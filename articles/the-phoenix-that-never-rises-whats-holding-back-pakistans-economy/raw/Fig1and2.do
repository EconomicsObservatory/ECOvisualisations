

// This file generates the FIRST and the SECOND figure for the Econ Observatory article



clear 

cd "C:\Users\ap1640\OneDrive - University of Bristol\Bristol Uni\Econ Observatory\Figures"

use ETD2021Release.dta



rename Total ind0
rename Agriculture ind1
rename Mining ind2
rename Manufacturing ind3
rename Utilities ind4
rename Construction ind5
rename Trade ind6
rename Transport ind7
rename Business ind8
rename Finance ind9
rename Realestate ind10
rename Government ind11
rename Other ind12


reshape long ind, i( country var year ) j(j)


sort country var j year


reshape wide ind, i(country j year) j(var) string

rename indEMP emp
rename indVA va 
rename indVA_Q15 va_q15

gen ind = ""
replace ind = "Total" if j == 0
replace ind = "Agriculture" if j == 1
replace ind = "Mining" if j == 2
replace ind = "Manufacturing" if j == 3
replace ind = "Utilities" if j == 4
replace ind = "Construction" if j == 5
replace ind = "Trade" if j == 6
replace ind = "Transport" if j == 7
replace ind = "Business" if j == 8
replace ind = "Finance" if j == 9
replace ind = "Realestate" if j == 10
replace ind = "Government" if j == 11
replace ind = "Other" if j == 12


sort country j year

egen emp_total = sum(emp) if j > 0, by(country year)
egen va_total = sum(va) if j > 0, by(country year)
egen vaq15_total = sum(va_q15) if j > 0, by(country year)

rename emp emp_sec


drop if j == 0


// GENERATE VARIABLES YOU NEED
gen emp_sh = emp_sec/emp_total			// employment share
gen vaq15_sh = va_q15/vaq15_total		// value-added share
gen prod_total = vaq15_total/emp_total	// output per worker
gen prod = va_q15/emp_sec   			// output per worker across sectors
gen prod_gap = prod/prod_total			// lab productivity gap




// LABOUR PRODUCTIVITY

keep if year == 1990 | year == 2018
egen id = group(country j)
sort id year
xtset id year



bysort id (country year): gen prodT_change_comp = 100*((prod_total[_N]/prod_total[1])^(1/28) - 1)
bysort id (country year): gen prod_change_comp = 100*((prod[_N]/prod[1])^(1/28) - 1)


//FIGURE 1

separate prodT_change_comp if j == 1, by(country == "Pakistan")

graph hbar prodT_change_comp0 prodT_change_comp1 if j == 1 & year == 1990, nofill over(country, lab(labsize(tiny)) sort(prodT_change_comp)) title("Change in Labour Productivity") legend(off) subtitle("between 1990 - 2018") ytitle("Average annual growth rate") name(labprod_annual_countries, replace)



// FIGURE 2

keep if country == "Pakistan" | country == "India" | country == "China" | country == "Bangladesh" // | country == "Sri Lanka" | country == "Nepal" | country == "Myanmar" 

graph bar prod_change_comp if (country != "Myanmar") & year == 1990, over(ind, lab(labsize(tiny) angle(45)) sort(1)) over(country, sort(1)) title("Growth in Labour Productivity") subtitle("between 1990 - 2018") ytitle("Average annual growth rate") graphregion(col(white)) name(labprod_annual_southasia,replace) //caption("{bf:Source}: Economic Advisory Group (EAG)" "{bf:Note}: based on {it:UNU-WIDER Economic Transformation Database}")



