

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*access*", w
dir "${raw_hfps_mwi}/sect5_access_r*", w
dir "${raw_hfps_mwi}/*prices*", w
dir "${raw_hfps_mwi}/*swift*", w

d using	"${raw_hfps_mwi}/sect5_access_r1.dta"
d using	"${raw_hfps_mwi}/sect5_access_r2.dta"
d using	"${raw_hfps_mwi}/sect5_access_r3.dta"
d using	"${raw_hfps_mwi}/sect5_access_r4.dta"
d using	"${raw_hfps_mwi}/sect5_access_r5.dta"
d using	"${raw_hfps_mwi}/sect5_access_r6.dta"	//	pretty different
d using	"${raw_hfps_mwi}/sect5_access_r7.dta"
d using	"${raw_hfps_mwi}/sect5_access_r8.dta"
d using	"${raw_hfps_mwi}/sect5_access_r9.dta"
d using	"${raw_hfps_mwi}/sect5_access_r11.dta"
d using	"${raw_hfps_mwi}/sect5_access_r12.dta"
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r13.dta"
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r13.dta"
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r14.dta"
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r14.dta"
d using	"${raw_hfps_mwi}/sect5f_healthaccess1_r15.dta"
d using	"${raw_hfps_mwi}/sect5f_healthaccess2_r15.dta"
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew1_r15.dta"
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew2_r15.dta"
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv1_r15.dta"
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv2_r15.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r16.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r16.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r17.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r17.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r18.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r18.dta"
d using	"${raw_hfps_mwi}/sect5_accesss_r19.dta"
d using	"${raw_hfps_mwi}/sect5_access_r20.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccess_r20.dta"

d using	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r20.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r21.dta"	//	no access, just knowledge of price 

d using	"${raw_hfps_mwi}/sect11_transportprices_r17.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_transportprices_r19.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_transportprices_r20.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_transportprices_r21.dta"	//	yes access

d using	"${raw_hfps_mwi}/sect14_fuels_r16.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"	//	yes acces
d using	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"	//	yes acces
d using	"${raw_hfps_mwi}/sect11_fuelprices_r20.dta"	//	yes acces
d using	"${raw_hfps_mwi}/sect11_fuelprices_r21.dta"	//	yes acces

d using	"${raw_hfps_mwi}/sect14_swift_r17.dta"	//	no access
d using	"${raw_hfps_mwi}/sect14_swift_r21.dta"	//	no access

u	"${raw_hfps_mwi}/sect5_access_r1.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r2.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r3.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r4.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r5.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r6.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r7.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r8.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r9.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r11.dta"	, clear
u	"${raw_hfps_mwi}/sect5_access_r12.dta"	, clear



*	this module shifts a lot over time. will have to implement round by round 
run "${do_hfps_util}/label_access_item"
run "${do_hfps_util}/label_item_ltfull"


{	/*	round 1	*/
u	"${raw_hfps_mwi}/sect5_access_r1.dta"	, clear
d s5*

*	soap->2
ta s5q1a1 s5q1b1,m
gl i=2
g item_need_${i}=(s5q1a1==1) if !mi(s5q1a1)
g item_access_${i}=(s5q1b1==1) if item_need_${i}==1
tabstat s5q1c1__?, s(n sum) c(s) varw(24)
g item_noaccess_cat1_${i}=(s5q1c1__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i}=(s5q1c1__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i}=(s5q1c1__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i}=(s5q1c1__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i}=(s5q1c1__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i}=(s5q1c1__6==1) if item_access_${i}==0


*	washing water->10
	*	survey design implicitly assumes item_need_10==1
gl i=10
	g item_need_${i}=1
ta s5q1a2,m
g item_access_${i}=(s5q1a2==2) if item_need_${i}==1
ta s5q1b2
la li s5q1b2
g item_noaccess_cat3_${i} = (s5q1b2==1) if item_access_${i}==0
g item_noaccess_cat4_${i} = (s5q1b2==4) if item_access_${i}==0
g item_noaccess_cat6_${i} = (s5q1b2==5) if item_access_${i}==0
g item_noaccess_cat92_${i}= (s5q1b2==3) if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat93_${i}= (s5q1b2==2) if item_access_${i}==0

*	cleaning supplies->3
ta s5q1a4 s5q1b4,m
gl i=3
g item_need_${i} =(s5q1a4==1) if !mi(s5q1a4)
g item_access_${i} = (s5q1b4==1) if item_need_${i}==1
tabstat s5q1c4__?, s(n sum) c(s) varw(24)
g item_noaccess_cat1_${i}=(s5q1c4__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i}=(s5q1c4__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i}=(s5q1c4__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i}=(s5q1c4__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i}=(s5q1c4__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i}=(s5q1c4__6==1) if item_access_${i}==0

*	staple->15
ta s5q2a s5q2b,m
gl i=15
g item_need_${i}	= (s5q2a==1) if !mi(s5q2a)
g item_access_${i}	= (s5q2b==1) if item_need_${i}==1
g item_noaccess_cat1_${i} =(s5q2c__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2c__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2c__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2c__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q2c__5==1) if item_access_${i}==0
g item_noaccess_cat31_${i}=(s5q2c__6==1) if item_access_${i}==0	//	different code here 

*	disaggregate staple 
ta s5q2
la li s5q2
recode s5q2 (1=16)(2=4)(3=6)(4=19)(5=90)(6=18), gen(xxx)	//	harmonize to the working item codes 
levelsof xxx, loc(crops)
foreach i of local crops {
	g item_need_`i' = (s5q2a==1) if !mi(s5q2a) & xxx==`i'
	g item_access_`i' = (s5q2b==1) if item_need_`i'==1 & xxx==`i'
	g item_noaccess_cat1_`i' =(s5q2c__1==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat2_`i' =(s5q2c__2==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat3_`i' =(s5q2c__3==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat4_`i' =(s5q2c__4==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat5_`i' =(s5q2c__5==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat31_`i'=(s5q2c__6==1) if item_access_`i'==0 & xxx==`i'
}


*	medicine->1
ta s5q1a3 s5q1b3,m
gl i=1
g item_need_${i}	= (s5q1a3==1) if !mi(s5q1a3)
g item_access_${i}	= (s5q1b3==1) if item_need_${i}==1
d s5q1c3__?
g item_noaccess_cat1_${i} =(s5q1c4__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1c4__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1c4__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1c4__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1c4__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1c4__6==1) if item_access_${i}==0


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
d s5q5__?
g item_noaccess_cat1_${i} =(s5q5__3==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q5__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q5__5==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5__6==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5__1==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5__7==1) if item_access_${i}==0


*	financial services->25
ta s5q9 s5q10,m
gl i=25
g item_need_${i}	= (s5q9==1) if !mi(s5q9)
g item_access_${i}	= (s5q10==1) if item_need_${i}==1
ta s5q11
la li s5q11
g item_noaccess_cat1_${i} =(s5q11==2) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q11==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q11==3) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q11==4) if item_access_${i}==0


keep y4_hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_	
	item_noaccess_cat92_	item_noaccess_cat93_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
g round=  1
tempfile r1
sa		`r1'
}	/*	 r1 end	*/


{	/*	round 2	*/
u	"${raw_hfps_mwi}/sect5_access_r2.dta"	, clear
d s5*


*	soap->2
ta s5q1a1,m
gl i=2

g item_access_${i}=(s5q1a1==1) if !mi(s5q1a1)
tabstat s5q1b1__?, s(n sum) c(s) varw(24)
g item_noaccess_cat1_${i} =(s5q1b1__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1b1__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1b1__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1b1__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1b1__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1b1__7==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1b1__8==1) if item_access_${i}==0
g item_noaccess_cat31_${i}=(s5q1b1__6==1) if item_access_${i}==0


*	washing water->10
	*	survey design implicitly assumes item_need_10==1
ta s5q1a2,m
gl i=10
	g item_need_${i}=1
g item_access_${i}=(s5q1a2==2) if item_need_${i}==1
tabstat s5q1b2__?, s(n sum) c(s) varw(12)
g item_noaccess_cat3_${i} = (s5q1b2__1==1) if item_access_${i}==0
g item_noaccess_cat4_${i} = (s5q1b2__4==1) if item_access_${i}==0
g item_noaccess_cat6_${i} = (s5q1b2__5==1) if item_access_${i}==0
g item_noaccess_cat92_${i}= (s5q1b2__3==1) if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat93_${i}= (s5q1b2__2==1) if item_access_${i}==0

*	drinking water->9
ta s5q1a2_2 s5q1a2_1,m
la li s5q1a2_1
gl i=9
g item_need_${i} =1
g item_access_${i} = (s5q1a2_1==2) if item_need_${i}==1
la li s5q1a2_2
g item_noaccess_cat91_${i}=(s5q1a2_2==1) if item_access_${i}==0
g item_noaccess_cat92_${i}=(s5q1a2_2==2) if item_access_${i}==0
g item_noaccess_cat93_${i}=(s5q1a2_2==3) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1a2_2==4) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1a2_2==5) if item_access_${i}==0


*	staple->15
ta s5q2a s5q2b,m
gl i=15
g item_need_${i}	= (s5q2a==1) if !mi(s5q2a)
g item_access_${i}	= (s5q2b==1) if item_need_${i}==1
g item_noaccess_cat1_${i} =(s5q2c__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2c__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2c__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2c__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q2c__5==1) if item_access_${i}==0
g item_noaccess_cat31_${i}=(s5q2c__6==1) if item_access_${i}==0

*	disaggregate staple 
ta s5q2
la li s5q2
recode s5q2 (1=16)(2=4)(3=6)(4=19)(5=90)(6=18), gen(xxx)	//	harmonize to the working item codes 
levelsof xxx, loc(crops)
foreach i of local crops {
	g item_need_`i' = (s5q2a==1) if !mi(s5q2a) & xxx==`i'
	g item_access_`i' = (s5q2b==1) if item_need_`i'==1 & xxx==`i'
	g item_noaccess_cat1_`i' =(s5q2c__1==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat2_`i' =(s5q2c__2==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat3_`i' =(s5q2c__3==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat4_`i' =(s5q2c__4==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat5_`i' =(s5q2c__5==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat31_`i'=(s5q2c__6==1) if item_access_`i'==0 & xxx==`i'
}


