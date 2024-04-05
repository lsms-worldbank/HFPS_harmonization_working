


********************************************************************************
********************************************************************************

***********************   ********  ********     **      ***********************
***********************   ********  ********    ****     ***********************
***********************      **           **   **  **    ***********************
***********************      **          **   **    **   ***********************
***********************      **         **    ********   ***********************
***********************      **        **     ********   ***********************
***********************      **       **      **    **   ***********************
***********************      **      **       **    **   ***********************
***********************      **     ********  **    **   ***********************
***********************      **     ********  **    **   ***********************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************





*	household level detail from actual completed interview (incl. weights)


#d ; 
clear; append using
	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"
	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"
	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"
	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"
	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
, gen(round);
keep round-interviewer_id wt_round1 wt_round2 
	wt_round3 wt_panel_round3 
	wt_round4 wt_panel_round4 
	wt_round5 wt_panel_round5 
	wt_round6 wt_panel_round6 
	wt_round7 wt_panel_round7 
	wt_round8 wt_panel_round8 
	wt_round9 wt_panel_round9 
	s10q01 s10q05 s10q06 s10q06_os s10q10
	;
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)	//	only one phase for the TZ data
	isid hhid round
	sort hhid round
	order wt_*, a(frame)
	
	d
	tabstat wt_*, by(round) s(sum) format(%12.3gc)
	egen wgt = rowfirst(wt_round1 wt_round2 wt_round3 wt_round4 wt_round5 wt_round6 wt_round7 wt_round8 wt_round9)
	tabstat wt_*, by(round) s(n) format(%12.3gc)
	egen wgt_panel = rowfirst(wt_round1 wt_round2 wt_panel_round3 wt_panel_round4 wt_panel_round5 wt_panel_round6 wt_panel_round7 wt_panel_round8 wt_panel_round9)
	drop wt_*
	order wgt wgt_panel, a(t0_ea)
	la var wgt			"Sampling weight"
	la var wgt_panel	"Panel sampling weight"
	
	g wtd = !mi(wgt)
	ta round wtd
	g pwtd = !mi(wgt_panel)
	ta round pwtd
	drop wtd pwtd
	
	
	ta t0_region urban_rural, missing	//	these are the design strata from the HBS and NPS frames (tzhfwms_bid_september_2023.pdf, footnote 1 p. 7.)
	
	su, sep(0)
	
*	dates 
	li Sec2 in 1/10
	convert_date_time Sec2
	ta round if !mi(Sec2)
	g pnl_intclock = Sec2
	format pnl_intclock %tc
	drop Sec2 	
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	g long start_yr= Clockpart(pnl_intclock, "year")
	g long start_mo= Clockpart(pnl_intclock, "month")
	g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal
	/*
li interviewer_id Sec2 if round==6 & start_yr==2017
ta interviewer_id round
g odd = (start_yr==2017) if round==6 & !mi(Sec2)
ta interviewer_id odd	//	three interviewers only

sort Sec2
li hhid Sec2 if round==6 & interviewer_id==17 & !mi(Sec2), sepby(start_mo)

bys interviewer_id round start_yr : egen mindate = min(Sec2)
bys interviewer_id round start_yr : egen maxdate = max(Sec2)
bys interviewer_id round (start_yr) : egen minmindate = min(mindate)
bys interviewer_id round (start_yr) : egen maxmindate = max(mindate)
g interview_date = Sec2 if odd!=1
replace interview_date = Sec2 + (maxmindate-minmindate) if odd==1 



	g long start_yr2= Clockpart(interview_date, "year")
	g long start_mo2= Clockpart(interview_date, "month")
	g long start_dy2= Clockpart(interview_date, "day")
	
table (start_yr2 start_mo2) round, nototal	//	not fixed, ignoring for now
	*/

	
isid hhid round
sort hhid round

sa "${local_storage}/tmp_TZA_cover.dta", replace 


*	modifications for construction of grand panel 
u "${local_storage}/tmp_TZA_cover.dta", clear


egen pnl_hhid = group(hhid)
li t0_region t0_district t0_ward t0_village t0_ea in 1/10
li t0_region t0_district t0_ward t0_village t0_ea in 1/10, nol

egen pnl_admin1 = group(t0_region)
egen pnl_admin2 = group(t0_region t0_district)
egen pnl_admin3 = group(t0_region t0_district t0_ward)

ta urban_rural, m
g pnl_urban = (urban_rural==2)
g pnl_wgt = wgt 
sa "${local_storage}/tmp_TZA_pnl_cover.dta", replace 




********************************************************************************
}	/*	end Cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************



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


#d ;
loc raw1	"${raw_hfps_tza}/r1_sect_2.dta"		;
loc raw2	"${raw_hfps_tza}/r2_sect_2_6.dta"	;
loc raw3	"${raw_hfps_tza}/r3_sect_2_3b.dta"	;
loc raw4	"${raw_hfps_tza}/r4_sect_2.dta"		;
loc raw5	"${raw_hfps_tza}/r5_sect_2.dta"		;
loc raw6	"${raw_hfps_tza}/r6_sect_2.dta"		;
loc raw7	"${raw_hfps_tza}/r7_sect_2.dta"		;
loc raw8	"${raw_hfps_tza}/r8_sect_2.dta"		;

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)8 {;
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
, gen(round);

#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)	//	only one phase for the TZ data
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
		 label copy labels10 relation
		 label val relation relation
		 gen relation_os=s2q07_os
		 replace relation_os=s2q09_os if relation_os=="" & s2q09_os!=""
		
	*	respondent
	d using "${local_storage}/tmp_TZA_cover.dta"
	g s10q05 = cond(inlist(round,5,6,7),indiv-1,indiv)
	mer 1:1 hhid s10q05 round using "${local_storage}/tmp_TZA_cover.dta"
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
	drop _merge
	
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

		*	can't really resolve the remainder 
	  drop testresp-flagresp3

		*	fill in with prior round information where possible
		su
		cou
		foreach x in age sex relation {
			tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
		bys hhid indiv (round) : egen `maxmiss'= max(mi(`x'))
		by  hhid indiv (round) : egen `maxnmiss'= max(`x')
		by  hhid indiv (round) : egen `minnmiss'= min(`x')
		by  hhid indiv (round), rc0 : egen `modenmiss'= mode(`x')
		
		g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
		replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
		su `x' if `maxmiss'==1
		replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
		su `x' if `maxmiss'==1
		
		drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
			}

	*	drop unnecessary variables 
	keep phase round hhid indiv member sex age head relation relation_os respond 
	isid hhid indiv round
	sort hhid indiv round

	sa "${local_storage}/tmp_TZA_ind.dta", replace 


*	use individual panel to make demographics 
u "${local_storage}/tmp_TZA_ind.dta", clear
ta member round,m

*	respondent characteristics
foreach x in sex age head relation {
	bys hhid round (indiv) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys hhid round (indiv) : egen headtest = sum(head) 
bys hhid round (indiv) : egen resptest = sum(respond) 
bys hhid round (indiv) : egen memtest = sum(member) 
tab1 *test,m


keep if member==1

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

sa "${local_storage}/tmp_TZA_demog.dta", replace
 
 



********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment	*/ 
********************************************************************************



