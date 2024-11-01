tsline DG PG,  ylabel(0 7.00e-08 2.50e-08 2.50e-08  1.20e-07) xtitle("") ytitle(Google Ngram frequency) xline(2008, lcolor(red) lpattern(dash))

tsline DG PG,  ylabel(0 7.00e-08 2.50e-08 2.50e-08  1.20e-07) xtitle("") ytitle(Google Ngram frequency) xline(2008, lcolor(red) lpattern(dash))

twoway (tsline DG PG LtoG, yaxis(1)  ytitle(Google Ngram frequency, axis(1)) ) (tsline EG, yaxis(2) ytitle(" Google Ngram frequency", axis(2)) xline(2008, lpattern(dash)))