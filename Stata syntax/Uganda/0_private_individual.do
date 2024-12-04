
loc investigate=0
if `investigate'==1 {

dir "${raw_hfpsprivate_uga}", w
dir "${raw_hfpsprivate_uga}/Phase 1", w
dir "${raw_hfpsprivate_uga}/Phase 2", w
dir "${raw_hfpsprivate_uga}/Phase 3", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave1", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave2", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave3", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave4", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave5", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave6", w
dir "${raw_hfpsprivate_uga}/Phase 1/Wave7", w
dir "${raw_hfpsprivate_uga}/Phase 2/Round 8", w
dir "${raw_hfpsprivate_uga}/Phase 2/Round 9", w
dir "${raw_hfpsprivate_uga}/Phase 2/Round 10", w
dir "${raw_hfpsprivate_uga}/Phase 2/Round 11", w
dir "${raw_hfpsprivate_uga}/Phase 2/Round 12", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 13", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 14", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 15", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 16", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 17", w
dir "${raw_hfpsprivate_uga}/Phase 3/Round 18", w


d *id* using	"${raw_hfps_uga}/round1/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round2/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round3/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round4/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round5/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round6/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round7/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round8/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round9/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round10/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round11/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round12/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round13/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round14/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round15/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round16/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round17/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round18/SEC1.dta"


d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave1/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave2/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave3/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave4/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave5/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave6/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 1/Wave7/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 2/Round 8/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 2/Round 9/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 2/Round 10/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 2/Round 11/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 2/Round 12/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 13/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 14/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 15/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 16/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 17/SEC1.dta"
d *id* using	"${raw_hfpsprivate_uga}/Phase 3/Round 18/SEC1.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave1/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave2/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave3/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave4/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave5/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave6/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 1/Wave7/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 2/Round 8/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 2/Round 9/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 2/Round 10/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 2/Round 11/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 2/Round 12/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 13/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 14/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 15/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 16/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 17/Cover.dta"
d using	"${raw_hfpsprivate_uga}/Phase 3/Round 18/Cover.dta"
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
d using	"${raw_hfps_uga}/round15/SEC1.dta"	//	is this the key to link the round 13 & 14
d using	"${raw_hfps_uga}/round16/SEC1.dta"
d using	"${raw_hfps_uga}/round17/SEC1.dta"
d using	"${raw_hfps_uga}/round18/SEC1.dta"





********************************************************************************
}	/*	end investigate bracket	*/
********************************************************************************


*	hh_roster__ididual data, using force to ignore one mismatch in Round7_hh_roster_id
#d ; 
clear; append using
	"${raw_hfpsprivate_uga}/Phase 1/Wave1/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave2/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave3/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave4/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave5/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave6/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 1/Wave7/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 2/Round 8/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 2/Round 9/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 2/Round 10/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 2/Round 11/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 2/Round 12/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 13/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 14/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 15/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 16/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 17/SEC1.dta"
	"${raw_hfpsprivate_uga}/Phase 3/Round 18/SEC1.dta"


	, gen(round) ;
#d cr


	la drop _append
	la val round 
	ta round 	
	recode round (1/7=1 "Phase 1")(8/12=2 "Phase 2")(13/18=3 "Phase 3"), gen(phase)
	g hhid=HHID
	format hhid %20.0g

// 	d *id*,f
// 	destring Round7_hh_roster_id, replace
// 	destring Round1_hh_roster_id Round2_hh_roster_id, replace ignore(#N/A)
// 	tabstat hh_roster__id t0_ubos_pid pid_ubos Round1_hh_roster_id Round2_pid_ubos Round2_hh_roster_id Round7_pid_ubos Round7_hh_roster_id, by(round) s(n) format(%9.3gc)
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round
	isid hhid pid_ubos round
	sort hhid pid_ubos round
	
	*	there are lots of PID variables, 
	ds Round*_pid_ubos, not(type string)
	loc pids `r(varlist)'
	for any `pids' : assert pid_ubos==X if !mi(X)
	drop Round*_pid_ubos
	
	/*
	ds Round*_hh_roster_id, not(type numeric)
	destring Round*_hh_roster_id, ignore(#N/A) replace
	foreach r of numlist 1(1)18 { 
		tempvar min max
		bys hhid pid_ubos (round) : egen `min'=min(Round`r'_hh_roster_id)
		by  hhid pid_ubos (round) : egen `max'=max(Round`r'_hh_roster_id)
		assert `min'==`max'
		drop `min' `max'
		}
	*/	//->	this does resolve, but is time consuming, so we simply implement the conclusion
	drop Round*_hh_roster_id
	
