


*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga1}/r1_sect_2.dta"
d using	"${raw_hfps_nga1}/r2_sect_2.dta"
d using	"${raw_hfps_nga1}/r3_sect_2.dta"
d using	"${raw_hfps_nga1}/r4_sect_2.dta"
d using	"${raw_hfps_nga1}/r5_sect_2.dta"
d using	"${raw_hfps_nga1}/r6_sect_2.dta"
d using	"${raw_hfps_nga1}/r7_sect_2.dta"
d using	"${raw_hfps_nga1}/r8_sect_2.dta"
d using	"${raw_hfps_nga1}/r8_sect_2.dta"
d using	"${raw_hfps_nga1}/r9_sect_2.dta"
d using	"${raw_hfps_nga1}/r10_sect_2.dta"
d using	"${raw_hfps_nga1}/r11_sect_2.dta"
d using	"${raw_hfps_nga1}/r12_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"	//	this is what we need for p2r2
d using	"${raw_hfps_nga2}/p2r2_sect_2a.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2a_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2b.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta"
d using	"${raw_hfps_nga2}/p2r10_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r11_sect_2.dta"


label_inventory `"${raw_hfps_nga1}"',	/*
*/	pre(`"r"') suf(`"_sect_2.dta"')	/*
*/	varname vallab 	/*vardetail varname diagnostic retain*/  
label_inventory `"${raw_hfps_nga2}"',	/*
*/	pre(`"p2r"' ) suf(`"_sect_2.dta"')	/*
*/	varname vallab 	/*vardetail varname diagnostic retain*/  

*	investigating coding for relation to head 
qui : label_inventory `"${raw_hfps_nga1}"',	/*
*/	pre(`"r"') suf(`"_sect_2.dta"')	/*
*/	vallab retain 	/*vardetail varname diagnostic*/  
li lname value label matches rounds if strpos(lname,"s2q7")>0, sepby(lname)
qui : label_inventory `"${raw_hfps_nga2}"',	/*
*/	pre(`"p2r"' ) suf(`"_sect_2.dta"')	/*
*/	vallab retain 	/*vardetail varname diagnostic*/  
li lname value label matches rounds if strpos(lname,"s2q7")>0, sepby(lname)



#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_2.dta"
	"${raw_hfps_nga1}/r2_sect_2.dta"
	"${raw_hfps_nga1}/r3_sect_2.dta"
	"${raw_hfps_nga1}/r4_sect_2.dta"
	"${raw_hfps_nga1}/r5_sect_2.dta"
	"${raw_hfps_nga1}/r6_sect_2.dta"
	"${raw_hfps_nga1}/r7_sect_2.dta"
	"${raw_hfps_nga1}/r8_sect_2.dta"
	"${raw_hfps_nga1}/r9_sect_2.dta"
	"${raw_hfps_nga1}/r10_sect_2.dta"
	"${raw_hfps_nga1}/r11_sect_2.dta"
	"${raw_hfps_nga1}/r12_sect_2.dta"
	"${raw_hfps_nga2}/p2r1_sect_2.dta"
	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"	//	this is what we need for p2r2
	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"
	"${raw_hfps_nga2}/p2r4_sect_2.dta"
	"${raw_hfps_nga2}/p2r5_sect_2.dta"
	"${raw_hfps_nga2}/p2r6_sect_2.dta"
	"${raw_hfps_nga2}/p2r7_sect_2.dta"
	"${raw_hfps_nga2}/p2r8_sect_2.dta"
	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta"
	"${raw_hfps_nga2}/p2r10_sect_2.dta"
	"${raw_hfps_nga2}/p2r11_sect_2.dta"
