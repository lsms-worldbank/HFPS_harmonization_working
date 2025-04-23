


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

d using	"${raw_hfps_uga}/round1/SEC4.dta"
d using	"${raw_hfps_uga}/round2/SEC4.dta"
d using	"${raw_hfps_uga}/round3/SEC4.dta"
d using	"${raw_hfps_uga}/round4/SEC4.dta"
d using	"${raw_hfps_uga}/round5/SEC4.dta"
d using	"${raw_hfps_uga}/round6/SEC4A.dta"	//	some asset ownership but a few yes/no purchase questions as well
d using	"${raw_hfps_uga}/round6/SEC4_1.dta"	//	a basic price module, and some food access 
d using	"${raw_hfps_uga}/round6/SEC4_2.dta"	//	health access
d using	"${raw_hfps_uga}/round7/SEC4_1.dta"	//	mask
d using	"${raw_hfps_uga}/round7/SEC4_2.dta"	
d using	"${raw_hfps_uga}/round8/SEC4.dta"	//	new version, identified at hhid goods_access__id level
d using	"${raw_hfps_uga}/round8/SEC4A_1.dta"	//	phase 2 health 
d using	"${raw_hfps_uga}/round8/SEC4A_2.dta"	//	phase 2 health 
d using	"${raw_hfps_uga}/round9/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round9/SEC4A_1.dta"	//	as in r8
d using	"${raw_hfps_uga}/round9/SEC4A_2.dta"	//	as in r8
d using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round10/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round10/SEC2A_2.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round11/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round11/SEC2A_2.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round12/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round12/SEC2A_2.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round13/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round13/SEC2A_2.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round15/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round15/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round15/SEC2A_2.dta"	//	similar to r8, but includes other individual vars
d using	"${raw_hfps_uga}/round17/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round17/SEC2A_1.dta"	//	as in r8, but at person level 
d using	"${raw_hfps_uga}/round17/SEC2A_2.dta"	//	similar to r8, but includes other individual vars

*	can treat rounds 8-13 in a batch 

*	automated comparison


*	going round by round
run "${do_hfps_util}/label_access_item.do"	//	defines label program 
run "${do_hfps_util}/label_item_ltfull.do"	//	defines label program for less than full variable labels 



