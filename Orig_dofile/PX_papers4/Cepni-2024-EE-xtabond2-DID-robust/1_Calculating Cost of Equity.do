***Calculating cost of equity

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use firm_Stock_price

sort LPERMNO datadate

xtset LPERMNO datadate

gen day=day(datadate)

gen month=month(datadate)

gen year=year(datadate)

save firm_Stock_price, replace

/////////////////////////////////////////////////////////////////////////////////

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\SP500-US1M.xlsx", sheet("SP500-US1M") firstrow

save market_index_data, replace

clear all

use firm_Stock_price

merge m:1 day month year using market_index_data

drop if _merge!=3
drop _merge

sort LPERMNO datadate

xtset LPERMNO datadate 

drop if year==2009

save firm_Stock_price, replace

/////////////////////////////////////////////////////////////////////////////////

forval i=2010(1)2022 {
	
clear all

use firm_Stock_price

keep if year==`i'

bys LPERMNO: gen fake_time=_n

sort LPERMNO fake_time

xtset LPERMNO fake_time

gen stock_return=ln(prccd/L.prccd)

gen market_return=ln(Sp500/L.Sp500)

winsor2 stock_return, cuts(0.5 99.5) suffix(_w05)

winsor2 market_return, cuts(0.5 99.5) suffix(_w05)

save firm_Stock_price_`i', replace

statsby beta=_b[market_return], by(LPERMNO): regress stock_return market_return

gen year=`i'

save beta_`i', replace

}

clear all

use beta_2010

forval i=2011(1)2022 {
	
append using beta_`i'

}

sort LPERMNO year

xtset LPERMNO year

winsor2 beta, cuts(1 99) suffix(_w1)

save beta_all_years, replace

/////////////////////////////////////////////////////////////////////////////////

clear all

use firm_Stock_price

duplicates drop LPERMNO, force

keep GVKEY LPERMNO cusip firmid

save firm_identifiers, replace

clear all

use beta_all_years

merge m:1 LPERMNO using firm_identifiers

drop _merge

save beta_all_years, replace

/////////////////////////////////////////////////////////////////////////////////

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\Damodaran_Data.xlsx", sheet("Sheet1") firstrow

save damodaran_data, replace

clear all

use beta_all_years

merge m:1 year using damodaran_data

drop _merge

sort LPERMNO year

xtset LPERMNO year

gen cost_of_equity=t_bill + beta_w1 * erp

save beta_all_years, replace

clear all