, gen(round);
#d cr

	la drop _append
	la val round .
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	isid hhid indiv round
	sort hhid indiv round
	format hhid %20.0f
	format indiv %9.0f
	d s2a*
	drop s2a*
	drop s6*
	drop wt_*
	drop zone-ea

	
	d
	  //demographic information
	     gen member=(s2q2==1|s2q3==1)
		 replace member = 1 if round==12	//	youth round, no comparable questions
		 gen sex=s2q5
		 gen age=s2q6
	     gen head=(s2q7==1|s2q9==1)
	     gen relation=s2q7 
		 replace relation=s2q9 if relation==. & s2q9!=.
		 label copy s2q9 relation
		 label val relation relation
		 gen relation_os=s2q7_os
		 replace relation_os=s2q9_os if relation_os=="" & s2q9_os!=""
		 		
		*	round 12 one-offs 
		replace sex = s2q5_r11 if round==12
		replace age = s2q6_r11 if round==12
		replace relation = s2q7_r11 if round==12
		replace member = s2q3_r11 if round==12
		
	  //respondent		 	  
	  ta round respondent, m	//	only available in rounds 14/15
	  d using "${tmp_hfps_nga}/cover.dta"
		g s12q9=indiv
		mer 1:1 hhid round s12q9 using "${tmp_hfps_nga}/cover.dta", keepus(s12q5 s12q9) gen(_m)
		ta round _m
		ta s12q9 if _m==2, m	//	dominated by missing
		ta s12q5 _m, m	//	most of these are just incomplete interviews
	ta _m respondent	//	imperfect... 
		keep if inlist(_m,1,3)
		g respond = (_m==3)
		ta respond respondent if inlist(round,14,15),m	//	not identical
		*	we will believe s12q9 where respond and respondent differ 
		
		 bys hhid round (indiv) : egen testresp = sum(respond)
		ta round testresp,m	//	widely distributed, rounds 12 and 19 noticeably high, serveral zero 
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
		li hhid round indiv member respond age sex relation if flagresp2==0 & (respond==1 | testresp3==0), sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the head
		recode respond (0=1) if inlist(hhid,39048,149091,160053,169065,210033,300035) & round==1 & relation==1

		bys hhid round (indiv) : egen testresp4 = sum(respond)
		by hhid : egen flagresp3 = min(testresp4)
		li hhid round indiv member respond age sex relation s12q5 if flagresp3==0 & (respond==1 | testresp4==0), sepby(hhid)
		recode respond (0=1) if hhid==120052 & round==13 & indiv==1
		recode respond (0=1) if hhid==239130 & round==23 & indiv==2
		
		*	can't really resolve the remainder 
	  drop testresp-flagresp3

	  
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
	
	levelsof hhid if y1!=y2, loc(cases)
	g zzz = y1!=y2
	sort round hhid indiv
	li round hhid indiv sex age relation member zzz if hhid==`: word 2 of `cases'', sepby(round)
	
	ta round if y1!=y2	//	no particular round where this is prominent
	duplicates report hhid indiv if y1!=y2	
	loc switch=r(unique_value)
	dis `switch' 	//	84 cases 
	qui : duplicates report hhid indiv
	loc all r(unique_value)	
	dis `all'	//	26497	
	dis round((`switch'/`all')*100,0.1)	//	0.3% of cases 
	
	g byte xxx = (y1!=y2)
	ta xxx
	by  hhid indiv (round) : egen byte yyy = max(xxx)
	by  hhid (indiv round) : egen byte zzz = max(yyy)
	

	keep if zzz==1
	la var xxx	"Gender switch case"
	la var yyy	"Individual gender switch flag"
	la var zzz	"HH gender switch flag"
	note: Dataset containing all households where a gender switch occurs for an individual in the public data
	compress
	sa "${tmp_hfps_nga}/nga_gender_switch_cases.dta", replace
    restore
	*	are these discontinuous membership? */ 
  
			ta sex,m
			ta age,m
			ta relation,m
			cleanstr relation_os
			ta str
			ta relation if !mi(str),m
			
		*	bring in cover page
		mer m:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(pnl_intdate) keep(1 3) nogen
			for any sex age relation : g preX=X

			tabstat sex age relation if member==1, by(round) s(n)
			qui : demographic_shifts , hh(hhid) ind(indiv)
			tabstat sex age relation if member==1, by(round) s(n)
			
		for any age sex relation : ta round if mi(X) & member==1
		for any sex age relation : compare X preX if member==1
		demographic_prepost
		mat li prepost
		for any sex age relation : drop preX 

		
		*	harmonize relation coding 
		numlabel relation, add
		ta relation round
		numlabel relation, remove
		la li relation	// no grandparent code
		recode relation (1=1)(2=2)(3/5=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
		la var pnl_rltn		"Relationship to household head"
		ta relation pnl_rltn, m
		ta round if relation==16
		ta round if relation==98
		recode pnl_rltn (16=3)(98=8)
	*	round 8 is the first round with both codes present
	*	investigation implemented in ${do_hfps_nga}/demographics.do

		la var pnl_rltn		"Relationship to household head"
		run "${do_hfps_util}/label_pnl_rltn.do"
		ta relation pnl_rltn
		order pnl_rltn, a(relation)
					
		*	check hh head characteristics
		bys hhid round (indiv) : egen headtest=sum(head)
		by  hhid round (indiv) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		li round hhid indiv sex age relation if headtest==2, sepby(hhid)
		ta round if headtest==0	//	aside from 12, a few in rounds 13, 18, & 23
		 	  		
** DROP UNNECESSARY VARIABLES		 
      keep phase-indiv member-relation_os respond

	  isid hhid indiv round
	  sort hhid indiv round
	  sa "${tmp_hfps_nga}/ind.dta", replace
	  u  "${tmp_hfps_nga}/ind.dta", clear

	  		
