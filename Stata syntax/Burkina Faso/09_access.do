
{	/*	investigations	*/
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

label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec5_acces_service_base.dta"') vallab

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
do "${do_hfps_util}/label_item_ltfull.do"

	
{	/*	rounds 2-11	*/
	#d ; 
clear; qui : append using
	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"		
	, gen(round); la drop _append; la val round .; replace round=round+1; 
#d cr 
isid hhid round

gl i=1
ta s05q01a round,m
g		item_need${i} = (s05q01a!=5) if inlist(round,2,3,4)
replace item_need${i} = (s05q01a!=6) if inlist(round,5,6,9,10)
ta s05q01a s05q01b
ta s05q01a s05q01b if inlist(round,2,3,4),m
ta s05q01a s05q01b if inlist(round,5,6,9,10),m

g		item_access${i} = (s05q01a!=4) if item_need${i}==1 & inlist(round,2,3,4)
replace	item_access${i} = (s05q01a!=5) if item_need${i}==1 & inlist(round,5,6,9,10)

ta round s05q01b, nol
	forv n=1/5 {
	g	item_noaccess_cat`n'${i} = (s05q01b==`n') if item_access${i}==0
	}
	g	item_noaccess_cat6${i} = cond(round==2,s05q01b==7,s05q01b==6) if item_access${i}==0


tab2 round AlimBase?, first
mer 1:1 hhid round using "${tmp_hfps_bfa}/cover.dta", keepus(strate)
keep if inlist(_m,1,3)
drop _m
tab2 strate AlimBase?, first

tab1 AlimBase?

g		cond16 = 1		if AlimBase1=="Maïs en grain"
recode	cond16 (.=2)	if AlimBase2=="Maïs en grain"
recode	cond16 (.=3)	if AlimBase3=="Farine de maïs"	//	not currently making a distinction between these two for harmonization purposes 

g		cond4 = 1		if AlimBase1=="Riz importé"
recode	cond4 (.=2)		if AlimBase2=="Riz importé"
recode	cond4 (.=3)		if AlimBase3=="Riz local"	//	again not currently capturing this distinction for harmonization

g		cond18 = 1		if AlimBase1=="Mil"
recode	cond18 (.=2)	if AlimBase2=="Mil"
recode	cond18 (.=3)	if AlimBase3=="Mil"

g		cond19 = 1		if AlimBase1=="Sorgho"
recode	cond19 (.=2)	if AlimBase2=="Sorgho"
recode	cond19 (.=3)	if AlimBase3=="Sorgho"

tab2 round s05q02_?, first m
tab2 round s05q02a s05q02c s05q02e, first m	//	access
tab2 round s05q02b s05q02d s05q02f, first m	//	reason

	*	organize these components for simpler use in next step 
	forv j=1/3 {
		foreach z in need access reason {
			cap : drop `z'`j'
			}
		g need`j' = (s05q02_`j'==1) if !mi(s05q02_`j')
		
		loc a : word `j' of s05q02a s05q02c s05q02e
		replace need`j' = (inlist(`a',1,2)) if mi(need`j')
		g access`j' = (`a'==1) if need`j'==1
		
		loc r : word `j' of s05q02b s05q02d s05q02f
		g reason`j' = `j' if access`j'==0
	}

	*	use components to construct item specific variables for use in a reshape later
foreach i of numlist 16 4 18 19 {
	
	foreach z in need access reason {
	g item_`z'`i' = .
		forv j=1/3 {
		replace item_`z'`i' = `z'`j' if cond`i'==`j'	//	here is where we use the cond variable from above
		}
	}
	forv n=1/5 {
		g item_noaccess_cat`n'`i' = (item_reason`i'==`n') if item_access`i'==0	
	}
		g item_noaccess_cat6`i' = cond(round==2,item_reason`i'==7,item_reason`i'==6) if item_access`i'==0	

	ta item_need`i' item_access`i', m
	tabstat item_noaccess_cat?`i', by(item_access`i') s(n sum)
		}
		
