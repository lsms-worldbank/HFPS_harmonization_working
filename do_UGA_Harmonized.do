


********************************************************************************
********************************************************************************

***********************   **    **   ******      **      ***********************
***********************   **    **  ********    ****     ***********************
***********************   **    **  **         **  **    ***********************
***********************   **    **  **        **    **   ***********************
***********************   **    **  **  ****  ********   ***********************
***********************   **    **  **  ****  ********   ***********************
***********************   **    **  **    **  **    **   ***********************
***********************   **    **  **    **  **    **   ***********************
***********************   ********  ********  **    **   ***********************
***********************    **** **   ******   **    **   ***********************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************


*	household level detail from actual completed interview (incl. weights)
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/interview_result.dta"
	"${raw_hfps_uga}/round2/interview_result.dta"
	"${raw_hfps_uga}/round3/interview_result.dta"
	"${raw_hfps_uga}/round4/interview_result.dta"
	"${raw_hfps_uga}/round5/interview_result.dta"
	"${raw_hfps_uga}/round6/interview_result.dta"
	"${raw_hfps_uga}/round7/interview_result.dta"
	"${raw_hfps_uga}/round8/interview_result.dta"
	"${raw_hfps_uga}/round9/interview_result.dta"
/*	"${raw_hfps_uga}/round10/interview_result.dta"		not available in public data! */
	"${raw_hfps_uga}/round11/interview_result.dta"
	"${raw_hfps_uga}/round12/interview_result.dta"
	"${raw_hfps_uga}/round13/interview_result.dta"
	"${raw_hfps_uga}/round14/interview_result.dta"
	"${raw_hfps_uga}/round15/interview_result.dta"

, gen(round);
#d cr
replace round = round+1 if round>=10	//	account for the missing module 
	la drop _append
	la val round 
	ta round 
	isid hhid round
	sort hhid round
	
	keep hhid round Rq05 Rq09
	tempfile interview_result
	sa		`interview_result'

#d ; 
clear; append using
 "${raw_hfps_uga}/round1/Cover.dta"
 "${raw_hfps_uga}/round2/Cover.dta"
 "${raw_hfps_uga}/round3/Cover.dta"
 "${raw_hfps_uga}/round4/Cover.dta"
 "${raw_hfps_uga}/round5/Cover.dta"
 "${raw_hfps_uga}/round6/Cover.dta"
 "${raw_hfps_uga}/round7/Cover.dta"
 "${raw_hfps_uga}/round8/Cover.dta"
 "${raw_hfps_uga}/round9/Cover.dta"
 "${raw_hfps_uga}/round10/Cover.dta"
 "${raw_hfps_uga}/round11/Cover.dta"
 "${raw_hfps_uga}/round12/Cover.dta"
 "${raw_hfps_uga}/round13/Cover.dta"
 "${raw_hfps_uga}/round14/Cover.dta"
 "${raw_hfps_uga}/round15/Cover.dta"

, gen(round);
#d cr

	
	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)	//	there was a replenishment of the sample in round 13 to 
	isid hhid round
	sort hhid round
	mer 1:1 hhid round using `interview_result'
	ta Rq05 _m,m
	ta round _m	
	keep if inlist(_m,1,3)
	
	ta round Rq05, m
	
	d *e2
	drop *e2
	d *_ID
	drop *_ID
	

	*	need some examples of these time variables
	levelsof Sq02 in 1/300
	levelsof sec0_startime in 1/100
	li sec0_startime in `=_N-19'/`=_N'
	
	cou if !mi(Sq02)
	convert_date_time sec0_startime sec0_endtime Sq02
	ta Sq02rmdr 
	
	g fmt1 = cofd(date(Sq02rmdr,"YMD")), a(Sq02)
	egen datetime = rowfirst(Sq02 fmt1)

	
	egen pnl_intclock = rowfirst(datetime sec0_startime sec0_endtime)
	format pnl_intclock datetime sec0_startime sec0_endtime fmt1  %tc
	li round Sq02 datetime sec0_startime sec0_endtime if mi(pnl_intclock), sepby(hhid)
	drop sec0_startime sec0_endtime Sq02 Sq02rmdr fmt1 datetime
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	
	g long start_yr= Clockpart(pnl_intclock, "year")
	g long start_mo= Clockpart(pnl_intclock, "month")
	g long start_dy= Clockpart(pnl_intclock, "day")

	table (start_yr start_mo) round, nototal
	li pnl_intclock if round==7 & start_yr==2020	//	appear to be off by a single calendar year perhaps
	li pnl_intclock if round==10 & start_yr==2021
	li pnl_intclock if round==12 & start_yr==2021

	
	tabstat wfinal, by(round) s(sum)
	tabstat w1 Round1_hh_weight Round2_hh_weight, by(round) s(sum)
	drop w1 Round1_hh_weight Round2_hh_weight
	
	
	ta sample_type
// 	bro hhid round sample_type baseline_hhid baseline_hhid* if !mi(baseline_hhid_unps)
	sort hhid round 
	egen str32 hhid_str = rowfirst(baseline_hhid baseline_hhid_unps baseline_hhid_unhs)
	isid hhid_str round
	
	
	d using "${raw_lsms_uga}/HH/gsec1.dta" 
	preserve 
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	isid hhid
	g str32 hhid_str=hhid
	keep hhid_str region-urban wgt
	ren (region regurb subreg district dc_2018 s1aq02a cc_2018 s1aq03a sc_2018 /*
	*/	 s1aq04a pc_2018 urban wgt)	/*
	*/	(r0_region r0_regurb r0_subreg r0_distname r0_distcode r0_countyname r0_countycode	/*
	*/	 r0_subconame r0_subcocode r0_parishname r0_parishcode r0_urban r0_wgt)
	tabstat r0_wgt, s(sum) format(%12.0fc)
	tempfile r0
	sa		`r0'
	restore
	mer m:1 hhid_str using `r0', gen(_r0) assert(1 2 3) keep(1 3)
	
	*	get rid of unnecessary variables 
	ta r0_region region
	ta r0_regurb region, m
	ta round region, m
	

	
		*	just retain both for now 
	ds phase round CountyCode CountyName DistrictCode DistrictName ParishCode ParishName SubcountyCode SubcountyName hhid_str bseqno hhid region subreg urban Rq05 Rq09 wfinal pnl_* start_* r0_* _r0, not
	d `r(varlist)', varlist	// retain the same varlist so it can be dropped 
	drop `r(varlist)'
	
	

	ren wfinal wgt
	la var wgt			"Sampling weight"
	
	g wtd = !mi(wgt)
	ta round wtd
	drop wtd
	
	isid hhid round
	sort hhid round

sa "${local_storage}/tmp_UGA_cover.dta", replace 

*	modifications for construction of grand panel 
u "${local_storage}/tmp_UGA_cover.dta", clear 

egen pnl_hhid = group(hhid)
egen pnl_admin1 = group(r0_region)
egen pnl_admin2 = group(r0_region r0_distname)
egen pnl_admin3 = group(r0_region r0_distname r0_countyname)

ta urban r0_urban,m
d urban
la li Cq07
egen pnl_urban = anymatch(urban), v(1 2)
g pnl_wgt = wgt

sa "${local_storage}/tmp_UGA_pnl_cover.dta", replace 


// gr twoway scatter start_yr start_mo




********************************************************************************
}	/*	end Cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************



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

, gen(round) force;
#d cr
destring Round7_hh_roster_id, replace


	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)	//	there was a replenishment of the sample in round 13 to 
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
	d using "${local_storage}/tmp_UGA_cover.dta"
	g Rq09 = hh_roster__id
	mer 1:m hhid Rq09 round using "${local_storage}/tmp_UGA_cover.dta"
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
	keep phase round hhid hh_roster__id pid_ubos member sex age head relation respond 
	
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round
	sa "${local_storage}/tmp_UGA_ind.dta", replace
	
	
u "${local_storage}/tmp_UGA_ind.dta", clear
mer m:1 hhid round using "${local_storage}/tmp_UGA_cover.dta"
ta round _m

*	use hh_roster__ididual panel to make demographics 
u "${local_storage}/tmp_UGA_ind.dta", clear
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

sa "${local_storage}/tmp_UGA_demog.dta", replace
 	
	
	
	
	
	
********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment	*/ 
********************************************************************************


