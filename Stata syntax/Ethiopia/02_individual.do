


*	household roster 
dir "${raw_hfps_eth}", w


*	Phase 1
d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
d using	"${raw_hfps_eth}/R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"

#d ;
loc raw1  "r1_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw2  "r2_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw3  "r3_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw4  "r4_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw5  "r5_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw6  "r6_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw7  "r7_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw8  "r8_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw9  "R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"				; 
loc raw10 "R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"			; 
loc raw11 "wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"	; 
loc raw12 "wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"	; 

u "${raw_hfps_eth}/`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)12 {;
	u "${raw_hfps_eth}/`raw`r''" , clear;
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
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var1 var2 var3 if matches>=10, sep(0)
li name var1 var2 var3 if matches<10, sep(0)

li _* if name=="submissiondate", nol
*	could add in flagging variables that are of a different type, but going to just ignore for now I htink 



*	submissiondate switches to double %tc in round 7. However, we will likely not use it anyway as it drops out in round 9

#d ;
clear; append using
	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
	"${raw_hfps_eth}/R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"
	, gen(round) force;
#d cr
drop submissiondate
la drop _append
la val round 
ta round 

*	identification
duplicates report household_id individual_id round
duplicates tag household_id individual_id round, gen(tag)
li household_id individual_id round bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh if tag>0, sepby(household_id)
bys household_id (individual_id round) : egen maxtag = max(tag)
format individual_id bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh %9.3g
li household_id individual_id round bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh tag if maxtag>0, sepby(household_id)
	*	all duplicate cases have one obs with Yes new member and one with no new member, and all were yes new in the previous round. 
drop if household_id=="030714010100520052" & individual_id==2 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
drop if household_id=="120302088800703022" & individual_id==4 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
drop if household_id=="140710010701008072" & individual_id==5 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
isid household_id individual_id round
drop tag maxtag

tab2 round bi2_hhm_new bi3_hhm_stillm, first

	     gen member=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex=bi4_hhm_gender
		 gen age=bi5_hhm_age
		 recode age (-98=.)
	     gen head=(bi6_hhm_relhhh==1)
	     gen relation=bi6_hhm_relhhh 
		 la copy bi6_hhm_relhhh relation
		 la val relation relation
		 la val relation .	//	prefer the phase 2 labels 
		 recode relation (-99 -98=.)
		 replace relation=. if member!=1
		 replace head=0 if member!=1
		 gen relation_os=bi6_hhm_relhhh_other if inlist(relation,13,15)
		 
	  //respondent	
	  d using "${tmp_hfps_eth}/p1_cover.dta"
	  g ii4_resp_id = individual_id

	 /*	old investigations
	mer 1:1 household_id ii4_resp_id round using "${tmp_hfps_eth}/p1_cover.dta"
	la drop _merge
	la val _merge
	bys household_id round (individual_id) : egen _m2 = max(_m==2)
	li household_id round individual_id ii4_resp_id _me if _m2==1, sepby(household_id)
// 	li round individual_id ii4_resp_id _me if household_id=="120203010100102031", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="041013088801410025", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="050213088801502044", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="130104010100219145", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="130108010100203100", sepby(round)	//->	now addressed in fix in cover.do

	format ii4_* %9.3g
	li individual_id ii4_resp_id _me bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh if _m2==1, sepby(household_id)
		replace sex=ii4_resp_gender if _m==2

	*/
	mer 1:1 household_id ii4_resp_id round using "${tmp_hfps_eth}/p1_cover.dta", assert(1 3) keepus(ii4_resp_id ii4_resp_gender ii4_resp_age ii4_resp_relhhh)
		gen respond=(_merge==3) 
	la drop _merge
	drop _merge
	
		format ii4_* %9.3g
 ta sex ii4_resp_gender if respond==1, m
 compare age ii4_resp_age if respond==1
 ta relation ii4_resp_relhhh if respond==1, m


** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-bi8_hhm_where ii4_*

	  isid household_id individual_id round
	  sort household_id individual_id round
	  sa "${tmp_hfps_eth}/p1_ind.dta", replace

	  
	  
