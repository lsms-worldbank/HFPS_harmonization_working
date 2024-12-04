



dir "${raw_hfps_tza}", w
dir "${raw_hfps_tza}/r8_*", w
dir "${raw_hfps_tza}/r11_*", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_12b.dta"

// d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
	*	 in r8, we are looking for section 13, and it is not available in the public data

*	Tanzania asks about extreme weather events as part of the economic sentiments module 	

d using	"${raw_hfps_tza}/r3_sect_11.dta"		
d using	"${raw_hfps_tza}/r11_sect_13.dta"

	
{	/*	round 3	*/
u "${raw_hfps_tza}/r3_sect_11.dta", clear
	isid hhid shock_cd
	sort hhid shock_cd
	
	ds s11*, not(type string)
	tabstat `r(varlist)', by(shock_cd) s(sum) format(%12.3gc)

	
	tab2 shock_cd s11q01 s11q03, first m

	*	in principle, we could say that this recall data is equivalent to
	*	round 2 data and make two rounds out of this 
	drop t0_region-clusterID
	d s11q02__*	//	codes perfectly match standard set
	ren (s11q01 s11q02__* s11q03 s11q04__*)	/*
	*/	(shock_yn_r2 shock_cope_*_r2 shock_yn_r3 shock_cope_*_r3 )
	cleanstr s11q02_os s11q04_os, names(shock_cope_os_r2 shock_cope_os_r3)
	drop s11q0?_os
	
	ds *_r2
	loc r2 `r(varlist)'
	loc r = subinstr("`r2'","_r2","_r",`: word count `r2'')
	reshape long `r', i(hhid shock_cd) j(round)
	ren *_r *
	
	run "${do_hfps_util}/label_coping_vars.do"
	la var shock_cope_os	"Specify other way to cope with shock"
	
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
tempfile r3
sa		`r3'	

}	/*	round 3	*/
	
	
{	/*	round 11	*/
u "${raw_hfps_tza}/r11_sect_13.dta", clear
	isid hhid shock_cd
	sort hhid shock_cd
	

	
	tab2 shock_cd s13q01, first m
	drop if mi(s13q01)

	drop t0_region-clusterID
	*	automatically capture variable labels to be re-applied after reshape gymnastics
	g shock_yn = (s13q01==1)
	d s13q02_*
	egen shock_cope_1 = rowmax(s13q02_1 s13q02_2 s13q02_3 s13q02_4 s13q02_5)
	egen shock_cope_6 = rowmax(s13q02_6)
	egen shock_cope_31= rowmax(s13q02_7)
	egen shock_cope_7 = rowmax(s13q02_8)
	egen shock_cope_8 = rowmax(s13q02_9)
	egen shock_cope_10= rowmax(s13q02_10)
	egen shock_cope_9 = rowmax(s13q02_11)
	egen shock_cope_11= rowmax(s13q02_12)
	egen shock_cope_12= rowmax(s13q02_13)
	egen shock_cope_13= rowmax(s13q02_14)
	egen shock_cope_14= rowmax(s13q02_15)
	egen shock_cope_15= rowmax(s13q02_16)
	egen shock_cope_32= rowmax(s13q02_17)
	egen shock_cope_16= rowmax(s13q02_18)
	egen shock_cope_17= rowmax(s13q02_19)
	egen shock_cope_18= rowmax(s13q02_20)
	egen shock_cope_19= rowmax(s13q02_21)
	egen shock_cope_20= rowmax(s13q02_22)
	egen shock_cope_21= rowmax(s13q02_23)
	egen shock_cope_96= rowmax(s13q02_96)
	cleanstr s13q02_os, names(shock_cope_os)

	run "${do_hfps_util}/label_coping_vars.do"
	la var shock_cope_os	"Specify other way to cope with shock"
		
	ta shock_cd if shock_yn==1
	
	la var shock_yn	"Affected by shock since last interaction"
	
	
	keep hhid shock*
	isid hhid shock_cd
	sort hhid shock_cd
	
*	harmonize shock_code
run "${do_hfps_util}/label_shock_code.do"
la li shock_cd shock_code 
recode shock_cd (1=5)(2=6)(3=7)(4=10)(5=11)(6=12)(7=31)(8=1)	/*
*/	(10=21)(11=22)(12=23)(13=51)(14=9)(15=52)(16=53)(17=96), gen(shock_code)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shock_cd shock_code
drop shock_cd

	//	we dont ave the string shock present in the public data
	g round=11, b(hhid)
	isid hhid round shock_code
	sort hhid round shock_code
tempfile r11
sa		`r11'	

}	/*	round 11	*/
	
clear
append using `r3' `r11'
isid hhid round shock_code 
sort hhid round shock_code 
order hhid round shock_code 
	
	run "${do_hfps_util}/label_coping_vars.do"	//	re-orders vars 
	
   sa "${tmp_hfps_tza}/shocks.dta", replace 

	
*	move to household level for analysis
u  "${tmp_hfps_tza}/shocks.dta", clear

ta shock_code
la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & shock_yn==1) if !mi(shock_yn)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
// ds shock*, has(type string)
// drop `r(varlist)'

*	verify that missing-ness is intact
tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
	ds shock_cope*, not(type string)
	loc d_shock_cope `r(varlist)'
tabstat `d_shock_cope', by(round) s(n)	


	bys hhid round (shock_code) : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = shock_cope_os if obs==X

 foreach x of varlist shock_yn* shock_cope* {
 	loc lbl`x' : var lab `x'
 }
collapse (max) shock_yn* `d_shock_cope' (firstnm) os*, by(hhid round)
 foreach x of varlist shock_yn* shock_cope* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn*, by(round) s(n)	
tabstat shock_cope*, by(round) s(n)	

	g shock_cope_os=""
	forv i=1/$max {
		tempvar l0 
		g `l0'=length(shock_cope_os)
		replace shock_cope_os = os`i' if `l0'==0 & !mi(os`i')
		replace shock_cope_os = shock_cope_os + "^ " + os`i' if `l0'>0 & !mi(os`i') & strpos(shock_cope_os,os`i')==0
		drop `l0'
	}
	li shock_cope_os if strpos(shock_cope_os,"^")>0, sep(0)
// 	replace shock_cope_os = subinstr(shock_cope_os,"^",", ",.)
	drop os* 
	
	run "${do_hfps_util}/label_coping_vars"
	
isid hhid round
sort hhid round
sa "${tmp_hfps_tza}/hh_shocks.dta", replace 
	
ex




