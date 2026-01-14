*! Stata程序：Oster(2019)系数稳定性检验实现
*! 版本：1.0
*! 作者：马俊豪
*! 日期：2026年1月14日

*==========================================*
*                基础设置
*==========================================*

*----- 路径设置 -----*
global PP   "/Users/lmm/Documents/FE-马俊豪"  // 项目主目录
global path "$PP"    
global data "$path/data"                      // 数据存储路径

* 切换到数据目录
qui cd "$data"

*----- 图形设置 -----*
set scheme scientific                        // 选择图形模板


*==========================================*
*            案例复现1：Acheampong(2024)
*==========================================*

use "Acheampong-2024-EE-Oster-2019-omit-variable-test", clear

* Table 10: Oster(2019)遗漏变量偏误检验
* OLS结果与系数稳定性检验
eststo clear
eststo: regress lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi ///
                 lntrad lnurb FI $tlist, robust

psacalc delta FI, rmax(1)

coefstability lnco2kt FI,                 ///
    controls(lnrgdpc2 lnrenew lnfdi       ///
             lntrad lnurb lnrgdpc)        ///
    model(regress)                        ///
    modelopts(robust)                     ///
    delta(1) rmax(1)


*==========================================*
*            案例复现2：Cepni(2024)
*==========================================*

use "Cepni-2024-EE-xtabond2-DID-robust.dta", clear

* 声明面板数据结构
xtset GVKEY_num year

* 基准估计（OLS和Poisson）
reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1, ///
         absorb(GVKEY_num year)               ///
         vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 ///
         L.bm_w1 L.firm_size_w1 L.npm_w1     ///
         L.roa_w1 L.debt_at_w1 L.rd_sale_w1, ///
         absorb(GVKEY_num year)               ///
         vce(cluster GICIndustries)

* reghdfe模型的bootstrap检验
coefstability cost_of_equity_w1 L.ln_cc_expo_ew_w1, ///
    controls(L.bm_w1 L.firm_size_w1 L.npm_w1        ///
             L.roa_w1 L.debt_at_w1 L.rd_sale_w1)    ///
    model(reghdfe)                                  ///
    modelopts(absorb(GVKEY_num year))               ///
    cluster(GICIndustries)                          ///
    delta(1) rmax(-1)                               ///
    bootstrap reps(100) seed(12345)                 ///
    noisily


*==========================================*
*          其他用法示例
*==========================================*

* ----------- 示例1：基础用法 ----------- *
sysuse auto, clear

* 基础系数稳定性检验：
* - 因变量(Y)：price（车价）
* - 处理变量(X)：mpg（燃油效率）
* - 控制变量：weight（车重）、length（车长）
coefstability price mpg, controls(weight length)

* ----------- 示例2：手动设定参数 ----------- *
* δ=0.5：未观测变量相对已观测变量的选择强度为一半
* Rmax=0.8：理论最大R²设定为0.8
coefstability price mpg,                ///
    controls(weight length)             ///
    delta(0.5) rmax(0.8)

* ----------- 示例3：bootstrap标准误 ----------- *
coefstability price mpg,                ///
    controls(weight length)             ///
    bootstrap reps(500) seed(12345)

* ----------- 示例4：reghdfe模型 ----------- *
sysuse auto, clear

coefstability price mpg,                ///
    controls(weight length)             ///
    model(reghdfe)                      ///
    modelopts(absorb(rep78))

* ----------- 示例5：面板数据设置 ----------- *
webuse nlswork, clear
xtset idcode year

* ----------- 示例6：xtreg固定效应 ----------- *
coefstability ln_wage hours,            ///
    controls(age ttl_exp tenure         ///
             not_smsa south i.year)     ///
    model(xtreg)                        ///
    modelopts(fe)                       ///
    delta(1) rmax(1)                    ///
    bootstrap reps(100)                 ///
    seed(12345)

* ----------- 示例7：reghdfe双向固定效应 ----------- *
coefstability ln_wage hours,            ///
    controls(age ttl_exp tenure         ///
             not_smsa south)            ///
    model(reghdfe)                      ///
    modelopts(absorb(idcode year))      ///
    cluster(idcode)                     ///
    delta(0.8) rmax(-1)                 ///
    bootstrap reps(100) seed(12345)     ///
    noisily
