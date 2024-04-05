


********************************************************************************
********************************************************************************

***********************   *******   ********     **      ***********************
***********************   ********  ********    ****     ***********************
***********************   **    **  **         **  **    ***********************
***********************   **    **  **        **    **   ***********************
***********************   *******   *****     ********   ***********************
***********************   *******   *****     ********   ***********************
***********************   **    **  **        **    **   ***********************
***********************   **    **  **        **    **   ***********************
***********************   ********  **        **    **   ***********************
***********************   *******   **        **    **   ***********************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************


*	two separate directories for phase 1 & 2
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/r*_sec0_*.dta", w
dir "${raw_hfps_bfa}/r*_sec1a_*.dta", w

d using	"${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta"		
d using	"${raw_hfps_bfa}/r1_sec1b_info_entretien_numero.dta"		
u "${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta", clear
cou if s01aq03=="Oui":s01aq03
la li s01aq08
cou if s01aq08==1
duplicates report hhid if s01aq08==1	
ret li	//	there is the 1968 we expect

keep if s01aq08==1
duplicates tag hhid, gen(tag)	
ta tag
li if tag==2, sepby(hhid)
bys hhid (tentatives__id) : keep if _n==_N
cou
keep hhid s01aq02

d using	"${raw_hfps_bfa}/r1_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r2_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r3_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r4_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r5_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r6_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r7_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r8_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r9_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r10_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r11_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r12_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r13_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r14_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r15_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r16_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r17_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r18_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r19_sec0_cover.dta"	



u "${raw_hfps_bfa}/r1_sec0_cover.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
tempfile base
sa      `base'
foreach r of numlist 2(1)19 {
	u "${raw_hfps_bfa}/r`r'_sec0_cover.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10

levelsof name if matches>=10, clean
li name var1 var2 var3 if matches>=10, sep(0)






*	household level detail from actual completed interview (incl. weights)

#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r2_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r3_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r4_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r5_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r6_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r7_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r8_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r9_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r10_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r11_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r12_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r13_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r14_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r15_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r16_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r17_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r18_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r18_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r19_sec1a_info_entretien_tentative.dta"	

, gen(round);
#d cr
bys hhid round (tentatives__id) : keep if _n==_N
keep hhid round s01aq02
tempfile time
sa		`time'
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r2_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r3_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r4_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r5_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r6_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r7_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r8_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r9_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r10_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r11_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r12_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r13_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r14_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r15_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r16_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r17_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r18_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r19_sec12_bilan_entretien.dta"	

, gen(round);
#d cr
isid hhid round
keep hhid round s12q05 s12q09 s12q14
tempfile respondent
sa		`respondent'
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec0_cover.dta"		
	"${raw_hfps_bfa}/r2_sec0_cover.dta"		
	"${raw_hfps_bfa}/r3_sec0_cover.dta"		
	"${raw_hfps_bfa}/r4_sec0_cover.dta"		
	"${raw_hfps_bfa}/r5_sec0_cover.dta"		
	"${raw_hfps_bfa}/r6_sec0_cover.dta"		
	"${raw_hfps_bfa}/r7_sec0_cover.dta"		
	"${raw_hfps_bfa}/r8_sec0_cover.dta"		
	"${raw_hfps_bfa}/r9_sec0_cover.dta"		
	"${raw_hfps_bfa}/r10_sec0_cover.dta"	
	"${raw_hfps_bfa}/r11_sec0_cover.dta"	
	"${raw_hfps_bfa}/r12_sec0_cover.dta"	
	"${raw_hfps_bfa}/r13_sec0_cover.dta"	
	"${raw_hfps_bfa}/r14_sec0_cover.dta"	
	"${raw_hfps_bfa}/r15_sec0_cover.dta"	
	"${raw_hfps_bfa}/r16_sec0_cover.dta"	
	"${raw_hfps_bfa}/r17_sec0_cover.dta"	
	"${raw_hfps_bfa}/r18_sec0_cover.dta"	
	"${raw_hfps_bfa}/r19_sec0_cover.dta"	

, gen(round);
#d cr
	mer 1:1 hhid round using `time',
	ta round _m,m
	ta _m resultat, m
	cou if !mi(s01aq02) & _m==3 & mi(resultat)	//	round 1 
	keep if _m==3
	drop _m resultat
	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	la var round	"Survey round"
	la var phase	"Survey phase"
	isid hhid round
	sort hhid round
	
	mer 1:1 hhid round using `respondent'
	ta s12q05 _m,m	//	imperfect now
	ta s12q05 round if _m==3
	keep if s12q05==1
	drop _merge
	

	d hhw*cs, f
	d hhw*pnl, f
	tabstat hhw*pnl, by(round) s(sum) format(%12.3gc)
	tabstat hhw*cs, by(round) s(sum) format(%12.3gc)
	egen wgt = rowfirst(hhwcovid_r1 hhwcovid_r2_s1 hhw*cs)
	tabstat hhw*pnl, by(round) s(n) format(%12.3gc)
	egen wgt_panel = rowfirst(hhwcovid_r1 hhwcovid_r2_s1s2 hhw*pnl)
	drop hhwcovid_r1 hhwcovid_r2_s1 hhw*cs hhwcovid_r2_s1s2 hhw*pnl

	la var wgt			"Cross section weight"
	la var wgt_panel	"Panel sampling weight"

	tab1 round strate milieu region province commune echantillon, m 


*	dates 
li s01aq02 in 1/10
convert_date_time s01aq02
g pnl_intclock=s01aq02
	format pnl_intclock %tc
	drop s01aq02
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
		

g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal	//	a few oddities in round 18 

	isid hhid round
	sort hhid round

sa "${local_storage}/tmp_BFA_cover.dta", replace 


*	modifications for construction of grand panel 
u "${local_storage}/tmp_BFA_cover.dta", clear


egen pnl_hhid = group(hhid)
li strate milieu region grappe province commune echantillon in 1/10
li strate milieu region grappe province commune echantillon in 1/10, nol

egen pnl_admin1 = group(region)
egen pnl_admin2 = group(region province)
egen pnl_admin3 = group(region province commune)

ta strate, m
la li strate
egen pnl_urban = anymatch(strate), v(1 2)
g pnl_wgt = wgt 
sa "${local_storage}/tmp_BFA_pnl_cover.dta", replace 

