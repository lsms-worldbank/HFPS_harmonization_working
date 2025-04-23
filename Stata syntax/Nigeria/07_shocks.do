
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d shock_cd* s10* using	"${raw_hfps_nga1}/r1_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r3_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r8_sect_10.dta"

d using	"${raw_hfps_nga2}/p2r6_sect_10.dta"		//	simplified capture of coping mechanisms 
d using	"${raw_hfps_nga2}/p2r10_sect_10.dta"	//	simplified capture of coping mechanisms 


label_inventory "${raw_hfps_nga1}", pre(`"r"')   suf(`"_sect_10.dta"')
label_inventory "${raw_hfps_nga2}", pre(`"p2r"')   suf(`"_sect_10.dta"')
qui : label_inventory "${raw_hfps_nga1}", pre(`"r"')   suf(`"_sect_10.dta"') vallab retain
li lname value label matches rounds if !inlist(lname,"lga","sector","state","state_id","zone"), sepby(lname)
qui : label_inventory "${raw_hfps_nga2}", pre("p2r") suf("_sect_10.dta") vallab retain
li lname value label matches rounds if !inlist(lname,"lga","sector","state","state_id","zone"), sepby(lname)

u "${raw_hfps_nga1}/r1_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r3_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r8_sect_10.dta", clear
la li shock_cd s10q1	//	added 13 fuel cost
u "${raw_hfps_nga2}/p2r6_sect_10.dta", clear
la li shock_cd s10q1 s10q3 	//	code shift
u "${raw_hfps_nga2}/p2r10_sect_10.dta", clear
la li shock_cd s10q1 s10q2 	//	code shift again 



u "${raw_hfps_nga2}/p2r6_sect_10.dta", clear
la li shock_cd s10q1 s10q3 	//	code shift 

ta shock_cd s10q1
recode shock_cd (1=5)(2=6)(3=7)(4=10)(5/7=31)(8=11)(9=12)(10=8)(11=1)(12=27), copyrest gen(shock_alt)

cleanstr shock_cd_os, names(shock_alt_os)

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
*	just ignoring the string s10q3_os for now -> carry them through
cleanstr s10q3_os

	bys hhid shock_alt : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = str if obs==X
	

*	this simple approach will mean we lose some of the o/s  
collapse (lastnm) shock_alt_os (min) s10q1 (max) s10q3__*  (firstnm) os?, by(hhid shock_alt)
ren shock_alt* shock_cd*
loc y s10q3_os
	g `y'=""
	forv i=1/$max {
		tempvar l0 
		g `l0'=length(`y')
		replace `y' = os`i' if `l0'==0 & !mi(os`i')
		replace `y' = `y' + "^ " + os`i' if `l0'>0 & !mi(os`i') & strpos(`y',os`i')==0
		drop `l0'
	}
	li `y' if strpos(`y',"^")>0, sep(0)
// 	replace shock_cope_os = subinstr(shock_cope_os,"^",", ",.)
	drop os* 

tempfile r18
sa		`r18'



u "${raw_hfps_nga2}/p2r10_sect_10.dta", clear
la li shock_cd s10q1 s10q2 	//	code shift 

ta shock_cd s10q1
recode shock_cd (1=5)(2=6)(3=7)(4=10)(5=11)(6=12)(7 71 72=31)(8=1)(10=21)	/*
*/	(11=22)(12=23)(13=51)(14=9)(15=52)(16=53), copyrest gen(shock_alt)
cleanstr s10q1_os, names(shock_alt_os) 
ta shock_alt_os
li shock_alt_os if length(shock_alt_os)>1 & shock_alt==96, sep(0)
recode shock_alt (96=14) if inlist(shock_alt_os,"hunger (lack of food)","lack of money")
recode shock_alt (96=30) if inlist(shock_alt_os,"electricity problems","lack of water and health facilities","lack of drinking water")
*	complaints about high cost of fertilizer are a special case. We will not recode here. 
recode shock_alt (96=64) if inlist(shock_alt_os,"health issues in the household","health issues within the family","sickness and diseases among household members")
recode shock_alt (96=65) if inlist(shock_alt_os,"erosion")
recode shock_alt (96=67) if inlist(shock_alt_os,"animals grazed on his maize","destruction of our crops by cattles. cattle entered our farms and ate our crops")
recode shock_alt (96=68) if inlist(shock_alt_os,"fire outbreak in his shop")
recode shock_alt (96=72) if inlist(shock_alt_os,"disputes with neighboring villages","insecurity issues","insecurity")
replace shock_alt_os = "" if shock_alt!=96

*	now adjust the coping mechanisms and reshape to match phase 1 version
la li s10q2
egen s10q3__1 = anymatch(s10q2_?), v(1/5)
egen s10q3__6 = anymatch(s10q2_?), v(6)
egen s10q3__31= anymatch(s10q2_?), v(7)
egen s10q3__7 = anymatch(s10q2_?), v(8)
egen s10q3__8 = anymatch(s10q2_?), v(9)
egen s10q3__10= anymatch(s10q2_?), v(10)
egen s10q3__9 = anymatch(s10q2_?), v(11)
egen s10q3__11= anymatch(s10q2_?), v(12)
egen s10q3__12= anymatch(s10q2_?), v(13)
egen s10q3__13= anymatch(s10q2_?), v(14)
egen s10q3__14= anymatch(s10q2_?), v(15)
egen s10q3__15= anymatch(s10q2_?), v(16)
egen s10q3__16= anymatch(s10q2_?), v(17)
egen s10q3__17= anymatch(s10q2_?), v(18)
egen s10q3__18= anymatch(s10q2_?), v(19)
egen s10q3__19= anymatch(s10q2_?), v(20)
egen s10q3__20= anymatch(s10q2_?), v(21)
egen s10q3__21= anymatch(s10q2_?), v(22)
egen s10q3__32= anymatch(s10q2_?), v(23)
egen s10q3__33= anymatch(s10q2_?), v(24)
egen s10q3__41= anymatch(s10q2_?), v(25)
egen s10q3__42= anymatch(s10q2_?), v(26)
egen s10q3__43= anymatch(s10q2_?), v(27)

egen s10q3__96= anymatch(s10q2_?), v(96)

	cleanstr s10q2_os
	bys hhid shock_alt : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = str if obs==X
	

*	this simple approach will mean we lose some of the o/s  
collapse (lastnm) shock_alt_os (min) s10q1 (max) s10q3__* (firstnm) os*, by(hhid shock_alt)
ren shock_alt* shock_cd*
loc y s10q3_os
	g `y'=""
	forv i=1/$max {
		tempvar l0 
		g `l0'=length(`y')
		replace `y' = os`i' if `l0'==0 & !mi(os`i')
		replace `y' = `y' + "^ " + os`i' if `l0'>0 & !mi(os`i') & strpos(`y',os`i')==0
		drop `l0'
	}
	li `y' if strpos(`y',"^")>0, sep(0)
// 	replace shock_cope_os = subinstr(shock_cope_os,"^",", ",.)
	drop os* 


tempfile r22
sa		`r22'


#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_10.dta"
	"${raw_hfps_nga1}/r3_sect_10.dta"
	"${raw_hfps_nga1}/r8_sect_10.dta"
	
	`r18'	
	`r22'	
, gen(round);
#d cr

	la drop _append
	la val round 
	replace round=round+1 if round>1
	replace round=round+4 if round>3
	replace round=round+9 if round>8
	replace round=round+3 if round>18
	assert inlist(round,1,3,8,18,22)
	ta round 	
	isid hhid shock_cd round
	sort hhid shock_cd round

	d using "${tmp_hfps_nga}/cover.dta"
	mer m:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(s12q5)
	ta round _merge	//	perfect
// 	keep if inlist(round,1,3,8,18,22)
	keep if _merge==3
	ta s12q5
	drop _merge s12q5
	
	ta shock_cd round if s10q1==1
	la def shock_cd 13 "13. Increase in the price of fuel/transportation", add
	
	ta shock_cd_os
	cleanstr shock_cd_os
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
	cleanstr s10q3_os, names(shock_cope_os)
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
sa "${tmp_hfps_nga}/shocks.dta", replace 

*	move to household level for analysis
u  "${tmp_hfps_nga}/shocks.dta", clear

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
assert  mi(shock_cope_os) if shock_cope_96!=1

*	verify that missing-ness is intact
tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
	ds shock_cope*, not(type string)
	loc d_shock_cope `r(varlist)'
tabstat `d_shock_cope', by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)

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
sa "${tmp_hfps_nga}/hh_shocks.dta", replace 
u  "${tmp_hfps_nga}/hh_shocks.dta", clear 

 	mer 1:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(s12q5)
	ta round _merge	//	what are the rules for inclusion in this dataset? 
	keep if inlist(round,1,3,8,18)
	ta s12q5 _merge	//	very good 
	
	ex
*	modifications for construction of grand panel 
u "${tmp_hfps_nga}/cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_wgt = wgt 

sa "${tmp_hfps_nga}/pnl_cover.dta", replace 







