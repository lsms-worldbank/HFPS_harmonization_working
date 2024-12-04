

u "${tmp_hfps_mwi}/access.dta", clear
ta round item if item==11 | inrange(item,51,58)
	*	rounds 1(1)21
wordsearch "*ocket* *OCKET*", dir("${raw_hfps_mwi}")
*	rounds 13 14 15 16 17 18 20

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*access*", w
dir "${raw_hfps_mwi}/sect5_access_r*", w
dir "${raw_hfps_mwi}/*prices*", w

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
d using	"${raw_hfps_mwi}/sect5_healthaccess_r20.dta"

d using	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"	//	no access, just knowledge of price 
d using	"${raw_hfps_mwi}/sect11_foodprices_r20.dta"	//	no access, just knowledge of price 

d using	"${raw_hfps_mwi}/sect11_transportprices_r17.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_transportprices_r19.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_transportprices_r20.dta"	//	yes access

d using	"${raw_hfps_mwi}/sect14_fuels_r16.dta"	//	yes access
d using	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"	//	yes acces
d using	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"	//	yes acces
d using	"${raw_hfps_mwi}/sect11_fuelprices_r20.dta"	//	yes acces

d using	"${raw_hfps_mwi}/sect14_swift_r17.dta"	//	no access

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



*	this module shifts somewhat over time. will have to implement round by round 
run "${do_hfps_util}/label_access_item"


{	/*	round 13	*/
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r13.dta"	//	insurance
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r13.dta"



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


ta s5fq7
la li s5fq7_2
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

su s5fq9?
tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq10
la li s5fq10_2
recode s5fq10 (3=4)(4=5)(5=3), gen(care_satisfaction)

keep y4_hhid item care_*


g round=  13
tempfile r13
sa		`r13'
}	/*	 r13 end	*/


{	/*	round 14	*/
d using	"${raw_hfps_mwi}/sect5_heatlthaccess1_r14.dta"	//	insurance + one need question
d using	"${raw_hfps_mwi}/sect5_heatlthaccess2_r14.dta"


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

ta s5fq7
la li s5fq7_2
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

su s5fq9?
tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq10
la li s5fq10_2
recode s5fq10 (3=4)(4=5)(5=3), gen(care_satisfaction)

keep y4_hhid item care_*

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
keep y4 pid service_cd  s5hq7* s5hq8 s5hq9* 
ren (s5hq*)(s5fq*)


tempfile indiv2
sa		`indiv2'

u	"${raw_hfps_mwi}/sect5g_healthaccessnew2_r15.dta", clear	/*	to harmonize, need to take max of this vn	*/
la li service_type__id
recode service_cd (6=7)(7=8)

keep y4 pid service_cd s5gq7* s5gq8 s5gq9* 
ren (s5gq*)(s5fq*)
append using `indiv2', gen(mk)

// g item=service_cd+49 if service_cd!=96
// recode item 50=58
// drop if mi(item)

cleanstr s5fq9f_oth
ta str,m


ta s5fq7
la li s5fq7
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d s5hq9? using "${raw_hfps_mwi}/sect5h_healthaccessnew_indiv2_r15.dta"
su s5fq9?
tabstat s5fq9?, by(care_oop_any) s(n mean)

recode s5fq9b s5fq9c s5fq9d s5fq9e (min/0=.), copyrest gen(bb cc dd ee)
drop s5fq9b s5fq9c s5fq9d s5fq9e
egen xx = rowtotal(bb cc), m
egen yy = rowtotal(dd ee), m
g s5fq9b = xx, a(s5fq9a)
g s5fq9c = yy, a(s5fq9b)
ren s5fq9f s5fq9d	

recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0


// keep y4_hhid item care_*
keep y4_hhid pid mk service_cd care_*
#d ; 
reshape wide care_place care_oop_any 
	care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other 
	care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other 
	care_oop_value
	, i(y4_hhid pid mk) j(service_cd); 
#d cr 

tempfile mod2
sa		`mod2'

*	retain all of this module 1 stuff to ensure we get the same set of observations as in access
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


*	these are changes to service type based on the care specified


tabstat s5gq4__*, s(n sum min max) c(s) varw(12)
cleanstr s5gq4_os
ta str if s5gq4__96==1
d s5gq4__*
g if4 = 1 if inlist(str,"blood pressure","check up","cough","coughing","infection","legs","malaria")
g if7 = 1 if inlist(str,"bought medz from grocery","buy drugs","medicine from grocery","pharmacy","purchae medicine from grocery store","purchase of medicine","skin care")

foreach i of numlist 4 7 {
replace care_place`i'=min(care_place`i',care_place96) if if`i'==1
replace care_oop_any`i' = max(care_oop_any`i',care_oop_any96) if if`i'==1
replace care_oop_value`i' = cond(!mi(care_oop_value`i'),care_oop_value`i',0) + cond(!mi(care_oop_value96),care_oop_value96,0)    if if`i'==1
recode  care_oop_value`i' (0=.) if care_oop_any`i'!=1 & if`i'==1
foreach c in services goods transit other {
	replace care_oop_v_`c'`i' = cond(!mi(care_oop_v_`c'`i'),care_oop_v_`c'`i',0) + cond(!mi(care_oop_v_`c'96),care_oop_v_`c'96,0)    if if`i'==1
	replace care_oop_d_`c'`i' = max(care_oop_d_`c'`i',care_oop_d_`c'96) if if`i'==1
	recode  care_oop_v_`c'`i' (0=.) if care_oop_d_`c'`i'!=1 & if`i'==1
}
}