*	medicine->1
ta s5q1a3 s5q1b3,m
gl i=1
g item_need_${i}	= (s5q1a3==1) if !mi(s5q1a3)
g item_access_${i}	= (s5q1b3==1) if item_need_${i}==1
d s5q1c3__?
g item_noaccess_cat1_${i} =(s5q1c3__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1c3__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1c3__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1c3__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1c3__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1c3__6==1) if item_access_${i}==0


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
g item_noaccess_cat1_${i} =(s5q5==3) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q5==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q5==5) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7) if item_access_${i}==0


*	financial services->25
ta s5q9 s5q10,m
gl i=25
g item_need_${i}	= (s5q9==1) if !mi(s5q9)
g item_access_${i}	= (s5q10==1) if item_need_${i}==1
ta s5q11	//	only 6 responses, but 4 are O/S
ta s5q11_os	//	judgment call, I will bin all of these into cat 2 local mkts not operating. 
la li s5q11
g item_noaccess_cat1_${i} =(s5q11==2) if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q11,1,96)) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q11==3) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q11==4) if item_access_${i}==0

*	internet access->72
ta s5q12 s5q13,m	//	no typology for the difficulties experienced, and we don't really have a way to code this that will match with anything else. Ignoring the "difficulty/reduction" question
g item_access_72 = (s5q12==1)



keep y4_hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_	
	item_noaccess_cat91_	item_noaccess_cat92_	item_noaccess_cat93_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
g round=  2
tempfile r2
sa		`r2'
}	/*	 r2 end	*/


{	/*	round 3	*/
u	"${raw_hfps_mwi}/sect5_access_r3.dta"	, clear
d s5*

*	prenatal care->	53
*	adult/general care->	55
*	washing water->10
*	drinking water->9

*	prenatal care->53
ta s5q2_2a s5q2_2b,m
gl i=53

g item_need_${i}=(s5q2_2a==1) if !mi(s5q2_2a)
g item_access_${i}=(s5q2_2b==1) if item_need_${i}==1
tabstat s5q2_2c__*, s(n sum) c(s) varw(24)	 
g item_noaccess_cat1_${i} =(s5q2_2c__3==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2_2c__2==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2_2c__4==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2_2c__1==1) if item_access_${i}==0
g item_noaccess_cat12_${i}=(s5q2_2c__5==1) if item_access_${i}==0
g item_noaccess_cat13_${i}=(s5q2_2c__6==1) if item_access_${i}==0	//	variable label does not match documenation, going with documentation as the more reliable


*	adult/general care->55
ta s5q2_2d s5q2_2e,m
la li s5q2_2e
gl i=55

g item_need_${i}=(s5q2_2d==1) if !mi(s5q2_2d)
g item_access_${i}=(s5q2_2e==3) if item_need_${i}==1
tabstat s5q2_2f__*, s(n sum) c(s) varw(24)
g item_noaccess_cat1_${i} =(s5q2_2f__3==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2_2f__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2_2f__9==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2_2f__4==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2_2f__1==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q2_2f__5==1) if item_access_${i}==0
g item_noaccess_cat12_${i}=(s5q2_2f__6==1) if item_access_${i}==0
g item_noaccess_cat13_${i}=(s5q2_2f__7==1) if item_access_${i}==0


*	washing water->10
	*	survey design implicitly assumes item_need_10==1
ta s5q1b2 s5q1a2,m
gl i=10
	g item_need_${i}=1 if !mi(s5q1a2)
g item_access_${i}=(s5q1a2==2) if item_need_${i}==1
d s5q1b2
la li s5q4_1	//	codes are consistent with the paper documentation
ta s5q1b2_ot	//->	code 91 
g str=strtrim(stritrim(strlower(s5q1b2_ot)))
ta str if s5q1b2==95
recode s5q1b2 (95=3) if inlist(str,"intermittent water supply")	//	not=large household size, but yes = code 92
drop str
g item_noaccess_cat3_${i} = (s5q1b2==1) if item_access_${i}==0
g item_noaccess_cat4_${i} = (s5q1b2==4) if item_access_${i}==0
g item_noaccess_cat6_${i} = (s5q1b2==5) if item_access_${i}==0
g item_noaccess_cat91_${i}= (s5q1b2==95) if item_access_${i}==0	//	the O/S are pretty much all consistent with this code 
g item_noaccess_cat92_${i}= (s5q1b2==3) if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat93_${i}= (s5q1b2==2) if item_access_${i}==0

*	drinking water->9
ta s5q1a2_2 s5q1a2_1,m
gl i=9
g item_need_${i} =1 if !mi(s5q1a2_1)
g item_access_${i} = (s5q1a2_1==2) if item_need_${i}==1
d s5q1a2_2
la li s5q6_1	//	codes are consistent with the paper documentation
g str=strtrim(stritrim(strlower(s5q1a2_2_ot)))
ta str if s5q1a2_2==95
recode s5q1a2_2 (95=5) if inlist(str,"did not have enough money to buy water","no money")
// recode s5q1a2_2 (95=6) if inlist(str,"water source too far")	//	add a code 
recode s5q1a2_2 (95=1) 	//	remainder
drop str
g item_noaccess_cat91_${i}=(s5q1a2_2==1) if item_access_${i}==0
g item_noaccess_cat92_${i}=(s5q1a2_2==2) if item_access_${i}==0
g item_noaccess_cat93_${i}=(s5q1a2_2==3) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1a2_2==4) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1a2_2==5) if item_access_${i}==0





keep y4_hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_								item_noaccess_cat6_		
	item_noaccess_cat11_	item_noaccess_cat12_	item_noaccess_cat13_	
	item_noaccess_cat91_	item_noaccess_cat92_	item_noaccess_cat93_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  3
tempfile r3
sa		`r3'
}	/*	 r3 end	*/


{	/*	round 4	*/
u	"${raw_hfps_mwi}/sect5_access_r4.dta"	, clear
d s5*

*	prenatal care->	53
*	adult/general care->	55
*	washing water->10
*	drinking water->9

*	prenatal care->53
ta s5q2_2a s5q2_2b,m
gl i=53

g item_need_${i}=(s5q2_2a==1) if !mi(s5q2_2a)
g item_access_${i}=(s5q2_2b==1) if item_need_${i}==1
tabstat s5q2_2c__*, s(n sum) c(s) varw(24)	 
g item_noaccess_cat1_${i} =(s5q2_2c__3==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2_2c__2==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2_2c__4==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2_2c__1==1) if item_access_${i}==0
g item_noaccess_cat12_${i}=(s5q2_2c__5==1) if item_access_${i}==0
g item_noaccess_cat13_${i}=(s5q2_2c__6==1) if item_access_${i}==0	//	variable label does not match documenation, going with documentation as the more reliable


*	adult/general care->55
ta s5q2_2d s5q2_2e,m
la li s5q2_2e
gl i=55

g item_need_${i}=(s5q2_2d==1) if !mi(s5q2_2d)
g item_access_${i}=(s5q2_2e==3) if item_need_${i}==1
tabstat s5q2_2f__*, s(n sum) c(s) varw(24)
g item_noaccess_cat1_${i} =(s5q2_2f__3==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2_2f__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2_2f__9==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2_2f__4==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2_2f__1==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q2_2f__5==1) if item_access_${i}==0
g item_noaccess_cat12_${i}=(s5q2_2f__6==1) if item_access_${i}==0
g item_noaccess_cat13_${i}=(s5q2_2f__7==1) if item_access_${i}==0


*	washing water->10
	*	survey design implicitly assumes item_need_10==1
ta s5q1b2 s5q1a2,m
gl i=10
	g item_need_${i}=1 if !mi(s5q1a2)
g item_access_${i}=(s5q1a2==2) if item_need_${i}==1
d s5q1b2
la li s5q4_1	//	codes are consistent with the paper documentation
*	predominant O/S
g str=strtrim(stritrim(strlower(s5q1b2_ot)))
ta str if s5q1b2==95
recode s5q1b2 (95=3) if inlist(str,"intermittent water supply","water supply reduced")	//	not=large household size, but yes = code 92
drop str

g item_noaccess_cat3_${i} = (s5q1b2==1) if item_access_${i}==0
g item_noaccess_cat4_${i} = (s5q1b2==4) if item_access_${i}==0
g item_noaccess_cat6_${i} = (s5q1b2==5) if item_access_${i}==0
g item_noaccess_cat91_${i}= (s5q1b2==95) if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat92_${i}= (s5q1b2==3) if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat93_${i}= (s5q1b2==2) if item_access_${i}==0

*	drinking water->9
ta s5q1a2_2 s5q1a2_1,m
gl i=9
g item_need_${i} =1 if !mi(s5q1a2_1)
g item_access_${i} = (s5q1a2_1==2) if item_need_${i}==1
d s5q1a2_2
la li s5q6_1	//	codes are consistent with the paper documentation
g str=strtrim(stritrim(strlower(s5q1a2_2_ot)))
ta str if s5q1a2_2==95
recode s5q1a2_2 (95=3) if inlist(str,"too many people at the water source")
recode s5q1a2_2 (95=1) 	//	remainder
drop str

g item_noaccess_cat91_${i}=(s5q1a2_2==1) if item_access_${i}==0
g item_noaccess_cat92_${i}=(s5q1a2_2==2) if item_access_${i}==0
g item_noaccess_cat93_${i}=(s5q1a2_2==3) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1a2_2==4) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1a2_2==5) if item_access_${i}==0





keep y4_hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_								item_noaccess_cat6_		
	item_noaccess_cat11_	item_noaccess_cat12_	item_noaccess_cat13_	
	item_noaccess_cat91_	item_noaccess_cat92_	item_noaccess_cat93_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  4