dir "${raw_hfps_tza}", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_1.dta"

*	s3=employment, s4=nfe, s5=tourism nfe 
d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	//	s3* 
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s3* s4* s5q*
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	//	s3q* s4q*		
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		//	s3q* s4q* 	
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	s3q* s4q* 	
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"		//	s3q*  	
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	//	s3q*
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	s3q* s4q0*

*	s3q00a is the respondent id in rounds 3, 

********************************************************************************
********************************************************************************
u hhid s3q*		using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear

g work_cur = (s3q06==1) if inlist(s3q06,1,2)
g nwork_cur=1-work_cur

ta s3q09 s3q06,m
ta s3q06 s3q10,m
ta s3q06 s3q01,m
g wage_cur = (s3q06==1 & inlist(s3q09,4,5)) if inlist(s3q06,1,2)
g biz_cur  = (s3q06==1 & inlist(s3q09,1,2)) if inlist(s3q06,1,2)
g farm_cur = (s3q06==1 & inlist(s3q09,3))	if inlist(s3q06,1,2)

*	sector 
ta s3q08b
// la li s3q08b	//	reduce these to the set of 9 for the panel
	*	categorizing 20 and 21 are particularly challenging
recode s3q08b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

**	NFE
g refperiod_nfe = (s3q15==1) if !mi(s3q15)

*	activity
ta s3q16a	//	little to no english, not much to do 
ta s3q16b
// la li s3q16b
recode s3q16b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_nfe)

*	no others available in this round 
keep hhid *_cur *_nfe
tempfile r1
sa		`r1'


********************************************************************************
********************************************************************************
u hhid s3* s4* s5q*		using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta", clear	

g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
ta s3q09b
// la li s3q09b
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week 

**	NFE
tab2 s4q00 s4q01 s4q02, first m
g refperiod_nfe = s4q00==1 | s4q02==1
g open_nfe = (s4q02==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	switched to the 9 code system 
g sector_nfe=s4q05

*	challenges 
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{
	loc v s4q08__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced by business:","",1)
	la var challenge`i'_nfe "`lbl'"
}

keep hhid *_cur *_nfe
tempfile r2
sa		`r2'

********************************************************************************
********************************************************************************
u hhid s3q* s4q*		using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta", clear			
g emp_respondent = s3q00a
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
// la li s6q09B  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week 


**	NFE
tab2 s4q00 s4q01 s4q02, first m
g refperiod_nfe = s4q00==1 | s4q02==1
g open_nfe = (s4q02==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
g sector_nfe=s4q05

*	challenges 
d s4q08__*
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{
	loc v s4q08__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced by business:","",1)
	la var challenge`i'_nfe "`lbl'"
}

keep hhid *_cur *_nfe emp_respondent
tempfile r3
sa		`r3'

********************************************************************************
********************************************************************************
u hhid s3q* s4q*		using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"	, clear	
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
// la li s6q09B  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week. Could also drop these values


**	NFE
tab2 s4q00 s4q01 s4q02, first m
g refperiod_nfe = s4q00==1 | s4q02==1
g open_nfe = (s4q02==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
g sector_nfe=s4q05

*	challenges 
d s4q08__*
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{
	loc v s4q08__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced by business:","",1)
	la var challenge`i'_nfe "`lbl'"
}

keep hhid *_cur *_nfe
tempfile r4
sa		`r4'

********************************************************************************
********************************************************************************
u hhid s3q* s4q*		using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta", clear	
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
// la li s6q09B  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week. Could also drop these values


**	NFE
tab2 s4q00 s4q01 s4q02, first m
g refperiod_nfe = s4q00==1 | s4q02==1
g open_nfe = (s4q02==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
inspect s4q05
g sector_nfe=s4q05

*	challenges 
d s4q08__*
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{
	loc v s4q08__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced by business:","",1)
	la var challenge`i'_nfe "`lbl'"
}

keep hhid *_cur *_nfe
tempfile r5
sa		`r5'

********************************************************************************
********************************************************************************
u hhid s3q*				using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	, clear	
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
// la li s3q09b  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
assert hours_cur<=168 if !mi(hours_cur)


**	no NFE in r6


keep hhid *_cur 
tempfile r6
sa		`r6'

********************************************************************************
********************************************************************************
u hhid s3q*				using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	, clear
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)

*	sector
// la li s3q09b  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
assert hours_cur<=168 if !mi(hours_cur)


**	no NFE in r7


keep hhid *_cur 
tempfile r7
sa		`r7'

********************************************************************************
********************************************************************************
u hhid s3q* s4q0*		using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)


*	sector
// la li s3q09b  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
assert hours_cur<=168 if !mi(hours_cur)


**	NFE
tab2 s4q00 s4q01 s4q02, first m
g refperiod_nfe = s4q00==1 | s4q02==1
g open_nfe = (s4q02==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
inspect s4q05
g sector_nfe=s4q05

*	challenges 
d s4q08__*
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{
	loc v s4q08__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced by business:","",1)
	la var challenge`i'_nfe "`lbl'"
}

