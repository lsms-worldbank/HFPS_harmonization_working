


dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w


d using	"${raw_hfps_uga}/round1/SEC1.dta"
d using	"${raw_hfps_uga}/round2/SEC1.dta"
d using	"${raw_hfps_uga}/round3/SEC1.dta"
d using	"${raw_hfps_uga}/round4/SEC1.dta"
d using	"${raw_hfps_uga}/round5/SEC1.dta"
d using	"${raw_hfps_uga}/round6/SEC1.dta"
d using	"${raw_hfps_uga}/round7/SEC1.dta"
d using	"${raw_hfps_uga}/round8/SEC1.dta"
d using	"${raw_hfps_uga}/round9/SEC1.dta"
d using	"${raw_hfps_uga}/round10/SEC1.dta"
d using	"${raw_hfps_uga}/round11/SEC1.dta"
d using	"${raw_hfps_uga}/round12/SEC1.dta"
d using	"${raw_hfps_uga}/round13/SEC1.dta"
d using	"${raw_hfps_uga}/round14/SEC1.dta"
d using	"${raw_hfps_uga}/round15/SEC1.dta"
d using	"${raw_hfps_uga}/round16/SEC1.dta"
d using	"${raw_hfps_uga}/round17/SEC1.dta"

/*
*	test merge prior to any subsequent work
u	"${raw_hfps_uga}/round3/SEC1.dta", clear
mer m:1 hhid using	"${raw_hfps_uga}/round3/COVER.dta"
su wfinal if _m==2	//	only 2 obs anyway? what is going on? 
u	"${raw_hfps_uga}/round3/SEC1.dta", clear
mer m:1 hhid using	"${raw_hfps_uga}/round3/interview_result.dta"
ta Rq05 _m
keep if _m==2
keep hhid
duplicates drop
mer 1:1 hhid using "${raw_hfps_uga}/round2/COVER.dta"
ta _m	//	not present in round 2
keep if _m==1
keep hhid 
mer 1:1 hhid using "${raw_hfps_uga}/round1/COVER.dta"	//	no _m==3 here either 



u "${raw_hfps_uga}/round3/COVER.dta", clear
mer 1:1 hhid using	"${raw_hfps_uga}/round3/interview_result.dta", assert(3) nogen
ta Rq05,m

u "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", clear
ren hhid baseline_hhid
mer 1:1 baseline_hhid using	"${raw_hfps_uga}/round3/COVER.dta"




*	automated look for this information
local files : dir "${raw_hfps_uga}/round10" files "*.dta"
dir "${raw_hfps_uga}/round10", w

foreach f in Cover SEC1 SEC2A_1 SEC2A_2 SEC4 SEC5 SEC5A SEC6 SEC7 SEC8 SEC10 SEC10_1 SEC12 SEC13 SEC15 SEC16 {
	u "${raw_hfps_uga}/round10/`f'.dta", clear
	d , replace clear
	tempfile f`f'
	sa `f`f''
}
clear
append using  `fCover' `fSEC1' `fSEC2A_1' `fSEC2A_2' `fSEC4' `fSEC5' `fSEC5A' `fSEC6' `fSEC7' `fSEC8' `fSEC10' `fSEC10_1' `fSEC12' `fSEC13' `fSEC15' `fSEC16', gen(file)
ta file if strpos(name,"Rq")>0
	//	not present... 
	
	

#d ;
u "${raw_hfps_uga}/round1/SEC1.dta" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)17 {;
	u "${raw_hfps_uga}/round`r'/SEC1.dta" , clear;
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

li name var1 if matches>=10, sep(0)
li name _* if matches<10, sep(0) nol


u	"${raw_hfps_uga}/round8/SEC1.dta", clear

bro hhid hh_roster__id pid_ubos Round7_pid_ubos Round7_hh_roster_id
destring Round7_hh_roster_id, replace
compare Round7_hh_roster_id hh_roster__id

*/

*	hh_roster__ididual data, using force to ignore one mismatch in Round7_hh_roster_id
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC1.dta"
	"${raw_hfps_uga}/round2/SEC1.dta"
	"${raw_hfps_uga}/round3/SEC1.dta"
	"${raw_hfps_uga}/round4/SEC1.dta"
	"${raw_hfps_uga}/round5/SEC1.dta"
	"${raw_hfps_uga}/round6/SEC1.dta"
	"${raw_hfps_uga}/round7/SEC1.dta"
	"${raw_hfps_uga}/round8/SEC1.dta"
	"${raw_hfps_uga}/round9/SEC1.dta"
	"${raw_hfps_uga}/round10/SEC1.dta"
	"${raw_hfps_uga}/round11/SEC1.dta"
	"${raw_hfps_uga}/round12/SEC1.dta"
	"${raw_hfps_uga}/round13/SEC1.dta"
	"${raw_hfps_uga}/round14/SEC1.dta"
	"${raw_hfps_uga}/round15/SEC1.dta"
	"${raw_hfps_uga}/round16/SEC1.dta"
	"${raw_hfps_uga}/round17/SEC1.dta"

