


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
dir "${raw_hfps_uga}/round18", w

// d using	"${raw_hfps_uga}/round1/SEC11.dta"
// d using	"${raw_hfps_uga}/round2/SEC11.dta"
// d using	"${raw_hfps_uga}/round3/SEC11.dta"
// d using	"${raw_hfps_uga}/round4/SEC11.dta"
// d using	"${raw_hfps_uga}/round5/SEC11.dta"
// d using	"${raw_hfps_uga}/round6/SEC11.dta"
// d using	"${raw_hfps_uga}/round7/SEC11.dta"
d using	"${raw_hfps_uga}/round8/SEC11.dta"
// d using	"${raw_hfps_uga}/round9/SEC11.dta"
// d using	"${raw_hfps_uga}/round10/SEC11.dta"
// d using	"${raw_hfps_uga}/round11/SEC11.dta"
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d using	"${raw_hfps_uga}/round13/SEC11.dta"
d using	"${raw_hfps_uga}/round15/SEC11.dta"
d using	"${raw_hfps_uga}/round17/SEC11.dta"


loc r=8
u "${raw_hfps_uga}/round`r'/SEC11.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
tempfile base
sa      `base'
foreach r of numlist 12 13 {
	u "${raw_hfps_uga}/round`r'/SEC11.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>0
li name _* if matches>0, nol sep(0)
li name var8 if matches>0, sep(0)

*/

d using	"${raw_hfps_uga}/round8/SEC11.dta"
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d using	"${raw_hfps_uga}/round13/SEC11.dta"
d using	"${raw_hfps_uga}/round15/SEC11.dta"
d using	"${raw_hfps_uga}/round17/SEC11.dta"

u	"${raw_hfps_uga}/round8/SEC11.dta", clear
la li food_prices__id s11q02a s11q02b	//	need a recode 
u	"${raw_hfps_uga}/round12/SEC11.dta", clear
la li food_prices__id s11q02a s11q02b
u	"${raw_hfps_uga}/round13/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b
u	"${raw_hfps_uga}/round15/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b
u	"${raw_hfps_uga}/round17/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b

