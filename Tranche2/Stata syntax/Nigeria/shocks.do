
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d shock_cd* s10* using	"${raw_hfps_nga1}/r1_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r3_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r8_sect_10.dta"

d using	"${raw_hfps_nga2}/p2r6_sect_10.dta"	//	simplified capture of coping mechanisms 



u "${raw_hfps_nga1}/r1_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r3_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r8_sect_10.dta", clear
la li shock_cd s10q1	//	added 13 fuel cost
u "${raw_hfps_nga2}/p2r6_sect_10.dta", clear
la li shock_cd s10q1 s10q3 	//	code shift 

ta shock_cd s10q1
recode shock_cd (1=5)(2=6)(3=7)(4=10)(5/7=13)(8=11)(9=12)(10=8)(11=1)(12=96), copyrest gen(shock_alt)
replace shock_cd_os="Reduction in work hours" if shock_cd==12 & s10q1==1
bys hhid (shock_cd) : egen multios = sum(shock_alt==96 & s10q1==1)
ta multios
li shock_cd shock_cd_os if multios==2, sepby(hhid) nol
g shock_alt_os = shock_cd_os
bys hhid (shock_cd) : replace shock_alt_os = shock_cd_os[_n-1] + " + " + shock_alt_os if shock_cd[_n-1]==12 & s10q1[_n-1]==1 & s10q1==1
li shock_cd shock_cd_os shock_alt_os if multios==2 & inlist(shock_cd,12,96), sepby(hhid) nol

*	now adjust the coping mechanisms and reshape to match phase 1 version
la li s10q3
egen s10q3__1 = anymatch(s10q3_?), v(1)
egen s10q3__6 = anymatch(s10q3_?), v(2)
egen s10q3__7 = anymatch(s10q3_?), v(3)
egen s10q3__8 = anymatch(s10q3_?), v(4)
egen s10q3__9 = anymatch(s10q3_?), v(5)
egen s10q3__11= anymatch(s10q3_?), v(6)
egen s10q3__12= anymatch(s10q3_?), v(7)
egen s10q3__13= anymatch(s10q3_?), v(8)
egen s10q3__14= anymatch(s10q3_?), v(9)
egen s10q3__15= anymatch(s10q3_?), v(10)
egen s10q3__16= anymatch(s10q3_?), v(11)
egen s10q3__17= anymatch(s10q3_?), v(12)
egen s10q3__18= anymatch(s10q3_?), v(13)
egen s10q3__19= anymatch(s10q3_?), v(14)
egen s10q3__20= anymatch(s10q3_?), v(15)
// egen s10q3__22= anymatch(s10q3_?), v(1)	//	not a coded option in r18 
egen s10q3__21= anymatch(s10q3_?), v(16)
egen s10q3__96= anymatch(s10q3_?), v(96)

bys hhid shock_alt (shock_cd) : egen multicopeos = sum(s10q3__96==1 & s10q1==1)
ta multicopeos

li hhid shock_cd shock_alt s10q3_os if multicopeos==3, sepby(shock_alt)
*	just ignoring the string s10q3_os for now 

*	this simple approach will mean we lose some of the o/s  
collapse (lastnm) shock_alt_os (min) s10q1 (max) s10q3__*, by(hhid shock_alt)
ren shock_alt* shock_cd*
tempfile r18
sa		`r18'
#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_10.dta"
	"${raw_hfps_nga1}/r3_sect_10.dta"
	"${raw_hfps_nga1}/r8_sect_10.dta"
	
	`r18'	
, gen(round);
#d cr

	la drop _append
	la val round 
	replace round=round+1 if round>1
	replace round=round+4 if round>3
	replace round=round+9 if round>8
	assert inlist(round,1,3,8,18)
	ta round 	
	isid hhid shock_cd round
	sort hhid shock_cd round

	d using "${tmp_hfps_nga}/panel/cover.dta"
	mer m:1 hhid round using "${tmp_hfps_nga}/panel/cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3
	ta s12q5
	drop _m s12q5
	
	ta shock_cd round if s10q1==1
	la def shock_cd 13 "13. Increase in the price of fuel/transportation", add
	
	ta shock_cd_os
	g str = strtrim(lower(shock_cd_os))
	li str if !mi(str) & shock_cd==96, sep(20)
	ta str	//	several of these seem more like the result of shocks than a specific shock
	drop str
	
	*	make slightly cleaner but leave at shock level, then collapse to hh level in a second step
	g shock_yn = (s10q1==1) if !mi(s10q1)
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

	
	
	keep hhid round shock*
	isid hhid round shock_cd
	sort hhid round shock_cd
	
*	harmonize shock_code
run "${do_hfps_util}/label_shock_code.do"
la li shock_cd shock_code 
g shock_code=shock_cd, a(shock_cd)
recode shock_code 13=31
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shock_cd shock_code
drop shock_cd

	isid hhid round shock_code
	sort hhid round shock_code
sa "${tmp_hfps_nga}/panel/shocks.dta", replace 

*	move to household level for analysis
u  "${tmp_hfps_nga}/panel/shocks.dta", clear

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
sa "${tmp_hfps_nga}/panel/hh_shocks.dta", replace 

 	mer 1:1 hhid round using "${tmp_hfps_nga}/panel/cover.dta", keepus(s12q5)
	ta round _m	//	what are the rules for inclusion in this dataset? 
	keep if inlist(round,1,3,8,18)
	ta s12q5 _m	//	very good 
	
	ex
*	modifications for construction of grand panel 
u "${tmp_hfps_nga}/panel/cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_wgt = wgt 

sa "${tmp_hfps_nga}/panel/pnl_cover.dta", replace 







