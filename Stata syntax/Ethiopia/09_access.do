



#d cr 
run "${do_hfps_util}/label_access_item.do"	//	defines label program 
run "${do_hfps_util}/label_item_ltfull.do"	//	defines label program for less than full variable labels 

*	food access 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*price*", w	//	phase 2 stub 
dir "${raw_hfps_eth}/*health*", w	//	phase 2 health access -> why not incorporated? 


{	/*	Phase 1	*/
d ac?_atb* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2
d ac?_atb* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac1 ac2 
// d ac?_atb* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac are heathcare here
// d ac?_atb* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac are heathcare here
// d ac?_atb* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		//	ac are heathcare here
d ac?_atb* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	//	ac1_atb ac2_atb 
// d ac* using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		


#d ; 
clear; append using
		"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
		"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
		"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
		"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
		"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
		"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
		"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
		, keep(household_id ac1_atb_* ac2_atb_*) gen(round) force; 
		la drop _append; la val round;
#d cr 
ta round
replace round=round+3 if round>7

tab2 round ac1_atb_*, first
tab2 round ac2_atb_*_why, first
tab1 ac2_atb_*_why
la li ac1_atb_med ac1_atb_teff ac1_atb_wheat ac1_atb_maize ac1_atb_oil
la li ac2_atb_med_why ac2_atb_teff_why ac2_atb_wheat_why ac2_atb_maize_why ac2_atb_oil_why

#d ; 
ren (
	ac1_atb_med   ac2_atb_med_why   ac2_atb_med_why_other   
	ac1_atb_teff  ac2_atb_teff_why  ac2_atb_teff_why_other  
	ac1_atb_wheat ac2_atb_wheat_why ac2_atb_wheat_why_other 
	ac1_atb_maize ac2_atb_maize_why ac2_atb_maize_why_other 
	ac1_atb_oil   ac2_atb_oil_why   ac2_atb_oil_why_other   )
  (	item_fullbuy1	item_ltfull1	item_ltfull_os1
  	item_fullbuy48 	item_ltfull48	item_ltfull_os48
  	item_fullbuy69 	item_ltfull69	item_ltfull_os69
  	item_fullbuy16 	item_ltfull16	item_ltfull_os16
  	item_fullbuy68 	item_ltfull68	item_ltfull_os68
    );
#d cr 
reshape long item_fullbuy item_ltfull item_ltfull_os, i(household_id round) j(item)
la drop types
la val item .
label_access_item
ta item round if item_fullbuy==1

ta item_fullbuy


g		item_need = inlist(item_fullbuy,1,0) if inlist(item_fullbuy,0,1,-97)
la var	item_need	"Household wanted or needed to buy [food] in past 7 days"

replace	item_fullbuy = (item_fullbuy==1)	if item_need==1
replace	item_fullbuy = .					if item_need!=1
la var	item_fullbuy		"Able to buy desired amount of [food] in past 7 days"

ta item_ltfull round
ta item_need item_ltfull,m
ta item_fullbuy item_ltfull,m
la li ac2_atb_med_why	//	standard set of 6
g item_ltfull_label=.
la var item_ltfull_label	"Reason not able to buy desired amount of [food] in past 7 days"
forv i=1/6 {
	g		item_ltfull_cat`i' = (item_ltfull==`i')
	la var	item_ltfull_cat`i'	"`: label ac2_atb_med_why `i''"
}
recode item_ltfull_cat? (0=.) if item_fullbuy!=0

keep household_id round item*
isid household_id round item
tempfile phase1
sa		`phase1'
}	/*	end Phase 1	*/


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
li lname value label rounds if strpos(lname,"typ")>0, sepby(lname)
	*	first instance does not have 5 & 6 spelled out fully (matches fifth instance)
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
ta gf4_serv gf3,m
drop if mi(gf4_serv_typ)

ds gf4_serv_typ household_id instance, not
loc targets `r(varlist)'
collapse (firstnm) `targets', by(household_id gf4_serv_typ)
reshape wide `targets', i(household_id) j(gf4_serv_typ)
reshape long
ta gf4_serv gf3,m

ta gf4_serv_typ
la li gf4_serv_typ
recode gf4_serv_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


g item_need=(gf3==1)
g item_access=(gf5==1) if item_need==1
ta gf6_reason_ gf5_access,m	
cleanstr gf6_reason_other_
li str if !mi(str)	//	all of these are did nothing (as opposed to round 15 where they were temporal issues )
recode gf6_reason_ (-96=10)
forv i=1/10 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(gf6_reason_==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
drop if mi(item)
*	need our zeroes
reshape wide item_need item_access item_noaccess_cat*, i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access


g round=  13
tempfile r13
sa		`r13'
}	/*	 r13 end	*/


