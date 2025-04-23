

loc investigate=0
if `investigate'==1 {

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

u	"${raw_hfps_mwi}/sect2_household_roster_r10.dta", clear


*	variable label inventory
label_inventory `"${raw_hfps_mwi}"', pre(`"sect2_household_roster_r"') suf(`".dta"')	/*
*/	varname vallab 	/*vardetail varname diagnostic retain*/  

}	/*	close investigation brackets	*/



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
// isid y4_hhid round pid
inspect pid PID
compare pid PID
replace pid=PID if mi(pid)
isid y4_hhid round pid


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

		 *	one-offs for round 10 
		 bys y4_hhid pid (round) : replace member=member[_n-1] if round==10
		 li s2q2 s2q3 s2q5 s2q6 s2q7 current_age selected_youth if round==10 & mi(member)
		 //	assuming this is a new individual
		 recode member .=1 if round==10	//	this is one case in round 10
		 replace sex=preload_sex if round==10
		 replace age=current_age if round==10
		 replace relation=preload_relation if round==10
		 replace head=(relation==1) if round==10

		 
		*	respondent
	  d using "${tmp_hfps_mwi}/cover.dta"
	  mer 1:1 y4_hhid round pid using "${tmp_hfps_mwi}/cover.dta", keepus(s1q9 y4_hhid round pid result) gen(_m)
	  la val _m .
	  ta round _m, m
	  ta result _m, m
	  
	  bys y4_hhid round (pid) : egen _m2 = max(_m==2)
	  li y4_hhid round pid s1q9 _m if _m2==1, sepby(y4_hhid)	//	 quite a few cases of missing pid leading to _m==2
	  keep if inlist(_m,1,3)
	  g respond =(_m==3)
	  
		 bys y4_hhid round (pid) : egen testresp = sum(respond)
		 ta round testresp, m	// all = 0 or 1, must infer where possible
		recode respond (0=1) if round==10 & selected_youth==1 & testresp==0  
		drop testresp
		 bys y4_hhid round (pid) : egen testresp = sum(respond)
		 ta round testresp, m	// round 10 is sorted
		
		 
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
		li y4_hhid round pid member respond testresp3 age sex relation if flagresp2==0 & (respond==1 | testresp3==0), sepby(y4_hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the head
		recode respond 0=1 if y4_hhid=="2424-001" & round==14 & relation==1
		recode respond 0=1 if y4_hhid=="0933-004" & round==14 & relation==1
		recode respond 0=1 if y4_hhid=="2476-002" & round==1  & relation==1
		*	cases with another simple solution
		recode respond 0=1 if y4_hhid=="0685-001" & round==14 & pid==6	//	eldest member in hh in round
		recode respond 0=1 if y4_hhid=="1394-001" & round==20 & pid==9	//	PID of respondent in prior round

		bys y4_hhid round (pid) : egen testresp4 = sum(respond)
		tab2 round testresp3, first
		by y4_hhid : egen flagresp3 = min(testresp4)
		li y4_hhid round pid member respond testresp4 age sex relation if flagresp3==0 & (respond==1 | testresp4==0), sepby(y4_hhid)
		preserve 
		u if y4_hhid=="2372-004" using "${tmp_hfps_mwi}/cover.dta", clear
		li s1q9 y4_hhid round pid result, sep(0)
		restore
		*	no obvious response for this case, it appears the respondent could have moved away but is reporting about the children that are still present
	
		drop testresp-flagresp3
		drop _m _m2 
		 	  
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
			li y4_hhid pid round age sex if issue==1, sepby(y4_hhid)
			recode age (226=22) if y4_hhid=="1006-005" & pid==2 & inrange(round,2,7)
			d using "${tmp_hfps_mwi}/cover.dta"
			mer m:1 y4_hhid round using "${tmp_hfps_mwi}/cover.dta", keepus(start_yr pnl_intdate) assert(3) nogen
			replace age = start_yr-age if y4_hhid=="1172-001" & pid==9 & age==1977
			li y4_hhid pid round age sex start_yr if issue==1, sepby(y4_hhid)
			drop start_yr issue
			ta relation
			
			tabstat sex age relation if member==1, by(round) s(n)
			for any sex age relation : gen preX = X
			
			demographic_shifts , hh(y4_hhid) ind(pid)
			tabstat sex age relation if member==1, by(round) s(n)
			for any age sex relation : ta round if mi(X) & member==1

			demographic_prepost
		mat li prepost
		
			for any sex age relation : drop preX 
				
			
		*	harmonize relation coding 
		ta relation
		la li relation
		recode relation (1=1)(2=2)(3 8=3)(6 11=4)(4=5)(7 9=7)(5 10 12 98=8)(14 15 16=9)(13=10)(else=.), gen(pnl_rltn)
		la var pnl_rltn		"Relationship to household head"
		run "${do_hfps_util}/label_pnl_rltn.do"
		ta relation pnl_rltn, m
		order pnl_rltn, a(relation)
					
	
		*	check hh head characteristics
		bys y4_hhid round (pid) : egen headtest=sum(head)
		by  y4_hhid round (pid) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		li round y4_hhid pid sex age relation if headtest==2, sepby(y4_hhid)
		ta round if headtest==0	//	large blip in 10, vary large uptick in rounds 15-18 
		 	  
			  
	  *	drop unnecessary variables 
	  keep y4_hhid pid round member-relation_os respond
	  isid y4_hhid pid round
	  sort y4_hhid pid round
	  sa "${tmp_hfps_mwi}/ind.dta", replace
	  u  "${tmp_hfps_mwi}/ind.dta", clear
	