*	health
	ta round s05q03a,m	//	mod 5 had add'l questions, but non-standard reference period. Leaving out. 
	
	g item_need11 = (s05q03a==1)
	ta round s05q03d,m	//	rounds 8 & 11 break down access by service 
	
	g item_access11 = (s05q03d==1) if item_need11==1 & !mi(s05q03d)
	
	ta round s05q03e,m
	la li s05q03e
	g item_noaccess_cat4111 = (s05q03e==1) if item_access11==0 & !mi(s05q03e)
	g item_noaccess_cat4211 = (s05q03e==2) if item_access11==0 & !mi(s05q03e)
	g item_noaccess_cat4311 = (s05q03e==3) if item_access11==0 & !mi(s05q03e)
	
	ta round s05q03d_1,m
	replace item_noaccess_cat4111 = (s05q03d_1==1) if item_access11==0 & !mi(s05q03d_1)
	replace item_noaccess_cat4211 = (s05q03d_1==2) if item_access11==0 & !mi(s05q03d_1)
	replace item_noaccess_cat4311 = (s05q03d_1==3) if item_access11==0 & !mi(s05q03d_1)
	g item_noaccess_cat4411 = (s05q03d_1==4) if item_access11==0 & !mi(s05q03d_1) & inlist(round,4,5,6,7,9,10)
	g item_noaccess_cat4511 = (s05q03d_1==5) if item_access11==0 & !mi(s05q03d_1) & inlist(round,4,5,6,7,9,10)
	g item_noaccess_cat4611 = (s05q03d_1==6) if item_access11==0 & !mi(s05q03d_1) & inlist(round,4,5,6,7,9,10)
	g item_noaccess_cat4711 = (s05q03d_1==7) if item_access11==0 & !mi(s05q03d_1) & inlist(round,4,5,6,7,9,10)
	
	
	*	rounds 8 & 11 break down health services
	d s05q03a_1__1 s05q03a_1__2 s05q03a_1__3 s05q03a_1__4 s05q03a_1__5 s05q03a_1__6 s05q03a_1__7 s05q03a_1__96
	tabstat s05q03a_1__1 s05q03a_1__2 s05q03a_1__3 s05q03a_1__4 s05q03a_1__5 s05q03a_1__6 s05q03a_1__7 s05q03a_1__96, by(round) s(n sum)
	d s05q03d_??
	tabstat s05q03d_??, by(round) s(n sum)
 
	forv i=1/7 {
	g item_need5`i' = (s05q03a_1__`i'==1) if !mi(s05q03a_1__1)
	g item_access5`i' = (s05q03d_`i'a==1) if item_need5`i'==1 & !mi(s05q03d_`i'a)
	forv j=1/7 {
		g item_noaccess_cat4`j'5`i' = (s05q03d_`i'b==`j') if item_access5`i'==0 
	}
	}
	
	keep hhid round item*
	drop item_reason*
	d item_need*, f
	
	#d ; 
	reshape long item_need item_access
		item_noaccess_cat1  item_noaccess_cat2  item_noaccess_cat3  
		item_noaccess_cat4  item_noaccess_cat5  item_noaccess_cat6  
	
		item_noaccess_cat41 item_noaccess_cat42 item_noaccess_cat43 
		item_noaccess_cat44 item_noaccess_cat45 item_noaccess_cat46 
		item_noaccess_cat47 
		, i(hhid round) j(item);
	#d cr 
	ta item round
	label_access_item
	label_item_ltfull noaccess
	
	tempfile phase1
	sa		`phase1'
}	/*	end rounds 2-11	*/
	

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
	u if sec5_exp==0 using "${raw_hfps_bfa}/r14_sec5f1_acces_service_sante.dta", clear; 
	ren s05q0?_cls* s05q0?*;
	tempfile r14	; 
	sa		`r14'	; 
clear; append using 
	"${raw_hfps_bfa}/r12_sec5f1_acces_service_sante.dta"	
	"${raw_hfps_bfa}/r13_sec5f1_acces_service_sante.dta"	
	`r14'	
	, gen(round); la drop _append; la val round .; 
#d cr 
isid hhid round
replace round=round+11

tabstat s05q04__?, by(round)
g item_need11 = (s05q03==1)
d s05q04__?
g item_need58=s05q04__1==1 if item_need11==1
g item_need51=s05q04__2==1 if item_need11==1
g item_need52=s05q04__3==1 if item_need11==1
g item_need53=s05q04__4==1 if item_need11==1
g item_need54=s05q04__5==1 if item_need11==1
g item_need55=s05q04__6==1 if item_need11==1
g item_need56=s05q04__7==1 if item_need11==1
g item_need57=s05q04__8==1 if item_need11==1

keep hhid round item*
reshape long item_need, i(hhid round) j(item)
tempfile need
sa		`need'


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
// mer m:1 hhid round item using `need'
//
// ta item_need s05q04,m
// ta item item_need if item!=11
// ta item s05q04
g item_need = (s05q04==1)
g item_access = (s05q05==1) if item_need==1

ta s05q06,m
li round s05q06_autre if s05q06==96, sep(0) clean noobs
forv i=1/9 {
g item_noaccess_cat4`i' = s05q06==`i' if item_access==0
}
g item_noaccess_cat21 = (s05q06==10 | inlist(s05q06_autre,"problème de sécurité","insécurité")) if item_access==0
g item_noaccess_cat50 = (s05q06==96 & !inlist(s05q06_autre,"problème de sécurité","insécurité")) if item_access==0


*	stretching a bit here
ta s05q10 round
g item_fullbuy = inlist(s05q10,1,2) if item_access==1

keep hhid round item*
ta round item
table round item, stat(sum item_need)
mer 1:1 hhid round item using `need'
table round item, stat(sum item_need)
drop _merge
la drop _merge

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
/*	verify data structure	*/
u hhid membres__id sec5_exp_r3 using "${raw_hfps_bfa}/r14_sec5g1_acces_service_sante.dta", clear; 
tempfile exp; sa `exp'; 
u	"${raw_hfps_bfa}/r14_sec5g2_acces_service_sante.dta", clear; 
mer m:1 hhid membres__id using `exp'; assert _m==2 if sec5==0; 

*	need to construct need here actually, else it will not be represented
#d ; 
clear; append using
	"${raw_hfps_bfa}/r14_sec5g1_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r16_sec5g1_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r17_sec5g1_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r18_sec5f1_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r20_sec5f1_acces_service_sante.dta"		
	"${raw_hfps_bfa}/r22_sec5f1_acces_service_sante.dta"		
	, gen(round); la drop _append; la val round .; 
#d cr
drop if sec5_exp_r3==0
replace round=round+13
replace round=round+1 if round>14
replace round=round+1 if round>18
replace round=round+1 if round>20

tabstat s05q03 s05q04__?, by(round)
g item_need11 = (s05q03==1)
d s05q04__?
g item_need58=s05q04__1==1 if item_need11==1
g item_need51=s05q04__2==1 if item_need11==1
g item_need52=s05q04__3==1 if item_need11==1
g item_need53=s05q04__4==1 if item_need11==1
g item_need54=s05q04__5==1 if item_need11==1
g item_need55=s05q04__6==1 if item_need11==1
g item_need56=s05q04__7==1 if item_need11==1
g item_need57=s05q04__8==1 if item_need11==1

keep hhid membres__id round item*
reshape long item_need, i(hhid membres__id round) j(item)
preserve
keep if item==11
isid hhid membres__id round
collapse (max) item_need, by(hhid round item)
tempfile need11
sa		`need11'
restore
preserve
keep if item!=11
drop if mi(item_need)
tempfile need
sa		`need'
restore



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
mer 1:1 hhid membres__id round item using `need'

ta s05q05 item_need,m
g item_access = (s05q05==1) if item_need==1

ta s05q06,m
sort round hhid membres__id
li round s05q06_autre if s05q06==96, sep(0) clean noobs
li round s05q06_autre if s05q06==96, sep(0) clean noobs string(100)
li round s05q06_autre if s05q06==96 & length(s05q06_autre)<100, sep(0) clean noobs
li round s05q06_autre if s05q06==96 & length(s05q06_autre)>=100, sep(0) clean noobs	//->	visiting health worker

forv i=1/9 {
g item_noaccess_cat4`i' = s05q06==`i' if item_access==0
}
g item_noaccess_cat21 = (s05q06==10 | strpos(s05q06_autre,"sécurité")>0)  if item_access==0
g item_noaccess_cat50 = (s05q06==96 & strpos(s05q06_autre,"sécurité")==0) if item_access==0


*	again a stretch, but less so
ta round s05q14	//	this was only enabled for the primary respondent... 
ta item_access s05q14,m
g item_fullbuy = (s05q14==1) if item_access==1
	

*	now we must go to household x item level
#d ; 
collapse	
	(max) item_need (min) item_access (max) item_noaccess_cat* 
	(min) item_fullbuy
	, by(hhid round item); 
#d cr 
tempfile full 
sa		`full'

*	take this down to household level to construct item 11 
#d ; 
collapse 
	(max) zzz=item_need (min) item_access (max) item_noaccess_cat* 
	(min) item_fullbuy
	, by(hhid round); 
	
mer 1:1 hhid round using `need11';
#d cr 
	ta item_need _m,m
	drop _m
	la drop _merge
	ta item_need zzz,m
	drop item_need	//	we will use the version where the respondent has filled the subsequent questions as well for consistency in the resulting descriptives
	ren zzz item_need
	ta item item_need
	
append using `full'
isid hhid round item
tempfile experimental
sa		`experimental'
}
	
	
clear
append using `classic' `experimental'	
isid hhid round item
label_access_item
label_item_ltfull noaccess
table round item, stat(sum item_need)