// 	compare pid_ubos t0_ubos_pid
	*	our entire goal here is to take the updated pid_ubos that Frederic has prepared 
	*	and bring it to the harmonized dataset as an input. Therefore, we shall; 
		preserve
	keep hhid hh_roster__id pid_ubos round
	sort hhid hh_roster__id round
	dir "${hfps}/Input datasets/Uganda"
	sa  "${hfps}/Input datasets/Uganda/private_pid_ubos.dta", replace
		restore
	
	g member = (s1q02==1 | s1q03==1) & s1q02a!=2
	g sex=s1q05
	li hhid hh_roster__id pid_ubos if sex==.a & round==5
	g age=s1q06
	g head=(s1q07==1)
	g relation=s1q07
	label copy s1q07 relation
	label val relation relation			 
	
	tab2 round member sex /*age*/ head relation, first m
	ta member if mi(relation)
	ta member if mi(sex)
	
	*	respondent
	d using "${tmp_hfps_uga}/cover.dta"
	g Rq09 = hh_roster__id
	mer 1:m hhid Rq09 round using "${tmp_hfps_uga}/cover.dta"
	ta round _m
	g respond = (_m==3) if round!=10
	g carbon=respond
	drop if _m==2
	
		bys hhid round (pid_ubos) : egen testresp = sum(respond)
		ta round testresp,m	//	notably rounds 9, 10 is all blank by construction
		ta respond member,m
		
		*	step 1 assume prior round respondent was interviewed again if available 
		bys hhid pid_ubos (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (pid_ubos) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	rounds 2 & 4 most pronounced
		assert inlist(testresp2,0,1)
// 		li hhid round pid_ubos hh_roster__id member respond carbon if testresp2==2 & round!=10, sepby(hhid)
// 		li hhid round pid_ubos hh_roster__id member respond carbon if hhid==102102041501 & inrange(round,6,12), sepby(round)
// 		recode respond (1=0) if hhid==102102041501 & round==9 & hh_roster__id==1
// 		li hhid round hh_roster__id member respond carbon if hhid==124103021802 & inrange(round,8,11), sepby(round)
// 		recode respond (1=0) if hhid==124103021802 & round==9 & hh_roster__id==1
// 		li hhid round hh_roster__id member respond carbon if hhid==313109010501 & inrange(round,8,11), sepby(round)
// 		recode respond (1=0) if hhid==313109010501 & round==9 & hh_roster__id==2
// 		li hhid round hh_roster__id member respond carbon if hhid==407202041401 & inrange(round,8,11), sepby(round)
// 		recode respond (1=0) if hhid==407202041401 & round==9 & hh_roster__id==1
// 		li hhid round hh_roster__id member respond carbon if hhid==408112022601 & inrange(round,5,9), sepby(round)
// 		recode respond (1=0) if hhid==408112022601 & round==7 & hh_roster__id==1
//		
		
		li hhid round pid_ubos hh_roster__id member respond if testresp2==0 & round!=10, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round pid_ubos hh_roster__id member respond age sex testresp2 if flagresp==0 & round!=10, sepby(hhid)
		li hhid round pid_ubos hh_roster__id member respond if flagresp==0 & (respond==1 | testresp2==0) & round!=10, sepby(hhid)

	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min)) if round!=10
		bys hhid pid_ubos (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys hhid round (pid_ubos) : replace respond =1 if testresp2!=1 & _N==1 & round!=10 //	2
			
		
		bys hhid round (pid_ubos) : egen testresp3 = sum(respond)
		ta round testresp3
		by hhid : egen flagresp2 = min(cond(round==10,1,testresp3))
		li hhid round pid_ubos hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & round!=10, sepby(hhid)
		li hhid round pid_ubos hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0) & round!=10, sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the respondent from prior rounds, respecting member values 
