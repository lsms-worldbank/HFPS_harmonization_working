
loc	investivate	= 0
qui : if `investivate'==1	{		/*quiet brackets to slim down results window output, recommend to run investigations on a one-off basis if the output is desired */
{	/*	data inventory	*/
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
dir "${raw_hfps_uga}/round10", w	//	no interview_result module??!?!?! 
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w

d using	"${raw_hfps_uga}/round1/Cover.dta"
d using	"${raw_hfps_uga}/round2/Cover.dta"
d using	"${raw_hfps_uga}/round3/Cover.dta"
d using	"${raw_hfps_uga}/round4/Cover.dta"
d using	"${raw_hfps_uga}/round5/Cover.dta"
d using	"${raw_hfps_uga}/round6/Cover.dta"
d using	"${raw_hfps_uga}/round7/Cover.dta"
d using	"${raw_hfps_uga}/round8/Cover.dta"
d using	"${raw_hfps_uga}/round9/Cover.dta"
d using	"${raw_hfps_uga}/round10/Cover.dta"
d using	"${raw_hfps_uga}/round11/Cover.dta"
d using	"${raw_hfps_uga}/round12/Cover.dta"
d using	"${raw_hfps_uga}/round13/Cover.dta"
d using	"${raw_hfps_uga}/round14/Cover.dta"
d using	"${raw_hfps_uga}/round15/Cover.dta"
d using	"${raw_hfps_uga}/round16/Cover.dta"
d using	"${raw_hfps_uga}/round17/Cover.dta"

d using	"${raw_hfps_uga}/round1/interview_result.dta"
d using	"${raw_hfps_uga}/round2/interview_result.dta"
d using	"${raw_hfps_uga}/round3/interview_result.dta"
d using	"${raw_hfps_uga}/round4/interview_result.dta"
d using	"${raw_hfps_uga}/round5/interview_result.dta"
d using	"${raw_hfps_uga}/round6/interview_result.dta"
d using	"${raw_hfps_uga}/round7/interview_result.dta"
d using	"${raw_hfps_uga}/round8/interview_result.dta"
d using	"${raw_hfps_uga}/round9/interview_result.dta"
// d using	"${raw_hfps_uga}/round10/interview_result.dta"
d using	"${raw_hfps_uga}/round11/interview_result.dta"
d using	"${raw_hfps_uga}/round12/interview_result.dta"
d using	"${raw_hfps_uga}/round13/interview_result.dta"
d using	"${raw_hfps_uga}/round14/interview_result.dta"
d using	"${raw_hfps_uga}/round15/interview_result.dta"
d using	"${raw_hfps_uga}/round16/interview_result.dta"
d using	"${raw_hfps_uga}/round17/interview_result.dta"
*/

}

{	/*	investigate admin codes	*/
		/*	admin codes	*/
*	investigate the admin codes in this specific round, why the second set? 
u	"${raw_hfps_uga}/round3/Cover.dta", clear 
ta DistrictName DistrictName2	//	identical
ta DistrictCode DistrictCode2	//	identical
ta ParishName ParishName2
assert ParishName==ParishName2 if !mi(ParishName2)
	*-> don't care, drop them 



u "${raw_hfps_uga}/round1/Cover.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
tempfile base
sa      `base'
foreach r of numlist 2(1)17 {
	u "${raw_hfps_uga}/round`r'/Cover.dta" , clear
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
ta name matches if matches>10

levelsof name if matches>10, clean


*/
dir "${raw_lsms_uga}/HH"
d using "${raw_lsms_uga}/HH/gsec1.dta"
u  "${raw_lsms_uga}/HH/gsec1.dta", clear
keep region-urban
duplicates drop
ta region
sort district region urban s1aq02a s1aq03a s1aq04a
li, sepby(district)



/*	Are the coding issues round-specific for the spatial IDs?	*/
	forv i=1/17 {
	u region subreg using "${raw_hfps_uga}/round`i'/Cover.dta", clear
	g one=1
	collapse (sum) n`i'=one, by(region subreg)
	tempfile r`i'
	sa		`r`i''
	}
	
	u `r1', clear
	forv i=2/17 {
		mer 1:1 region subreg using `r`i'', gen(_r`i')
	}
	egen obs = rowtotal(n* )
	egen matches = anycount(_*), v(3)
	
	sort region subreg matches obs 
	li region subreg matches obs, sepby(region)



	forv i=1/17 {
	u region subreg DistrictName DistrictCode using "${raw_hfps_uga}/round`i'/Cover.dta", clear
	g one=1
	collapse (sum) n`i'=one, by( region subreg DistrictName DistrictCode)
	tempfile r`i'
	sa		`r`i''
	}
	
	u `r1', clear
	forv i=2/17 {
		mer 1:1 region subreg DistrictName DistrictCode using `r`i'', gen(_r`i')
	}
	egen obs = rowtotal(n* )
	egen matches = anycount(_*), v(3)
	
	sort DistrictName matches obs DistrictCode
	li region subreg DistrictName DistrictCode matches obs, sepby(DistrictName)

	*	pull in round 0 to validate
	
	
	
	*	making the region/subreg results more sensical. 
		preserve
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	tab1 region subreg dc_2018 if district=="ARUA"
		restore
		
	replace region="Northern" if DistrictName=="ARUA" & region=="Kampala"
	replace subreg="West Nile" if DistrictName=="ARUA" & subreg=="Kampala"
		preserve
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	tab1 region subreg dc_2018 if district=="BUIKWE"
		restore
		preserve
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	tab1 region subreg dc_2018 if district=="BUSIA"
		restore
		preserve
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	tab1 region subreg dc_2018 if district=="ISINGIRO"
		restore
		preserve
	u  "${raw_lsms_uga}/HH/gsec1.dta", clear
	tab1 region subreg dc_2018 if district=="KAGADI"
		restore
		

	

	*	pull in UEC to validate
		preserve
	import excel using "${ug}/UBOS/census reports 2017/09_2019Final_2020_21_HLG_IPFs_Sept_2019.xlsx", clear
	li in 1/2	//	top matter
	import excel using "${ug}/UBOS/census reports 2017/09_2019Final_2020_21_HLG_IPFs_Sept_2019.xlsx", clear cellrange(A2) first
	drop if length(VoteCode)!=3
	destring VoteCode, gen(DistrictCode)
	ta DistrictMuni
	g DistrictName = strupper(strtrim(stritrim(subinstr(DistrictMunicipality,"District","",1))))
	ta DistrictName
	isid DistrictCode
	isid DistrictName
	g dn=DistrictName
	g dc=DistrictCode
	tempfile UBOS_District
	sa		`UBOS_District'
		restore
		preserve
	mer m:1 DistrictName using `UBOS_District', keepus(DistrictName dc)
	sort DistrictName _merge matches obs DistrictCode
	li DistrictName DistrictCode dc _m matches obs, sepby(DistrictName) nol
		restore

	*	Changes 
	cap : program drop DistrictNameChanges
	program def DistrictNameChanges
	replace DistrictName="BUYENDE" if DistrictName=="BUYEND"
	replace DistrictName="KAMPALA" if DistrictName=="KAMPAL"
	replace DistrictName="KASANDA" if inlist(DistrictName,"KASSAN","KASSANDA")
	replace DistrictName="KIBOGA" if DistrictName==" KIBOGA"
	replace DistrictName="KIRUHURA" if DistrictName=="KIRUHU"
	replace DistrictName="KIRYANDONGO" if DistrictName=="KIRYAN"
	replace DistrictName="KWANIA" if DistrictName=="KWAINA"
	replace DistrictName="KYANKWANZI" if DistrictName=="KYANKW"
	replace DistrictName="KYENJOJO" if DistrictName=="KYENJO"
	replace DistrictName="KYOTERA" if DistrictName=="KYOTER"
	replace DistrictName="MITYANA" if DistrictName=="MITYAN"
	replace DistrictName="MUKONO" if DistrictName=="MUKONO "
	replace DistrictName="NABILATUK" if DistrictName=="NABILA"
	replace DistrictName="NAMTUMBA" if DistrictName=="NAMUTUMBA"
	replace DistrictName="NTUNGA" if DistrictName=="NTUNGAMO"
	replace DistrictName="PALLISA" if DistrictName=="PALISA"
	replace DistrictName="SEMBABULE" if DistrictName=="SSEMBABULE"	//	reconciling to the spelling in UBOS 
	replace DistrictName="NAMUTUMBA" if DistrictName=="NAMTUMBA"	//	UBOS spelling
	replace DistrictName="NTUNGAMO" if DistrictName=="NTUNGA"		//	UBOS spelling
	replace DistrictName=strtrim(stritrim(DistrictName))
	end
	*	what is the basis for separate codes within the same names? 
		preserve
	DistrictNameChanges
	mer m:1 DistrictName using `UBOS_District', keepus(DistrictName dc)
	ta DistrictName if _m==1
	sort DistrictName _merge matches obs DistrictCode
	li DistrictName DistrictCode dc _m matches obs, sepby(DistrictName) nol
		restore
	
	}
	
	}


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
	"${raw_hfps_uga}/round16/interview_result.dta"
	"${raw_hfps_uga}/round17/interview_result.dta"

, gen(round);
#d cr
replace round = round+1 if round>=10	//	account for the missing module 
	la drop _append
	la val round 
	ta round 
	isid hhid round
	sort hhid round
	
	keep hhid round Rq05 Rq09 Rq14
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
 "${raw_hfps_uga}/round16/Cover.dta"
 "${raw_hfps_uga}/round17/Cover.dta"

, gen(round);
#d cr

	
	la drop _append
	la val round 
	ta round 	
// 	g phase=cond(round<=12,1,2), b(round)	//	there was a replenishment of the sample in round 13 to 
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
	convert_date_time sec0_startime sec0_endtime Sq02 Rq14
	ta Sq02rmdr 
	
	g fmt1 = cofd(date(Sq02rmdr,"YMD")), a(Sq02)
	egen datetime = rowfirst(Sq02 fmt1)

	
	egen pnl_intclock = rowfirst(datetime sec0_startime sec0_endtime Rq14)
	format pnl_intclock datetime sec0_startime sec0_endtime fmt1 Rq14  %tc
	li round Sq02 datetime sec0_startime sec0_endtime Rq14 if mi(pnl_intclock), sepby(hhid)
	drop sec0_startime sec0_endtime Sq02 Sq02rmdr fmt1 datetime Rq14

	*	need a solution for these to be able to xtset the data. We will impute. 
		*	relying on premise that approximate position in the queue the 
		*	previous round would determine 
	g flagdate = (round==7 & Clockpart(pnl_intclock, "year")==2020) | (inlist(round,10,12) & Clockpart(pnl_intclock, "year")==2021) | mi(pnl_intclock)
	g cleandate = cond(flagdate==0,pnl_intclock,.)
	bys round : egen maxclean = max(cleandate)
	by  round : egen minclean = min(cleandate)
	g  ranked_date = round(((cleandate - minclean) / (maxclean - minclean))*100,1) 
	ta ranked_date
	
	bys hhid (round) : g prev_rank = ranked_date[_n-1] if flagdate==1
	
	forv i=2/20 {
		cou if mi(prev_rank) & flagdate==1
		if r(N)==0 continue, break
		by  hhid (round) : replace prev_rank = ranked_date[_n-`i'] if flagdate==1 & mi(prev_rank)
		}
	by  hhid (round) : g next_rank = ranked_date[_n+1] if flagdate==1
	forv i=2/20 {
		cou if mi(next_rank) & flagdate==1
		if r(N)==0 continue, break
		by  hhid (round) : replace next_rank = ranked_date[_n+`i'] if flagdate==1 & mi(next_rank)
		}
	compare prev_rank next_rank
	ta prev_rank next_rank if flagdate==1,m
	ta prev_rank flagdate,m
	egen rank_to_use = rowfirst(prev_rank next_rank ranked_date)	//	need a non-missing version across all flag/non-flag

	bys round rank_to_use : egen avg_date_in_rank = median(cleandate)
	g  filldate = avg_date_in_rank if flagdate==1
	
	su filldate cleandate

		*	cast a wider net, this still is missing some 
	recode rank_to_use (0/10=1)(11/20=2)(21/30=3)(31/40=4)(41/50 .=5)(51/60=6)(61/70=7)(71/80=8)(81/90=9)(91/100=10), gen(rank_tenth)
	bys round rank_tenth : egen avg_date_in_tenth = median(cleandate)
	replace filldate = avg_date_in_tenth if flagdate==1 & mi(filldate)

	cou if mi(filldate) & flagdate==1
		*	simply take a round median in cases that are still missing
	bys round : egen avg_date_in_round = median(cleandate)
	replace filldate = avg_date_in_round if flagdate==1 & mi(filldate)
	
	assert !mi(filldate) if flagdate==1
	replace pnl_intclock = filldate if flagdate==1
	assert !mi(pnl_intclock)
	drop flagdate-avg_date_in_round
	
	
		
	*	manipulate pnl_intclock following fixes 
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	
	
	g long start_yr= Clockpart(pnl_intclock, "year")
	g long start_mo= Clockpart(pnl_intclock, "month")
	g long start_dy= Clockpart(pnl_intclock, "day")

	table (start_yr start_mo) round, nototal
	/*	//	these cases are not fixed in the imputation step above 
	li pnl_intclock if round==7 & start_yr==2020	//	appear to be off by a single calendar year perhaps
	li pnl_intclock if round==10 & start_yr==2021
	li pnl_intclock if round==12 & start_yr==2021
	*/


	
	
	
	tabstat wfinal, by(round) s(sum)
	tabstat w1 Round1_hh_weight Round2_hh_weight, by(round) s(sum)
	drop w1 Round1_hh_weight Round2_hh_weight
	
	
	ta sample_type
// 	bro hhid round sample_type baseline_hhid baseline_hhid* if !mi(baseline_hhid_unps)
	sort hhid round 
	egen str32 hhid_str = rowfirst(baseline_hhid baseline_hhid_unps baseline_hhid_unhs)
	isid hhid_str round
	
	
	d using "${raw_lsms_uga}/HH/gsec1.dta" 	//	2019 public data does not have the cluster included... 
	d using "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta"				
	d using "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta"					
	d using "${ug}/LSMS/UGA_2013_UNPS_v01_M_STATA8/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2011_UNPS_v01_M_Stata/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2010_UNPS_v02_M_STATA12/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2009/2009_GSEC1.dta"	
	d using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2005/2005_GSEC1.dta"	
	
	preserve 
	u	"${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta", clear
	isid HHID
	
	u	"${raw_lsms_uga}/HH/gsec1.dta", clear
	ren (hhid)(hhid2019)
	g str32 hhid = hhidold
	duplicates report hhid	//	missing
	mer m:1 hhid using "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta", keepus(t0_hhid) gen(_18)
	ren (hhid t0_hhid)(hhid2018 HHID)
	mer m:1 HHID using "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta", keepus(h1aq5 ea) gen(_15)
	ren (HHID hhid2019)(hhid2015 hhid)
	drop if mi(hhid)
	isid hhid
	g str32 hhid_str=hhid
	keep hhid_str region-urban wgt ea
	ren (region regurb subreg district dc_2018 s1aq02a cc_2018 s1aq03a sc_2018 /*
	*/	 s1aq04a pc_2018 urban wgt)	/*
	*/	(r0_region r0_regurb r0_subreg r0_distname r0_distcode r0_countyname r0_countycode	/*
	*/	 r0_subconame r0_subcocode r0_parishname r0_parishcode r0_urban r0_wgt)
	tabstat r0_wgt, s(sum) format(%12.0fc)
	tempfile r0
	sa		`r0'
	restore
	mer m:1 hhid_str using `r0', gen(_r0) assert(1 2 3) keep(1 3)
	cou if mi(ea)
	
	*	get rid of unnecessary variables 
	ta r0_region region
	ta r0_regurb region, m
	ta round region, m
	

	
		*	just retain both for now 
	ds round CountyCode CountyName DistrictCode DistrictName ParishCode ParishName SubcountyCode SubcountyName hhid_str bseqno hhid region subreg urban Rq05 Rq09 wfinal ea pnl_* start_* r0_* _r0, not detail
	drop `r(varlist)'
	
	

	ren wfinal wgt
	la var wgt			"Sampling weight"
	
	g wtd = !mi(wgt)
	ta round wtd
	drop wtd
	
	isid hhid round
	sort hhid round

sa "${tmp_hfps_uga}/panel/cover.dta", replace 

*	modifications for construction of grand panel 
u "${tmp_hfps_uga}/panel/cover.dta", clear 


egen pnl_hhid = group(hhid)
egen pnl_admin1 = group(r0_region)
egen pnl_admin2 = group(r0_region r0_distname)
egen pnl_admin3 = group(r0_region r0_distname r0_countyname)

ta urban r0_urban,m
d urban r0_urban
la li Cq07 urbanx
g pnl_urban = (r0_urban==1) if !mi(r0_urban)
replace pnl_urban = (inlist(urban,1,2)) if mi(pnl_urban) & !mi(urban)

ta region urban,m
ta r0_region r0_urban,m
ta r0_regurb,m
d r0_region r0_urban r0_regurb
la li lbregu
g		pnl_strata = 1 if r0_regurb==11		//	calling all urban in central = Kampala, which is unsatisfying but 
replace pnl_strata = 2 if inlist(r0_regurb,21,31,41)
replace pnl_strata = 3 if r0_regurb==10
replace pnl_strata = 4 if r0_regurb==20
replace pnl_strata = 5 if r0_regurb==30
replace pnl_strata = 6 if r0_regurb==40
ta region urban if mi(pnl_strata),m
replace pnl_strata = 1 if mi(pnl_strata) & region=="Kampala"
replace pnl_strata = 2 if mi(pnl_strata) & inlist(urban,1,2)
replace pnl_strata = 3 if mi(pnl_strata) & region=="Central"
replace pnl_strata = 4 if mi(pnl_strata) & region=="Eastern"
replace pnl_strata = 5 if mi(pnl_strata) & region=="Northern"
replace pnl_strata = 6 if mi(pnl_strata) & region=="Western"
ta pnl_strata,m

*	per BID documentation, the cluster switched from EA in the original sample to Parish. 
ta ea,m
levelsof ParishCode
levelsof r0_parishcode
ta ParishCode r0_parishcode, m
tabstat r0_region r0_distcode r0_countycode r0_subcocode r0_parishcode, by(round) s(n)
egen pnl_cluster = group(r0_region r0_distcode r0_countycode r0_subcocode r0_parishcode)
tabstat DistrictCode CountyCode SubcountyCode ParishCode if mi(pnl_cluster), by(round) s(n)
*	to move forward with this step we need to verify that the coding is ocnsisten 
d r0_distcode DistrictCode
levelsof r0_distcode
levelsof DistrictCode if mi(r0_distcode)	//	at least 234 is present here and not r0_distcode. Thus we cannot just use the egen group approach. 
drop pnl_cluster	//	


su r0_distcode r0_countycode r0_subcocode r0_parishcode
su DistrictCode CountyCode SubcountyCode ParishCode	//no, code is not similar here in county and subcounty certainly
ta CountyCode round if mi(r0_countycode)
ta SubcountyCode round if mi(r0_subcocode)
li DistrictCode CountyCode SubcountyCode ParishCode if mi(r0_distcode) & CountyCode>10 & !mi(CountyCode)
tostring DistrictCode CountyCode SubcountyCode, gen(d c s)
g cl= length(c)
g sl= length(s)
ta cl sl
tab1 cl sl
li d c s if length(c)>2
replace s = subinstr(s,c,"",1) if length(s)==6
replace c = subinstr(c,d,"",1) if length(c)==4
destring d c s, replace
ta c s
assert d==DistrictCode
drop d	//	no need to keep 

egen x = rowfirst(r0_distcode DistrictCode)
assert x == r0_distcode if !mi(r0_distcode)
drop x

loc set1 r0_distcode r0_countycode r0_subcocode r0_parishcode
loc set2 DistrictCode c s ParishCode
foreach i of numlist 1/`: word count `set1'' {
	egen z`i' = rowfirst(`: word `i' of `set1'' `: word `i' of `set2'')
}
su z1-z4
tostring z1-z4, replace
forv i=2/4 {
	replace z`i' = "0"+z`i' if length(z`i')==1
	}
g str9 pnl_cluster = z1 + z2 + z3 + z4
destring pnl_cluster, replace

drop pnl_admin2 pnl_admin3		//	corollary must be true here too, but we will deal with pnl_admin1 differently
ta r0_region region,m
d r0_region region
replace pnl_admin1 = 1 if inlist(region,"Central","Kampala") & mi(pnl_admin1)
replace pnl_admin1 = 2 if inlist(region,"Eastern") & mi(pnl_admin1)
replace pnl_admin1 = 3 if inlist(region,"Northern") & mi(pnl_admin1)
replace pnl_admin1 = 4 if inlist(region,"Western") & mi(pnl_admin1)

g pnl_admin2 = z1, a(pnl_admin1)	//	already incorporates coding for region
g pnl_admin3 = z1 + z2, a(pnl_admin2)
destring pnl_admin?, replace
ta pnl_admin2 pnl_admin1	//	perfect 
su pnl_admin?
li region r0_region pnl_admin2 if mi(pnl_admin1) & !mi(pnl_admin2)	//	all are = 1
recode pnl_admin1 (.=1) if inrange(pnl_admin2,100,199)
su pnl_admin?
drop c s z1 z2 z3 z4

g pnl_wgt = wgt
su pnl_*

sa "${tmp_hfps_uga}/panel/pnl_cover.dta", replace 


// gr twoway scatter start_yr start_mo








