

dir "${raw_hfps_eth}", w


*	there is a switch in sample between phases 1 & 2


*	Phase 1
d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, si
d using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, si
d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, si




u "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh //	ir1_endearly-key
convert_date_time cs_startdate cs_submissiondate
d cs3b_kebeleid cs5_eaid
tab1 cs3b_kebeleid cs5_eaid
tempfile r1
sa		`r1'
// sa "${tmp_hfps_eth}/r1/cover.dta", replace

u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh //	ir1_endearly-key
convert_date_time cs_startdate cs_submissiondate
tempfile r2
sa		`r2'
// sa "${tmp_hfps_eth}/r2/cover.dta", replace

u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh /*ir1_endearly-*/ phw3
convert_date_time cs_startdate cs_submissiondate
tempfile r3
sa		`r3'
// sa "${tmp_hfps_eth}/r3/cover.dta", replace

u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh // ir1_endearly-_merge
// assert _merge==3
// drop _merge
convert_date_time cs_startdate cs_submissiondate
tempfile r4
sa		`r4'
// sa "${tmp_hfps_eth}/r4/cover.dta", replace

u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh //	ir1_endearly-ir_confident
convert_date_time cs_startdate cs_submissiondate
tempfile r5
sa		`r5'
// sa "${tmp_hfps_eth}/r5/cover.dta", replace

u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
tempfile r6
sa		`r6'
// sa "${tmp_hfps_eth}/r6/cover.dta", replace

u "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
tempfile r7
sa		`r7'
// sa "${tmp_hfps_eth}/r7/cover.dta", replace

u "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
tempfile r8
sa		`r8'
// sa "${tmp_hfps_eth}/r8/cover.dta", replace

u "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
tempfile r9
sa		`r9'
// sa "${tmp_hfps_eth}/r9/cover.dta", replace

u "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw*, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
tempfile r10
sa		`r10'
// sa "${tmp_hfps_eth}/r10/cover.dta", replace

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"		, clear
order wfinal, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
destring cs3c_cityid cs3c_subcityid cs6_hhid cs7_hhh_id ii1_attempt, replace
li cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid cs6_hhid ii4_resp_id in 1/10
tempfile r11
sa		`r11'
// sa "${tmp_hfps_eth}/r11/cover.dta", replace

u "${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order wfinal, a(household_id)
keep household_id-ii4_resp_relhhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
li cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid cs6_hhid ii4_resp_id in 1/10, nol
egen tail = ends(ii4_resp_id), punct(-) tail
order tail, a(ii4_resp_id)
la var tail	"`: var lab ii4_resp_id'"
drop ii4_resp_id
destring tail, replace
ren tail ii4_resp_id
tempfile r12
sa		`r12'
// sa "${tmp_hfps_eth}/r12/cover.dta", replace


*	let's systematize the checks for inconsistencies here 
d ii4_resp_id using `r1'
d ii4_resp_id using `r2'
d ii4_resp_id using `r3'
d ii4_resp_id using `r4'
d ii4_resp_id using `r5'
d ii4_resp_id using `r6'
d ii4_resp_id using `r7'
d ii4_resp_id using `r8'
d ii4_resp_id using `r9'
d ii4_resp_id using `r10'
d ii4_resp_id using `r11'
d ii4_resp_id using `r12'


#d ; 
clear; append using 
		`r1'
		`r2'
		`r3'
		`r4'
		`r5'
		`r6'
		`r7'
		`r8'
		`r9'
		`r10'
		`r11'
		`r12'
	, gen(round) force;
#d cr
la drop _append
la val round 
ta round 
assert round==cs12_round

isid household_id round

tab1 ii5_consent*, m	//	these are round 12 only, not useful here 
drop ii5_consent*		

*	dates
d cs_startdate	//	these are stata formatted
	li cs_startdate round if household_id=="020301088800303109"
	bys round : egen medianday1 = median(dofc(cs_startdate))
	tabstat medianday?, by(round) format(%td)
	g keep1 = cs_startdate		if inrange(dofc(cs_startdate)  ,medianday1-30,medianday1+30)
	format medianday? %td
	format keep? %tc
	li cs_startdate medianday? keep? round if household_id=="020301088800303109"

g double pnl_intclock = keep1
	ta round if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	
format pnl_intclock %tc
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	duplicates report household_id pnl_intdate
drop cs_startdate medianday? keep?
	
g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")


tab1 start_??
ta start_dy start_mo
ta start_mo start_yr
table (start_yr start_mo) round, nototal
li household_id pnl_intclock pnl_intdate start_* round if start_yr==2010
ta start_dy start_mo if round==8

tab1 ii4_resp_*
destring ii4_resp_id, replace
la li gender
ta ii4_resp_gender, gen(resp_sex)
g resp_nhead = ii4_resp_relhhh!=1


*	basic organization things
#d ; 
order round household_id ea_id 
	cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid 
	cs6_hhid cs7_hhh_id cs7a_hhh_gender cs7a_hhh_age cs12_round 
	ii1_attempt ii4_resp_id ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh 
	bi_locchange bi_same_hhh
	;
#d cr 
ta cs4_sector
format cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid %9.0g
li cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid ea_id in 1/10

format ii4_resp_id %9.0g
ta round ii4_resp_same, m

egen ea=group(ea_id)
la var ea	"Numerically coded ea (sampling cluster)"
egen wgt=rowfirst(phw1 phw2 phw3 phw4 phw5 phw6 phw7 phw8 phw9 phw10 wfinal)
order phw1 phw2 phw3 phw4 phw5 phw6 phw7 phw8 phw9 phw10 wfinal, b(wgt)
drop phw1 phw2 phw3 phw4 phw5 phw6 phw7 phw8 phw9 phw10 wfinal	//	easy to extract these if desired later
la var wgt	"Sampling weight (round-specific)"
tabstat wgt, by(round) s(sum) format(%12.3gc) nototal
svyset ea [pw=wgt], strata(cs4_sector)


*	fixes	
	*	roster issues
	recode ii4_resp_id (1=2) if household_id=="120203010100102031" & round==3
	drop if household_id=="041013088801410025" & round==10
	drop if household_id=="050213088801502044" & round==6
	drop if household_id=="130104010100219145" & round==7
	drop if household_id=="130108010100203100" & round==10

sa "${tmp_hfps_eth}/p1_cover.dta", replace
d using "${tmp_hfps_eth}/p1_cover.dta"




*	Phase 2
dir "${raw_hfps_eth}/*_cover_*", w
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta"	, si

d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta"

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta", clear
destring ii4_resp_id, replace
tempfile r13
sa		`r13'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta", clear
destring ii4_resp_id, replace
tempfile r14
sa		`r14'
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta", clear
destring ii4_resp_id, replace
tempfile r15
sa		`r15'