tempfile r4
sa		`r4'
}	/*	 r4 end	*/


{	/*	round 5	*/
u	"${raw_hfps_mwi}/sect5_access_r5.dta"	, clear
d s5*

*	staple->15
*	medicine->1
*	medical treatment->1


*	staple->15
ta s5q2a s5q2b,m
gl i=15
g item_need_${i}	= (s5q2a==1) if !mi(s5q2a)
g item_access_${i}	= (s5q2b==1) if item_need_${i}==1
la li s5q2c
g item_noaccess_cat1_${i} =(s5q2c==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2c==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2c==3) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2c==4) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q2c==5) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2c==6) if item_access_${i}==0

*	disaggregate staple 
ta s5q2
la li s5q2
recode s5q2 (1=16)(2=4)(3=6)(4=19)(5=90)(6=18), gen(xxx)	//	harmonize to the working item codes 
levelsof xxx, loc(crops)
foreach i of local crops {
	g item_need_`i' = (s5q2a==1) if !mi(s5q2a) & xxx==`i'
	g item_access_`i' = (s5q2b==1) if item_need_`i'==1 & xxx==`i'
	g item_noaccess_cat1_`i' =(s5q2c==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat2_`i' =(s5q2c==2) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat3_`i' =(s5q2c==3) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat4_`i' =(s5q2c==4) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat5_`i' =(s5q2c==5) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat6_`i' =(s5q2c==6) if item_access_`i'==0 & xxx==`i'
}


*	medicine->1
ta s5q1a3 s5q1b3,m
gl i=1
g item_need_${i}	= (s5q1a3==1) if !mi(s5q1a3)
g item_access_${i}	= (s5q1b3==1) if item_need_${i}==1
d s5q1c3__?
g item_noaccess_cat1_${i} =(s5q1c3__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1c3__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1c3__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1c3__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1c3__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1c3__6==1) if item_access_${i}==0


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
ta str if s5q5==96	//	one mask restriction case here, but was not a coded option
recode s5q5 (96=6)  if inlist(str,"no face mask was turned home")
recode s5q5 (96=3)	//	remainder are stock issues, so coding 3 to have them bin into cat2 per the harmonized codes
drop str
g item_noaccess_cat1_${i} =(s5q5==3) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q5==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q5==5) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7) if item_access_${i}==0




keep y4_hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  5
tempfile r5
sa		`r5'
}	/*	 r5 end	*/


{	/*	round 6	*/
u	"${raw_hfps_mwi}/sect5_access_r6.dta"	, clear
d s5*

ta s5q0a,m	//	affordable inputs program

*	medicine->1
*	medical treatment->1, then disaggregate


*	medicine->1
ta s5q1a3 s5q1b3,m
gl i=1
g item_need_${i}	= (s5q1a3==1) if !mi(s5q1a3)
g item_access_${i}	= (s5q1b3==1) if item_need_${i}==1
d s5q1c3__?
g item_noaccess_cat1_${i} =(s5q1c3__1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1c3__2==1) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1c3__3==1) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1c3__4==1) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1c3__5==1) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1c3__6==1) if item_access_${i}==0


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555	//	one mask restriction case here, but was not a coded option
recode s5q5 (555=6)  if inlist(str,"afraid to be turned aaway because did not have a mask")
recode s5q5 (555=3)	//	remainder are stock issues, so coding 3 to have them bin into cat2 per the harmonized codes
drop str
g item_noaccess_cat1_${i} =(s5q5==3) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q5==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q5==5) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7) if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str
recode s5q3b__5 (0=1) if !mi(str)	//	adult health
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(s5q5==3) if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(s5q5==2) if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(s5q5==5) if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6) if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1) if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7) if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_*
d *_cat??_*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  6
tempfile r6
sa		`r6'
}	/*	 r6 end	*/


{	/*	round 7	*/
u	"${raw_hfps_mwi}/sect5_access_r7.dta"	, clear
d s5*

// ta s5q0a,m	//	affordable inputs program

*	medicine->1
*	medical treatment->1, then disaggregate



*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555	//	one mask restriction case here, but was not a coded option
recode s5q5 (555=6)  if strpos(str,"mask")>0
recode s5q5 (555=3)	//	remainder are stock issues, so coding 3 to have them bin into cat2 per the harmonized codes
drop str
g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str		//	no obs
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_*
d *_cat??_*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_								item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  7
tempfile r7
sa		`r7'
}	/*	 r7 end	*/


{	/*	round 8	*/
u	"${raw_hfps_mwi}/sect5_access_r8.dta"	, clear
d s5*

*	soap->2
*	washing water->10
*	drinking water->9
*	medical treatment->11



*	soap->2
ta s5q1a1,m
gl i=2

g item_access_${i}=(s5q1a1==1) if !mi(s5q1a1)
ta s5q1b1,m
la li s5q8_1
g item_noaccess_cat1_${i} =(s5q1b1==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q1b1==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q1b1==3) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q1b1==4) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q1b1==5) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q1b1==7) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1b1==8) if item_access_${i}==0
g item_noaccess_cat31_${i}=(s5q1b1==6) if item_access_${i}==0


*	washing water->10
	*	survey design implicitly assumes item_need_10==1
ta s5q1a2,m
gl i=10
	g item_need_${i}=1
g item_access_${i}=(s5q1a2==2) if item_need_${i}==1
ta s5q1b2,m	//		9 o/s
la li s5q3_2
g str=strtrim(stritrim(strlower(s5q1b2_oth)))
li str if s5q1b2==95	
recode s5q1b2 (95=2)  if inlist(str,"water supply reduced")>0
drop str

g item_noaccess_cat3_${i} = (s5q1b2==1)  if item_access_${i}==0
g item_noaccess_cat4_${i} = (s5q1b2==4)  if item_access_${i}==0
g item_noaccess_cat6_${i} = (s5q1b2==5)  if item_access_${i}==0
g item_noaccess_cat91_${i}= (s5q1b2==95) if item_access_${i}==0	
g item_noaccess_cat92_${i}= (s5q1b2==3)  if item_access_${i}==0	//	large household size indicates that the water supply is inadequate given the household size
g item_noaccess_cat93_${i}= (s5q1b2==2)  if item_access_${i}==0

*	drinking water->9
ta s5q1a2_2 s5q1a2_1,m
la li s5q5_1
gl i=9
g item_need_${i} =1
g item_access_${i} = (s5q1a2_1==2) if item_need_${i}==1
la li s5q6_1
g str=strtrim(stritrim(strlower(s5q1a2_2_oth)))
li str if s5q1a2_2==95	//->	all to 91 
recode s5q1b2 (95=1) 
drop str

g item_noaccess_cat6_${i} =(s5q1a2_2==4) if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q1a2_2==5) if item_access_${i}==0
g item_noaccess_cat91_${i}=(s5q1a2_2==1) if item_access_${i}==0
g item_noaccess_cat92_${i}=(s5q1a2_2==2) if item_access_${i}==0
g item_noaccess_cat93_${i}=(s5q1a2_2==3) if item_access_${i}==0


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555	//	remainder are stock issues, so coding 3 to have them bin into cat2 per the harmonized codes
recode s5q5 (555=3)	
drop str
g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str if s5q3b__555==1		//	all adult health + dental
recode s5q3b__5 (0=1) if s5q3b__555==1
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_*,f
d *_cat??_*,f
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_	item_noaccess_cat31_							
	item_noaccess_cat91_	item_noaccess_cat92_	item_noaccess_cat93_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  8
tempfile r8
sa		`r8'
}	/*	 r8 end	*/


{	/*	round 9	*/
u	"${raw_hfps_mwi}/sect5_access_r9.dta"	, clear
d s5*

*	staple->15, then disaggregate
*	medical treatment->11, then disaggregate


*	staple->15
ta s5q2a s5q2b,m
gl i=15
g item_need_${i}	= (s5q2a==1) if !mi(s5q2a)
g item_access_${i}	= (s5q2b==1) if item_need_${i}==1
la li s5q2c
ta s5q2c	//	all lack of money 
g item_noaccess_cat1_${i} =(s5q2c==1) if item_access_${i}==0
g item_noaccess_cat2_${i} =(s5q2c==2) if item_access_${i}==0
g item_noaccess_cat3_${i} =(s5q2c==3) if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q2c==4) if item_access_${i}==0
g item_noaccess_cat5_${i} =(s5q2c==5) if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q2c==6) if item_access_${i}==0

*	disaggregate staple 
ta s5q2
la li s5q2
recode s5q2 (1=16)(2=4)(3=6)(4=19)(5=90)(6=18), gen(xxx)	//	harmonize to the working item codes 
levelsof xxx, loc(crops)
foreach i of local crops {
	g item_need_`i' = (s5q2a==1) if !mi(s5q2a) & xxx==`i'
	g item_access_`i' = (s5q2b==1) if item_need_`i'==1 & xxx==`i'
	g item_noaccess_cat1_`i' =(s5q2c==1) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat2_`i' =(s5q2c==2) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat3_`i' =(s5q2c==3) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat4_`i' =(s5q2c==4) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat5_`i' =(s5q2c==5) if item_access_`i'==0 & xxx==`i'
	g item_noaccess_cat6_`i' =(s5q2c==6) if item_access_`i'==0 & xxx==`i'
}



*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555
recode s5q5 (555=12)  if inlist(str,"afraid of being suspected that they have covid-19")
recode s5q5 (555=2)  if inlist(str,"the hospital was closed")
recode s5q5 (555=3)	//	remainder are stock issues, so coding 3 to have them bin into cat2 per the harmonized codes
drop str
g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str		//	no obs
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(s5q5==3)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_*,f
d *_cat??_*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  9
tempfile r9
sa		`r9'
}	/*	 r9 end	*/