{	/*	round 1	*/
d using	"${raw_hfps_uga}/round1/SEC4.dta"
u		"${raw_hfps_uga}/round1/SEC4.dta", clear

ta s4q01,m	
la li s4q01
g item_fullbuy_2 = (s4q01==1)	if !mi(s4q01)

ta s4q02
la li s4q02
g item_ltfull_cat1_2	= (s4q02==1) if !mi(s4q02)
g item_ltfull_cat2_2	= (s4q02==2) if !mi(s4q02)
g item_ltfull_cat3_2	= (s4q02==3) if !mi(s4q02)
g item_ltfull_cat4_2	= (s4q02==4) if !mi(s4q02)
g item_ltfull_cat5_2	= (s4q02==5) if !mi(s4q02)
g item_ltfull_cat6_2	= (s4q02==7) if !mi(s4q02)
g item_ltfull_cat11_2	= (s4q02==8) if !mi(s4q02)
g item_ltfull_cat31_2	= (s4q02==6) if !mi(s4q02)

ta s4q01 s4q03,m
g item_fullbuy_10 = (s4q03==1)	if !mi(s4q03)
ta s4q04,m
la li s4q04

g item_ltfull_cat1_10	= (s4q04==4)	if !mi(s4q04)
g item_ltfull_cat2_10	= (s4q04==5)	if !mi(s4q04)
g item_ltfull_cat3_10	= (s4q04==6)	if !mi(s4q04)
g item_ltfull_cat4_10	= (s4q04==7)	if !mi(s4q04)
g item_ltfull_cat5_10	= (s4q04==8)	if !mi(s4q04)
g item_ltfull_cat6_10	= (s4q04==10)	if !mi(s4q04)
g item_ltfull_cat11_10	= (s4q04==11)	if !mi(s4q04)
g item_ltfull_cat31_10	= (s4q04==9)	if !mi(s4q04)
g item_ltfull_cat91_10	= (s4q04==1)	if !mi(s4q04)
g item_ltfull_cat92_10	= (s4q04==2)	if !mi(s4q04)
g item_ltfull_cat93_10	= (s4q04==3)	if !mi(s4q04)

ta s4q05	//	the staple 
la li s4q05
ta s4q06,m
g item_need_15		= (inlist(s4q06,1,2))	if !mi(s4q06)
g item_access_15	= (s4q06==2) 			if item_need_15==1

ta s4q07 s4q06,m	//	substantial O/S 
la li s4q07
g item_noaccess_cat1_15		= (s4q07==1) if !mi(s4q07)
g item_noaccess_cat2_15		= (s4q07==2) if !mi(s4q07)
g item_noaccess_cat3_15		= (s4q07==3) if !mi(s4q07)
g item_noaccess_cat4_15		= (s4q07==4) if !mi(s4q07)
g item_noaccess_cat5_15		= (s4q07==5) if !mi(s4q07)
g item_noaccess_cat31_15	= (s4q07==6) if !mi(s4q07)

recode s4q05 (1=16)(2=4)(3=17)(4=6)(5=18)(6=19)(7=7)(8=20), gen(staple)
foreach x of numlist 16 4 17 6 18 19 7 20 { 
	g item_need_`x'		= (inlist(s4q06,1,2))	if !mi(s4q06)		& staple==`x'
	g item_access_`x'	= (inlist(s4q06,2))		if item_need_`x'==1	& staple==`x'
	g item_noaccess_cat1_`x'	= (s4q07==1) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat2_`x'	= (s4q07==2) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat3_`x'	= (s4q07==3) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat4_`x'	= (s4q07==4) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat5_`x'	= (s4q07==5) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat31_`x'	= (s4q07==6) if !mi(s4q07) & staple==`x'

	}

ta s4q07a	//	the "sauce"
la li s4q07a
ta s4q07b
g item_need_60		= (inlist(s4q07b,1,2))	if !mi(s4q07b)
g item_access_60	= (s4q07b==2)			if item_need_60==1

ta s4q07c,m
la li s4q07c
g item_noaccess_cat1_60		= (s4q07c==1) if !mi(s4q07c)
g item_noaccess_cat2_60		= (s4q07c==2) if !mi(s4q07c)
g item_noaccess_cat3_60		= (s4q07c==3) if !mi(s4q07c)
g item_noaccess_cat4_60		= (s4q07c==4) if !mi(s4q07c)
g item_noaccess_cat5_60		= (s4q07c==5) if !mi(s4q07c)
g item_noaccess_cat31_60	= (s4q07c==6) if !mi(s4q07c)

recode s4q07a (1=5)(2=61)(4=62)(5=63)(6=64)(7=65)(8=66)(9=67)(10=68), gen(sauce)
foreach x of numlist 5 61(1)68 { 
	g item_need_`x'		= (inlist(s4q07b,1,2))	if !mi(s4q07b)		& sauce==`x'
	g item_access_`x'	= (inlist(s4q07b,2))	if item_need_`x'==1	& sauce==`x'
	g item_noaccess_cat1_`x'	= (s4q07c==1) if !mi(s4q07c) & sauce==`x'
	g item_noaccess_cat2_`x'	= (s4q07c==2) if !mi(s4q07c) & sauce==`x'
	g item_noaccess_cat3_`x'	= (s4q07c==3) if !mi(s4q07c) & sauce==`x'
	g item_noaccess_cat4_`x'	= (s4q07c==4) if !mi(s4q07c) & sauce==`x'
	g item_noaccess_cat5_`x'	= (s4q07c==5) if !mi(s4q07c) & sauce==`x'
	g item_noaccess_cat31_`x'	= (s4q07c==6) if !mi(s4q07c) & sauce==`x'

	}

*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q09 s4q10,m
g item_need_11		= s4q09==1 if !mi(s4q09)
g item_access_11	= (s4q10==1)	if item_need_11==1
ta s4q11	
la li s4q11
g item_noaccess_cat1_11		= (s4q11==3) if !mi(s4q11)
g item_noaccess_cat2_11		= inlist(s4q11,2,5) if !mi(s4q11)
g item_noaccess_cat3_11		= (s4q11==7) if !mi(s4q11)
g item_noaccess_cat4_11		= (s4q11==6) if !mi(s4q11)
g item_noaccess_cat6_11		= (s4q11==1) if !mi(s4q11)
g item_noaccess_cat11_11	= (s4q11==4) if !mi(s4q11)

*	skipping education right now

*	financial services
ta s4q18,m
g item_need_25 		= s4q18==1	if !mi(s4q18)
g item_access_25	= s4q19==1	if item_need_25==1
ta s4q20
la li s4q20
g item_noaccess_cat2_25		= (s4q20==1) if !mi(s4q20)
g item_noaccess_cat4_25		= (s4q20==2) if !mi(s4q20)
g item_noaccess_cat31_25	= (s4q20==3) if !mi(s4q20)


*	set to hhid item
keep hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_		
	
	item_fullbuy_
	item_ltfull_cat1_	item_ltfull_cat2_	item_ltfull_cat3_	
	item_ltfull_cat4_	item_ltfull_cat5_	item_ltfull_cat6_	
	item_ltfull_cat11_	item_ltfull_cat31_	
	item_ltfull_cat91_	item_ltfull_cat92_	item_ltfull_cat93_	
, i(hhid) j(item);
#d cr
ren *_ *
	
isid hhid item
sort hhid item
label_access_item

g round=  1
tempfile r1
sa		`r1'
}	/*	 r1 end	*/


{	/*	round 2	*/
d using	"${raw_hfps_uga}/round2/SEC4.dta"
u		"${raw_hfps_uga}/round2/SEC4.dta", clear

ta s4q01e,m	
la li s4q01e
g item_fullbuy_9 = (s4q01e==2)	if !mi(s4q01e)

ta s4q01f
la li s4q01f
g item_ltfull_cat1_9	= (s4q01f==4)	if !mi(s4q01f)
g item_ltfull_cat2_9	= (s4q01f==5)	if !mi(s4q01f)
g item_ltfull_cat3_9	= (s4q01f==6)	if !mi(s4q01f)
g item_ltfull_cat4_9	= (s4q01f==7)	if !mi(s4q01f)
g item_ltfull_cat5_9	= (s4q01f==8)	if !mi(s4q01f)
g item_ltfull_cat6_9	= (s4q01f==10)	if !mi(s4q01f)
g item_ltfull_cat11_9	= (s4q01f==11)	if !mi(s4q01f)
g item_ltfull_cat91_9	= (s4q01f==1)	if !mi(s4q01f)
g item_ltfull_cat92_9	= (s4q01f==2)	if !mi(s4q01f)
g item_ltfull_cat93_9	= (s4q01f==3)	if !mi(s4q01f)


ta s4q01 s4q03,m
g item_fullbuy_2	= (s4q01==1)	if !mi(s4q01)
ta s4q02 s4q01,m
la li s4q02

g item_ltfull_cat1_2	= (s4q02==1) if !mi(s4q02)
g item_ltfull_cat2_2	= (s4q02==2) if !mi(s4q02)
g item_ltfull_cat3_2	= (s4q02==3) if !mi(s4q02)
g item_ltfull_cat4_2	= (s4q02==4) if !mi(s4q02)
g item_ltfull_cat5_2	= (s4q02==5) if !mi(s4q02)
g item_ltfull_cat6_2	= (s4q02==7) if !mi(s4q02)
g item_ltfull_cat11_2	= (s4q02==8) if !mi(s4q02)
g item_ltfull_cat31_2	= (s4q02==6) if !mi(s4q02)


g item_fullbuy_10	= (s4q03==1)	if !mi(s4q03)
ta s4q04 s4q03,m
la li s4q04

g item_ltfull_cat1_10	= (s4q04==4)	if !mi(s4q04)
g item_ltfull_cat2_10	= (s4q04==5)	if !mi(s4q04)
g item_ltfull_cat3_10	= (s4q04==6)	if !mi(s4q04)
g item_ltfull_cat4_10	= (s4q04==7)	if !mi(s4q04)
g item_ltfull_cat5_10	= (s4q04==8)	if !mi(s4q04)
g item_ltfull_cat6_10	= (s4q04==10)	if !mi(s4q04)
g item_ltfull_cat11_10	= (s4q04==11)	if !mi(s4q04)
g item_ltfull_cat31_10	= (s4q04==9)	if !mi(s4q04)
g item_ltfull_cat91_10	= (s4q04==1)	if !mi(s4q04)
g item_ltfull_cat92_10	= (s4q04==2)	if !mi(s4q04)
g item_ltfull_cat93_10	= (s4q04==3)	if !mi(s4q04)


*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q09 s4q10,m
g item_need_11		= s4q09==1 if !mi(s4q09)
g item_access_11	= (s4q10==1)	if item_need_11==1
ta s4q11	
la li s4q11
g item_noaccess_cat1_11		= (s4q11==3) if !mi(s4q11)
g item_noaccess_cat2_11		= inlist(s4q11,2,5) if !mi(s4q11)
g item_noaccess_cat3_11		= (s4q11==7) if !mi(s4q11)
g item_noaccess_cat4_11		= (s4q11==6) if !mi(s4q11)
g item_noaccess_cat6_11		= (s4q11==1) if !mi(s4q11)
g item_noaccess_cat11_11	= (s4q11==4) if !mi(s4q11)


*	set to hhid item
keep hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_		
	
	item_fullbuy_
	item_ltfull_cat1_	item_ltfull_cat2_	item_ltfull_cat3_	
	item_ltfull_cat4_	item_ltfull_cat5_	item_ltfull_cat6_	
	item_ltfull_cat11_	item_ltfull_cat31_	
	item_ltfull_cat91_	item_ltfull_cat92_	item_ltfull_cat93_	
, i(hhid) j(item);
#d cr
ren *_ *
	
isid hhid item
sort hhid item
label_access_item

g round=  2
tempfile r2
sa		`r2'
}	/*	 r2 end	*/