tempfile health_phase2
sa		`health_phase2'
}	/*	end health phase 2	*/
		
********************************************************************************	
********************************************************************************	

{	/*	basic phase 2	*/ 
d using	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r19_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r20_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r21_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r22_sec5_acces_aliments_biens_essentiels.dta"		
d using	"${raw_hfps_bfa}/r23_sec5_acces_aliments_biens_essentiels.dta"		

{	/*check for stability across time */
foreach r of numlist 18/23 {
	u "${raw_hfps_bfa}/r`r'_sec5_acces_aliments_biens_essentiels.dta", clear
	d, replace clear
	tempfile r`r'
	sa		`r`r''
}
u `r18', clear
foreach r of numlist 18/23 {
	mer 1:1 name vallab varlab using `r`r'', gen(_`r')
	recode _`r'(1 .=.)(2 3=`r')
}
egen rounds = group(_??), label missing
li name vallab varlab rounds, sep(0) clean


foreach r of numlist 18/23 {
	u "${raw_hfps_bfa}/r`r'_sec5_acces_aliments_biens_essentiels.dta", clear
	la dir
	uselabel `r(labels)', clear
	tempfile r`r'
	sa		`r`r''
}
u `r18', clear
foreach r of numlist 18/23 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r'(1 .=.)(2 3=`r')
}
egen rounds = group(_??), label missing
li lname value label rounds, sepby(lname)
	
}	/*	these modules are identical across rounds for all intents and purposes	*/