*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d care*1,f
tab1 care_place*
#d ; 
collapse 
	(min)	care_place* 
	(max)	care_oop_any* 
			care_oop_d_services* care_oop_d_goods* care_oop_d_transit* care_oop_d_other*
	(sum)	care_oop_v_services* care_oop_v_goods* care_oop_v_transit* care_oop_v_other*
			care_oop_value*
	, by(y4_hhid);
#d cr 

*	make long by item 
keep y4_hhid care*
drop *96	// we have gleaned all that we can use from these 
d *1
#d ; 
reshape long care_place care_oop_any
			care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other
			care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other
			care_oop_value
	, i(y4_hhid) j(item); 
#d cr 
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
d, si

tempfile r15new
sa		`r15new'




/*	old	module	*/

u	"${raw_hfps_mwi}/sect5f_healthaccess2_r15.dta", clear

ta service_cd	
la li Sect5f_id_2__id	//	they did away with 5/6 disaggregation here, and binned a bunch explicitly into 8 
recode service_cd (5=6)	//	we have been binning extras into "adult care", so will continue to use this bin here. In the MW aggregation, let's manually bin 5 & 6 
ta s5fq4_os
cleanstr s5fq4_os
recode service_cd 96=8 if str=="tooth"	
recode service_cd 96=6 	//	remainder
drop str

g		item = service_cd+49 if inrange(service_cd,2,8)
replace	item = 58 if service_cd==1	//	no cases for service_cd=1

*	get our zeroes
ta s5fq4 s5fq5,m

ds y4_hhid hhid item, not
reshape wide `r(varlist)', i(y4_hhid) j(item)
reshape long


ta s5fq7
la li s5aq7_2
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d  s5fq9?
su s5fq9?
recode s5fq9b s5fq9c s5fq9d s5fq9e (min/0=.), copyrest gen(bb cc dd ee)
drop s5fq9b s5fq9c s5fq9d s5fq9e
egen xx = rowtotal(bb cc), m
egen yy = rowtotal(dd ee), m
g s5fq9b = xx, a(s5fq9a)
g s5fq9c = yy, a(s5fq9b)
ren s5fq9f s5fq9d	

tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq10
la li s5aq10_2
recode s5fq10 (3=4)(4=5)(5=3), gen(care_satisfaction)

keep y4_hhid item care_*

isid y4_hhid item
d, si

tempfile r15old
sa		`r15old'

clear
append using `r15old' `r15new', gen(mk)
la val mk .
isid y4_hhid item
ta item mk,m
expand 2 if item==51 & mk==1, gen(fill_covid19_vals)
recode item (51=58)		if fill_covid19_vals==1
recode care_* (nonm=.)	if fill_covid19_vals==1
drop fill_covid19_vals
ta item mk,m
drop mk

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
cleanstr s5gq6_ot
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