********************************************************************************
}	/*	end cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/r*_sec2_*.dta", w
dir "${raw_hfps_bfa}/r*_sec12_*.dta", w

d using	"${raw_hfps_bfa}/r1_sec12_bilan_entretien.dta"		
d using	"${raw_hfps_bfa}/r1_sec1b_info_entretien_numero.dta"		
u "${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta", clear
cou if s01aq03=="Oui":s01aq03
la li s01aq08
cou if s01aq08==1
duplicates report hhid if s01aq08==1	
ret li	//	there is the 1968 we expect

keep if s01aq08==1
duplicates tag hhid, gen(tag)	
ta tag
li if tag==2, sepby(hhid)
bys hhid (tentatives__id) : keep if _n==_N
cou
keep hhid s01aq02

d using	"${raw_hfps_bfa}/r1_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r2_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r3_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r4_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r5_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r6_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r7_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r8_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r9_sec2_liste_membre_menage.dta"		
d using	"${raw_hfps_bfa}/r10_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r11_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r12_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r13_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r14_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r15_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r16_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r17_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r18_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r19_sec2_liste_membre_menage.dta"	

u	"${raw_hfps_bfa}/r1_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r2_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r3_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r4_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r5_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r6_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r7_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r8_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r9_sec2_liste_membre_menage.dta"	, clear	
la li s02q07	
u	"${raw_hfps_bfa}/r10_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r11_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r12_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r13_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r14_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r15_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r16_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r17_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r18_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r19_sec2_liste_membre_menage.dta"	, clear
la li s02q07	



u "${raw_hfps_bfa}/r1_sec2_liste_membre_menage.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
tempfile base
sa      `base'
foreach r of numlist 2(1)19 {
	u "${raw_hfps_bfa}/r`r'_sec2_liste_membre_menage.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var2 if matches>=10, sep(0)






*	household level detail from actual completed interview (incl. weights)

#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r2_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r3_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r4_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r5_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r6_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r7_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r8_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r9_sec2_liste_membre_menage.dta"		
	"${raw_hfps_bfa}/r10_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r11_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r12_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r13_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r14_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r15_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r16_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r17_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r18_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r19_sec2_liste_membre_menage.dta"	

, gen(round) force;
#d cr
	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	la var round	"Survey round"
	la var phase	"Survey phase"
	isid hhid membres__id round
	sort hhid membres__id round

		ta s02q02 s02q03,m
		la li nonoui ouinon
	     gen member=(s02q02==1|s02q03==1)
		la li homfem
		 gen sex=s02q05
		 gen age=s02q06
		ta age member, m
		 recode age (-98=.)
		la li s02q07
	     gen head=(s02q07==1)
	     gen relation=s02q07 
		 ta s02q07
		ta s02q09b s02q09a, m
		 replace relation = s02q09b if s02q09a==2 & !mi(s02q09b)
		 
		 replace relation=. if member!=1
		 replace head=0 if member!=1
		 ta s02q07 if !mi(s02q07_autre)
		 gen relation_os=s02q07_autre
		#d ; 
		la def relation
			 1	"Head"
			 2	"Spouse"
			 3	"Child"
			 4	"Parent"
			 5	"Grandchild"
			 6	"Grandparent"
			 7	"Sibling"
			 8	"Other relative"
			 9	"Other non-relative"
			10	"Servant or relative of servant"
			;
		#d cr 
		la val relation relation
		 
		*	respondent
	  d using "${local_storage}/tmp_BFA_cover.dta"
		g s12q09=membres__id
		mer 1:1 hhid s12q09 round using "${local_storage}/tmp_BFA_cover.dta"
		 ta hhid round if _m==2,m
		 ta s12q09 if _m==2,m
		 keep if inlist(_m,1,3)
		 g respond = (_m==3)
		 
		 bys hhid round (membres__id) : egen testresp = sum(respond)
		ta testresp round,m	//	rounds 3, 4, & 16 have the issues
		ta respond member,m
		
		bys hhid membres__id (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (membres__id) : egen testresp2 = sum(respond)
		ta testresp2 round,m	//	rounds 3, 4, & 16 have the issues
		ta respond member,m
		li hhid round membres__id member respond if testresp2==0, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round membres__id ind_id_EHCVM member respond age sex testresp2 if flagresp==0, sepby(hhid)
		li hhid round membres__id ind_id_EHCVM member respond if flagresp==0 & (respond==1 | testresp2==0), sepby(hhid)
		*	use respondent from subsequent rounds 
		recode respond (0=1) if hhid==564074 & round==4 & membres__id==406	//	respondent in next rounds
		recode respond (0=1) if hhid==326075 & inlist(round,3,4) & membres__id==105	//respondent in prior rounds appears to ahve a code switch. In these two rounds, thehh only contains two members, and one is age 9, so stick with 43 year old 
		recode respond (0=1) if hhid==169078 & inlist(round,3,4)  & membres__id==5	//	only member in round 3, and no member in round 4 is obvious as a replacement
		bys hhid round (membres__id) : egen testresp3 = sum(respond)
		assert testresp3==1

		*	fill in with prior round information where possible
		foreach x in age sex relation {
			tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
		bys hhid membres__id (round) : egen `maxmiss'= max(mi(`x'))
		by  hhid membres__id (round) : egen `maxnmiss'= max(`x')
		by  hhid membres__id (round) : egen `minnmiss'= min(`x')
		by  hhid membres__id (round), rc0 : egen `modenmiss'= mode(`x')
		
		g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
		replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
		su `x' if `maxmiss'==1
		replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
		su `x' if `maxmiss'==1
		
		drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
			}

		
		*	drop unnecessary variables
		keep phase-ind_id_EHCVM member-relation_os respond
		
		isid hhid membres__id round
		sort hhid membres__id round
		sa "${local_storage}/tmp_BFA_ind.dta", replace 
		 
		 

*	use individual panel to make demographics 
u "${local_storage}/tmp_BFA_ind.dta", clear

*	respondent characteristics
foreach x in sex age head relation {
	bys hhid round (membres__id) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys hhid round (membres__id) : egen headtest = sum(head) 
bys hhid round (membres__id) : egen resptest = sum(respond) 
bys hhid round (membres__id) : egen memtest = sum(member) 
tab1 *test,m


ta round member,m
keep if member==1
su 

g hhsize=1
*	assume all missing ages are labor age 
g m0_14 	= (sex==1 & inrange(age,0,14))
g m15_64	= (sex==1 & (inrange(age,15,64) | mi(age)))
g m65		= (sex==1 & (age>64 & !mi(age)))
g f0_14 	= (sex==2 & inrange(age,0,14))
g f15_64	= (sex==2 & (inrange(age,15,64) | mi(age)))
g f65		= (sex==2 & (age>64 & !mi(age)))

		    g		adulteq=. 
            replace adulteq = 0.27 if (sex==1 & age==0) 
            replace adulteq = 0.45 if (sex==1 & inrange(age,1,3)) 
            replace adulteq = 0.61 if (sex==1 & inrange(age,4,6)) 
            replace adulteq = 0.73 if (sex==1 & inrange(age,7,9)) 
            replace adulteq = 0.86 if (sex==1 & inrange(age,10,12)) 
            replace adulteq = 0.96 if (sex==1 & inrange(age,13,15)) 
            replace adulteq = 1.02 if (sex==1 & inrange(age,16,19)) 
            replace adulteq = 1.00 if (sex==1 & age >=20) 	//	assumes all missing ages are adults 
            replace adulteq = 0.27 if (sex==2 & age ==0) 
            replace adulteq = 0.45 if (sex==2 & inrange(age,1,3)) 
            replace adulteq = 0.61 if (sex==2 & inrange(age,4,6)) 
            replace adulteq = 0.73 if (sex==2 & inrange(age,7,9)) 
            replace adulteq = 0.78 if (sex==2 & inrange(age,10,12)) 
            replace adulteq = 0.83 if (sex==2 & inrange(age,13,15)) 
            replace adulteq = 0.77 if (sex==2 & inrange(age,16,19)) 
            replace adulteq = 0.73 if (sex==2 & age >=20)   
			su adulteq
			

	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(hhid round)	

sa "${local_storage}/tmp_BFA_demog.dta", replace
 

********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment 	*/ 
********************************************************************************



dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*_sec6a*.dta", w	//we need section 6, but it splits in sections after the first  
dir "${raw_hfps_bfa}/r*_sec6c*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d using	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"	
// d using	"${raw_hfps_bfa}/r14_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"	
// d using	"${raw_hfps_bfa}/r16_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"	

*	NFE modules
d using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		


*	employment sector codes 
u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear
uselabel s06q04a, clear
tempfile r1
sa		`r1' 
u	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r2
sa		`r2' 
u	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r3
sa		`r3' 
u	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r4
sa		`r4' 
u	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r5
sa		`r5' 
u	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r6
sa		`r6' 
u	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r7
sa		`r7' 
u	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r8
sa		`r8' 
u	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r9
sa		`r9' 
u	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r10
sa		`r10' 
u	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r11
sa		`r11' 
u	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r12
sa		`r12' 
u	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r13
sa		`r13' 
u	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r15
sa		`r15' 
u	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r17
sa		`r17' 
// u	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		, clear
// uselabel s06q04a, clear	//	not labeled in this dataset
// tempfile r18
// sa		`r18' 
// u	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"		, clear
// uselabel s06q04a, clear	//	not labeled in this dataset
// tempfile r19
// sa		`r19' 

u `r1', clear
foreach i of numlist 2/13 15 17 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
u	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		, clear
la li s06q04a	//	this contains all codes 
/*
	1 Agriculture											
	2 Extraction minière									
	3 Branche manufacturière								
	4 Activités techniques et scientifiques					
	5 Electricité/eau/gaz/déchets							
	6 Construction											
	7 Transports											
	8 Commerce												
	9 Banques, assurances, immobilier						
	10 Services personnels									
	11 Education											
	12 Sante												
	13 Administration publique								
	14 Tourisme												
	15 Autre, spécifier										
	16 Fabrication/transformation de produits alimentaires	

 1 Agriculture
 2 Mining
 3 Manufacturing branch
 4 Technical and scientific activities
 5 Electricity/water/gas/waste
 6 Building
 7 Transportation
 8 Trade
 9 Banks, insurance, real estate
10 Personal services
11 Education
12 Health
13 Public administration
14 Tourism
15 Other, specify
16 Manufacturing/processing of food products
*/


*	nfe sector codes 
u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear
uselabel s06q11, clear
tempfile r1
sa		`r1' 
u	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r2
sa		`r2' 
u	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r3
sa		`r3' 
u	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r4
sa		`r4' 
u	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r6
sa		`r6' 
u	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r8
sa		`r8' 
u	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r9
sa		`r9' 
u	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear
tempfile r12
sa		`r12' 
u	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12a, clear
tempfile r17
sa		`r17' 
u	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear	//	not labeled in this dataset
tempfile r19
sa		`r19' 

u `r1', clear
foreach i of numlist 2/4 6 8 9 12 17 19 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
u	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		, clear
la li s06q11	//	this contains all codes 
u	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		, clear
la li s06q11	//	this r12_sec6c_emplrev_nonagr all codes 
u	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		, clear
la li s06q12	//	this is re-used in r19 
u	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		, clear
la li s06q12a
/*
 1 Agriculture, chasse, pêche
 2 Exploitation miniére, fabrication
 3 Électricité, gaz, alimentation en eau
 4 Construction
 5 Achat et vente de biens, réparation de biens, hôtels et restaurants
 6 Trasport, conduite, poste, voyage agence
 7 Activités professionnelles, finance, juridique, analyse, ordinateur, immobilier
 8 Administration publique
 9 Services personnels, éducation, santé culture, sport, travail domestique, autres


 1 Agriculture
 2 Mining
 3 Manufacturing branch
 4 Technical and scientific activities
 5 Electricity/water/gas/waste
 6 Building
 7 Transportation
 8 Trade
 9 Banks, insurance, real estate
10 Personal services
11 Education
12 Health
13 Public administration
14 Tourism
15 Other, specify
16 Manufacturing/processing of food products
*/