/*
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

d using	"${raw_hfps_uga}/round1/SEC5.dta"
d using	"${raw_hfps_uga}/round2/SEC5.dta"
d using	"${raw_hfps_uga}/round3/SEC5.dta"
d using	"${raw_hfps_uga}/round4/SEC5.dta"
d using	"${raw_hfps_uga}/round5/SEC5.dta"
d using	"${raw_hfps_uga}/round6/SEC5_Resp.dta"
d using	"${raw_hfps_uga}/round7/SEC5.dta"
d using	"${raw_hfps_uga}/round8/SEC5.dta"
d using	"${raw_hfps_uga}/round9/SEC5.dta"
d using	"${raw_hfps_uga}/round10/SEC5.dta"
d using	"${raw_hfps_uga}/round11/SEC5.dta"
d using	"${raw_hfps_uga}/round12/SEC5.dta"
d using	"${raw_hfps_uga}/round13/SEC5.dta"
d using	"${raw_hfps_uga}/round14/SEC5.dta"


*	NFE
d using	"${raw_hfps_uga}/round1/SEC5A.dta"	//	ag in this round
d using	"${raw_hfps_uga}/round2/SEC5A.dta"
d using	"${raw_hfps_uga}/round3/SEC5A.dta"
d using	"${raw_hfps_uga}/round4/SEC5A.dta"
d using	"${raw_hfps_uga}/round5/SEC5A.dta"
d using	"${raw_hfps_uga}/round6/SEC5A.dta"
d using	"${raw_hfps_uga}/round7/SEC5A.dta"
d using	"${raw_hfps_uga}/round8/SEC5A.dta"
d using	"${raw_hfps_uga}/round9/SEC5A.dta"
d using	"${raw_hfps_uga}/round10/SEC5A.dta"
d using	"${raw_hfps_uga}/round11/SEC5A.dta"
d using	"${raw_hfps_uga}/round12/SEC5A.dta"
// d using	"${raw_hfps_uga}/round13/SEC5A.dta"
d using	"${raw_hfps_uga}/round14/SEC5A.dta"



*	investigate the admin codes in this specific round, why the second set? 
u	"${raw_hfps_uga}/round3/Cover.dta", clear 
ta DistrictName DistrictName2	//	identical
ta DistrictCode DistrictCode2	//	identical
ta ParishName ParishName2
assert ParishName==ParishName2 if !mi(ParishName2)
	*-> don't care, drop them 



u "${raw_hfps_uga}/round1/SEC5.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
tempfile base
sa      `base'
foreach r of numlist 2/5 7/13 {
	u "${raw_hfps_uga}/round`r'/SEC5.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>3
li name _* if matches>3, nol sep(0)
li name var8 if matches>3, sep(0)

*/

*	NFE low/no income codes 
foreach r of numlist 2/12 14 {
	u "${raw_hfps_uga}/round`r'/SEC5A.dta", clear
	uselabel s5aq14_1 s5aq14_2
	tempfile r`r'
	sa		`r`r''
}
u `r2', clear
foreach r of numlist 3/12 14 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	*	these shift over time. But they are not currently requested for analysis 



#d ; 
clear; append using
 "${raw_hfps_uga}/round1/SEC5.dta"
 "${raw_hfps_uga}/round2/SEC5.dta"
 "${raw_hfps_uga}/round3/SEC5.dta"
 "${raw_hfps_uga}/round4/SEC5.dta"
 "${raw_hfps_uga}/round5/SEC5.dta"
 "${raw_hfps_uga}/round6/SEC5_Resp.dta"
 "${raw_hfps_uga}/round7/SEC5.dta"
 "${raw_hfps_uga}/round8/SEC5.dta"
 "${raw_hfps_uga}/round9/SEC5.dta"
 "${raw_hfps_uga}/round10/SEC5.dta"
 "${raw_hfps_uga}/round11/SEC5.dta"
 "${raw_hfps_uga}/round12/SEC5.dta"
 "${raw_hfps_uga}/round13/SEC5.dta"
 "${raw_hfps_uga}/round14/SEC5.dta"

, gen(round);
#d cr

	
	la drop _append
	la val round 
	ta round 	
	isid hhid round
	sort hhid round

ta round s5q01,m 
ta s5q06 round,m
ta s5q06 s5q01, m
	
g work_cur = (s5q01==1) if inlist(s5q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s5q01==1 & inlist(s5q06,4,5)) if inlist(s5q01,1,2)
g biz_cur  = (s5q01==1 & inlist(s5q06,1,2)) if inlist(s5q01,1,2)
g farm_cur = (s5q01==1 & inlist(s5q06,3))   if inlist(s5q01,1,2)
la var work_cur			"Respondent currently employed"
la var nwork_cur		"Respondent currently unemployed"
la var wage_cur			"Respondent mainly employed for wages"
la var biz_cur			"Respondent mainly employed in household enterprise"
la var farm_cur			"Respondent mainly employed on family farm"
	
*	sector 
tab2 round s504 s5q05,m first
d s5q05
la li s5q05	
recode s5q05 (11111 201111=1)(21111 31111=2)(41111 51111=3)(61111=4)	/*
*/	(71111 91111=5)(81111=6)(101111 111111 121111 131111 141111=7)(151111=8)	/*
*/	(161111 171111 181111 191111 211111 -96=9), copyrest gen(sector_cur)
run "${hfps_github}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"
ta round sector_cur

*	hours
tabstat s5q08b s5q8b1 s5q8c1, by(round)
egen hours_cur = rowfirst(s5q08b s5q8b1)
ta hours_cur round
replace hours_cur=. if mi(hours_cur)
assert hours_cur<=168 if !mi(hours_cur)
la var hours_cur	"Hours respondent worked in current employment"



keep hhid round *_cur
	tempfile cur
	sa		`cur'
	
	
**	NFE
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC5.dta"
	"${raw_hfps_uga}/round2/SEC5A.dta"
	"${raw_hfps_uga}/round3/SEC5A.dta"
	"${raw_hfps_uga}/round4/SEC5A.dta"
	"${raw_hfps_uga}/round5/SEC5A.dta"
	"${raw_hfps_uga}/round6/SEC5A.dta"
	"${raw_hfps_uga}/round7/SEC5A.dta"
	"${raw_hfps_uga}/round8/SEC5A.dta"
	"${raw_hfps_uga}/round9/SEC5A.dta"
	"${raw_hfps_uga}/round10/SEC5A.dta"
	"${raw_hfps_uga}/round11/SEC5A.dta"
	"${raw_hfps_uga}/round12/SEC5A.dta"
	"${raw_hfps_uga}/round14/SEC5A.dta"

, gen(round);
#d cr
	la drop _append
	la val round 
	replace round=round+1 if round>12
	ta round 	
	isid hhid round
	sort hhid round

	*	refperiod operational 
tab2 round s5q11 s5aq11, first m
	egen xx = rowfirst(s5q11 s5aq11)
	g refperiod_nfe = (xx==1) if !mi(xx)
	drop xx
la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"

	*	activity
	tab2 round s5q12 s5aq12,m first
	la li s5q12
	egen xx = rowfirst(s5q12 s5aq12)
	
recode xx (11111 201111=1)(21111 31111=2)(41111 51111=3)(61111=4)	/*
*/	(71111 91111=5)(81111=6)(101111 111111 121111 131111 141111=7)(151111=8)	/*
*/	(161111 171111 181111 191111 211111 -96=9), copyrest gen(sector_nfe)
run "${hfps_github}/label_emp_sector.do"
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"
ta round sector_nfe
drop xx
	
	*	currently operational
	tab2 round s5aq11a s5aq11a_?,m first
	egen status_nfe = rowfirst(s5aq11a s5aq11a_?)
	la copy s5aq11a_1 status_nfe
	la val status_nfe status_nfe
	ta round status_nfe,m
	la var status_nfe	"Current operational status of NFE"
	
	g open_nfe = (status_nfe==1) if !mi(status_nfe)
	la var open_nfe		"NFE is currently open"
	
*	reason for no/low revenue 
tab2 round s5q14 s5aq14_1 s5aq14_2, first m	//	check labels in round 11+ for code 12 
la li  s5q14 s5aq14_1 s5aq14_2	//	identical	
		preserve
	u "${raw_hfps_uga}/round11/SEC5A.dta", clear
	la li s5aq14_1 s5aq14_2	//	identical	
		restore
		*->	not currently requested, leave it 

*	challenges
tab2 round s5aq15__? , first m
d s5aq15__?, f
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/6 {
	loc v s5aq15__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
}
g challenge7_nfe = (s5aq15__n96==1) if !mi(s5aq15__n96)
la var challenge1_nfe	"Difficulty buying and receiving supplies and inputs to run my business"
la var challenge2_nfe	"Difficulty raising money run the business"
la var challenge3_nfe	"Difficulty repaying loans or other debt obligations"
la var challenge4_nfe	"Difficulty paying rent for business location"
la var challenge5_nfe	"Difficulty paying workers"
la var challenge6_nfe	"Difficulty selling goods or services to customers"
la var challenge7_nfe	"Other difficulty"

*	no events


keep hhid round *_nfe
	tempfile nfe
	sa		`nfe'

	
	*	combine and export 
u `cur', clear
mer 1:1 hhid round using `nfe', assert(1 3) 
ta round _m	
	

sa "${local_storage}/tmp_UGA_employment.dta", replace 


********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************



/*
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

d using	"${raw_hfps_uga}/round1/SEC7.dta"
d using	"${raw_hfps_uga}/round2/SEC8.dta"
d using	"${raw_hfps_uga}/round3/SEC8.dta"
d using	"${raw_hfps_uga}/round4/SEC8.dta"
d using	"${raw_hfps_uga}/round5/SEC8.dta"
d using	"${raw_hfps_uga}/round6/SEC8.dta"
d using	"${raw_hfps_uga}/round7/SEC8.dta"
d using	"${raw_hfps_uga}/round8/SEC8.dta"
d using	"${raw_hfps_uga}/round9/SEC8.dta"
d using	"${raw_hfps_uga}/round10/SEC8.dta"
d using	"${raw_hfps_uga}/round11/SEC8.dta"
d using	"${raw_hfps_uga}/round12/SEC8.dta"
d using	"${raw_hfps_uga}/round13/SEC8.dta"
d using	"${raw_hfps_uga}/round14/SEC8.dta"
d using	"${raw_hfps_uga}/round15/SEC8.dta"


*/



*	household level detail from actual completed interview (incl. weights)
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC7.dta"
	"${raw_hfps_uga}/round2/SEC8.dta"
	"${raw_hfps_uga}/round3/SEC8.dta"
	"${raw_hfps_uga}/round4/SEC8.dta"
	"${raw_hfps_uga}/round5/SEC8.dta"
	"${raw_hfps_uga}/round6/SEC8.dta"
	"${raw_hfps_uga}/round7/SEC8.dta"
	"${raw_hfps_uga}/round8/SEC8.dta"
	"${raw_hfps_uga}/round9/SEC8.dta"
	"${raw_hfps_uga}/round10/SEC8.dta"
	"${raw_hfps_uga}/round11/SEC8.dta"
	"${raw_hfps_uga}/round12/SEC8.dta"
	"${raw_hfps_uga}/round13/SEC8.dta"
	"${raw_hfps_uga}/round14/SEC8.dta"
	"${raw_hfps_uga}/round15/SEC8.dta"
, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 
	format hhid %20.0g
	isid hhid round
	sort hhid round
	
d s8q0*
la li s8q01 s8q02 s8q03 s8q04 s8q05 s8q06 s8q07 s8q08
d s7q0*
la li s7q01 s7q02 s7q03 s7q04 s7q05 s7q06 s7q07 s7q08

forv i=1/8 {
	egen q`i' = rowfirst(s7q0`i' s8q0`i')
// 	tab2 round s7q0`i' s8q0`i' q`i', first m
}

