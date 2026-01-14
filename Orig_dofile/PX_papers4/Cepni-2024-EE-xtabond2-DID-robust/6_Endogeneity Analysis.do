clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use main_sample

order GVKEY GVKEY_num year

sort GVKEY_num year

save main_sample, replace

******************************************************************************************************************************************

***Entropy balancing

sum ln_cc_expo_ew_w1, detail

gen high_exposure=(ln_cc_expo_ew_w1>=.0002674)

ebalance high_exposure bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1, targets(1) generate(weights_entropy)

svyset [pweight=weights_entropy]

svy: reg cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 i.GVKEY_num i.year

outreg2 using entropy_balancing.xls, append

save main_sample, replace

******************************************************************************************************************************************

***IV: industry average climate change exposure index (GICIndustries) (this did not work)

clear all

use main_sample

bysort GICIndustries year: egen industry_average_exposure=mean(ln_cc_expo_ew_w1)

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen L_industry_average_exposure=L.industry_average_exposure

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_industry_average_exposure), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: sector average climate change exposure index (GICSectors) (this worked)

bysort GICSectors year: egen sector_average_exposure=mean(ln_cc_expo_ew_w1)

sort GVKEY_num year

gen L_sector_average_exposure=L.sector_average_exposure

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_sector_average_exposure), cluster(GICIndustries) fe first

outreg2 using iv_regressions_sector_average.xls, append

******************************************************************************************************************************************

***IV: democrat/republican presidential voting orientation (data from "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/42MVDX") (this did not work)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\1976-2020-president.xlsx", sheet("1976-2020-president") firstrow

keep year state_po candidatevotes totalvotes party_simplified

rename state_po state
rename party_simplified party

gen democrat_percentage=candidatevotes/totalvotes

keep if party=="DEMOCRAT"

keep year state democrat_percentage

keep if year>2007

encode state, gen(state_num)

gen fake=_n

drop if fake==106
drop if fake==125

drop fake

xtset state_num year

tsfill

tsappend, add(1)

carryforward democrat_percentage, gen(democrat_percentage_c)

carryforward state, gen(state_c)

drop state democrat_percentage

rename state_c state
rename democrat_percentage_c democrat_percentage

save state_democrat_leniency, replace

clear all

use main_sample

merge m:1 state year using state_democrat_leniency

drop if _merge==2
drop _merge

sum democrat_percentage, detail

replace democrat_percentage=.5501107 if democrat_percentage==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

gen L_democrat_percentage=L.democrat_percentage

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_democrat_percentage), cluster(GICIndustries) fe first

gen dummy_democrat=(democrat_percentage>0.50)

gen L_dummy_democrat=L.dummy_democrat

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_dummy_democrat), cluster(GICIndustries) fe first

sum democrat_percentage, detail

gen upper_democrat=(democrat_percentage>.6023896)

gen L_upper_democrat=L.upper_democrat

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_upper_democrat), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: democrat/republican US Senate voting orientation (this did not work)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\1976-2020-senate.xlsx", sheet("1976-2020-senate") firstrow

keep year state_po candidatevotes totalvotes party_simplified

keep if year > 2007

rename state_po state
rename party_simplified party

gen democrat_percentage=candidatevotes/totalvotes

keep if party=="DEMOCRAT"

duplicates tag year state, gen(dup_state_year)

drop dup_state_year

duplicates drop state year, force

encode state, gen(state_num)

sort state_num year

xtset state_num year

tsfill

tsappend, add(3)

carryforward democrat_percentage, gen(democrat_percentage_c)

carryforward state, gen(state_c)

drop state democrat_percentage

rename state_c state
rename democrat_percentage_c democrat_percentage

keep if year>=2010

keep year state democrat_percentage

save state_democrat_leniency, replace

clear all

use main_sample

merge m:1 year state using state_democrat_leniency

drop if _merge==2
drop _merge

sum democrat_percentage, detail

replace democrat_percentage=`r(p50)' if missing(democrat_percentage)==1

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

gen L_democrat_percentage=L.democrat_percentage

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_democrat_percentage), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: state-level climate attention index (this did not work)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\NewsCount-ClimateChange.xlsx", sheet("Sheet2-Tableau") firstrow

rename Year year
drop State_Name

sum NewsCount, detail

gen news_count_normalized=(NewsCount - `r(p50)')/`r(sd)'

gen news_count_divided=NewsCount/1000

save climate_attention_index, replace

clear all

use main_sample

merge m:1 year state using climate_attention_index

drop if _merge==2

sum news_count_normalized, detail

replace news_count_normalized=`r(p50)' if news_count_normalized==.

sum news_count_divided, detail

replace news_count_divided=`r(p50)' if news_count_divided==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

gen L_news_count_normalized=L.news_count_normalized

