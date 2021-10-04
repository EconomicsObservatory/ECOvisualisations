* ************************************
* ********** Preamble ****************
* ************************************

* Preliminary

version 14
clear all
clear matrix
pause off
set more off
prog drop _all
set matsize 5000

* Define path

global path="ADD FOLDER PATH" 


* **************************************
* ********** Replication ***************
* **************************************

* 0. Preliminary cleaning

use "${path}/main.dta", clear

* 0.a Define samples and controls 

global sample "if share_labor_oa_males_1881!=. & share_labor_oa_2011!=. & max_elevation!=. & distance_chimneys_heavy!=. & distance_chimneys_light!=. & property_tax_1815!=."

global controls_population "tot_empl_1881 share_labor_1817 share_farm_1817 share_manager_1817 property_tax_1815"
global controls_geo "max_elevation min_elevation mean_elevation distance_canals_inv"
global controls_city "distance_townhall_inv distance_park_inv share_area_city area distance_chimneys_heavy distance_chimneys_light"
global controls_coordinates "longitude_oa latitude_oa"

* 0.b Define LSOA group identifiers and standardize important variables

gen group_lsoa=_n
foreach var of varlist share_labor_oa_males_1881 {
center `var' ${sample}, standardize 
}

* 0.c Compute the number of cities and LSOAs, MSOAs, wards, 

egen group_city=group(city) ${sample}
egen count_city=max(group_city) ${sample}
drop group_lsoa
egen group_lsoa=group(lsoa_code) ${sample}
egen count_lsoa=max(group_lsoa) ${sample}
egen group_parish=group(parish_code) ${sample}
egen count_parish=max(group_parish) ${sample}
egen group_msoa=group(msoa_code) ${sample}
egen count_msoa=max(group_msoa) ${sample}
egen group_ward=group(stwardcode) ${sample}
egen count_ward=max(group_ward) ${sample}
display "count_city"
su count_city
display "count_parish"
su count_parish
foreach unit in lsoa parish msoa ward {
generate count_`unit'_per_city=count_`unit'/count_city
display "count_`unit'_per_city"
su count_`unit'_per_city
}


* Figure 10: Pollution (x-axis) across neighborhoods and shares of low-skilled workers (y-axis) in 1817, 1881, 1971, 1991 and 2011

global controls ${controls_population} ${controls_geo} ${controls_coordinates}
areg norm_pollution_weight ${controls} ${sample}, absorb(city)
predict norm_pollution_city, res
foreach year in 1971 1981 1991 2001 2011 {
areg norm_share_labor_oa_`year' ${controls_population} ${controls} ${sample}, absorb(city)
predict share_labor_oa_`year'_city, res
}
areg norm_share_labor_1817 ${controls_geo} ${controls_coordinates} ${sample}, absorb(city)
predict share_labor_oa_1817_city, res
areg norm_share_labor_oa_males_1881 ${controls} ${sample}, absorb(city)
predict share_labor_oa_1881_city, res
generate norm_pollution_city_round=floor(norm_pollution_city*20)/20  ${sample}
foreach year in 1817 1881 1971 1981 1991 2001 2011 {
egen share_labor_oa_`year'_round=mean(share_labor_oa_`year'_city) ${sample}, by(norm_pollution_city_round)
}
egen tag=tag(norm_pollution_city_round)
egen count=count(norm_pollution_city_round), by(norm_pollution_city_round)
global sample_fig "if norm_pollution_city>-1.4 & norm_pollution_city<1.4"
#delimit ;
twoway lpoly share_labor_oa_2011_city norm_pollution_city ${sample_fig}, lcolor(gs10) bwidth(.5) deg(1) lpattern(longdash) ||
lpoly share_labor_oa_1991_city norm_pollution_city ${sample_fig}, lcolor(gs10) bwidth(.5) deg(1)  lpattern(dot) ||
lpoly share_labor_oa_1971_city norm_pollution_city ${sample_fig}, lcolor(gs10) bwidth(.5) deg(1) lpattern(-) ||
lpoly share_labor_oa_1881_city norm_pollution_city ${sample_fig}, lcolor(black) bwidth(.5) deg(1) lpattern(solid) ||
lpoly share_labor_oa_1817_city norm_pollution_city ${sample_fig}, lcolor(black) bwidth(.5) deg(1) lpattern(dash_dot)
ytitle("Share of low-skilled workers (standardized)")       
xtitle("Pollution")
xlabel(-1 0 1)
yscale(range(-0.7 0.7))
ylabel(-0.5 0 0.5)
bgcolor("white") graphregion(color(white) margin(l-3 r+1)) 
scale(1.2) legend(order(5 4 3 2 1) ring(0) nobox region(lstyle(none)) label(1 "2011") label(2 "1991") label(3 "1971") label(4 "1881") label(5 "1817") cols(3) pos(10) region(lcolor(white)))
;
#delimit cr


graph export "${path}\Figure_10.eps", as(eps) preview(off) replace
graph export "${path}\Figure_10.png", as(png) replace width(1000)
