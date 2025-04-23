
********************************************************************************
*	data investigation sandbox, optionally disabled when run from top 
********************************************************************************
loc investigate=0	//	set=1 to enable investigation when run from top
if `investigate'==1 {
dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*coping*", w

d using	"${raw_hfps_mwi}/sect10_coping_r2.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r3.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r7.dta"
d using	"${raw_hfps_mwi}/sect10_coping_r15.dta"	//	coping matches NG code
d using	"${raw_hfps_mwi}/sect10_coping_r16.dta"	//	alternate coping codes
d using	"${raw_hfps_mwi}/sect10_coping_r18.dta"	//	coping matches NG code


label_inventory "${raw_hfps_mwi}", pre("sect10_coping_r") suf(".dta") varn vallab
label_inventory "${raw_hfps_mwi}", pre("sect10_coping_r") suf(".dta") vardetail retain
g code=subinstr(name,"s10q3__","",1) if strpos(name,"s10q3__")>0
destring code, replace
sort code rounds
egen tail = ends(varlab), punct(:) tail
li tail code rounds if strpos(name,"s10q3__")>0, sep(0)

d s10q8__* using	"${raw_hfps_mwi}/sect10_coping_r16.dta"	//	alternate coping codes

********************************************************************************
}	/*	end bracket to optionally disable investigatin when run from the top	*/
********************************************************************************


*	dealing with different coping codes here 
u	"${raw_hfps_mwi}/sect10_coping_r16.dta"	, clear
la li selection

g  s10q3__1 =  s10q8__3
egen s10q3__6 = rowmax(s10q8__4 s10q8__5)	//	combining add'l income activities with renting out more things 
g s10q3__14 =  s10q8__7
g s10q3__15 =  s10q8__8
g s10q3__16 =  s10q8__1
g s10q3__20 = s10q8__12
g s10q3__21 = s10q8__13
g s10q3__96 = s10q8__96
tempfile r16
sa		`r16'


