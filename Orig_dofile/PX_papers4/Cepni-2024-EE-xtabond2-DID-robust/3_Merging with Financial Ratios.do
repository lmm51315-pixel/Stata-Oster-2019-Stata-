clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use financial_ratios

rename gvkey GVKEY

gen date_month=month(public_date)

keep if date_month==12

gen year=year(public_date)

drop if year==2022

encode GVKEY, gen(GVKEY_num)

sort GVKEY year

xtset GVKEY_num year

save financial_ratios_filtered, replace

clear all

use main_sample

merge 1:1 GVKEY year using financial_ratios_filtered

drop if _merge==2

drop if _merge==1

drop _merge

sort GVKEY year

xtset GVKEY_num year

save main_sample, replace