u "${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
tempfile base
sa      `base'
foreach r of numlist 2/13 15 17/19 {
	u "${raw_hfps_bfa}/r`r'_sec6a_emplrev_general.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var2 if matches>=10, sep(0)

*	wage employment
#d ; 
clear; append using

	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		
	
	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"		
	
	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"		


, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round+1 if round>13
replace round=round+1 if round>15
	ta round
	isid hhid round
	
	
tab2 round s06q01 s06q01a, first
tab2 round s06q04b s06q04b1, first
la li s06q04b s06q04b1
ta s06q04b s06q01, m
	
g work_cur = (s06q01==1) if inlist(s06q01,1,2)
replace work_cur = (s06q01a==1) if inlist(s06q01a,1,2) & round>11
g nwork_cur=1-work_cur
g wage_cur = (work_cur==1 & (inlist(s06q04b,4,5) | inlist(s06q04b1,4,5))) if !mi(work_cur)
g biz_cur  = (work_cur==1 & (inlist(s06q04b,1,2) | inlist(s06q04b1,1,2))) if !mi(work_cur)
g farm_cur = (work_cur==1 & (inlist(s06q04b,3)   | inlist(s06q04b1,3)  )) if !mi(work_cur)
la var  work_cur		"Respondent currently employed"
la var nwork_cur		"Respondent currently unemployed"
la var  wage_cur		"Respondent mainly employed for wages"
la var   biz_cur		"Respondent mainly employed in household enterprise"
la var  farm_cur		"Respondent mainly employed on family farm"

*	sector
tab2 round s06q04a, m first
la li s06q04a	//	code 16 added in round 13
recode s06q04a (1 16=1)(2 3=2)(4 9=7)(5=3)(6=4)(7=6)(8 14=5)(10/12 15=9)(13=8), gen(sector_cur)
la var sector_cur		"Sector of respondent current employment"

tabstat *_cur, by(round) s(n sum) longstub

*	no hours in BFA
*	respondent where available 
ta round if !mi(sec6_rep)
ta round if  mi(sec6_rep)
d using  "${local_storage}/tmp_BFA_ind.dta"
g membres__id = sec6_rep
mer m:1 hhid membres__id round using "${local_storage}/tmp_BFA_ind.dta", keep(1 3)
ta round _m, nol
ta respond if _m==3,m	//	99% same person 
g emp_resp_main = respond
foreach x in sex age head relation {
g emp_resp_`x' = `x' 
}
drop membres__id-_merge
order emp_resp_*, a(sec6_rep)
la var emp_resp_main		"Employment respondent = primary respondent"
la var emp_resp_sex			"Sex of employment respondent"
la var emp_resp_age			"Age of employment respondent"
la var emp_resp_head		"Employment respondent is head"
la var emp_resp_relation	"Employment respondent relationship to household head"


keep hhid round *_cur emp_resp* 
	tempfile emp
	sa		`emp'
	
	
*	implement NFE separately
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round+1 if round>4
replace round=round+1 if round>6
replace round=round+2 if round>9
replace round=round+4 if round>12
replace round=round+1 if round>17
	ta round
	isid hhid round

	ta s06q10 round,m
g		refperiod_nfe = (s06q10==1) if round!=12 & !mi(s06q10)
replace	refperiod_nfe = (s06q11==1) if round==12 & !mi(s06q11)
la var	refperiod_nfe	"Household operated a non-farm enterprise (NFE) since previous contact"

tab2 round s06q10a_? s06q10a? s06q11a,m first
egen status_nfe = rowfirst(s06q10a_? s06q10a? s06q11a) if round!=12

g open_nfe = status_nfe==1 if !mi(status_nfe)
ta round status_nfe,m
la var	status_nfe		"Operational status of NFE"
la var	open_nfe		"NFE is currently open"
	
*	sector 
	*	these codes are consistent with the 9-value codes
tab2 round s06q11 s06q12a s06q12, first m	//	ignore the ournd 1 three code split 
	g		sector_nfe = s06q11 if inrange(round,2,4)
	replace	sector_nfe = s06q11+1 if inrange(round,6,9)
	recode sector_nfe (8=9) if inrange(round,6,9)
	replace sector_nfe = s06q12 if inlist(round,12,19)
	replace sector_nfe = s06q12a if round==17
	ta round sector_nfe
la var	sector_nfe		"Sector of NFE"	//	
	
keep hhid round *_nfe
tempfile nfe
sa		`nfe'
	
u `emp', clear
mer 1:1 hhid round using `nfe', assert(1 3) nogen


run "${hfps_github}/label_emp_sector.do"
la val sector_cur sector_nfe emp_sector

isid hhid round
sort hhid round

sa "${local_storage}/tmp_BFA_employment.dta", replace







********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************


*	FIES
dir "${raw_hfps_bfa}", w	//we need section 7 
dir "${raw_hfps_bfa}/r*_sec7_securite_alimentaire.dta", w	//we need section 7 


// d using	"${raw_hfps_bfa}/r1_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r2_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r3_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r4_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r5_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r6_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r7_sec7_securite_alimentaire.dta"		
// d using	"${raw_hfps_bfa}/r8_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r9_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r10_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r11_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r12_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r13_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r14_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r15_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r16_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r17_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r18_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r19_sec7_securite_alimentaire.dta"	



u "${raw_hfps_bfa}/r2_sec2_liste_membre_menage.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos2 type2 isnum2 fmt2 val2 var2)
tempfile base
sa      `base'
foreach r of numlist 3/7 9/11 13 15 17 18 19 {
	u "${raw_hfps_bfa}/r`r'_sec2_liste_membre_menage.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var2 if matches>=10, sep(0)


#d ; 
clear; append using

	"${raw_hfps_bfa}/r2_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r3_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r4_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r5_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r6_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r7_sec7_securite_alimentaire.dta"		

	"${raw_hfps_bfa}/r9_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r10_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r11_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r13_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r15_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r17_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r18_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r19_sec7_securite_alimentaire.dta"	

, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round+1
replace round=round+1 if round>7
replace round=round+1 if round>11
replace round=round+1 if round>13
replace round=round+1 if round>15
	ta round
	
	la li onnspr
g worried	= s07q01=="Oui":onnspr if inlist(s07q01,"Non":onnspr,"Oui":onnspr)
g healthy	= s07q02=="Oui":onnspr if inlist(s07q02,"Non":onnspr,"Oui":onnspr)
g fewfood	= s07q03=="Oui":onnspr if inlist(s07q03,"Non":onnspr,"Oui":onnspr)
g skipped	= s07q04=="Oui":onnspr if inlist(s07q04,"Non":onnspr,"Oui":onnspr)
g ateless	= s07q05=="Oui":onnspr if inlist(s07q05,"Non":onnspr,"Oui":onnspr)
g runout	= s07q06=="Oui":onnspr if inlist(s07q06,"Non":onnspr,"Oui":onnspr)
g hungry	= s07q07=="Oui":onnspr if inlist(s07q07,"Non":onnspr,"Oui":onnspr)
g whlday	= s07q08=="Oui":onnspr if inlist(s07q08,"Non":onnspr,"Oui":onnspr)

tabstat worried healthy fewfood skipped ateless runout hungry whlday, by(round) s(n)
tabstat s07q01 s07q02 s07q03 s07q04 s07q05 s07q06 s07q07 s07q08, by(round) s(n)


*	get weight and hhsize vars 
d using "${local_storage}/tmp_BFA_cover.dta"
mer 1:1 round hhid using "${local_storage}/tmp_BFA_cover.dta", keepus(strate wgt)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
assert min==max
keep if _m==3
drop _m min max

mer 1:1 round hhid using "${local_storage}/tmp_BFA_demog.dta", keepus(hhsize)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
keep if _m==3 | min!=max
drop _m min max


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

g na="NA" 
g urban = (strate!="Rural":strate)

cap : erase "${local_storage}/FIES_BFA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_BFA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3), though worried on the high side at 1.208
	2	Equating: Dropped runout (0.41), after that all items are <=.35
	3	downloaded and saved as FIES_BFA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
2	45.94	6.38	8.51	3.35
3	42.29	5.43	7.49	2.86
4	30.35	5.24	4.15	1.99
5	24.31	4.95	3.47	1.96
6	19.96	4.13	3.05	1.62
7	24.39	4.63	2.12	1.23
9	22.76	4.07	1.33	1.10
10	24.01	4.84	0.83	0.59
11	27.57	4.92	1.57	1.27
13	45.28	5.66	5.96	2.52
15	34.31	5.05	3.79	2.06
17	33.94	5.67	4.33	2.33
18	49.50	7.68	13.06	4.32
19	46.39	8.20	9.94	4.38
*/

										/*	ARCHIVE
											notes on process done in Shiny app
											1	All infit inrange(0.7,1.3), though worried on the high side at 1.218
											2	Equating: Dropped runout (0.41), after that all items are <=.35
											3	downloaded and saved as FIES_BFA_out.csv
										*/
										
										/*	when using all, individual level (note that here "region" = survey round)
										Prevalence rates of food insecurity by region (% of individuals)
										Moderate or Severe	MoE	Severe	MoE
										2	44.36	6.44	7.14	2.95
										3	40.62	5.44	6.36	2.54
										4	28.89	5.19	3.50	1.76
										5	22.90	4.90	2.95	1.74
										6	18.75	4.06	2.58	1.41
										7	22.88	4.56	1.75	1.08
										9	21.02	3.95	1.10	0.97
										10	22.39	4.76	0.64	0.49
										11	25.71	4.85	1.31	1.11
										13	43.39	5.66	4.96	2.22
										15	32.45	4.98	3.20	1.82
										17	32.26	5.60	3.67	2.08
										18	48.46	7.69	10.95	3.85
										*/