{	/*	r14 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta"		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", si		//	wide, ind, 2 services
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", s		//	wide, ind, 2 services

u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_health_public.dta", clear
duplicates report	household_id	
isid household_id individual_id	
keep household_id individual_id gf*

la li gfa6_reason1

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
ta gfa4_serv gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_serv
la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


g item_need=(gfa3==1)
g item_access=(gfa5==1) if item_need==1
ta gfa6_reason gfa5_access,m	
cleanstr gfa6_reason_other
li str if !mi(str)	//	all of these are did nothing (as opposed to round 15 where they were temporal issues )
la li gfa6_reason3
recode gfa6_reason (-96=9)
forv i=1/9 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(gfa6_reason==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
drop if mi(item)
*	need our zeroes
ta item
ds item_*
reshape wide `r(varlist)', i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access


g round=  14
tempfile r14
sa		`r14'
}	/*	 r14 end	*/


{	/*	r15 health	*/
	*	try to treat in a batch, but to do that we must reshape the long version and harmonize
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta"		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta"	//	long it appears, or else 1 service. ind. 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", si		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta",si	//	long it appears, or else 1 service. ind. 
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", s		//	wide, ind, 2 services
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta",s	//	long it appears, or else 1 service. ind. 

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta", clear
duplicates report household_id	//	no duplicates
ta gfa4
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", clear
duplicates report household_id
duplicates report household_id individual_id
isid household_id individual_id
mer 1:1 household_id individual_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta"
	*	cases of _m=2 exist, and thus we need to try to use this information or HH will not be represented

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_random_health_public.dta", clear
// ta rep_rand_gfaname
	*	simply rename these to enable a comparison with the main module 
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
/*
mer 1:1 household_id individual_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", keepus(household_id individual_id) keep(3) nogen
tempfile restricted_random
sa		`restricted_random'

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", clear
mer 1:1 household_id individual_id using `random_respondent', keepus(household_id individual_id) keep(3) nogen
append using `restricted_random', gen(mk)
ta gfa3 mk	//	close, but not identical. We will prefer the standard version where there are differences 
*/ 

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_health_public.dta", clear
mer 1:1 household_id individual_id using `random_respondent', update 
ta gfa3
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

*	make access vars
ta gfa3 instance
g item_need=(gfa3==1)
ta gfa4 instance	//	almost no second instances 
ta gfa5_access
g item_access=(gfa5_access==1) if item_need==1
ta gfa3 gfa4,m	//	why so many yes with no type named? 
ta gfa4 _m
la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)
ta gfa6_reason gfa5_access,m	//	one inappropriately = yes 
la li gfa6_reason2	//	standard codes
cleanstr gfa6_reason_other
li str if !mi(str)	//	no strong reason to recategorize these
forv i=1/9 {
	g item_noaccess_cat4`i'=(gfa6_reason==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
drop if mi(item)
*	need our zeroes
reshape wide item_need item_access item_noaccess_cat*, i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access

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
ta gfa4_serv gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_serv
la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


g item_need=(gfa3==1)
g item_access=(gfa5==1) if item_need==1
ta gfa6_reason gfa5_access,m	
cleanstr gfa6_reason_other
li str if !mi(str)	//	temporal issue, leave it alone
la li medaccess	//	standard
forv i=1/9 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(gfa6_reason==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
assert !mi(item)
*	need our zeroes
ta item 
ds item_*
reshape wide `r(varlist)', i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access


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

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta", clear
duplicates report household_id	//	no duplicates
// ta gfa4
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", clear
duplicates report household_id	//	many duplicates
duplicates report household_id individual_id //	identified duplicates
isid household_id individual_id
g ii4_resp_id=individual_id
mer 1:1 household_id ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta"
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", clear
mer m:1 household_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_sampleb_public.dta"

	*	no cases of _m=2 exist, and thus we need to try to use this information or HH will not be represented

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
ta gfa4 gfa3,m


tempfile smplb
sa		`smplb'

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_health_samplea_public.dta", clear
duplicates report household_id gfa4_service_typ1
mer m:1 household_id gfa4_service_typ1 using `smplb', assert(1 2) gen(_sampleb) 
ta  gfa4_service_typ1 _sampleb



*	make access vars
ta gfa3 gfa4,m	//	perfect


g item_need=(gfa3==1)

ta gfa5_access
g item_access=(gfa5_access==1) if item_need==1
ta gfa3 gfa4,m 
ta _sampleb individual_id if mi(gfa4) & gfa3==1,m
ta gfa4 _sampleb,m nol
la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)
ta gfa6_reason gfa5_access,m	//	one inappropriately = yes 
la li medaccess	//	standard codes
cleanstr gfa6_reason_other
li str if !mi(str)	//	all of these are did nothing (as opposed to round 15 where they were temporal issues )
recode gfa6_reason (-96=10)
forv i=1/10 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(gfa6_reason==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
drop if mi(item)

*	no cases of item=58, let's fill that in here
bys household_id (item) : g case = 1 if _n==1
expand 2 if case==1, gen(mk)
recode item (nonm=58) if mk==1
recode item_need (nonm=0) if mk==1
recode item_access item_noaccess_cat* (nonm=.) if mk==1
isid household_id item
ta item item_need
drop case mk

*	need our zeroes
reshape wide item_need item_access item_noaccess_cat*, i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access



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
ta gfa4_serv gfa3,m
drop if mi(gfa4_service_typ)
ta gfa4_serv
la li gfa4_service_typ
recode gfa4_service_typ (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57), gen(item)


g item_need=(gfa3==1)
g item_access=(gfa5==1) if item_need==1
ta gfa6_reason gfa5_access,m	
cleanstr gfa6_reason_other
li str if !mi(str)	//	self medication in one case, possibly both cases 
la li medaccess	//	standard
recode gfa6_reason -96=10 if str=="i bought medicin from farmacy"
forv i=1/10 {
	loc j=`i'+40
	g item_noaccess_cat`j'=(gfa6_reason==`i') if item_access==0
}
*	this is all for access

*	collapse to hh x item level 
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id item);
#d cr 
ta item item_need,m
ta item_need item_access,m
ta item,m
duplicates report household_id
assert !mi(item)
*	need our zeroes
ta item
ds item_*
reshape wide `r(varlist)', i(household_id) j(item)
reshape long
ta item
recode item_need (.=0)
ta item item_need
ta item item_access


g round=  18
tempfile r18
sa		`r18'
}	/*	 r18 end	*/


