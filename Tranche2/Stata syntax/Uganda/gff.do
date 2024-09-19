


u "${tmp_hfps_uga}/panel/access.dta", clear
ta item round if inlist(item,11) | inrange(item,51,59)
	*	rounds 1-7 
{
	dir "${raw_hfps_uga}"
#d ; 
wordsearch "*ocket* *OCKET*", dir(
	"${raw_hfps_uga}/round1"
	"${raw_hfps_uga}/round2"
	"${raw_hfps_uga}/round3"
	"${raw_hfps_uga}/round4"
	"${raw_hfps_uga}/round5"
	"${raw_hfps_uga}/round6"
	"${raw_hfps_uga}/round7"
	"${raw_hfps_uga}/round8"
	"${raw_hfps_uga}/round9"
	"${raw_hfps_uga}/round10"
	"${raw_hfps_uga}/round11"
	"${raw_hfps_uga}/round12"
	"${raw_hfps_uga}/round13"
	"${raw_hfps_uga}/round14"
	"${raw_hfps_uga}/round15"
	"${raw_hfps_uga}/round16"
	"${raw_hfps_uga}/round17"
	"${raw_hfps_uga}/round18"
	) retain; 
#d cr 
li name vallab varlab file, sepby(dir)
	*	round 5 only 
li dir file, sepby(dir)
egen r = ends(dir), last punct(/)
destring r, ignore(round) replace
sort r
format r %9.0g
li name vallab r file if file!="Interview_info.dta", sepby(r)
u	"${raw_hfps_uga}/round1/SEC6.dta", clear
la li income_loss__id	//	nothing specific to work with here

u	"${raw_hfps_uga}/round8/SEC4A_2.dta", clear	//	yes
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
*/

*	need to put rounds 9/15 17 with med services into access
d using	"${raw_hfps_uga}/round1/SEC6.dta"
d using	"${raw_hfps_uga}/round8/SEC4.dta"	//	new version, identified at hhid goods_access__id level
d using	"${raw_hfps_uga}/round8/SEC4A_2.dta"	//	yes, this is health. need to pull into access.do
d using	"${raw_hfps_uga}/round9/SEC2A_2.dta"	//	as in r8
d using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round15/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round17/SEC4.dta"	//	as in r8

*	can treat rounds 8-13 in a batch 

}

*	going round by round
run "${do_hfps_util}/label_access_item.do"	//	defines label program 


