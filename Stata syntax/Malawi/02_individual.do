

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/sect2_household_roster_r*.dta", w

u	"${raw_hfps_mwi}/sect2_household_roster_r1.dta", clear
d using	"${raw_hfps_mwi}/sect2_household_roster_r1.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r2.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r3.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r4.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r5.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r6.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r7.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r8.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r9.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r10.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r11.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r12.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r13.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r14.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r15.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r16.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r17.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r18.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r19.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r20.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r21.dta"


*	variable label inventory
label_inventory `"${raw_hfps_mwi}"', pre(`"sect2_household_roster_r"') suf(`".dta"')	/*
*/	varname vallab 	/*vardetail varname diagnostic retain*/  

*	get round zero identification information to augment this data
#d ; 
clear; append using
	"${raw_hfps_mwi}/sect2_household_roster_r1.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r2.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r3.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r4.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r5.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r6.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r7.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r8.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r9.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r10.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r11.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r12.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r13.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r14.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r15.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r16.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r17.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r18.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r19.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r20.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r21.dta"
, gen(round); la drop _append; la val round; 
#d cr 
// isid y4 round pid
inspect pid PID
compare pid PID
replace pid=PID if mi(pid)
isid y4 round pid


		tabstat s2q2 s2q3 s2q5 s2q6 s2q7, by(round) s(n)
	     gen member=(s2q2==1|s2q3==1)
		 gen sex=s2q5
		 gen age=s2q6
	     gen head=(s2q7==1|s2q9==1)
	     gen relation=s2q7 
		 replace relation=s2q9 if relation==. & s2q9!=.
		 label copy s2q7 relation
		 label val relation relation	
		 replace relation=. if member!=1
		 replace head=0 if member!=1			 
		 gen relation_os=s2q7_os  if relation==16
		 replace relation_os=s2q9_os if relation_os=="" & relation==16

		 

		 
		*	respondent
	  d using "${tmp_hfps_mwi}/cover.dta"
	  mer 1:1 y4_hhid round pid using "${tmp_hfps_mwi}/cover.dta", keepus(s1q9 y4_hhid round pid result)
	  la val _merge
	  ta round _m, m
	  ta result _m, m
	  
	  bys y4_hhid round (pid) : egen _m2 = max(_m==2)
	  li y4 round pid s1q9 _me if _m2==1, sepby(y4)	//	 quite a few cases of missing pid leading to _m==2
	  keep if inlist(_me,1,3)
	  g respond =(_me==3)
	  
		 bys y4_hhid round (pid) : egen testresp = sum(respond)
		 ta round testresp, m	// all = 0 or 1, must infer where possible
		*	step 1 assume prior round respondent was interviewed again if available 
		bys y4_hhid pid (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

		bys y4_hhid round (pid) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	round 1 most pronounced
	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min))
		bys y4_hhid pid (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys y4_hhid round (pid) : replace respond =1 if testresp2!=1 & _N==1	//	9
		
		bys y4_hhid round (pid) : egen testresp3 = sum(respond)
		ta round testresp3
		by y4_hhid : egen flagresp2 = min(testresp3)
		li y4_hhid round pid member respond age sex relation testresp3 if flagresp2==0, sepby(y4_hhid)
		li y4_hhid round pid member respond age sex relation if flagresp2==0 & (respond==1 | testresp3==0), sepby(y4_hhid)
	  
	*	step 3 manual decision-making
		*	taking the previous round's pid as the respondent in case where member bar was not met for whole family
		recode member  (0=1) if y4_hhid=="0716-001" & round==10
		recode respond (0=1) if y4_hhid=="0716-001" & round==10 & pid==2
		
	
		*	cases where we will take the head
// 		recode respond 0=1 if y4_hhid=="2476-002" & round==14 & relation==1
// 		recode respond 0=1 if y4_hhid=="2424-001" & round==1 & relation==1
		recode respond 0=1 if y4_hhid=="0933-004" & round==14 & relation==1
		recode respond 0=1 if y4_hhid=="1394-001" & round==20 & pid==9
	  *	can't really resolve the remainder 

		bys y4_hhid round (pid) : egen testresp4 = sum(respond)
		ta round testresp3
		by y4_hhid : egen flagresp3 = min(testresp4)
	
	  drop testresp-flagresp3

		 	  
	*	new approach, document extent of problem first 		
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
	
			ta sex,m
			ta age
			bys y4_hhid pid (round) : egen issue=max(!inrange(age,0,100) & !mi(age))
			li y4 pid round age sex if issue==1, sepby(y4)
			recode age (226=22) if y4=="1006-005" & pid==2 & inrange(round,2,7)
			d using "${tmp_hfps_mwi}/cover.dta"
			mer m:1 y4_hhid round using "${tmp_hfps_mwi}/cover.dta", keepus(start_yr) assert(3) nogen
			replace age = start_yr-age if y4=="1172-001" & pid==9 & age==1977
			li y4 pid round age sex start_yr if issue==1, sepby(y4)
			drop start_yr
			ta relation
			
			tabstat sex age relation if member==1, by(round) s(n)
			demographic_shifts , hh(y4_hhid) ind(pid)
			tabstat sex age relation if member==1, by(round) s(n)
			
		for any age sex relation : ta round if mi(X) & member==1
	
		*	check hh head characteristics
		bys y4_hhid round (pid) : egen headtest=sum(head)
		by  y4_hhid round (pid) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		li round y4_hhid pid sex age relation if headtest==2, sepby(y4_hhid)
		ta round if headtest==0	//	large blip in 10, vary large uptick in rounds 15-18 
		 	  
			  
	  *	drop unnecessary variables 
	  keep y4 pid round member-relation_os respond
	  isid y4 pid round
	  sort y4 pid round
	  sa "${tmp_hfps_mwi}/ind.dta", replace
	