{	/*	round 11	*/
u	"${raw_hfps_mwi}/sect5_access_r11.dta"	, clear
d s5*

*	medical treatment->11, then disaggregate


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555	//	nothing much to do with this 
drop str
g item_noaccess_cat1_${i} =(inlist(s5q5,3,9))	if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str		//	no obs
recode s5q3b__5 (0=1) if s5q3b__555==1
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(inlist(s5q5,3,9))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_* ,f
d *_cat??_*,f
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_								item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  11
tempfile r11
sa		`r11'
}	/*	 r11 end	*/


{	/*	round 12	*/
u	"${raw_hfps_mwi}/sect5_access_r12.dta"	, clear
d s5*

*	medical treatment->11, then disaggregate


*	medical treatment->11
ta s5q3 s5q4,m
gl i=11
g item_need_${i}	= (s5q3==1) if !mi(s5q3)
g item_access_${i}	= (s5q4==1) if item_need_${i}==1
la li s5q5
ta s5q5
g str=strtrim(stritrim(strlower(s5q5_oth)))
li str if s5q5==555	//	none
drop str
g item_noaccess_cat1_${i} =(inlist(s5q5,3,9))	if item_access_${i}==0
g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0
g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0
g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0
g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0

*	disaggregate medical treatment
d s5q3b__?
g str=strtrim(stritrim(strlower(s5q3b_ot)))
ta str		//	no obs
drop str
forv i=1/7 {
	gl i=50+`i'
	g item_need_${i}	= (s5q3==1) if !mi(s5q3) & s5q3b__`i'==1
	g item_access_${i}	= (s5q4==1) if item_need_${i}==1 & s5q3b__`i'==1
	g item_noaccess_cat1_${i} =(inlist(s5q5,3,9))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat2_${i} =(inlist(s5q5,2,4))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat3_${i} =(inlist(s5q5,5,8))	if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat4_${i} =(s5q5==6)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat6_${i} =(s5q5==1)			if item_access_${i}==0 & s5q3b__`i'==1
	g item_noaccess_cat11_${i}=(s5q5==7)			if item_access_${i}==0 & s5q3b__`i'==1
}




keep y4_hhid item*
d *_cat?_* ,f
d *_cat??_*,f
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_		
	item_noaccess_cat4_								item_noaccess_cat6_		
	item_noaccess_cat11_	
	
	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
label_access_item
ta item item_access
d, si
g round=  12
tempfile r12
sa		`r12'
}	/*	 r12 end	*/


{	/*	round 13	*/
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r13.dta"	//	insurance
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r13.dta"


u	"${raw_hfps_mwi}/sect5_heatlthaccess1_r13.dta", clear
ta s5fq3,m
g item=11
g item_need	= (s5fq3==1) if !mi(s5fq3)
keep y4_hhid item*
tempfile pt1 
sa		`pt1'

u	"${raw_hfps_mwi}/sect5_heatlthaccess2_r13.dta", clear

ta service_cd
la li Sect5f_id_2__id
ta s5fq4_os
recode service_cd 96=6 if s5fq4_os=="Checkup"


g		item = service_cd+49 if inrange(service_cd,2,8)
replace	item = 58 if service_cd==1

*	get our zeroes
ta s5fq4 s5fq5,m

reshape wide service_cd random_read s5fq4 s5fq4_os s5fq5 s5fq6a s5fq6a_os s5fq7 s5fq7_os s5fq8 s5fq9a s5fq9b s5fq9c s5fq9d s5fq9d_os s5fq10, i(y4_hhid) j(item)
reshape long

ta s5fq4 s5fq5,m
g item_need=(s5fq4==1)
g item_access = (s5fq5==1) if item_need==1

la li s5fq6b_2
ta s5fq6a
g str=strtrim(stritrim(strlower(s5fq6a_os)))
li str if s5fq6a==96
recode s5fq6a (96=1) if inlist(str,"had no money")
recode s5fq6a (96=10) if inlist(str,"no medicine","bought medicine")	
drop str
	foreach i of numlist 1/10 {
		loc z=`i'+40
		g item_noaccess_cat`z'	= (s5fq6a==`i')	if item_access==0
	}

keep y4_hhid item*
label_access_item
ta item item_need
d, si

preserve
collapse (min) item_access (max) item_noaccess_cat*, by(y4_hhid)
mer 1:1 y4_hhid using `pt1', nogen
ta item_need item_access,m
su
tempfile add_11
sa		`add_11'
restore
append using `add_11'
isid y4_hhid item

g round=  13
tempfile r13
sa		`r13'
}	/*	 r13 end	*/


{	/*	round 14	*/
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r14.dta"	//	insurance + one need question
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r14.dta"


u	"${raw_hfps_mwi}/sect5_heatlthaccess1_r14.dta", clear
ta s5fq3,m
g item=11
g item_need	= (s5fq3==1) if !mi(s5fq3)
keep y4_hhid item*
tempfile pt1 
sa		`pt1'

u	"${raw_hfps_mwi}/sect5_heatlthaccess2_r14.dta", clear

ta service_cd
la li Sect5f_id_2__id	//	they did away with 5/6 disaggregation here, and binned a bunch explicitly into 8 
recode service_cd (5=6)	//	we have been binning extras into "adult care", so will continue to use this bin here. In the MW aggregation, let's manually bin 5 & 6 
ta s5fq4_os
recode service_cd 96=8 if s5fq4_os=="tooth"	
recode service_cd 96=6 	//	remainder


g		item = service_cd+49 if inrange(service_cd,2,8)
replace	item = 58 if service_cd==1

*	get our zeroes
ta s5fq4 s5fq5,m

ds y4_hhid hhid item, not
reshape wide `r(varlist)', i(y4_hhid) j(item)
reshape long

ta s5fq4 s5fq5,m
g item_need=(s5fq4==1)
g item_access = (s5fq5==1) if item_need==1

la li s5fq6b_2
ta s5fq6a
g str=strtrim(stritrim(strlower(s5fq6a_os)))
li str if s5fq6a==96
recode s5fq6a (96=1) if inlist(str,"had no money")
recode s5fq6a (96=10) if inlist(str,"no medicine","bought medicine")	//	judgment call on "bought medicine" in particular
drop str
	foreach i of numlist 1/10 {
		loc z=`i'+40
		g item_noaccess_cat`z'	= (s5fq6a==`i')	if item_access==0
	}


keep y4_hhid item*

preserve
collapse (min) item_access (max) item_noaccess_cat*, by(y4_hhid)
mer 1:1 y4_hhid using `pt1', nogen
ta item_need item_access,m
su
tempfile add_11
sa		`add_11'
restore
append using `add_11'
isid y4_hhid item

label_access_item
ta item item_need
d, si


g round=  14
tempfile r14
sa		`r14'
}	/*	 r14 end	*/


{	/*	round 15	*/
d using	"${raw_hfps_mwi}/sect1_interview_info_r15.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r15.dta"	//	N=1691
u	"${raw_hfps_mwi}/secta_cover_page_r15.dta", clear
ta result
ta gffx 	//	332 old 1343 new
ta gffx if result==1	//	295 old 1067 new
ta selected_individual result
d using	"${raw_hfps_mwi}/sect5f_healthaccess1_r15.dta"	//n=311
d using	"${raw_hfps_mwi}/sect5f_healthaccess2_r15.dta"	//n=131
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew1_r15.dta"	//n=5763
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew2_r15.dta"	//n=938
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv1_r15.dta" //n=597
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv2_r15.dta"	//n=173

/*
From the Basic Information Document: 
Note: In Round 15 there were 2 variants of the health access module. The original module was
fielded for 330 householdss while the rest of the households received the new and revised module.
Additionally, the new health access module and vaccines modules were structured at main
respondent and individual levels. The individual sections were only enabled IF the randomly
selected individual was different from the main respondent.
*/


/*	new module	*/
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv1_r15.dta" //n=597
d using	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv2_r15.dta"	//n=173
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew1_r15.dta"	//n=5763
d using	"${raw_hfps_mwi}/sect5g_healthaccessnew2_r15.dta"	//n=938



u	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv2_r15.dta", clear
la li service_ind__id
g str=strtrim(stritrim(strlower(s5hq6_ot)))
la li s5gq6
ta str if s5hq6==96
recode s5hq6 (96=10)
keep y4 pid service_cd s5hq5 s5hq6 
ren (s5hq5 s5hq6)(acc_ rsn_)


tempfile indiv2
sa		`indiv2'

u	"${raw_hfps_mwi}/sect5g_healthaccessnew2_r15.dta", clear	/*	to harmonize, need to take max of this vn	*/
g str=strtrim(stritrim(strlower(s5gq6_ot)))
la li s5fq6
li service_cd str if s5gq6==96, sep(0)

recode s5gq6 (96=10)

la li service_type__id
recode service_cd (6=7)(7=8)

keep y4 pid service_cd s5gq5 s5gq6 
ren (s5gq5 s5gq6)(acc_ rsn_)
append using `indiv2', gen(mk)

ta acc_,m
g item_access_=(acc_==1)
ta rsn_
la li s5fq6
	foreach i of numlist 1/10 {
		loc z=`i'+40
		g item_noaccess_cat`z'	= (rsn_==`i')	if item_access==0
	}
keep y4_hhid pid mk service_cd item*
#d ; 
reshape wide item_access_
	item_noaccess_cat41 item_noaccess_cat42 item_noaccess_cat43 
	item_noaccess_cat44 item_noaccess_cat45 item_noaccess_cat46 
	item_noaccess_cat47 item_noaccess_cat48 item_noaccess_cat49 
	item_noaccess_cat50
	, i(y4_hhid pid mk) j(service_cd); 
#d cr 

