



dir "${raw_hfps_mwi}", w

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


#d ;
u "${raw_hfps_mwi}/sect2_household_roster_r1" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)20 {;
	u "${raw_hfps_mwi}/sect2_household_roster_r`r'.dta" , clear;
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
ta name matches if matches>=16
ta name matches if matches<16

levelsof name if matches>=16, clean
li name var1 if matches>=16, sep(0)
li name _* if matches<16, sep(0) nol


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
	  d using "${tmp_hfps_mwi}/panel/cover.dta"
	  mer 1:1 y4_hhid round pid using "${tmp_hfps_mwi}/panel/cover.dta", keepus(s1q9 y4_hhid round pid result)
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

	  
		
		*	fill in with prior round information where possible
		foreach x in age sex relation {
			tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
		bys y4_hhid pid (round) : egen `maxmiss'= max(mi(`x'))
		by  y4_hhid pid (round) : egen `maxnmiss'= max(`x')
		by  y4_hhid pid (round) : egen `minnmiss'= min(`x')
		by  y4_hhid pid (round), rc0 : egen `modenmiss'= mode(`x')
		
		g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
		replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
		su `x' if `maxmiss'==1
		replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
		su `x' if `maxmiss'==1
		
		drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
			}
		
	  
	  *	drop unnecessary variables 
	  keep y4 pid round member-relation_os respond
	  isid y4 pid round
	  sort y4 pid round
	  sa "${tmp_hfps_mwi}/panel/ind.dta", replace
	  
	  
*	use individual panel to make demographics 
u "${tmp_hfps_mwi}/panel/ind.dta", clear

*	respondent characteristics
foreach x in sex age head relation {
	bys y4_hhid round (pid) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys y4_hhid round (pid) : egen headtest = sum(head) 
bys y4_hhid round (pid) : egen resptest = sum(respond) 
bys y4_hhid round (pid) : egen memtest = sum(member) 
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
	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(y4_hhid round)	

sa "${tmp_hfps_mwi}/panel/demog.dta", replace
 
	  	  ex	  
	  








