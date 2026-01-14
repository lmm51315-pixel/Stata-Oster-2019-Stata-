clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use main_sample

order GVKEY GVKEY_num year

sort GVKEY_num year

***Two way SE clustering industry and year

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster industry_num#year)

***SE clustering at firm level

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GVKEY_num)

***Firm stock beta as dependent variable

reghdfe beta_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Excluding Covid era (2020-2021)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if year<2020, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Additional controls (additional controls as P/E ratio, enterprise value multiple, cash/total liabilities ratio, capital expenditures ratio)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 L.pe_inc_w1 L.evm_w1 L.cash_lt_w1 L.capex_ratio_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Industry x year fixed effects instead of year fixed effects

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year#industry_num) vce(cluster GICIndustries)

***Excluding financial firms

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if GICSectors!="60", absorb(GVKEY_num year) vce(cluster GICIndustries)

***Contemporaneous value of climate change exposure index

reghdfe cost_of_equity_w1 ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Excluding observations of climate change exposure index with zero values

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if cc_expo_ew!=0, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Placebo test: cost of debt as dependent variable

reghdfe int_totdebt_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Firms with at least 5 years of observations

bysort GVKEY: egen counter=count(AssetsTotal)

sort GVKEY_num year

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if counter>=5, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if counter>=10, absorb(GVKEY_num year) vce(cluster GICIndustries)

***Controlling for firm-level E-score

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\ESG Score.xlsx", sheet("Sheet1") firstrow

drop if year<2010

tostring GVKEY, generate(GVKEY_string)

drop GVKEY

rename GVKEY_string GVKEY

duplicates drop GVKEY year, force

save esg_data, replace

clear all

use main_sample

merge 1:1 year GVKEY using esg_data

drop if _merge==2
drop _merge

sort GVKEY_num year

sum EScore, detail

replace EScore=0 if EScore==.

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 L.EScore, absorb(GVKEY_num year) vce(cluster GICIndustries)

clear all


***outreg2 using robustness_checks.xls, append adjr2