// 		recode respond (0=1) if hhid==204203011402 & hh_roster__id==2 & round==9 
		recode respond (0=1) if hhid==111202062821 & pid_ubos==1 & round==2 
		recode respond (0=1) if hhid==205107031305 & pid_ubos==1 & round==8 
		recode respond (0=1) if hhid==211106070421 & pid_ubos==5 & round==4 
		recode respond (0=1) if hhid==324104010321 & pid_ubos==1 
		bys hhid round (hh_roster__id) : egen testresp4 = sum(respond)
		ta round testresp4
		assert testresp4==1 if round!=10
		*	can't really resolve the remainder 
	  drop testresp-testresp4
	
	
	*	new approach, document extent of problem first 		
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
	
			ta sex,m
			ta age
			bys hhid pid_ubos (round) : egen issue=max(!inrange(age,0,100) & !mi(age))
			d using "${tmp_hfps_uga}/cover.dta"
			mer m:1 hhid round using "${tmp_hfps_uga}/cover.dta", keepus(start_yr) assert(1 2 3) keep(1 3) nogen
			li hhid pid round age sex member start_yr if issue==1, sepby(hhid)
			recode age (220=22) if hhid==108301011502 & pid==2
			recode age (823=83) if hhid==208102140209 & pid==1
			recode age (163=16) if hhid==303504020405 & pid==11
			recode age (115=13) if hhid==310306040201 & pid==5	//	presuming this was an error that was carried forward without checking it
			recode age (11=105) if hhid==325103061006 & pid==2	//	presuming the last was an error
			recode age (5600=56) if hhid==406210060301 & pid==3	
			recode age (110=10) if hhid==406212010704 & pid==17	
			recode age (8000=8) if hhid==417201010502 & pid==6	
			drop start_yr
			ta age
			ta relation,m
			
			tabstat sex age relation if member==1, by(round) s(n)
			demographic_shifts , hh(hhid) ind(pid_ubos)
			tabstat sex age relation if member==1, by(round) s(n)
			
		for any age sex relation : ta round if mi(X) & member==1
	
		*	check hh head characteristics
		bys hhid round (pid_ubos) : egen headtest=sum(head==1 & member==1)
		by  hhid round (pid_ubos) : egen rltntest=sum(relation==1 & member==1)
		ta headtest rltntest
		tab2 round headtest rltntest, first
		li round hhid pid_ubos sex age relation s1q07 member if headtest==2, sepby(hhid)
		ta round if headtest==0	//	large blip in 10, vary large uptick in rounds 15-18 

		
	 
	*	drop unnecessary variables 
	ta round if mi(pid_ubos)
	keep /*phase*/ round hhid hh_roster__id pid_ubos member sex age head relation respond 
	
	isid hhid pid_ubos round
	sort hhid pid_ubos round
	sa "${hfps}/Input datasets/Uganda/private_ind.dta", replace
	
	ex
u "${hfps}/Input datasets/Uganda/private_ind.dta", clear
mer m:1 hhid round using "${tmp_hfps_uga}/cover.dta"
ta round _m

*	use hh_roster__ididual panel to make demographics 
u "${tmp_hfps_uga}/ind.dta", clear
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

sa "${tmp_hfps_uga}/demog.dta", replace
 	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	