{	/*	r8+ (phase 2) access	*/


{	/*	r8+ (phase 2) health	*/
*	different verion, append into single dataset and deal with jointly
d using	"${raw_hfps_uga}/round8/SEC4A_1.dta"	
d using	"${raw_hfps_uga}/round9/SEC4A_1.dta"	//	small N
d using	"${raw_hfps_uga}/round10/SEC2A_1.dta"	
d using	"${raw_hfps_uga}/round11/SEC2A_1.dta"	
d using	"${raw_hfps_uga}/round12/SEC2A_1.dta"	
d using	"${raw_hfps_uga}/round13/SEC2A_1.dta"	
d using	"${raw_hfps_uga}/round15/SEC2A_1.dta"	
d using	"${raw_hfps_uga}/round17/SEC2A_1.dta"	

d using	"${raw_hfps_uga}/round8/SEC4A_2.dta"	//	wide by individual
d using	"${raw_hfps_uga}/round9/SEC4A_2.dta"	//	long by individual
d using	"${raw_hfps_uga}/round10/SEC2A_2.dta"	//	l by ind, naming convention differs from r8/9
d using	"${raw_hfps_uga}/round11/SEC2A_2.dta"	//	l by ind
d using	"${raw_hfps_uga}/round12/SEC2A_2.dta"	//	
d using	"${raw_hfps_uga}/round13/SEC2A_2.dta"	
d using	"${raw_hfps_uga}/round15/SEC2A_2.dta"	
d using	"${raw_hfps_uga}/round17/SEC2A_2.dta"	
	*	10-17 appear consistent 



{	/*check for stability across time */
	*	basic structure 
qui {
	preserve
foreach r of numlist 10/13 15 17 {
	u "${raw_hfps_uga}/round`r'/SEC2A_2.dta", clear
	d, replace clear
	tempfile r`r'
	sa		`r`r''
}
u `r10', clear
foreach r of numlist 10/13 15 17 {
	mer 1:1 name vallab varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group(_??), label missing
}
// li name vallab varlab rounds, sep(0) clean
li name vallab varlab rounds if strpos(name,"s2aq")>0 | strpos(name,"s1q")>0, sep(0) clean
	restore
	
qui {	/*	health codes	*/
	preserve
foreach r of numlist 10/13 15 17 {
	u "${raw_hfps_uga}/round`r'/SEC2A_2.dta", clear
	la dir
	uselabel `r(labels)', clear
	tempfile r`r'
	sa		`r`r''
}
u `r10', clear
foreach r of numlist 10/13 15 17 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group( _??), label missing
}
li lname value label rounds, sepby(lname)
	restore


d s4q1c__? using	"${raw_hfps_uga}/round9/SEC4.dta"	//	as in r8
d s4q1c__? using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d s4q1c__? using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8 mainly, s4q1c__6-s4q1c__9 recoded, label indicates the s4q2b question actually
d s4q1c__? using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d s4q1c__? using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8
d s4q1c__? using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8

d s4q2b__? using	"${raw_hfps_uga}/round9/SEC4.dta"	//	as in r8
d s4q2b__? using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d s4q2b__? using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8 mainly, s4q1c__6-s4q1c__9 recoded, label indicates the s4q2b question actually
d s4q2b__? using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d s4q2b__? using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8

}

*	split 8 and 9 from 10/17, due to individual vs hh level  
{	/*	r8p (phase2) health	*/

{	/*	round 8	*/
u	"${raw_hfps_uga}/round8/SEC4A_2.dta", clear
drop s4aq04b__*
ta medical_service__id
la li medical_service__id
g item = cond(medical_service__id==1,58,medical_service__id+49)
isid hhid item

ta s4aq07
la li s4aq07	//	standard
g care_place=s4aq07
ta s4aq08
g care_oop_any = (s4aq08==1) if !mi(s4aq08)

d s4aq09?
d s4aq09*	//	we will do away with the distinction bewteen prescription and non-prescription drugs
recode s4aq09b s4aq09c s4aq09d s4aq09e (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

su s4aq09a yy zz s4aq09f
tabstat s4aq09a yy zz s4aq09f, by(care_oop_any) s(n mean)
recode s4aq09a yy zz s4aq09f (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s4aq09a yy zz s4aq09f (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s4aq10
recode s4aq10 (3=4)(4=5)(5=3), gen(care_satisfaction)


keep hhid item care_*

g round=    8
tempfile   r8
sa		  `r8'
}	/*	end 8	*/


{	/*	round 9	*/
u	"${raw_hfps_uga}/round9/SEC4A_2.dta", clear
ta medical_service__id
la li medical_service__id
g item = cond(medical_service__id==1,58,medical_service__id+49)
isid hhid hh_roster__id item

*	access items 
d s4aq07*
tabstat s4aq07*, s(sum n)
egen abc = rowtotal(s4aq07*),m
ta abc
la val s4aq07* .
egen def = group(s4aq07*), label
ta def if abc>1
*	we will make use of the variable label order as an implied order of treatment formality
forv i=1/9 {
	g i`i' = `i' if s4aq07__`i'==1
}
egen care_place = rowmin(i?)
// g care_place=s4aq07
ta s4aq08
g care_oop_any = (s4aq08==1) if !mi(s4aq08)

d s4aq09?
d s4aq09*	//	we will do away with the distinction bewteen prescription and non-prescription drugs
recode s4aq09b s4aq09c s4aq09d s4aq09e (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

su s4aq09a yy zz s4aq09f
tabstat s4aq09a yy zz s4aq09f, by(care_oop_any) s(n mean)
recode s4aq09a yy zz s4aq09f (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s4aq09a yy zz s4aq09f (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s4aq10
recode s4aq10 (3=4)(4=5)(5=3), gen(care_satisfaction)


*	collapse to hh x item level 
ta item care_oop_any,m
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
	, by(hhid item); 
#d cr
ta item care_oop_any,m

g round=    9
tempfile   r9
sa		  `r9'
}	/*	end 9	*/


{	/*	round 10+ health	*/
#d ; 
clear; append using
	"${raw_hfps_uga}/round10/SEC2A_2.dta"
	"${raw_hfps_uga}/round11/SEC2A_2.dta"
	"${raw_hfps_uga}/round12/SEC2A_2.dta"
	"${raw_hfps_uga}/round13/SEC2A_2.dta"	
	"${raw_hfps_uga}/round15/SEC2A_2.dta"	
	"${raw_hfps_uga}/round17/SEC2A_2.dta"
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+9
replace round=round+1 if round>13
replace round=round+1 if round>15
ta round
isid hhid round hh_roster__id health_service__id

ta health_service__id
la li health_service__id	//	will equate outpatient with adult health and inpatient with emergency
recode health_service__id (1=58)(2=51)(3=52)(4=53)(5=55)(6=56)(7=57)(8=59), gen(item)
isid hhid round hh_roster__id item


ta s2aq07
la li s2aq07	//	standard
g care_place=s2aq07
ta s2aq08
g care_oop_any = (s2aq08==1) if !mi(s2aq08)

d s2aq09?
d s2aq09*	//	we will do away with the distinction bewteen prescription and non-prescription drugs
recode s2aq09b s2aq09c s2aq09d s2aq09e (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

su s2aq09a yy zz s2aq09f
tabstat s2aq09a yy zz s2aq09f, by(care_oop_any) s(n mean)
recode s2aq09a yy zz s2aq09f (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s2aq09a yy zz s2aq09f (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s2aq10
recode s2aq10 (3=4)(4=5)(5=3), gen(care_satisfaction)


keep hhid round item care_*

*	collapse to hh x round x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
	, by(hhid round item); 
#d cr
ta item round

drop if item==59 & !inlist(round,11,12)

tempfile    r10p
sa		   `r10p'
}	/*	end r10p health	*/

*	aggregate health 
clear
append using `r8' `r9' `r10p'
isid hhid round item

ta item round

*	get item 11 
preserve
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
	, by(hhid round); 
#d cr
g item=11
tempfile item11
sa		`item11'
restore
append using `item11'
isid hhid round item

tempfile    r8phealth
sa		   `r8phealth'
}	/*	end r8phealth	*/



/*	append all rounds	*/
clear
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8phealth' `r8pfood', nolabel
isid	hhid round item
order	hhid round item
sort	hhid round item

ta item
label_access_item
ta item round

la var care_place			"Place where care was received"
recode care_place -96=96
do "${do_hfps_util}/label_care_place.do"
la var care_oop_any			"Any out-of-pocket payment made for care"
la var care_oop_d_services	"Any out-of-pocket payment for services"
la var care_oop_d_goods		"Any out-of-pocket payment for drugs"
la var care_oop_d_transit	"Any out-of-pocket payment for transit to care"
la var care_oop_d_other		"Any out-of-pocket payment for other care-related items"
la var care_oop_v_services	"Value of out-of-pocket payment for services"
la var care_oop_v_goods		"Value of out-of-pocket payment for drugs"
la var care_oop_v_transit	"Value of out-of-pocket payment for transit to care"
la var care_oop_v_other		"Value of out-of-pocket payment for other care-related items"
la var care_oop_value		"Value of out-of-pocket payments for care"
la var care_satisfaction	"Satisfaction with care recieved"


sa "${tmp_hfps_uga}/panel/gff.dta", replace 

cap : 	prog drop	label_access_item

ex

