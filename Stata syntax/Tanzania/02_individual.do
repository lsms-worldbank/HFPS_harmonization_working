




*	two separate directories for phase 1 & 2
dir "${raw_hfps_tza}", w


u "${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta", clear
u "${raw_hfps_tza}/r5_sect_2.dta", clear

d using	"${raw_hfps_tza}/r1_sect_2.dta"
d using	"${raw_hfps_tza}/r2_sect_2_6.dta"
d using	"${raw_hfps_tza}/r3_sect_2_3b.dta"
d using	"${raw_hfps_tza}/r4_sect_2.dta"
d using	"${raw_hfps_tza}/r5_sect_2.dta"
d using	"${raw_hfps_tza}/r6_sect_2.dta"
d using	"${raw_hfps_tza}/r7_sect_2.dta"
d using	"${raw_hfps_tza}/r8_sect_2.dta"
d using	"${raw_hfps_tza}/r9_sect_2.dta"
d using	"${raw_hfps_tza}/r10_sect_2.dta"
d using	"${raw_hfps_tza}/r11_sect_2.dta"

/*
#d ;
loc raw1	"${raw_hfps_tza}/r1_sect_2.dta"		;
loc raw2	"${raw_hfps_tza}/r2_sect_2_6.dta"	;
loc raw3	"${raw_hfps_tza}/r3_sect_2_3b.dta"	;
loc raw4	"${raw_hfps_tza}/r4_sect_2.dta"		;
loc raw5	"${raw_hfps_tza}/r5_sect_2.dta"		;
loc raw6	"${raw_hfps_tza}/r6_sect_2.dta"		;
loc raw7	"${raw_hfps_tza}/r7_sect_2.dta"		;
loc raw8	"${raw_hfps_tza}/r8_sect_2.dta"		;
loc raw9	"${raw_hfps_tza}/r9_sect_2.dta"		;
loc raw10	"${raw_hfps_tza}/r10_sect_2.dta"		;
loc raw11	"${raw_hfps_tza}/r11_sect_2.dta"		;

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)11 {;
	u "`raw`r''" , clear;
	d, replace clear;
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r');
	tempfile r`r';
	sa      `r`r'';
	u `base', clear;
	mer 1:1 name using `r`r'', gen(_`r');
	sa `base', replace ;
};
u `base', clear;
#d cr 
egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=7
ta name matches if matches<7

li name var1 if matches>=7, sep(0)
li name _* if matches<7, sep(0) nol
*/


/*	variable label inventory	*/
label_inventory `"${raw_hfps_tza}"', pre(`"r"') suf(`"_sect_2.dta"')	/*
*/	varname vallab  	/* vardetail diagnostic retain*/  





*	household level detail from actual completed interview (incl. weights)
#d ; 
clear; append using
	"${raw_hfps_tza}/r1_sect_2.dta"
	"${raw_hfps_tza}/r2_sect_2_6.dta"
	"${raw_hfps_tza}/r3_sect_2_3b.dta"
	"${raw_hfps_tza}/r4_sect_2.dta"
	"${raw_hfps_tza}/r5_sect_2.dta"
	"${raw_hfps_tza}/r6_sect_2.dta"
	"${raw_hfps_tza}/r7_sect_2.dta"
	"${raw_hfps_tza}/r8_sect_2.dta"
	"${raw_hfps_tza}/r9_sect_2.dta"
	"${raw_hfps_tza}/r10_sect_2.dta"
	"${raw_hfps_tza}/r11_sect_2.dta"
, gen(round);

#d cr

	la drop _append
	la val round 
	ta round 	