g worried	= q1==1 if inlist(q1,1,2)
g healthy	= q2==1 if inlist(q2,1,2)
g fewfood	= q3==1 if inlist(q3,1,2)
g skipped	= q4==1 if inlist(q4,1,2)
g ateless	= q5==1 if inlist(q5,1,2)
g runout	= q6==1 if inlist(q6,1,2)
g hungry	= q7==1 if inlist(q7,1,2)
g whlday	= q8==1 if inlist(q8,1,2)

keep round hhid worried-whlday

*	get weight and hhsize vars 
d using "${local_storage}/tmp_UGA_cover.dta"
mer 1:1 round hhid using "${local_storage}/tmp_UGA_cover.dta", keepus(Rq05 urban /*r0_urban*/ wgt)
ta round _m
keep if _m==3
drop _m

mer 1:1 round hhid using "${local_storage}/tmp_UGA_demog.dta", keepus(hhsize)
ta round _m
ta Rq05 if _m==1,m
su worried-whlday if _m==1
keep if inlist(_m,1,3)
drop _m


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta round RS,m

g na="NA" 
ta urban,m
recode urban (1/2=1)(3=0)

cap : erase "${local_storage}/FIES_UGA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_UGA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35, though worried is high at 0.32 
	3	downloaded and saved as FIES_UGA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
1	43.98	4.71	8.30	2.14
2	31.72	4.49	5.27	1.71
3	20.72	3.74	2.38	1.20
4	20.74	3.96	2.17	1.32
5	19.55	3.82	2.59	1.37
6	22.19	4.25	2.65	1.35
7	46.24	5.17	10.58	2.59
8	50.58	5.20	11.61	2.67
9	48.13	5.14	10.41	2.63
10	53.26	5.69	13.47	3.36
11	38.78	5.56	8.67	2.66
12	33.99	4.85	7.63	2.48
13	41.81	7.01	5.04	2.74
14	39.44	7.88	5.17	4.20
15	33.48	6.63	2.84	2.04
*/

			/*	ARCHIVE: notes on process done in Shiny app
				1	All infit inrange(0.7,1.3)
				2	Equating: All items are <=.35, though worried is high at 0.34 
				3	downloaded and saved as FIES_UGA_out.csv
			*/
			
			/*	when using all, individual level (note that here "region" = survey round)
			Prevalence rates of food insecurity by region (% of individuals)
				Moderate or Severe	MoE	Severe	MoE
			1	44.09	4.71	8.26	2.14
			2	31.79	4.50	5.24	1.72
			3	20.80	3.74	2.37	1.20
			4	20.82	3.97	2.16	1.32
			5	19.61	3.82	2.58	1.37
			6	22.26	4.25	2.63	1.34
			7	46.34	5.17	10.55	2.59
			8	50.68	5.20	11.56	2.67
			9	48.24	5.14	10.38	2.63
			10	53.35	5.69	13.45	3.37
			11	38.87	5.56	8.66	2.67
			12	34.09	4.86	7.63	2.49
			13	41.93	7.02	5.02	2.74
			*/

levelsof round, loc(rounds)
foreach r of local rounds {
	loc r=15
	cap : erase "${local_storage}/FIES_UGA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_UGA_r`r'_in.csv", delim(",")
}

	
	
	

/*
round 1 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r1_out.csv

round 2 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.36 & Healthy -0.38, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.45, but retained for consistency. All others 
		are <=.35
	3	downloaded and saved as FIES_UGA_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.47 & Healthy -0.39, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r4_out.csv

round 5 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.51 & Healthy -0.46, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r5_out.csv

round 6 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.57 & Healthy -0.37, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r6_out.csv

round 7 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.40 & Runout +0.45, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r7_out.csv

round 8 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r8_out.csv

round 9 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r9_out.csv

round 10 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.44, but retained for consistency. All others 
		are <=.35
	3	downloaded and saved as FIES_UGA_r10_out.csv

round 11 
	1	All infit inrange(0.7,1.3), though worried is 1.266
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r11_out.csv

round 12 
	1	All infit inrange(0.7,1.3), although hungry is 0.730
	2	Equating: All items are <=.35, though healthy is -.33
	3	downloaded and saved as FIES_UGA_r12_out.csv

round 13 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +.39 and skipped is -.45, but retained for 
		consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r13_out.csv

round 14 
	1	Worried at 1.343, Ateless at .680 & Hungry at .686, but retained all 
		according to pooled approach
	2	Equating: Skipped is -.51, RunOut is +.39 & Hungry is +.37. All are 
		retained for consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r14_out.csv

round 15 
	1	All infit inrange(0.7,1.3), although runout is is 0.702 & others are <.8
	2	Equating: Skipped is -.52, RunOut is +.39. All are retained for 
		consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r15_out.csv

*/