levelsof round, loc(rounds)
foreach r of local rounds {
// 	loc r=19
	cap : erase "${local_storage}/FIES_BFA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_BFA_r`r'_in.csv", delim(",")
}

*	If we do round by round, the results do differ. 
*	however, the round 3 constructed using this data also differs from the round 3 previously constructed
*	it is possible that the weight changed and this was the entire driver of difference, 
	*-> we ahve to compare these somehow 
	/*
	preserve
import delim using "${local_storage}/FIES_BFA_r3_in.csv", delim(",") clear 
g row=_n
tempfile public
sa		`public'
import delim using "${fies_hfps_bfa}/FIES_BFround3_in.csv", delim(",") clear 
g row=_n
d
append using `public', gen(public)
isid row public
la val public 
ta public	
tabstat hhwcovid_r3_cs wt_hh wgt wgt_hh, by(public) s(sum) format(%12.0gc)	//	identical
tabstat worried-whlday, by(public) s(sum) format(%12.0gc)	//	identical
tabstat urban, by(public) s(sum) format(%12.0gc)	//	identical
	restore
	*/
	


/*
round 2 
	1	Hungry infit is 0.698, otherwise inrange(0.7,1.3). Retained as this is 
		not seen in other rounds for BF 
	2	Equating: All items are <=.35, though runout is close at 0.34 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.27 
	2	Equating: All items are <=.35, though runout is close at 0.35 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3). 
	2	Equating: runout is 0.36, droppedn and then all items are <=.35
	3	downloaded and saved as FIES_BFA_r4_out.csv

round 5 
	1	Worried high at 1.393, retained for consistency with other rounds 
	2	Equating: runout is 0.42 - dropped. 
	3	downloaded and saved as FIES_BFA_r5_out.csv

round 6 
	1	Worried high at 1.411, but retained for conssitency with other rounds. 
		All other infit inrange(0.7,1.3).
	2	Equating: runout is 0.50 - dropped.
	3	downloaded and saved as FIES_BFA_r6_out.csv

round 7 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.22 
	2	Equating: runout is 0.63 - dropped.
	3	downloaded and saved as FIES_BFA_r7_out.csv

round 9 
	1	Healthy high at 1.392. Retained for consistency with other rounds.  
	2	Equating: runout is 0.53 - dropped.
	3	downloaded and saved as FIES_BFA_r9_out.csv

round 10 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.299 
	2	Equating: runout is 0.56 - dropped.
	3	downloaded and saved as FIES_BFA_r10_out.csv

round 11 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.23 
	2	Equating: All items are <=.35, though runout is close at 0.31 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r11_out.csv

round 13 
	1	All infit inrange(0.7,1.3). 
	2	Equating: All items are <=.35, runout is fine at 0.21, but dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r13_out.csv

round 15 
	1	All infit inrange(0.7,1.3). 
	2	Equating: runout is 0.41 - dropped.
	3	downloaded and saved as FIES_BFA_r15_out.csv

round 17 
	1	All infit inrange(0.7,1.3).
	2	Equating: runout is 0.38 - dropped.
	3	downloaded and saved as FIES_BFA_r17_out.csv

round 18 
	1	Hungry low at 0.678. Retained for consistency with other rounds. 
	2	Equating: runout is 0.53 - dropped.
	3	downloaded and saved as FIES_BFA_r18_out.csv

round 19 
	1	All infit inrange(0.7,1.3).
	2	Equating: runout is 0.29 while skipped is .43. Dropped runout for  
		consistency with other rounds, though note that Skipped is now still .39
	3	downloaded and saved as FIES_BFA_r19_out.csv


*/





*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${local_storage}/FIES_BFA_out.csv", varn(1) clear
ds rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev, has(type string)
if length("`r(varlist)'")>0 {
destring rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev, replace ignore("NA")
	}
ren (rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev)(RS fies_mod fies_sev)
keep RS fies_mod fies_sev
duplicates drop
isid RS, missok
sa `out'
	restore
mer m:1 RS using `out', assert(3) nogen

tabstat fies_mod fies_sev [aw=wgt_hh], by(round)

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
ren fies_??? fies_pooled_???


	preserve 
levelsof round if !mi(RS), loc(rounds)
loc toappend ""
foreach r of local rounds {
import delimited using "${local_storage}/FIES_BFA_r`r'_out.csv", varn(1) clear
ds rawscore probmod_sev probsev, has(type string)
if length("`r(varlist)'")>0 {
destring rawscore probmod_sev probsev, replace ignore("NA")
	}
ren (rawscore probmod_sev probsev)(RS fies_mod fies_sev)
keep RS fies_mod fies_sev
duplicates drop
g round=`r'
tempfile r`r'
sa		`r`r''
loc toappend "`toappend' `r`r''"
}
clear
append using `toappend'
ta round RS
tempfile tomerge 
sa		`tomerge'
	restore

mer m:1 RS round using `tomerge'
ta RS round if _m!=3,	m
drop _m

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
tabstat fies_mod fies_sev fies_pooled_mod fies_pooled_sev [aw=wgt_hh], by(round) format(%9.3f)

la var worried	"Worried about not having enough food to eat"
la var healthy	"Unable to eat healthy and nutritious/preferred foods"
la var fewfood	"Ate only a few kinds of foods"
la var skipped	"Had to skip a meal"
la var ateless	"Ate less than you thought you should"
la var runout	"Ran out of food"
la var hungry	"Were hungry but did not eat"
la var whlday	"Went without eating for a whole day"

ren (worried healthy fewfood skipped ateless runout hungry whlday)	/*
*/	(fies_worried fies_healthy fies_fewfood fies_skipped fies_ateless fies_runout fies_hungry fies_whlday)

ren RS fies_rawscore
la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

keep round hhid fies_*
sa "${local_storage}/tmp_BFA_fies.dta", replace
	
	
	



********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************


dir "${raw_hfps_bfa}", w	//we need section 7a 
dir "${raw_hfps_bfa}/r*fcs*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r18_sec7a_fcs_consommation_alimentaire.dta"	
u	"${raw_hfps_bfa}/r18_sec7a_fcs_consommation_alimentaire.dta"	, clear

g round=18
isid hhid
	drop *__*
	tab1 s07*
	d s07*
*	prepare to reshape to implement syntax as in other countries
ren (s07aq01a s07aq01b s07aq01c s07aq01d s07aq03_1d s07aq03_2d s07aq03_3d s07aq03_4d s07aq01e s07aq03_1e s07aq03_2e s07aq01f s07aq03_1f s07aq01g s07aq01h s07aq01i)	/*
*/	(d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16)
reshape long d, i(hhid round) j(foodcat)

generate days = d if inrange(d,0,7)
replace  days = 0 if d==.
replace  days = 7 if d>7 & !missing(d)
g dum = (inrange(days,1,7))	


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode foodcat (2=12)(3=13)(4=9)(5=9)(6=8)(7=11)(8=10)(9=5)(10=3)(11=4)(12=7)(13=6), copyrest gen(HDDS_codes)
				/*	tubers were omitted	*/ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
*	make HDDS scores to combine at household level
bys hhid round HDDS_codes (foodcat) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_codes : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode foodcat
				/*	tubers were omitted	*/ 
	(2=3)		/*	nuts, pulses	*/ 
	(9/11=4)		/*	vegetables	*/
	(12/13=5)		/*	fruits	*/
	(4/8=6	)	/*	meat, fish, eggs	*/
	(3=7)		/*	dairy	*/
	(14=9)		/*	oils, fats	*/
	(15=8)	/*	sugar, sugar products, honey	*/
	(16=.)	/*	exclude condiments	*/ 
	, copyrest gen(fcs_cats);
#d cr 
*	make weights per food consumption score category 
assert inrange(fcs_cats,1,9) | mi(fcs_cats)
#d ; 
recode fcs_cats 
	(1=2)	/*	cereals, grains, cereal products	*/
	(2=2)	/*	roots, tubers, plantains	*/
	(3=3)	/*	nuts, pulses	*/
	(4=1)	/*	vegetables	*/
	(5=1)	/*	fruits	*/
	(6=4)	/*	meat, fish, eggs	*/
	(7=4)	/*	dairy	*/
	(8=0.5)	/*	sugar, sugar products, honey	*/
	(9=0.5)	/*	oils, fats	*/
	, gen(fcs_weights);
#d cr 


*	make sum of days by category, truncating at 7 max for combined categories
bys hhid round fcs_cats (foodcat) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${local_storage}/tmp_BFA_dietary_diversity.dta", replace 


	
********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************


dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*chocs*.dta", w	//we need section 6, but it splits in sections after the first  


// d using	"${raw_hfps_bfa}/r1_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r2_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r3_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r4_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r5_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r6_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r7_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r8_sec9_chocs.dta"		
// d using	"${raw_hfps_bfa}/r9_sec9_chocs.dta"		
d using	"${raw_hfps_bfa}/r10_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r11_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r12_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r13_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r14_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r15_sec9_chocs.dta"	
d using	"${raw_hfps_bfa}/r16_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r17_sec9_chocs.dta"	
// d using	"${raw_hfps_bfa}/r18_sec9_chocs.dta"	



#d ; 
clear; append using
	"${raw_hfps_bfa}/r2_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r4_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r6_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r8_sec9_chocs.dta"		
	"${raw_hfps_bfa}/r10_sec9_chocs.dta"	
	"${raw_hfps_bfa}/r16_sec9_chocs.dta"	
, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round*2
replace round=round+4 if round>10
	ta round
	isid hhid chocs__id round
	
*	harmonize shock_code
run "${hfps_github}/label_shock_code.do"
la li chocs shock_code 
g shock_code=chocs__id, a(chocs__id)
recode shock_code (2=41)(3=1)(4=42)(13=96)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta chocs__id shock_code
drop chocs__id

bys hhid round (shock_code) : egen shock_yn = max(s09q01==1)
g yn = (s09q01==1)
ds s09q03*, not(type string)
collapse (max) yn=s09q01 `r(varlist)', by(hhid round shock_code)
	
