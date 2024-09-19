






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
loc raw9	"${raw_hfps_tza}/r10_sect_2.dta"		;

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)9 {;
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
	"${raw_hfps_tza}/r9_sect_2.dta"
	"${raw_hfps_tza}/r10_sect_2.dta"
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
	d using "${tmp_hfps_tza}/panel/cover.dta"
	g s10q05 = cond(inlist(round,5,6,7),indiv-1,indiv)
	mer 1:1 hhid s10q05 round using "${tmp_hfps_tza}/panel/cover.dta"
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
		*	presume that indiv 5 who was the respondent in the 1,3,4,5 has respnoded again in 9
		recode respond (0=1) if hhid=="210215101005020" & round==9 & indiv==5 & testresp4==0
		recode respond (0=1) if hhid=="40313105003037" & inlist(round,5,6) & indiv==201 & testresp4==0

		*	resolved
		bys hhid round (indiv) : egen testresp5 = sum(respond)
		assert testresp5==1
	  drop testresp-testresp5

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

	sa "${tmp_hfps_tza}/panel/ind.dta", replace 


*	use individual panel to make demographics 
u "${tmp_hfps_tza}/panel/ind.dta", clear
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

sa "${tmp_hfps_tza}/panel/demog.dta", replace
 
 