*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${local_storage}/FIES_UGA_out.csv", varn(1) clear
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
mer m:1 RS using `out', assert(3) nogen

tabstat fies_mod fies_sev [aw=wgt_hh], by(round)

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
ren fies_??? fies_pooled_???


	preserve 
levelsof round if !mi(RS), loc(rounds)
loc toappend ""
foreach r of local rounds {
import delimited using "${local_storage}/FIES_UGA_r`r'_out.csv", varn(1) clear
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

mer m:1 RS round using `tomerge'
ta RS round if _m!=3,	m
drop _m

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

ren RS fies_rawscore
la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

keep round hhid fies_*
sa "${local_storage}/tmp_UGA_fies.dta", replace
	
	
	

********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************



/*
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




*/

d using "${raw_hfps_uga}/round12/SEC18.dta"	//	no
d using "${raw_hfps_uga}/round13/SEC18.dta"
u  "${raw_hfps_uga}/round13/SEC18.dta", clear
la li food_consumpn_score__id
ta s18q01,m
g round=13

generate days = s18q01 if inrange(s18q01,0,7)
replace  days = 0 if s18q01==.
replace  days = 7 if s18q01>7 & !missing(s18q01)
g dum = (inrange(days,1,7))


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode food_consumpn_score__id (2=12)(3=13)(4=9)(5=8)(6=11)(7=10)(8=5)(9=3)(10=4)(11=7)(12=6)(13=14)(14=15)(15=16), copyrest gen(HDDS_codes)
				/*	tubers were omitted	*/ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
*	make HDDS scores to combine at household level
bys hhid round HDDS_codes (food_consumpn_score__id) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_codes : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode food_consumpn_score__id
				/*	tubers were omitted	*/ 
	(2=3)		/*	nuts, pulses	*/ 
	(8/10=4)		/*	vegetables	*/
	(11/12=5)		/*	fruits	*/
	(4/7=6	)	/*	meat, fish, eggs	*/
	(3=7)		/*	dairy	*/
	(13=9)		/*	oils, fats	*/
	(14=8)	/*	sugar, sugar products, honey	*/
	(15=.)	/*	exclude condiments	*/ 
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
bys hhid round fcs_cats (food_consumpn_score__id) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${local_storage}/tmp_UGA_dietary_diversity.dta", replace 




********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************


/*
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




*/

d using	"${raw_hfps_uga}/round1/SEC9.dta"	//	follows other conventions (though a reduced set of shocks)
d using	"${raw_hfps_uga}/round6/SEC9A.dta"

*	manually harmonize these prior to append 
u	"${raw_hfps_uga}/round1/SEC9.dta", clear

la li s9q03__1 s9q03__2 s9q03__3 s9q03__4 s9q03__5 s9q03__6 s9q03__7 s9q03__8 s9q03__9 s9q03__10 s9q03__11 s9q03__12 s9q03__13 s9q03__14 s9q03__15 s9q03__16 s9q03__n96

loc clncodes 1 6 7 8 9 11 12 13 14 15 16 17 18 19 20 21 96
ds s9q03__*, not(type string)
loc vars `r(varlist)'
loc i=0
foreach v of local vars {
	loc ++i
	loc c : word `i' of `clncodes'
	g shock_cope_`c' = `v' 
	loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
	loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
	loc clnlbl = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
	la var shock_cope_`c'	"`clnlbl' to cope with shock"
}
ren (s9q01 s9q01_Other s9q03_Other) (shock_yn shock_os shock_cope_os)
keep hhid shock*
g round=1, b(hhid)
tempfile r1
sa		`r1'

u	"${raw_hfps_uga}/round6/SEC9A.dta", clear
drop s9aq04 s9aq05	//	hh level vars added on to this module 
la li shocks__id
// ta s9aq01_Other
ta s9aq02	// no other examples for the panel
drop s9aq02
ta s9aq03	//	only one coping strategy per shock allowed here
// ta s9aq03_Other

la li s9aq03	//	

foreach i of numlist 1 6/9 11/21 -96 {
	loc a = abs(`i')
	g shock_cope_`a' = (s9aq03==`i') if !mi(s9aq03)
	la var shock_cope_`a'	"`: label (s9aq03) `i'' to cope with shock"
}
ren (s9aq01 s9aq01_Other s9aq03_Other) (shock_yn shock_os shock_cope_os)

keep hhid shock*
g round=6, b(hhid)
tempfile r6
sa		`r6'


clear 
append using `r1' `r6'
	
	ta round 	
	isid hhid shocks__id round		

*	harmonize shock_code
run "${hfps_github}/label_shock_code.do"
la li shocks__id shock_code 
g shock_code=shocks__id, a(shocks__id)
recode shock_code (1 3=1)(2=41)(4=42)(8 9=8)(13=23)(-96=96)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shocks__id shock_code
drop shocks__id

	
// 	isid hhid shock_code round	//	npt identified because of binning of shock_code
	sort hhid shock_code round

	

sa "${local_storage}/tmp_UGA_shocks.dta", replace 

*	move to household level for analysis
u  "${local_storage}/tmp_UGA_shocks.dta", clear

ta shock_code
la li shock_code
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

tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
tabstat shock_cope_*, by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)

isid hhid round
sort hhid round
sa "${local_storage}/tmp_UGA_hh_shocks.dta", replace 


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
         113 "maize flour"
         110 "rice"
         114 "bread"
         117 "beef"
         125 "fresh milk"
         124 "eggs"
        1237 "silverfish"
         140 "fresh beans"
         105 "sweet potatoes"
         107 "cassava"	/*	fresh is modal cassava code in 2019 data (though likely seasonal)	*/
         141 "dry beans"
         144 "groundnuts"
         135 "onions"
         136 "tomatoes"
         168 "eggplants"
         138 "greens"
         147 "sugar"
        1271 "cooking oil"
        1491 "tea"			/*	green tea wasn't even selected in 2019	*/
        1501 "salt"
        1082 "cassava flour"	/*	was specified in HFPS round 12	*/ 

         100 "banana food"	
/*         101 "Matooke (Bunch)"	
         102 "Matooke (Cluster)"*/
        1312 "banana sweet"	/*	modal sweet banana type in 2019	*/ 

        4623 "diesel"
        4622 "petrol"
         308 "paraffin or kerosene"
         452 "soap"		/*	modal soap type in 2019	*/ 

        8888 "chemical fertilizer"	/*	special code, not captured in the hh module */
; 
#d cr 		

	
		end
********************************************************************************
}	/*	label_item end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************



/*
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

// d using	"${raw_hfps_uga}/round1/SEC11.dta"
// d using	"${raw_hfps_uga}/round2/SEC11.dta"
// d using	"${raw_hfps_uga}/round3/SEC11.dta"
// d using	"${raw_hfps_uga}/round4/SEC11.dta"
// d using	"${raw_hfps_uga}/round5/SEC11.dta"
// d using	"${raw_hfps_uga}/round6/SEC11.dta"
// d using	"${raw_hfps_uga}/round7/SEC11.dta"
d using	"${raw_hfps_uga}/round8/SEC11.dta"
// d using	"${raw_hfps_uga}/round9/SEC11.dta"
// d using	"${raw_hfps_uga}/round10/SEC11.dta"
// d using	"${raw_hfps_uga}/round11/SEC11.dta"
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d using	"${raw_hfps_uga}/round13/SEC11.dta"


loc r=8
u "${raw_hfps_uga}/round`r'/SEC11.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
tempfile base
sa      `base'
foreach r of numlist 12 13 {
	u "${raw_hfps_uga}/round`r'/SEC11.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>0
li name _* if matches>0, nol sep(0)
li name var8 if matches>0, sep(0)

*/

d using	"${raw_hfps_uga}/round8/SEC11.dta"
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d using	"${raw_hfps_uga}/round13/SEC11.dta"

u	"${raw_hfps_uga}/round8/SEC11.dta", clear
la li food_prices__id s11q02a s11q02b	//	need a recode 
u	"${raw_hfps_uga}/round12/SEC11.dta", clear
la li food_prices__id food_prices__id s11q02a s11q02b
u	"${raw_hfps_uga}/round13/SEC11.dta", clear
la li food_prices__id s11q03a s11q03b

u "${raw_lsms_uga}/HH/gsec15b.dta", clear
la li itmcd	//	no conversion factor available, but we will harmonize the codes anyway
ta CEB01 if CEB03==1
u "${raw_lsms_uga}/HH/gsec15c.dta", clear
la li CEC02
ta CEC02 if CEC02_1==1

