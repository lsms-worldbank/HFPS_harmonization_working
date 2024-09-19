



dir "${raw_hfps_tza}", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_1.dta"

*	s3=employment, s4=nfe, s5=tourism nfe 
// d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	//	s3* 
// d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s3* s4* s5q*
d using	"${raw_hfps_tza}/r3_sect_11.dta"	//	s3q* s4q*		
// d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		//	s3q* s4q* 	
// d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	s3q* s4q* 	
// d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"		//	s3q*  	
// d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	//	s3q*
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	s3q* s4q0*

d using	"${raw_hfps_tza}/r8_sect_12b.dta"	//	s3q* s4q*		
	*	 in r8, we are looking for section 13, and it is not available in the public data

*	only one shocks module in the current version of the public data
u "${raw_hfps_tza}/r3_sect_11.dta", clear
	isid hhid shock_cd
	sort hhid shock_cd
	
	ds s11*, not(type string)
	tabstat `r(varlist)', by(shock_cd) s(sum) format(%12.3gc)

	
	tab2 shock_cd s11q01 s11q03, first m

	*	in principle, we could say that this recall data is equivalent to
	*	round 2 data and make two rounds out of this 
	drop t0_region-clusterID
	*	automatically capture variable labels to be re-applied after reshape gymnastics
	ds s11q02__*, not(type string)
	loc vars `r(varlist)'
	foreach v of local vars {
		loc i = substr("`v'",strpos("`v'","__")+2,length("`v'")-strpos("`v'","__")-1)
		loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
		loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
		loc clnlbl`i' = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
	}
	*	reshape gymnastics
	reshape long s11q02__ s11q04__, i(hhid shock_cd) j(cope_cd)
	ren (s11q01 s11q02__ s11q02_os s11q03 s11q04__ s11q04_os)	/*
	*/	(shock_yn2 shock_cope_2 os2 shock_yn3 shock_cope_3 os3)
	reshape long shock_yn shock_cope_ os, i(hhid shock_cd cope_cd) j(round)
	reshape wide shock_cope_, i(hhid shock_cd round) j(cope_cd)
	order shock_yn, a(round)
	*	automatically re-apply variable labels captured in locals above 
	ds shock_cope_*, not(type string)
	loc vars `r(varlist)'
	foreach v of local vars {
		loc i = substr("`v'",length("shock_cope_")+1,length("`v'")-length("shock_cope_"))
		la var `v' "`clnlbl`i'' to cope with shock"	
	}	
	g shock_cope_os = strtrim(lower(os))
	la var shock_cope_os	"Specify other way to cope with shock"
	d shock_cope_*
	
	ta shock_cd round if shock_yn==1
	
	recode shock_yn (2=0) 
	la val shock_yn 	//	get rid of old label 
	la var shock_yn	"Affected by shock since last interaction"
	
	
	keep hhid round shock*
	isid hhid round shock_cd
	sort hhid round shock_cd
	
*	harmonize shock_code
run "${do_hfps_util}/label_shock_code.do"
la li shock_cd shock_code 
g shock_code=shock_cd+4, a(shock_cd)
recode shock_code (9=10)(10=11)(11=12)(12=1)(100=96)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shock_cd shock_code
drop shock_cd

	isid hhid round shock_code
	sort hhid round shock_code
   sa "${tmp_hfps_tza}/panel/shocks.dta", replace 

	
*	move to household level for analysis
u  "${tmp_hfps_tza}/panel/shocks.dta", clear

ta shock_code
la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & shock_yn==1) if !mi(shock_yn)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
ds shock*, has(type string)
drop `r(varlist)'

*	verify that missing-ness is intact
tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)


 foreach x of varlist shock_yn* shock_cope* {
 	loc lbl`x' : var lab `x'
 }
collapse (max) shock_yn* shock_cope*, by(hhid round)
 foreach x of varlist shock_yn* shock_cope* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)


isid hhid round
sort hhid round
sa "${tmp_hfps_tza}/panel/hh_shocks.dta", replace 
	
ex

*	modifications for construction of grand panel 
u "${tmp_hfps_tza}/panel/cover.dta", clear


egen pnl_hhid = group(hhid)
li t0_region t0_district t0_ward t0_village t0_ea in 1/10
li t0_region t0_district t0_ward t0_village t0_ea in 1/10, nol

egen pnl_admin1 = group(t0_region)
egen pnl_admin2 = group(t0_region t0_district)
egen pnl_admin3 = group(t0_region t0_district t0_ward)

ta urban_rural, m
g pnl_urban = (urban_rural==2)
g pnl_wgt = wgt 
sa "${tmp_hfps_tza}/panel/pnl_cover.dta", replace 


