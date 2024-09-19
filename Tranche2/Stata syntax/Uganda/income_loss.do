



/*
dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w

d using	"${raw_hfps_uga}/round1/SEC6.dta"
d using	"${raw_hfps_uga}/round2/SEC6.dta"
d using	"${raw_hfps_uga}/round3/SEC6.dta"
d using	"${raw_hfps_uga}/round4/SEC6.dta"
d using	"${raw_hfps_uga}/round5/SEC6.dta"
d using	"${raw_hfps_uga}/round6/SEC6.dta"
// d using	"${raw_hfps_uga}/round7/SEC6.dta"
d using	"${raw_hfps_uga}/round8/SEC6.dta"
// d using	"${raw_hfps_uga}/round9/SEC6.dta"	//	not the same section 6 
d using	"${raw_hfps_uga}/round10/SEC6.dta"
d using	"${raw_hfps_uga}/round11/SEC6.dta"
d using	"${raw_hfps_uga}/round12/SEC6.dta"
// d using	"${raw_hfps_uga}/round13/SEC6.dta"



*/




#d ; 
clear; append using
 "${raw_hfps_uga}/round1/SEC6.dta"
 "${raw_hfps_uga}/round2/SEC6.dta"
 "${raw_hfps_uga}/round3/SEC6.dta"
 "${raw_hfps_uga}/round4/SEC6.dta"
 "${raw_hfps_uga}/round5/SEC6.dta"
 "${raw_hfps_uga}/round6/SEC6.dta"
 "${raw_hfps_uga}/round8/SEC6.dta"
 "${raw_hfps_uga}/round10/SEC6.dta"
 "${raw_hfps_uga}/round11/SEC6.dta"
 "${raw_hfps_uga}/round12/SEC6.dta"

, gen(round);
#d cr

	
	la drop _append
	la val round 
	ta round 	

	isid hhid income_loss__id round
	sort hhid income_loss__id round

	

sa "${tmp_hfps_uga}/panel/income_loss.dta", replace 
ex

*	modifications for construction of grand panel 
u "${tmp_hfps_uga}/panel/cover.dta", clear 

egen pnl_hhid = group(hhid)
egen pnl_admin1 = group(r0_region)
egen pnl_admin2 = group(r0_region r0_distname)
egen pnl_admin3 = group(r0_region r0_distname r0_countyname)

ta urban r0_urban,m
d urban
la li Cq07
egen pnl_urban = anymatch(urban), v(1 2)
g pnl_wgt = wgt

sa "${tmp_hfps_uga}/panel/pnl_cover.dta", replace 


// gr twoway scatter start_yr start_mo