keep y4 pid service_cd s5gq7* s5gq8 s5gq9*
ren (s5gq*)(s5fq*)

ta s5fq7
la li s5fq7
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d  s5fq9?
su s5fq9?
recode s5fq9b s5fq9c s5fq9d s5fq9e (min/0=.), copyrest gen(bb cc dd ee)
drop s5fq9b s5fq9c s5fq9d s5fq9e
egen xx = rowtotal(bb cc), m
egen yy = rowtotal(dd ee), m
g s5fq9b = xx, a(s5fq9a)
g s5fq9c = yy, a(s5fq9b)
ren s5fq9f s5fq9d	

tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0


keep y4_hhid pid service_cd care_*
#d ; 
reshape wide care_place care_oop_any 
	care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other 
	care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other 
	care_oop_value
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
cleanstr s5gq4_os
ta str if s5gq4__96==1
d s5gq4__*

g if8 = 1 if inlist(str,"body pains","epilepsy","headache","purchase","purchase medicine")

foreach i of numlist 8 {
replace care_place`i'=min(care_place`i',care_place96) if if`i'==1
replace care_oop_any`i' = max(care_oop_any`i',care_oop_any96) if if`i'==1
replace care_oop_value`i' = cond(!mi(care_oop_value`i'),care_oop_value`i',0) + cond(!mi(care_oop_value96),care_oop_value96,0)    if if`i'==1
recode  care_oop_value`i' (0=.) if care_oop_any`i'!=1 & if`i'==1
foreach c in services goods transit other {
	replace care_oop_v_`c'`i' = cond(!mi(care_oop_v_`c'`i'),care_oop_v_`c'`i',0) + cond(!mi(care_oop_v_`c'96),care_oop_v_`c'96,0)    if if`i'==1
	replace care_oop_d_`c'`i' = max(care_oop_d_`c'`i',care_oop_d_`c'96) if if`i'==1
	recode  care_oop_v_`c'`i' (0=.) if care_oop_d_`c'`i'!=1 & if`i'==1
}
}

*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d care*1,f
tab1 care_place*
#d ; 
collapse 
	(min)	care_place* 
	(max)	care_oop_any* 
			care_oop_d_services* care_oop_d_goods* care_oop_d_transit* care_oop_d_other*
	(sum)	care_oop_v_services* care_oop_v_goods* care_oop_v_transit* care_oop_v_other*
			care_oop_value*
	, by(y4_hhid);
#d cr 

*	make long by item 
keep y4_hhid care*
drop *96	// we have gleaned all that we can use from these 
d *1
#d ; 
reshape long care_place care_oop_any
			care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other
			care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other
			care_oop_value
	, i(y4_hhid) j(item); 
#d cr 
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
d, si

isid y4_hhid item

g round=  16
tempfile r16
sa		`r16'
}	/*	 r16 end	*/


{	/*	round 17	*/
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r17.dta"	//	n=8122
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r17.dta"	//	n=1109




u	"${raw_hfps_mwi}/sect5_healthaccessnew2_r17.dta", clear	/*	to harmonize, need to take max of this vn	*/

la li service_type__id
recode service_cd (6=7)(7=8)
keep y4 pid service_cd s5gq7* s5gq8 s5gq9*
ren (s5gq*)(s5fq*)

ta s5fq7
la li s5fq7
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d  s5fq9?
su s5fq9?
recode s5fq9b s5fq9c s5fq9d s5fq9e (min/0=.), copyrest gen(bb cc dd ee)
drop s5fq9b s5fq9c s5fq9d s5fq9e
egen xx = rowtotal(bb cc), m
egen yy = rowtotal(dd ee), m
g s5fq9b = xx, a(s5fq9a)
g s5fq9c = yy, a(s5fq9b)
ren s5fq9f s5fq9d	

tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0


keep y4_hhid pid service_cd care_*
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
cleanstr s5gq4_os
ta str if s5gq4__96==1
d s5gq4__*

g if5 = 1 if inlist(str,"check up","hiv testing","under five clinic")
g if8 = 1 if inlist(str,"medicine","medicine purchase","pharmacy","purchasing medicine","scale")
foreach i of numlist 5 8 {
replace care_place`i'=min(care_place`i',care_place96) if if`i'==1
replace care_oop_any`i' = max(care_oop_any`i',care_oop_any96) if if`i'==1
replace care_oop_value`i' = cond(!mi(care_oop_value`i'),care_oop_value`i',0) + cond(!mi(care_oop_value96),care_oop_value96,0)    if if`i'==1
recode  care_oop_value`i' (0=.) if care_oop_any`i'!=1 & if`i'==1
foreach c in services goods transit other {
	replace care_oop_v_`c'`i' = cond(!mi(care_oop_v_`c'`i'),care_oop_v_`c'`i',0) + cond(!mi(care_oop_v_`c'96),care_oop_v_`c'96,0)    if if`i'==1
	replace care_oop_d_`c'`i' = max(care_oop_d_`c'`i',care_oop_d_`c'96) if if`i'==1
	recode  care_oop_v_`c'`i' (0=.) if care_oop_d_`c'`i'!=1 & if`i'==1
}
}


