clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use main_sample

order GVKEY GVKEY_num year

sort GVKEY_num year

***Generating main dependent independent variables

winsor2 cost_of_equity, cuts(1 99) suffix(_w1)

foreach var of varlist cc_expo_ew-ph_sent_ew {
	
gen ln_`var'=ln(1+`var')

winsor2 ln_`var', cuts(1 99) suffix(_w1)

}

***Generating potential other control variables

foreach var of varlist CAPEI-divyield {
	
winsor2 `var', cuts(1 99) suffix(_w1)
	
}

gen firm_size=ln(AssetsTotal)

winsor2 firm_size, cuts(1 99) suffix(_w1)

save main_sample, replace

***Baseline estimations (OLS and Poisson)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using baseline_results.xls, append adjr2

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using baseline_results.xls, append adjr2

ppmlhdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using baseline_results.xls, append

ppmlhdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using baseline_results.xls, append

***Sub-components of climate change exposure index

reghdfe cost_of_equity_w1 L.ln_op_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append adjr2

reghdfe cost_of_equity_w1 L.ln_rg_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append adjr2

reghdfe cost_of_equity_w1 L.ln_ph_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append adjr2

reghdfe cost_of_equity_w1 L.ln_op_expo_ew_w1 L.ln_rg_expo_ew_w1 L.ln_ph_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append adjr2

///

ppmlhdfe cost_of_equity_w1 L.ln_op_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append

ppmlhdfe cost_of_equity_w1 L.ln_rg_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append 

ppmlhdfe cost_of_equity_w1 L.ln_ph_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append

ppmlhdfe cost_of_equity_w1 L.ln_op_expo_ew_w1 L.ln_rg_expo_ew_w1 L.ln_ph_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

outreg2 using subcomponents.xls, append