ren s09q03__* shock_cope_*
ren shock_cope_22 shock_cope_96
	la var shock_cope_1  "Sale of assets (ag and no-ag) to cope with shock"
	la var shock_cope_6  "Engaged in additional income generating activities to cope with shock"
	la var shock_cope_7  "Received assistance from friends & family to cope with shock"
	la var shock_cope_8  "Borrowed from friends & family to cope with shock"
	la var shock_cope_9  "Took a loan from a financial institution to cope with shock"
	la var shock_cope_11 "Credited purchases to cope with shock"
	la var shock_cope_12 "Delayed payment obligations to cope with shock"
	la var shock_cope_13 "Sold harvest in advance to cope with shock"
	la var shock_cope_14 "Reduced food consumption to cope with shock"
	la var shock_cope_15 "Reduced non-food consumption to cope with shock"
	la var shock_cope_16 "Relied on savings to cope with shock"
	la var shock_cope_17 "Received assistance from ngo to cope with shock"
	la var shock_cope_18 "Took advanced payment from employer to cope with shock"
	la var shock_cope_19 "Received assistance from government to cope with shock"
	la var shock_cope_20 "Was covered by insurance policy to cope with shock"
	la var shock_cope_21 "Did nothing to cope with shock"
	la var shock_cope_96 "Other (specify) to cope with shock"

sa "${local_storage}/tmp_BFA_shocks.dta", replace
	
	
*	move to household level for analysis
u  "${local_storage}/tmp_BFA_shocks.dta", clear

ta shock_code
la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & yn==1)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
// ds shock*, has(type string)
// drop `r(varlist)'

*	verify that missing-ness is intact
tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)


 foreach x of varlist shock_yn* shock_cope* {
 	loc lbl`x' : var lab `x'
 }
collapse (max) shock_yn* shock_cope*, by(hhid round)
 foreach x of varlist shock_yn* shock_cope* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)


isid hhid round
sort hhid round
sa "${local_storage}/tmp_BFA_hh_shocks.dta", replace 
	
	
	

********************************************************************************
}	/*	Shocks / Coping end	*/ 
********************************************************************************


********************************************************************************
{	/*	Label Item	*/ 
********************************************************************************

cap : program drop	bfa_label_item
program define		bfa_label_item
cap : la drop item
#d ; 
la def item 
	1	"local rice"
	3	"imported rice"
	6	"maize grain"
	7	"millet"
	8	"sorghum"
	12	"maize flour"
	14	"wheat flour"
	17	"bread"
	23	"beef"
	25	"mutton"
	36	"horse mackerel"	/* (modal type in 2018)	*/
	41	"dried fish"
	44	"fresh milk"
	52	"eggs"
	55	"cooking oil"	/*	palm oil */
	75	"fresh beans"
	79	"tomatoes"
	80	"tomato concentrate"
	83	"onions"
	95	"dry beans"
	98	"crushed peanuts"
	114 "sugar"
	118 "salt"
	130	"tea"
	
	104	"cassava"	
	107	"irish potato"	
	109	"sweet potato"	
	111	"cassava flour"	
	222	"sorghum flour"	/*	not coded in 2018 (aside from "other flour" category)	*/ 
	
	601	"maize seed"
	602	"soya seed"
	603	"bean seed"
	
	701	"petrol"
	702	"diesel"
	703	"paraffin"
	704	"LPG"	/*	liquefied petroleum gas (bottled)	*/
	
	801	"fuel for car"
	802	"fuel for motorcycle"
	901	"chemical fertilizer"
	
	
	;
#d cr 

end

********************************************************************************
}	/*	Label Item end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_lsms_bfa}", w
d using "${raw_lsms_bfa}/s07b_me_bfa2018.dta"
u "${raw_lsms_bfa}/s07b_me_bfa2018.dta", clear
la li produitID
// la save produitID using "${do_hfps_bfa}/label_item.do", replace	//starting point
ta s07bq01 if s07bq02==1
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/*prix*.dta", w


d using	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5t_prix_transport.dta"		

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

*	item codes are not harmonized across rounds, necessitating a recode 


u	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta", clear
g item=carburant__id + 691
bfa_label_item
la val item item
inspect item
assert r(N_undoc)==0
ta carburant__id item 
la var item	"Item code"


g item_avail = inlist(s05cq02,1,2)	//	this is actual purchase here, not truly availability
la var	item_avail	"Item is available for sale"

g price =  s05cq05/s05cq04
la var	price		"Price (LCU/standard unit)"
g unitcost = price	//	in this case we will construct them as identical, though the LCU for total could also be of interest in the price variable
la var	unitcost	"Unit Cost (LCU/unit)"

g unit=302
g unitstr="Litre"
la var unitstr		"Unit"

isid hhid item
keep hhid item item_avail price unitcost /*unit*/ unitstr
tempfile fuel
sa		`fuel'

u	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta", clear
la li da
#d ; 
recode denrees_alimentaires__id
	(10=6)		/*	maize grain	*/ 
	(11=3)		/*	imported rice	*/ 
	(12=104)	/*	cassava	*/
	(13=107)	/*	irish potato	*/
	(14=109)	/*	sweet potato	*/ 
	(15=12)		/*	maize flour	*/
	(16=111)	/*	cassava flour	*/
	(17=222)	/*	sorghum flour	*/
	(18=14)		/*	wheat flour	*/
	(19=95)		/*	dry bean	*/
	(20=75)		/*	fresh beans	*/
	(21=98)		/*	crushed peanuts	*/
	(22=23)		/*	beef	*/
	(23=44)		/*	fresh milk	*/
	(24=52)		/*	eggs	*/
	(25=17)		/*	bread	*/
	(26=83)		/*	onions	*/
	(27=79)		/*	tomato	*/
	(28=114)	/*	sugar	*/
	(29=55)		/*	cooking oil=palm oil here for simplicity	*/
	(30=130)	/*	tea	*/
	(31=118)	/*	salt	*/
	(32=901)	/*	fertilizer	*/
	(33=601)	/*	maize seed	*/
	(34=602)	/*	soy seed	*/
	(35=603)	/*	bean seed	*/
, gen(item); 
	#d cr
	
bfa_label_item
la val item item
inspect item
assert r(N_undoc)==0
ta denrees_alimentaires__id item 
la var item	"Item code"

g item_avail = (s05pq01==1)
la var	item_avail	"Item is available for sale"

la li s05pq03a
ta s05pq03a
compare s05pq05 s05pq07	//	never jointly defined
g price = cond(inlist(s05pq03a,100,302),s05pq05,cond(inlist(s05pq06a,100,302),s05pq07,.))
la var price		"Price (LCU/standard unit)"

egen unitcost = rowfirst(s05pq05 s05pq07)
la var	unitcost	"Unit Cost (LCU/unit)"

*	lacking a conversion factor, we will simply bring the raw unit through 
compare s05pq03a s05pq06a
g unit=cond(!mi(s05pq05),s05pq03a,cond(!mi(s05pq07),s05pq06a,.))
g size=cond(!mi(s05pq05),s05pq03b,cond(!mi(s05pq07),s05pq06b,.))
la copy s05pq03a unit
la val unit unit
la copy s05pq03b size
la val size size

decode unit, gen(xx)
decode size, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

isid hhid item
keep hhid item item_avail price unitcost /*unit size*/ unitstr

append using `fuel'
isid hhid item

decode item, gen(itemstr)
la var itemstr	"Item code"