#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"		
	"${raw_hfps_bfa}/r19_sec5_acces_aliments_biens_essentiels.dta"		
	"${raw_hfps_bfa}/r20_sec5_acces_aliments_biens_essentiels.dta"		
	"${raw_hfps_bfa}/r21_sec5_acces_aliments_biens_essentiels.dta"		
	"${raw_hfps_bfa}/r22_sec5_acces_aliments_biens_essentiels.dta"		
	"${raw_hfps_bfa}/r23_sec5_acces_aliments_biens_essentiels.dta"		
	, gen(round); la drop _append; la val round .; replace round=round+17; 
#d cr
isid hhid round

		*	we will make this set of stubs across all items present here 
		#d ; 
		gl zzz need access
		    noaccess_cat1 noaccess_cat5 noaccess_cat3 noaccess_cat21 noaccess_cat6
			fullbuy
			ltfull_cat1 ltfull_cat5 ltfull_cat3 ltfull_cat6
			; 
		#d cr 

		
	*	food item set is presented with a strata as in rounds 2-11 above
tab1 AlimBase?

g		cond16 = 1		if AlimBase1=="Maïs en grain"
recode	cond16 (.=2)	if AlimBase2=="Maïs en grain"
recode	cond16 (.=3)	if AlimBase3=="Farine de maïs"	//	not currently making a distinction between these two for harmonization purposes 