keep hhid *_cur *_nfe
tempfile r8
sa		`r8'


********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
clear 
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8', gen(round)
	la drop _append
	la val round 
	ta round 	
	isid hhid round
	sort hhid round
	
	ds, not(type string) detail
	tabstat `r(varlist)', by(round) s(sum) format(%12.3gc)

la var work_cur			"Respondent currently employed"
la var nwork_cur		"Respondent currently unemployed"
la var wage_cur			"Respondent mainly employed for wages"
la var biz_cur			"Respondent mainly employed in household enterprise"
la var farm_cur			"Respondent mainly employed on family farm"

run "${hfps_github}/label_emp_sector.do"
la val sector_cur sector_nfe emp_sector
la var sector_cur		"Sector of respondent current employment"
la var hours_cur		"Hours respondent worked in current employment"
assert hours_cur<=168 if !mi(hours_cur)

la var	refperiod_nfe	"Household operated a non-farm enterprise (NFE) since previous contact"
la var	open_nfe		"NFE is currently open"
la var	sector_nfe		"Sector of NFE"

d *_cur *_nfe

d using "${local_storage}/tmp_TZA_ind.dta"
g indiv = emp_respondent
mer m:1 hhid round indiv using "${local_storage}/tmp_TZA_ind.dta", keep(1 3) 
ta round _m
ta respond if _m==3,m	//	99% same person 
g emp_resp_main = respond
foreach x in sex age head relation {
g emp_resp_`x' = `x' 
}
drop indiv-_merge
order emp_resp_*, a(emp_respondent)
la var emp_resp_main		"Employment respondent = primary respondent"
la var emp_resp_sex			"Sex of employment respondent"
la var emp_resp_age			"Age of employment respondent"
la var emp_resp_head		"Employment respondent is head"
la var emp_resp_relation	"Employment respondent relationship to household head"

isid hhid round
sort hhid round

sa "${local_storage}/tmp_TZA_employment.dta", replace 

********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************




dir "${raw_hfps_tza}", w


d s6* using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
// d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"
// d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"
// d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"
// d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
// d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"
d s12* using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
d s12* using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"



*	adopting a round-specific approach since changes occurred between rounds
u "${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear

tab1 s6*,m
d s6*, varlist
// la li `r(varlist)'
g worried	= s6q01==1 if inlist(s6q01,1,2)
g healthy	= s6q02==1 if inlist(s6q02,1,2)
g fewfood	= s6q03==1 if inlist(s6q03,1,2)
g skipped	= s6q04==1 if inlist(s6q04,1,2)
g ateless	= s6q05==1 if inlist(s6q05,1,2)
g runout	= s6q06==1 if inlist(s6q06,1,2)
g hungry	= s6q07==1 if inlist(s6q07,1,2)
g whlday	= s6q08==1 if inlist(s6q08,1,2)

keep hhid worried-whlday
g round=1, b(hhid)
tempfile r1
sa		`r1'


u "${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta", clear

tab1 s12**,m
d s12**, varlist
// la li `r(varlist)'
g worried	= s12aq1==1 if inlist(s12aq1,1,2)
g healthy	= s12aq2==1 if inlist(s12aq2,1,2)
g fewfood	= s12aq3==1 if inlist(s12aq3,1,2)
g skipped	= s12aq4==1 if inlist(s12aq4,1,2)
g ateless	= s12aq5==1 if inlist(s12aq5,1,2)
g runout	= s12aq6==1 if inlist(s12aq6,1,2)
g hungry	= s12aq7==1 if inlist(s12aq7,1,2)
g whlday	= s12aq8==1 if inlist(s12aq8,1,2)

keep hhid worried-whlday
g round=  7, b(hhid)
tempfile r7
sa		`r7'


u "${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear

tab1 s12**,m
d s12**, varlist
// la li `r(varlist)'
g worried	= s12aq1==1 if inlist(s12aq1,1,2)
g healthy	= s12aq2==1 if inlist(s12aq2,1,2)
g fewfood	= s12aq3==1 if inlist(s12aq3,1,2)
g skipped	= s12aq4==1 if inlist(s12aq4,1,2)
g ateless	= s12aq5==1 if inlist(s12aq5,1,2)
g runout	= s12aq6==1 if inlist(s12aq6,1,2)
g hungry	= s12aq7==1 if inlist(s12aq7,1,2)
g whlday	= s12aq8==1 if inlist(s12aq8,1,2)

keep hhid worried-whlday
g round=  8, b(hhid)
tempfile r8
sa		`r8'

clear 
append using `r1' `r7' `r8'
	ta round 	
	isid hhid round
	


tabstat worried healthy fewfood skipped ateless runout hungry whlday, by(round) s(n)

*	get weight and hhsize vars 
d using "${local_storage}/tmp_TZA_cover.dta"
mer 1:1 round hhid using "${local_storage}/tmp_TZA_cover.dta", keepus(s10q01 urban_rural wgt)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
assert min==max
keep if _m==3
drop _m min max
ta s10q01 round

mer 1:1 round hhid using "${local_storage}/tmp_TZA_demog.dta", keepus(hhsize)
ta round _m
ta s10q01 _m
keep if _m==3
drop _m s10


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

tabstat worried-whlday, by(round) 


g na="NA" 
g urban = (urban_rural=="1. RURAL":urban_rural)

cap : erase "${local_storage}/FIES_TZA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_TZA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	Worried infit is 1.334-> excluded. All other infit are inrange(0.7,1.3) 
	2	Equating: Skipped very low at 0.69. healthy and runout are also >0.35
		1	dropped skipped => healthy and runout still>0.35
		2	dropped healthy => remainder <=.35 
	3	downloaded and saved as FIES_TZA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
	Moderate or Severe	MoE	Severe	MoE
1	50.77	3.95	18.36	2.90
7	54.90	6.92	20.12	4.88
8	37.52	6.73	10.30	3.63
*/

levelsof round, loc(rounds)
foreach r of local rounds {
	cap : erase "${local_storage}/FIES_TZA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_TZA_r`r'_in.csv", delim(",")
}



