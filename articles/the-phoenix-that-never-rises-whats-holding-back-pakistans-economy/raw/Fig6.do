

// This file generates the SIXTH figure in the Econ Observatory article


clear 

cd "C:\Users\ap1640\OneDrive - University of Bristol\Bristol Uni\Econ Observatory\Figures"

use pld2023_dataset.dta


// rename sectors
replace sector = "Agriculture" if sector == "agr"
replace sector = "Mining" if sector == "min"
replace sector = "Manufacturing" if sector == "man"
replace sector = "Utilities" if sector == "pu"
replace sector = "Construction" if sector == "con"
replace sector = "Trade" if sector == "trd"
replace sector = "Transport" if sector == "tra"
replace sector = "Business" if sector == "bus"
replace sector = "Finance" if sector == "fin"
replace sector = "Real estate" if sector == "dwe"
replace sector = "Government" if sector == "pub"
replace sector = "Other services" if sector == "oth"

encode(sector), gen(j)

// create variable representing aggregate GDP (nominal) and labour force
sort countrycode year sector
egen VA_total = sum(VA), by(countrycode year)
egen EMP_total = sum(EMP), by(countrycode year)
 
 
sort countrycode year


cd "C:\Users\ap1640\OneDrive - University of Bristol\Pakistan\EAG\Report on productivity\Databases"

merge m:m countrycode year using Penworldtables10.dta, keepusing(country rgdpo cgdpo pop ctfp pl_gdpo xr)

keep if _merge == 3

/*
// MERGE data with WDI PPPs for aggregate output - only for ETD countries
cd "C:\Users\ap1640\OneDrive - University of Bristol\Pakistan\EAG\Report on productivity"
merge m:m countrycode year using ppp_wdi_etd
keep if year == 2005 | year == 2011 | year == 2017
label var ppp "PPP for aggregate output"
label var price_level "Price level for aggregate output (US = 1)"
*/


// Adjust nominal aggregate and sector output for PPP
gen VA_ppp = VA/PPP_va
gen VA_total_ppp = VA_total/(xr*pl_gdpo)


// Labour productivity (PPP adjusted - for spacial comparison)
gen lab_prod = VA_ppp/EMP
gen labT_prod = VA_total_ppp/EMP_total
gen emp_sh = EMP/EMP_total

// Productivity gap
gen prod_gap = lab_prod/labT_prod			// lab productivity gap






// LABOUR PRODUCTIVITY GAP 
 
preserve 

keep if year == 2017 

egen id = group(country j)
sort country id


replace labT_prod = ln(labT_prod)


twoway (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & year == 2017, color(%50)) (qfit prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & year == 2017, mcolor(black)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "Pakistan" & year == 2017, mlabel(countrycode) mlabc(green) mcolor(green) color(%75)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "Bangladesh" & year == 2017, mlabel("") mlabc(black) mcolor(black) color(%75)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "United States" & year == 2017, mlabel(countrycode) mlabc(red) mcolor(red) color(%75)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "India" & year == 2017, mlabel(countrycode) mlabc(orange) mcolor(orange) color(%75)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "China" & year == 2017, mlabel(countrycode) mlabc(black) mcolor(black) color(%50)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "Germany" & year == 2017, mlabel(countrycode) mlabc(maroon) mcolor(maroon) color(%50)) (scatter prod_gap labT_prod if prod_gap < 1.2 & labT_prod < 130 & sector == "Agriculture" & country == "United Kingdom" & year == 2017, mlabel(countrycode) mlabc(maroon) mcolor(maroon) color(%50)), xtitle("log(Labour Productivity, 000s of $)") legend(off) ytitle("Productivity gap") title("Agriculture Productivity Gap (PPP 2017)") name(agrigap_sd,replace) ylabel(0(0.2)1.2)