g round=18, b(hhid)
tempfile r18 
sa		`r18'

#d ; 
clear; append using
	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"
	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"
	, gen(round); replace round=round+14; la val round; la drop _append; 
recode produit__id (100/199=1)(200/299=2)(300/399=3), gen(urb); 
recode produit__id 
	(101 202 304=3)	/*	imported rice	*/ 
	(203=1)			/*	local rice	*/ 
	(102 201 301=6)	/*	maize grain	*/ 
	(103 205=12)	/*	maize flour	*/
	(104 204 305=17)	/*	modern bread	*/
	(105 303=7)	/*	millet	*/
	(302=8)	/*	Sorghum	*/
	(106 206 306=79)	/*	fresh tomato	*/
	(107 207 307=80)	/*	tomato concentrate	*/
	(108 208 308=95)	/*	cowpea / dried bean	*/
	(109 209 309=114)	/*	sugar	*/
	(110 210 310=52)	/*	eggs	*/
	(111 211 311=23)	/*	beef	*/
	(112 212 312=25)	/*	mutton	*/
	(113 213 313=36)	/*	horse mackerel (modal type in 2018)	*/
	(114 214 314=41)	/*	dried fish	*/
	(115 215 315=55)	/*	palm oil	*/
	
	(116 216 316=801)	/*	fuel for car	*/
	(117 217 317=802)	/*	fuel for motorcycle	*/
	(318=901)	/*	chemical fertilizer	*/
	, gen(item);
	#d cr
	
bfa_label_item
la val item item
inspect item
assert r(N_undoc)==0
ta produit__id item 
la var urb	"Spatial domain for prices"
la var item	"Item code"

ta sec9e round,m
drop if sec9e!=1
isid hhid round produit__id


decode item, gen(itemstr)
la var itemstr	"Item code"

g item_avail = (s09eq01==1)
la var	item_avail	"Item is available for sale"


la li s09eq02a_1
ta s09eq02a
g price = cond(inlist(s09eq02a,100,302),s09eq03,.)
la var price		"Price (LCU/standard unit)"

g unitcost = s09eq03
la var	unitcost	"Unit Cost (LCU/unit)"

*	lacking a conversion factor, we will simply bring the raw unit through 
decode s09eq02a, gen(xx)
decode s09eq02b, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

*	collapse needed to manage multiple strata unit codes 
foreach x in item_avail price unitcost unitstr itemstr {
	loc lbl`x' : var lab `x'
}
collapse (max) item_avail (firstnm) price unitcost unitstr itemstr, by(hhid round item)
foreach x in item_avail price unitcost unitstr itemstr {
	la var `x' "`lbl`x''"
}
// nmissing hhid round item
keep  hhid round item itemstr item_avail unitstr price unitcost 
order hhid round item itemstr item_avail unitstr price unitcost
isid  hhid round item
append using `r18'	/*	bring in the round 18 things	*/ 
isid  hhid round item
sort  hhid round item

replace price = . if price<=0
replace unitcost = . if unitcost<=0

sa "${local_storage}/tmp_BFA_price.dta", replace 

u  "${local_storage}/tmp_BFA_price.dta", clear
*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)



********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************


dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*opinion*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r13_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r14_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r15_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r16_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r18_sec9c_opinion_economique.dta"	

#d ; 
clear; append using 
	"${raw_hfps_bfa}/r13_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r14_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r15_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r16_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r18_sec9c_opinion_economique.dta"	
	, gen(round); la drop _append; la val round .; 
#d cr 
replace round = round+12
replace round = round+1 if round>16



	la li q1 q2 q3 q4 q5 q7 q8 q9 q11

d s09*


ds s09*, not(type string)
tabstat `r(varlist)', by(round) s(n)


loc q1 s09cq01
ta		`q1',m
la li	q1
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
// 	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s09cq02
ta		`q2', m
la li	q2
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s09cq03
ta		`q3', m
la li	q3
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s09cq04
ta		`q4', m
la li	q4
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s09cq05
ta		`q5', m
la li	q5
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}


loc q6	s09cq06
ta		`q6', m
g		sntmnt_last12moPricepct = `q6'
la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s09cq07
ta		`q7', m
la li	q7
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s09cq08
ta		`q8', m
la li	q8
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s09cq09
ta		`q9', m
la li	q9
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s09cq10__
tabstat `weather'?, by(round) s(n)	
d `weather'?	//	no storms for UGA 

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)4 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"



loc q11	s09cq11
ta		`q11', m
la li	q11
g      sntmnt_securityrisk_label=.
la var sntmnt_securityrisk_label	"Financial effects from extreme violence are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_securityrisk_cat`l' = `q11'==`i' if !mi(`q11')
	la var sntmnt_securityrisk_cat`l' "`: label (`q11') `i''"
}


loc violence s09cq12__
tabstat `violence'?, by(round) s(n)	
d `violence'?	//	no storms for UGA 

