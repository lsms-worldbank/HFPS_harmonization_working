



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
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w




*/

d using	"${raw_hfps_uga}/round1/SEC9.dta"		//	follows other conventions (though a reduced set of shocks)
d using	"${raw_hfps_uga}/round6/SEC9A.dta"	
d using	"${raw_hfps_uga}/round14/SEC9.dta"	
d using	"${raw_hfps_uga}/round17/SEC9A.dta"

u	"${raw_hfps_uga}/round1/SEC9.dta"	, clear	//	follows other conventions (though a reduced set of shocks)
u	"${raw_hfps_uga}/round6/SEC9A.dta"	, clear
uselabel shocks__id, replace
tempfile r6
sa		`r6'
u	"${raw_hfps_uga}/round14/SEC9.dta"	, clear
uselabel shocks__id, replace
tempfile r14
sa		`r14'
u	"${raw_hfps_uga}/round17/SEC9A.dta"	, clear
uselabel shocks__id, replace
tempfile r17
sa		`r17'

u `r6', clear
foreach r of numlist 14 17 {
mer 1:1 value label using `r`r'', gen(_`r')
}
li value label _*, nol sepby(value)
	*	shock codes are harmonized rounds 14 & 17
	
*	coping codes, rounds 14 & 17
u "${raw_hfps_uga}/round14/SEC9.dta", clear
d s9aq02__*, replace clear
tempfile r14
sa		`r14'
u "${raw_hfps_uga}/round17/SEC9A.dta", clear
d s9aq02__*, replace clear
tempfile r17
sa		`r17'

u `r14', clear
foreach r of numlist 17 {
mer 1:1 name varlab using `r`r'', gen(_`r')
}

g code = subinstr(name,"s9aq02__","",1)
destring code, replace ignore(n)
recode code 96=-96
egen zz = ends(varlab), tail punct(: )
sort code _* zz
li code zz _*, nol sepby(code)
	*	substantial conflict in codes 7 8
	
	

*	manually harmonize these prior to append 
u	"${raw_hfps_uga}/round1/SEC9.dta", clear

la li s9q03__1 s9q03__2 s9q03__3 s9q03__4 s9q03__5 s9q03__6 s9q03__7 s9q03__8 s9q03__9 s9q03__10 s9q03__11 s9q03__12 s9q03__13 s9q03__14 s9q03__15 s9q03__16 s9q03__n96

loc clncodes 1 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 96
ds s9q03__*, not(type string)
loc vars `r(varlist)'
loc i=0
foreach v of local vars {
	loc ++i
	loc c : word `i' of `clncodes'
	g shock_cope_`c' = `v' 
	loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
	loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
	loc clnlbl = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
	la var shock_cope_`c'	"`clnlbl' to cope with shock"
}
ren (s9q01 s9q01_Other s9q03_Other) (shock_yn shock_os shock_cope_os)
keep hhid shock*
g round=1, b(hhid)
tempfile r1
sa		`r1'

u	"${raw_hfps_uga}/round6/SEC9A.dta", clear
drop s9aq04 s9aq05	//	hh level vars added on to this module 
la li shocks__id
// ta s9aq01_Other
ta s9aq02	// no other examples for the panel
drop s9aq02
ta s9aq03	//	only one coping strategy per shock allowed here
// ta s9aq03_Other

la li s9aq03	//	

foreach i of numlist 1 6/9 11/21 -96 {
	loc a = abs(`i')
	g shock_cope_`a' = (s9aq03==`i') if !mi(s9aq03)
	la var shock_cope_`a'	"`: label (s9aq03) `i'' to cope with shock"
}
ren (s9aq01 s9aq01_Other s9aq03_Other) (shock_yn shock_os shock_cope_os)

keep hhid shock*
g round=6, b(hhid)
tempfile r6
sa		`r6'


#d ; 
clear; append using 
	"${raw_hfps_uga}/round14/SEC9.dta"
	"${raw_hfps_uga}/round17/SEC9A.dta"
	, gen(round); 
la drop _append; la val round .; recode round (1=14)(2=17); 
#d cr
la li shocks__id

recode shocks__id	(1=5)(2=6)(3=7)(4=10)(5=11)(6=12)(7=43)(8=1)(9=21)(10=22)	/*
*/		(11=23)(12=51)(13=9)(14=52)(15=53)(-96=96)
do "${do_hfps_util}/label_shock_code.do"


ta s9aq01	// no other examples for the panel

la li s9aq02__1	//	0/1
d s9aq02__*	//	unique variables already constructed for all coping strategies 

egen shock_cope_1 = rowmax(s9aq02__1 s9aq02__2 s9aq02__3  s9aq02__4  s9aq02__5 )
egen shock_cope_6 = rowmax(s9aq02__6 )

egen shock_cope_8 = rowmax(s9aq02__9 )
egen shock_cope_10= rowmax(s9aq02__10 )
egen shock_cope_9 = rowmax(s9aq02__11 )
egen shock_cope_11= rowmax(s9aq02__12 )
egen shock_cope_12= rowmax(s9aq02__13 )
egen shock_cope_13= rowmax(s9aq02__14 )
egen shock_cope_14= rowmax(s9aq02__15 )
egen shock_cope_15= rowmax(s9aq02__16 s9aq02__17 )
egen shock_cope_17= rowmax(s9aq02__18 )
egen shock_cope_18= rowmax(s9aq02__19 )
egen shock_cope_19= rowmax(s9aq02__20 )
egen shock_cope_20= rowmax(s9aq02__21 )
egen shock_cope_21= rowmax(s9aq02__22 )
egen shock_cope_96= rowmax(s9aq02__n96)

egen aaa = rowmax(s9aq02__8 ) if round==14
egen bbb = rowmax(s9aq02__7 s9aq02__8 ) if round==17
egen shock_cope_7 = rowmax(aaa bbb)
drop aaa bbb
egen aaa = rowmax(s9aq02__7  ) if round==14
egen bbb = rowmax(s9aq02__23 ) if round==17
egen shock_cope_31= rowmax(aaa bbb)
drop aaa bbb
egen shock_cope_16= rowmax(s9aq02__24 ) if round==17

do "${do_hfps_util}/label_coping_vars.do"
ren (s9aq01) (shock_yn)

keep hhid round shock*

tempfile r14p
sa		`r14p'


clear 
append using `r1' `r6' `r14p'
	
	ta round shocks__id	
	isid hhid shocks__id round		

*	harmonize shock_code
run "${do_hfps_util}/label_shock_code.do"
la li shocks__id shock_code 
g shock_code=shocks__id if round<14, a(shocks__id)
recode shock_code (1 3=1)(2=41)(4=42)(8 9=8)(13=23)(-96=96)
replace shock_code=shocks__id if inlist(round,14,17)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shocks__id shock_code
drop shocks__id

do "${do_hfps_util}/label_coping_vars.do"	
	
// 	isid hhid shock_code round	//	npt identified because of binning of shock_code
	sort hhid shock_code round

	

sa "${tmp_hfps_uga}/panel/shocks.dta", replace 

*	move to household level for analysis
u  "${tmp_hfps_uga}/panel/shocks.dta", clear

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

tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)

isid hhid round
sort hhid round
sa "${tmp_hfps_uga}/panel/hh_shocks.dta", replace 

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








