

loc explore=0
if `explore'==1 {
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
d using	"${raw_hfps_bfa}/r20_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r21_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r22_sec2_liste_membre_menage.dta"	
d using	"${raw_hfps_bfa}/r23_sec2_liste_membre_menage.dta"	

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
u	"${raw_hfps_bfa}/r20_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r21_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r22_sec2_liste_membre_menage.dta"	, clear
la li s02q07	
u	"${raw_hfps_bfa}/r23_sec2_liste_membre_menage.dta"	, clear
la li s02q07	

{
loc r=1
	u "${raw_hfps_bfa}/r`r'_sec2_liste_membre_menage.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
tempfile base
sa      `base'
foreach r of numlist 2(1)23 {
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

}

}	/*	end explore bracket	*/


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
	"${raw_hfps_bfa}/r20_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r21_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r22_sec2_liste_membre_menage.dta"	
	"${raw_hfps_bfa}/r23_sec2_liste_membre_menage.dta"	

, gen(round) force;
#d cr
	la drop _append
	la val round 
	ta round 	
	la var round	"Survey round"
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
	  d using "${tmp_hfps_bfa}/cover.dta"
		g s12q09=membres__id
		mer 1:1 hhid s12q09 round using "${tmp_hfps_bfa}/cover.dta", gen(_m)
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
		
		drop s12q09-_m
		drop ????resp*

	*	new approach, document extent of problem first 		
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
	
		*	as of v23 of the release these are all resolved 
	
		ta sex,m
		ta age,m
		ta relation,m

		*	bring in cover page
		mer m:1 hhid round using "${tmp_hfps_bfa}/cover.dta", keepus(pnl_intdate)
		ta hhid round if _merge!=3	//	all round 3
		ta member if _merge!=3	//	these are missing since _m=2
		keep if inlist(_merge,1,3)
		drop _merge
			for any sex age relation : g preX=X
	
		tabstat sex age relation if member==1, by(round) s(n)
		demographic_shifts, tofix(age) hh(hhid) ind(membres__id)
		tabstat sex age relation if member==1, by(round) s(n)
		tabstat pre* if member==1, by(round) s(n)

		for any sex age relation : compare X preX if member==1
		demographic_prepost
		mat li prepost
			for any sex age relation : drop preX 
				

		*	check hh head characteristics
		bys hhid round (membres__id) : egen headtest=sum(head)
		by  hhid round (membres__id) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		ta round if headtest==0	//	reasonable distribution, biggest case is round 1
		 	  		
		*	harmonize relation coding 
		numlabel relation, add
		ta relation,m
		numlabel relation, remove
		la li relation	//	this is the simplest coding structure in the HFPS, and is straightforward to apply to other codes, so we will rely on this. 
		recode relation (6=8), copyrest gen(pnl_rltn)	//	bin grandparent into other relation to match NGA/TZA/UGA
		la var pnl_rltn		"Relationship to household head"
		run "${do_hfps_util}/label_pnl_rltn.do"
		order pnl_rltn, a(relation)
					
		*	drop unnecessary variables
		keep round -ind_id_EHCVM member-relation_os respond
		
		isid hhid membres__id round
		sort hhid membres__id round
		sa "${tmp_hfps_bfa}/ind.dta", replace 
		u  "${tmp_hfps_bfa}/ind.dta", clear
		
		 
		