// 	g phase=cond(round<=12,1,2), b(round)	//	only one phase for the TZ data
	isid hhid indiv round
	sort hhid indiv round

	
	*	clean up some initially unused vars
	drop educ_wt_r2-s3q16a_1 t0_region-clusterID
	d

	     gen member=(s2q02==1|s2q03==1)
		 gen sex=s2q05
		 gen age=s2q06
		 recode age (-98=.)
	     gen head=(s2q07==1|s2q09==1)
	     gen relation=s2q07 
		 replace relation=s2q09 if relation==. & s2q09!=.
		 label copy s2q09 relation
		 label val relation relation
		 gen relation_os=s2q07_os
		 replace relation_os=s2q09_os if relation_os=="" & s2q09_os!=""
		
	*	respondent
	d using "${tmp_hfps_tza}/cover.dta"
	g s10q05 = cond(inlist(round,5,6,7),indiv-1,indiv)
	mer 1:1 hhid s10q05 round using "${tmp_hfps_tza}/cover.dta", gen(_m)
	ta round _m
	ta s10q01 _m	//	now fixed 
	ta s10q05 if _m==2 & s10q01==1, m	//	dominated by zero
	ta indiv	//	no zero 
	ta round if s10q05==0	//	5, 6, 7
	ta s10q05 round if inlist(_m,2,3)	//	appears to be a very simple -1 for some reason
	ta s10q01 if s10q05==0
	
	drop if _m==2
	g respond = (_m==3)
	la drop _merge
	drop _m
	
		 bys hhid round (indiv) : egen testresp = sum(respond)
		ta round testresp,m	//	notably rounds 5-7
		ta respond member,m
		
		*	step 1 assume prior round respondent was interviewed again if available 
		bys hhid indiv (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (indiv) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	round 1 most pronounced
		li hhid round indiv member respond if testresp2==0, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round indiv member respond age sex testresp2 if flagresp==0, sepby(hhid)
		li hhid round indiv member respond if flagresp==0 & (respond==1 | testresp2==0), sepby(hhid)

	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min))
		bys hhid indiv (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys hhid round (indiv) : replace respond =1 if testresp2!=1 & _N==1	//	2
			
		
		bys hhid round (indiv) : egen testresp3 = sum(respond)
		ta round testresp3
		by hhid : egen flagresp2 = min(testresp3)
		li hhid round indiv member respond age sex relation testresp3 if flagresp2==0, sepby(hhid)
		li hhid round indiv member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0), sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the head
		recode respond (0=1) if round==1 & relation==1 & testresp3==0
		bys hhid round (indiv) : egen testresp4 = sum(respond)
		ta round testresp4
		by hhid : egen flagresp3 = min(testresp4)
		li hhid round indiv member respond age sex relation testresp4 if flagresp3==0, sepby(hhid)
		li hhid round indiv member respond age sex relation testresp4 if flagresp3==0 & (respond==1 | testresp3==0), sepby(hhid)

		recode respond (0=1) if hhid=="1230-001" & round==6 & relation==1 & testresp4==0
		recode respond (0=1) if hhid=="110220104001116" & inlist(round,5,6) & relation==1 & testresp4==0
		*	presume that indiv 5 who was the respondent in the 1,3,4,5 has respnoded again in 9
		recode respond (0=1) if hhid=="210215101005020" & round==9 & indiv==5 & testresp4==0
		recode respond (0=1) if hhid=="40313105003037" & inlist(round,5,6) & indiv==201 & testresp4==0

		*	resolved
		bys hhid round (indiv) : egen testresp5 = sum(respond)
		assert testresp5==1
	  drop testresp-testresp5
	drop s10q05-start_dy	//	drop components from cover dataset
	
	
	*	new approach, document extent of problem first 		
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
	
			/*	document gender switch cases and email
	preserve
	*	simpler version, but this is what we need to make sense 
	bys hhid indiv (round) : egen byte y1 = min(sex)
	by  hhid indiv (round) : egen byte y2 = max(sex)
	
// 	levelsof hhid if y1!=y2, loc(cases)
// 	g zzz = y1!=y2
// 	sort round hhid indiv
// 	li round hhid indiv sex age relation member zzz if hhid=="`: word 2 of `cases''", sepby(round)
// 	drop zzz
	
	ta round if y1!=y2	//	no particular round where this is prominent
	duplicates report hhid indiv if y1!=y2	
	loc switch=r(unique_value)
	dis `switch' 	//	173 cases 
	qui : duplicates report hhid indiv
	loc all r(unique_value)	
	dis `all'	//	19186	
	dis round((`switch'/`all')*100,0.1)	//	0.9% of cases 
	
	g byte xxx = (y1!=y2)
	ta xxx
	bys hhid indiv (round) : egen byte yyy = max(xxx)
	by  hhid (indiv round) : egen byte zzz = max(yyy)
	

	keep if zzz==1
	la var xxx	"Gender switch case"
	la var yyy	"Individual gender switch flag"
	la var zzz	"HH gender switch flag"
	note: Dataset containing all households where a gender switch occurs for an individual in the public data
	compress
	sa "${tmp_hfps_tza}/tza_gender_switch_cases.dta", replace
    restore
	*	are these discontinuous membership? */ 
	
	
  			ta sex,m
			ta age,m
			ta relation,m
			
		*	bring in cover page
		d using "${tmp_hfps_tza}/cover.dta"
// 		u "${tmp_hfps_tza}/cover.dta", clear
// 		ta s10q01
		mer m:1 hhid round using "${tmp_hfps_tza}/cover.dta", keepus(pnl_intdate s10q01)
		ta round if _merge==2	//	all round 6
		ta s10q01 _merge,m	//	almost all members
		keep if inlist(_merge,1,3)
		drop _merge s10q01
			for any sex age relation : g preX=X

			tabstat sex age relation if member==1, by(round) s(n)
			qui : demographic_shifts , hh(hhid) ind(indiv)
			tabstat sex age relation if member==1, by(round) s(n)
			
		for any age sex relation : ta round if mi(X) & member==1
		for any sex age relation : compare X preX if member==1
		demographic_prepost
		mat li prepost
		for any sex age relation : drop preX 

		
		*	check hh head characteristics
		bys hhid round (indiv) : egen headtest=sum(head)
		by  hhid round (indiv) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		assert headtest==1 & rltntest==1

		*	harmonize relation to head coding 
		ta relation,m
		la li relation
		recode relation (1=1)(2=2)(3/5 16=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
		la var pnl_rltn		"Relationship to household head"
		run "${do_hfps_util}/label_pnl_rltn.do"
		ta relation pnl_rltn
		order pnl_rltn, a(relation)

	*	drop unnecessary variables 
		mer m:1 hhid round using "${tmp_hfps_tza}/cover.dta", keepus(phase) keep(1 3) nogen
	keep phase round hhid indiv member sex age head relation pnl_rltn relation_os respond 
	isid hhid indiv round
	sort hhid indiv round

	sa "${tmp_hfps_tza}/ind.dta", replace 
	u  "${tmp_hfps_tza}/ind.dta", clear 