*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d care*1,f
tab1 care_place*
#d ; 
collapse 
	(min)	care_place* 
	(max)	care_oop_any* 
			care_oop_d_services* care_oop_d_goods* care_oop_d_transit* care_oop_d_other*
	(sum)	care_oop_v_services* care_oop_v_goods* care_oop_v_transit* care_oop_v_other*
			care_oop_value*
	, by(y4_hhid);
#d cr 

*	make long by item 
keep y4_hhid care*
drop *96	// we have gleaned all that we can use from these 
d *1
#d ; 
reshape long care_place care_oop_any
			care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other
			care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other
			care_oop_value
	, i(y4_hhid) j(item); 
#d cr 
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
isid y4_hhid item
ta item, m

g round=  17
tempfile r17
sa		`r17'
}	/*	 r17 end	*/


{	/*	round 18	*/
d using	"${raw_hfps_mwi}/sect5_healthaccessnew1_r18.dta"
d using	"${raw_hfps_mwi}/sect5_healthaccessnew2_r18.dta"


u	"${raw_hfps_mwi}/sect5_healthaccessnew2_r18.dta", clear	/*	to harmonize, need to take max of this vn	*/
cleanstr s5gq6_ot
la li s5fq6
li service_cd str if s5gq6==96, sep(0)
recode s5gq6 (96=10)
*	little to do beyond this

la li service_type__id
recode service_cd (6=7)(7=8)

keep y4 PID service_cd s5gq7* s5gq8 s5gq9* 
ren (s5gq*)(s5fq*)

ta s5fq7
la li s5fq7
g care_place = s5fq7

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d  s5fq9?
su s5fq9?
recode s5fq9b s5fq9c s5fq9d s5fq9e (min/0=.), copyrest gen(bb cc dd ee)
drop s5fq9b s5fq9c s5fq9d s5fq9e
egen xx = rowtotal(bb cc), m
egen yy = rowtotal(dd ee), m
g s5fq9b = xx, a(s5fq9a)
g s5fq9c = yy, a(s5fq9b)
ren s5fq9f s5fq9d	

tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0


keep y4_hhid PID service_cd care_*
#d ; 
ds y4_hhid PID service_cd, not; 
reshape wide `r(varlist)'	
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
cleanstr s5gq4_os
ta str if s5gq4__96==1
d s5gq4__*

g if5 = 1 if inlist(str,"hiv testing","under 5 clinic","under five clinic","under5","underfive","underfive clinic-scale")
g if8 = 1 if inlist(str,"purchace of medicine","purchase of medicine","purchasing"	/*
*/	,"purchasing medicine","scale")
foreach i of numlist 5 8 {
replace care_place`i'=min(care_place`i',care_place96) if if`i'==1
replace care_oop_any`i' = max(care_oop_any`i',care_oop_any96) if if`i'==1
replace care_oop_value`i' = cond(!mi(care_oop_value`i'),care_oop_value`i',0) + cond(!mi(care_oop_value96),care_oop_value96,0)    if if`i'==1
recode  care_oop_value`i' (0=.) if care_oop_any`i'!=1 & if`i'==1
foreach c in services goods transit other {
	replace care_oop_v_`c'`i' = cond(!mi(care_oop_v_`c'`i'),care_oop_v_`c'`i',0) + cond(!mi(care_oop_v_`c'96),care_oop_v_`c'96,0)    if if`i'==1
	replace care_oop_d_`c'`i' = max(care_oop_d_`c'`i',care_oop_d_`c'96) if if`i'==1
	recode  care_oop_v_`c'`i' (0=.) if care_oop_d_`c'`i'!=1 & if`i'==1
}
}