tempfile mod2
sa		`mod2'


u	"${raw_hfps_mwi}/sect5h_healthaccessnew_indiv1_r15.dta", clear
ren s5h* s5g*	//	simplify the next part	
recode s5gq3 s5gq4__* (.a=.)	//	need to take this step to ensure that the merge update can function
tabstat s5gq4__*, by(s5gq3) s(n sum)
keep y4_hhid pid s5gq3 s5gq4* 
tempfile indiv1
sa		`indiv1'
u	"${raw_hfps_mwi}/sect5g_healthaccessnew1_r15.dta", clear	/*	to harmonize, need to take max of this vn	*/
keep y4_hhid pid s5gq3 s5gq4* 
recode s5gq3 s5gq4__* (.a=.)
ren (s5gq4__6 s5gq4__7)(s5gq4__7 s5gq4__8)	//	make consistent 
tabstat s5gq4__*, by(s5gq3) s(n sum)
// mer 1:1 y4_hhid pid using `indiv1', update
append using `indiv1', gen(mk)
*	bring this info in prior to restricting dataset 
mer 1:1 y4 pid mk using `mod2', assert(1 3) nogen

tabstat s5gq4__*, by(s5gq3) s(n sum)

ta mk
duplicates report y4 pid	//	duplicate copies identical to copies of mk
duplicates report y4 pid s5gq3 s5gq4__*

*	rule 0 : get rid of pure duplicates 
duplicates drop y4 pid s5gq3 s5gq4__*, force
duplicates tag y4 pid, gen(tag1)

sort y4 pid
li y4-mk if tag1>0, sepby(y4) nol

*	rule 1 : take the s5q3=yes if one is yes and one is no
bys y4 pid : egen min3 = min(s5gq3)
by  y4 pid : egen max3 = max(s5gq3)
drop if tag1>0 & s5gq3==1 & min3==1 & max3==2

*	rule 2 : keep the non missing s5q3 
bys y4 pid : egen nonm = count(s5gq3)
duplicates tag		y4 pid, gen(tag2)
ta nonm tag2
drop if tag2==1 & nonm==1

*	identify remainder
duplicates report	y4 pid
duplicates tag		y4 pid, gen(tag3)
sort y4 pid mk
li y4-mk if tag3>0, sepby(y4) nol	//	

*	rule 3 : take the indiv results where they differ 
drop if tag3>0 & mk==0
isid y4 pid	//	verifying that now identified by hh individual
ta mk



ta s5gq3,m

tabstat s5gq4__*, s(n sum min max) c(s) varw(12)
ta s5gq4_os	//	need to carry any changes over to new2 work
g str=strtrim(stritrim(strlower(s5gq4_os)))
ta str if s5gq4__96==1
d s5gq4__*
g if4 = 1 if inlist(str,"blood pressure","check up","cough","coughing","infection","legs","malaria")
recode s5gq4__4		(0 .=1)	if if4==1
replace item_access_4=min(item_access_4,item_access_96) if if4==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'4 = max(item_noaccess_cat`c'4,item_noaccess_cat`c'96) if if4==1
}
recode s5gq4__96	(1=0)	if if4==1
recode item_access_96 item_noaccess_cat*96 (nonm=.) if if4==1

g if7 = 1 if inlist(str,"bought medz from grocery","buy drugs","medicine from grocery","pharmacy","purchae medicine from grocery store","purchase of medicine","skin care")
recode s5gq4__7		(0 .=1)	if if7==1
replace item_access_7=min(item_access_7,item_access_96) if if7==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'7 = max(item_noaccess_cat`c'7,item_noaccess_cat`c'96) if if7==1
}
recode s5gq4__96	(1=0)	if if7==1
recode item_access_96 item_noaccess_cat*96 (nonm=.) if if7==1
ta str if s5gq4__96==1

*	deal with missingness
tabstat s5gq4__*, by(s5gq3) s(n sum)
recode s5gq4__* (.=0) if s5gq3==1
tabstat s5gq4__*, by(s5gq3) s(n sum) missing



*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d s5gq4__*
d *_1
ren s5gq4__* item_need_*

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
ta mk if item_need_`i'==1 & mi(item_access_`i')
tabstat item_noaccess_cat*`i' , by(item_access_`i') s(n sum) missing
}


#d ; 
collapse (min) s5gq3 
	(max) item_need_* 
	(min) item_access_* 
	(max) item_noaccess_cat*
	, by(y4_hhid);
#d cr 
tabstat item_need_*, by(s5gq3) s(n sum)

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*`i' , by(item_access_`i') s(n sum) missing
}


*	construct the overall need category 
g item_need_11 = (s5gq3==1) if !mi(s5gq3)
recode item_need_? item_need_96 (.=0) if item_need_11==1
egen item_access_11 = rowmin(item_access_? item_access_96)
ta item_need_11 item_access_11,m	//	perfect 
foreach c of numlist 41(1)50 {
	egen item_noaccess_cat`c'11 = rowmax(item_noaccess_cat`c'? item_noaccess_cat`c'96)
}
tabstat item_noaccess_cat*11, by(item_access_11) s(n sum) missing

*	make long by item 
keep y4_hhid item*
drop *96	// we have gleaned all that we can use from these 
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat41 item_noaccess_cat42 item_noaccess_cat43 
	item_noaccess_cat44 item_noaccess_cat45 item_noaccess_cat46 
	item_noaccess_cat47 item_noaccess_cat48 item_noaccess_cat49 
	item_noaccess_cat50
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
label_access_item
ta item item_need,m
// drop if mi(item_need)	//	 gets ride of the cases where need any medical treatment=0 
d, si

tempfile r15new
sa		`r15new'




/*	old	module	*/

u	"${raw_hfps_mwi}/sect5f_healthaccess1_r15.dta", clear
ta s5fq3,m
g item=11
g item_need	= (s5fq3==1) if !mi(s5fq3)
keep y4_hhid item*
tempfile pt1 
sa		`pt1'

u	"${raw_hfps_mwi}/sect5f_healthaccess2_r15.dta", clear

ta service_cd	
la li Sect5f_id_2__id	//	they did away with 5/6 disaggregation here, and binned a bunch explicitly into 8 
recode service_cd (5=6)	//	we have been binning extras into "adult care", so will continue to use this bin here. In the MW aggregation, let's manually bin 5 & 6 
ta s5fq4_os
recode service_cd 96=8 if s5fq4_os=="tooth"	
recode service_cd 96=6 	//	remainder


g		item = service_cd+49 if inrange(service_cd,2,8)
replace	item = 58 if service_cd==1	//	no cases for service_cd=1

*	get our zeroes
ta s5fq4 s5fq5,m

ds y4_hhid hhid item, not
reshape wide `r(varlist)', i(y4_hhid) j(item)
reshape long

ta s5fq4 s5fq5,m
g item_need=(s5fq4==1)
g item_access = (s5fq5==1) if item_need==1

la li s5aq6b_2
ta s5fq6a		//	three responses, no O/S
g str=strtrim(stritrim(strlower(s5fq6a_os)))
li str if s5fq6a==96
drop str
	foreach i of numlist 1/9 {
		loc z=`i'+40
		g item_noaccess_cat`z'	= (s5fq6a==`i')	if item_access==0
	}


keep y4_hhid item*

preserve
collapse (min) item_access (max) item_noaccess_cat*, by(y4_hhid)
mer 1:1 y4_hhid using `pt1', nogen
ta item_need item_access,m
su
tempfile add_11
sa		`add_11'
restore
append using `add_11'
isid y4_hhid item

label_access_item
ta item item_need,m
d, si

tempfile r15old
sa		`r15old'

clear
append using `r15old' `r15new', gen(mk)
la val mk .
isid y4_hhid item
ta item mk,m
expand 2 if item==11 & item_need==1 & mk==1, gen(fill_covid19_vals)
recode item (11=58)		if fill_covid19_vals==1
recode item_need (1=0)	if fill_covid19_vals==1
recode item_access item_noaccess_cat* (nonm=.)	if fill_covid19_vals==1
drop fill_covid19_vals
ta item mk,m
drop mk
ta item item_need, m


g round=  15
tempfile r15
sa		`r15'
}	/*	 r15 end	*/


{	/*	round 16	*/
d using	"${raw_hfps_mwi}/sect1_interview_info_r16.dta"	//	n=3389
d using	"${raw_hfps_mwi}/secta_cover_page_r16.dta"	//	n=1686
u		"${raw_hfps_mwi}/secta_cover_page_r16.dta", clear
ta result
cou if !mi(wt)
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r16.dta"	//	n=8207
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r16.dta"	//	n=8207
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r16.dta"	//	n=831
d using	"${raw_hfps_mwi}/sect14_fuels_r16.dta"	//	n=5472

/*	new module	*/
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r16.dta"	//	n=8207
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r16.dta"	//	n=831



u	"${raw_hfps_mwi}/sect5_healthaccessnew2_r16.dta", clear	/*	to harmonize, need to take max of this vn	*/
g str=strtrim(stritrim(strlower(s5gq6_ot)))
la li s5fq6
li service_cd str if s5gq6==96, sep(0)
#d ; 
recode s5gq6 (96=5) if inlist(str
	,"no medication"
	,"there was no medicine"
	,"no medicine then go to private hospital"
	,"use medicine that was stored"
	,"use medice that was stored"
	,"no medication at the facility"
	); 
#d cr
*	little to do beyond this

la li service_type__id
recode service_cd (6=7)(7=8)

keep y4 pid service_cd s5gq5 s5gq6 
ren (s5gq5 s5gq6)(acc_ rsn_)


ta acc_,m nol
g item_access_=(acc_==1)
ta rsn_
la li s5fq6
	foreach i of numlist 1/10 {
		loc z=`i'+40
		g item_noaccess_cat`z'_	= (rsn_==`i')	if item_access==0
	}
keep y4_hhid pid service_cd item*
#d ; 
reshape wide item_access_
	item_noaccess_cat41_ item_noaccess_cat42_ item_noaccess_cat43_ 
	item_noaccess_cat44_ item_noaccess_cat45_ item_noaccess_cat46_ 
	item_noaccess_cat47_ item_noaccess_cat48_ item_noaccess_cat49_ 
	item_noaccess_cat50_
	, i(y4_hhid pid) j(service_cd); 
#d cr 