{	/*	round 3	*/
d using	"${raw_hfps_uga}/round3/SEC4.dta"
u		"${raw_hfps_uga}/round3/SEC4.dta", clear

ta s4q05	//	the staple 
la li s4q05
ta s4q06,m
g item_need_15		= (inlist(s4q06,1,2))	if !mi(s4q06)
g item_access_15	= (s4q06==2) 			if item_need_15==1

ta s4q07 s4q06,m
la li s4q07
g item_noaccess_cat1_15		= (s4q07==1) if !mi(s4q07)
g item_noaccess_cat2_15		= (s4q07==2) if !mi(s4q07)
g item_noaccess_cat3_15		= (s4q07==3) if !mi(s4q07)
g item_noaccess_cat4_15		= (s4q07==4) if !mi(s4q07)
g item_noaccess_cat5_15		= (s4q07==5) if !mi(s4q07)
g item_noaccess_cat31_15	= (s4q07==6) if !mi(s4q07)

recode s4q05 (1=16)(2=4)(3=17)(4=6)(5=18)(6=19)(7=7)(8=20), gen(staple)
foreach x of numlist 16 4 17 6 18 19 7 20 { 
	g item_need_`x'		= (inlist(s4q06,1,2))	if !mi(s4q06)		& staple==`x'
	g item_access_`x'	= (inlist(s4q06,2))		if item_need_`x'==1	& staple==`x'
	g item_noaccess_cat1_`x'	= (s4q07==1) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat2_`x'	= (s4q07==2) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat3_`x'	= (s4q07==3) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat4_`x'	= (s4q07==4) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat5_`x'	= (s4q07==5) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat31_`x'	= (s4q07==6) if !mi(s4q07) & staple==`x'

	}


*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q09 s4q10,m
g item_need_11		= s4q09==1 if !mi(s4q09)
g item_access_11	= (s4q10==1)	if item_need_11==1
ta s4q11	
la li s4q11
g item_noaccess_cat1_11		= (s4q11==3) if !mi(s4q11)
g item_noaccess_cat2_11		= inlist(s4q11,2,5) if !mi(s4q11)
g item_noaccess_cat3_11		= (s4q11==7) if !mi(s4q11)
g item_noaccess_cat4_11		= (s4q11==6) if !mi(s4q11)
g item_noaccess_cat6_11		= (s4q11==1) if !mi(s4q11)
g item_noaccess_cat11_11	= (s4q11==4) if !mi(s4q11)


*	mask
ta s4q12
g item_need_26		= inlist(s4q12,1,2) if !mi(s4q12)
g item_access_26	= (s4q12==2)	if item_need_26==1
ta s4q13
la li s4q13
g item_noaccess_cat1_26		= (s4q13==1) if !mi(s4q13)
g item_noaccess_cat2_26		= (s4q13==2) if !mi(s4q13)
g item_noaccess_cat5_26		= (s4q13==3) if !mi(s4q13)
g item_noaccess_cat6_26		= (s4q13==4) if !mi(s4q13)
g item_noaccess_cat11_26	= (s4q13==5) if !mi(s4q13)




*	set to hhid item
keep hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_		
	
, i(hhid) j(item);
#d cr
ren *_ *
	
isid hhid item
sort hhid item
label_access_item

g round=  3
tempfile r3
sa		`r3'
}	/*	 r3 end	*/


{	/*	round 4	*/
d using	"${raw_hfps_uga}/round4/SEC4.dta"
u		"${raw_hfps_uga}/round4/SEC4.dta", clear


ta s4q1e,m	
la li s4q1e
g item_fullbuy_9 = (s4q1e==2)	if !mi(s4q1e)

ta s4q1f
la li s4q1f
g item_ltfull_cat1_9	= (s4q1f==4)	if !mi(s4q1f)
g item_ltfull_cat2_9	= (s4q1f==5)	if !mi(s4q1f)
g item_ltfull_cat3_9	= (s4q1f==6)	if !mi(s4q1f)
g item_ltfull_cat4_9	= (s4q1f==7)	if !mi(s4q1f)
g item_ltfull_cat5_9	= (s4q1f==8)	if !mi(s4q1f)
g item_ltfull_cat6_9	= (s4q1f==10)	if !mi(s4q1f)
g item_ltfull_cat11_9	= (s4q1f==11)	if !mi(s4q1f)
g item_ltfull_cat91_9	= (s4q1f==1)	if !mi(s4q1f)
g item_ltfull_cat92_9	= (s4q1f==2)	if !mi(s4q1f)
g item_ltfull_cat93_9	= (s4q1f==3)	if !mi(s4q1f)


ta s4q01 s4q03,m
g item_fullbuy_2	= (s4q01==1)	if !mi(s4q01)
ta s4q02 s4q01,m
la li s4q02

g item_ltfull_cat1_2	= (s4q02==1) if !mi(s4q02)
g item_ltfull_cat2_2	= (s4q02==2) if !mi(s4q02)
g item_ltfull_cat3_2	= (s4q02==3) if !mi(s4q02)
g item_ltfull_cat4_2	= (s4q02==4) if !mi(s4q02)
g item_ltfull_cat5_2	= (s4q02==5) if !mi(s4q02)
g item_ltfull_cat6_2	= (s4q02==7) if !mi(s4q02)
g item_ltfull_cat11_2	= (s4q02==8) if !mi(s4q02)
g item_ltfull_cat31_2	= (s4q02==6) if !mi(s4q02)


g item_fullbuy_10	= (s4q03==1)	if !mi(s4q03)
ta s4q04 s4q03,m
la li s4q04

g item_ltfull_cat1_10	= (s4q04==4)	if !mi(s4q04)
g item_ltfull_cat2_10	= (s4q04==5)	if !mi(s4q04)
g item_ltfull_cat3_10	= (s4q04==6)	if !mi(s4q04)
g item_ltfull_cat4_10	= (s4q04==7)	if !mi(s4q04)
g item_ltfull_cat5_10	= (s4q04==8)	if !mi(s4q04)
g item_ltfull_cat6_10	= (s4q04==10)	if !mi(s4q04)
g item_ltfull_cat11_10	= (s4q04==11)	if !mi(s4q04)
g item_ltfull_cat31_10	= (s4q04==9)	if !mi(s4q04)
g item_ltfull_cat91_10	= (s4q04==1)	if !mi(s4q04)
g item_ltfull_cat92_10	= (s4q04==2)	if !mi(s4q04)
g item_ltfull_cat93_10	= (s4q04==3)	if !mi(s4q04)


*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q09 s4q10,m 
g item_need_11		= s4q09==1 if !mi(s4q09)
g item_access_11	= (s4q10==1)	if item_need_11==1
ta s4q11	
la li s4q11
g item_noaccess_cat1_11		= (s4q11==3) if !mi(s4q11)
g item_noaccess_cat2_11		= inlist(s4q11,2,5) if !mi(s4q11)
g item_noaccess_cat3_11		= (s4q11==7) if !mi(s4q11)
g item_noaccess_cat4_11		= (s4q11==6) if !mi(s4q11)
g item_noaccess_cat6_11		= (s4q11==1) if !mi(s4q11)
g item_noaccess_cat11_11	= (s4q11==4) if !mi(s4q11)


*	mask
ta s4q12
g item_need_26		= inlist(s4q12,1,2) if !mi(s4q12)
g item_access_26	= (s4q12==2)	if item_need_26==1
ta s4q13
la li s4q13
g item_noaccess_cat1_26		= (s4q13==1) if !mi(s4q13)
g item_noaccess_cat2_26		= (s4q13==2) if !mi(s4q13)
g item_noaccess_cat5_26		= (s4q13==3) if !mi(s4q13)
g item_noaccess_cat6_26		= (s4q13==4) if !mi(s4q13)
g item_noaccess_cat11_26	= (s4q13==5) if !mi(s4q13)




*	set to hhid item
keep hhid item*
d,f
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_		

	item_fullbuy_
	item_ltfull_cat1_	item_ltfull_cat2_	item_ltfull_cat3_	
	item_ltfull_cat4_	item_ltfull_cat5_	item_ltfull_cat6_	
	item_ltfull_cat11_	item_ltfull_cat31_		
	item_ltfull_cat91_	item_ltfull_cat92_	item_ltfull_cat93_	
	
, i(hhid) j(item);
#d cr
d,f
ren *_ *
	
isid hhid item
sort hhid item
label_access_item

g round=  4
tempfile r4
sa		`r4'
}	/*	 r4 end	*/


{	/*	round 5	*/
d using	"${raw_hfps_uga}/round5/SEC4.dta"
u		"${raw_hfps_uga}/round5/SEC4.dta", clear


ta s4q05	//	the staple 
la li s4q05
ta s4q06,m
g item_need_15		= (inlist(s4q06,1,2))	if !mi(s4q06)
g item_access_15	= (s4q06==2) 			if item_need_15==1

ta s4q07 s4q06,m
la li s4q07
g item_noaccess_cat1_15		= (s4q07==1) if !mi(s4q07)
g item_noaccess_cat2_15		= (s4q07==2) if !mi(s4q07)
g item_noaccess_cat3_15		= (s4q07==3) if !mi(s4q07)
g item_noaccess_cat4_15		= (s4q07==4) if !mi(s4q07)
g item_noaccess_cat5_15		= (s4q07==5) if !mi(s4q07)
g item_noaccess_cat31_15	= (s4q07==6) if !mi(s4q07)

recode s4q05 (1=16)(2=4)(3=17)(4=6)(5=18)(6=19)(7=7)(8=20), gen(staple)
foreach x of numlist 16 4 17 6 18 19 7 20 { 
	g item_need_`x'		= (inlist(s4q06,1,2))	if !mi(s4q06)		& staple==`x'
	g item_access_`x'	= (inlist(s4q06,2))		if item_need_`x'==1	& staple==`x'
	g item_noaccess_cat1_`x'	= (s4q07==1) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat2_`x'	= (s4q07==2) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat3_`x'	= (s4q07==3) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat4_`x'	= (s4q07==4) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat5_`x'	= (s4q07==5) if !mi(s4q07) & staple==`x'
	g item_noaccess_cat31_`x'	= (s4q07==6) if !mi(s4q07) & staple==`x'

	}





*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q09 s4q10,m
g item_need_11		= s4q09==1 if !mi(s4q09)
g item_access_11	= (s4q10==1)	if item_need_11==1
ta s4q11	
la li s4q11
g item_noaccess_cat1_11		= (s4q11==3) if !mi(s4q11)
g item_noaccess_cat2_11		= inlist(s4q11,2,5) if !mi(s4q11)
g item_noaccess_cat3_11		= (s4q11==7) if !mi(s4q11)
g item_noaccess_cat4_11		= (s4q11==6) if !mi(s4q11)
g item_noaccess_cat6_11		= (s4q11==1) if !mi(s4q11)
g item_noaccess_cat11_11	= (s4q11==4) if !mi(s4q11)


*	mask
ta s4q12
g item_need_26		= inlist(s4q12,1,2) if !mi(s4q12)
g item_access_26	= (s4q12==2)	if item_need_26==1
ta s4q13
la li s4q13
g item_noaccess_cat1_26		= (s4q13==1) if !mi(s4q13)
g item_noaccess_cat2_26		= (s4q13==2) if !mi(s4q13)
g item_noaccess_cat5_26		= (s4q13==3) if !mi(s4q13)
g item_noaccess_cat6_26		= (s4q13==4) if !mi(s4q13)
g item_noaccess_cat11_26	= (s4q13==5) if !mi(s4q13)




*	set to hhid item
keep hhid item*
d,f
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
	item_noaccess_cat4_		item_noaccess_cat5_		item_noaccess_cat6_	
	item_noaccess_cat11_	item_noaccess_cat31_		
	
, i(hhid) j(item);
#d cr
ren *_ *
	
isid hhid item
sort hhid item
label_access_item

g round=  5
tempfile r5
sa		`r5'
}	/*	 r5 end	*/


{	/*	round 6	*/
d using	"${raw_hfps_uga}/round6/SEC4A.dta"
d using	"${raw_hfps_uga}/round6/SEC4_1.dta"
d using	"${raw_hfps_uga}/round6/SEC4_2.dta"

u		"${raw_hfps_uga}/round6/SEC4A.dta", clear
la li s4cq01 s4cq02 s4cq03 s4cq04 s4cq05 s4cq06 s4cq07 s4cq08

g item_access_22	= (s4aq04==1)
g item_access_71	= (s4aq05==1)
g item_access_72	= (s4aq08==1)

*	set to hhid item
keep hhid item*
d,f
#d ; 
reshape long item_access_ 
, i(hhid) j(item);
#d cr
ren *_ *
label_access_item
tempfile r6_4a
sa		`r6_4a'
	
u	"${raw_hfps_uga}/round6/SEC4_1.dta", clear

*	soap and washing water 
ta s4q01 s4q03,m
g item_fullbuy_2	= (s4q01==1)	if !mi(s4q01)
ta s4q02 s4q01,m
la li s4q02

g item_ltfull_cat1_2	= (s4q02==1) if !mi(s4q02)
g item_ltfull_cat2_2	= (s4q02==2) if !mi(s4q02)
g item_ltfull_cat3_2	= (s4q02==3) if !mi(s4q02)
g item_ltfull_cat4_2	= (s4q02==4) if !mi(s4q02)
g item_ltfull_cat5_2	= (s4q02==5) if !mi(s4q02)
g item_ltfull_cat6_2	= (s4q02==7) if !mi(s4q02)
g item_ltfull_cat11_2	= (s4q02==8) if !mi(s4q02)
g item_ltfull_cat31_2	= (s4q02==6) if !mi(s4q02)


g item_fullbuy_10	= (s4q03==1)	if !mi(s4q03)
ta s4q04 s4q03,m
la li s4q04

g item_ltfull_cat1_10	= (s4q04==4)	if !mi(s4q04)
g item_ltfull_cat2_10	= (s4q04==5)	if !mi(s4q04)
g item_ltfull_cat3_10	= (s4q04==6)	if !mi(s4q04)
g item_ltfull_cat4_10	= (s4q04==7)	if !mi(s4q04)
g item_ltfull_cat5_10	= (s4q04==8)	if !mi(s4q04)
g item_ltfull_cat6_10	= (s4q04==10)	if !mi(s4q04)
g item_ltfull_cat11_10	= (s4q04==11)	if !mi(s4q04)
g item_ltfull_cat31_10	= (s4q04==9)	if !mi(s4q04)
g item_ltfull_cat91_10	= (s4q04==1)	if !mi(s4q04)
g item_ltfull_cat92_10	= (s4q04==2)	if !mi(s4q04)
g item_ltfull_cat93_10	= (s4q04==3)	if !mi(s4q04)


*	food purchases 
tab1 s4q04_1__?,m
la li s4q04_1__1

g item_access_16=s4q04_1__1==1 if !mi(s4q04_1__1)
g item_access_4 =s4q04_1__2==1 if !mi(s4q04_1__2)
g item_access_5 =s4q04_1__3==1 if !mi(s4q04_1__3)


*	mask
ta s4q12
g item_need_26		= inlist(s4q12,1,2) if !mi(s4q12)
g item_access_26	= (s4q12==2)	if item_need_26==1
ta s4q13
la li s4q13
g item_noaccess_cat1_26		= (s4q13==1) if !mi(s4q13)
g item_noaccess_cat2_26		= (s4q13==2) if !mi(s4q13)
g item_noaccess_cat5_26		= (s4q13==3) if !mi(s4q13)
g item_noaccess_cat6_26		= (s4q13==4) if !mi(s4q13)
g item_noaccess_cat11_26	= (s4q13==5) if !mi(s4q13)


*	medicine
ta s4q08,m
g item_need_1		= inlist(s4q08,1,2) if !mi(s4q08)
g item_access_1		= (s4q08==2)	if item_need_1==1

*	medical treatment
ta s4q19,m
la li s4q19
g item_need_11		= s4q19==1 if inlist(s4q19,0,1)

tabstat s4q19 s4q20*, s(n sum me) c(s)
la li s4q20__1 s4q20__2 s4q20__3 s4q20__4 s4q20__5 s4q20__6 s4q20__7
g item_need_51	= (s4q20__1==1)	if inlist(s4q19,0,1)
g item_need_52	= (s4q20__2==1)	if inlist(s4q19,0,1)
g item_need_53	= (s4q20__3==1)	if inlist(s4q19,0,1)
g item_need_54	= (s4q20__4==1)	if inlist(s4q19,0,1)
g item_need_55	= (s4q20__5==1)	if inlist(s4q19,0,1)
g item_need_56	= (s4q20__6==1)	if inlist(s4q19,0,1)
g item_need_57	= (s4q20__7==1)	if inlist(s4q19,0,1)

	*	where are q21 and q22? 	*->	4_2

keep hhid item*
#d ; 
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		
	item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_		
	item_fullbuy_
	item_ltfull_cat1_	item_ltfull_cat2_	item_ltfull_cat3_	
	item_ltfull_cat4_	item_ltfull_cat5_	item_ltfull_cat6_	
	item_ltfull_cat11_	item_ltfull_cat31_		
	item_ltfull_cat91_	item_ltfull_cat92_	item_ltfull_cat93_	
	, i(hhid) j(item); 
#d cr 
ren *_ *
label_access_item

tempfile r6_4_1
sa		`r6_4_1'


d using	"${raw_hfps_uga}/round6/SEC4_2.dta"
u		"${raw_hfps_uga}/round6/SEC4_2.dta", clear
la li medical_access__id
la li s4q21 s4q22
reshape long medical_access__id_ s4q21_ s4q22_, i(hhid) j(rank)
drop if !inrange(medical_access__id_,1,7)
g item = medical_access__id_ + 50 
label_access_item
isid hhid item
la dir
// la li s4q21 s4q22
ta s4q21_,m
ta s4q22_,m

g item_access = (s4q21_==1) 
g item_noaccess_cat1 = (inlist(s4q22_,3,5)) if s4q21_!=1
g item_noaccess_cat2 = (inlist(s4q22_,2,4)) if s4q21_!=1
g item_noaccess_cat3 = (inlist(s4q22_,6)) if s4q21_!=1
g item_noaccess_cat4 = (inlist(s4q22_,8)) if s4q21_!=1
g item_noaccess_cat6 = (inlist(s4q22_,1)) if s4q21_!=1
g item_noaccess_cat11= (inlist(s4q22_,7)) if s4q21_!=1

keep hhid item*
mer 1:1 hhid item using `r6_4_1', assert(2 3) nogen
ta item item_access,m
ta item item_need,m
tabstat item_access item_need, by(item) s(n sum) longstub c(s)
recode item_access (.=0) if item_need==1 & inrange(item,51,57)

isid hhid item
sort hhid item
mer 1:1 hhid item using `r6_4a', assert(1 2) nogen

ta item item_access,m
ta item item_need,m


g round=  6
tempfile r6
sa		`r6'
}	/*	 r6 end	*/