u	"${raw_hfps_uga}/round8/SEC11.dta", clear
la li food_prices__id
*	reogranize food_prices__id to harmonize with rounds 12/13
recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)(7=1237)	/*
*/	(8=140)(9=105)(10=107)(11=141)(12=144)(13=135)(14=136)(15=168)(16=138)	/*
*/	(17=147)(18=1271)(19=1491)(20=1501), gen(item)
label_item
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}
keep hhid item s11q*
g   round=8, a(hhid)
tempfile r8
sa		`r8'


u	"${raw_hfps_uga}/round12/SEC11.dta", clear
la li food_prices__id
ta s11q02a s11q02b if food_prices__id==12	//	have to split food_prices__id 12 by unit

recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)	/*
*/	(8=141)(9=105)  (11=140)(12=100)(13=1312) (15=135)(16=136)	/*
*/	(18=138)(19=147)(20=1271)(21=1491)(22=1501)(23=8888)	/*
*/	(24=4623)(25=4622)(26=308)(28=1082)(30=144)(31=452) , gen(item)
// recode item 101=102 if s11q02a=="cluster":s11q02a 
label_item
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}

keep hhid item s11q*
g   round=12, a(hhid)
tempfile r12
sa		`r12'

u	"${raw_hfps_uga}/round13/SEC11.dta", clear
la li food_prices__id	//	consistent with round 12, but minus soap
ta s11q03a s11q03b if food_prices__id==12	//	have to split matooke by unit to match organizational approach in 2019

recode food_prices__id (1=113)(2=110)(3=114)(4=117)(5=125)(6=124)	/*
*/	(8=141)(9=105)  (11=140)(12=100)(13=1312) (15=135)(16=136)	/*
*/	(18=138)(19=147)(20=1271)(21=1491)(22=1501)(23=8888)	/*
*/	(24=4623)(25=4622)(26=308)(28=1082)(30=144) , gen(item)
// recode item 101=102 if s11q03a=="CLUSTER":s11q03a 
label_item
la val item item
inspect item
assert r(N_undoc)==0
levelsof food_prices__id, loc(raw)
foreach r of local raw {
	dis ""
	dis as result "raw `r' = `: label (food_prices__id) `r''", _column(1) _cont
	dis as text "links to", _column(70) _cont
	qui : levelsof item if food_prices__id==`r', loc(cln)
	foreach c of local cln {
		dis as text "cln `c' = `: label (item) `c''", _column(70) _cont
	}
}
drop food_prices__id	// labels not harmonious between rounds 

*	need to reorganize to append
d using	"${raw_hfps_uga}/round12/SEC11.dta"
d s11*

ren s11q02			s11q01a
ren s11q03a			s11q02a
ren s11q03a_Other	s11q02a_os
ren s11q03b			s11q02b
ren s11q04			s11q02c
ren s11q05			s11q03
ren s11q09			s11q04
order s11q04, a(s11q03)

assert mi(s11q02a_os)	//	nothing
drop s11q02a_os

keep hhid item s11q*
g   round=13, a(hhid)
tempfile r13
sa		`r13'


clear
append using `r8' `r12' `r13'
isid hhid item round

ta item round 

ta s11q02a s11q02b,m	//	some undocumented, have to check back on this 
#d ; 
la def s11q02a 
          11 "basins"
          12 "bar"
          13 "cluster"
          14 "BAGS (50 KGs)"
          15 "BAGS (100 KGs)"
          16 "TRAY (30 EGGs)"
		  , add; 
#d cr 
ta s11q02a s11q02b,m	//	some undocumented, have to check back on this 
ta item s11q02a
// egen unit = group(s11q02a s11q02b), label missing

decode item, gen(itemstr)
g		item_avail  = (s11q01==1) 
la var	item_avail	"Item is available for sale"

*	lacking a conversion factor, we will simply bring the raw unit through 
decode s11q02a, gen(xx)
decode s11q02b, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

ta s11q04
g		unitcost=s11q04 if s11q04!=-98
la var	unitcost	"Unit cost (LCU/unit)"
ta item s11q02a if inlist(s11q02a,1,2)
g		price=s11q04 if inlist(s11q02a,1,2) & s11q04!=-98
la var	price		"Price (LCU/standard unit)"

*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)

*	simply ignoring the add'l questions added in round 13 for this panel aggregation exercise

keep  hhid round item itemstr item_avail unitstr price unitcost 
order hhid round item itemstr item_avail unitstr price unitcost
isid  hhid round item
sort  hhid round item
sa "${local_storage}/tmp_UGA_price.dta", replace 
 




********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************




/*
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

// d using	"${raw_hfps_uga}/round1/SEC12.dta"
// d using	"${raw_hfps_uga}/round2/SEC12.dta"
// d using	"${raw_hfps_uga}/round3/SEC12.dta"
// d using	"${raw_hfps_uga}/round4/SEC12.dta"
// d using	"${raw_hfps_uga}/round5/SEC12.dta"
// d using	"${raw_hfps_uga}/round6/SEC12.dta"
// d using	"${raw_hfps_uga}/round7/SEC12.dta"
d using	"${raw_hfps_uga}/round8/SEC12.dta"
// d using	"${raw_hfps_uga}/round9/SEC12.dta"
d using	"${raw_hfps_uga}/round10/SEC12.dta"
// d using	"${raw_hfps_uga}/round11/SEC12.dta"
d using	"${raw_hfps_uga}/round12/SEC12.dta"
d using	"${raw_hfps_uga}/round13/SEC12.dta"

*/

u	"${raw_hfps_uga}/round8/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round10/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round12/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round13/SEC12.dta"		, clear
la li _all


#d ; 
clear; append using
	"${raw_hfps_uga}/round8/SEC12.dta"	
	"${raw_hfps_uga}/round10/SEC12.dta"	
	"${raw_hfps_uga}/round12/SEC12.dta"	
	"${raw_hfps_uga}/round13/SEC12.dta"	
	, gen(round);
#d cr 

replace round=round+7
replace round=round+1 if round>8
replace round=round+1 if round>10

isid hhid round

	
	
	la li s12q01 s12q02 s12q03 s12q04 s12q05 s12q07 s12q08 s12q09
	

d s12*


ds s12*, not(type string)
tabstat `r(varlist)', by(round) s(n)


loc q1 s12q01
ta		`q1',m
la li	`q1'
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s12q02
ta		`q2', m
la li	`q2'
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s12q03
ta		`q3', m
la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s12q04
ta		`q4', m
la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s12q05
ta		`q5', m
la li	`q5'
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

d s12q06* s12q07
ta s12q06 s12q07,m
compare s12q07 s12q06
replace s12q07=s12q06 if mi(s12q07)
drop s12q06
tabstat s12q06*, by(round)
compare s12q06?	//	never jointly defined, as we expect
g s12q06 = s12q06a
replace s12q06 = s12q06b * -1 if mi(s12q06)

loc q6	s12q06
ta		`q6', m
g		sntmnt_last12moPricepct = `q6'
la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s12q07
ta		`q7', m
la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s12q08
ta		`q8', m
la li	`q8'
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s12q09
ta		`q9', m
la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s12q10__
tabstat `weather'?, by(round) s(n)	
d `weather'?	//	no storms for UGA 

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)4 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${local_storage}/tmp_UGA_economic_sentiment.dta", replace 





********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************




/*
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

d using	"${raw_hfps_uga}/round1/SEC5.dta"
d using	"${raw_hfps_uga}/round2/SEC5.dta"
d using	"${raw_hfps_uga}/round3/SEC5.dta"
d using	"${raw_hfps_uga}/round4/SEC5.dta"
d using	"${raw_hfps_uga}/round5/SEC5.dta"
d using	"${raw_hfps_uga}/round6/SEC5_Resp.dta"
d using	"${raw_hfps_uga}/round7/SEC5.dta"
d using	"${raw_hfps_uga}/round8/SEC5.dta"
d using	"${raw_hfps_uga}/round9/SEC5.dta"
d using	"${raw_hfps_uga}/round10/SEC5.dta"
d using	"${raw_hfps_uga}/round11/SEC5.dta"
d using	"${raw_hfps_uga}/round12/SEC5.dta"
d using	"${raw_hfps_uga}/round13/SEC13.dta"

*/




