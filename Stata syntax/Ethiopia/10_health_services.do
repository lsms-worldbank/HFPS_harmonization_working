



u "${tmp_hfps_eth}/access.dta", clear
ta item round if inlist(item,11,51,52,53,54,55,56,57,58)
	*	rounds 13/18 

wordsearch "*ocket* *OCKET*", dir("${raw_hfps_eth}")
run "${do_hfps_util}/label_access_item.do"	//	defines label program 

*	food access 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*price*", w	//	phase 2 stub 
dir "${raw_hfps_eth}/*health*", w	//	phase 2 health access -> why not incorporated? 


{	/*	Phase 2	*/
dir "${raw_hfps_eth}"
dir "${raw_hfps_eth}/*health*"
dir "${raw_hfps_eth}/*price*"


{	/*	health	*/
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_health_public.dta"		//	wide, hh, 3 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta"		//	wide, ind, 3 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta"		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta"	//	long it appears, or else 1 service. ind. 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_health_public.dta"		//	wide, ind, 2 services 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta"	//	similar to round 15 random 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta"	//	wide, ind, 2 services 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_health_public.dta"		//	wide, ind, 2 services 


{	/*	var label and code checks 	*/
qui {	/*	var labels	*/
	preserve
loc hlthfiles : dir "${raw_hfps_eth}" files "*health*"	

loc i=1	//	counter
foreach f of local hlthfiles {
	u "${raw_hfps_eth}/`f'", clear
	d, replace clear
	tempfile r`i'
	sa		`r`i''
	loc ++i
}
loc i=1
u `r`i'', clear
foreach f of local hlthfiles {
	mer 1:1 name vallab varlab using `r`i'', gen(_`i')
	la val _`i' . 
	recode _`i' (1 .=.)(2 3=`i')
	loc ++i
}
cap : ds _?
loc set1 `r(varlist)'
cap : ds _??
loc set2 `r(varlist)'
egen rounds = group(`set1' `set2'), label missing
}
li name vallab varlab rounds, sep(0) clean
li name vallab varlab rounds if strpos(name,"gf")>0, sep(0) clean
	restore
	
qui {	/*	codes	*/
	preserve
loc hlthfiles : dir "${raw_hfps_eth}" files "*health*"	

loc i=1	//	counter
foreach f of local hlthfiles {
	u "${raw_hfps_eth}/`f'", clear
	la dir
	uselabel `r(labels)', clear
	tempfile r`i'
	sa		`r`i''
	loc ++i
}
loc i=1
u `r`i'', clear
foreach f of local hlthfiles {
	mer 1:1 lname value label using `r`i'', gen(_`i')
	la val _`i' . 
	recode _`i' (1 .=.)(2 3=`i')
	loc ++i
}
cap : ds _?
loc set1 `r(varlist)'
cap : ds _??
loc set2 `r(varlist)'
egen rounds = group(`set1' `set2'), label missing
}
li lname value label rounds, sepby(lname)
// li lname value label rounds if strpos(lname,"typ")>0, sepby(lname)
	*	first instance does not have 5 & 6 spelled out fully (matches fifth instance)
// li lname value label rounds if strpos(lname,"where")>0, sepby(lname)
	restore
	*	-> the codes bounce around a lot, though moreso in the name of the value label than the actual coding substantively
}	/*	end var label and code checks	*/


{	/*	r13 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_health_public.dta"		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_health_public.dta", si		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_health_public.dta", s		//	wide, ind, 2 services

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_health_public.dta", clear
isid household_id	//	no duplicates
keep household_id gf*

la li gf4_serv_typ
la li gf6_reason_1
*	ignore insurance questions
drop gf1 gf2_who?

*	reshape to hh instance level
ren (gf4b_1who_HHID? gf4b_2who_HHID? gf4b_3who_HHID?)	/*
*/	(gf4b_HHID?_iid1 gf4b_HHID?_iid2 gf4b_HHID?_iid3)
*	we are ignoring the individual aspect at this point, so simply drop these 
drop gf4b_*

ds *1	
loc rawvars `r(varlist)'
loc clnvars 
foreach raw of local rawvars {
	loc cln = substr("`raw'",1,length("`raw'")-1)
	loc clnvars `clnvars' `cln'
}
reshape long `clnvars', i(household_id) j(instance)
ta gf4_serv_typ gf3,m
drop if mi(gf4_serv_typ)

ds gf4_serv_typ household_id instance, not
loc targets `r(varlist)'
collapse (firstnm) `targets', by(household_id gf4_serv_typ)
reshape wide `targets', i(household_id) j(gf4_serv_typ)
reshape long
ta gf4_serv_typ gf3,m

ta gf4_serv_typ
// la li gf4_serv_typ
recode gf4_serv_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


ta gf7_where_
// la li s5fq7_2	//	checked above
g care_place=gf7_where_
ta gf8_payown_
g care_oop_any = (gf8_payown_==1) if !mi(gf8_payown_)

d gf9_payamount_?_
recode gf9_payamount_2_ gf9_payamount_3_ gf9_payamount_4_ gf9_payamount_5_ (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gf9_payamount_1_ yy zz gf9_payamount_6_
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta gf10_satisfaction_
recode gf10_satisfaction_ (3=4)(4=5)(-98=3), gen(care_satisfaction)

*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
	, by(household_id item);
#d cr 
ta item,m

g round=  13
tempfile r13
sa		`r13'
}	/*	 r13 end	*/


{	/*	r14 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta"		//	wide, ind, 2 services
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", si		//	wide, ind, 2 services
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", s		//	wide, ind, 2 services
//
// u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", clear

*-> we will revert to the v14 release of this data for this dataset
	*	copied in the Ethiopia/09_access.do syntax
d using	"${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round14_health_public.dta"		//	wide, ind, 2 services
d using	"${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round14_health_public.dta", si		//	wide, ind, 2 services
d using	"${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round14_health_public.dta", s		//	wide, ind, 2 services

u		"${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round14_health_public.dta", clear
duplicates report	household_id	
isid household_id individual_id	
keep household_id individual_id gf*

la li gfa4_service_typ
la li gfa6_reason1
la li where	//	checked above

drop  gfa4_read
*	ignore insurance questions
drop gfa1_coverage gf2_who? gfa2_other

*	reshape to hh ind instance level
*	we are ignoring the individual aspect at this point, so simply drop these 

ds *1	
loc rawvars `r(varlist)'
loc clnvars 
foreach raw of local rawvars {
	loc cln = substr("`raw'",1,length("`raw'")-1)
	loc clnvars `clnvars' `cln'
}
reshape long `clnvars', i(household_id individual_id) j(instance)
ta gfa4_service_typ gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_service_typ
// la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


ta gfa7_where
// la li where	//	checked above
g care_place=gfa7_where
ta gfa8_payown
g care_oop_any = (gfa8_payown==1) if !mi(gfa8_payown)

d gfa9_payamount_*

recode gfa9_payamount_pres gfa9_payamount_nopr gfa9_payamount_trem gfa9_payamount_noem (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gfa9_payamount_med yy zz gfa9_payamount_other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0



*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id item);
#d cr 

g round=  14
tempfile r14
sa		`r14'
}	/*	 r14 end	*/


{	/*	r15 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta"		//	wide, ind, 2 services
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta"	//	long it appears, or else 1 service. ind. 
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", si		//	wide, ind, 2 services
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta",si	//	long it appears, or else 1 service. ind. 
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", s		//	wide, ind, 2 services
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta",s	//	long it appears, or else 1 service. ind. 
//
//
// u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta", clear

*	following on investigations in 09_access.do, we will use the v14 release of this dataset 

u "${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta", clear
#d ; 
ren (rand_gfa3 gfa4_service_typ1 rep_rand_gfaname rand_gfa5_access 
	rand_gfa6_reason rand_gfa6_reason_other 
	rand_gfa7_where rand_gfa7_where_other 
	rand_gfa8_payown 
	rand_gfa9_payamount_1 rand_gfa9_payamount_2 rand_gfa9_payamount_3 
	rand_gfa9_payamount_4 rand_gfa9_payamount_5 rand_gfa9_payamount_6 
	rand_gfa9_payamount_6_other 
	/*rand_gfa10_satisfaction*/ rand_gfa10 
	rand_gfa11 rand_gfa12 rand_gfa13 rand_gfa14 rand_gfa15 
	rand_gfa16 rand_gfa16_other)
	(gfa3 gfa4_service_typ1 rep_gfaname1 gfa5_access1 
	gfa6_reason1 gfa6_reason_other1 
	gfa7_where1 gfa7_where_other1 
	gfa8_payown1 
	gfa9_payamount_med1 gfa9_payamount_pres1 gfa9_payamount_nopr1 
	gfa9_payamount_trem1 gfa9_payamount_noem1 gfa9_payamount_other1 
	gfa9_payamount_other_x1 
	gfa10_1 
	gfa11_1 gfa12_1 gfa13_1 gfa14_1 gfa151 
	gfa161 gfa16_other1); 
#d cr
keep household_id individual_id gfa*
tempfile random_respondent
sa		`random_respondent'

u "${hfps}/Input datasets/Ethiopia/wb_lsms_hfpm_hh_survey_round15_health_public.dta", clear
mer 1:1 household_id individual_id using `random_respondent', update 
ta gfa3
la li gfa4_service_typ
la li where	//	checked above

*	reshape to instance level
ds *1, not
ds *1
loc rawvars `r(varlist)'
d  `rawvars', si
loc stubs
foreach i of local rawvars {
	loc stub = substr("`i'",1,length("`i'")-1)
	loc stubs `stubs' `stub'
}
reshape long `stubs', i(household_id individual_id) j(instance)
d
la val instance . 
la var instance	"instance of health issue"
ren *_ *

// la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)
drop if mi(item)

ta gfa7_where
// la li where	//	checked above
g care_place=gfa7_where
ta gfa8_payown
g care_oop_any = (gfa8_payown==1) if !mi(gfa8_payown)

d gfa9_payamount_*

recode gfa9_payamount_pres gfa9_payamount_nopr gfa9_payamount_trem gfa9_payamount_noem (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gfa9_payamount_med yy zz gfa9_payamount_other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id item);
#d cr 

g round=  15
tempfile r15
sa		`r15'
}	/*	 r15 end	*/


{	/*	r16 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_health_public.dta"		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_health_public.dta", si		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_health_public.dta", s		//	wide, ind, 2 services

u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_health_public.dta", clear
duplicates report	household_id	
duplicates report	household_id	individual_id
isid household_id individual_id, missok
su if mi(individual_id)
keep household_id individual_id gf*

la li gfa4_service_typ
la li where	

*	ignore insurance questions
drop gfa1_coverage gf2_who? gfa2_other

*	reshape to hh ind instance level
*	we are ignoring the individual aspect at this point, so simply drop these 

ds *1	
loc rawvars `r(varlist)'
loc clnvars 
foreach raw of local rawvars {
	loc cln = substr("`raw'",1,length("`raw'")-1)
	loc clnvars `clnvars' `cln'
}
reshape long `clnvars', i(household_id individual_id) j(instance)
ta gfa4_service_typ gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_service_typ
// la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)

ta gfa7_where
// la li where	//	checked above
g care_place=gfa7_where
ta gfa8_payown
g care_oop_any = (gfa8_payown==1) if !mi(gfa8_payown)

d gfa9_payamount_*,f

recode gfa9_payamount_pres gfa9_payamount_nopr gfa9_payamount_trem gfa9_payamount_noem (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gfa9_payamount_med yy zz gfa9_payamount_other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id item);
#d cr 

g round=  16
tempfile r16
sa		`r16'
}	/*	 r16 end	*/


{	/*	r17 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta"	//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta"	//	long it appears, or else 1 service. ind. 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", si	//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta", si	//	long it appears, or else 1 service. ind. 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", s	//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta", s	//	long it appears, or else 1 service. ind. 


*	will reconcile sample b naming to sample a
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", clear
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta", clear
// ta rep_rand_gfaname
	*	simply rename these to enable a comparison with the main module 
	ren gfa4b_service1_who? gfa4b_who?_service1
	ren gfa4b_service2_who? gfa4b_who?_service2

// 	ds gfa*1
// 	loc rawvars `r(varlist)'
// 	d `rawvars'
	#d  ;
	reshape long 
	gfa4_service_typ 
	gfa4b_who1_service gfa4b_who2_service gfa4b_who3_service 
	gfa4b_who4_service gfa4b_who5_service gfa4b_who6_service 
	gfa4b_who_other_b_ 
	gfa5_access_b_ gfa6_reason_b_ gfa6_reason_other_b_ 
	gfa7_where_b_ gfa7_where_other_b_ gfa8_payown_b_ 
	gfa9_payamount_1_b_ gfa9_payamount_2_b_ gfa9_payamount_3_b_ 
	gfa9_payamount_4_b_ gfa9_payamount_5_b_ gfa9_payamount_6_b_ 
	gfa9_payamount_6_other_b_ 
	gfa10_satisfaction_b_
	, i(household_id) j(instance); 
	#d cr 
	la val instance .
	ta gfa4_service_typ instance,m

	d, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", si

	order gfa4b_who3_service gfa4b_who4_service gfa4b_who5_service gfa4b_who6_service, a(gfa4b_who2_service)
	*	could make individual level to match more directly with sample A 
	ren (gfa4b_who?_service)(individual_id?)	
	*	but no, this is implying greater precision than really exists
	drop individual_id? 

	
#d ; 
ren (gfa1_b gfa2_b_other_b gfa3_b
	 gfa4_service_typ /*rep_gfapos_b_2*/ rep_gfaname_b_2 
	 /*gfa4b_who1_service gfa4b_who2_service gfa4b_who3_service 
	 gfa4b_who4_service gfa4b_who5_service gfa4b_who6_service
	 gfa4b_who_other_b_ */
	 gfa5_access_b_ gfa6_reason_b_ gfa6_reason_other_b_ 
	 gfa7_where_b_ gfa7_where_other_b_ 
	 gfa8_payown_b_ 
	 gfa9_payamount_1_b_ gfa9_payamount_2_b_ gfa9_payamount_3_b_ 
	 gfa9_payamount_4_b_ gfa9_payamount_5_b_ gfa9_payamount_6_b_ 
	 gfa9_payamount_6_other_b_ 
	 gfa10_satisfaction_b_
	 )
	(gfa1_coverage /*gf2_who1 gf2_who2*/ gfa2_other gfa3 
	 gfa4_service_typ1 rep_gfaname 
	 gfa5_access gfa6_reason gfa6_reason_other 
	 gfa7_where gfa7_where_other 
	 gfa8_payown 
	 gfa9_payamount_med gfa9_payamount_pres gfa9_payamount_nopr 
	 gfa9_payamount_trem gfa9_payamount_noem gfa9_payamount_other 
	 gfa9_payamount_other_x 
	 /*gfa9_payamount_rowtotal*/ 
	 gfa10_satisfaction
	 ); 
#d ; 
collapse (first) gfa3  
	 gfa5_access gfa6_reason gfa6_reason_other 
	 gfa7_where gfa7_where_other 
	 gfa8_payown 
	 gfa9_payamount_med gfa9_payamount_pres gfa9_payamount_nopr 
	 gfa9_payamount_trem gfa9_payamount_noem gfa9_payamount_other 
	 gfa9_payamount_other_x 
	 , by(household_id gfa4_service_typ1); 
#d cr
duplicates drop
isid household_id gfa4_service_typ1, missok
drop if mi(gfa4_service_typ1)

*	get our zeroes, though of course not for those codes no household reported. We will simply ignore this for now
#d ; 
reshape wide gfa3 gfa5_access 
	gfa6_reason gfa6_reason_other 
	gfa7_where gfa7_where_other 
	gfa8_payown 
	gfa9_payamount_med gfa9_payamount_pres gfa9_payamount_nopr 
	gfa9_payamount_trem gfa9_payamount_noem gfa9_payamount_other 
	gfa9_payamount_other_x
	, i(household_id) j(gfa4_service_typ1); 
#d cr 
reshape long
recode gfa3 (.=0)
ta gfa4_service_typ1 gfa3,m


tempfile smplb
sa		`smplb'

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", clear
duplicates report household_id gfa4_service_typ1
mer m:1 household_id gfa4_service_typ1 using `smplb', assert(1 2) gen(_sampleb) 
ta  gfa4_service_typ1 _sampleb

la li gfa4_service_typ
recode gfa4_service_typ1 (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)

ta gfa7_where
la li where	//	checked above
g care_place=gfa7_where
ta gfa8_payown
g care_oop_any = (gfa8_payown==1) if !mi(gfa8_payown)

d gfa9_payamount_*,f

recode gfa9_payamount_pres gfa9_payamount_nopr gfa9_payamount_trem gfa9_payamount_noem (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gfa9_payamount_med yy zz gfa9_payamount_other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id item);
#d cr 
drop if mi(item)

g round=  17
tempfile r17
sa		`r17'
}	/*	 r17 end	*/


{	/*	r18 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_health_public.dta"		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_health_public.dta", si		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_health_public.dta", s		//	wide, ind, 2 services

u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_health_public.dta", clear
duplicates report	household_id	
duplicates report	household_id	individual_id
isid household_id individual_id

keep household_id individual_id gf*

la li gfa4_service_typ
la li where	//	checked above

*	ignore insurance questions
drop gfa1_coverage gf2_who? gfa2_other

*	reshape to hh ind instance level
*	we are ignoring the individual aspect at this point, so simply drop these 

ds *1	
loc rawvars `r(varlist)'
loc clnvars 
foreach raw of local rawvars {
	loc cln = substr("`raw'",1,length("`raw'")-1)
	loc clnvars `clnvars' `cln'
}
reshape long `clnvars', i(household_id individual_id) j(instance)
ta gfa4_service_typ gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_service_typ
// la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)

ta gfa7_where
// la li where	//	checked above
cleanstr gfa7_where_other
li str if !mi(str)
g care_place=gfa7_where
ta gfa8_payown
g care_oop_any = (gfa8_payown==1) if !mi(gfa8_payown)

d gfa9_payamount_*,f

recode gfa9_payamount_pres gfa9_payamount_nopr gfa9_payamount_trem gfa9_payamount_noem (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

loc vars gfa9_payamount_med yy zz gfa9_payamount_other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

*	collapse to hh x item level 
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id item);
#d cr 

g round=  18
tempfile r18
sa		`r18'
}	/*	 r18 end	*/


*	aggregate phase 2 health 
clear
append using `r13' `r14' `r15' `r16' `r17' `r18'

ta item round

*	add in item 11
preserve
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
	, by(household_id round);
#d cr 
g item=11
tempfile item11
sa		`item11'
restore
append using `item11'
ta item round

tempfile    health
sa		   `health'
}	/*	end health	*/


keep  household_id round item care*
order household_id round item care*
isid  household_id round item
sort  household_id round item
tempfile phase2
sa		`phase2'
}	/*	end Phase 2	*/
		
		
clear
append using `phase1' `phase2'
isid household_id round item
sort household_id round item
ta item round

label_access_item

recode care_place -96=96
la var care_place			"Place where care was received"
run "${do_hfps_util}/label_care_place.do"
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


sa "${tmp_hfps_eth}/health_services.dta", replace 
u  "${tmp_hfps_eth}/health_services.dta", clear 







