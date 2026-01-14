clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\Compustat-CRSP.xlsx", sheet("lx2wtrrvuuxexsqb") firstrow

rename StandardandPoorsIdentifier GVKEY

encode GVKEY, gen(GVKEY_num)

save compustat_balance_sheet_data, replace

clear all

use beta_all_years

encode GVKEY, gen(GVKEY_num)

duplicates tag GVKEY year, gen(dup_GVKEY)

drop if dup_GVKEY!=0

sort GVKEY_num year

xtset GVKEY_num year

merge 1:1 GVKEY year using compustat_balance_sheet_data

drop if _merge!=3
drop _merge

save beta_compustat_balance_sheet_matched_data, replace

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\firmquarter_score_2021Q4_Version_2022_Nov_22.xlsx", sheet("firmquarter_score_2021Q4_Versio") firstrow

drop isin cusip hqcountrycode

collapse (mean) cc_expo_ew-ph_sent_ew, by(year gvkey)

drop if gvkey==.

keep if year>=2010

sort gvkey year

xtset gvkey year

rename gvkey GVKEY_num

tostring GVKEY_num, generate(GVKEY)

save climate_exposure_index, replace

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

clear all

use beta_compustat_balance_sheet_matched_data

merge 1:1 GVKEY year using climate_exposure_index

keep if _merge==3
drop _merge

sort GVKEY_num year
xtset GVKEY_num year

encode GICIndustries, gen(industry_num)

save main_sample, replace