/*
round 1 
	1	Worried infit is 1.259, which is inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped and healthy are >.35, as is runout. After dropping 
		skipped and healthy, runout is .4, but we retain for consistency (and to
		keep at least 5 items for analysis)
	3	downloaded and saved as FIES_TZA_r1_out.csv

round 7 
	1	Worried infit is 1.387, otherwise inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped >.35, as is runout and fewfood. healthy is .14, but we 
		drop for consistency. After dropping remainder are <=.35
	3	downloaded and saved as FIES_TZA_r7_out.csv

round 8 
	1	Worried infit is 1.322, otherwise inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped >.35, as is runout and fewfood. healthy is .34, but we 
		drop for consistency. After dropping skipped and healthy, remainder are <=.35
	3	downloaded and saved as FIES_TZA_r8_out.csv



*/

	
*	before merging, need to account for the exclusion of -worried- from the analysis
ren RS fies_rawscore
la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

egen RS = rowtotal(/*worried*/ healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(/*worried,*/healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${local_storage}/FIES_TZA_out.csv", varn(1) clear
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
mer m:1 RS using `out',	assert(3) nogen

tabstat fies_mod fies_sev [aw=wgt_hh], by(round)

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
ren fies_??? fies_pooled_???


	preserve 
levelsof round if !mi(RS), loc(rounds)
loc toappend ""
foreach r of local rounds {
import delimited using "${local_storage}/FIES_TZA_r`r'_out.csv", varn(1) clear
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

mer m:1 RS round using `tomerge', assert(3) nogen

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

// ren RS fies_rawscore	//->	this step was moved earlier to manage the worried change
// la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

keep round hhid fies_*
sa "${local_storage}/tmp_TZA_fies.dta", replace
	
	
	
********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************


dir "${raw_hfps_tza}", w	//	12b is the target 


d using	"${raw_hfps_tza}/r7_sect_12b.dta"
d using	"${raw_hfps_tza}/r8_sect_12b.dta"

u	"${raw_hfps_tza}/r7_sect_12b.dta", clear
// la li foodcat_cd
u	"${raw_hfps_tza}/r8_sect_12b.dta", clear
// la li foodcat_cd


#d ; 
clear; append using 
	"${raw_hfps_tza}/r7_sect_12b.dta"
	"${raw_hfps_tza}/r8_sect_12b.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
#d cr 

isid hhid round foodcat_cd



g		days = s12bq1 if inrange(s12bq1,0,7)
replace days = 0 if s12bq1==.
replace days = 7 if s12bq1>7 & !missing(s12bq1)
g dum = (inrange(days,1,7))


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode foodcat_cd (10=1)(20=2)(30=12)(40=13)(50 51=9)(52=8)(53=11)(54=10)	/*
*/	(60=5)(61=3)(62=4)(70=7)(71=6)(80=14)(90=15)(100=16) , copyrest gen(HDDS_codes)
				/*	tubers were omitted	*/ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
*	make HDDS scores to combine at household level
bys hhid round HDDS_codes (foodcat_cd) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_codes : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode foodcat_cd
	(10=1)	/*	cereals, grains, cereal products	*/
	(20=2)	/*	roots, tubers, plantains	*/
	(30=3)	/*	nuts, pulses	*/
	(60/62=4)	/*	vegetables	*/
	(70/71=5)	/*	fruits	*/
	(50/54=6)	/*	meat, fish, eggs	*/
	(40=7)	/*	dairy	*/
	(90=8)	/*	sugar, sugar products, honey	*/
	(80=9)	/*	oils, fats	*/
	(100=.)	/*	condiments	*/ 
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
bys hhid round fcs_cats (foodcat_cd) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${local_storage}/tmp_TZA_dietary_diversity.dta", replace 




********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************


dir "${raw_hfps_tza}", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_1.dta"

*	s3=employment, s4=nfe, s5=tourism nfe 
// d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	//	s3* 
// d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s3* s4* s5q*
d using	"${raw_hfps_tza}/r3_sect_11.dta"	//	s3q* s4q*		
// d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		//	s3q* s4q* 	
// d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	s3q* s4q* 	
// d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"		//	s3q*  	
// d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	//	s3q*
// d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	s3q* s4q0*

d using	"${raw_hfps_tza}/r8_sect_12b.dta"	//	s3q* s4q*		

*	only one shocks module in the current version of the public data
u "${raw_hfps_tza}/r3_sect_11.dta", clear
	isid hhid shock_cd
	sort hhid shock_cd
	
	ds s11*, not(type string)
	tabstat `r(varlist)', by(shock_cd) s(sum) format(%12.3gc)

	
	tab2 shock_cd s11q01 s11q03, first m

	*	in principle, we could say that this recall data is equivalent to
	*	round 2 data and make two rounds out of this 
	drop t0_region-clusterID
	*	automatically capture variable labels to be re-applied after reshape gymnastics
	ds s11q02__*, not(type string)
	loc vars `r(varlist)'
	foreach v of local vars {
		loc i = substr("`v'",strpos("`v'","__")+2,length("`v'")-strpos("`v'","__")-1)
		loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
		loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
		loc clnlbl`i' = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
	}
	*	reshape gymnastics
	reshape long s11q02__ s11q04__, i(hhid shock_cd) j(cope_cd)
	ren (s11q01 s11q02__ s11q02_os s11q03 s11q04__ s11q04_os)	/*
	*/	(shock_yn2 shock_cope_2 os2 shock_yn3 shock_cope_3 os3)
	reshape long shock_yn shock_cope_ os, i(hhid shock_cd cope_cd) j(round)
	reshape wide shock_cope_, i(hhid shock_cd round) j(cope_cd)
	order shock_yn, a(round)
	*	automatically re-apply variable labels captured in locals above 
	ds shock_cope_*, not(type string)
	loc vars `r(varlist)'
	foreach v of local vars {
		loc i = substr("`v'",length("shock_cope_")+1,length("`v'")-length("shock_cope_"))
		la var `v' "`clnlbl`i'' to cope with shock"	
	}	
	g shock_cope_os = strtrim(lower(os))
	la var shock_cope_os	"Specify other way to cope with shock"
	d shock_cope_*
	
	ta shock_cd round if shock_yn==1
	
	recode shock_yn (2=0) 
	la val shock_yn 	//	get rid of old label 
	la var shock_yn	"Affected by shock since last interaction"
	
	
	keep hhid round shock*
	isid hhid round shock_cd
	sort hhid round shock_cd
	
*	harmonize shock_code
run "${hfps_github}/label_shock_code.do"
// la li shock_cd shock_code 
g shock_code=shock_cd+4, a(shock_cd)
recode shock_code (9=10)(10=11)(11=12)(12=1)(100=96)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shock_cd shock_code
drop shock_cd

	isid hhid round shock_code
	sort hhid round shock_code
   sa "${local_storage}/tmp_TZA_shocks.dta", replace 

	
*	move to household level for analysis
u  "${local_storage}/tmp_TZA_shocks.dta", clear

ta shock_code
// la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & shock_yn==1) if !mi(shock_yn)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
ds shock*, has(type string)
drop `r(varlist)'

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
sa "${local_storage}/tmp_TZA_hh_shocks.dta", replace 
	
********************************************************************************
}	/*	Shocks / Coping end	*/ 
********************************************************************************


********************************************************************************
{	/*	label_item	*/ 
********************************************************************************
cap :	program drop	label_item
		program define	label_item
cap : la drop item
#d ; 
la def item 
	105		"maize flour"	
	102		"rice"
	202		"cassava flour"	
	1081	"wheat flour"
	301		"sugar"
	1001	"cooking oil"
	401		"dry beans"
	802		"beef"
	1003	"salt"
	
	

	6001	"maize seed"
	6002	"soya seed"
	6003	"bean seed"
	
	7001	"petrol"
	7002	"diesel"
	7003	"paraffin"
	7004	"LPG"	/*	liquefied petroleum gas (bottled)	*/
	7005	"kerosene"	
	
	8001	"fuel for car"
	8002	"fuel for motorcycle"
	8003	"transport to nearest market"
	9001	"chemical fertilizer"
	
	
	;
#d cr 
		
		end
********************************************************************************
}	/*	label_item end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************


dir "${raw_hfps_tza}", w


d using	"${raw_hfps_tza}/r6_sect_6.dta"
d using	"${raw_hfps_tza}/r7_sect_6.dta"
d using	"${raw_hfps_tza}/r7_sect_7.dta"
d using	"${raw_hfps_tza}/r7_sect_8.dta"	//	ignoring transportation for now 
d using	"${raw_hfps_tza}/r8_sect_6.dta"
d using	"${raw_hfps_tza}/r8_sect_7.dta"
d using	"${raw_hfps_tza}/r8_sect_8.dta"

u	"${raw_hfps_tza}/r6_sect_6.dta", clear 
// la li item_cd
u	"${raw_hfps_tza}/r7_sect_6.dta", clear 
// la li item_cd 
u	"${raw_hfps_tza}/r7_sect_7.dta", clear 
// la li fuel_cd
u	"${raw_hfps_tza}/r7_sect_8.dta", clear 
// la li destination_cd
u	"${raw_hfps_tza}/r8_sect_6.dta", clear 
// la li item_cd 
u	"${raw_hfps_tza}/r8_sect_7.dta", clear 
// la li fuel_cd
u	"${raw_hfps_tza}/r8_sect_8.dta", clear 
// la li destination_cd


u	"${raw_hfps_tza}/r6_sect_6.dta", clear 
#d ; 
recode item_cd 
          (10=105) 	/*	Maize flour		*/
          (11=202) 	/*	Cassava flour	*/
          (13=102) 	/*	Rice			*/
          (16=1081) /*	Wheat flour		*/
          (17=301) 	/*	Sugar			*/
          (18=1001) /*	Cooking oil		*/
	, gen(item); 
#d cr 
label_item
la val item item
inspect item
assert r(N_undoc)==0
ta item_cd item 
la var item	"Item code"

decode item, gen(itemstr)
la var itemstr	"Item code"

g item_avail=(s6q1==1)
la var	item_avail	"Item is available for sale"

g unitstr = "KG"	
g price = s6q2
la var price		"Price (LCU/standard unit)"

g unitcost = s6q2	//	no units collected for TZ so these will match
la var	unitcost	"Unit Cost (LCU/unit)"

isid  hhid item
keep  hhid item itemstr item_avail unitstr price unitcost 
g round=6, b(hhid)
tempfile r6
sa		`r6'




#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_7.dta"
	"${raw_hfps_tza}/r8_sect_7.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode fuel_cd 
          (1=7001) 	/*	petrol		*/
		  (2=7002)	/*	diesel		*/
		  (3=7004)	/*	lpg			*/
          (5=7005) 	/*	kerosene	*/
	, gen(item); 
#d cr 
label_item
la val item item
inspect item
assert r(N_undoc)==0
ta fuel_cd item 
la var item	"Item code"

ta s7q2	//	4 categories here 
g item_avail=(inlist(s7q2,1,2,3))
la var	item_avail	"Item is available for sale"

g unitstr = "L" 
la var unitstr		"Unit"

g price = s7q5 / s7q4
la var price		"Price (LCU/standard unit)"


isid round hhid item
keep round hhid item  item_avail unitstr price	// unitcost
tempfile fuel
sa		`fuel'

#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_6.dta"
	"${raw_hfps_tza}/r8_sect_6.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode item_cd 
          (10=105) 	/*	Maize flour		*/
          (11=102) 	/*	Rice			*/
		  (12=401)	/*	Dry beans	*/
		  (14=802)	/*	beef/sausage	*/
          (16=301) 	/*	Sugar			*/
          (17=1001) /*	Cooking oil		*/
          (18=1003) /*	Salt		*/
	, gen(item); 
#d cr 
label_item
la val item item
inspect item
assert r(N_undoc)==0
ta item_cd item 
la var item	"Item code"

g item_avail=(s6q1==1)
la var	item_avail	"Item is available for sale"

g unitstr = "KG" 
la var unitstr		"Unit"

g price = s6q5
la var price		"Price (LCU/standard unit)"


isid round hhid item
keep round hhid item  item_avail unitstr price	// unitcost 


g unitcost = price, a(price)	//	no units collected for TZ so these will match
la var	unitcost	"Unit Cost (LCU/unit)"

append using `fuel'
isid round hhid item
decode item, gen(itemstr)
la var itemstr	"Item code"
append using `r6'
isid round hhid item
sort round hhid item


   sa "${local_storage}/tmp_TZA_price.dta", replace 
   u  "${local_storage}/tmp_TZA_price.dta", clear 
ta item round	

*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)


********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************



dir "${raw_hfps_tza}", w

*	s3=employment, s4=nfe, s5=tourism nfe 
d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"			//	s5* 
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"		//	s4*
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	s4* 

*	have to harmonize prior to append 
u	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta", clear		//	s5* 
keep hhid s5q1-s5q9_os
g round=  6
tempfile r6
sa		`r6'
u	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta", clear		//	s4*
keep hhid select_s4-s4q9_os
g round=  7
tempfile r7
sa		`r7'
u	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear	//	s4* 
keep hhid select_s4a-s4q9_os
g round=  8
tempfile r8
sa		`r8'

clear
append using `r6' `r7' `r8'
la li _all

*	now that value labels are checked, combine 
foreach s5 of varlist s5* {
	loc s4 = subinstr("`s5'","s5","s4",1)
	replace `s5'=`s4' if inlist(round,7,8)
	drop `s4'
}
replace select_s4 = select_s4a if round==8
drop select_s4a


ta select_s4 round,m
ds s5*, not(type string)
tabstat `r(varlist)', by(select_s4) s(n)


loc q1 s5q1
ta `q1',m
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s5q2
ta		`q2', m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s5q3
ta		`q3', m
// la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s5q4
ta		`q4', m
// la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s5q5
ta		`q5', m
// la li	`q5'
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

// loc q6	s11bq6
// ta		`q6', m
// la li	s9q6
// g		sntmnt_last12moPricepct = `q6'
// la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s5q6
ta		`q7', m
// la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}


loc q8	s4q7	//	did not exist in round 6 
ta		`q8', m
// la li	`q8'
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s5q8
ta		`q9', m
// la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}



loc weather s5q9__
tabstat `weather'1 `weather'2 `weather'3 `weather'4 `weather'5, by(`q9') s(n)	
d `weather'1 `weather'2 `weather'3 `weather'4 `weather'5

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)5 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
la var sntmnt_weatherevent_cat5		"Storms"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${local_storage}/tmp_TZA_economic_sentiment.dta", replace 



********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************



dir "${raw_hfps_tza}", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_7.dta"

*	s3=employment, s4=nfe, s5=tourism nfe 
d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"		
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	where is s11q7* at?  


#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	
	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
, gen(round) keep(hhid  *s11*);
#d cr
replace round = round+6
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s11q1
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s11q2
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s11q3
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s11q4
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s11q5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s11q6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

keep hhid round sw_*
sa "${local_storage}/tmp_TZA_subjective_welfare.dta", replace 

********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************


dir "${raw_hfps_tza}"
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"	//	s5j & s6 




********************************************************************************
********************************************************************************

u t0_region-hhid s14* using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s14q1
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	2	able to farm normally 
loc v2	s14q4
ta `v2'
g		ag_normal_yn = (`v2'==1) if !mi(`v2')
la var	ag_normal_yn	"Able to conduct agricultural s14qtivies normally"