*	now take to hh level. This means we will be claiming that the individual specific reporting in round 15 is comparable to the respondent reporting on the whole hh in other rounds
d care*1,f
tab1 care_place*
#d ; 
collapse 
	(min)	care_place* 
	(max)	care_oop_any* 
			care_oop_d_services* care_oop_d_goods* care_oop_d_transit* care_oop_d_other*
	(sum)	care_oop_v_services* care_oop_v_goods* care_oop_v_transit* care_oop_v_other*
			care_oop_value*
	, by(y4_hhid);
#d cr 

*	make long by item 
keep y4_hhid care*
drop *96	// we have gleaned all that we can use from these 
d *1
#d ; 
reshape long care_place care_oop_any
			care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other
			care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other
			care_oop_value
	, i(y4_hhid) j(item); 
#d cr 
ta item, nol
recode item (1=58)(2=51)(3=52)(4=53)(5=55)(7=56)(8=57), copyrest
label_access_item
ta item ,m
// drop if mi(item_need)	//	 gets rid of the cases where need any medical treatment=0 
d, si

isid y4_hhid item

label_access_item


g round=  18
tempfile r18
sa		`r18'
}	/*	 r18 end	*/


{	/*	round 20	*/
d using	"${raw_hfps_mwi}/sect5_healthaccess_r20.dta"	//	substantial reorganization vis-a-vis r18

gl r=20	//	enforce the round for simplicity below


d using	"${raw_hfps_mwi}/sect5_healthaccess_r${r}.dta"	
u		"${raw_hfps_mwi}/sect5_healthaccess_r${r}.dta", clear

la li f_services__id
recode service_id (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(else=.), gen(item)
label_access_item
ta s5fq2a item,m
drop if mi(item)	//	no category for "other health services" here and string response is not available 

*	get our zeroes
ta s5fq4 s5fq5,m

*	names are shifted 

ta s5fq6
la li f6
cleanstr s5fq6_os
ta str
g care_place = s5fq6

ta s5fq7
g care_oop_any = (s5fq7==1) if !mi(s5fq7)

d s5fq8*	//	documentation is unclear but from qx b_1 is prescription and b_2 is non-prescription
cleanstr s5fq8d_os
ta str
su s5fq8?
tabstat s5fq8?, by(care_oop_any) s(n mean)

recode s5fq8b_?  (min/0=.), copyrest gen(bb cc)
egen s5fq8b = rowtotal(bb cc), m
recode s5fq8? (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq8? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq9
la li f9
recode s5fq9 (3=4)(4=5)(5=3), gen(care_satisfaction)

keep y4_hhid item care_*
isid y4_hhid item


label_access_item
ta item
d, si
g round=  ${r}
tempfile r${r}
sa		`r${r}'
}	/*	 r${r} end	*/



/*	append all rounds	*/
clear
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8' `r9' `r11' `r12' `r13' `r14' `r15' `r16' `r17' `r18' `r19' `r20', nolabel
isid	y4_hhid round item
order	y4_hhid round item

ta item
label_access_item
ta item round

preserve
#d ; 
collapse 
	(min)	care_place 
	(max)	care_oop_any 
			care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other
	(sum)	care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other
			care_oop_value
	, by(y4_hhid round);
#d cr 
g item=11
tempfile item11
sa		`item11'
restore
append using `item11'
sort	y4_hhid round item
ta item care_oop_any,m

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


sa "${tmp_hfps_mwi}/gff.dta", replace 
u  "${tmp_hfps_mwi}/gff.dta", clear 

cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex

ex