*	phase 2
*	household roster 
dir "${raw_hfps_eth}/*roster*", w
label_inventory "${raw_hfps_eth}", pre(wb_lsms_hfpm_hh_survey_round) suf(_roster_public.dta) vall vardetail


u 	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_roster_public.dta", clear
destring individual_id, replace	// inconsistent
tempfile r18
sa		`r18'
u 	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_roster_public.dta", clear
destring individual_id, replace	// inconsistent
tempfile r19
sa		`r19'

#d ;
clear; append using
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_roster_public.dta"
	`r18'
	`r19'
	, gen(round);
#d cr
la drop _append
la val round 
replace round=round+12	//	consistency with phase 1 
	  ta round 

// 	isid household_id individual_id round, missok	//	this no longer holds as of v15 release
	duplicates report household_id individual_id round
	duplicates tag household_id individual_id round, gen(tag)
	ta round tag
	drop tag
	ta round if mi(individual_id)
	li household_id individual_id round bi* if mi(individual_id), nol
	
	levelsof household_id if mi(individual_id)
	sort household_id round individual_id 
	li household_id individual_id round bi* if household_id=="041009010100207260", nol sepby(round)
	li household_id individual_id round bi* if household_id=="060108010100319073", nol sepby(round)
	li household_id individual_id round bi* if household_id=="070603010100105018", nol sepby(round)
	li household_id individual_id round bi* if household_id=="130106010100108072", nol sepby(round)	
		//	more complication in this last case, it's a new member of some type apparently, but the 42 year old shifts id in the subsequent rounds 
		*	enforcing de facto decisions shown in this listing exercise 
	recode individual_id (.=5)  if household_id=="041009010100207260" & round==14
	recode individual_id (.=5)  if household_id=="060108010100319073" & round==14
	recode individual_id (.=10) if household_id=="070603010100105018" & round==13	//	person not captured in round 14, but captured in round 15 (sex/age/rltn)
	recode individual_id (.=2)(2=3)  if household_id=="130106010100108072" & round==13	//	making consistent with subsequent rounds 
	*	new cases as of v15 release
	duplicates list household_id individual_id round	//	2 hh, both round 14 
	li household_id individual_id round bi* if household_id=="050808088801601058", nol sepby(round)	
	drop if household_id=="050808088801601058" & individual_id==4 & bi5_hhm_age==16 & round==14	//	The age shifts between rounds 13 & 15, but both values of the age are retained in round 14. Dropping the obs with the round 13 value on the premise that this must have been a fix implemented by an enumerator without properly deleting the member 
	drop if household_id=="050808088801601058" & individual_id==10 & bi3_hhm_stillm==0 & round==14	//	odd duplicate here 
	li household_id individual_id round bi* if household_id=="120106010100504248", nol sepby(round)
		*	honestly looks like some kind of mistake that could have occurred in an excel copy of the data somehow
		*	decision: simply dropping the individuals that are listed as no longer members 
	drop if household_id=="120106010100504248" & individual_id==6 & bi3_hhm_stillm==0 & round==14	//	2 ases
	isid household_id individual_id round
	  
	  
	     gen member=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex=bi4_hhm_gender
		 gen age=bi5_hhm_age
		 recode age (-98=.)
	     gen head=(bi6_hhm_relhhh==1)
	     gen relation=bi6_hhm_relhhh 
		 recode relation (-99 -98=.)
		 la copy bi6_hhm_relhhh relation
		 la val relation relation
		 replace relation=. if member!=1
		 replace head=0 if member!=1
		 gen relation_os=bi6_hhm_relhhh_other if inlist(relation,13,15)
		 
	  //respondent	
	  d using "${tmp_hfps_eth}/p2_cover.dta"
	  g ii4_resp_id = individual_id
	  
	mer 1:1 household_id ii4_resp_id round using "${tmp_hfps_eth}/p2_cover.dta", keepus(ii4_resp_id ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh)
		
		gen respond=(_merge==3) 
		
	la drop _merge
	la val _merge
	ta ii4_resp_id round if _merge==2	//	-96 in all cases 
	ta ii4_resp_id ii4_resp_same if _merge==2	//	some are the same as previous round somehow 
	ta ii4_resp_relhhh
	
	bys household_id round (individual_id) : egen _m2 = max(_merge==2)
	ta round _m2