u	"${raw_hfps_mwi}/sect10_coping_r20.dta"	, clear
tabstat s10q3__*
d s10q3__*
ren s10q3__* _*
egen s10q3__1 = rowmax(_1 _2 _3 _4 _5)
egen s10q3__6 = rowmax(_10)
egen s10q3__7 = rowmax(_11)
egen s10q3__8 = rowmax(_12)
egen s10q3__9 = rowmax(_13)
egen s10q3__10= rowmax(_7)
egen s10q3__11= rowmax(_14)
egen s10q3__12= rowmax(_15)
egen s10q3__13= rowmax(_16)
egen s10q3__14= rowmax(_17)
egen s10q3__15= rowmax(_18)
egen s10q3__16= rowmax(_19)
egen s10q3__17= rowmax(_20)
egen s10q3__18= rowmax(_21)
egen s10q3__19= rowmax(_22)
egen s10q3__20= rowmax(_23)
egen s10q3__21= rowmax(_24)
egen s10q3__31= rowmax(_6)
egen s10q3__32= rowmax(_8)
egen s10q3__33= rowmax(_9)
egen s10q3__96= rowmax(_96)
order s10q3__*, b(_1)
drop _1-_96
tempfile r20
sa		`r20'



#d ; 
clear; append using
	"${raw_hfps_mwi}/sect10_coping_r2.dta"
	"${raw_hfps_mwi}/sect10_coping_r3.dta"
	"${raw_hfps_mwi}/sect10_coping_r7.dta"
	"${raw_hfps_mwi}/sect10_coping_r15.dta"
	`r16'
	"${raw_hfps_mwi}/sect10_coping_r18.dta"
	`r20'
	, gen(round);
#d cr 
isid y4_hhid shock_id round
la drop _append
la val round 
ta round 
replace round=round+1
replace round=round+3 if round>3
replace round=round+7 if round>7
replace round=round+1 if round>16
replace round=round+1 if round>18
ta round
assert inlist(round,2,3,7,15,16,18,20)
	la var round	"Survey round"

*	dealing with different shock code, reconciling to harmonized shock code 
la li Sec10_shocks__id
// recode shock_id (1=5) if round==16
recode shock_id (95=96)(13=1)(14=25) if !inlist(round,16,20), copyrest
recode shock_id (1=21)(2=22)(3=23)(4=24)(96=97) if round==16
recode shock_id (1 12=5)(2=6)(3=7)(4=10)(5/7=31)(8=11)(9=12)(10=8)(11=1)(12=27)	/*
*/	(13=21)(14=22)(15=23)(16=51)(17=9)(18=52)(19=53) if round==20

// ta shock_id_os	
cleanstr shock_id_os shock_os, stub(strs)
egen str = concat(strs?)
ta str round	//	10 copies of most, 9 of some

preserve
keep if !mi(str) & inlist(shock_id,95,96,97)
g first = substr(str,1,1)
bys str round : keep if _n==1
li round str, sepby(first)
restore
recode shock_id (95/97=9)  if inlist(str,"army worms")
recode shock_id (95/97=12) if inlist(str,"water is expensive")
recode shock_id (95/97=13) if inlist(str,"increase in non food items","increase in rent","increase of non food items")
recode shock_id (95/97=14) if inlist(str,"lack of food and money","lack of money","lack of money to buy mask","scarecity of money","shortage of food")
recode shock_id (95/97=21) if inlist(str,"drought")
recode shock_id (95/97=22) if inlist(str,"destruction of the family house by storm","disruption of houses due to heavy rain","distruction of dwelling due to heavy winds","lack of food due to delay of farm production","destruction of trees due to heavy rain")
recode shock_id (95/97=22) if inlist(str,"lightening","too cold")
recode shock_id (95/97=23) if inlist(str,"floods","much rainfall(floods)")
recode shock_id (95/97=24) if inlist(str,"cyclone","cyclone freddy","cyclone fredy problems","destruction of property due to cyclone")
recode shock_id (95/97=27) if inlist(str,"business disruption","business problems")
recode shock_id (95/97=28) if inlist(str,"end of marriage","marriage")
recode shock_id (95/97=29) if inlist(str,"few customers","lack of ganyu","not called by customers to build there house","scarcity of piece work")
recode shock_id (95/97=30) if inlist(str,"late coming of farm inputs e.g fertilizer","late coming of farm inputs")
recode shock_id (95/97=31) if inlist(str,"increase in road transport fairs","increase in transport service")
recode shock_id (95/97=51) if inlist(str,"heat waves","heatwave","heatwaves")
recode shock_id (95/97=53) if inlist(str,"collapsing of dwelling","corupsing of her house","disprution of his house","distruction of house","distrupution of house")
recode shock_id (95/97=53) if inlist(str,"destruction of buildings","destruction of dwelling","destruction of house","destruction of property","didtruction houses","disruption of his house","disruction of house","disruption of house","disruption of the house")
recode shock_id (95/97=53) if inlist(str,"distruction","disruction of house","distruption of house","fall of house")
recode shock_id (95/97=62) if inlist(str,"death of a child","death of child")
recode shock_id (95/97=63) if inlist(str,"death","death of a relative who murdered","death of his nephew due to cholera in mozambique","death of non hh members","death of relatives","funeral")
recode shock_id (95/97=63) if inlist(str,"death of relative","death's of relatives")
recode shock_id (95/97=64) if inlist(str,"accident","illiness of a family member","illness of children of the hhd","illness of hh member","illness of othe hh member")
ta str round if inlist(shock_id,95,96,97) & (s10q1==1 | s10q3==1),m
	//	nothing was specified for these shocks
	drop if inlist(shock_id,95,96,97)
	drop str strs? shock_id_os shock_os

ta shock_id round
tab2 round s10q1 s10q3, first m

egen shock_d_ = rowmin(s10q1 s10q3)
ta shock_id round if shock_d_==1,m

	*	harmonize shock_code
	run "${do_hfps_util}/label_shock_code.do"
	la li shock_code
	g shock_code=shock_id, a(shock_id)
	la val shock_code shock_code
	inspect shock_code
	assert r(N_undoc)==0
	ta shock_code shock_id
	drop shock_id
	ta shock_code round if shock_d_==1,m

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
	tabstat shock_cope_*, by(round)
	cleanstr s10q3_os, names(shock_cope_os)
	ta shock_cope_os
	la var shock_cope_os	"Specify other way to cope with shock"

	
	
	
// 	keep y4_hhid round shock*
	duplicates report y4_hhid round shock_code	//	5 & 
	duplicates tag y4_hhid round shock_code, gen(tag)
	numlabel shock_code, add
	ta shock_code round if tag>0
	numlabel shock_code, remove
	su tag	//	up to three copies are possible (max(tag)==2)
	
	bys y4_hhid round shock_code : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = shock_cope_os if obs==X
	
	ds shock_cope*, not(type string)
// 	loc copedums `r(varlist)'
	collapse (max) shock_yn `r(varlist)' (firstnm) os?, by(y4_hhid round shock_code)
	
	egen shock_cope_os=concat(os?), punct(^)
	ta shock_cope_os
	replace shock_cope_os = subinstr(shock_cope_os,"^^","",1)
	replace shock_cope_os = subinstr(shock_cope_os,"##n/a##","",1)	//	a one-off here 
	replace shock_cope_os = subinstr(shock_cope_os,"^","",2) if substr(shock_cope_os,1,1)=="^" & substr(shock_cope_os,length(shock_cope_os),1)=="^"
	ta shock_cope_os if strpos(shock_cope_os,"^")>0	 //	remainder are actual compound answers
	replace shock_cope_os = subinstr(shock_cope_os,"^","",1) if substr(shock_cope_os,1,1)=="^"
	replace shock_cope_os = substr(shock_cope_os,1,length(shock_cope_os)-1) if substr(shock_cope_os,length(shock_cope_os),1)=="^"
	replace shock_cope_os = subinstr(shock_cope_os,"^",", ",2)
	assert strpos(shock_cope_os,"^")==0
	drop os? 
	
	run "${do_hfps_util}/label_coping_vars"
	
	
	la var shock_yn	"Affected by shock since last interaction"
	
	
	isid y4_hhid round shock_code
	sort y4_hhid round shock_code
    sa "${tmp_hfps_mwi}/shocks.dta", replace 
	
*	move to household level for analysis
u  "${tmp_hfps_mwi}/shocks.dta", clear

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


	bys y4_hhid round (shock_code) : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = shock_cope_os if obs==X

 foreach x of varlist shock_yn* shock_cope_* {
 	loc lbl`x' : var lab `x'
 }

collapse (max) shock_yn* `d_shock_cope' (firstnm) os*,  by(y4_hhid round)
 foreach x of varlist shock_yn* shock_cope_* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)

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
	
isid y4_hhid round
sort y4_hhid round
sa "${tmp_hfps_mwi}/hh_shocks.dta", replace 
	
ex