tempfile mod2
sa		`mod2'


u	"${raw_hfps_mwi}/sect5_healthaccessnew1_r16.dta", clear	/*	to harmonize, need to take max of this vn	*/
keep y4_hhid pid s5gq3 s5gq4* 
recode s5gq3 s5gq4__* (.a=.)
ren (s5gq4__6 s5gq4__7)(s5gq4__7 s5gq4__8)	//	make consistent 
tabstat s5gq4__*, by(s5gq3) s(n sum)
mer 1:1 y4 pid using `mod2', assert(1 3) nogen

tabstat s5gq4__*, by(s5gq3) s(n sum) missing

isid y4 pid	//	verifying that now identified by hh individual




ta s5gq3,m	//	why is this sometimes missing? 
qui : ta y4
dis r(r)	//	1368
qui : ta y4 if !mi(s5gq3)
dis r(r)	//	1367
// mer m:1 y4 using "${raw_hfps_mwi}/secta_cover_page_r16.dta", 
// ta _m if !mi(wt),m
// ta s5gq3 if !mi(wt),m

tabstat s5gq4__*, s(n sum min max) c(s) varw(12)
ta s5gq4_os	//	need to carry any changes over to new2 work
g str=strtrim(stritrim(strlower(s5gq4_os)))
ta str if s5gq4__96==1
d s5gq4__*

gl i=8
g if${i} = 1 if inlist(str,"body pains","epilepsy","headache","purchase","purchase medicine")
recode s5gq4__${i} (0 .=1)	if if${i}==1
replace item_access_${i}=min(item_access_${i},item_access_96) if if${i}==1
foreach c of numlist 41/50 {
	replace item_noaccess_cat`c'_${i} = max(item_noaccess_cat`c'_${i},item_noaccess_cat`c'_96) if if${i}==1
}
recode s5gq4__96	(1=0)	if if${i}==1
recode item_access_96 item_noaccess_cat*_96 (nonm=.) if if${i}==1
ta str if s5gq4__96==1


*	deal with missingness
tabstat s5gq4__*, by(s5gq3) s(n sum)
recode s5gq4__* (.=0) if s5gq3==1
tabstat s5gq4__*, by(s5gq3) s(n sum) missing



*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d s5gq4__*
d *_1
ren s5gq4__* item_need_*

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


#d ; 
collapse (min) s5gq3 
	(max) item_need_* 
	(min) item_access_* 
	(max) item_noaccess_cat*
	, by(y4_hhid);
#d cr 
tabstat item_need_*, by(s5gq3) s(n sum) m

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


*	construct the overall need category 
g item_need_11 = (s5gq3==1) if !mi(s5gq3)
recode item_need_? item_need_96 (.=0) if item_need_11==1
egen item_access_11 = rowmin(item_access_? item_access_96)
ta item_need_11 item_access_11,m	//	perfect 
foreach c of numlist 41/50 {
	egen item_noaccess_cat`c'_11 = rowmax(item_noaccess_cat`c'_? item_noaccess_cat`c'_96)
}
tabstat item_noaccess_cat*_11, by(item_access_11) s(n sum) missing

*	make long by item 
keep y4_hhid item*
drop *96	// we have gleaned all that we can use from these 
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat41_ item_noaccess_cat42_ item_noaccess_cat43_ 
	item_noaccess_cat44_ item_noaccess_cat45_ item_noaccess_cat46_ 
	item_noaccess_cat47_ item_noaccess_cat48_ item_noaccess_cat49_ 
	item_noaccess_cat50_
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
label_access_item
ta item item_need,m
// drop if mi(item_need)	//	 gets rid of the cases where need any medical treatment=0 
d, si

isid y4_hhid item
ta item item_need, m

tempfile health
sa		`health'


d using	"${raw_hfps_mwi}/sect14_fuels_r16.dta"	//	n=5472
u	"${raw_hfps_mwi}/sect14_fuels_r16.dta", clear
ta fuel_id
la li fuels__id
recode fuel_id (1=91)(2=92)(3=93)(4=94), gen(item)
ta s14q2
la li s14q2
g item_access = (s14q2==1) if inlist(s14q2,1,2,3)
keep y4_hhid item*
isid y4_hhid item
append using `health'
isid y4_hhid item
label_access_item


g round=  16
tempfile r16
sa		`r16'
}	/*	 r16 end	*/


{	/*	round 17	*/
d using	"${raw_hfps_mwi}/sect1_interview_info_r17.dta"	//	n=3966
d using	"${raw_hfps_mwi}/secta_cover_page_r17.dta"	//	n=1674
u		"${raw_hfps_mwi}/secta_cover_page_r17.dta", clear
ta result
cou if !mi(wt)	//	1318
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r17.dta"	//	n=8122
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r17.dta"	//	n=1109
d using	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"	//	n=5272
d using	"${raw_hfps_mwi}/sect11_transportprices_r17.dta"	//	n=6590




u	"${raw_hfps_mwi}/sect5_healthaccessnew2_r17.dta", clear	/*	to harmonize, need to take max of this vn	*/
g str=strtrim(stritrim(strlower(s5gq6_ot)))
la li s5fq6
li service_cd str if s5gq6==96, sep(0)
recode s5gq6 (96=10)


la li service_type__id
recode service_cd (6=7)(7=8)


ren (s5gq5 s5gq6)(acc_ rsn_)


ta acc_,m nol
g item_access_=(acc_==1)
ta rsn_
la li s5fq6
forv i=1/10 {
	loc z=`i'+40
	g item_noaccess_cat`z'_ = (rsn_==`i')	if item_access_==0
}
keep y4_hhid pid service_cd item*
#d ; 
ds y4_hhid pid service_cd, not; 
reshape wide `r(varlist)'	
	, i(y4_hhid pid) j(service_cd); 
#d cr 

tempfile mod2
sa		`mod2'


u	"${raw_hfps_mwi}/sect5_healthaccessnew1_r17.dta", clear	/*	to harmonize, need to take max of this vn	*/
keep y4_hhid pid s5gq3 s5gq4* 	//	not actually necessary in r17 
recode s5gq3 s5gq4__* (.a=.)
ren (s5gq4__6 s5gq4__7)(s5gq4__7 s5gq4__8)	//	make consistent 
tabstat s5gq4__*, by(s5gq3) s(n sum) m
mer 1:1 y4 pid using `mod2', assert(1 3) nogen

tabstat s5gq4__*, by(s5gq3) s(n sum) missing

isid y4 pid	//	verifying that now identified by hh individual




ta s5gq3,m	//	why is this sometimes missing? persons for whom the q is not asked 
qui : ta y4
dis r(r)	//	1318
qui : ta y4 if !mi(s5gq3)
dis r(r)	//	1317

tabstat s5gq4__*, s(n sum min max) c(s) varw(12)
ta s5gq4_os	//	need to carry any changes over to new2 work
g str=strtrim(stritrim(strlower(s5gq4_os)))
ta str if s5gq4__96==1
d s5gq4__*

gl i=5
g if${i} = 1 if inlist(str,"check up","hiv testing","under five clinic")
recode s5gq4__${i}		(0 .=1)	if if${i}==1
replace item_access_${i}=min(item_access_${i},item_access_96) if if${i}==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'_${i} = max(item_noaccess_cat`c'_${i},item_noaccess_cat`c'_96) if if${i}==1
}
recode s5gq4__96	(1=0)	if if${i}==1
recode item_access_96 item_noaccess_cat*_96 (nonm=.) if if${i}==1
ta str if s5gq4__96==1

gl i=8
g if${i} = 1 if inlist(str,"medicine","medicine purchase","pharmacy","purchasing medicine","scale")
recode s5gq4__${i}		(0 .=1)	if if${i}==1
replace item_access_${i}=min(item_access_${i},item_access_96) if if${i}==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'_${i} = max(item_noaccess_cat`c'_${i},item_noaccess_cat`c'_96) if if${i}==1
}
recode s5gq4__96	(1=0)	if if${i}==1
recode item_access_96 item_noaccess_cat*_96 (nonm=.) if if${i}==1
ta str if s5gq4__96==1


*	deal with missingness
tabstat s5gq4__*, by(s5gq3) s(n sum)
recode s5gq4__* (.=0) if s5gq3==1
tabstat s5gq4__*, by(s5gq3) s(n sum) missing



*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d s5gq4__*
d *_1
ren s5gq4__* item_need_*

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


#d ; 
collapse (min) s5gq3 
	(max) item_need_* 
	(min) item_access_* 
	(max) item_noaccess_cat*
	, by(y4_hhid);
#d cr 
tabstat item_need_*, by(s5gq3) s(n sum) m

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


*	construct the overall need category 
g item_need_11 = (s5gq3==1) if !mi(s5gq3)
recode item_need_? item_need_96 (.=0) if item_need_11==1
egen item_access_11 = rowmin(item_access_? item_access_96)
ta item_need_11 item_access_11,m	//	perfect 
foreach c of numlist 41(1)50 {
	egen item_noaccess_cat`c'_11 = rowmax(item_noaccess_cat`c'_? item_noaccess_cat`c'_96)
}
tabstat item_noaccess_cat*_11, by(item_access_11) s(n sum) missing

*	make long by item 
keep y4_hhid item*
drop *96	// we have gleaned all that we can use from these 
#d ; 
reshape long item_need_ item_access_
	item_noaccess_cat41_ item_noaccess_cat42_ item_noaccess_cat43_ 
	item_noaccess_cat44_ item_noaccess_cat45_ item_noaccess_cat46_ 
	item_noaccess_cat47_ item_noaccess_cat48_ item_noaccess_cat49_ 
	item_noaccess_cat50_
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
label_access_item
ta item item_need,m
// drop if mi(item_need)	//	 gets rid of the cases where need any medical treatment=0 
d, si

isid y4_hhid item
ta item item_need, m

tempfile health
sa		`health'