// 	li household_id round individual_id ii4_resp_id ii4_resp_same sex age relation ii4_resp_gender ii4_resp_age ii4_resp_relhh _me if _m2==1, sepby(household_id)
	*	no straightforward fix is possible here 
	drop if _merge==2
	
 ta sex ii4_resp_gender if respond==1, m
 compare age ii4_resp_age if respond==1
 ta relation ii4_resp_relhhh if respond==1, m
 
	drop _merge _m2 ii4_*
	
	


** DROP UNNECESSARY VARIABLES		 
      drop key ea_id phw?* bi* cs12_round group*

	  isid household_id individual_id round
	  sort household_id individual_id round
	  sa "${tmp_hfps_eth}/p2_ind.dta", replace

	  
*	combine individual datasets
clear 
append using "${tmp_hfps_eth}/p1_ind.dta" "${tmp_hfps_eth}/p2_ind.dta", gen(phase)
la drop _append
la val phase .
la val relation relation
	isid household_id individual_id round

	*	respondent check
	bys household_id round (individual_id) : egen testresp = sum(respond)
	ta round testresp
	
	*	step 1 replace with prior round respondent if available
	bys household_id individual_id (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

	bys household_id round (individual_id) : egen testresp2 = sum(respond)
	ta round testresp2,m	//	round  13 mainly, as well as 14
	ta respond member,m
	li household_id round individual_id member respond if testresp2==0, sepby(household_id)
	by household_id : egen flagresp = min(testresp2)
	li household_id round individual_id member respond age sex testresp2 if flagresp==0, sepby(household_id)
	li household_id round individual_id member respond age sex testresp2 if flagresp==0 & (respond==1 | testresp2==0), sepby(household_id)
	*	step 2 use respondent from subsequent rounds 
	su round, meanonly
	g backwards = -1 * (round-r(max)-r(min))
	bys household_id individual_id (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 
	*	also code=1 if any singletons exist 
	bys household_id round (individual_id) : replace respond =1 if testresp2!=1 & _N==1	//	none
	
	bys household_id round (individual_id) : egen testresp3 = sum(respond)
	ta round testresp3
	ta household_id if testresp3==0
	dis r(r)	//	14 cases 
	by household_id : egen flagresp2 = min(testresp3)
	li household_id round individual_id member respond age sex relation testresp3 if flagresp2==0, sepby(household_id)
	li household_id round individual_id member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0), sepby(household_id)

	*	these primarily appear to be cases where the respondent was not captured on the household roster
	*	make some choices
	levelsof household_id if flagresp2==0, loc(cases) 
	preserve
	foreach i of local cases {
	u household_id round ii4_* if inlist(household_id,"`i'") using "${tmp_hfps_eth}/p2_cover.dta", clear
	li, sep(0)
	}
	restore	//	these are all -96 cases 
	
	*	these two cases are unique and can't be explained by the assumption that the respondent was omitted from the hh roster for some reason
	recode respond (0=1) if household_id=="130108010100301020" & individual_id==1 	//	three rounds for this hh, all affected
	recode respond (0=1) if household_id=="030404088801907006" & individual_id==2 & round==13	//	different rltn but same sex age in subsequent rounds.  

	*	round 19
	recode respond (0=1) if household_id=="010602010100216029" & individual_id==1 & round==19	//	previous rounds
	recode respond (0=1) if household_id=="010605010100313067" & individual_id==1 & round==19	//	initial round of survey. prior round person 5 drops in round 19

	*	arbitrary selections or else leave blank 
	recode respond (0=1) if household_id=="030512088800206009" & individual_id==1 & round==19	//	arbitrary
	recode respond (0=1) if household_id=="030614088801003032" & individual_id==3 & inlist(round,13,19)	//	arbitrary

	
	*	there are many round 13 cases where the round 14 respondent is added to the
	*	roster in round 14 and is absent in round 13.  This appears to be systematic,
	*	and we will treat it as such. 
	*	make a new flag variable to isolate the round 14 cases that remain
	bys household_id round (individual_id) : egen testresp4 = sum(respond)
// 	levelsof household_id if testresp4==0, loc(cases) sep(,)
// 	li household_id round individual_id member respond age sex relation testresp4 if inlist(household_id,`cases') & inlist(round,13,14), sepby(household_id)
	levelsof household_id if testresp4==0, loc(cases) clean
	
	*	add the round 14 respondent observation as the round 13 respondent for these houseohlds 
	foreach case of local cases {
	expand 2 if household_id=="`case'" & round==14 & respond==1, gen(mark)
	recode round 14=13 if mark==1
	drop mark
	}

	bys household_id round (individual_id) : egen testresp5 = sum(respond)
// 	by household_id : egen flagresp3 = min(testresp5)
// 	li household_id round individual_id member respond age sex relation testresp5 if flagresp3!=1, sepby(household_id)
	assert testresp5==1

	drop surveyed-testresp5
	
	*	new approach, document extent of problem first 		
	 	  
			  	/*	document these cases and email to Giulia Ponzini
	preserve
	*	simpler version, but this is what we need to make sense 
	bys household_id individual_id (round) : egen byte y1 = min(sex)
	by  household_id individual_id (round) : egen byte y2 = max(sex)
	ta round if y1!=y2
	ta round if y1==y2
	duplicates report household_id individual_id if y1!=y2	
	dis r(unique_value)	//	11093 cases 
	qui : duplicates report household_id individual_id
	dis r(unique_value)	//	19627 total individuals
	g byte xxx = (y1!=y2)
	ta round xxx	//	reasonably low 
	by  household_id individual_id (round) : egen byte yyy = max(xxx)
	by  household_id (individual_id round) : egen byte zzz = max(yyy)
	

	keep if zzz==1
	la var xxx	"Gender switch case"
	la var yyy	"Individual gender switch flag"
	la var zzz	"HH gender switch flag"
	note: Dataset containing all households where a gender switch occurs for an individual in the public data
	compress
// 	sa "${tmp_hfps_eth}/eth_gender_switch_cases.dta", replace
    restore
	 */
	*	a fix is in the works on this question
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
		

	*	fill in with prior round information where possible
	ta sex round,m
	ta age,m
	ta relation,m
	for var sex age : replace X=. if X<0

		*	bring in cover page
		mer m:1 household_id round using "${tmp_hfps_eth}/cover.dta", keepus(pnl_intdate)
		ta household_id round if _merge==1	//	all round 6
		ta member if _merge==1	//	almost all members
		drop _merge
			for any sex age relation : g preX=X
		tabstat sex age relation if member==1, by(round) s(n)
		demographic_shifts, hh(household_id) ind(individual_id)
		tabstat sex age relation if member==1, by(round) s(n)
			
		for any age sex relation : ta round if mi(X) & member==1
		for any sex age relation : compare X preX if member==1
		demographic_prepost
		mat li prepost
		for any sex age relation : drop preX 
				
	
		*	harmonize relation coding 
		ta relation
		la li relation	
		recode relation (-99 -98=.)(1=1)(2=2)(3 9=3)(5 10=4)(4=5)(6 11=7)(7 8 12 13=8)(15=9)(14=10), gen(pnl_rltn)
		la var pnl_rltn		"Relationship to household head"
		ta relation pnl_rltn
		run "${do_hfps_util}/label_pnl_rltn.do"
		order pnl_rltn, a(relation)
					
		*	check hh head characteristics
		bys household_id round (individual_id) : egen headtest=sum(head)
		by  household_id round (individual_id) : egen rltntest=sum(relation==1 & member==1)
		tab2 round headtest rltntest, first
		li round household_id individual_id sex age relation if headtest==2, sepby(household_id)
		ta round if headtest==0	//	round 15+ only 
		drop headtest rltntest
		
isid household_id individual_id round
sort household_id individual_id round
sa "${tmp_hfps_eth}/ind.dta", replace
u  "${tmp_hfps_eth}/ind.dta", clear

ta round member
