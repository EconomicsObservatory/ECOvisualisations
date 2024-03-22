

// This file generates the THIRD figure in the Econ Observatory article


clear all 

cd "C:\Users\ap1640\OneDrive - University of Bristol\Bristol Uni\Econ Observatory\Figures"

use avg_gvc_data_sector.dta, clear 


gen country3 = isocode3  if (isocode3=="PAK") 

graph twoway (scatter avg_gvc_part_exp_int lnavg_share_trade00 if export_intensity==1, mlabel(country3) mlabcolor(green) msymbol(T) mcolor(maroon)) (lfit avg_gvc_part_exp_int lnavg_share_trade00) (scatter avg_gvc_part_exp_int  lnavg_share_trade00 if export_intensity==0, mlabel(country3) mlabcolor(green) msymbol(o) mcolor(blue)),  ytit("Participation rate") xtit("log(trade openness)") legend(order(1 "Export sector" 3 "Non-Export sector")) name(growth_part_gdp, replace) title("GVC Participation and Trade Openess")