d using	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"	//	n=5472
u	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta", clear
ta fuel_id
la li fuel_items__id
recode fuel_id (10=91)(11=92)(12=93)(13=94), gen(item)
ta s11cq2
la li s11cq2
g item_access = (s11cq2==1) if inlist(s11cq2,1,2,3)
keep y4_hhid item*

isid y4_hhid item
tempfile fuel
sa		`fuel'


d using	"${raw_hfps_mwi}/sect11_transportprices_r17.dta"	//	n=6590
u	"${raw_hfps_mwi}/sect11_transportprices_r17.dta", clear
la li transportitems__id

ta s11bq1,m
g item_access = (s11bq1==1)
ta s11bq2
la li s11bq2

g item=s11bq2+30 if inrange(s11bq2,1,9)
ta item item_access,m
keep if !mi(item)
collapse (max) item_access, by(y4_hhid item)	//	duplicates are possible here due to multiple destinations

ta item item_acces,m
reshape wide item_access, i(y4_hhid) j(item)
reshape long
recode item_access (.=0)
ta item item_acces,m
keep y4_hhid item*

tempfile transit 
sa		`transit'

clear
append using `health' `fuel' `transit'
isid y4_hhid item


label_access_item


g round=  17
tempfile r17
sa		`r17'
}	/*	 r17 end	*/


{	/*	round 18	*/
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r18.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r18.dta"


u	"${raw_hfps_mwi}/sect5_healthaccessnew2_r18.dta", clear	/*	to harmonize, need to take max of this vn	*/
g str=strtrim(stritrim(strlower(s5gq6_ot)))
la li s5fq6
li service_cd str if s5gq6==96, sep(0)
recode s5gq6 (96=10)
*	little to do beyond this

la li service_type__id
recode service_cd (6=7)(7=8)

keep y4 PID service_cd s5gq5 s5gq6 
ren (s5gq5 s5gq6)(acc_ rsn_)


ta acc_,m nol
g item_access_=(acc_==1)
ta rsn_
la li s5fq6
foreach i of numlist 1/10 {
	loc z=`i'+40
	g item_noaccess_cat`z'_ = (rsn_==`i')	if item_access_==0
	}
keep y4_hhid PID service_cd item*
#d ; 
reshape wide item_access_
	item_noaccess_cat41_ item_noaccess_cat42_ item_noaccess_cat43_ 
	item_noaccess_cat44_ item_noaccess_cat45_ item_noaccess_cat46_ 
	item_noaccess_cat47_ item_noaccess_cat48_ item_noaccess_cat49_ 
	item_noaccess_cat50_	
	, i(y4_hhid PID) j(service_cd); 
#d cr 

tempfile mod2
sa		`mod2'


u	"${raw_hfps_mwi}/sect5_healthaccessnew1_r18.dta", clear	/*	to harmonize, need to take max of this vn	*/
keep y4_hhid PID s5gq3 s5gq4* 	//	not actually necessary in r17 
recode s5gq3 s5gq4__* (.a=.)
ren (s5gq4__6 s5gq4__7)(s5gq4__7 s5gq4__8)	//	make consistent 
tabstat s5gq4__*, by(s5gq3) s(n sum) m
mer 1:1 y4 PID using `mod2', assert(1 3) nogen

tabstat s5gq4__*, by(s5gq3) s(n sum) missing

isid y4 PID	//	verifying that now identified by hh individual




ta s5gq3,m	//	why is this sometimes missing? persons for whom the q is not asked 
qui : ta y4
dis r(r)	//	1347
qui : ta y4 if !mi(s5gq3)
dis r(r)	//	1345

tabstat s5gq4__*, s(n sum min max) c(s) varw(12)
ta s5gq4_os	//	need to carry any changes over to new2 work
g str=strtrim(stritrim(strlower(s5gq4_os)))
ta str if s5gq4__96==1
d s5gq4__*

gl i=5
g if${i} = 1 if inlist(str,"hiv testing","under 5 clinic","under five clinic","under5","underfive","underfive clinic-scale")
recode s5gq4__${i}		(0 .=1)	if if${i}==1
replace item_access_${i}=min(item_access_${i},item_access_96) if if${i}==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'_${i} = max(item_noaccess_cat`c'_${i},item_noaccess_cat`c'_96) if if${i}==1
}
recode s5gq4__96	(1=0)	if if${i}==1
recode item_access_96 item_noaccess_cat*_96 (nonm=.) if if${i}==1
ta str if s5gq4__96==1

gl i=8
g if${i} = 1 if inlist(str,"purchace of medicine","purchase of medicine","purchasing"	/*
*/	,"purchasing medicine","scale")
recode s5gq4__${i}		(0 .=1)	if if${i}==1
replace item_access_${i}=min(item_access_${i},item_access_96) if if${i}==1
foreach c of numlist 41(1)50 {
	replace item_noaccess_cat`c'_${i} = max(item_noaccess_cat`c'_${i},item_noaccess_cat`c'_96) if if${i}==1
}
recode s5gq4__96	(1=0)	if if${i}==1
recode item_access_96 item_noaccess_cat*_96 (nonm=.) if if${i}==1
ta str if s5gq4__96==1


*	deal with missingness
tabstat s5gq4__*, by(s5gq3) s(n sum)
recode s5gq4__* (.=0) if s5gq3==1
tabstat s5gq4__*, by(s5gq3) s(n sum) missing



*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d s5gq4__*
d *_1
ren s5gq4__* item_need_*

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


#d ; 
collapse (min) s5gq3 
	(max) item_need_* 
	(min) item_access_* 
	(max) item_noaccess_cat*
	, by(y4_hhid);
#d cr 
tabstat item_need_*, by(s5gq3) s(n sum) m

*	verify relationship between access and noaccess_cat
foreach i of numlist 1(1)5 7 8 {
ta item_need_`i' item_access_`i',m
tabstat item_noaccess_cat*_`i' , by(item_access_`i') s(n sum) m
}


*	construct the overall need category 
g item_need_11 = (s5gq3==1) if !mi(s5gq3)
recode item_need_? item_need_96 (.=0) if item_need_11==1
egen item_access_11 = rowmin(item_access_? item_access_96)
ta item_need_11 item_access_11,m	//	perfect 
foreach c of numlist 41(1)50 {
	egen item_noaccess_cat`c'_11 = rowmax(item_noaccess_cat`c'_? item_noaccess_cat`c'_96)
}
tabstat item_noaccess_cat*_11, by(item_access_11) s(n sum) missing

*	make long by item 
keep y4_hhid item*
drop *96	// we have gleaned all that we can use from these 
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat41_ item_noaccess_cat42_ item_noaccess_cat43_ 
	item_noaccess_cat44_ item_noaccess_cat45_ item_noaccess_cat46_ 
	item_noaccess_cat47_ item_noaccess_cat48_ item_noaccess_cat49_ 
	item_noaccess_cat50_	
	, i(y4_hhid) j(item); 
#d cr 
ren *_ *
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
label_access_item
ta item item_need,m
// drop if mi(item_need)	//	 gets rid of the cases where need any medical treatment=0 
d, si

isid y4_hhid item
ta item item_need, m

label_access_item


g round=  18
tempfile r18
sa		`r18'
}	/*	 r18 end	*/


{	/*	round 19	*/
d using	"${raw_hfps_mwi}/sect5_accesss_r19.dta"	
d using	"${raw_hfps_mwi}/sect11_transportprices_r19.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"	//	yes acces
u	"${raw_hfps_mwi}/sect5_accesss_r19.dta"	, clear
d s5*
ta item_id
la li sect5_access__id

recode item_id (4=16)(5=4)(6=6)(7=19)(8=90)(9=18)(10=1)(11=2)(12=40)(13=21), gen(item)
drop item_id	//	 have to do this here, as we want to continue using the itme wildcard below
label_access_item

ta s5q1a s5q1b,m
g item_need=(s5q1a==1)
g item_access=(s5q1b==1) if item_need==1
tabstat s5q1c__*, s(n sum)	//	only 5 O/S, ignore them 
d s5q1c__*	//	only 5 O/S, ignore them 
ta s5q1c_o
g item_noaccess_cat1 = s5q1c__1==1 | s5q1c__3==1 | s5q1c__5==1 if item_access==0
g item_noaccess_cat3 = s5q1c__4==1 if item_access==0
g item_noaccess_cat4 = s5q1c__6==1 if item_access==0
g item_noaccess_cat5 = s5q1c__2==1 if item_access==0
g item_noaccess_cat6 = s5q1c__7==1 if item_access==0

ta s5q2a,m
g item_fullbuy = (s5q2a==1) if item_access==1
tabstat s5q2b__*, s(n sum)	//	only 2 O/S, ignore them 

g item_ltfull_cat1 = s5q2b__1==1 | s5q2b__3==1 | s5q2b__5==1 if item_fullbuy==0
g item_ltfull_cat3 = s5q2b__4==1 if item_fullbuy==0
g item_ltfull_cat5 = s5q2b__2==1 if item_fullbuy==0
g item_ltfull_cat6 = s5q2b__6==1 if item_fullbuy==0


keep y4_hhid item*
isid y4_hhid item
tempfile general
sa		`general'

d using	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"	
u	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta", clear
ta fuel_id
la li fuel_items__id
recode fuel_id (10=91)(11=92)(12=93)(13=94), gen(item)
ta s11cq2
la li s11cq2
g item_access = (s11cq2==1) if inlist(s11cq2,1,2,3)
keep y4_hhid item*

isid y4_hhid item
tempfile fuel
sa		`fuel'


d using	"${raw_hfps_mwi}/sect11_transportprices_r19.dta"	//	n=6590
u	"${raw_hfps_mwi}/sect11_transportprices_r19.dta", clear
la li transportitems__id

ta s11bq1,m
g item_access = (s11bq1==1)
ta s11bq2
la li s11bq2

g item=s11bq2+30 if inrange(s11bq2,1,9)
ta item item_access,m
keep if !mi(item)
collapse (max) item_access, by(y4_hhid item)	//	duplicates are possible here due to multiple destinations

ta item item_access,m
reshape wide item_access, i(y4_hhid) j(item)
reshape long
recode item_access (.=0)
ta item item_acces,m

tempfile transit 
sa		`transit'