*	5	reason respondent not able to conduct normal farming activities
loc v3 s14q5_
d `v3'*
tabstat `v3'? `v3'1?, s(sum)

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
egen	ag_resp_no_farm_cat2 = anymatch(`v3'1) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
egen	ag_resp_no_farm_cat4a = anymatch(`v3'2) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4a		"Unable to acquire / transport seeds"
egen	ag_resp_no_farm_cat4b = anymatch(`v3'3) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_resp_no_farm_cat4c = anymatch(`v3'4) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4c		"Unable to acquire / transport other inputs"
egen	ag_resp_no_farm_cat4 = anymatch(`v3'2 `v3'3 `v3'4) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
egen	ag_resp_no_farm_cat5 = anymatch(`v3'5) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
egen	ag_resp_no_farm_cat6 = anymatch(`v3'6) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
egen	ag_resp_no_farm_cat7 = anymatch(`v3'11) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
egen	ag_resp_no_farm_cat8 = anymatch(`v3'7 `v3'8) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat8		"Climate"
egen	ag_resp_no_farm_cat9 = anymatch(`v3'9) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat9		"Pests"
egen	ag_resp_no_farm_cat10 = anymatch(`v3'10) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat10		"Insecurity"

*	4	total cultivated area
loc v4 s14q6
su `v4',d
g		ag_total_ha = `v4' * 0.40468564224 if `v4'>0
la var	ag_total_ha	"Total area under all crops (ha)"

*	5	not able to conduct hh ag activities
loc v5 s14q2_
d `v5'*,f
tabstat `v5'? `v5'1?
ta s14q2_96_os
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
egen	ag_nogrow_cat2 = anymatch(`v5'1) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
egen	ag_nogrow_cat4a = anymatch(`v5'2) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
egen	ag_nogrow_cat4b = anymatch(`v5'3) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_nogrow_cat4c = anymatch(`v5'4) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = anymatch(`v5'2 `v5'3 `v5'4) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
egen	ag_nogrow_cat5 = anymatch(`v5'5) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
egen	ag_nogrow_cat6 = anymatch(`v5'6) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
egen	ag_nogrow_cat7 = anymatch(`v5'11) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
egen	ag_nogrow_cat8 = anymatch(`v5'7 `v3'8) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat8		"Climate"
egen	ag_nogrow_cat9 = anymatch(`v5'9) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat9		"Pests"
egen	ag_nogrow_cat10 = anymatch(`v5'10) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat10		"Insecurity"
	
*	6	not able to access fertilizer 
loc v6 s14q3
d `v6',f
ta `v6'
la li labels47
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
egen	ag_nofert_cat1=anymatch(`v6') if ag_nogrow_cat4b==1, v(1)
la var	ag_nofert_cat1	"No supply of fertilizer"
egen	ag_nofert_cat2=anymatch(`v6') if ag_nogrow_cat4b==1, v(2)
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
egen	ag_nofert_cat3=anymatch(`v6') if ag_nogrow_cat4b==1, v(3)
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"


*	7	main crops, taking first 
loc v7 s14q7 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	10 area planted
loc v10	s14q8
su `v10',d	//	why are zero values present? 
g		ag_plant_ha = `v10' * 0.40468564224 if `v10'>0
la var	ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
loc v11 s14q9
ta `v11'
d  `v11'
la li labels50
g ag_plant_vs_prior=`v11' if inrange(`v11',1,6)
recode  ag_plant_vs_prior (.=6) if `v11'==-97
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

*	12	harvest expectation ex post
loc v12	s14q11
ta `v12'
d  `v12'
la li labels51
g ag_postharv_subj=`v12' 
la var ag_postharv_subj	"Subjective assessment of harvest ex-post"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_postharv_subj ag_subjective_assessment


*	14	completed harvest quantity
ta s14q8 if s14q10==0,m
ta s14q10 if s14q8==0,m	
loc v14 s14q10
su `v14', d
d  `v14'
g		ag_postharv_kg		= `v14'		
la var	ag_postharv_kg		"Completed harvest quantity (kg)"


*	15	normally sell 
loc v15	s14q12
ta `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
loc v16	s14q13
ta `v16'
g		ag_sale_current = (`v16'==1) if !mi(`v16')
la var	ag_sale_current		"Main crop was sold from most recent harvest"

*	17a	Post-sale subjective assessment
loc v17	s14q14
ta `v17'
g		ag_postsale_subj = `v17' if !mi(`v17')
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	Reasoning for subjective assessment of sales
loc v18	s14q15
ta `v18'
d  `v18'
la li labels55
ta s14q15 s14q14,m	//	meaning is unclear when s14q14==3. WIll ignore these, consistent with other rounds
/*	emulating code structure from Uganda*/
g		ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
g		ag_salesubj_why_cat1	= (`v18'==1 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat2	= (`v18'==1 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat3	= (`v18'==2 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat4	= (`v18'==2 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat5	= (`v18'==3 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat6	= (`v18'==3 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat7	= (`v18'==4 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat8	= (`v18'==4 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat9	= (`v18'==5 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat10	= (`v18'==5 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)

la var	ag_salesubj_why_cat1	"Harvested more"
la var	ag_salesubj_why_cat2	"Harvested less"
la var	ag_salesubj_why_cat3	"Sold higher quantities"
la var	ag_salesubj_why_cat4	"Sold lower quantities"
la var	ag_salesubj_why_cat5	"Incured higher production costs"
la var	ag_salesubj_why_cat6	"Incureed lower production costs"
la var	ag_salesubj_why_cat7	"Prices were higher"
la var	ag_salesubj_why_cat8	"Prices were lower"
la var	ag_salesubj_why_cat9	"Sold in main market instead of farmgate"
la var	ag_salesubj_why_cat10	"Sold at farmgate instead of main market"


*	19	inorg fertilizer dummy
loc v19 s14q16
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s14q18_
d `v21'*
tabstat `v21'?, s(sum)
ta `v21'8_os
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'1 `v21'4 `v21'6 ) if ag_inorgfert_post==1, v(1)	//	following on Uganda, binning DAP into compound fertilizer
egen	ag_ferttype_post_cat2 = anymatch(`v21'2 `v21'5 ) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'3 `v21'7 ) if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"


*	22	fertilizer applied quantity
loc v22	s14q20_
d  `v22'*	
tab1 `v22'*	
g		ag_fertpost_tot_kg	= `v22'1 if `v22'1>0
la var	ag_fertpost_tot_kg	"Total quantity of fertilizer on all plots (kg)"

*	23 reason no [input]
loc v23 s14q17
ta `v23'
la li labels57
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',1,2)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',3)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',4)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"
g 		ag_inorgfert_no_cat4 = (inlist(`v23',5)) if !mi(`v23')
la var	ag_inorgfert_no_cat4	"Unable to access due to security issue"

*	24	fertilizer acquired quantity
loc v24	s14q19_
d  `v24'*
ta `v24'2	//	all are standard units (kg or l)
g		ag_fertpurch_tot_kg	= `v24'1 if `v24'1>0
la var	ag_fertpurch_tot_kg	"Total quantity of fertilizer acquired (kg)"

*	25 acquire full amount? 
loc v25 s14q21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	s14q22_
d  `v26'*
ta `v26'2
g		ag_fertpurch_ante_kg	= `v26'1 if `v26'1>0
la var	ag_fertpurch_ante_kg	"Total quantity of fertilizer still desired (kg)"

*	27	reason couldn't acquire fertilizer
loc v27	s14q23
ta `v27'
d  `v27'
la li labels62
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
egen	ag_fert_partial_cat2 = anymatch(`v27') if !mi(`v27'), v(2)
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
egen	ag_fert_partial_cat3 = anymatch(`v27') if !mi(`v27'), v(1 3)
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 s14q24_
d `v28'*
tabstat `v28'? `v28'??, s(sum)
ta `v28'96_os
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
egen	ag_nofert_adapt_cat1=anymatch(`v28'1) if !mi(`v28'1), v(1)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
egen	ag_nofert_adapt_cat2=anymatch(`v28'2) if !mi(`v28'2), v(1)
la var	ag_nofert_adapt_cat2	"Used lower rate of fertilizer"
egen	ag_nofert_adapt_cat3=anymatch(`v28'3) if !mi(`v28'3), v(1)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
egen	ag_nofert_adapt_cat4=anymatch(`v28'4) if !mi(`v28'4), v(1)
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
egen	ag_nofert_adapt_cat5=anymatch(`v28'5) if !mi(`v28'5), v(1)
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"


*	29	price of fertilizer
d s14q25_1?
d s14q25_?a
la li labels63
tab1 s14q25_3?
compare s14q25_1a s14q25_1d	//	majority are equal, let's rule out zero + u/q differences and compare
loc y s14q25_
foreach x in a b c d e f g	{
	g `y'4`x'= `y'1`x' / (`y'2`x' * cond(inlist(`y'3`x',2,4),.001,1)), a(`y'3`x')
}
tabstat s14q25_4?, s(n me sd min p1 p5 p50 p95 p99 max) format(%12.3gc) c(s)
li s14q25_?a if s14q25_4a>9000 & !mi(s14q25_4a)
li s14q25_?b if s14q25_4b>9000 & !mi(s14q25_4b)
li s14q25_?e if s14q25_4e>9000 & !mi(s14q25_4e)
li s14q25_?g if s14q25_4g>9000 & !mi(s14q25_4g)

su s14q25_4a s14q25_4d s14q25_4f, d
compare s14q25_4a s14q25_4d
compare s14q25_4a s14q25_4f
compare s14q25_4d s14q25_4f
	*	unlike the other situations, we do not have consistency between these prices 
	*	algorithm to select/construct price data: 
	*	1	fertcat shall = the three basic types following derinitions in ag_ferttype_post_cat
	*	2	modal unit, using minmode to prefer kg to gram, L to mL, kg to L
	*	3	quantity/lcu = median where unit=modal unit
	*	4	price = median lcu / median quant
preserve 
keep hhid  	s14q25_??
ren (s14q25_?a s14q25_?b s14q25_?c s14q25_?d s14q25_?e s14q25_?f s14q25_?g)	/*
*/	(q?1 q?2 q?3 q?4 q?5 q?6 q?7)
ren (q1? q2? q3? q4?)(  lcu? quant?  unit? price?)
d
reshape long lcu quant unit price, i(hhid) j(ferttype) 
recode ferttype (1 4 6=1)(2 5=2)(3 7=3), gen(fertcat)
sort hhid fertcat ferttype
by hhid fertcat : egen modal_unit = mode(unit), minmode
keep if !mi(modal_unit) & unit==modal_unit
collapse (median) quant unit lcu price, by(hhid fertcat)
ren (quant unit lcu price)(ag_fertcost_quant ag_fertcost_unit ag_fertcost_lcu ag_fertcost_price)
reshape wide ag_fertcost_quant ag_fertcost_unit ag_fertcost_lcu ag_fertcost_price, i(hhid) j(fertcat)
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid using `fertcost', assert(1 3) nogen

la var	ag_fertcost_quant1	"Quantity, Compound fertilizer"
la var	ag_fertcost_unit1	"Unit, Compound fertilizer"
la var	ag_fertcost_lcu1	"LCU/unit, Compound fertilizer"
la var	ag_fertcost_price1	"LCU/standard unit, Compound fertilizer"

la var	ag_fertcost_quant2	"Quantity, Nitrogen fertilizer"
la var	ag_fertcost_unit2	"Unit, Nitrogen fertilizer"
la var	ag_fertcost_lcu2	"LCU/unit, Nitrogen fertilizer"
la var	ag_fertcost_price2	"LCU/standard unit, Nitrogen fertilizer"

la var	ag_fertcost_quant3	"Quantity, Phosphate fertilizer"
la var	ag_fertcost_unit3	"Unit, Phosphate fertilizer"
la var	ag_fertcost_lcu3	"LCU/unit, Phosphate fertilizer"
la var	ag_fertcost_price3	"LCU/standard unit, Phosphate fertilizer"


*	30	subjective change in fertilizer price vs last year
loc v30 s14q26
ta `v30'
la li labels70
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"
la copy labels70 cost_subj
la val ag_fertcost_subj cost_subj

*	31	adaptation to fertilizer prices (building on v28 codes)
loc v31	s14q27_
tabstat `v31'?
d `v31'?

g		ag_fertprice_adapt_label=.
la var	ag_fertprice_adapt_label	"Adapted to high fertilizer price by [...]"
egen	ag_fertprice_adapt_cat2		=anymatch(`v31'?) if !mi(`v31'1), v(1)
la var	ag_fertprice_adapt_cat2		"Used lower rate of fertilizer"
egen	ag_fertprice_adapt_cat3		=anymatch(`v31'?) if !mi(`v31'1), v(6)
la var	ag_fertprice_adapt_cat3		"Cultivated a smaller area"
egen	ag_fertprice_adapt_cat11	=anymatch(`v31'?) if !mi(`v31'1), v(2)
la var	ag_fertprice_adapt_cat11	"Borrowed money"
egen	ag_fertprice_adapt_cat12	=anymatch(`v31'?) if !mi(`v31'1), v(3)
la var	ag_fertprice_adapt_cat12	"Sold productive assets"
egen	ag_fertprice_adapt_cat13	=anymatch(`v31'?) if !mi(`v31'1), v(4)
la var	ag_fertprice_adapt_cat13	"Assistance from family/friends"
egen	ag_fertprice_adapt_cat14	=anymatch(`v31'?) if !mi(`v31'1), v(5)
la var	ag_fertprice_adapt_cat14	"Sharecropped/rented out land"

g round=9
keep hhid round ag_* cropcode
isid hhid round
sort hhid round


sa "${local_storage}/tmp_TZA_agriculture.dta", replace 
 



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