g		cond4 = 1		if AlimBase1=="Riz importé"
recode	cond4 (.=2)		if AlimBase2=="Riz importé"
recode	cond4 (.=3)		if AlimBase3=="Riz local"	//	again not currently capturing this distinction for harmonization

g		cond18 = 1		if AlimBase1=="Mil"
recode	cond18 (.=2)	if AlimBase2=="Mil"
recode	cond18 (.=3)	if AlimBase3=="Mil"

g		cond19 = 1		if AlimBase1=="Sorgho"
recode	cond19 (.=2)	if AlimBase2=="Sorgho"
recode	cond19 (.=3)	if AlimBase3=="Sorgho"



	*	organize these components for simpler use in next step 
	forv i=1/3 {
		loc j : word `i' of a b c 	
	
		#d ; 
			foreach z of global zzz {; cap : drop `z'`j'; }; 
		#d cr 
		
		g need`j' = (s05q02`j'==1) //	if !mi(s05q02`j')
		g access`j' = (s05q02`j'1==1) if need`j'==1
		g noaccess_cat1`j' = (s05q02`j'2__1==1 | s05q02`j'2__3==1 | s05q02`j'2__5==1) if access`j'==0
		g noaccess_cat5`j' = (s05q02`j'2__2==1) if access`j'==0
		g noaccess_cat3`j' = (s05q02`j'2__4==1) if access`j'==0
		g noaccess_cat21`j'= (s05q02`j'2__6==1) if access`j'==0
		g noaccess_cat6`j' = (s05q02`j'2__7==1) if access`j'==0
		g fullbuy`j' = (s05q02`j'3==1) if access`j'==1
		g ltfull_cat1`j' = (s05q02`j'4__1==1 | s05q02`j'2__3==1 | s05q02`j'2__5==1) if fullbuy`j'==0
		g ltfull_cat5`j' = (s05q02`j'4__2==1) if fullbuy`j'==0
		g ltfull_cat3`j' = (s05q02`j'4__4==1) if fullbuy`j'==0
		g ltfull_cat6`j' = (s05q02`j'4__7==1) if fullbuy`j'==0
	}

	*	use components to construct item specific variables for use in a reshape later