g      sntmnt_securityevent_label=.
la var sntmnt_securityevent_label	"Most likely security event to cause financial effects [...]" 
foreach i of numlist 1(1)4 {
	g	   sntmnt_securityevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_securityevent_cat1		"Terrorism/extreme violence"
la var sntmnt_securityevent_cat2		"Large scale theft"
la var sntmnt_securityevent_cat3		"Community violence"
la var sntmnt_securityevent_cat4		"Political instability/unrest"






	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${local_storage}/tmp_BFA_economic_sentiment.dta", replace 


********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************


dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*subjectif*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r18_sec9f1_bienetre_subjectif.dta"	



u "${raw_hfps_bfa}/r18_sec9f1_bienetre_subjectif.dta" , clear

g round=18
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s09f1q01 
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s09f1q02 
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s09f1q03 
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s09f1q04 
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s09f1q05 
la def q5 1 "Well" 2 "Fairly well" 3 "Fairly" 4 "With difficulty"
la val `q5' q5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s09f1q06
la def q6 1 "Very happy " 2 "Fairly happy" 3 "Not very happy" 4 "Not at all happy"
la val `q6' q6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

keep hhid round sw_*	
sa "${local_storage}/tmp_BFA_subjective_welfare.dta", replace
	
	

********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_lsms_bfa}", w
d using "${raw_lsms_bfa}/s07b_me_bfa2018.dta"
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/*prix*.dta", w


d using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d using	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		

d using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		

#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r4_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r6_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		

	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
	, gen(round); 
	la drop _append; la val round .; 
#d cr
isid hhid round
replace round=round+1 if round>4
replace round=round+4 if round>6
replace round=round+4 if round>11
ta round

*	1	hh has grown crops since beginning of agricultural season 
tab2 round s06q01 s06q14 s06dq01 s06d1q00, first
g		ag_refperiod_yn = (s06q14==1) if !mi(s06q14)
replace	ag_refperiod_yn = (s06dq01==1) if !mi(s06dq01)
replace	ag_refperiod_yn = (s06d1q00==1) if !mi(s06d1q00)
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"


*	2	able to farm normally 
tab2 round s06q15, first

g		ag_normal_yn = (s06q15==1) if !mi(s06q15) & inlist(round,1,2)
la var	ag_normal_yn	"Able to conduct agricultural activies normally"


*	3	reason respondent not able to conduct normal farming activities
tab2 round s06q16__1 , first	//	per Yaneck, take for rounds 1&2 only. 
	*	per the survey instrument, round 3 q 16 should be crop codes, 
	*	presumably these s06q16__* values were pre-loaded into round 3 
loc v3 s06q16__
tabstat `v3'*, by(round) s(sum)
d `v3'* using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d `v3'* using	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
g		ag_resp_no_farm_cat1 = (`v3'1==1) if !mi(`v3'1) & inlist(round,1,2)
la var	ag_resp_no_farm_cat1		"Advised to stay home"
g		ag_resp_no_farm_cat2 = (`v3'2==1) if !mi(`v3'2) & inlist(round,1,2)
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
g		ag_resp_no_farm_cat3 = (`v3'3==1) if !mi(`v3'3) & inlist(round,1,2)
la var	ag_resp_no_farm_cat3		"Restrictions on movement / travel"
g		ag_resp_no_farm_cat4 = (`v3'4==1) if !mi(`v3'4) & inlist(round,1,2)
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
g		ag_resp_no_farm_cat5 = (`v3'5==1) if !mi(`v3'5) & round==1
replace	ag_resp_no_farm_cat5 = (`v3'7==1) if !mi(`v3'7) & round==2
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
g		ag_resp_no_farm_cat6 = (`v3'6==1) if !mi(`v3'6) & round==1
replace	ag_resp_no_farm_cat6 = (`v3'8==1) if !mi(`v3'8) & round==2
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
g		ag_resp_no_farm_cat7 = (`v3'7==1) if !mi(`v3'7)  & round==1
replace	ag_resp_no_farm_cat7 = (`v3'9==1) if !mi(`v3'9)  & round==2
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
g		ag_resp_no_farm_cat8 = (`v3'11==1) if !mi(`v3'11) & round==2
la var	ag_resp_no_farm_cat8		"Climate"


*	5	not able to conduct hh ag activities
d s06q15_1__*	//	r3
d s06dq02__*	//	r11
d s06d1q01__*	//	r16
d s06q15_1__*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d s06dq02__*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d s06d1q01__*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		

loc v5r03	s06q15_1__
loc v5r11	s06dq02__
loc v5r16	s06d1q01__
d  `v5r03'*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d  `v5r11'*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d  `v5r16'*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (`v5r03'1==1) if !mi(`v5r03'1) & round== 3
replace	ag_nogrow_cat1 = (`v5r11'1==1) if !mi(`v5r11'1) & round==11
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (`v5r03'2==1) if !mi(`v5r03'2) & round== 3
replace	ag_nogrow_cat2 = (`v5r11'2==1) if !mi(`v5r11'2) & round==11
replace	ag_nogrow_cat2 = (`v5r16'1==1) if !mi(`v5r16'1) & round==16
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (`v5r03'3==1) if !mi(`v5r03'3) & round== 3
replace	ag_nogrow_cat3 = (`v5r11'3==1) if !mi(`v5r11'3) & round==11
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (`v5r03'4==1) if !mi(`v5r03'4) & round== 3
replace	ag_nogrow_cat4a = (`v5r11'4==1) if !mi(`v5r11'4) & round==11
replace	ag_nogrow_cat4a = (`v5r16'2==1) if !mi(`v5r16'2) & round==16
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5r03'5==1) if !mi(`v5r03'5) & round== 3
replace	ag_nogrow_cat4b = (`v5r11'5==1) if !mi(`v5r11'5) & round==11
replace	ag_nogrow_cat4b = (`v5r16'3==1) if !mi(`v5r16'3) & round==16
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5r03'6==1) if !mi(`v5r03'6) & round== 3
replace	ag_nogrow_cat4c = (`v5r11'6==1) if !mi(`v5r11'6) & round==11
replace	ag_nogrow_cat4c = (`v5r16'4==1) if !mi(`v5r16'4) & round==16
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5r03'7==1) if !mi(`v5r03'7) & round== 3
replace	ag_nogrow_cat5 = (`v5r11'7==1) if !mi(`v5r11'7) & round==11
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5r03'8==1) if !mi(`v5r03'8) & round== 3
replace	ag_nogrow_cat6 = (`v5r11'8==1) if !mi(`v5r11'8) & round==11
replace	ag_nogrow_cat6 = (`v5r16'5==1) if !mi(`v5r16'5) & round==16
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5r03'9==1) if !mi(`v5r03'9) & round== 3
replace	ag_nogrow_cat7 = (`v5r11'9==1) if !mi(`v5r11'9) & round==11
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"

g		ag_nogrow_cat10= (`v5r16'6==1) if !mi(`v5r16'6) & round==16
la var	ag_nogrow_cat10		"Insecurity"
	*	ignore the o/s

*	6	not able to access fertilizer 
loc v6r03	s06q20__
loc v6r11	s06dq04_1__
loc v6r16	s06d1q02
d  `v6r03'*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d  `v6r11'*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d  `v6r16'*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"
la li 	`v6r16'
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6r03'1==1 | `v6r03'2==1) if !mi(`v6r03'1,`v6r03'2) & round== 3
replace	ag_nofert_cat1=(`v6r11'1==1 | `v6r11'2==1) if !mi(`v6r11'1,`v6r11'2) & round==11
replace	ag_nofert_cat1=(inlist(`v6r16',1,3)) if !mi(`v6r16') & round==16
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6r03'6==1) if !mi(`v6r03'6) & round== 3 
replace	ag_nofert_cat2=(`v6r11'6==1) if !mi(`v6r11'6) & round==11 
replace	ag_nofert_cat2=(inlist(`v6r16',2)) if !mi(`v6r16') & round==16
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
g		ag_nofert_cat3=(`v6r03'3==1 | `v6r03'4==1) if !mi(`v6r03'3,`v6r03'4) & round== 3
replace	ag_nofert_cat3=(`v6r11'3==1 | `v6r11'4==1) if !mi(`v6r11'3,`v6r11'4) & round==11
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"
g		ag_nofert_cat4=(`v6r03'5==1) if !mi(`v6r03'5) & round== 3
replace	ag_nofert_cat4=(`v6r11'5==1) if !mi(`v6r11'5) & round==11
la var	ag_nofert_cat4	"Increase in price of fertilizer"
	*	ignore the o/s
	
*	7	main crop 
la li s06d1q03
g cropcode=s06d1q03 
la var cropcode	"Main crop code"

*	8	harvest complete
loc v8 s06d1q05
ta round `v8'
g		ag_harv_complete = (`v8'==1)		if round==16  & !mi(`v8')

*	11	area comparison to last planting
loc v11	s06d1q04
ta  round	`v11'
la li		`v11'
g ag_plant_vs_prior=`v11' if round==16
recode	ag_plant_vs_prior (min/0 7/max=6)
#d ; 
la def ag_plant_vs_prior 
           1 "Much more (<25% or more area)"
           2 "Somewhat more (5-25% more)"
           3 "About the same (+/- 5%)"
           4 "Somewhat less (5-25% less)"
           5 "Much less (>25% less)"
           6 "Not applicable (e.g. did not plant this crop last year)"
		;
#d cr 
la val ag_plant_vs_prior ag_plant_vs_prior
la var ag_plant_vs_prior	"Comparative planting area vs last planting"

*	14	actual harvest quantity
loc v14	s06dq07
tab2 round `v14'b `v14'c, first
d `v14'*
g		ag_postharv_q		= `v14'a		if round==6
g		ag_postharv_u		= `v14'b		if round==6
g		ag_postharv_u_os	= `v14'b_autre	if round==6
g		ag_postharv_c		= `v14'c		if round==6
la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"
la var	ag_postharv_u_os	"Completed harvest unit o/s"
la var	ag_postharv_c		"Completed harvest condition"

*	15	normally sell
tab2 round s06q15 s06dq05,first m
*	Yannick calls for this variable in round 16 but I am failing to find it? 
g		ag_sale_typical	= s06q15==1 if !mi(s06q15) & inlist(round,4)
replace ag_sale_typical = (s06dq05==1) if !mi(s06dq05) & round==11
la var	ag_sale_typical		"Main crop is typically marketed"
	
	
*	17	Pre-sale subjective assessment
tab2 round s06q16 s06dq11 s06dq06, first
g		ag_antesale_subj = s06q16 if round==4
replace	ag_antesale_subj = s06dq11 if round==6
replace	ag_antesale_subj = s06dq06 if round==11
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment

*	17a	Post-sale subjective assessment
tab2 round s06dq13 s06d1q07, first
g		ag_postsale_subj = s06dq13 if round==6
replace	ag_postsale_subj = s06d1q07 if round==16
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	19	inorg fertilizer dummy
tab2 round s06dq16?, first 
tab2 round s06d1q11?, first 
g		ag_inorgfert_post 	= (s06dq16a==1) if !mi(s06dq16a)	//	no round requirement necessary
replace	ag_inorgfert_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_inorgfert_post	"Applied any inorganic fertilizer this season"

g		ag_orgfert_post		= (s06dq16b==1) if !mi(s06dq16b)
replace	ag_orgfert_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_orgfert_post		"Applied any organic fertilizer this season"
g		ag_pesticide_post	= (s06dq16c==1) if !mi(s06dq16c)
replace	ag_pesticide_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_pesticide_post	"Applied any pesticide / herbicide this season"
g		ag_hirelabor_post	= (s06dq16d==1) if !mi(s06dq16d)
replace	ag_hirelabor_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_hirelabor_post	"Applied any hired labor this season"
g		ag_draught_post		= (s06dq16e==1) if !mi(s06dq16e)
replace	ag_draught_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_draught_post		"Applied any animal traction this season"



*	23 reason no fertilizer
loc v23r6 s06dq17__
tabstat `v23r6'?, by(round) s(sum)
loc v23r16 s06d1q18
ta round `v23r16' 
la li `v23r16'
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (`v23r6'7==1) if !mi(`v23r6'7)
replace ag_inorgfert_no_cat1 = (inlist(`v23r16',1,2)) if !mi(`v23r16')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (`v23r6'5==1 | `v23r6'6==1) if !mi(`v23r6'5,`v23r6'6)
replace ag_inorgfert_no_cat2 = (inlist(`v23r16',3)) if !mi(`v23r16')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (`v23r6'1==1 | `v23r6'2==1) if !mi(`v23r6'1,`v23r6'2)
replace ag_inorgfert_no_cat3 = (inlist(`v23r16',4)) if !mi(`v23r16')
la var	ag_inorgfert_no_cat3	"Not available"
g 		ag_inorgfert_no_cat4 = (`v23r6'3==1 | `v23r6'4==1) if !mi(`v23r6'3,`v23r6'4)
// replace ag_inorgfert_no_cat4 = (inlist(`v23r16',4)) if !mi(s13q16)
la var	ag_inorgfert_no_cat4	"Unable to travel / transport"
	*	ignore o/s

*	
loc v23br6 s06dq18__
loc v23cr6 s06dq19__
loc v23dr6 s06dq20__
loc v23er6 s06dq21__
tabstat `v23br6'? `v23cr6'? `v23dr6'? `v23er6'?, by(round) s(sum) 

g		ag_orgfert_no_label=.
la var	ag_orgfert_no_label	"Did not apply organic fertilizer because [...]"
g 		ag_orgfert_no_cat1 = (`v23br6'7==1) if !mi(`v23br6'7)
la var	ag_orgfert_no_cat1	"Did not need"
g 		ag_orgfert_no_cat2 = (`v23br6'5==1 | `v23br6'6==1) if !mi(`v23br6'5,`v23br6'6)
la var	ag_orgfert_no_cat2	"Too expensive / could not afford"
g 		ag_orgfert_no_cat3 = (`v23br6'1==1 | `v23br6'2==1 | `v23br6'96==1) if !mi(`v23br6'1,`v23br6'2)
la var	ag_orgfert_no_cat3	"Not available"
g 		ag_orgfert_no_cat4 = (`v23br6'3==1 | `v23br6'4==1) if !mi(`v23br6'3,`v23br6'4)
la var	ag_orgfert_no_cat4	"Unable to travel / transport"

g		ag_pesticide_no_label=.
la var	ag_pesticide_no_label	"Did not apply pesticide / herbicide because [...]"
g 		ag_pesticide_no_cat1 = (`v23cr6'7==1) if !mi(`v23cr6'7)
la var	ag_pesticide_no_cat1	"Did not need"
g 		ag_pesticide_no_cat2 = (`v23cr6'5==1 | `v23cr6'6==1) if !mi(`v23cr6'5,`v23cr6'6)
la var	ag_pesticide_no_cat2	"Too expensive / could not afford"
g 		ag_pesticide_no_cat3 = (`v23cr6'1==1 | `v23cr6'2==1) if !mi(`v23cr6'1,`v23cr6'2)
la var	ag_pesticide_no_cat3	"Not available"
g 		ag_pesticide_no_cat4 = (`v23cr6'3==1 | `v23cr6'4==1) if !mi(`v23cr6'3,`v23cr6'4)
la var	ag_pesticide_no_cat4	"Unable to travel / transport"

g		ag_hirelabor_no_label=.
la var	ag_hirelabor_no_label	"Did not hire any labor because [...]"
g 		ag_hirelabor_no_cat1 = (`v23dr6'7==1) if !mi(`v23dr6'7)
la var	ag_hirelabor_no_cat1	"Did not need"
g 		ag_hirelabor_no_cat2 = (`v23dr6'2==1 | `v23dr6'5==1 | `v23dr6'96==1) if !mi(`v23dr6'2,`v23dr6'5,`v23dr6'96)
la var	ag_hirelabor_no_cat2	"Too expensive / could not afford"
g 		ag_hirelabor_no_cat3 = (`v23dr6'1==1 | `v23dr6'3==1) if !mi(`v23dr6'1,`v23dr6'3)
la var	ag_hirelabor_no_cat3	"Not available"
g 		ag_hirelabor_no_cat4 = (`v23dr6'4==1) if !mi(`v23dr6'4)
la var	ag_hirelabor_no_cat4	"Unable to travel / transport"

g		ag_draught_no_label=.
la var	ag_draught_no_label	"Did not use animal traction because [...]"
g 		ag_draught_no_cat1 = (`v23e6'7==1) if !mi(`v23e6'7)
la var	ag_draught_no_cat1	"Did not need"
g 		ag_draught_no_cat2 = (`v23e6'2==1 | `v23e6'5==1 | `v23e6'6==1) if !mi(`v23e6'2,`v23e6'5)
la var	ag_draught_no_cat2	"Too expensive / could not afford"
g 		ag_draught_no_cat3 = (`v23e6'1==1 | `v23e6'3==1) if !mi(`v23e6'1,`v23e6'3)
la var	ag_draught_no_cat3	"Not available"
g 		ag_draught_no_cat4 = (`v23e6'4==1) if !mi(`v23e6'4)
la var	ag_draught_no_cat4	"Unable to travel / transport"
	*	ignore o/s

	
*	25 Acquire full amount? 
*	The below is not perfectly comparable with other countries on this question
ta s06d1q16__1 round
g ag_fertilizer_fullq = (s06d1q16__1==0) if !mi(s06d1q16__1)
la var ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"
	
*	28	Adaptations for fertilizer issue
loc v28 s06d1q17__
tabstat `v28'?, by(round)
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat1=(`v28'1==1) if !mi(`v28'1)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
g		ag_nofert_adapt_cat2=(`v28'2==1) if !mi(`v28'2)
la var	ag_nofert_adapt_cat2	"Used lower rate of fertilizer"
g		ag_nofert_adapt_cat3=(`v28'3==1) if !mi(`v28'3)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
g		ag_nofert_adapt_cat4=(`v28'4==1) if !mi(`v28'4)	
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_nofert_adapt_cat6=(`v28'5==1) if !mi(`v28'5)	
la var	ag_nofert_adapt_cat6	"Changed crop"

/*	21	fert types tables 
loc v21 s06d1q12__
d `v21'?
tabstat `v21'?, by(round) s(sum)
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'3 `v21'4) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'1) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'2) if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"

*	29	price of fertilizer
loc v29a s06d1q13a__	//	lcu
loc v29b s06d1q13b__	//	unit
forv i=1/4 {
g ag_fertcost`i'_type	= `i'		if !inlist(`v29a'`i',.,-999) & !mi(`v29b'`i')
g ag_fertcost`i'_lcu	= `v29a'`i'	if !inlist(`v29a'`i',.,-999) & !mi(`v29b'`i')
g ag_fertcost`i'_unit	= `v29a'`i'	if !inlist(`v29a'`i',.,-999) & !mi(`v29b'`i')
}
*	no conversion for now
*	for ferttype above we combine 3 & 4 into 1, 
*/
preserve 
keep if round==16
keep hhid round s06d1q12__? s06d1q13a__? s06d1q13b__? s06d1q15__?
reshape long s06d1q12__ s06d1q13a__ s06d1q13b__ s06d1q15__, i(hhid) j(type)
keep if s06d1q12__==1
recode type (3 4=1)(2=3)(1=2), gen(t)
duplicates tag hhid t, gen(tag)
li type s06d1q12__ s06d1q13a__ s06d1q13b__ if tag>0, sepby(hhid) nol	//	one obs, very similar prices 
ta type, nol	//	determine modal type 
drop if tag>0 & type==3	//	retain the variation since 4 is less common
drop tag type
ren (s06d1q12__ s06d1q13a__ s06d1q13b__ s06d1q15__)	/*
*/	(ag_ferttype_post_cat ag_fertcost_lcu ag_fertcost_unit ag_fertcost_subj)
reshape wide ag_ferttype_post_cat ag_fertcost_lcu ag_fertcost_unit ag_fertcost_subj, i(hhid) j(t)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"

