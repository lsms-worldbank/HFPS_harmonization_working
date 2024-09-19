

dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*chocs*.dta", w	//we need section 6, but it splits in sections after the first  


// d using	"${raw_hfps_bfa}/r1_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r2_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r3_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r4_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r5_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r6_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r7_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r8_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r9_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r10_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r11_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r12_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r13_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r14_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r15_sec9_chocs.dta"	
d using	"${raw_hfps_bfa}/r16_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r17_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r18_sec9_chocs.dta"	
d using	"${raw_hfps_bfa}/r19_sec9_chocs.dta"	
d using	"${raw_hfps_bfa}/r22_sec9_chocs.dta"	



foreach r of numlist 2 4 6 8 10 16 19 22	{
u chocs__id using 	"${raw_hfps_bfa}/r`r'_sec9_chocs.dta", clear
uselabel chocs, clear
tempfile r`r'
sa		`r`r''
}
u `r2', clear
foreach r of numlist  4 6 8 10 16 19 22	{
	mer 1:1 value label using `r`r'', gen(_`r')
}

li value label _*, sep(0) nol


#d ; 
clear; append using
	"${raw_hfps_bfa}/r2_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r4_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r6_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r8_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r10_sec9_chocs.dta"	
	"${raw_hfps_bfa}/r16_sec9_chocs.dta"	
	"${raw_hfps_bfa}/r19_sec9_chocs.dta"	
	"${raw_hfps_bfa}/r22_sec9_chocs.dta"	
, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round+1
replace round=round+1 if round>2
replace round=round+1 if round>4
replace round=round+1 if round>6
replace round=round+1 if round>8
replace round=round+5 if round>10
replace round=round+2 if round>16
replace round=round+2 if round>19
	ta round
	isid hhid chocs__id round
	
*	harmonize shock_code
inspect chocs__id
run "${do_hfps_util}/label_shock_code.do"
la li chocs shock_code 
g shock_code=chocs__id, a(chocs__id)
recode shock_code (2=41)(3=1)(4=42)(13=96) if inrange(round,1,16)
recode shock_code (1=5)(2=6)(3=7)(4=10)(5=11)(6=12)(7=31)(8=1)(9=21)(10=22)(11=23)(12=51)(13=9)(14=52)(15=53) if inrange(round,19,22)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta chocs__id shock_code
drop chocs__id

bys hhid round (shock_code) : egen shock_yn = max(s09q01==1)
g yn = (s09q01==1)
ds s09q03*, not(type string)
collapse (max) yn=s09q01 `r(varlist)', by(hhid round shock_code)
	
ren s09q03__* shock_cope_*
tabstat shock_cope_*, by(round) s(min max)	//	coding is 0/1
// ren shock_cope_22 shock_cope_96
replace shock_cope_96=shock_cope_22 if round<19
	la var shock_cope_1  "Sale of assets (ag and no-ag) to cope with shock"
	la var shock_cope_6  "Engaged in additional income generating activities to cope with shock"
	la var shock_cope_7  "Received assistance from friends & family to cope with shock"
	la var shock_cope_8  "Borrowed from friends & family to cope with shock"
	la var shock_cope_9  "Took a loan from a financial institution to cope with shock"
	la var shock_cope_11 "Credited purchases to cope with shock"
	la var shock_cope_12 "Delayed payment obligations to cope with shock"
	la var shock_cope_13 "Sold harvest in advance to cope with shock"
	la var shock_cope_14 "Reduced food consumption to cope with shock"
	la var shock_cope_15 "Reduced non-food consumption to cope with shock"
	la var shock_cope_16 "Relied on savings to cope with shock"
	la var shock_cope_17 "Received assistance from ngo to cope with shock"
	la var shock_cope_18 "Took advanced payment from employer to cope with shock"
	la var shock_cope_19 "Received assistance from government to cope with shock"
	la var shock_cope_20 "Was covered by insurance policy to cope with shock"
	la var shock_cope_21 "Did nothing to cope with shock"
	la var shock_cope_96 "Other (specify) to cope with shock"

*	codes shift in r19+
	*	could also approach with a reshape
foreach x of varlist shock_cope_* {
	loc name = subinstr("`x'","shock_cope","raw",1)
	g `name' = `x' if round>=19
	replace `x' = . if round>=19
}
cap : prog drop change_code 
	  prog def  change_code 
syntax name(name=targetvar), source(varlist)

	*	ensure that none of source have been used already
	foreach x of local source {
		cou if !mi(`x') & round>=19
		cap : assert r(N)>0
		if _rc {
			dis as error "`x' contains all missing in r19+, meaning it has already been included in another variable. Please check. "
			error 7
		}
	}

tempvar zzz
egen `zzz'  = rowmax(`source')
cap : confirm numeric variable `targetvar'
if !_rc {
replace `targetvar' = `zzz' if round>=19
}
else {
g `targetvar' = `zzz'
}
drop `zzz'

drop `source'

end

change_code shock_cope_1 , source(raw_1 raw_2 raw_5)
change_code shock_cope_12, source(raw_3)
	*	how to treat code 4, it's "sold crops/food products". treat this as relying on savings? 
change_code shock_cope_6, source(raw_4 raw_6)
change_code shock_cope_31, source(raw_7)
la var shock_cope_31	"One or more family members migrated for work to cope with shock"
change_code shock_cope_9, source(raw_11)	//	keeping only financial instition
change_code shock_cope_10, source(raw_10)	//	money lenders getting their own category
la var shock_cope_10	"Borrowed from money lenders to cope with shock"




*	cases where we just add one to the code 
foreach outcode of numlist 7 8 11/21 {
	loc incode = `outcode'+1
	change_code shock_cope_`outcode', source(raw_`incode')
}

d raw*
change_code shock_cope_96, source(raw_96)
cap : d raw*
assert _rc
prog drop change_code

tabstat shock_cope_*, by(round)
do "${do_hfps_util}/label_coping_vars.do"



sa "${tmp_hfps_bfa}/panel/shocks.dta", replace
	
	
*	move to household level for analysis
u  "${tmp_hfps_bfa}/panel/shocks.dta", clear

ta shock_code
la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & yn==1)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
// ds shock*, has(type string)
// drop `r(varlist)'

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
sa "${tmp_hfps_bfa}/panel/hh_shocks.dta", replace 
	
	
	

