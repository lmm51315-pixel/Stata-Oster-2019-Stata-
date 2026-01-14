*! version 1.5.0 系数稳定性检验 (基于 Oster 2019)
*! 日期: 2026年1月14日 
*! 作者: 马俊豪

cap program drop coefstability
cap program drop _build_cmd
cap program drop _get_r2
cap program drop _coefstar_adv

// ==================== 辅助函数1: 构建命令 ====================
program define _build_cmd
    args model depvar treatvar controls modelopts cluster touse
    
    // 基础命令
    local base_cmd "`model' `depvar' `treatvar' `controls' if `touse'"
    local opts ""
    
    // 处理模型选项
    if `"`modelopts'"' != "" {
        local opts `"`modelopts'"'
    }
    
    // 处理聚类
    if "`cluster'" != "" {
        // 防止重复添加 vce
        if strpos("`opts'", "vce(") == 0 {
            local opts "`opts' vce(cluster `cluster')"
        }
    }
    
    // 组合最终命令
    if `"`opts'"' != "" {
        local cmd "`base_cmd', `opts'"
    }
    else {
        local cmd "`base_cmd'"
    }
    
    c_local cmd_full `"`cmd'"'
end

// ==================== 辅助函数2: 获取R² ====================
program define _get_r2
    args model
    local r2 = .
    // 面板模型优先取组内 R2
    if "`model'" == "xtreg" | "`model'" == "reghdfe" {
        capture local r2 = e(r2_w)
        if missing(`r2') capture local r2 = e(r2_within)
    }
    // 通用 R2
    if missing(`r2') capture local r2 = e(r2)
    if missing(`r2') local r2 = 0
    c_local r2_value `r2'
end

// ==================== 辅助程序: 自助法计算核心 ====================
program define _coefstar_adv, rclass
    // 接收参数：变量名均为已转换的静态变量名
    args depvar treatvar controls delta rmax model modelopts cluster sampleflag
    
    tempname b_full r2_full b_base r2_base
    local clean_modelopts `"`modelopts'"'
    
    // 清理 bootstrap 中不需要的选项（防止嵌套 vce 报错）
    if inlist("`model'", "reghdfe", "ivreghdfe") {
        local clean_modelopts : subinstr local clean_modelopts "vce(" "", all
        local clean_modelopts : subinstr local clean_modelopts "cluster(" "", all
        // 保留 absorb
    }
    else if "`model'" == "xtreg" {
        local clean_modelopts : subinstr local clean_modelopts "vce(" "", all
        local clean_modelopts : subinstr local clean_modelopts "cluster(" "", all
    }
    
    // 1. 估计完整模型 (Full Model)
    _build_cmd "`model'" "`depvar'" "`treatvar'" "`controls'" ///
               "`clean_modelopts'" "" "`sampleflag'"
    local cmd_run `"`cmd_full'"'
    
    capture noisily `cmd_run'
    local rc_full = _rc
    
    if `rc_full' == 0 {
        // 获取系数
        capture scalar `b_full' = _b[`treatvar']
        local treat_found = (_rc == 0)
        
        if `treat_found' {
            _get_r2 "`model'"
            scalar `r2_full' = `r2_value'
            
            // 获取实际样本
            tempvar esample
            gen byte `esample' = e(sample)
            qui count if `esample'
            local sample_count = r(N)
            
            if `sample_count' > 3 {
                // 2. 估计基准模型 (Base Model, 无控制变量)
                _build_cmd "`model'" "`depvar'" "`treatvar'" "" ///
                           "`clean_modelopts'" "" "`esample'"
                local cmd_base `"`cmd_full'"'
                
                capture noisily `cmd_base'
                local rc_base = _rc
                
                if `rc_base' == 0 {
                    capture scalar `b_base' = _b[`treatvar']
                    if _rc == 0 {
                        _get_r2 "`model'"
                        scalar `r2_base' = `r2_value'
                        
                        // Oster (2019) 公式计算 β*
                        // 仅当 R2_full > R2_base 且 Rmax > R2_full 时计算，否则无解
                        if !missing(`r2_full') & !missing(`r2_base') ///
                           & `r2_full' > `r2_base' & `rmax' > `r2_full' {
                            local bstar = `b_full' - `delta' * (`b_base' - `b_full') * ///
                                          (`rmax' - `r2_full') / (`r2_full' - `r2_base')
                            return scalar bstar = `bstar'
                        }
                        else {
                            return scalar bstar = .
                        }
                    }
                    else {
                        return scalar bstar = .
                    }
                }
                else {
                    return scalar bstar = .
                }
            }
            else {
                return scalar bstar = .
            }
        }
        else {
            return scalar bstar = .
        }
    }
    else {
        return scalar bstar = .
    }
end

// ==================== 主程序入口 ====================
program define coefstability, rclass sortpreserve
    version 17.0
    
    // ==================== 1. 语法解析 ====================
    syntax varlist(min=2 max=2 ts) [if] [in] [, ///
        CONTrols(string) ///   控制变量列表（支持 i.year, L.x 等）
        DELta(real 1) ///      假设不可观测选择与可观测选择的比例 (默认 1)
        RMAX(real -1) ///      最大理论 R2 (默认 -1 表示自动计算 1.3*R2)
        MODEL(string) ///      估计模型 (regress, xtreg, reghdfe 等)
        MODELopts(string asis) /// 模型选项 (如 fe, absorb(...) 等)
        BOOTstrap ///          是否进行 Bootstrap 推断
        REPS(integer 1000) /// Bootstrap 次数
        SEED(integer 12345) /// 随机种子
        CLUSTer(varname) ///   聚类变量
        Level(cilevel) ///     置信区间水平
        NOIsily ///            显示详细回归结果
        SAVing(string) ///     保存结果到文件
    ]
    
    tokenize `varlist'
    local depvar `1'
    local treatvar `2'
    
    if "`model'" == "" local model "regress"
    
    marksample touse
    
    // ==================== 2. 输入验证 ====================
    if "`controls'" == "" {
        di as error "{bf:错误}: 必须通过 {bf:controls()} 选项指定控制变量。"
        exit 198
    }
    
    // 检查 treatvar 是否在 controls 中 (简单字符串检查)
    local conflict : list treatvar & controls
    if "`conflict'" != "" {
        di as error "{bf:错误}: 处理变量 {bf:`treatvar'} 不能同时出现在控制变量列表中。"
        exit 198
    }
    
    if `delta' < 0 {
        di as error "{bf:错误}: delta 参数必须为非负数。"
        exit 198
    }
    
    if `rmax' != -1 & `rmax' <= 0 {
        di as error "{bf:错误}: Rmax 参数必须为正数。"
        exit 198
    }
    
    // 检查 tsset：如果变量名包含时间算子，必须预先 tsset
    capture tsset
    local ts_rc = _rc
    if strpos("`treatvar' `controls'", "L.") | strpos("`treatvar' `controls'", "F.") | strpos("`treatvar' `controls'", "D.") {
        if `ts_rc' != 0 {
             di as error "{bf:错误}: 检测到时间序列算子，但未设定时间变量。请先运行 {stata tsset}。"
             exit 111
        }
    }

    if "`noisily'" != "" di as text _n "{hline}" _n "正在计算系数稳定性检验..."
    
    // ==================== 3. 主样本点估计 (Point Estimate) ====================
    tempfile bootfile
    tempvar sampleflag
    
    // 3.1 估计完整模型
    _build_cmd "`model'" "`depvar'" "`treatvar'" "`controls'" ///
               "`modelopts'" "`cluster'" "`touse'"
    local cmd_full `"`cmd_full'"'
    
    if "`noisily'" != "" di as text "完整模型命令: `cmd_full'"
    
    capture `cmd_full'
    local rc_main = _rc
    
    if `rc_main' != 0 {
        di as error "{bf:错误}: 完整模型估计失败 (错误代码: `rc_main')。"
        if `rc_main' == 2000 di as error "原因: 没有可用的观测值。"
        exit `rc_main'
    }
    
    capture local b_full = _b[`treatvar']
    if _rc {
        di as error "{bf:错误}: 无法找到变量 {bf:`treatvar'} 的系数。请确认模型输出中包含该变量。"
        exit 111
    }
    local se_full = _se[`treatvar']
    
    _get_r2 "`model'"
    local r2_full = `r2_value'
    
    // 3.2 锁定样本 (e(sample))
    tempvar esample_main
    gen byte `esample_main' = e(sample)
    
    // 更新 touse，确保 bootstrap 使用完全相同的样本
    qui replace `touse' = 0 if `esample_main' == 0
    qui gen byte `sampleflag' = `touse'
    
    local N_full = e(N)
    
    // Rmax 自动计算
    if `rmax' == -1 {
        local rmax = 1.3 * `r2_full'
        if `rmax' > 1 local rmax = 1
        if "`noisily'" != "" di as text "注意: 自动设定 Rmax = Min(1, 1.3 * R2_full) = " %6.4f `rmax'
    }
    
    local df_full = e(df_r)
    if missing(`df_full') local df_full = `N_full' - 1
    
    // 3.3 估计基准模型
    _build_cmd "`model'" "`depvar'" "`treatvar'" "" ///
               "`modelopts'" "`cluster'" "`esample_main'"
    local cmd_base `"`cmd_full'"'
    
    if "`noisily'" != "" di as text "基准模型命令: `cmd_base'"
    
    capture `cmd_base'
    if _rc {
        di as error "{bf:错误}: 基准模型估计失败。"
        exit _rc
    }
    
    capture local b_base = _b[`treatvar']
    if _rc exit 111
    
    local se_base = _se[`treatvar']
    local df_base = e(df_r)
    if missing(`df_base') local df_base = e(N) - 1
    
    _get_r2 "`model'"
    local r2_base = `r2_value'
    
    // 3.4 计算点估计结果 (Beta*)
    local r2_diff = `r2_full' - `r2_base'
    local beta_star = .
    
    if `r2_diff' > 0 & `rmax' > `r2_full' {
        local beta_star = `b_full' - `delta' * (`b_base' - `b_full') * ///
                          (`rmax' - `r2_full') / (`r2_full' - `r2_base')
    }
    
    // 计算临界 Delta* (使 Beta* = 0 的 Delta)
    local delta_star = .
    if `r2_diff' > 0 & `b_full' != 0 {
        local term = (`b_base' - `b_full') * (`rmax' - `r2_full') / (`r2_diff')
        if abs(`term') > 1e-8 local delta_star = `b_full' / `term'
    }
    
    // ==================== 4. 自助法标准误 (核心修复版) ====================
    local se_star = .
    local ci_lower = .
    local ci_upper = .
    
    if "`bootstrap'" != "" {
        if "`noisily'" != "" di as text _n "开始 Bootstrap (重复 `reps' 次)..."
        
        // Preserve 数据以进行破坏性操作（生成静态变量、清除 tsset）
        preserve
        
        // 4.1 处理 Treat Var (静态化)
        // 尝试生成新变量，如果是 i.treat 等复杂形式则使用 fvrevar
        local bs_treatvar "`treatvar'"
        local bs_treat_clean "_BS_TREAT"
        capture drop `bs_treat_clean'
        capture qui gen double `bs_treat_clean' = `treatvar' if `touse'
        if _rc == 0 {
            local bs_treatvar "`bs_treat_clean'"
        }
        else {
            // 如果 gen 失败 (如 i.x)，使用 fvrevar
            capture fvrevar `treatvar', stub(_BS_TREAT_X)
            if _rc == 0 {
                // 注意：Oster 方法通常针对单个核心变量。
                // 如果 fvrevar 返回多个变量，这里只取第一个，或者根据具体逻辑调整。
                // 假设 treatvar 是单个数值变量。
                local bs_treatvar "`r(varlist)'"
            }
        }

        // 4.2 处理 Controls
        // 使用 fvrevar 自动解析 i.year, L.x, c.x#c.y 等，生成 _BS_CTRL1, _BS_CTRL2...
        local bs_controls ""
        capture fvrevar `controls', stub(_BS_CTRL_)
        if _rc == 0 {
            local bs_controls `r(varlist)'
        }
        else {
             di as error "{bf:错误}: 无法解析控制变量列表。请检查变量名或语法。"
             restore // 提前恢复
             exit 198
        }
        
        // 4.3 处理 TSSET (xtreg 核心修复)
        // 记录当前的 panelvar (如 firm_id)
        local temp_panelvar ""
        capture qui tsset
        if _rc == 0 {
            local temp_panelvar "`r(panelvar)'"
        }
        
        // 清除 tsset (防止 bootstrap 内部因找不到时间变量而对静态化后的变量报错)
        capture tsset, clear
        
        // 如果是 xtreg，必须恢复 panelvar，否则 xtreg 报错 "panel variable not set"
        if "`model'" == "xtreg" & "`temp_panelvar'" != "" {
            quietly xtset `temp_panelvar'
        }
        
        // 4.4 设置 Bootstrap 选项
        local bs_options ""
        // 对于面板/固定效应模型，通常需要按簇抽样或分层抽样
        if inlist("`model'", "reghdfe", "ivreghdfe", "xtreg") {
            local bs_options "strata(`cluster')"
        }
        local bs_noi = cond("`noisily'"!="", "noisily", "")
        if "`cluster'" != "" & !inlist("`model'", "reghdfe", "ivreghdfe") {
            local bs_clu = "cluster(`cluster')"
        }
        else {
            local bs_clu = ""
        }
        
        set seed `seed'
        tempvar bootvar
        
        // 4.5 执行 Bootstrap
        // 注意：传入的是静态变量名列表 `bs_treatvar` 和 `bs_controls`
        capture {
            bootstrap `bootvar' = r(bstar), ///
                reps(`reps') `bs_clu' `bs_options' level(`level') ///
                saving(`bootfile', replace) `bs_noi' : ///
                _coefstar_adv `depvar' `bs_treatvar' `"`bs_controls'"' ///
                `delta' `rmax' "`model'" `"`modelopts'"' "`cluster'" `sampleflag'
        }
        
        local bs_rc = _rc
        
        restore // 恢复原始数据
        
        // 4.6 处理 Bootstrap 结果
        if `bs_rc' == 0 {
            preserve 
            use `bootfile', clear
            qui count if !missing(`bootvar')
            local valid_reps = r(N)
            if `valid_reps' > 0 {
                qui sum `bootvar', detail
                local se_star = r(sd)
                if `valid_reps' >= 10 {
                    _pctile `bootvar', p(`= (100-`level')/2' `= 100 - (100-`level')/2')
                    local ci_lower = r(r1)
                    local ci_upper = r(r2)
                }
            }
            restore
        }
        else {
            di as error "{bf:警告}: 自助法执行失败 (错误码: `bs_rc')."
            if `bs_rc' == 198 di as error "提示: 可能是变量冲突。"
            if `bs_rc' == 459 & "`model'" == "xtreg" di as error "提示: 面板设定可能丢失。"
        }
    }
    
    // ==================== 5. 结果输出 ====================
    // 计算调整 R2 用于显示
    quietly `cmd_full'
    local r2_adj_full = e(r2_a)
    if missing(`r2_adj_full') local r2_adj_full = .
    
    quietly `cmd_base'
    local r2_adj_base = e(r2_a)
    if missing(`r2_adj_base') local r2_adj_base = .
    
    di as text _n "{hline 82}"
    di as text "{bf: 系数稳定性检验 (Oster, 2019) }"
    di as text "{hline 82}"
    di as text " 因变量(Y): {bf:`depvar'}" _col(45) "处理变量(X): {bf:`treatvar'}"
    di as text " 模型类型: {bf:`model'}" _col(45) "样本量(N): {bf:`N_full'}"
    if "`modelopts'" != "" di as text " 模型选项: {bf:`modelopts'}"
    if "`cluster'" != "" di as text " 聚类标准误: {bf:`cluster'}"
    di as text "{hline 82}"
    di as text _col(3) "{bf:模型}" ///
             _col(16) "{bf:系数}" ///
             _col(28) "{bf:P值}" ///
             _col(38) "{bf:R²}" ///
             _col(47) "{bf:调整R²}" ///
             _col(57) "{bf:`level'% 置信区间}"
    di as text "{hline 82}"
    
    // 计算 Full Model CI
    local ci_low_full = `b_full' - invttail(`df_full', (100-`level')/200) * `se_full'
    local ci_high_full = `b_full' + invttail(`df_full', (100-`level')/200) * `se_full'
    
    local p_full = .
    if !missing(`b_full') & !missing(`se_full') & `se_full' > 0 {
        local t_val_full = `b_full'/`se_full'
        local p_full = 2*ttail(`df_full', abs(`t_val_full'))
    }
    
    // 计算 Base Model CI
    local ci_low_base = `b_base' - invttail(`df_base', (100-`level')/200) * `se_base'
    local ci_high_base = `b_base' + invttail(`df_base', (100-`level')/200) * `se_base'
    
    local p_base = .
    if !missing(`b_base') & !missing(`se_base') & `se_base' > 0 {
        local t_val_base = `b_base'/`se_base'
        local p_base = 2*ttail(`df_base', abs(`t_val_base'))
    }
    
    // 格式化输出
    local s_r2_adj_full : display %6.3f `r2_adj_full'
    local s_p_full : display %6.3f `p_full'
    local s_r2_adj_base : display %6.3f `r2_adj_base'
    local s_p_base : display %6.3f `p_base'
    
    if missing(`r2_adj_full') local s_r2_adj_full " - "
    if missing(`p_full') local s_p_full " - "
    if missing(`r2_adj_base') local s_r2_adj_base " - "
    if missing(`p_base') local s_p_base " - "
    
    di as text _col(3) "含控制变量" ///
       _col(15) as result %9.4f `b_full' ///
       _col(27) as result "`s_p_full'" ///
       _col(37) as result %6.3f `r2_full' ///
       _col(46) as result "`s_r2_adj_full'" ///
       _col(56) as result "[ " %8.3f `ci_low_full' as text " , " ///
                  as result %8.3f `ci_high_full' as text " ]"
    
    di as text _col(3) "基准模型" ///
       _col(15) as result %9.4f `b_base' ///
       _col(27) as result "`s_p_base'" ///
       _col(37) as result %6.3f `r2_base' ///
       _col(46) as result "`s_r2_adj_base'" ///
       _col(56) as result "[ " %8.3f `ci_low_base' as text " , " ///
                  as result %8.3f `ci_high_base' as text " ]"
    
    di as text "{hline 82}"
    
    // 输出 β*
    if !missing(`beta_star') {
        if "`bootstrap'" != "" & !missing(`se_star') {
             local p_star = .
             if `se_star' > 0 {
                 local z_star = `beta_star'/`se_star'
                 local p_star = 2*(1-normal(abs(`z_star')))
             }
             if !missing(`p_star') local s_p_star : display %6.3f `p_star'
             else local s_p_star " - "
             
             di as text _col(3) "调整系数(β*)" ///
                _col(15) as result %9.4f `beta_star' ///
                _col(27) as result "`s_p_star'" ///
                _col(37) as result " - " ///
                _col(46) as result " - " ///
                _col(56) as result "[ " %8.3f `ci_lower' as text " , " ///
                           as result %8.3f `ci_upper' as text " ]"
        }
        else {
             di as text _col(3) "调整系数(β*)" ///
                _col(15) as result %9.4f `beta_star' ///
                _col(27) as result " - " ///
                _col(37) as result " - " ///
                _col(46) as result " - " ///
                _col(56) as result " - "
        }
    }
    else {
        di as text _col(3) "调整系数(β*)" _col(15) as result " - "
    }
    di as text "{hline 82}"
    
    di as text ""
    di as text "{bf:参数设定:} δ = {bf:`delta'}, Rmax = {bf:`rmax'}"
    di as text "{bf:稳健性分析:}"
    
    if !missing(`delta_star') {
        if `delta_star' < 0 {
             di as result " ✓ 结果高度稳健 (δ* < 0)"
        }
        else {
             di as text " 临界δ* = " %6.3f `delta_star'
             if `delta_star' > 1 di as result " ✓ 结果稳健 (δ* > 1)"
             else if `delta_star' > 0.5 di as result " ~ 结果中等稳健 (0.5 < δ* < 1)"
             else di as error " ⚠ 结果敏感 (δ* < 0.5)"
        }
    }
    di as text "{hline 82}"
    
    // 保存结果
    if `"`saving'"' != "" {
        preserve
        clear
        set obs 1
        gen depvar = "`depvar'"
        gen treatvar = "`treatvar'"
        gen b_full = `b_full'
        gen b_base = `b_base'
        gen r2_full = `r2_full'
        gen r2_base = `r2_base'
        gen rmax = `rmax'
        gen delta = `delta'
        gen beta_star = `beta_star'
        gen delta_star = `delta_star'
        if "`bootstrap'" != "" {
            gen se_star = `se_star'
            gen ci_lo = `ci_lower'
            gen ci_hi = `ci_upper'
        }
        save `"`saving'"', replace
        restore
    }
    
    return scalar delta_star = `delta_star'
    return scalar beta_star = `beta_star'
end