la var ag_fertcost_unit1	"Unit, Compound fertilizer"
la var ag_fertcost_lcu1		"LCU/unit, Compound fertilizer"
la var ag_fertcost_subj1	"Price change, Compound fertilizer"
la var ag_fertcost_unit2	"Unit, Nitrogen fertilizer"
la var ag_fertcost_lcu2		"LCU/unit, Nitrogen fertilizer"
la var ag_fertcost_subj2	"Price change, Nitrogen fertilizer"
la var ag_fertcost_unit3	"Unit, Phosphate fertilizer"
la var ag_fertcost_lcu3		"LCU/unit, Phosphate fertilizer"
la var ag_fertcost_subj3	"Price change, Phosphate fertilizer"
isid hhid round
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid round using `fertcost', assert(1 3) nogen

#d ; 
la def ag_fertcost_subj
	1	"Much higher"
	2	"Higher"
	3	"About the same"
	4	"Lower"
	5	"Much lower"
	6	"No fertilizer used all year"
	; la val ag_fertcost_subj?  ag_fertcost_subj; 
#d cr

*	31	manage high fertilizer price, building on v28 codes
loc v31	s06d1q16__
tabstat `v31'?, by(round)
g		ag_fertprice_adapt_label=.
g		ag_fertprice_adapt_cat2		=(`v31'1==1) if !mi(`v31'1)	
la var	ag_fertprice_adapt_cat2		"Used lower rate of fertilizer"
g		ag_fertprice_adapt_cat3		=(`v31'6==1) if !mi(`v31'6)	
la var	ag_fertprice_adapt_cat3		"Cultivated a smaller area"
g		ag_fertprice_adapt_cat11	=(`v31'2==1) if !mi(`v31'2)	
la var	ag_fertprice_adapt_cat11	"Borrowed money"
g		ag_fertprice_adapt_cat12	=(`v31'3==1) if !mi(`v31'3)	
la var	ag_fertprice_adapt_cat12	"Sold productive assets"
g		ag_fertprice_adapt_cat13	=(`v31'4==1) if !mi(`v31'4)	
la var	ag_fertprice_adapt_cat13	"Assistance from family/friends"
g		ag_fertprice_adapt_cat14	=(`v31'5==1) if !mi(`v31'5)	
la var	ag_fertprice_adapt_cat14	"Sharecropped/rented out land"

keep  hhid round ag_* crop*
isid  hhid round 
sort  hhid round 

sa "${local_storage}/tmp_BFA_agriculture.dta", replace 

u  "${local_storage}/tmp_BFA_agriculture.dta", clear

********************************************************************************
}	/*	Agriculture end	*/ 
********************************************************************************

ex

********************************************************************************
{	/*		*/ 
********************************************************************************

********************************************************************************
}	/*	end	*/ 
********************************************************************************