// dir "${raw_hfps_eth}/*_round19_*", w
// u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_roster_public.dta", clear
// u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta", clear
// mer 1:1 household_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta"	/*
// */	, keepus(phw) gen(_r13)
// foreach r of numlist 14(1)18 {
// mer 1:1 household_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round`r'_cover_interview_public.dta"	/*
// */	, keepus(phw*) gen(_r`r')
// }
// tabstat phw*, s(n sum) format(%12.0fc)
//
// u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta", clear
// destring ii4_resp_id, replace
// destring cs12_round, replace
// destring group, replace
// *	need a for the _m==3 at least
// mer 1:1 household_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"	/*
// */	, keepus(phw* cs4_sector) update 
// bys cs4_sector : egen tot = sum(phw18)
// keep if inlist(_m,1,3)
// bys cs4_sector : egen rmndr = sum(phw18)
// g factor = rmndr / tot if _m==3
// ta factor
// replace factor = 1+(1-factor)
// ta factor
// g phw19 = phw18 * factor
// bys cs4_sector : egen check = sum(phw19)
// format tot check %12.0fc
// ta tot check	//	slightly undershooting. leaving as-is for now
// tabstat phw18 phw19, by(cs4_sector) s(n sum) format(%12.0fc)
// ta tot
// drop _m tot rmndr factor check phw18
//
// tempfile r19
// sa		`r19'

#d ; 
clear; append using 
	`r13'
	`r14'	
	`r15'	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta"
, gen(round) ;
#d cr
la drop _append
la val round .
ta round 
ta round cs12_round, m
replace round=round+12
drop cs12_round	//	not present in all rounds 

ta ii4_resp_id round,m


isid household_id round

*	dates
d cs_startdate	//	these are stata formatted

	bys round : egen medianday1 = median(dofc(cs_startdate))
	tabstat medianday?, by(round) format(%td)
	g keep1 = cs_startdate		if inrange(dofc(cs_startdate)  ,medianday1-30,medianday1+30)

g double pnl_intclock = keep1
	ta round if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	
format pnl_intclock %tc
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	duplicates report household_id pnl_intdate
drop cs_startdate medianday? keep?
	
g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")
tab1 start_??
ta start_dy start_mo
ta start_mo start_yr
table (start_yr start_mo) round, nototal

tab1 ii4_resp_*
la li gender
ta ii4_resp_gender, gen(resp_sex)
g resp_nhead = ii4_resp_relhhh!=1

tab2 round ii5_consent*, m first	//	all=yes
drop ii5_consent*

bys household_id (round) : g ii4_resp_same = (ii4_resp_id==ii4_resp_id[_n-1])	//	ignores cases where the hh is not observed in a given round
ta ii4_resp_same round
la var ii4_resp_same	"Respondent is the same as in previous round"	

tab2 round cs1_region*, first
la li cs1_region cs1_regionid	//	no substantive change in codes 
replace cs1_region=cs1_regionid if mi(cs1_region) & !mi(cs1_regionid)
drop cs1_regionid

ta round group

li round household_id ea_id cs5_eaid in 1/20, sepby(household_id)
assert cs5_eaid==ea_id if round==16
assert mi(cs5_eaid) if round!=16
drop cs5_eaid	//	not additional information

*	basic organization things
#d ; 
order round household_id ea_id 
	cs1_region cs4_sector 
	ii1_attempt ii4_resp_id ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh 
	;
#d cr 
ta cs4_sector


egen ea=group(ea_id)
la var ea	"Numerically coded ea (sampling cluster)"
ds phw*
loc weights `r(varlist)'
tabstat `weights', by(round) s(n sum) format(%12.3gc)
egen wgt=rowfirst(`weights')
order `weights', b(wgt)
drop `weights'	//	easy to extract these if desired later
la var wgt	"Sampling weight (round-specific)"
tabstat wgt, by(round) s(sum) format(%12.3gc) nototal	//	updated total in r19 is rescaled following completion of ESS round
svyset ea [pw=wgt], strata(cs4_sector)