gen L_news_count_divided=L.news_count_divided

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_news_count_normalized), cluster(GICIndustries) fe first

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_news_count_divided), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: state-level abnormal temperature (this did not work) (https://www.ncei.noaa.gov/access/monitoring/climate-at-a-glance/statewide/time-series/1/tavg/ann/4/2010-2021?base_prd=true&begbaseyear=1901&endbaseyear=2023)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Abnormal Temperature Data.xlsx", sheet("Sheet1") firstrow

drop state_name temp

save state_abnormal_temperature, replace

clear all

use main_sample

merge m:1 year state using state_abnormal_temperature

drop if _merge==2
drop _merge

sum anomaly, detail

replace anomaly=`r(p50)' if anomaly==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

gen L_anomaly=L.anomaly

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_anomaly), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: per-capita energy related CO2 emissions by state (these did not work) (https://www.eia.gov/environment/emissions/state/)
***IV: energy intensity by state
***IV: carbon intensity by state

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Emission Data.xlsx", sheet("Sheet1") firstrow

drop G state_name

save state_emission_data, replace

clear all

use main_sample

merge m:1 year state using state_emission_data

drop if _merge==2
drop _merge

sum percapita_co_emissions, detail

replace percapita_co_emissions=`r(p50)' if percapita_co_emissions==.

sum energy_intensity, detail

replace energy_intensity=`r(p50)' if energy_intensity==.

sum carbon_intensity, detail

replace carbon_intensity=`r(p50)' if carbon_intensity==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

gen L_percapita_co_emissions=L.percapita_co_emissions

gen L_energy_intensity=L.energy_intensity

gen L_carbon_intensity=L.carbon_intensity

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_percapita_co_emissions), cluster(GICIndustries) fe first

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_energy_intensity), cluster(GICIndustries) fe first

xtivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=L_carbon_intensity), cluster(GICIndustries) fe first

******************************************************************************************************************************************

***IV: state-level religiosity (this did not work) (https://www.pewresearch.org/short-reads/2016/02/29/how-religious-is-your-state/?state=alabama)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Religiosity Data.xlsx", sheet("Sheet1") firstrow

drop state_name

save state_level_religiosity, replace

clear all

use main_sample

merge m:1 state using state_level_religiosity

drop if _merge==2
drop _merge

sum religiosity, detail

replace religiosity=`r(p50)' if religiosity==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

ivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=religiosity), cluster(GICIndustries) first

******************************************************************************************************************************************

***IV: state-level extreme weather events (this did not work) (https://feu-us.org/our-work/case-for-climate-action-us/maps-events-by-state/)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Extreme Weather Events Data.xlsx", sheet("Sheet1") firstrow

drop state_name

save state_level_extreme_weather_events, replace

clear all

use main_sample

merge m:1 state using state_level_extreme_weather_events

drop if _merge==2
drop _merge

sum extreme_events, detail

replace extreme_events=`r(p50)' if extreme_events==.

sort GVKEY_num year

foreach var of varlist bm_w1 firm_size_w1 npm_w1 roa_w1 debt_at_w1 rd_sale_w1 {
	
gen L_`var'=L.`var'
	
}

gen L_ln_cc_expo_ew_w1=L.ln_cc_expo_ew_w1

gen abc=L_ln_cc_expo_ew_w1

tab year, gen(year_)

ivreg2 cost_of_equity_w1 L_bm_w1 L_firm_size_w1 L_npm_w1 L_roa_w1 L_debt_at_w1 L_rd_sale_w1 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11 year_12 (abc=extreme_events), cluster(GICIndustries) first

******************************************************************************************************************************************

***DiD analysis by using the withdrawal of US from Paris Agreement in 2017

clear all

use main_sample

keep if year==2017

sum ln_cc_expo_ew_w1, detail

gen cc_dummy=( ln_cc_expo_ew_w1>0.0002507)

keep GVKEY cc_dummy

save xyz, replace

clear all

use main_sample

merge m:1 GVKEY using xyz

gen Paris_withdrawal=.

replace Paris_withdrawal=0 if inlist(year,2015,2016,2017)

replace Paris_withdrawal=1 if inlist(year,2018,2019,2020)

gen Paris_withdrawal_cc_dummy= Paris_withdrawal*cc_dummy

sort GVKEY_num year

reg cost_of_equity_w1 Paris_withdrawal_cc_dummy Paris_withdrawal cc_dummy L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if inlist(year,2015,2016,2017,2018,2019,2020), vce(cluster GICIndustries)

reg cost_of_equity_w1 Paris_withdrawal_cc_dummy Paris_withdrawal cc_dummy L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if inlist(year,2016,2017,2018,2019), vce(cluster GICIndustries)

gen placebo_w=.

replace placebo_w=0 if inlist(year,2010,2011,2012)

replace placebo_w=1 if inlist(year,2013,2014,2015)

gen placebo_w_cc_dummy=placebo_w*cc_dummy

reg cost_of_equity_w1 placebo_w_cc_dummy placebo_w cc_dummy L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if inlist(year,2010,2011,2012,2013,2014,2015), vce(cluster GICIndustries)

******************************************************************************************************************************************

***System GMM estimation

xtabond2 cost_of_equity_w1 L.cost_of_equity_w1 L2.cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 i.year, gmm(L.cost_of_equity_w1 L2.cost_of_equity_w1 L.ln_cc_expo_ew_w1, lag(2 3)) iv(L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1) cluster(GICIndustries) artests(3)