, gen(round) force;
#d cr
destring Round7_hh_roster_id, replace


	la drop _append
	la val round 
	ta round 	
// 	g phase=cond(round<=12,1,2), b(round)	//	there was a replenishment of the sample in round 13 to 
	format hhid %20.0g

	destring Round1_hh_roster_id Round2_hh_roster_id, replace ignore(#N/A)
	tabstat hh_roster__id t0_ubos_pid pid_ubos Round1_hh_roster_id Round2_pid_ubos Round2_hh_roster_id Round7_pid_ubos Round7_hh_roster_id, by(round) s(n) format(%9.3gc)
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round
	
	
	ta round s1q02a, m
	ta s1q02a s1q02,m
	
	g member = (s1q02==1 | s1q03==1) & s1q02a!=2
	g sex=s1q05
	li hhid hh_roster__id pid_ubos if sex==.a & round==5
	g age=s1q06
	g head=(s1q07==1)
	g relation=s1q07
	label copy s1q07 relation
	label val relation relation			 
		 	
	*	respondent
	d using "${tmp_hfps_uga}/panel/cover.dta"
	g Rq09 = hh_roster__id
	mer 1:m hhid Rq09 round using "${tmp_hfps_uga}/panel/cover.dta"
	ta round _m
	g respond = (_m==3) if round!=10
	g carbon=respond
	drop if _m==2
	
		bys hhid round (hh_roster__id) : egen testresp = sum(respond)
		ta round testresp,m	//	notably rounds 9, 10 is all blank by construction
		ta respond member,m
		
		*	step 1 assume prior round respondent was interviewed again if available 
		bys hhid hh_roster__id (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (hh_roster__id) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	round 1 most pronounced
		li hhid round hh_roster__id member respond carbon if testresp2==2 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond carbon if hhid==102102041501 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==102102041501 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==124103021802 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==124103021802 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==313109010501 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==313109010501 & round==9 & hh_roster__id==2
		li hhid round hh_roster__id member respond carbon if hhid==407202041401 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==407202041401 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==408112022601 & inrange(round,5,9), sepby(round)
		recode respond (1=0) if hhid==408112022601 & round==7 & hh_roster__id==1
		
		
		li hhid round hh_roster__id member respond if testresp2==0 & round!=10, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round hh_roster__id member respond age sex testresp2 if flagresp==0 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond if flagresp==0 & (respond==1 | testresp2==0) & round!=10, sepby(hhid)

	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min)) if round!=10
		bys hhid hh_roster__id (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys hhid round (hh_roster__id) : replace respond =1 if testresp2!=1 & _N==1 & round!=10 //	2
			
		
		bys hhid round (hh_roster__id) : egen testresp3 = sum(respond)
		ta round testresp3
		by hhid : egen flagresp2 = min(cond(round==10,1,testresp3))
		li hhid round hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0) & round!=10, sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the respondent from prior rounds, respecting member values 
		recode respond (0=1) if hhid==204203011402 & hh_roster__id==2 & round==9 
		recode respond (0=1) if hhid==205107031305 & hh_roster__id==1 & round==8 
		recode respond (0=1) if hhid==405302010301 & hh_roster__id==3 & round==13 
		bys hhid round (hh_roster__id) : egen testresp4 = sum(respond)
		ta round testresp4
		*	can't really resolve the remainder 
	  drop testresp-testresp4
	
	
	*	fill in with prior round information where possible
	su
	cou
	foreach x in age sex relation {
		tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
	bys hhid hh_roster__id (round) : egen `maxmiss'= max(mi(`x'))
	by  hhid hh_roster__id (round) : egen `maxnmiss'= max(`x')
	by  hhid hh_roster__id (round) : egen `minnmiss'= min(`x')
	by  hhid hh_roster__id (round), rc0 : egen `modenmiss'= mode(`x')
	
	g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
	replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
	su `x' if `maxmiss'==1
	replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
	su `x' if `maxmiss'==1
	
	drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
		}
	
	 
	*	drop unnecessary variables 
	compare t0_ubos_pid pid_ubos
	ta round if mi(pid_ubos)
	keep /*phase*/ round hhid hh_roster__id pid_ubos member sex age head relation respond 
	
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round
	sa "${tmp_hfps_uga}/panel/ind.dta", replace
	
	
u "${tmp_hfps_uga}/panel/ind.dta", clear
mer m:1 hhid round using "${tmp_hfps_uga}/panel/cover.dta"
ta round _m

*	use hh_roster__ididual panel to make demographics 
u "${tmp_hfps_uga}/panel/ind.dta", clear
ta member round,m

*	respondent characteristics
foreach x in sex age head relation {
	bys hhid round (hh_roster__id) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys hhid round (hh_roster__id) : egen headtest = sum(head) 
bys hhid round (hh_roster__id) : egen resptest = sum(respond) 
bys hhid round (hh_roster__id) : egen memtest = sum(member) 
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

sa "${tmp_hfps_uga}/panel/demog.dta", replace
 	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	