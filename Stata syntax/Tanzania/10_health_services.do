


u "${tmp_hfps_tza}/access.dta", clear
ta item round if inlist(item,11,51,52,53,54,55,56,57,58)
	*	rounds 1 2 and 5 
dir "${raw_hfps_tza}", w
dir "${raw_hfps_tza}/*_5*", w

wordsearch "*ocket* *OCKET*", dir("${raw_hfps_tza}")
	*	round 5 only 

*	section 5
d s5*	using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	//	no
d		using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
d s7*	using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s5 not access
d		using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s7
d s5*	using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	//	s5 not access
d		using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	//	s7
d		using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		//	yes, healthcare 
d		using	"${raw_hfps_tza}/r5_sect_5f.dta"	//	yes, healthcare 
d s5*	using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	yes, also healthcare
d		using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
d s5*	using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	this s5 is economic sentiment
d		using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	s7 has some fuel access questions
d s7*	using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	

d		using	"${raw_hfps_tza}/r6_sect_6.dta"	//	no access, price only
d		using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	no access, price only

d 		using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r7_sect_5.dta"	//	yes, access
d s5*	using	"${raw_hfps_tza}/r7_sect_5.dta"	//	yes, access
d		using	"${raw_hfps_tza}/r7_sect_6.dta"	//	no, price only
d		using	"${raw_hfps_tza}/r7_sect_7.dta"	//	yes, fuel access 
d		using	"${raw_hfps_tza}/r7_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r8_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r8_sect_6.dta"	//	no, price only
d 		using	"${raw_hfps_tza}/r8_sect_7.dta"	//	yes, fuel access
d 		using	"${raw_hfps_tza}/r8_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r9_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r9_sect_6.dta"	//	availability, no access
d 		using	"${raw_hfps_tza}/r9_sect_7.dta"	//	yes, fuel acces
d 		using	"${raw_hfps_tza}/r9_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r10_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r10_sect_6.dta"	//	availability, no access
d 		using	"${raw_hfps_tza}/r10_sect_7.dta"	//	yes, fuel acces
d 		using	"${raw_hfps_tza}/r10_sect_8.dta"	//	yes, transit access


d s5*	using	"${raw_hfps_tza}/r9_sect_5.dta"	
	*	the r7-9 are a distinct structure, can treat them in a batch


run "${do_hfps_util}/label_access_item.do"

	

{	/*	round 5	*/	
d		using	"${raw_hfps_tza}/r5_sect_5f.dta"	//	yes, healthcare 
u	"${raw_hfps_tza}/r5_sect_5f.dta", clear
ta service_cd s5fq4 
	*	this comparison demonstrates that the information in the hh level module is identical to the info in the service_cd identified data
isid hhid service_cd
la li service_cd
recode service_cd (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57)(else=.), gen(item)
ta s5fq4_os service_cd
recode item (.=55) if service_cd==96 & !mi(s5fq4_os)
drop if mi(item)


ta s5fq7
la li s5fq7_2
recode s5fq7 (2/4=2)(5=3)(6=8), copyrest gen(care_place)
cleanstr s5fq7_os
levelsof str if s5fq7==96, clean	//	these are in swahili, translated using google translate
recode care_place 96=2 if inlist(str,"ofisi za serikali za mtaa","zahanati")

ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d s5fq9?
su s5fq9?	//	no coded missing/don't know option
tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq10
la li s5fq10_2	//	no coded 5 option
recode s5fq10 (3=4)(4=5)(5=3), gen(care_satisfaction)	


	*	deal with duplicates made by recode of item 
	#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
		, by(hhid item); 
	#d cr
	*	construct item 11 across all medical care types 
	#d ; 
	preserve; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
		, by(hhid); 
	g byte item=11; 
	tempfile item11;
	sa		`item11'; 
	restore; 
	append using `item11'; 
	#d cr


label_access_item
g round=  5
tempfile r5
sa		`r5'
}	/*	 r5 end	*/
	
	
#d ; 
clear; append using
	`r1' `r2' `r5' `r6' `r7_10'; 
#d cr
// replace round=round+2 if round>2
ta round
	
isid	hhid round item
order	hhid round item
sort	hhid round item

ta item
label_access_item
ta item round


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

sa "${tmp_hfps_tza}/health_services.dta", replace 

cap : 	prog drop	label_access_item

ex
u  "${tmp_hfps_tza}/health_services.dta", clear 