{	/*	round 7	*/
d using	"${raw_hfps_uga}/round7/SEC4_1.dta"
d using	"${raw_hfps_uga}/round7/SEC4_2.dta"


u	"${raw_hfps_uga}/round7/SEC4_1.dta", clear
*	mask
ta s4q12,m
g item_need_26		= inlist(s4q12,1,2) if !mi(s4q12)
la li s4q12
g item_access_26	= (s4q12==2)	if item_need_26==1
ta s4q13
la li s4q13
g item_noaccess_cat1_26		= (s4q13==1) if !mi(s4q13)
g item_noaccess_cat2_26		= (s4q13==2) if !mi(s4q13)
g item_noaccess_cat5_26		= (s4q13==3) if !mi(s4q13)
g item_noaccess_cat6_26		= (s4q13==4) if !mi(s4q13)
g item_noaccess_cat11_26	= (s4q13==5) if !mi(s4q13)


*	medicine
ta s4q15,m
g item_need_1		= inlist(s4q15,1,2) if !mi(s4q15)
g item_access_1		= (s4q15==2)	if item_need_1==1

keep hhid item*
#d ; 
reshape long item_need_ item_access_
	item_noaccess_cat1_		item_noaccess_cat2_		
	item_noaccess_cat5_		item_noaccess_cat6_		
	item_noaccess_cat11_			
	, i(hhid) j(item);
#d cr
ren *_ *
label_access_item
tempfile r7_4_1
sa		`r7_4_1'

u	"${raw_hfps_uga}/round7/SEC4_2.dta", clear

u	"${raw_hfps_uga}/round7/SEC4_2.dta", clear
ta medical_access__id
keep if inrange(medical_access__id,1,7)
la li medical_access__id
g item=medical_access__id+50
label_access_item
isid hhid item
la dir
la li s4q20 s4q21 s4q22
ta s4q21,m
ta s4q22,m

g item_need = (s4q20==1) 
g item_access = (s4q21==1) if item_need==1
g item_noaccess_cat1 = (inlist(s4q22,3,5))	if !mi(s4q22)
g item_noaccess_cat2 = (inlist(s4q22,2,4))	if !mi(s4q22)
g item_noaccess_cat3 = (inlist(s4q22,6)) 	if !mi(s4q22)
g item_noaccess_cat4 = (inlist(s4q22,8)) 	if !mi(s4q22)
g item_noaccess_cat6 = (inlist(s4q22,1)) 	if !mi(s4q22)
g item_noaccess_cat11= (inlist(s4q22,7)) 	if !mi(s4q22)


keep hhid item*
*	there is an implicit need for item 11 medical services 
tempfile r7_4_2
sa		`r7_4_2'

recode item (nonm=11)
su
collapse (max) item_need item_access item_noaccess_cat*, by(hhid item)
su
sort hhid item
mer 1:1 hhid item using `r7_4_2', assert(1 2) nogen
mer 1:1 hhid item using `r7_4_1', assert(1 2) nogen

label_access_item
ta item item_access,m
ta item item_need,m



g round=  7
tempfile r7
sa		`r7'
}	/*	 r7 end	*/


{	/*	r8+ (phase 2) access	*/
*	different verion, append into single dataset and deal with jointly
d using	"${raw_hfps_uga}/round8/SEC4.dta"	//	base
d using	"${raw_hfps_uga}/round9/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8 mainly, s4q1c__6-s4q1c__9 recoded, label indicates the s4q2b question actually
d using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round15/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round17/SEC4.dta"	//	as in r8

{	/*check for stability across time */
	*	basic structure 
qui {
	preserve
foreach r of numlist 8/13 15 17 {
	u "${raw_hfps_uga}/round`r'/SEC4.dta", clear
	d, replace clear
	tempfile r`r'
	sa		`r`r''
}
u `r8', clear
foreach r of numlist 8/13 15 17 {
	mer 1:1 name vallab varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group(_? _??), label missing
}
// li name vallab varlab rounds, sep(0) clean
li name vallab varlab rounds if strpos(name,"s4q2b__")>0, sep(0) clean
	restore
	
qui {	/*	codes	*/
	preserve
foreach r of numlist 8/13 15 17 {
	u "${raw_hfps_uga}/round`r'/SEC4.dta", clear
	la dir
	uselabel `r(labels)', clear
	tempfile r`r'
	sa		`r`r''
}
u `r8', clear
foreach r of numlist 8/13 15 17 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group(_? _??), label missing
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

#d ; 
clear; append using
	"${raw_hfps_uga}/round8/SEC4.dta"	
	"${raw_hfps_uga}/round9/SEC4.dta"	
	"${raw_hfps_uga}/round10/SEC4.dta"	
	"${raw_hfps_uga}/round11/SEC4.dta"	
	"${raw_hfps_uga}/round12/SEC4.dta"	
	"${raw_hfps_uga}/round13/SEC4.dta"	
	"${raw_hfps_uga}/round15/SEC4.dta"	
	"${raw_hfps_uga}/round17/SEC4.dta"	
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+7
replace round=round+1 if round>13
replace round=round+1 if round>15

isid hhid round goods_access__id
ta goods_access__id round
la li goods_access__id

#d ; 
recode goods_access__id
	( 1=16)		/*MAIZE FLOUR*/
	( 2= 4)		/*rice*/
	( 3=81)		/*bread*/
	( 4=63)		/*beef*/
	( 5=82)		/*FRESH MILK*/
	( 6=22)		/*eggs*/
	( 7 23=61)		/*silverfish  -> different from subsequent	*/
	( 8=84)		/*FRESH BEANS -> different from subsequent	*/
	( 9= 7)		/*SWEET POTATOES*/
	(10= 6)		/*cassava*/
	(11=83)		/*DRY BEANS -> different from subsequent	*/
	(12=67)		/*GROUNDNUTS (POUNDED)*/
	(13=14)		/*onions*/
	(14=85)		/*tomatoes*/
	(15=86)		/*EGG PLANTS*/
	(16=65)		/*DODO/NAKATI GUOBYO/MALAKWNAG*/
	(17=87)		/*sugar*/
	(18=68)		/*COOKING OIL REFINED*/
	(19=88)		/*TEA LEAVES/GREEN TEA*/
	(20=89)		/*salt*/
	(21= 2)		/*soap*/
	(22=21)		/*FUEL/GASOLINE*/

	if round==8, gen(item8); 
#d cr 
#d ; 
recode goods_access__id
	( 1=16)		/*MAIZE FLOUR*/
	( 2= 4)		/*rice*/
	( 3=81)		/*bread*/
	( 4=63)		/*beef*/
	( 5=82)		/*FRESH MILK*/
	( 6=22)		/*eggs*/
	( 7=61)		/*silverfish*/
	( 8=83)		/*DRY BEANS*/
	( 9= 7)		/*SWEET POTATOES*/
	(10= 6)		/*cassava*/
	(11=84)		/*FRESH BEANS*/
	(12=67)		/*GROUNDNUTS (POUNDED)*/
	(13=14)		/*onions*/
	(14=85)		/*tomatoes*/
	(15=86)		/*EGG PLANTS*/
	(16=65)		/*DODO/NAKATI GUOBYO/MALAKWNAG*/
	(17=87)		/*sugar*/
	(18=68)		/*COOKING OIL REFINED*/
	(19=88)		/*TEA LEAVES/GREEN TEA*/
	(20=89)		/*salt*/
	(21= 2)		/*soap*/
	(22=21)		/*FUEL/GASOLINE*/
	(23=26)		/*masks*/
	if round>=9, gen(item9p); 
#d cr 
egen item=rowfirst(item8 item9p)
label_access_item

ta item goods_access__id
// isid hhid round item	//-> no longer holds due to binning of fish and silverfish in round 8

ta s4q1a,m
g item_need = (s4q1a==1)
ta s4q1b item_need,m
la li s4q1b
g item_access=(s4q1b==1) if item_need==1

g		item_noaccess_cat1 =(s4q1c__1==1 | s4q1c__3==1 | s4q1c__5==1) if item_access==0
g		item_noaccess_cat3 =(s4q1c__4==1) if item_access==0
g		item_noaccess_cat4 =(s4q1c__6==1) if item_access==0 & inlist(round,9,10)
g		item_noaccess_cat5 =(s4q1c__2==1) if item_access==0
g		item_noaccess_cat6 =(s4q1c__7==1) if item_access==0 & inlist(round,8,9,10)

replace	item_noaccess_cat6 =(s4q1c__9==1)				if item_access==0 & inrange(round,11,17)
g		item_noaccess_cat21=(s4q1c__6==1)				if item_access==0 & inrange(round,11,17)
g		item_noaccess_cat32=(s4q1c__7==1 | s4q1c__8==1)	if item_access==0 & inlist(round,11,12)

tabstat item_noaccess_cat*, by(item_access) s(n sum)
ta s4q2a item_access,m
g item_fullbuy = (s4q2a==1) if item_access==1

g		item_ltfull_cat1 =(s4q2b__1==1 | s4q2b__3==1 | s4q2b__5==1) if item_fullbuy==0
g		item_ltfull_cat3 =(s4q2b__4==1) if item_fullbuy==0
g		item_ltfull_cat5 =(s4q2b__2==1) if item_fullbuy==0
g		item_ltfull_cat6 =(s4q2b__6==1) if item_fullbuy==0

tabstat item_*, s(n sum) by(round)

*	due to differing item codes in round 8 vs round 9+ creatig duplicates, we will bring to hh x item level here
#d ; 
collapse	(max) item_need 
			(min) item_access	(max) item_noaccess_cat*
			(min) item_fullbuy	(max) item_ltfull_cat*
			, by(hhid round item);
#d cr 
sort hhid round item

tempfile r8p
sa		`r8p'
}	/*	 r8p end	*/


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
	u "${raw_hfps_uga}/round`r'/SEC2A_1.dta", clear
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
	
qui {	/*	codes	*/
	preserve
foreach r of numlist 8/13 15 17 {
	u "${raw_hfps_uga}/round`r'/SEC4.dta", clear
	la dir
	uselabel `r(labels)', clear
	tempfile r`r'
	sa		`r`r''
}
u `r8', clear
foreach r of numlist 8/13 15 17 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group(_? _??), label missing
}
li lname value label rounds, sepby(lname)
	restore
	

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
	/*	r8p (phase2) health	*/
// #d ; 
// clear; append using
// 	"${raw_hfps_uga}/round8/SEC4A_2.dta"	
// 	"${raw_hfps_uga}/round9/SEC4A_2.dta"	
// 	, gen(round); la drop _append; la val round .; 
// 	replace round=round+7; ta round; 
// #d cr
// isid hhid round medical_service__id

{	/*	round 8	*/
*	we will ignore the individual information for now
u	"${raw_hfps_uga}/round8/SEC4A_1.dta", clear
ta s4aq03	//	we will just get zero with a reshape 
keep hhid s4aq04__*
u	"${raw_hfps_uga}/round8/SEC4A_2.dta", clear
drop s4aq04b__*
ta medical_service__id
la li medical_service__id
g item = cond(medical_service__id==1,58,medical_service__id+49)
isid hhid item

*	access items 
g item_need=1
g item_access=s4aq05==1 if item_need==1
ta s4aq06	//	no o/s responses available, we will have to simply ignore
la li s4aq06	//	standard
forv i=1/9 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(s4aq06==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
ta item item_need,m
ds item*
keep hhid `r(varlist)'

*	need our zeroes
ds item_*
reshape wide `r(varlist)', i(hhid) j(item)
mer 1:1 hhid using "${raw_hfps_uga}/round8/SEC4A_1.dta", keepus(hhid) nogen
reshape long
ta item
recode item_need (.=0)
ta item item_need,m
ta item item_access

g round=    8
tempfile   r8
sa		  `r8'
}	/*	end 8	*/


{	/*	round 9	*/
*	we will ignore the individual information for now
u	"${raw_hfps_uga}/round9/SEC4A_1.dta", clear
ta s4aq03	//	we will just get zero with a reshape 
keep hhid s4aq04__*
u	"${raw_hfps_uga}/round9/SEC4A_2.dta", clear
ta medical_service__id
la li medical_service__id
g item = cond(medical_service__id==1,58,medical_service__id+49)
isid hhid hh_roster__id item

*	access items 
g item_need=1
g item_access=s4aq05==1 if item_need==1
ta s4aq06	//	no o/s responses available, we will have to simply ignore
la li s4aq06	//	standard
forv i=1/9 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(s4aq06==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
ta item item_need,m
#d ; 
collapse (max) item_need (min) item_access (max) item_noaccess_cat*
	, by(hhid item); 
#d cr
ta item item_need,m

*	need our zeroes
ds item_*
reshape wide `r(varlist)', i(hhid) j(item)
mer 1:1 hhid using "${raw_hfps_uga}/round9/SEC4A_1.dta", keepus(hhid) nogen
reshape long
ta item
recode item_need (.=0)
ta item item_need,m
ta item item_access

g round=    9
tempfile   r9
sa		  `r9'
}	/*	end 9	*/


{	/*	round 10+ health	*/
#d ; 
clear; append using
	"${raw_hfps_uga}/round10/SEC2A_1.dta"
	"${raw_hfps_uga}/round11/SEC2A_1.dta"
	"${raw_hfps_uga}/round12/SEC2A_1.dta"
	"${raw_hfps_uga}/round13/SEC2A_1.dta"	
	"${raw_hfps_uga}/round15/SEC2A_1.dta"	
	"${raw_hfps_uga}/round17/SEC2A_1.dta"
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+9
replace round=round+1 if round>13
replace round=round+1 if round>15
ta round
isid hhid round hh_roster__id
ta s2aq03 round,m
collapse (min) s2aq03, by(hhid round)
ta s2aq03 round,m
tempfile mod1
sa		`mod1'

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

g item_need=1
g item_access=s2aq05==1 if item_need==1
ta s2aq06 round,m	//	no o/s responses available, we will have to simply ignore
la li s2aq06	//	standard except 10, which is ebola in round 11 and 12 only 
forv i=1/9 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(s2aq06==`i') if item_access==0
}
g item_noaccess_cat32=(s2aq06==11) if item_access==0 & inlist(round,11,12)
*	this is all for access

*	collapse to hh x round x item level 
ta item item_need,m
#d ; 
collapse (max) item_need (min) item_access (max) item_noaccess_cat*
	, by(hhid round item); 
#d cr
ta item item_need,m

*	need our zeroes
ds item_*
reshape wide `r(varlist)', i(hhid round) j(item)
mer 1:1 hhid round using `mod1',  nogen
reshape long
ta item
recode item_need (.=0)
ta item item_need,m
ta item item_access

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
collapse (max) item_need (min) item_access (max) item_noaccess_cat*
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


{	/*	r8p (phase 2) food	*/
#d ; 
clear; append using
	"${raw_hfps_uga}/round8/SEC4.dta"	
	"${raw_hfps_uga}/round9/SEC4.dta"	
	"${raw_hfps_uga}/round10/SEC4.dta"	
	"${raw_hfps_uga}/round11/SEC4.dta"	
	"${raw_hfps_uga}/round12/SEC4.dta"	
	"${raw_hfps_uga}/round13/SEC4.dta"	
	"${raw_hfps_uga}/round15/SEC4.dta"	
	"${raw_hfps_uga}/round17/SEC4.dta"	
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+7
replace round=round+1 if round>13
replace round=round+1 if round>15

isid hhid round goods_access__id
ta goods_access__id round
la li goods_access__id

#d ; 
recode goods_access__id
	( 1=16)		/*MAIZE FLOUR*/
	( 2= 4)		/*rice*/
	( 3=81)		/*bread*/
	( 4=63)		/*beef*/
	( 5=82)		/*FRESH MILK*/
	( 6=22)		/*eggs*/
	( 7 23=61)		/*silverfish  -> different from subsequent	*/
	( 8=84)		/*FRESH BEANS -> different from subsequent	*/
	( 9= 7)		/*SWEET POTATOES*/
	(10= 6)		/*cassava*/
	(11=83)		/*DRY BEANS -> different from subsequent	*/
	(12=67)		/*GROUNDNUTS (POUNDED)*/
	(13=14)		/*onions*/
	(14=85)		/*tomatoes*/
	(15=86)		/*EGG PLANTS*/
	(16=65)		/*DODO/NAKATI GUOBYO/MALAKWNAG*/
	(17=87)		/*sugar*/
	(18=68)		/*COOKING OIL REFINED*/
	(19=88)		/*TEA LEAVES/GREEN TEA*/
	(20=89)		/*salt*/
	(21= 2)		/*soap*/
	(22=21)		/*FUEL/GASOLINE*/

	if round==8, gen(item8); 
#d cr 
#d ; 
recode goods_access__id
	( 1=16)		/*MAIZE FLOUR*/
	( 2= 4)		/*rice*/
	( 3=81)		/*bread*/
	( 4=63)		/*beef*/
	( 5=82)		/*FRESH MILK*/
	( 6=22)		/*eggs*/
	( 7=61)		/*silverfish*/
	( 8=83)		/*DRY BEANS*/
	( 9= 7)		/*SWEET POTATOES*/
	(10= 6)		/*cassava*/
	(11=84)		/*FRESH BEANS*/
	(12=67)		/*GROUNDNUTS (POUNDED)*/
	(13=14)		/*onions*/
	(14=85)		/*tomatoes*/
	(15=86)		/*EGG PLANTS*/
	(16=65)		/*DODO/NAKATI GUOBYO/MALAKWNAG*/
	(17=87)		/*sugar*/
	(18=68)		/*COOKING OIL REFINED*/
	(19=88)		/*TEA LEAVES/GREEN TEA*/
	(20=89)		/*salt*/
	(21= 2)		/*soap*/
	(22=21)		/*FUEL/GASOLINE*/
	(23=26)		/*masks*/
	if round>=9, gen(item9p); 
#d cr 
egen item=rowfirst(item8 item9p)
label_access_item

ta item goods_access__id
// isid hhid round item	//-> no longer holds due to binning of fish and silverfish in round 8

ta s4q1a,m
g item_need = (s4q1a==1)
ta s4q1b item_need,m
la li s4q1b
g item_access=(s4q1b==1) if item_need==1

g		item_noaccess_cat1 =(s4q1c__1==1 | s4q1c__3==1 | s4q1c__5==1) if item_access==0
g		item_noaccess_cat3 =(s4q1c__4==1) if item_access==0
g		item_noaccess_cat4 =(s4q1c__6==1) if item_access==0 & inlist(round,9,10)
g		item_noaccess_cat5 =(s4q1c__2==1) if item_access==0
g		item_noaccess_cat6 =(s4q1c__7==1) if item_access==0 & inlist(round,8,9,10)

replace	item_noaccess_cat6 =(s4q1c__9==1)				if item_access==0 & inrange(round,11,17)
g		item_noaccess_cat21=(s4q1c__6==1)				if item_access==0 & inrange(round,11,17)
g		item_noaccess_cat32=(s4q1c__7==1 | s4q1c__8==1)	if item_access==0 &  inlist(round,11,12)

tabstat item_noaccess_cat*, by(item_access) s(n sum)
ta s4q2a item_access,m
g item_fullbuy = (s4q2a==1) if item_access==1

g		item_ltfull_cat1 =(s4q2b__1==1 | s4q2b__3==1 | s4q2b__5==1) if item_fullbuy==0
g		item_ltfull_cat3 =(s4q2b__4==1) if item_fullbuy==0
g		item_ltfull_cat5 =(s4q2b__2==1) if item_fullbuy==0
g		item_ltfull_cat6 =(s4q2b__6==1) if item_fullbuy==0

tabstat item_*, s(n sum) by(round)

*	due to differing item codes in round 8 vs round 9+ creatig duplicates, we will bring to hh x item level here
#d ; 
collapse	(max) item_need 
			(min) item_access	(max) item_noaccess_cat*
			(min) item_fullbuy	(max) item_ltfull_cat*
			, by(hhid round item);
#d cr 
sort hhid round item
tempfile r8pfood
sa		`r8pfood'
}	/*	 r8pfood end	*/


u `r8p', clear
ta item round

u `r8phealth', clear
ta item round

u `r8pfood', clear
ta item round

/*	append all rounds	*/
clear
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8phealth' `r8pfood', nolabel
isid	hhid round item
order	hhid round item
sort	hhid round item

ta item
label_access_item
ta item round

*	need to harmonize item once other versions are available 
#d ; 
order item_need item_access item_noaccess_cat? 
	item_noaccess_cat1? item_noaccess_cat2? item_noaccess_cat3?	
	item_fullbuy 
	item_ltfull_cat? item_ltfull_cat1? item_ltfull_cat3? item_ltfull_cat9?
	, a(item); 
#d cr 
drop s2aq03

*	label contents here, but these are subject to reorganization in the panel construction
la var item_need		"HH needed item in last 7 days"
la var item_access		"HH accessed item in last 7 days"
label_item_ltfull noaccess

la var item_fullbuy		"HH accessed full amount of item needed in last 7 days"
label_item_ltfull ltfull

sa "${tmp_hfps_uga}/access.dta", replace 

cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex
u  "${tmp_hfps_uga}/access.dta", clear 










	







