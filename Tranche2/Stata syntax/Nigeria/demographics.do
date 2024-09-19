



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

*	need an automated check for value label changes
u	"${raw_hfps_nga1}/r1_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r1
sa		`r1'
u	"${raw_hfps_nga1}/r2_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r2
sa		`r2'
u	"${raw_hfps_nga1}/r3_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r3
sa		`r3'
u	"${raw_hfps_nga1}/r4_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r4
sa		`r4'
u	"${raw_hfps_nga1}/r5_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r5
sa		`r5'
u	"${raw_hfps_nga1}/r6_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r6
sa		`r6'
u	"${raw_hfps_nga1}/r7_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r7
sa		`r7'
u	"${raw_hfps_nga1}/r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r8
sa		`r8'
u	"${raw_hfps_nga1}/r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r9
sa		`r9'
u	"${raw_hfps_nga1}/r9_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r10
sa		`r10'
u	"${raw_hfps_nga1}/r10_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r11
sa		`r11'
u	"${raw_hfps_nga1}/r11_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r12
sa		`r12'
u	"${raw_hfps_nga1}/r12_sect_2.dta"		, clear
la li s2q7_r11
la copy s2q7_r11 s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r13
sa		`r13'
u	"${raw_hfps_nga2}/p2r1_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r14
sa		`r14'
u	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r15
sa		`r15'
u	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r16
sa		`r16'
u	"${raw_hfps_nga2}/p2r4_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r17
sa		`r17'
u	"${raw_hfps_nga2}/p2r5_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r18
sa		`r18'
u	"${raw_hfps_nga2}/p2r6_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r19
sa		`r19'
u	"${raw_hfps_nga2}/p2r7_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r20
sa		`r20'
u	"${raw_hfps_nga2}/p2r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${tmp_hfps_nga}/r1_s2q7"
tempfile r21
sa		`r21'

u `r1', clear
forv i=2/21 {
	mer 1:1 value label using `r`i'', gen(_`i')
}
egen matches = anycount(_2-_21), v(3)
recode _* (3=1)(else=.)
la drop _merge
la val _* .
li value label _* if matches<21, nol
sort value label
li value label matches _*, nol sep(0)
*	leave as-is for the country-specific panel, but reconcile in the grand panel


#d ; 
loc raw1	"${raw_hfps_nga1}/r1_sect_2.dta";
loc raw2	"${raw_hfps_nga1}/r2_sect_2.dta";
loc raw3	"${raw_hfps_nga1}/r3_sect_2.dta";
loc raw4	"${raw_hfps_nga1}/r4_sect_2.dta";
loc raw5	"${raw_hfps_nga1}/r5_sect_2.dta";
loc raw6	"${raw_hfps_nga1}/r6_sect_2.dta";
loc raw7	"${raw_hfps_nga1}/r7_sect_2.dta";
loc raw8	"${raw_hfps_nga1}/r8_sect_2.dta";
loc raw9	"${raw_hfps_nga1}/r9_sect_2.dta";
loc raw10	"${raw_hfps_nga1}/r10_sect_2.dta";
loc raw11	"${raw_hfps_nga1}/r11_sect_2.dta";
loc raw12	"${raw_hfps_nga1}/r12_sect_2.dta";
loc raw13	"${raw_hfps_nga2}/p2r1_sect_2.dta";
loc raw14	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta";		
loc raw15	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta";	
loc raw16	"${raw_hfps_nga2}/p2r4_sect_2.dta";			
loc raw17	"${raw_hfps_nga2}/p2r5_sect_2.dta";			
loc raw18	"${raw_hfps_nga2}/p2r6_sect_2.dta";			
loc raw19	"${raw_hfps_nga2}/p2r7_sect_2.dta";			
loc raw20	"${raw_hfps_nga2}/p2r8_sect_2.dta";			
loc raw21	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta";		

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)21 {;
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
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var1 matches if matches>=10, sep(0)
li name var1 matches if matches<10, sep(0)

*	which round is missing indiv or hhid? 
li _* matches if inlist(name,"hhid","indiv"), nol	//	how can these possibly differ? 



*	household level detail from actual completed interview (incl. weights)
u "${raw_hfps_nga1}/r8_sect_2.dta", clear
la li s2q7


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
, gen(round);
#d cr

	la drop _append
	la val round 
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
		 		 
	  //respondent		 	  
	  ta round respondent, m	//	only available in rounds 14/15
	  d using "${tmp_hfps_nga}/panel/cover.dta"
		g s12q9=indiv
		mer 1:1 hhid round s12q9 using "${tmp_hfps_nga}/panel/cover.dta", keepus(s12q5 s12q9)
		ta round _m
		ta s12q9 if _m==2, m	//	dominated by missing
		ta s12q5 _m, m	//	most of these are just incomplete interviews
	ta _m respondent	//	imperfect... 
		keep if inlist(_m,1,3)
		g respond = (_m==3)
		
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

		*	can't really resolve the remainder 
	  drop testresp-flagresp2

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
		
** DROP UNNECESSARY VARIABLES		 
      keep phase-indiv member-relation_os respond

	  isid hhid indiv round
	  sort hhid indiv round
	  sa "${tmp_hfps_nga}/panel/ind.dta", replace

	  		
			
*	use individual panel to make demographics 
u "${tmp_hfps_nga}/panel/ind.dta", clear
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
format hhid indiv %9.3g



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
			


sa "${tmp_hfps_nga}/panel/demog.dta", replace
 
	  	  ex

u  "${tmp_hfps_nga}/panel/demog.dta", clear
		  
tabstat hhsize-adulteq, by(round) s(sum)
	*	the household size captured in round 12 is anomalous due to the different nature of the sample in that round

