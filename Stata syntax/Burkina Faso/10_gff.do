

u "${tmp_hfps_bfa}/access.dta", clear
ta item round if inlist(item,11,51,52,53,54,55,56,57,58)
	*	2/14 16/18 20 22
loc investigate=0
if `investigate'==1 {	/*	investigations	*/
	*	two separate directories for phase 1 & 2
dir "${raw_lsms_bfa}", w
d using "${raw_lsms_bfa}/s07b_me_bfa2018.dta"
u "${raw_lsms_bfa}/s07b_me_bfa2018.dta", clear
la li produitID
// la save produitID using "${do_hfps_bfa}/label_item.do", replace	//starting point
ta s07bq01 if s07bq02==1
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/*prix*.dta", w
dir "${raw_hfps_bfa}/*acces*.dta", w


********************************************************************************	
********************************************************************************	

*	initial style
d using	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"		

d using	"${raw_hfps_bfa}/r12_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r12_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r13_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r13_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r14_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r14_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r14_sec5g1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r14_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r14_sec5i1_acces_service_sante_individuelle.dta"		
d using	"${raw_hfps_bfa}/r14_sec5i2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r15_sec5_acces_aliments_base.dta"		
d using	"${raw_hfps_bfa}/r16_sec5g1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r16_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r17_sec5_acces_aliments_base.dta"		
d using	"${raw_hfps_bfa}/r17_sec5g1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r17_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r18_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r18_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r19_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r20_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r20_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r20_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r21_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r22_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r22_sec5f1_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r22_sec5f2_acces_service_sante.dta"		

d using	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r19_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r19_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r19_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r20_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r20_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r20_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r21_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r21_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r21_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r22_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r22_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r22_sec5t_prix_transport.dta"		

label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5f1_acces_service_sante.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5f2_acces_service_sante.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5_acces_aliments_base.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5_acces_aliments_biens_essentiels.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5g1_acces_service_sante.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5g2_acces_service_sante.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5c_prix_carburant.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5p_prix_denrees_alimentaires.dta"')
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5t_prix_transport.dta"')

label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5f1_acces_service_sante.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5f2_acces_service_sante.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5_acces_aliments_base.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5_acces_aliments_biens_essentiels.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5g1_acces_service_sante.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5g2_acces_service_sante.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5c_prix_carburant.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5p_prix_denrees_alimentaires.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5t_prix_transport.dta"') vallab


u	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"		, clear
u	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"		, clear

{	/*	rounds 2-11 combined	*/
preserve
qui {
forv r=2/11 {
u	"${raw_hfps_bfa}/r`r'_sec5_acces_service_base.dta"		, clear
la dir
uselabel `r(labels)', clear
replace label=strlower(strtrim(label))
tempfile r`r'
sa		`r`r''
}
u `r2', clear
forv r=2/11 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
}
sort lname value label
recode _? _?? (. 1=.)(2 3=1)
la val _* .
egen rounds = group(_? _??), label missing
}
li lname value label rounds, sepby(lname)
li lname value label rounds	if lname=="s05q03d_1b", sep(0) noobs
li value label				if lname=="s05q03d_1b", sep(0) clean noobs	//	for google translate copy/paste
restore

*	systematic comparison of labels in s05q03b => health service 

preserve
qui {
forv r=2/11 {
u	"${raw_hfps_bfa}/r`r'_sec5_acces_service_base.dta"		, clear
cap : d s05q03b*, replace clear
if _rc==0 {
replace varlab=strlower(strtrim(varlab))
loc rounds `rounds' `r'
tempfile r`r'
sa		`r`r''
}
}
dis "`rounds'"
u `r`: word 1 of `rounds''', clear
foreach r of numlist `rounds' {
	mer 1:1 name varlab using `r`r'', gen(_`r')
}
sort name varlab 
cap : drop __*
recode _* (. 1=.)(2 3=1)
la val _* .
egen rounds = group(_*), label missing
}
li name varlab rounds, sep(0) noobs clean
g code = substr(name,length("s05q03b__")+1,length(name)-length("s05q03b__"))
destring code, replace force
sort code
egen value = ends(varlab), punct(:) tail
replace value=strtrim(value)
li code value, sep(0) noobs clean	//	these are all typical health problems, do not fit will with our codes
restore

}





u	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta", clear
la li produit		//	coding hsa a spatial strata (Ougadougou vs oth urban vs rural)
u	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta", clear
la li produit		
la li s09eq02a_1
u	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta", clear
la li da
la li s05fq02
u	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta", clear
la li da
u	"${raw_hfps_bfa}/r18_sec5t_prix_transport.dta", clear
la li da

{	/*	item codes are not harmonized across rounds, necessitating a recode */
preserve
qui {
foreach r of numlist 18(1)22 {
u	"${raw_hfps_bfa}/r`r'_sec5p_prix_denrees_alimentaires.dta", clear
uselabel da, clear
tempfile r`r'
sa		`r`r''
}
clear 
u `r18', clear
foreach r of numlist 19(1)22	{
	mer 1:1 value label using `r`r'', gen(_`r')
}
}
li value label _*, nol sepby(value)	
restore
}	/*	code is stable	*/
}	/*	end investigations	*/

********************************************************************************	
********************************************************************************	

	*	programs to label
do "${do_hfps_util}/label_access_item.do"

	
********************************************************************************	
********************************************************************************	
********************************************************************************	
********************************************************************************	

	
{	/*	phase 2	*/
********************************************************************************	
********************************************************************************	

{	/*	health phase 2	*/

{	/*	hh level (classic) version (f)	*/

#d ; 
	u "${raw_hfps_bfa}/r14_sec5f2_acces_service_sante.dta", clear; 
	ren *_cls* **;
	tempfile r14	; 
	sa		`r14'	; 
clear; append using 
	"${raw_hfps_bfa}/r12_sec5f2_acces_service_sante.dta"	
	"${raw_hfps_bfa}/r13_sec5f2_acces_service_sante.dta"	
	`r14'	
	, gen(round); la drop _append; la val round .; 
#d cr 
replace round=round+11
isid hhid round service
ta service
la li service
g item=service+49 if service!=96
recode item (50=58)
drop if mi(item)

ta s05q07 round
// la li s5fq7_2	//	no value label coded in. google translate has led this solution to get down to 9 codes
recode s05q07 (1 2 7=1)(3/6 8 9 11=2)(10=3)(12=8)(13=7), gen(care_place)

ta s05q08
g care_oop_any = (s05q08==1) if !mi(s05q08)

d s05q09?_?
tabstat s05q09?_?, by(round)
tabstat s05q09?_?, by(round) s(n sum)

recode s05q09b_2 s05q09b_3 s05q09b_4 s05q09b_5 (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m

g goods		= cond(round==12,s05q09b_2,yy)
g transit	= cond(round==12,s05q09b_3,zz)
g other		= cond(round==12,s05q09b_4,s05q09b_6)

loc vars s05q09b_1 goods transit other
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode	care_oop_d_* (.=0) if care_oop_any==1
egen	care_oop_value = rowtotal(care_oop_v_*)
recode	care_oop_value (0=.) if care_oop_any==0

ta s05q10 round,m
recode s05q10 (3=4)(4=5)(5=3), gen(care_satisfaction)


keep hhid round item care_*

tempfile classic
sa		`classic'



}

{	/*	individual level (experimental) version (g, then f)	*/
d using	"${raw_hfps_bfa}/r14_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r16_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r17_sec5g2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r18_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r20_sec5f2_acces_service_sante.dta"		
d using	"${raw_hfps_bfa}/r22_sec5f2_acces_service_sante.dta"		

{	/*	verifying health service code consistency	*/
foreach r of numlist 14 16 17 {
	u service using "${raw_hfps_bfa}/r`r'_sec5g2_acces_service_sante.dta", clear
	uselabel service, clear
	tempfile r`r'
	sa		`r`r''
}
foreach r of numlist 18 20 22 {
	u service using "${raw_hfps_bfa}/r`r'_sec5f2_acces_service_sante.dta", clear
	uselabel service, clear
	tempfile r`r'
	sa		`r`r''
}
u `r14', clear
foreach r of numlist 14 16/18 20 22 {
mer 1:1 lname value label using `r`r'', gen(_`r')
la val _`r' .
recode _`r' (1 .=.)(2 3=`r')
}
egen rounds = group(_??), missing label
li lname value label rounds, sepby(lname) 	//	yes, consistent across all rounds 
li label value, sepby(lname) noobs clean	//	for google translate copy-paste
}


#d ; 
clear; append using
	"${raw_hfps_bfa}/r14_sec5g2_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r16_sec5g2_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r17_sec5g2_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r18_sec5f2_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r20_sec5f2_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r22_sec5f2_acces_service_sante.dta"		
	, gen(round); la drop _append; la val round .; 
#d cr

replace round=round+13
replace round=round+1 if round>14
replace round=round+1 if round>18
replace round=round+1 if round>20

tab2 round service service_id,m first
replace service=service_id if mi(service) & !mi(service_id)
isid round hhid membres__id service

g item=service+49 if service!=96
recode item (50=58)
drop if mi(item)



ta s05q07 round
// la li s5fq7_2	//	no value label coded in. google translate has led this solution to get down to 9 codes
recode s05q07 (1 2 7=1)(3/6 8 9 11=2)(10=3)(12=8)(13=7), gen(care_place)
ta s05q08
g care_oop_any = (s05q08==1) if !mi(s05q08)

d s05q09?_?
tabstat s05q09?_?, by(round)
tabstat s05q09?_?, by(round) s(n sum)

recode s05q09b_2 s05q09b_3 s05q09b_4 s05q09b_5 (min/0=.), copyrest gen(aa bb cc dd)
egen yy = rowtotal(aa bb), m
egen zz = rowtotal(cc dd), m


loc vars s05q09b_1 yy zz s05q09b_6
su		`vars'
tabstat	`vars', by(care_oop_any) s(n mean)
recode	`vars' (min/0=0)(nonm=1),  gen(care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other)
recode	`vars' (min/0=.), copyrest gen(care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other)
recode	care_oop_d_* (.=0) if care_oop_any==1
egen	care_oop_value = rowtotal(care_oop_v_*)
recode	care_oop_value (0=.) if care_oop_any==0

ta s05q15 round,m nol
la li s05q15
recode s05q15 (3=4)(4=5)(5=3), gen(care_satisfaction)


*	now we must go to household x item level
#d ; 
	collapse	(min) care_place care_oop_any 
				(min) care_oop_d_* (sum) care_oop_v_* care_oop_value
				(max) care_satisfaction
	, by(hhid round item); 
#d cr 
tempfile experimental
sa		`experimental'
}
	
	
clear
append using `classic' `experimental'	
isid hhid round item
label_access_item


// tempfile health_phase2
// sa		`health_phase2'
}	/*	end health phase 2	*/
		

// u `basic_phase2', clear
// mer 1:1 hhid round item using `health_phase2', assert(1 2) nogen
// mer 1:1 hhid round item using `price_modules_phase2'
// ta item _m	//	this presents some interesting possibilities
// ta item_avail item_access	//	how would we reconcile these, 
// table item round if _m==3, stat(sum item_avail item_need item_access)
// drop _merge	//	must clean this up for the final construction however 
// la drop _merge


isid hhid round item
sort hhid round item
tempfile phase2
sa		`phase2'

}	/*	end phase 2	*/


********************************************************************************	
********************************************************************************	
********************************************************************************	
********************************************************************************	

clear
append using `phase1' `phase2'
	label_access_item

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

isid hhid round item
sort hhid round item
sa "${tmp_hfps_bfa}/gff.dta", replace 
u  "${tmp_hfps_bfa}/gff.dta", clear 
d, s
ta item round
cap : 	prog drop	label_access_item

ex