*	aggregate phase 2 health 
clear
append using `r13' `r14' `r15' `r16' `r17' `r18'

ta item round
ds item_*
reshape wide `r(varlist)', i(household_id round) j(item)
mer 1:1 household_id round using "${tmp_hfps_eth}/cover.dta", keepus(household_id round) assert(2 3)
bys round : egen zz = max(_m)
drop if zz==2
drop _m zz
reshape long
recode item_need (.=0) 
ta item item_need
ta item round

*	add in item 11
preserve
#d ; 
collapse 
	(max) item_need (min) item_access (max) item_noaccess_cat*
	, by(household_id round);
#d cr 
g item=11
tempfile item11
sa		`item11'
restore
append using `item11'
ta item item_need

tempfile    health
sa		   `health'
}	/*	end health	*/

{	/*	food	*/
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_price_public.dta"




u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta", clear
la li fp_00	
uselabel fp6_7_reason fp_00, clear
tempfile r13
sa		`r13'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta", clear	
la li fp_00	
uselabel fp6_7_reason fp_00, clear
tempfile r14
sa		`r14'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta", clear
la li fp_00	
uselabel fp6_7_reason fp_00, clear
tempfile r15
sa		`r15'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta", clear
la li item	
la copy item fp_00
uselabel fp6_7_reason fp_00, clear
tempfile r16
sa		`r16'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta", clear
la li item	
la copy item fp_00
uselabel fp6_7_reason fp_00, clear
tempfile r17
sa		`r17'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta", clear
la li item	
la copy item fp_00
uselabel fp6_7_reason fp_00, clear
tempfile r18
sa		`r18'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_price_public.dta", clear
la li fp_00
numlabel fp_00, remove
uselabel fp6_7_reason fp_00, clear
tempfile r19
sa		`r19'

u `r13', clear
forv i=14/19 {
	mer 1:1 lname value label using `r`i'', gen(_`i')
}
li lname value label _*, nol sepby(lname)	//all identical 


*	will do reduced set from what is possible here, focusing on panel compatibility
*	not reorganizing the item code as it is stable across rounds
#d ; 
clear; append using
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_price_public.dta"
	, gen(round) force; replace round=round+12;  la drop _append; la val round; 
#d cr 
ta fp_00 round,m
recode fp_00 (111/113=48)(2=69)(3=16)(4=19)(5=81)(6=49)(7=68)(8=14)(9=85)	/*
*/	(10=87)(11=96)(12=96)(13=95)(else=.), gen(item)

isid household_id round fp_00	//	item not identifying due to teff combination
label_access_item
ta item round, m



ta fp1_avail fp4_7dayneed,m
ta fp4_7dayneed round,m		//	 in rounds 17 & 18 the questions were not asked if the item was not available. How is this handled in other rounds
ta fp4_7dayneed fp_00,m
g item_need = (fp4_7dayneed==1) if inlist(fp4_7dayneed,0,1)
la var item_need	"Household wanted or needed to buy [item] in past 7 days"
ta fp5_7dayaccess,m
ta fp_00 fp5_7dayaccess,m
ta fp5_7dayaccess fp4,m
g		item_access  = (fp5_7dayaccess==1) if inlist(fp5_7dayaccess,0,1)
la var	item_access	"Able to buy any [item] in past 7 days"

tabstat item_need item_access, by(fp_00) format(%9.3g)

ta fp6_7daynoaccess
ta fp6_7_reason1
la li fp6_7_reason	//	non-standard set, no loop  
g		item_noaccess_label=.
la var	item_noaccess_label	"Reason not able to buy any [food] in past 7 days"

	egen	item_noaccess_cat1 = anymatch(fp6_7_reason?), v(1 3 5)	//	binning quotas and quality/availability into stock issues 
	egen	item_noaccess_cat5 = anymatch(fp6_7_reason?), v(2)
	egen	item_noaccess_cat6 = anymatch(fp6_7_reason?), v(6)
	egen	item_noaccess_cat21= anymatch(fp6_7_reason?), v(7)

	recode item_noaccess_cat? (0=.) if item_access!=0
su item_noaccess_cat?

ta fp7_7dayamount fp4_7dayneed,m
g		item_fullbuy = (fp7_7dayamount==1) if inlist(fp7_7dayamount,1,0)
la var	item_fullbuy		"Able to buy desired amount of [item] in past 7 days"

ta fp8_7daynoamount
la li fp6_7_reason
g		item_ltfull_label=.
la var	item_ltfull_label	"Reason not able to buy desired amount of [item] in past 7 days"
	egen	item_ltfull_cat1 = anymatch(fp6_7_reason?), v(1 3 5)	//	binning quotas and quality/availability into stock issues 
	egen	item_ltfull_cat5 = anymatch(fp6_7_reason?), v(2)
	egen	item_ltfull_cat6 = anymatch(fp6_7_reason?), v(6)
	egen	item_ltfull_cat21= anymatch(fp6_7_reason?), v(7)
recode item_ltfull_cat? (0=.) if item_fullbuy!=0


*	deal with duplicates rising out of multiple teff types
#d ; 
collapse (max) item_need (min) item_access (max) item_noaccess_*
		(min) item_fullbuy (max) item_ltfull_*
		, by(household_id round item); 
#d cr 

tempfile food
sa		`food'

// ta fp9_2mquant food_access,m
// g food_change_label=.
// la var food_change_label	"Change in [item] purchase quantity since two months ago"
// la li fp9_2mquant_10
// forv i=1/3 {
// g food_change_cat`i' = (fp9_2mquant==`i') if !mi(fp9_2mquant)
// }
// la var food_change_cat1	"Increase"
// la var food_change_cat2	"No change"
// la var food_change_cat3	"Decrease"

// ta fp10_2mless,m 
// la li fp6_7_reason
// g food_decrease_label=.
// la var food_decrease_label	"Reason for decrease in [food] purchase quantity"
// forv i=1/7 {
// 	egen food_decrease_cat`i' = anymatch(fp10_2_less?), v(`i')
// 	la var food_decrease_cat`i'	"`: label fp6_7_reason `i''"
// }
// recode food_decrease_cat? (0=.) if food_change_cat3!=1

}	/*	end food	*/

u `food', clear
append using `health'
isid household_id round item


keep  household_id round item*
order household_id round item*
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
label_item_ltfull noaccess
label_item_ltfull ltfull

*	clean up
// drop *_label
drop item_ltfull item_ltfull_os

sa "${tmp_hfps_eth}/access.dta", replace 
u  "${tmp_hfps_eth}/access.dta", clear 