u "${raw_hfps_uga}/round13/SEC13.dta", clear
g round=13


	
	
	la li s9q01 s9q02 s9q03 s9q04 s9q05_1 s9q06
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s9q01 
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s9q02 
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s9q03
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4  s9q04 
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3   {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s9q05_1 
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s9q06
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}


keep hhid round sw_* 
sa "${local_storage}/tmp_UGA_subjective_welfare.dta", replace 


********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************


dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
// dir "${raw_hfps_uga}/round8", w
// dir "${raw_hfps_uga}/round9", w
// dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
// dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
// dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w

d using	"${raw_hfps_uga}/round1/SEC5A.dta"
d using	"${raw_hfps_uga}/round2/SEC5B.dta"
d using	"${raw_hfps_uga}/round3/SEC5B.dta"
d using	"${raw_hfps_uga}/round4/SEC5B.dta"
d using	"${raw_hfps_uga}/round5/SEC5B.dta"
d using	"${raw_hfps_uga}/round6/SEC5B.dta"		//	pretty different 
d using	"${raw_hfps_uga}/round7/SEC6E_1.dta"
d using	"${raw_hfps_uga}/round7/SEC6E_2.dta"
// d using	"${raw_hfps_uga}/round8/SEC5B.dta"
// d using	"${raw_hfps_uga}/round9/SEC5B.dta"
// d using	"${raw_hfps_uga}/round10/SEC5B.dta"
d using	"${raw_hfps_uga}/round11/SEC17.dta"
// d using	"${raw_hfps_uga}/round12/SEC5B.dta"
d using	"${raw_hfps_uga}/round13/SEC19_1.dta"
d using	"${raw_hfps_uga}/round13/SEC19_2.dta"
// d using	"${raw_hfps_uga}/round14/SEC5B.dta"
d using	"${raw_hfps_uga}/round15/SEC19.dta"

u	"${raw_hfps_uga}/round7/SEC6E_2.dta", clear
ta crop__id
duplicates report hhid
u "${raw_hfps_uga}/round13/SEC19_2.dta", clear
ta fertilizer_type__id




*	there is substantial variation across rounds. We will just go round by round, 
*	but to economize on lines we will save labeling til a grand append at the end

********************************************************************************
{	/*round 1*/
u "${raw_hfps_uga}/round1/SEC5A.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5aq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s5qaq17_1
ta `v5'
la li `v5'

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (`v5'==1) if !mi(`v5')
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (`v5'==2) if !mi(`v5')
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (`v5'==3) if !mi(`v5')
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (`v5'==4) if !mi(`v5')
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'==5) if !mi(`v5')
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'==6) if !mi(`v5')
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'==7) if !mi(`v5')
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'==8) if !mi(`v5')
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
	*	ignore the o/s

*	6	not able to access fertilizer 
loc v6 s5aq23
ta `v6'
la li `v6'
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'==1 | `v6'==2)	if !mi(`v6')
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'==6)	if !mi(`v6') 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
g		ag_nofert_cat3=(`v6'==3 |  `v6'==4)	if !mi(`v6')
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"
g		ag_nofert_cat4=(`v6'==5)	if !mi(`v6')
la var	ag_nofert_cat4	"Increase in price of fertilizer"

*	7	main crops, taking first 
loc v7 s5aq18__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"

keep hhid ag_* cropcode
g round=		  1
tempfile		 r1
sa				`r1'
}	/*	end round 1	*/ 
********************************************************************************


********************************************************************************
{	/*round 2*/
u "${raw_hfps_uga}/round2/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq02_ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'1

g 		cropcode = `v7'1
la var cropcode	"Main crop code"


*	8	harvesting complete
loc v8	s5bq03
ta		`v8'
la li	`v8' 
g		ag_harv_complete = (`v8'==3) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


keep hhid ag_* cropcode
g round=		  2
tempfile		 r2
sa				`r2'
}	/*	end round 2	*/ 
********************************************************************************


********************************************************************************
{	/*round 3*/
u "${raw_hfps_uga}/round3/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	12	harvest expectation ex ante
loc v12 s5bq19
ta `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val ag_????harv_subj ag_subjective_assessment

*	13	expected harvest quantity
loc v13 s5bq20
g		ag_anteharv_q		= `v13' 
g		ag_anteharv_u		= `v13'b
g		ag_anteharv_cf		= `v13'c
ta ag_anteharv_cf
destring ag_anteharv_cf, replace force
li `v13'c if mi(ag_anteharv_cf)
tabstat ag_anteharv_cf, by(ag_anteharv_u) s(n me min max)
g		ag_anteharv_kg		= ag_anteharv_q * ag_anteharv_cf

*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment


keep hhid ag_* 
g round=		  3
tempfile		 r3
sa				`r3'
}	/*	end round 3	*/ 
********************************************************************************


********************************************************************************
{	/*round 4*/
u "${raw_hfps_uga}/round4/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq18_ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'1

g 		cropcode = `v7'1
la var cropcode	"Main crop code"



*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_antesale_subj ag_subjective_assessment


keep hhid ag_* cropcode
g round=		  4
tempfile		 r4
sa				`r4'
}	/*	end round 4	*/ 
********************************************************************************


********************************************************************************
{	/*round 5*/
u "${raw_hfps_uga}/round5/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq21a 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	9	planting complete
loc v9 s5bq21b
g		ag_plant_complete = (`v9'==1)	if !mi(`v9')
la var	ag_plant_complete	"Planting of main crop complete"

*	10 area planted
loc v10	s5bq21c
g		ag_plant_ha = `v10' * 0.40468564224 //	acres
la var	ag_plant_ha	"Hectares planted with main crop"


*	12	harvest expectation ex ante
loc v12	s5bq21d
ta `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_anteharv_subj ag_subjective_assessment


*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val ag_antesale_subj ag_subjective_assessment


keep hhid ag_* cropcode
g round=		  5
tempfile		 r5
sa				`r5'
}	/*	end round 5	*/ 
********************************************************************************


********************************************************************************
{	/*round 6*/
u "${raw_hfps_uga}/round6/SEC5B.dta", clear

*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
la li `v17'
g		ag_antesale_subj = `v17' if !mi(`v17') & `v17'!=-97
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val ag_antesale_subj ag_subjective_assessment


keep hhid ag_* 
g round=		  6
tempfile		 r6
sa				`r6'
}	/*	end round 6	*/ 
********************************************************************************


********************************************************************************
{	/*round 7*/
u "${raw_hfps_uga}/round7/SEC6E_2.dta", clear
u "${raw_hfps_uga}/round7/SEC6E_1.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s6eq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s6eq21a__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4c = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'8==1) if !mi(`v5'8)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	

*	7	main crops, taking first 
loc v7 s5bq18__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"


*	10 area planted not available, must merge
d using "${raw_hfps_uga}/round7/SEC6E_2.dta"
g crop__id=cropcode
mer 1:1 hhid crop__id using "${raw_hfps_uga}/round7/SEC6E_2.dta", keep(1 3) nogen
loc v10	s6eq21d
g		ag_plant_ha = `v10' * 0.40468564224 //	acres
la var	ag_plant_ha	"Hectares planted with main crop"


*	12	harvest expectation ex ante
loc v12	s6eq21e
ta `v12'
// tab1 s6eq21f s6eq21g
la li `v12'
g ag_anteharv_subj=`v12'+1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_anteharv_subj ag_subjective_assessment


*	15	normally sell
loc v15	s6eq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s6eq24
ta `v17'
la li `v17'
g		ag_antesale_subj = `v17' if !mi(`v17') & `v17'!=-97
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val ag_antesale_subj ag_subjective_assessment


keep hhid ag_* 
g round=		  7
tempfile		 r7
sa				`r7'
}	/*	end round 7	*/ 
********************************************************************************


********************************************************************************
{	/*round 11*/
u "${raw_hfps_uga}/round11/SEC17.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s17q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s17q02__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	
*	6	not able to access fertilizer 
loc v6 s17q03
ta `v6'
la li `v6'
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'==1)	if !mi(`v6')
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'==2)	if !mi(`v6') 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"


*	7	main crops, taking first 
loc v7 s17q04__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"


*	11	area comparison to last planting
loc v11 s17q07
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,5)
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


*	12	harvest expectation ex ante
loc v12	s17q08
ta `v12'
// tab1 s6eq21f s6eq21g
la li `v12'
g ag_anteharv_subj=`v12'+1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_anteharv_subj ag_subjective_assessment

*	19	inorg fertilizer dummy
loc v19 s17q12
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	20	future fertilizer 
loc v20 s17q14
ta `v20'
g		ag_inorgfert_ante = (`v20'==1) if !mi(`v20')
la var	ag_inorgfert_ante	"Intend to apply inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s17q13__
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'11 `v21'12 `v21'13)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'14 `v21'15 `v21'16)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'17 `v21'18)			if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"
loc v21 s17q15__
g		ag_ferttype_ante_label=.
la var	ag_ferttype_ante_label	"Intends to apply [...] fertilizer"
egen	ag_ferttype_ante_cat1 = anymatch(`v21'11 `v21'12 `v21'13)	if ag_inorgfert_ante==1, v(1)
egen	ag_ferttype_ante_cat2 = anymatch(`v21'14 `v21'15 `v21'16)	if ag_inorgfert_ante==1, v(1)
egen	ag_ferttype_ante_cat3 = anymatch(`v21'17 `v21'18)			if ag_inorgfert_ante==1, v(1)
la var	ag_ferttype_ante_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_ante_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_ante_cat3	"Phosphate"

*	23 reason no fertilizer
loc v23 s17q16
ta `v23' 
la li `v23'
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',1,2)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',3)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',4)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"
	*	ignore o/s

*	25 Acquire full amount? 
loc v25 s17q17
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"
	
	
keep hhid ag_* 
g round=		  11
tempfile		 r11
sa				`r11'
}	/*	end round 11	*/ 
********************************************************************************


********************************************************************************
{	/*round 13*/
u "${raw_hfps_uga}/round13/SEC19_1.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s19q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s19q02__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	
*	6	not able to access fertilizer 
loc v6 s19q03__
tabstat `v6'*, s(n me)
d `v6'*
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'1==1)	if !mi(`v6'1)
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'2==1)	if !mi(`v6'2) 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"