destring cs7_hhh_id, replace
sa "${tmp_hfps_eth}/p2_cover.dta", replace


u  "${tmp_hfps_eth}/p2_cover.dta", clear


clear 
append using "${tmp_hfps_eth}/p1_cover.dta" "${tmp_hfps_eth}/p2_cover.dta", gen(phase)
isid household_id round

table (start_yr start_mo) round, nototal

*	tabulating the change in sample (r1 is p1 baseline, r13 is p2 baseline)
u if round==1 using "${tmp_hfps_eth}/p1_cover.dta", clear
tempfile p1r1
sa `p1r1'
u if round==13 using "${tmp_hfps_eth}/p2_cover.dta", clear
mer 1:1 household_id using `p1r1', gen(_m)
ta cs4_sector _m, m
recode _m (1=2)(2=1), copyrest gen(panel)
la def panel 1 "Phase 1 Only" 2 "Phase 2 only" 3 "Both phases"
la val panel panel
la var panel	"Household panel type"
keep household_id panel
isid household_id
tempfile panel
sa `panel'

clear 
append using "${tmp_hfps_eth}/p1_cover.dta" "${tmp_hfps_eth}/p2_cover.dta", gen(phase)
isid household_id round

mer m:1 household_id using `panel', assert(3) nogen
order panel phase round household_id
isid household_id round
sort household_id round
sa "${tmp_hfps_eth}/cover.dta", replace


*	modifications for construction of grand panel 
u  "${tmp_hfps_eth}/cover.dta", clear
format cs1_region %15.3g
format cs4_sector cs5_eaid  %9.3g
li household_id round ea_id cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector in 1/20, sepby(household_id) nol
cou if cs2_zoneid>10
ta cs2_zoneid
li household_id round ea_id cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector if cs2_zoneid>100 & !mi(cs2_zoneid), sepby(household_id) nol
recode cs2_zoneid (101=1)(1202=2)
recode cs3_woredaid (10101 120201=1)
ta cs1_region
ta cs3c_cityid
ta cs3b_kebeleid
li household_id round ea_id cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid if cs3b_kebeleid>100 & !mi(cs3b_kebeleid), sepby(household_id) nol


egen pnl_hhid = group(household_id)	//	will be coded starting from 1, but with use of country we can make a correctly identified dataset

egen pnl_admin1 = group(cs1_region)
egen pnl_admin2 = group(cs1_region cs2_zoneid)
egen pnl_admin3 = group(cs1_region cs2_zoneid cs3_woredaid)
// egen pnl_admin4 = group(cs1_region cs2_zoneid cs3_woredaid cs3b_kebeleid)
ta cs4_sector, m
d cs4_sector
la li cs4_sector
g pnl_urban=(cs4_sector==2)
g pnl_strata = cs4_sector
ta ea_id round	//	round 6 has some oddities 
g x = length(ea_id)
ta x round
g y = ea_id if x==15
replace y = "0"+ea_id if x==14
ta y round
egen pnl_cluster = group(y)
drop x y 
g pnl_wgt = wgt 

sa "${tmp_hfps_eth}/pnl_cover.dta", replace	//	leave all variables in place, to be dropped for the append 
u  "${tmp_hfps_eth}/pnl_cover.dta", clear

svyset pnl_cluster [pw=pnl_wgt], strata(pnl_strata)
keep round phase pnl_* start_*





ex	


u "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", clear
keep household_id hhsize_r0-wt_panel_r10
ds *_r1
reshape long contact_r complete_r m0_14_r m65_r f15_64_r adulteq_r wt_r	/*
*/	interview_r hhsize_r m15_64_r f0_14_r f65_r head_chg_r	/*
*/	, i(household_id) j(round)

la drop s15q02b
la var round ""
drop fies_* respond_chg_* wt_panel_*

isid household_id round
ta round complete_r, m

mer 1:1 household_id round using "${tmp_hfps_eth}/p1_cover.dta"

ta round _m, m
ta round complete if

 

