

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*coping*", w

d using	"${raw_hfps_mwi}/sect10_coping_r2.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r3.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r7.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r15.dta"	//	coping matches NG code
d using	"${raw_hfps_mwi}/sect10_coping_r16.dta"	//	alternate coping codes
d using	"${raw_hfps_mwi}/sect10_coping_r18.dta"	//	coping matches NG code

*	set up an automated verification of the coping codes
foreach r of numlist 2 3 7 15 18 {
	u s10q3__* using "${raw_hfps_mwi}/sect10_coping_r2.dta", clear
	d, replace clear
	keep name varlab
	ren varlab varlab`r'
	tempfile r`r'
	sa		`r`r''
}
u `r2', clear
foreach r of numlist 3 7 15 18 {
mer 1:1 name using `r`r'', assert(3) gen(_`r')
assert varlab`r'==varlab2
}
sort name
g code = substr(name,length("s10q3__")+1,length(name)-length("s10q3__"))
destring code, replace
sort code
g varlab = substr(varlab2,strpos(varlab2,":")+1,length(varlab2)-strpos(varlab2,":"))
li name code varlab, sep(0)

d s10q8__* using	"${raw_hfps_mwi}/sect10_coping_r16.dta"	//	alternate coping codes



u	"${raw_hfps_mwi}/sect10_coping_r2.dta"	, clear
la li Sec10_shocks__id
u	"${raw_hfps_mwi}/sect10_coping_r3.dta"	, clear
la li Sec10_shocks__id
u	"${raw_hfps_mwi}/sect10_coping_r7.dta"	, clear
la li Sec10_shocks__id
u	"${raw_hfps_mwi}/sect10_coping_r15.dta"	, clear
la li Sec10_shocks__id
u	"${raw_hfps_mwi}/sect10_coping_r16.dta"	, clear
la li Sec10_shocks__id
u	"${raw_hfps_mwi}/sect10_coping_r18.dta"	, clear	//	matches NG code
la li Sec10_shocks__id

u	"${raw_hfps_mwi}/sect10_coping_r16.dta"	, clear
la li selection

g  s10q3__1 =  s10q8__3
egen  s10q3__6 = rowmax(s10q8__4 s10q8__5)	//	combining add'l income activities with renting out more things 
// g  s10q3__7 =  s10q8__ //	can't link assistance or loans as they are binned in round 16
// g  s10q3__8 =  s10q8__ 
// g  s10q3__9 =  s10q8__ 
// g s10q3__11 =  s10q8__ 
// g s10q3__12 =  s10q8__ 
// g s10q3__13 =  s10q8__ 
g s10q3__14 =  s10q8__7
g s10q3__15 =  s10q8__8
g s10q3__16 =  s10q8__1
// g s10q3__17 =  s10q8__ 
// g s10q3__18 =  s10q8__ 
// g s10q3__19 =  s10q8__ 
g s10q3__20 = s10q8__12
g s10q3__21 = s10q8__13
g s10q3__96 = s10q8__96
tempfile r16
sa		`r16'


#d ; 
clear; append using
	"${raw_hfps_mwi}/sect10_coping_r2.dta"
	"${raw_hfps_mwi}/sect10_coping_r3.dta"
	"${raw_hfps_mwi}/sect10_coping_r7.dta"
	"${raw_hfps_mwi}/sect10_coping_r15.dta"
	`r16'
	"${raw_hfps_mwi}/sect10_coping_r18.dta"
, gen(round);
#d cr 
isid y4 shock_id round
la drop _append
la val round 
ta round 
replace round=round+1
replace round=round+3 if round>3
replace round=round+7 if round>7
replace round=round+1 if round>16
ta round
assert inlist(round,2,3,7,15,16,18)
	la var round	"Survey round"

	
ta shock_id_os	//	10 copies of each
la li Sec10_shocks__id
la copy Sec10_shocks__id shock_id
la def shock_id 1 "Drought" 2 "Irregular rainfall" 3 "Flooding" 4 "Cyclone", add	//	considered in r18
la def shock_id 14 "Death of Any Other HH member due to COVID-19", add	//	added in round 15 and continued
la val shock_id shock_id 
recode shock_id 95=96	//	different code in round 3, unclear why 
ta shock_id round
tab2 round s10q1 s10q3, first m

egen shock_d_ = rowmin(s10q1 s10q3)
ta shock_id round if shock_d==1

ta shock_id_os if shock_id==96 & shock_d_==1
la li shock_id
*	some of these could be categorized into the categories not asked about. However, can't do mu


*	extent of effect 
*	are s10q2__? categories exclusie? 
la li selection
egen test = rowtotal(s10q2__*)
	ta test round	//	no, not exclusive, and only present in rounds 2&3 
	*	ignore these for the panel 
	drop s10q2__* test
	
*	ignore round 16 specific vars 
	drop s10q3-s10q9
	
	*	make slightly cleaner but leave at shock level, then collapse to hh level in a second step
	g shock_yn = (shock_d_==1) if !mi(shock_d_)
	la var shock_yn	"Affected by shock since last interaction"
	ds s10q3__*, not(type string)
	loc vars `r(varlist)'	//	this is simply automated here, could manually set the order to harmonize later
// 	loc vars s10q3__1 s10q3__6 s10q3__7 s10q3__8 s10q3__9 s10q3__11 s10q3__12 s10q3__13 s10q3__14 s10q3__15 s10q3__16 s10q3__17 s10q3__18 s10q3__19 s10q3__20 s10q3__21 s10q3__22 s10q3__96
	foreach v of local vars {
		loc i = substr("`v'",strpos("`v'","__")+2,length("`v'")-strpos("`v'","__")-1)
		g shock_cope_`i' = `v'
		loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
		loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
		loc clnlbl = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
		la var shock_cope_`i'	"`clnlbl' to cope with shock"
		}
	g shock_cope_os = strtrim(lower(s10q3_os))
	la var shock_cope_os	"Specify other way to cope with shock"

	
	
	
	keep y4_hhid round shock*
	isid y4_hhid round shock_id
	sort y4_hhid round shock_id
	
	*	harmonize shock_code
	run "${do_hfps_util}/label_shock_code.do"
	la li shock_id shock_code
	g shock_code=shock_id, a(shock_id)
	recode shock_code (1=21)(2=22)(3=23)(4=24)(14=25)(13=1)	
	la val shock_code shock_code
	inspect shock_code
	assert r(N_undoc)==0
	ta shock_id shock_code
	drop shock_id
		
	isid y4_hhid round shock_code
	sort y4_hhid round shock_code
    sa "${tmp_hfps_mwi}/panel/shocks.dta", replace 
	
*	move to household level for analysis
u  "${tmp_hfps_mwi}/panel/shocks.dta", clear

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
collapse (max) shock_yn* shock_cope*, by(y4_hhid round)
 foreach x of varlist shock_yn* shock_cope* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)

isid y4_hhid round
sort y4_hhid round
sa "${tmp_hfps_mwi}/panel/hh_shocks.dta", replace 
	
ex


*	modifications for construction of grand panel 
u  "${tmp_hfps_mwi}/panel/cover.dta", clear


egen pnl_hhid = group(y4_hhid)
egen pnl_admin1 = group(hh_a00)
egen pnl_admin2 = group(hh_a01)
egen pnl_admin3 = group(r0_ta_code)

g pnl_urban = urb_rural=="urban":hh_a03b
g pnl_wgt = wgt 

sa "${tmp_hfps_mwi}/panel/pnl_cover.dta", replace 











