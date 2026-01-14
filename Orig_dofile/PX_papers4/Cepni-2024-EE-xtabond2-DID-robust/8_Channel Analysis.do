clear all

cd "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity"

use main_sample

order GVKEY GVKEY_num year

sort GVKEY_num year

***Democrat/republican presidential voting orientation (data from "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/42MVDX")

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

replace democrat_percentage=`r(p50)' if democrat_percentage==.

sort GVKEY_num year

gen interaction=(L.ln_cc_expo_ew_w1)*democrat_percentage

gen dummy=0

sum democrat_percentage, detail

replace dummy=(democrat_percentage>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

gen dummy_alt=0

sum democrat_percentage, detail

replace dummy_alt=1 if democrat_percentage>=`r(p75)'

replace dummy_alt=. if democrat_percentage>=`r(p25)' & democrat_percentage<=`r(p75)'

gen dummy_alt_interaction=(L.ln_cc_expo_ew_w1)*dummy_alt

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 democrat_percentage interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_alt dummy_alt_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen democrat_percentage_ave=mean(democrat_percentage)

gen dummy_overall=0

sum democrat_percentage_ave, detail

sort GVKEY_num year

replace dummy_overall=(democrat_percentage_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum democrat_percentage, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if democrat_percentage>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum democrat_percentage, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if democrat_percentage<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**************************************************************************************************************************************************************************************************

***Democrat/republican US Senate voting orientation

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

replace democrat_percentage=`r(p50)' if democrat_percentage==.

sort GVKEY_num year

gen interaction=(L.ln_cc_expo_ew_w1)*democrat_percentage

gen dummy=0

sum democrat_percentage, detail

replace dummy=(democrat_percentage>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 democrat_percentage interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen democrat_percentage_ave=mean(democrat_percentage)

gen dummy_overall=0

sum democrat_percentage_ave, detail

sort GVKEY_num year

replace dummy_overall=(democrat_percentage_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum democrat_percentage, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if democrat_percentage>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum democrat_percentage, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if democrat_percentage<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**************************************************************************************************************************************************************************************************

***State-level climate attention index

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

drop _merge

sum news_count_normalized, detail

replace news_count_normalized=`r(p50)' if news_count_normalized==.

sum news_count_divided, detail

replace news_count_divided=`r(p50)' if news_count_divided==.

sort GVKEY_num year

gen interaction_1=(L.ln_cc_expo_ew_w1)*news_count_normalized
gen interaction_2=(L.ln_cc_expo_ew_w1)*news_count_divided

gen dummy_1=0

sum news_count_normalized, detail

replace dummy_1=(news_count_normalized>=`r(p50)')

gen dummy_1_interaction=(L.ln_cc_expo_ew_w1)*dummy_1

gen dummy_2=0

sum news_count_divided, detail

replace dummy_2=(news_count_divided>=`r(p50)')

gen dummy_2_interaction=(L.ln_cc_expo_ew_w1)*dummy_2

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 interaction_1 news_count_normalized L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 interaction_2 news_count_divided L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_1_interaction dummy_1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_2_interaction dummy_2 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen news_count_divided_ave=mean(news_count_divided)

gen dummy_overall=0

sum news_count_divided_ave, detail

sort GVKEY_num year

replace dummy_overall=(news_count_divided_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum news_count_divided, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if news_count_divided>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum news_count_divided, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if news_count_divided<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**************************************************************************************************************************************************************************************************

***State-level abnormal temperature (https://www.ncei.noaa.gov/access/monitoring/climate-at-a-glance/statewide/time-series/1/tavg/ann/4/2010-2021?base_prd=true&begbaseyear=1901&endbaseyear=2023)

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

gen interaction=(L.ln_cc_expo_ew_w1)*anomaly

gen dummy=0

sum anomaly, detail

replace dummy=(anomaly>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 anomaly interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen anomaly_ave=mean(anomaly)

gen dummy_overall=0

sum anomaly_ave, detail

sort GVKEY_num year

replace dummy_overall=(anomaly_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum anomaly, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if anomaly>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum anomaly, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if anomaly<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***Per-capita energy related CO2 emissions by state (https://www.eia.gov/environment/emissions/state/)

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

sort GVKEY_num year

gen interaction=(L.ln_cc_expo_ew_w1)*percapita_co_emissions

gen dummy=0

sum percapita_co_emissions, detail

replace dummy=(percapita_co_emissions>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 percapita_co_emissions interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen percapita_co_emissions_ave=mean(percapita_co_emissions)

gen dummy_overall=0

sum percapita_co_emissions_ave, detail

sort GVKEY_num year

replace dummy_overall=(percapita_co_emissions_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum percapita_co_emissions, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if percapita_co_emissions>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum percapita_co_emissions, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if percapita_co_emissions<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***State-level energy intensity (https://www.eia.gov/environment/emissions/state/)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Emission Data.xlsx", sheet("Sheet1") firstrow

drop G state_name

save state_emission_data, replace

clear all

use main_sample

merge m:1 year state using state_emission_data

drop if _merge==2
drop _merge

sum energy_intensity, detail

replace energy_intensity=`r(p50)' if energy_intensity==.

sort GVKEY_num year

gen interaction=(L.ln_cc_expo_ew_w1)*energy_intensity

gen dummy=0

sum energy_intensity, detail

replace dummy=(energy_intensity>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 energy_intensity interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen energy_intensity_ave=mean(energy_intensity)

gen dummy_overall=0

sum energy_intensity_ave, detail

sort GVKEY_num year

replace dummy_overall=(energy_intensity_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum energy_intensity, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if energy_intensity>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum energy_intensity, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if energy_intensity<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***State-level carbon intensity (https://www.eia.gov/environment/emissions/state/)

clear all

import excel "C:\Users\User\Dropbox\Hasan-Oğuzhan\Climate Change Exposure and Cost of Equity\State Level Emission Data.xlsx", sheet("Sheet1") firstrow

drop G state_name

save state_emission_data, replace

clear all

use main_sample

merge m:1 year state using state_emission_data

drop if _merge==2
drop _merge

sum carbon_intensity, detail

replace carbon_intensity=`r(p50)' if carbon_intensity==.

sort GVKEY_num year

gen interaction=(L.ln_cc_expo_ew_w1)*carbon_intensity

gen dummy=0

sum carbon_intensity, detail

replace dummy=(carbon_intensity>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 carbon_intensity interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

bysort state: egen carbon_intensity_ave=mean(carbon_intensity)

gen dummy_overall=0

sum carbon_intensity_ave, detail

sort GVKEY_num year

replace dummy_overall=(carbon_intensity_ave>=`r(p50)')

gen dummy_overall_interaction=(L.ln_cc_expo_ew_w1)*dummy_overall

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_overall_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum carbon_intensity, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if carbon_intensity>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum carbon_intensity, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if carbon_intensity<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***State-level extreme weather events (https://feu-us.org/our-work/case-for-climate-action-us/maps-events-by-state/)

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

gen interaction=(L.ln_cc_expo_ew_w1)*extreme_events

gen dummy=0

sum extreme_events, detail

replace dummy=(extreme_events>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum extreme_events, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if extreme_events>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum extreme_events, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if extreme_events<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***Firm indebtedness (measured by debt_invcap totdebt_invcap debt_at lt_debt de_ratio)

**debt_invcap: long-term debt to invested capital

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*debt_invcap_w1

gen dummy=0

sum debt_invcap_w1, detail

replace dummy=(debt_invcap_w1>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 debt_invcap_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum debt_invcap_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if debt_invcap_w1>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum debt_invcap_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if debt_invcap_w1<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**totdebt_invcap: total debt to invested capital

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*totdebt_invcap_w1

gen dummy=0

sum totdebt_invcap_w1, detail

replace dummy=(totdebt_invcap_w1>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 totdebt_invcap_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum totdebt_invcap_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if totdebt_invcap_w1>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum totdebt_invcap_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if totdebt_invcap_w1<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**debt_at: total debt to total assets

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*debt_at_w1

gen dummy=0

sum debt_at_w1, detail

replace dummy=(debt_at_w1>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 debt_at_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum debt_at_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if debt_at_w1>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum debt_at_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if debt_at_w1<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**lt_debt: long-term debt to total liabilities

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*lt_debt_w1

gen dummy=0

sum lt_debt_w1, detail

replace dummy=(lt_debt_w1>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 lt_debt_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum lt_debt, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if lt_debt_w1>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum lt_debt, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if lt_debt_w1<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

**de_ratio: total debt to total equity ratio

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*de_ratio_w1

gen dummy=0

sum de_ratio_w1, detail

replace dummy=(de_ratio_w1>=`r(p50)')

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 de_ratio_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum de_ratio_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if de_ratio_w1>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum de_ratio_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if de_ratio_w1<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***After tax interest coverage (intcov_w1)

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*intcov_w1

gen dummy=0

sum intcov_w1, detail

replace dummy=(intcov_w1>=`r(p50)')

replace dummy=. if intcov_w1==.

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 intcov_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum intcov_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if intcov_w1>=`r(p50)' & intcov_w1!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

sum intcov_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if intcov_w1<`r(p50)' & intcov_w1!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

***Interest coverage ratio (intcov_ratio_w1)

clear all

use main_sample

gen interaction=(L.ln_cc_expo_ew_w1)*intcov_ratio_w1

gen dummy=0

sum intcov_ratio_w1, detail

replace dummy=(intcov_ratio_w1>=`r(p50)')

replace dummy=. if intcov_ratio_w1==.

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 intcov_ratio_w1 interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum intcov_ratio_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if intcov_ratio_w1>=`r(p50)' & intcov_w1!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

sum intcov_ratio_w1, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if intcov_ratio_w1<`r(p50)' & intcov_w1!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***Firm-level ESG score

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

gen interaction=(L.ln_cc_expo_ew_w1)*ESGScore

gen dummy=0

sum ESGScore, detail

replace dummy=(ESGScore>=`r(p50)')

replace dummy=. if ESGScore==.

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 ESGScore interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum ESGScore, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if ESGScore>=`r(p50)' & ESGScore!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

sum ESGScore, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if ESGScore<`r(p50)' & ESGScore!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

******************************************************************************************************************************************

***Firm-level E score

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

gen interaction=(L.ln_cc_expo_ew_w1)*EScore

gen dummy=0

sum EScore, detail

replace dummy=(EScore>=`r(p50)')

replace dummy=. if EScore==.

gen dummy_interaction=(L.ln_cc_expo_ew_w1)*dummy

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 EScore interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 dummy dummy_interaction L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1, absorb(GVKEY_num year) vce(cluster GICIndustries)

///

sum EScore, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if EScore>=`r(p50)' & EScore!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

sum EScore, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if EScore<`r(p50)' & EScore!=., absorb(GVKEY_num year) vce(cluster GICIndustries)

***Alternative calculation EScore

bysort GVKEY_num: egen EScore_ave=mean(EScore)

sort GVKEY_num year

sum EScore_ave, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if EScore_ave>=`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

sum EScore_ave, detail

reghdfe cost_of_equity_w1 L.ln_cc_expo_ew_w1 L.bm_w1 L.firm_size_w1 L.npm_w1 L.roa_w1 L.debt_at_w1 L.rd_sale_w1 if EScore_ave<`r(p50)', absorb(GVKEY_num year) vce(cluster GICIndustries)