clear
append using `general' `fuel' `transit'
duplicates report y4_hhid item
isid y4_hhid item


label_access_item
ta item item_access
d, si
g round=  19
tempfile r19
sa		`r19'
}	/*	 r19 end	*/


{	/*	round 20	*/
d using	"${raw_hfps_mwi}/sect5_access_r20.dta"	
d using	"${raw_hfps_mwi}/sect5_healthaccess_r20.dta"	//	substantial reorganization vis-a-vis r18
d using	"${raw_hfps_mwi}/sect11_transportprices_r20.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_fuelprices_r20.dta"	//	yes acces

gl r=20	//	enforce the round for simplicity below

u	"${raw_hfps_mwi}/sect5_access_r${r}.dta"	, clear
d s5*
ta item_id
la li sect5_access__id

recode item_id (4=16)(5=4)(6=6)(7=19)(8=90)(9=18)(10=1)(11=2)(12=40)(13=21), gen(item)
drop item_id	//	 have to do this here, as we want to continue using the itme wildcard below
label_access_item

ta s5q1a s5q1b,m
g item_need=(s5q1a==1)
g item_access=(s5q1b==1) if item_need==1
tabstat s5q1c__*, s(n sum)	//	only 1 O/S, ignore  
g item_noaccess_cat1 = s5q1c__1==1 | s5q1c__3==1 | s5q1c__5==1 if item_access==0
g item_noaccess_cat3 = s5q1c__4==1 if item_access==0
g item_noaccess_cat4 = s5q1c__6==1 if item_access==0
g item_noaccess_cat5 = s5q1c__2==1 if item_access==0
g item_noaccess_cat6 = s5q1c__7==1 if item_access==0

ta s5q2a,m
g item_fullbuy = (s5q2a==1) if item_access==1
tabstat s5q2b__*, s(n sum)	//	only 1 O/S, ignore them 

g item_ltfull_cat1 = s5q2b__1==1 | s5q2b__3==1 | s5q2b__5==1 if item_fullbuy==0
g item_ltfull_cat3 = s5q2b__4==1 if item_fullbuy==0
g item_ltfull_cat5 = s5q2b__2==1 if item_fullbuy==0
g item_ltfull_cat6 = s5q2b__6==1 if item_fullbuy==0


keep y4_hhid item*
isid y4_hhid item
tempfile general
sa		`general'

d using	"${raw_hfps_mwi}/sect5_healthaccess_r${r}.dta"	
u		"${raw_hfps_mwi}/sect5_healthaccess_r${r}.dta", clear

la li f_services__id
recode service_id (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(else=.), gen(item)
label_access_item
drop if mi(item)	//	no category for "other health services" here
ta s5fq2a s5fq4,m

g item_need=(s5fq2a==1)
g item_access=(s5fq4==1) if item_need==1

ta s5fq5 item_access,m
la li f5
ta s5fq5_os
g str=strtrim(stritrim(strlower(s5fq5_os)))
ta str
recode s5fq5 (96=4) if inlist(str,"there was a strike")
drop str
g item_noaccess_cat6 = (inlist(s5fq5,1)) if item_access==0
g item_noaccess_cat2 = (inlist(s5fq5,2,4)) if item_access==0
g item_noaccess_cat1 = (inlist(s5fq5,3,5)) if item_access==0
g item_noaccess_cat3 = (inlist(s5fq5,6,9)) if item_access==0
g item_noaccess_cat4 = (inlist(s5fq5,8)) if item_access==0
g item_noaccess_cat11= (inlist(s5fq5,7)) if item_access==0
egen zzz = rowtotal(item_noaccess_cat*),m
ta zzz	//	code 96 means it can be 1
drop zzz

keep y4_hhid item*
isid y4_hhid item
tempfile health
sa		`health'

d using	"${raw_hfps_mwi}/sect11_fuelprices_r${r}.dta"	
u		"${raw_hfps_mwi}/sect11_fuelprices_r${r}.dta", clear
ta fuel_id
la li fuel_items__id
recode fuel_id (10=91)(11=92)(12=93)(13=94)(14=95), gen(item)
label_access_item
ta s11cq2
la li s11cq2
g item_access = (s11cq2==1) if inlist(s11cq2,1,2,3)
keep y4_hhid item*

isid y4_hhid item
tempfile fuel
sa		`fuel'


d using	"${raw_hfps_mwi}/sect11_transportprices_r${r}.dta"	//	n=6735
u		"${raw_hfps_mwi}/sect11_transportprices_r${r}.dta", clear
la li transportitems__id

ta s11bq1,m
g item_access = (s11bq1==1)
ta s11bq2
la li s11bq2

g item=s11bq2+30 if inrange(s11bq2,1,9)
ta item item_access,m
keep if !mi(item)
collapse (max) item_access, by(y4_hhid item)	//	duplicates are possible here due to multiple destinations

ta item item_access,m
reshape wide item_access, i(y4_hhid) j(item)
reshape long
recode item_access (.=0)
ta item item_acces,m

tempfile transit 
sa		`transit'



clear
append using `general' `health' `fuel' `transit'
duplicates report y4_hhid item
isid y4_hhid item


label_access_item
ta item item_access
d, si
g round=  ${r}
tempfile r${r}
sa		`r${r}'
}	/*	 r${r} end	*/



{	/*	round 21	*/
dir "${raw_hfps_mwi}/*_r21.dta"
d using	"${raw_hfps_mwi}/sect5_accesss_r21.dta"	
d using	"${raw_hfps_mwi}/sect11_transportprices_r21.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_fuelprices_r21.dta"	//	yes acces

gl r=21	//	enforce the round for simplicity below

u	"${raw_hfps_mwi}/sect5_accesss_r${r}.dta"	, clear
d s5*
ta item_id
la li sect5_access__id

recode item_id (4=16)(5=4)(6=6)(7=19)(8=90)(9=18)(10=1)(11=2)(12=40)(13=21), gen(item)
drop item_id	//	 have to do this here, as we want to continue using the itme wildcard below
label_access_item

ta s5q1a s5q1b,m
g item_need=(s5q1a==1)
g item_access=(s5q1b==1) if item_need==1
tabstat s5q1c__*, s(n sum)	//	only 1 O/S, ignore  
g item_noaccess_cat1 = s5q1c__1==1 | s5q1c__3==1 | s5q1c__5==1 if item_access==0
g item_noaccess_cat3 = s5q1c__4==1 if item_access==0
g item_noaccess_cat4 = s5q1c__6==1 if item_access==0
g item_noaccess_cat5 = s5q1c__2==1 if item_access==0
g item_noaccess_cat6 = s5q1c__7==1 if item_access==0

ta s5q2a,m
g item_fullbuy = (s5q2a==1) if item_access==1
tabstat s5q2b__*, s(n sum)	//	only 1 O/S, ignore them 

g item_ltfull_cat1 = s5q2b__1==1 | s5q2b__3==1 | s5q2b__5==1 if item_fullbuy==0
g item_ltfull_cat3 = s5q2b__4==1 if item_fullbuy==0
g item_ltfull_cat5 = s5q2b__2==1 if item_fullbuy==0
g item_ltfull_cat6 = s5q2b__6==1 if item_fullbuy==0


keep y4_hhid item*
isid y4_hhid item
tempfile general
sa		`general'


d using	"${raw_hfps_mwi}/sect11_fuelprices_r${r}.dta"	
u		"${raw_hfps_mwi}/sect11_fuelprices_r${r}.dta", clear
ta fuel_id
la li fuel_items__id
recode fuel_id (10=91)(11=92)(12=93)(13=94)(14=95), gen(item)
label_access_item
ta s11cq2
la li s11cq2
g item_access = (s11cq2==1) if inlist(s11cq2,1,2,3)
keep y4_hhid item*

isid y4_hhid item
tempfile fuel
sa		`fuel'


d using	"${raw_hfps_mwi}/sect11_transportprices_r${r}.dta"	//	n=6735
u		"${raw_hfps_mwi}/sect11_transportprices_r${r}.dta", clear
la li transportitems__id

ta s11bq1,m
g item_access = (s11bq1==1)
ta s11bq2
la li s11bq2

g item=s11bq2+30 if inrange(s11bq2,1,9)
ta item item_access,m
keep if !mi(item)
collapse (max) item_access, by(y4_hhid item)	//	duplicates are possible here due to multiple destinations

ta item item_access,m
reshape wide item_access, i(y4_hhid) j(item)
reshape long
recode item_access (.=0)
ta item item_acces,m

tempfile transit 
sa		`transit'



clear
append using `general' `health' `fuel' `transit'
duplicates report y4_hhid item
isid y4_hhid item


label_access_item
ta item item_access
d, si
g round=  ${r}
tempfile r${r}
sa		`r${r}'
}	/*	 r${r} end	*/



/*	append all rounds	*/
clear
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8' `r9' `r11' `r12' `r13' `r14' `r15' `r16' `r17' `r18' `r19' `r20' `r21', nolabel
isid	y4_hhid round item
order	y4_hhid round item
sort	y4_hhid round item

ta item
label_access_item
ta item round

*	need to harmonize item once other versions are available 
#d ; 
order item_need item_access 
	item_noaccess_cat? item_noaccess_cat1? item_noaccess_cat3? item_noaccess_cat9?
	item_fullbuy item_ltfull_cat?, a(item); 
#d cr 

*	label contents here, but these are subject to reorganization in the panel construction
la var item_need		"HH needed item in last 7 days"
la var item_access		"HH accessed item in last 7 days"

label_item_ltfull noaccess

la var item_fullbuy		"HH accessed full amount of item needed in last 7 days"

label_item_ltfull ltfull


sa "${tmp_hfps_mwi}/access.dta", replace 
u  "${tmp_hfps_mwi}/access.dta", clear 

cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex

ex