foreach c of numlist 16 4 18 19 {
	foreach z of global zzz	{
			cap : drop item_`z'`c'
			g item_`z'`c' = .
			forv i=1/3 {
				loc j : word `i' of a b c
			
			replace item_`z'`c' = `z'`j' if cond`c'==`i'	//	here is where we use the cond variable from above
				}
			}

	ta item_need`c' item_access`c', m
	tabstat item_noaccess_cat*`c', by(item_access`c') s(n sum)
	ta item_access`c' item_fullbuy`c',m
	tabstat item_ltfull_cat*`c', by(item_fullbuy`c') s(n sum)
		}
			
			
			
*	remainder follows a consistent pattern across goods, so we can simply loop it
loc items 1 2 21 40
loc codes d e f  g

foreach a of numlist 1/`: word count `items'' {
	loc i : word `a' of `items'
	loc c : word `a' of `codes'

		#d ; 
		foreach z of global zzz {; cap : drop item_`z'`i'; cap : drop `z'`i'; }; 
		#d cr 
	
		g need`i' = (s05q02`c'==1) //	if !mi(s05q02`j')
		g access`i' = (s05q02`c'1==1) if need`i'==1
		g noaccess_cat1`i' = (s05q02`c'2__1==1 | s05q02`c'2__3==1 | s05q02`c'2__5==1) if access`i'==0
		g noaccess_cat5`i' = (s05q02`c'2__2==1) if access`i'==0
		g noaccess_cat3`i' = (s05q02`c'2__4==1) if access`i'==0
		g noaccess_cat21`i'= (s05q02`c'2__6==1) if access`i'==0
		g noaccess_cat6`i' = (s05q02`c'2__7==1) if access`i'==0
		g fullbuy`i' = (s05q02`c'3==1) if access`i'==1
		g ltfull_cat1`i' = (s05q02`c'4__1==1 | s05q02`c'2__3==1 | s05q02`c'2__5==1) if fullbuy`i'==0
		g ltfull_cat5`i' = (s05q02`c'4__2==1) if fullbuy`i'==0
		g ltfull_cat3`i' = (s05q02`c'4__4==1) if fullbuy`i'==0
		g ltfull_cat6`i' = (s05q02`c'4__7==1) if fullbuy`i'==0
		foreach z of global zzz {
			ren (`z'`i')(item_`z'`i')
		}
}

keep hhid round item*
*	use a simplification here to rely on the zzz global to populate this reshape
ren item_* *
reshape long ${zzz}, i(hhid round) j(item) 
foreach z of global	zzz {
	ren (`z'*)(item_`z'*)
}


isid hhid round item
label_access_item
label_item_ltfull noaccess
label_item_ltfull ltfull
table item round, stat(sum item_need)

tempfile basic_phase2
sa		`basic_phase2'
}	

********************************************************************************	
********************************************************************************	

{	/*	price modules phase 2	*/		
{	/*	r18+ version	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r19_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r20_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r21_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r22_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r23_sec5c_prix_carburant.dta"
	, gen(round); la drop _append; la val round .;
#d cr
replace round=round+17

la li da
g item=carburant__id + 81
label_access_item
ta carburant__id item 
drop carburant__id

ta s05cq02
g item_access = (s05cq02==1) if inlist(s05cq02,1,2,3)	//	this is actual purchase here, not truly availability

// g q=s05cq04
// g kg=q
// g lcu = s05cq05
// g price =  s05cq05/s05cq04
// la var	price		"Price (LCU/standard unit)"
// g unitcost = price	//	in this case we will construct them as identical, though the LCU for total could also be of interest in the price variable
// la var	unitcost	"Unit Cost (LCU/unit)"
//
// g unit=302
// g unitstr="Litre"
// la var unitstr		"Unit"
//
// keep  hhid round item item_avail q unitstr kg lcu price unitcost 
// order hhid round item item_avail q unitstr kg lcu price unitcost
keep  hhid round item*
isid  hhid round item
sort  hhid round item
tempfile fuel
sa		`fuel'



/*

dir "${hfps}/Input datasets/Burkina Faso"
d using "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta"
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li _all

u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
duplicates report
duplicates report	region milieu codpr uniteID tailleID
duplicates report	strate codpr uniteID tailleID
duplicates tag		strate codpr uniteID tailleID, gen(tag)
sort codpr uniteID tailleID region milieu 
li if tag>0, sepby(region milieu)	//	has two different results wit no label for why they are idfferent
ta codpr if tag>0
ta region milieu
la li s00q01 s00q04
recode region ( 9= 1)( 1= 2)(12= 3)( 8= 4)(13= 5)( 5= 6)( 6= 7)(11= 8)(10= 9)( 3=11)( 2=12)( 7=13)
collapse (p50) cf=poids_median, by(region milieu codpr uniteID tailleID)
replace cf=cf/1000	//	convert gm to kg 
tempfile cf
sa		`cf'

u "${tmp_hfps_bfa}/cover.dta", clear
ta strate milieu
ta region milieu
la li regione labmilieu
*/
	


#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r19_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r20_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r21_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r22_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r23_sec5p_prix_denrees_alimentaires.dta"
	, gen(round); la drop _append; la val round .; 
#d cr 
replace round=round+17
isid hhid round denrees_alimentaires__id
la li da
#d ; 
recode denrees_alimentaires__id
	(10=16)		/*	maize grain	*/ 
	(11=4)		/*	imported rice	*/ 
	(12=6)		/*	cassava	*/
	(13=20)		/*	irish potato	*/
	(14=7)		/*	sweet potato	*/ 
	(15=16)		/*	maize flour	*/
	(16=6)		/*	cassava flour	*/
	(17=8)		/*	sorghum flour	*/
	(18=69)		/*	wheat flour	*/
	(19=83)		/*	dry bean	*/
	(20=84)		/*	fresh beans	*/
	(21=67)		/*	crushed peanuts	*/
	(22=63)		/*	beef	*/
	(23=82)		/*	fresh milk	*/
	(24=22)		/*	eggs	*/
	(25=81)		/*	bread	*/
	(26=14)		/*	onions	*/
	(27=85)		/*	tomato	*/
	(28=87)		/*	sugar	*/
	(29=68)		/*	cooking oil=palm oil here for simplicity	*/
	(30=88)		/*	tea	*/
	(31=89)		/*	salt	*/
	(32=40)		/*	fertilizer	*/
	(33=45)		/*	maize seed	*/
	(34=46)		/*	soy seed	*/
	(35=47)		/*	bean seed	*/
, gen(item); 
	#d cr
	
label_access_item
ta denrees_alimentaires__id item 
la var item	"Item code"

g item_avail = (s05pq01==1)

collapse (max) item_avail, by(hhid round item)
la var	item_avail	"Item is available for sale"

isid  hhid round item
sort  hhid round item

append using `fuel'
isid hhid item round


isid  hhid round item
sort  hhid round item
tempfile r18 
sa		`r18'
}	/*	end r18+ version	*/


{	/*	r15/16 version	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"
	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"
	, gen(round); replace round=round+14; la val round .; la drop _append; 
recode produit__id (100/199=1)(200/299=2)(300/399=3), gen(urb); 
recode produit__id 
	(101 202 304=4)	/*	imported rice	*/ 
	(203=4)			/*	local rice	*/ 
	(102 201 301=16)	/*	maize grain	*/ 
	(103 205=16)	/*	maize flour	*/
	(104 204 305=81)	/*	modern bread	*/
	(105 303=18)	/*	millet	*/
	(302=19)	/*	Sorghum	*/
	(106 206 306=85)	/*	fresh tomato	*/
	(107 207 307=85)	/*	tomato concentrate	*/
	(108 208 308=83)	/*	cowpea / dried bean	*/
	(109 209 309=87)	/*	sugar	*/
	(110 210 310=22)	/*	eggs	*/
	(111 211 311=63)	/*	beef	*/
	(112 212 312=63)	/*	mutton	*/
	(113 213 313=61)	/*	horse mackerel (modal type in 2018)	*/
	(114 214 314=61)	/*	dried fish	*/
	(115 215 315=68)	/*	palm oil	*/
	
	(116 216 316=21)	/*	fuel for car	*/
	(117 217 317=21)	/*	fuel for motorcycle	*/
	(318=40)	/*	chemical fertilizer	*/
	, gen(item);
	#d cr
	
label_access_item
ta produit__id item 
la var urb	"Spatial domain for prices"
la var item	"Item code"

ta sec9e round,m
drop if sec9e!=1
isid hhid round produit__id

g item_avail = (s09eq01==1)
collapse (max) item_avail, by(hhid round item)
la var	item_avail	"Item is available for sale"

keep  hhid round item* 
order hhid round item*
isid  hhid round item
sort  hhid round item
tempfile r15_16
sa		`r15_16'
}	/*	end r15/16 version	*/

u `r15_16', clear
append using `r18'	/*	bring in the round 18 things	*/ 
isid  hhid round item
sort  hhid round item
tempfile price_modules_phase2
sa		`price_modules_phase2'
}

********************************************************************************	
********************************************************************************	

u `basic_phase2', clear
mer 1:1 hhid round item using `health_phase2', assert(1 2) nogen
mer 1:1 hhid round item using `price_modules_phase2'
ta item _m	//	this presents some interesting possibilities
ta item_avail item_access	//	how would we reconcile these, 
table item round if _m==3, stat(sum item_avail item_need item_access)
drop _merge	//	must clean this up for the final construction however 
la drop _merge


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
	label_item_ltfull noaccess
	label_item_ltfull ltfull
	
la var	item_need		"Household wanted or needed to buy [item] in past 7 days"
la var	item_access		"Able to buy any [item] in past 7 days"
la var	item_fullbuy	"Able to buy desired amount of [item] in past 7 days"

isid hhid round item
sort hhid round item
sa "${tmp_hfps_bfa}//access.dta", replace 
u  "${tmp_hfps_bfa}/access.dta", clear 
d, s
ta item round
table item round, stat(freq)
table item round, stat(sum item_need)
cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex
