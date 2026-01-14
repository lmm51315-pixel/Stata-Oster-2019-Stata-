clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\firm_adress.xlsx", sheet("Sheet2") firstrow

duplicates drop GVKEY year, force

save state_headquarters_data, replace

clear all

use main_sample

merge 1:1 GVKEY year using state_headquarters_data

keep if _merge==3

drop _merge

save main_sample, replace

