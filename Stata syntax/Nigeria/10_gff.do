



u "${tmp_hfps_nga}/access.dta", clear
ta item round if inlist(item,11,51,52,53,54,55,56,57,58)
	//	rounds 2 4 9 10 11 13 15 16 17 18 20 
*	For GFF, we are targeting the follow-up questions, especially out of pocket payment
*	Primarily, these questions start in phase 2. 
*	two separate directories for phase 1 & 2


dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

wordsearch "*ocket* *OCKET*", dir("${raw_hfps_nga2}")
	*-> rounds 13 15 16 17 18 20, sect_5 

	label_inventory "${raw_hfps_nga2}", pre(`"p2r"') suf(`"_sect_5.dta"') varname
	qui : label_inventory "${raw_hfps_nga2}", pre(`"p2r"') suf(`"_sect_5.dta"') vallab retain
	li lname value label matches rounds if strpos(lname,"5")>0, sepby(lname)
	

d s5* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r6_sect_5c.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	no
// d s5* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	no
d s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	no
d s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r12_sect_5e_9a.dta"				//	no

d s5* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"	//	no
d using	"${raw_hfps_nga2}/p2r1_sect_5.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_5.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	yes, food prices
d s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5.dta"	//	yes, health 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
d s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices
d s5* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	fuel 



*	These GFF questions are pretty stable across time 
*	
run "${do_hfps_util}/label_access_item.do"


	*-> rounds 13 15 16 17 18 20, sect_5 

d		s5* using	"${raw_hfps_nga2}/p2r1_sect_5.dta"	//	no
u					"${raw_hfps_nga2}/p2r1_sect_5.dta", clear
#d ; 
clear; append using
	"${raw_hfps_nga2}/p2r1_sect_5.dta"
	"${raw_hfps_nga2}/p2r3_sect_5.dta"
	"${raw_hfps_nga2}/p2r4_sect_5.dta"
	"${raw_hfps_nga2}/p2r5_sect_5.dta"
	"${raw_hfps_nga2}/p2r6_sect_5.dta"
	"${raw_hfps_nga2}/p2r8_sect_5.dta"
	, gen(round); la drop _append; la val round .; 
#d cr
replace round=round+12
replace round=round+1 if round>13
replace round=round+1 if round>18
isid hhid round service_cd

la li service_cd
g item = service_cd-1 if service_cd!=96
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq7
la li s5fq7_2
g care_place=s5fq7
ta s5fq8
g care_oop_any = (s5fq8==1) if !mi(s5fq8)

d s5fq9?
d s5fq9*	//	we will do away with the distinction bewteen prescription and non-prescription drugs
recode s5fq9b? (min/0=.), copyrest gen(aa bb)
egen zz = rowtotal(aa bb), m
compare s5fq9b zz
replace s5fq9b=zz if mi(s5fq9b) & !mi(zz)
su s5fq9?
tabstat s5fq9?, by(care_oop_any) s(n mean)
recode s5fq9? (min/0=0)(nonm=1), gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode s5fq9? (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode care_oop_d_* (.=0) if care_oop_any==1
egen care_oop_value = rowtotal(care_oop_v_*)
recode care_oop_value (0=.) if care_oop_any==0

ta s5fq10
recode s5fq10 (3=4)(4=5)(5=3), gen(care_satisfaction)


keep hhid round item care_*

	#d ; 
	preserve; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
		, by(hhid round); 
	g item=11; 
	tempfile item11;
	sa		`item11'; 
	restore; 
	append using `item11'; 
	#d cr

isid hhid round item
sort hhid round item
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

sa "${tmp_hfps_nga}/gff.dta", replace 
u  "${tmp_hfps_nga}/gff.dta", clear 
ta item round

ex













