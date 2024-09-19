



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
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"	//	s3q* 
d using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"	//	s3q* s4q*

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

*	low revenue
ta s3q18
la li s3q18
recode s3q18 (2=3)(3=4)(5=6)(6=8)(7=9)(8=10)(9=96), gen(lowrev_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe
la drop	closed_why_nfe

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
ta s3q09b,m
ta s3q09b s3q01,m
// la li s3q09b
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week 

**	NFE
tab2 s4q00 s4q01 s4q02,  m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	switched to the 9 code system 
ta s4q05,m
tab2 s4q05 s4q00 s4q01 s4q02,first m	//	s4q01=1 is necessary but insufficient for s4q05 to be filled
g sector_nfe=s4q05
ta sector_nfe refperiod_nfe,m

mer 1:1 hhid using "${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", keepus(s3q16b) keep(1 3) nogen nolabel
recode s3q16b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(xxx)
replace sector_nfe = xxx if mi(sector_nfe) & s4q02==1

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe

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
ta s3q09b s3q01,m
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
recode hours_cur (168/max=168)	//	no more than the theoretical maximum hours in a week 


**	NFE
tab2 s4q00 s4q01 s4q02, m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
ta s4q05,m
tab2 s4q05 s4q00 s4q01 s4q02,first m	//	s4q01=1 is again necessary but insufficient for s4q05 to be filled

mer 1:1 hhid using "${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta", keepus(s4q05) update assert(1 2 3 4) keep(1 3 4) nogen nolabel
mer 1:1 hhid using "${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", keepus(s3q16b) keep(1 3) nogen nolabel

g sector_nfe=s4q05
recode s3q16b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(xxx)
replace sector_nfe = xxx if mi(sector_nfe) & s4q02==1

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe

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
tab2 s4q00 s4q01 s4q02, m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
g sector_nfe=s4q05

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe

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
tab2 s4q00 s4q01 s4q02, m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
inspect s4q05
g sector_nfe=s4q05

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe


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
tab2 s4q00 s4q01 s4q02, m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
// la li s4q05	//	9 code system 
inspect s4q05
g sector_nfe=s4q05

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe

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
u hhid s3q*		using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)


*	sector
// la li s3q09b  
ta s3q09b
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
assert hours_cur<=168 if !mi(hours_cur)


**	no NFE in r9


keep hhid *_cur 
tempfile r9
sa		`r9'

********************************************************************************
********************************************************************************
u hhid s3q* s4q0*		using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta", clear
ta s3q10 s3q01,m
g work_cur = (s3q01==1) if inlist(s3q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s3q01==1 & inlist(s3q10,4,5)) if inlist(s3q01,1,2)
g biz_cur  = (s3q01==1 & inlist(s3q10,1,2)) if inlist(s3q01,1,2)
g farm_cur = (s3q01==1 & inlist(s3q10,3))	if inlist(s3q01,1,2)


*	sector
la li s3q09b  
recode s3q09b (1 20=1)(2 3=2)(4 5=3)(6=4)(7 9=5)(8=6)(10/14=7)(15=8)(16/19 21=9), gen(sector_cur)

ta s3q15
g hours_cur=s3q15
assert hours_cur<=168 if !mi(hours_cur)


**	NFE
tab2 s4q00 s4q01 s4q02, m
g refperiod_nfe = s4q00==1 | s4q01==1
g status_nfe = s4q02
g open_nfe = (status_nfe==1) if !mi(s4q02)

*	sector 
la li s4q05	//	9 code system 
inspect s4q05
g sector_nfe=s4q05

*	closed
ta s4q03
la li s4q03
recode s4q03 (1=3)(2=4)(3=5)(4=6)(5=8)(6=9)(7=10)(8=16), copyrest gen(closed_why_nfe)
run "${do_hfps_util}/label_closed_why_nfe.do"

*	low/no revenue
ta s4q07
la li s4q07
recode s4q07 (7=8), copyrest gen(lowrev_why_nfe)
la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe lowrev_why_nfe

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
tempfile r10
sa		`r10'


********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
clear 
append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r8' `r9' `r10', gen(round)
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

run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur sector_nfe emp_sector
la var sector_cur		"Sector of respondent current employment"
ta sector_cur work_cur,m

la var hours_cur		"Hours respondent worked in current employment"
assert hours_cur<=168 if !mi(hours_cur)

ta biz_cur refperiod_nfe,m
ta round if biz_cur==1 & refperiod_nfe==0
recode refperiod_nfe (0=1) if biz_cur==1

ta status_nfe refperiod_nfe,m
la var	refperiod_nfe	"Household operated a non-farm enterprise (NFE) since previous contact"
run "${do_hfps_util}/label_status_nfe.do" 
la val status_nfe status_nfe
la var status_nfe	"Current operational status of NFE"
la var	open_nfe		"NFE is currently open"
la var	sector_nfe		"Sector of NFE"

table (round refperiod_nfe) status_nfe,m nototal
recode status_nfe (.=1) if refperiod_nfe==1 & biz_cur==1 & round!=1
recode open_nfe (.=1) if status_nfe==1
table (round refperiod_nfe) status_nfe,m nototal


ta sector_nfe refperiod_nfe, m
ta round if mi(sector_nfe) & refperiod_nfe==1	//	present in all NFE rounds
g nfe_round = inlist(round,1,2,3,4,5,8)
ta sector_nfe refperiod_nfe if nfe_round==1,m
replace sector_nfe = sector_cur if refperiod_nfe==1 & biz_cur==1 & mi(sector_nfe)

ta sector_nfe refperiod_nfe if nfe_round==1,m
qui {	/*	deal with missingness in sector	*/

*	missingness can occur if the respondent is in the same employment as previous round
	*	put in the previous round's sector if it was non-missing 
	bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

	
	*	take mode following this first round and fill in
	bys hhid (round) : egen aaa = mode(sector_nfe)
	replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	fill in with the solve ties moving away from sector 9 if there are alternatives
	bys hhid (round) : egen bbb = mode(sector_nfe), minmode
	replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
	}	/*	end missingness in sector	*/

ta sector_nfe refperiod_nfe if nfe_round==1,m


ta status_nfe refperiod_nfe,m
ta round if refperiod==1 & mi(status_nfe)	//	almost all round 1
ta round if refperiod==1 & mi(open_nfe)		//	almost all round 1

d *_cur *_nfe

d using "${tmp_hfps_tza}/panel/ind.dta"
g indiv = emp_respondent
mer m:1 hhid round indiv using "${tmp_hfps_tza}/panel/ind.dta", keep(1 3) 
ta round _m	//	round 3 
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

sa "${tmp_hfps_tza}/panel/employment.dta", replace 
ex
u "${tmp_hfps_tza}/panel/employment.dta", clear
ta sector_cur work_cur,m
ta sector_nfe refperiod_nfe,m