foreach r of numlist 8 12 13 15 17 {
u	"${raw_hfps_uga}/round`r'/SEC11.dta", clear
cap : uselabel food_prices__id s11q02a s11q02b	
if _rc!=0 {
	cap : uselabel food_prices__id s11q03a s11q03b	
	replace lname = subinstr(lname,"s11q03","s11q02",1)
}
cleanstr label
tempfile r`r'
sa		`r`r''
}
u `r8', clear
foreach r of numlist 8 12 13 15 17 {
mer 1:1 lname value str using `r`r'', gen(_`r')
recode _`r' (1 .=.)(2 3=`r')
la val _`r' .
la drop _merge
}
egen rounds = group(_? _??), label missing
li lname value str rounds, sepby(lname)


u	"${raw_hfps_uga}/round12/SEC11.dta", clear
la li food_prices__id s11q02a s11q02b
u	"${raw_hfps_uga}/round13/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b
u	"${raw_hfps_uga}/round15/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b
u	"${raw_hfps_uga}/round17/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b



u "${raw_lsms_uga}/HH/gsec15b.dta", clear
la li itmcd	//	no conversion factor available, but we will harmonize the codes anyway
ta CEB01 if CEB03==1
u "${raw_lsms_uga}/HH/gsec15c.dta", clear
la li CEC02
ta CEC02 if CEC02_1==1

u	"${raw_hfps_uga}/round8/SEC11.dta", clear
la li food_prices__id
*	reogranize food_prices__id to harmonize with rounds 12/13
recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)(7=1237)	/*
*/	(8=140)(9=105)(10=107)(11=141)(12=144)(13=135)(14=136)(15=168)(16=138)	/*
*/	(17=147)(18=1271)(19=1491)(20=1501), gen(item)
run "${do_hfps_uga}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}
keep hhid item s11q*
g   round=8, a(hhid)
tempfile r8
sa		`r8'


u	"${raw_hfps_uga}/round12/SEC11.dta", clear
la li food_prices__id
ta s11q02a s11q02b if food_prices__id==12	//	have to split food_prices__id 12 by unit

recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)	/*
*/	(8=141)(9=105)  (11=140)(12=100)(13=1312) (15=135)(16=136)	/*
*/	(18=138)(19=147)(20=1271)(21=1491)(22=1501)(23=8888)	/*
*/	(24=4623)(25=4622)(26=308)(28=1082)(30=144)(31=452) , gen(item)
// recode item 101=102 if s11q02a=="cluster":s11q02a 
run "${do_hfps_uga}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}

keep hhid item s11q*
g   round=12, a(hhid)
tempfile r12
sa		`r12'

#d ; 
clear; append using
	"${raw_hfps_uga}/round13/SEC11.dta"
	"${raw_hfps_uga}/round15/SEC11.dta"
	"${raw_hfps_uga}/round17/SEC11.dta"
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+12
replace round=round+1 if round>13
replace round=round+1 if round>15
isid round hhid food_prices__id
la li food_prices__id	//	consistent with round 12, but minus soap
ta s11q03a s11q03b if food_prices__id==12	//	have to split matooke by unit to match organizational approach in 2019

recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)	/*
*/	(8=141)(9=105)  (11=140)(12=100)(13=1312) (15=135)(16=136)	/*
*/	(18=138)(19=147)(20=1271)(21=1491)(22=1501)(23=8888)	/*
*/	(24=4623)(25=4622)(26=308)(28=1082)(30=144) , gen(item)
// recode item 101=102 if s11q03a=="CLUSTER":s11q03a 
run "${do_hfps_uga}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}
drop food_prices__id	// labels not harmonious between rounds 

*	need to reorganize to append
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d s11*

ren s11q02			s11q01a
ren s11q03a			s11q02a
ren s11q03a_Other	s11q02a_os
ren s11q03b			s11q02b
ren s11q04			s11q02c
ren s11q05			s11q03
ren s11q09			s11q04
order s11q04, a(s11q03)

assert mi(s11q02a_os)	//	nothing
drop s11q02a_os

keep round hhid item s11q*
// g   round=13, a(hhid)
tempfile r13p
sa		`r13p'


clear
append using `r8' `r12' `r13p'
isid hhid item round

ta item round 

ta s11q02a s11q02b,m	//	some undocumented, have to check back on this 
#d ; 
la def s11q02a 
          11 "basins"
          12 "bar"
          13 "cluster"
          14 "BAGS (50 KGs)"
          15 "BAGS (100 KGs)"
          16 "TRAY (30 EGGs)"
		  , add; 
#d cr 
ta s11q02a s11q02b,m	//	some undocumented, have to check back on this 
ta item s11q02a
// egen unit = group(s11q02a s11q02b), label missing

g kg = 1 if inlist(s11q02a,1,2)
la var kg		"Quantity (standard units)"
la li s11q02b
replace kg =	cond(s11q02b==4, 10*0.001,/*
*/				cond(s11q02b==5, 15*0.001,/*
*/				cond(s11q02b==6, 20*0.001,/*
*/				cond(s11q02b==7,100*0.001,/*
*/				cond(s11q02b==8,250*0.001,/*
*/				cond(s11q02b==9,500*0.001,/*
*/				.)))))) if inrange(s11q02b,4,9) 

ta item
la li item s11q02a s11q02b
ta s11q02a s11q02b if item=="banana food":item,m
ta s11q02a s11q02b if item=="banana sweet":item,m
ta s11q02a s11q02b if item=="beans":item,m
ta s11q02a s11q02b if item=="sweet potatoes":item,m

preserve
// dir "${hfps}/Input datasets/Uganda"
// d using "${hfps}/Input datasets/Uganda/conversionfactors_UGA.dta"
u "${hfps}/Input datasets/Uganda/conversionfactors_UGA.dta", clear
li, abbrev(20)
recode itemcode (8=141)(9=105)(21=100)(22=1312), gen(item)
ren (unitcode size)(s11q02a s11q02b)
tempfile cf
sa		`cf'
restore 
mer m:1 item s11q02a s11q02b using `cf', keep(1 3) gen(_cf) keepus(conversion)
replace kg = conversion if _cf==3
drop _cf conversion

*	
ta s11q02a s11q02b if item=="eggs":item,m
tabstat s11q04 if item=="eggs":item, by(s11q02a) c(s) s(n me p50 p5 p95) format(%9.0fc) //	what is "Number of  EGGs"
ta round if s11q02a=="Number of  EGGs":s11q02a	//	can't reliably convert this without more information
	*	0.044 kg/egg is based on Trail (1962)
replace kg =      0.044 if item=="eggs":item & inlist(s11q02a,7)
replace kg = 30 * 0.044 if item=="eggs":item & inlist(s11q02a,16)

ta item s11q02a if !mi(kg)
ta item s11q02a if  mi(kg)



decode item, gen(itemstr)
g		item_avail  = (s11q01==1) 
la var	item_avail	"Item is available for sale"

*	lacking many conversion factors, we will simply bring the raw unit through 
decode s11q02a, gen(xx)
decode s11q02b, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

ta s11q04
g		q=1		//	 this is an implied variable, but filling in to make harmonized data more sensible
la var	q	"Quantity of [unit]"
g		lcu=s11q04 if s11q04>0
la var	lcu	"Cost (LCU)"
g		unitcost=lcu/q
la var	unitcost	"Unit cost (LCU/unit)"
ta item s11q02a if inlist(s11q02a,1,2)
g		price=lcu/kg
la var	price		"Price (LCU/standard unit)"

*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)

*	simply ignoring the add'l questions added in round 13 for this panel aggregation exercise

keep  hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item
sa "${tmp_hfps_uga}/price.dta", replace 
u  "${tmp_hfps_uga}/price.dta", clear 
 su