*	7	main crops, taking first 
loc v7 s19q04 
ta `v7',
la li `v7'

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	9	planting complete	//	unclear that this is referencing a single crop
loc v9 s19q05__
tabstat `v9'?, s(n me)
g		ag_plant_complete = (`v9'1==1)	if !mi(`v9'1)
la var	ag_plant_complete	"Planting of main crop complete"


*	10 area planted
loc v10	s19q06
ta `v10'b
la li `v10'b
ta `v10'b_Other
#d ; 
g		ag_plant_ha = `v10'a * 
	cond(`v10'b==1,0.40468564224,
	cond(`v10'b==2,`v10'a * 0.0001,
	cond(`v10'b==3,`v10'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 

la var	ag_plant_ha	"Hectares planted with main crop"


*	11	area comparison to last planting
loc v11 s19q07
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,5)
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
la var ag_plant_vs_prior	"Comparative planting area vs last planting"


*	12	harvest expectation ex ante
loc v12	s19q08
ta `v12'
la li `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
#d ; 
la def ag_subjective_assessment
		   1 "Exceptionally good / much better than normal"
		   2 "Good / better than normal"
		   3 "Average / normal"
		   4 "Not good, less than normal"
		   5 "Very bad, much less than normal"
		   ;
#d cr
la val	ag_anteharv_subj ag_subjective_assessment

*	13	expected harvest quantity
loc v13	s19q09
ta `v13'b
g		ag_anteharv_q		= `v13'a
g		ag_anteharv_u		= `v13'b
g		ag_anteharv_u_os	= `v13'b_Other
la var	ag_anteharv_q		"Expected harvest quantity"
la var	ag_anteharv_u		"Expected harvest unit"
la var	ag_anteharv_u_os	"Expected harvest unit o/s"


*	15	normally sell
loc v15	s19q10
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	29	price of fertilizer
preserve
u "${raw_hfps_uga}/round13/SEC19_2.dta", clear
ta fertilizer_type__id
la li fertilizer_type__id
recode fertilizer_type__id (11/13=1)(14/16=2)(17/18=3)(else=.), gen(ag_fertcost_type)
loc unit s19q12c
ta `unit'
la li `unit'
g ag_fertcost_unit=`unit' if `unit'!=-96
la copy `unit' ag_fertcost_unit
la val ag_fertcost_unit ag_fertcost_unit
loc lcu  s19q12b
g ag_fertcost_lcu = `lcu'
keep if !mi(ag_fertcost_type) & !mi(ag_fertcost_unit) & !mi(ag_fertcost_lcu)
cou
duplicates report hhid ag_fertcost_type
duplicates tag hhid ag_fertcost_type, gen(tag)
li if tag>0, sepby(hhid)	//	in all cases, the LCU/unit cost are identical
loc subj s19q13
la li `subj'
g ag_fertcost_subj = `subj'
la copy `subj' cost_subj
la val ag_fertcost_subj cost_subj
duplicates drop hhid ag_fertcost_type, force
keep hhid ag_fertcost_*
reshape wide ag_fertcost_unit ag_fertcost_lcu ag_fertcost_subj, i(hhid) j(ag_fertcost_type)
la var ag_fertcost_unit1	"Unit, Compound fertilizer"
la var ag_fertcost_lcu1		"LCU/unit, Compound fertilizer"
la var ag_fertcost_subj1	"Price change, Compound fertilizer"
la var ag_fertcost_unit2	"Unit, Nitrogen fertilizer"
la var ag_fertcost_lcu2		"LCU/unit, Nitrogen fertilizer"
la var ag_fertcost_subj2	"Price change, Nitrogen fertilizer"
la var ag_fertcost_unit3	"Unit, Phosphate fertilizer"
la var ag_fertcost_lcu3		"LCU/unit, Phosphate fertilizer"
la var ag_fertcost_subj3	"Price change, Phosphate fertilizer"
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid using `fertcost', assert(1 3) nogen

*	no conversion for now

	
keep hhid ag_* crop
g round=		  13
tempfile		 r13
sa				`r13'
}	/*	end round 13	*/ 
********************************************************************************


********************************************************************************
{	/*round 15*/
u "${raw_hfps_uga}/round15/SEC19.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s19q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	2	able to farm normally 
loc v2	s19q04
ta `v2'
g		ag_normal_yn = (`v2'==1) if !mi(`v2')
la var	ag_normal_yn	"Able to conduct agricultural activies normally"

*	3	reason respondent not able to conduct normal farming activities
loc v3 s19q02
ta `v3'
la li `v3'

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
// g		ag_resp_no_farm_cat1 = (s6q17_1__1==1) if !mi(s6q17_1__1)
// la var	ag_resp_no_farm_cat1		"Advised to stay home"
g		ag_resp_no_farm_cat2 = (`v3'==1) if !mi(`v3')
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
// g		ag_resp_no_farm_cat3 = (s6q17_1__3==1) if !mi(s6q17_1__3)
// la var	ag_resp_no_farm_cat3		"Restrictions on movement / travel"
g		ag_resp_no_farm_cat4 = (inlist(`v3',2,3,4)) if !mi(`v3')
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
g		ag_resp_no_farm_cat5 = (`v3'==5) if !mi(`v3')
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
g		ag_resp_no_farm_cat6 = (`v3'==6) if !mi(`v3')
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
g		ag_resp_no_farm_cat7 = (`v3'==11) if !mi(`v3')
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
g		ag_resp_no_farm_cat8 = (inlist(`v3',7,8)) if !mi(`v3')
la var	ag_resp_no_farm_cat8		"Climate"
g		ag_resp_no_farm_cat9 = (`v3'==9) if !mi(`v3')
la var	ag_resp_no_farm_cat9		"Pests"
g		ag_resp_no_farm_cat10= (`v3'==10) if !mi(`v3')
la var	ag_resp_no_farm_cat10		"Insecurity"

*	4	total cultivated area
loc v4 s19q06
la li `v4'b
#d ; 
g		ag_total_ha = `v4'a * 
	cond(`v4'b==1,0.40468564224,
	cond(`v4'b==2,`v4'a * 0.0001,
	cond(`v4'b==3,`v4'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 
la var ag_total_ha	"Total area under all crops (ha)"

*	5	not able to conduct hh ag activities
loc v5 s19q05__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
egen	ag_nogrow_cat8 = rowmax(`v5'7 `v5'8) if !mi(`v5'7)
la var	ag_nogrow_cat8		"Climate"
g		ag_nogrow_cat9 = (`v5'9==1) if !mi(`v5'9)
la var	ag_nogrow_cat9		"Pests"
g		ag_nogrow_cat10= (`v5'10==1) if !mi(`v5'10)
la var	ag_nogrow_cat10		"Insecurity"
	
*	6	not able to access fertilizer 
loc v6 s19q03
ta `v6'	//	no obs 


*	7	main crops, taking first 
loc v7 s19q07 
ta `v7',
la li `v7'

g 		cropcode = `v7'
la var cropcode	"Main crop code"




*	10 area planted
loc v10	s19q08
ta `v10'b
la li `v10'b
#d ; 
g		ag_plant_ha = `v10'a * 
	cond(`v10'b==1,0.40468564224,
	cond(`v10'b==2,`v10'a * 0.0001,
	cond(`v10'b==3,`v10'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 

la var	ag_plant_ha	"Hectares planted with main crop"


*	11	area comparison to last planting
loc v11 s19q09
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,6)
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
la var ag_plant_vs_prior	"Comparative planting area vs last planting"


*	12	harvest expectation ex post
loc v12	s19q11
ta `v12'
la li `v12'
g		ag_postharv_subj=`v12'
la var	ag_postharv_subj	"Subjective assessment of harvest ex-post"
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
loc v14	s19q10
ta `v14'b
g		ag_postharv_q		= `v14'a
g		ag_postharv_u		= `v14'b
la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"


*	15	normally sell
loc v15	s19q12
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
loc v16	s19q13
ta `v16'
la li `v16'
g ag_sale_current = (`v16'==1) if !mi(`v16')


*	17a	Post-sale subjective assessment
loc v17	s19q14
ta `v17'
la li `v17'
g		ag_postsale_subj = `v17' if !mi(`v17')
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	Reasoning for subjective assessment of sales
ta s19q15 s19q14,m
loc v18	s19q15
ta `v18'
la li `v18'	
/*
         -96 Other specify
           1 Harvested more
           2 Harvested less
           3 Sold higher quantities
           4 Sold lower quantities
           5 Incured higher production costs
           6 Incureed lower production costs
           7 Prices were higher
           8 Prices were lower
           9 Sold them in the main market instead of farmgate
          10 Sold them at farmgate  instead of the main market inst


*/

g		ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
forv i=1/10 {
g		ag_salesubj_why_cat`i' = (`v18'==`i') if !mi(`v18')
la var	ag_salesubj_why_cat`i'	"`: label `v18' `i''"
}

*	19	inorg fertilizer dummy
loc v19 s19q16
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s19q18__
la li `v21'1
d `v21'*
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'1 `v21'3 `v21'4)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'2 `v21'5 `v21'6)	if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"

*	22	fertilizer applied quantity
loc v22	s19q20
ta `v22'b
g ag_fertpost_tot_q		= `v22'a
g ag_fertpost_tot_unit	= `v22'b
la var ag_fertpost_tot_q	"Total quantity of fertilizer on all plots"
la var ag_fertpost_tot_unit	"Unit for fertilizer applied on all plots"

*	23 reason no [input]
loc v23 s19q17
ta `v23'
la li `v23'
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',1,2)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',3)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',4)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"


*	24	fertilizer acquired quantity
loc v24	s19q19
ta `v24'b
g		ag_fertpurch_tot_q		= `v24'a
g		ag_fertpurch_tot_unit	= `v24'b
la var	ag_fertpurch_tot_q		"Total quantity of fertilizer acquired"
la var	ag_fertpurch_tot_unit	"Unit for fertilizer acquired for all plots"

*	25 Acquire full amount? 
loc v25 s19q21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	s19q23
ta `v26'b
g		ag_fertpurch_ante_q		= `v26'a
g		ag_fertpurch_ante_unit	= `v26'b
la var	ag_fertpurch_ante_q		"Total quantity of fertilizer still desired"
la var	ag_fertpurch_ante_unit	"Unit for fertilizer still desired on all plots"

*	27	reason couldn't acquire fertilizer
loc v27	s19q24
ta `v27'
la li `v27'
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
g 		ag_fert_partial_cat2 = (inlist(`v27',2)) if !mi(`v27')
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
g 		ag_fert_partial_cat3 = (inlist(`v27',1,3)) if !mi(`v27')
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 s19q22__
d `v28'*
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat4=(`v28'3==1) if !mi(`v28'3) 
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_nofert_adapt_cat5=(`v28'4==1) if !mi(`v28'4)
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"
g		ag_nofert_adapt_cat6=(`v28'2==1) if !mi(`v28'2)
la var	ag_nofert_adapt_cat6	"Changed crop type"
g		ag_nofert_adapt_cat7=(`v28'1==1) if !mi(`v28'1)
la var	ag_nofert_adapt_cat7	"Just planted without fertilizer"

loc v28 s19q25__
d `v28'*
g		ag_partialfert_adapt_label=.
la var	ag_partialfert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_partialfert_adapt_cat1=(`v28'1==1) if !mi(`v28'1)
la var	ag_partialfert_adapt_cat1	"Only fertilized part of cultivated area"
g		ag_partialfert_adapt_cat2=(`v28'2==1) if !mi(`v28'2)
la var	ag_partialfert_adapt_cat2	"Used lower rate of fertilizer"
g		ag_partialfert_adapt_cat3=(`v28'3==1) if !mi(`v28'3)
la var	ag_partialfert_adapt_cat3	"Cultivated a smaller area"
g		ag_partialfert_adapt_cat4=(`v28'4==1) if !mi(`v28'4)
la var	ag_partialfert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_partialfert_adapt_cat5=(`v28'5==1) if !mi(`v28'5)
la var	ag_partialfert_adapt_cat5	"Practiced legume intercropping"


*	29	price of fertilizer
preserve
u "${raw_hfps_uga}/round15/SEC19_2.dta", clear
ta fertilizer_type__id
la li fertilizer_type__id
recode fertilizer_type__id (1 3=1)(2 5 6=2)(4=3)(else=.), gen(ag_fertcost_type)
loc unit s19q26c
ta `unit'
la li `unit'
g ag_fertcost_unit=`unit' if `unit'!=-96
la copy `unit' ag_fertcost_unit
la val ag_fertcost_unit ag_fertcost_unit
loc lcu  s19q26b
g ag_fertcost_lcu = `lcu'
keep if !mi(ag_fertcost_type) & !mi(ag_fertcost_unit) & !mi(ag_fertcost_lcu)
cou
duplicates report hhid ag_fertcost_type
duplicates tag hhid ag_fertcost_type, gen(tag)
li if tag>0, sepby(hhid)	//	in all cases, the LCU/unit cost are identical
loc subj s19q27
la li `subj'
g ag_fertcost_subj = `subj'
la copy `subj' cost_subj
la val ag_fertcost_subj cost_subj
duplicates drop hhid ag_fertcost_type, force
keep hhid ag_fertcost_*
reshape wide ag_fertcost_unit ag_fertcost_lcu ag_fertcost_subj, i(hhid) j(ag_fertcost_type)
la var ag_fertcost_unit1	"Unit, Compound fertilizer"
la var ag_fertcost_lcu1		"LCU/unit, Compound fertilizer"
la var ag_fertcost_subj1	"Price change, Compound fertilizer"
la var ag_fertcost_unit2	"Unit, Nitrogen fertilizer"
la var ag_fertcost_lcu2		"LCU/unit, Nitrogen fertilizer"
la var ag_fertcost_subj2	"Price change, Nitrogen fertilizer"
// la var ag_fertcost_unit3	"Unit, Phosphate fertilizer"
// la var ag_fertcost_lcu3		"LCU/unit, Phosphate fertilizer"
// la var ag_fertcost_subj3	"Price change, Phosphate fertilizer"
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid using `fertcost', assert(1 3) nogen

*	no conversion for now

	
keep hhid ag_* crop
g round=		  15
tempfile		 r15
sa				`r15'
}	/*	end round 15	*/ 
********************************************************************************





#d ; 
clear; append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r11' `r13' `r15'; 
#d cr 

isid hhid round
ta round


// keep  hhid round item itemstr item_avail unitstr price unitcost 
// order hhid round item itemstr item_avail unitstr price unitcost
isid  hhid round 
sort  hhid round 
sa "${local_storage}/tmp_UGA_agriculture.dta", replace 
 


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


