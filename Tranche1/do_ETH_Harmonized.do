


********************************************************************************
********************************************************************************

***********************   ********  ********  **    **   ***********************
***********************   ********  ********  **    **   ***********************
***********************   **           **     **    **   ***********************
***********************   **           **     **    **   ***********************
***********************   *******      **     ********   ***********************
***********************   *******      **     ********   ***********************
***********************   **           **     **    **   ***********************
***********************   **           **     **    **   ***********************
***********************   ********     **     **    **   ***********************
***********************   ********     **     **    **   ***********************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************

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
keep household_id-bi_same_hhh //	ir1_endearly-key
convert_date_time cs_startdate cs_submissiondate
d cs3b_kebeleid cs5_eaid
tab1 cs3b_kebeleid cs5_eaid
sa "${local_storage}/tmp_ETH_r1_cover.dta", replace

u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id-bi_same_hhh //	ir1_endearly-key
convert_date_time cs_startdate cs_submissiondate
sa "${local_storage}/tmp_ETH_r2_cover.dta", replace

u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw, a(household_id)
keep household_id-bi_same_hhh /*ir1_endearly-*/ phw3
convert_date_time cs_startdate cs_submissiondate
sa "${local_storage}/tmp_ETH_r3_cover.dta", replace

u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw, a(household_id)
keep household_id-bi_same_hhh // ir1_endearly-_merge
// assert _merge==3
// drop _merge
convert_date_time cs_startdate cs_submissiondate
sa "${local_storage}/tmp_ETH_r4_cover.dta", replace

u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
keep household_id-bi_same_hhh //	ir1_endearly-ir_confident
convert_date_time cs_startdate cs_submissiondate
sa "${local_storage}/tmp_ETH_r5_cover.dta", replace

u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
sa "${local_storage}/tmp_ETH_r6_cover.dta", replace

u "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
sa "${local_storage}/tmp_ETH_r7_cover.dta", replace

u "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
sa "${local_storage}/tmp_ETH_r8_cover.dta", replace

u "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
sa "${local_storage}/tmp_ETH_r9_cover.dta", replace

u "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
order phw, a(household_id)
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
sa "${local_storage}/tmp_ETH_r10_cover.dta", replace

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"		, clear
keep household_id-bi_same_hhh
convert_date_time cs_startdate cs_submissiondate
destring cs3b_kebeleid cs5_eaid, replace
destring cs3c_cityid cs3c_subcityid cs6_hhid cs7_hhh_id ii1_attempt, replace
li cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector cs5_eaid cs6_hhid ii4_resp_id in 1/10
sa "${local_storage}/tmp_ETH_r11_cover.dta", replace

u "${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
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
sa "${local_storage}/tmp_ETH_r12_cover.dta", replace


*	let's systematize the checks for inconsistencies here 
d ii4_resp_id using "${local_storage}/tmp_ETH_r1_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r2_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r3_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r4_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r5_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r6_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r7_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r8_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r9_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r10_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r11_cover.dta"
d ii4_resp_id using "${local_storage}/tmp_ETH_r12_cover.dta"


#d ; 
clear; append using 
	"${local_storage}/tmp_ETH_r1_cover.dta"
	"${local_storage}/tmp_ETH_r2_cover.dta"
	"${local_storage}/tmp_ETH_r3_cover.dta"
	"${local_storage}/tmp_ETH_r4_cover.dta"
	"${local_storage}/tmp_ETH_r5_cover.dta"
	"${local_storage}/tmp_ETH_r6_cover.dta"
	"${local_storage}/tmp_ETH_r7_cover.dta"
	"${local_storage}/tmp_ETH_r8_cover.dta"
	"${local_storage}/tmp_ETH_r9_cover.dta"
	"${local_storage}/tmp_ETH_r10_cover.dta"
	"${local_storage}/tmp_ETH_r11_cover.dta"
	"${local_storage}/tmp_ETH_r12_cover.dta"
	, gen(round) force;
#d cr
la drop _append
la val round 
ta round 
assert round==cs12_round

isid household_id round

tab1 ii5_consent*, m	//	these are round 12 only, not useful here 
drop ii5_consent*		

d cs_startdate	//	these are stata formatted
g double pnl_intclock = cs_startdate
format pnl_intclock %tc
drop cs_startdate 
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
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
g resp_nhead = ii4_resp_relhh!=1


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

sa "${local_storage}/tmp_ETH_p1_cover.dta", replace
d using "${local_storage}/tmp_ETH_p1_cover.dta"




*	Phase 2
dir "${raw_hfps_eth}/*_cover_*", w
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"	, si

d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"
d ii4_resp_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta"

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_cover_interview_inf_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r13_cover.dta", replace
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_cover_interview_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r14_cover.dta", replace
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r15_cover.dta", replace
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_cover_interview_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r16_cover.dta", replace
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r17_cover.dta", replace
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_cover_interview_public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r18_cover.dta", replace

*	non-public round 19
u "${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Cover&Interview_Public.dta", clear
destring ii4_resp_id, replace
sa "${local_storage}/tmp_ETH_r19_cover.dta", replace

#d ; 
clear; append using 
 "${local_storage}/tmp_ETH_r13_cover.dta"
 "${local_storage}/tmp_ETH_r14_cover.dta"	
 "${local_storage}/tmp_ETH_r15_cover.dta"	
 "${local_storage}/tmp_ETH_r16_cover.dta"	
 "${local_storage}/tmp_ETH_r17_cover.dta"	
 "${local_storage}/tmp_ETH_r18_cover.dta"	
 "${local_storage}/tmp_ETH_r19_cover.dta"	
, gen(round) ;
#d cr
la drop _append
la val round 
ta round 
ta round cs12_round, m
replace round=round+12
drop cs12_round	//	not present in all rounds 

ta ii4_resp_id round,m


isid household_id round

*	dates
d cs_startdate	//	these are stata formatted

g pnl_intclock = cs_startdate
format pnl_intclock %tc
drop cs_startdate 
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
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
g resp_nhead = ii4_resp_relhh!=1

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
egen wgt=rowfirst(phw1 phw2 phw3 phw4 phw5 phw18 phw19)
order phw1 phw2 phw3 phw4 phw5 phw18 phw19, b(wgt)
drop phw1 phw2 phw3 phw4 phw5 phw18 phw19	//	easy to extract these if desired later
la var wgt	"Sampling weight (round-specific)"
tabstat wgt, by(round) s(sum) format(%12.3gc) nototal
svyset ea [pw=wgt], strata(cs4_sector)


sa "${local_storage}/tmp_ETH_p2_cover.dta", replace


u  "${local_storage}/tmp_ETH_p2_cover.dta", clear


clear 
append using "${local_storage}/tmp_ETH_p1_cover.dta" "${local_storage}/tmp_ETH_p2_cover.dta", gen(phase)
isid household_id round

table (start_yr start_mo) round, nototal

*	tabulating the change in sample (r1 is p1 baseline, r13 is p2 baseline)
u if round==1 using "${local_storage}/tmp_ETH_p1_cover.dta", clear
tempfile p1r1
sa `p1r1'
u if round==13 using "${local_storage}/tmp_ETH_p2_cover.dta", clear
mer 1:1 household_id using `p1r1'
ta cs4 _m, m
recode _m (1=2)(2=1), copyrest gen(panel)
la def panel 1 "Phase 1 Only" 2 "Phase 2 only" 3 "Both phases"
la val panel panel
la var panel	"Household panel type"
keep household_id panel
isid household_id
tempfile panel
sa `panel'

clear 
append using "${local_storage}/tmp_ETH_p1_cover.dta" "${local_storage}/tmp_ETH_p2_cover.dta", gen(phase)
isid household_id round

mer m:1 household_id using `panel', assert(3) nogen
order panel phase round household_id
isid household_id round
sort household_id round
sa "${local_storage}/tmp_ETH_cover.dta", replace


*	modifications for construction of grand panel 
u  "${local_storage}/tmp_ETH_cover.dta", clear
format cs1_region %15.3g
format cs4_sector cs5_eaid  %9.3g
li household_id round ea_id cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector in 1/20, sepby(household_id) nol
cou if cs2_zone>10
ta cs2_zone
li household_id round ea_id cs1_region cs2_zoneid cs3_woredaid cs3c_cityid cs3c_subcityid cs3b_kebeleid cs4_sector if cs2_zone>100 & !mi(cs2_zone), sepby(household_id) nol
recode cs2_zone (101=1)(1202=2)
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
g pnl_wgt = wgt 

sa "${local_storage}/tmp_ETH_pnl_cover.dta", replace	//	leave all variables in place, to be dropped for the append 
u  "${local_storage}/tmp_ETH_pnl_cover.dta", clear

keep round phase pnl_* start_*


/*	clean up component datasets	*/
// loc toclean : dir "${hfps_github}" files "tmp_ETH_r*_cover.dta"
// foreach x of local toclean {
// 	dis "`x'"
// 	erase "${hfps_github}/`x'"
// }
// loc toclean : dir "${hfps_github}" files "tmp_ETH_p?_cover.dta"
// foreach x of local toclean {
// 	dis "`x'"
// 	erase "${hfps_github}/`x'"
// }


********************************************************************************
}	/*	end Cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************

*	household roster 
dir "${raw_hfps_eth}", w


*	Phase 1
d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_roster.dta"
d using	"${raw_hfps_eth}/R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
d using	"${raw_hfps_eth}/R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"
d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"

#d ;
loc raw1  "r1_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw2  "r2_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw3  "r3_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw4  "r4_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw5  "r5_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw6  "r6_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw7  "r7_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw8  "r8_wb_lsms_hfpm_hh_survey_public_roster.dta"				; 
loc raw9  "R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"				; 
loc raw10 "R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"			; 
loc raw11 "wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"	; 
loc raw12 "wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"	; 

u "${raw_hfps_eth}/`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)12 {;
	u "${raw_hfps_eth}/`raw`r''" , clear;
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
li name var1 var2 var3 if matches>=10, sep(0)
li name var1 var2 var3 if matches<10, sep(0)

li _* if name=="submissiondate", nol
*	could add in flagging variables that are of a different type, but going to just ignore for now I htink 



*	submissiondate switches to double %tc in round 7. However, we will likely not use it anyway as it drops out in round 9

#d ;
clear; append using
	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_roster.dta"
	"${raw_hfps_eth}/R9_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
	"${raw_hfps_eth}/R10_WB_LSMS_HFPM_HH_Survey_Public_Roster.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round11_clean_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_roster_round12_clean_public.dta"
	, gen(round) force;
#d cr
drop submissiondate
la drop _append
la val round 
ta round 

*	identification
duplicates report household_id individual_id round
duplicates tag household_id individual_id round, gen(tag)
li household_id individual_id round bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh if tag>0, sepby(household_id)
bys household_id (individual_id round) : egen maxtag = max(tag)
format individual_id bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh %9.3g
li household_id individual_id round bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh tag if maxtag>0, sepby(household_id)
	*	all duplicate cases have one obs with Yes new member and one with no new member, and all were yes new in the previous round. 
drop if household_id=="030714010100520052" & individual_id==2 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
drop if household_id=="120302088800703022" & individual_id==4 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
drop if household_id=="140710010701008072" & individual_id==5 & round==6 & bi2_hhm_new=="Yes":bi2_hhm_new & tag==1
isid household_id individual_id round
drop tag maxtag

tab2 round bi2_hhm_new bi3_hhm_stillm, first

	     gen member=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex=bi4_hhm_gender
		 gen age=bi5_hhm_age
		 recode age (-98=.)
	     gen head=(bi6_hhm_relhhh==1)
	     gen relation=bi6_hhm_relhhh 
		 la copy bi6_hhm_relhhh relation
		 la val relation relation
		 la val relation .	//	prefer the phase 2 labels 
		 recode relation (-99 -98=.)
		 replace relation=. if member!=1
		 replace head=0 if member!=1
		 gen relation_os=bi6_hhm_relhhh_other if inlist(relation,13,15)
		 
	  //respondent	
	  d using "${local_storage}/tmp_ETH_p1_cover.dta"
	  g ii4_resp_id = individual_id

	 /*	old investigations
	mer 1:1 household_id ii4_resp_id round using "${local_storage}/tmp_ETH_p1_cover.dta"
	la drop _merge
	la val _merge
	bys household_id round (individual_id) : egen _m2 = max(_m==2)
	li household_id round individual_id ii4_resp_id _me if _m2==1, sepby(household_id)
// 	li round individual_id ii4_resp_id _me if household_id=="120203010100102031", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="041013088801410025", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="050213088801502044", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="130104010100219145", sepby(round)	//->	now addressed in fix in cover.do
	li round individual_id ii4_resp_id _me if household_id=="130108010100203100", sepby(round)	//->	now addressed in fix in cover.do

	format ii4_* %9.3g
	li individual_id ii4_resp_id _me bi2_hhm_new bi3_hhm_stillm bi4_hhm_gender bi5_hhm_age bi6_hhm_relhhh ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh if _m2==1, sepby(household_id)
		replace sex=ii4_resp_gender if _m==2

	*/
	mer 1:1 household_id ii4_resp_id round using "${local_storage}/tmp_ETH_p1_cover.dta", assert(1 3) keepus(ii4_resp_id ii4_resp_gender ii4_resp_age ii4_resp_relhhh)
		gen respond=(_m==3) 
	la drop _merge
	drop _merge
	
		format ii4_* %9.3g
 ta sex ii4_resp_gender if respond==1, m
 compare age ii4_resp_age if respond==1
 ta relation ii4_resp_relhhh if respond==1, m


** DROP UNNECESSARY VARIABLES		 
      drop bi2-bi8 ii4_*

	  isid household_id individual_id round
	  sort household_id individual_id round
	  sa "${local_storage}/tmp_ETH_p1_ind.dta", replace

	  
	  
*	phase 2
*	household roster 
dir "${raw_hfps_eth}/*roster*", w

#d ;
loc raw13  "wb_lsms_hfpm_hh_survey_round13_roster_public.dta"				; 
loc raw14  "wb_lsms_hfpm_hh_survey_round14_roster_public.dta"				; 
loc raw15  "wb_lsms_hfpm_hh_survey_round15_roster_public.dta"				; 
loc raw16  "wb_lsms_hfpm_hh_survey_round16_roster_public.dta"				; 
loc raw17  "wb_lsms_hfpm_hh_survey_round17_roster_public.dta"				; 
loc raw18  "wb_lsms_hfpm_hh_survey_round18_roster_public.dta"				; 

u "${raw_hfps_eth}/`raw13'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos13 type13 isnum13 fmt13 val13 var13);
tempfile base;
sa      `base';
foreach r of numlist 14(1)18 {;
	u "${raw_hfps_eth}/`raw`r''" , clear;
	d, replace clear;
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r');
	tempfile r`r';
	sa      `r`r'';
	u `base', clear;
	mer 1:1 name using `r`r'', gen(_`r');
	sa `base', replace ;
};
u `base', clear;
#d cr Z
egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=4
ta name matches if matches<4

levelsof name if matches>=4, clean
li name var13 var14 var15 if matches>=4, sep(0)


u 	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_roster_public.dta", clear
destring individual_id, replace	// inconsistent
tempfile r18
sa		`r18'

#d ;
clear; append using
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_roster_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_roster_public.dta"
	`r18'
	, gen(round);
#d cr
la drop _append
la val round 
replace round=round+12	//	consistency with phase 1 
	  ta round 

	isid household_id individual_id round, missok
	ta round if mi(individual_id)
	li household_id individual_id round bi* if mi(individual_id), nol
	
	levelsof household_id if mi(individual_id)
	sort household_id round individual_id 
	li household_id individual_id round bi* if household_id=="041009010100207260", nol sepby(round)
	li household_id individual_id round bi* if household_id=="060108010100319073", nol sepby(round)
	li household_id individual_id round bi* if household_id=="070603010100105018", nol sepby(round)
	li household_id individual_id round bi* if household_id=="130106010100108072", nol sepby(round)	
		//	more complication in this last case, it's a new member of some type apparently, but the 42 year old shifts id in the subsequent rounds 
		*	enforcing de facto decisions shown in this listing exercise 
	recode individual_id (.=5)  if household_id=="041009010100207260" & round==14
	recode individual_id (.=5)  if household_id=="060108010100319073" & round==14
	recode individual_id (.=10) if household_id=="070603010100105018" & round==13	//	person not captured in round 14, but captured in round 15 (sex/age/rltn)
	recode individual_id (.=2)(2=3)  if household_id=="130106010100108072" & round==13	//	making consistent with subsequent rounds 
	isid household_id individual_id round
	  
	  
	     gen member=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex=bi4_hhm_gender
		 gen age=bi5_hhm_age
		 recode age (-98=.)
	     gen head=(bi6_hhm_relhhh==1)
	     gen relation=bi6_hhm_relhhh 
		 recode relation (-99 -98=.)
		 la copy bi6_hhm_relhhh relation
		 la val relation relation
		 replace relation=. if member!=1
		 replace head=0 if member!=1
		 gen relation_os=bi6_hhm_relhhh_other if inlist(relation,13,15)
		 
	  //respondent	
	  d using "${local_storage}/tmp_ETH_p2_cover.dta"
	  g ii4_resp_id = individual_id
	  
	mer 1:1 household_id ii4_resp_id round using "${local_storage}/tmp_ETH_p2_cover.dta", keepus(ii4_resp_id ii4_resp_same ii4_resp_gender ii4_resp_age ii4_resp_relhhh)
		
		gen respond=(_m==3) 
		
	la drop _merge
	la val _merge
	ta ii4_resp_id round if _me==2	//	-96 in all cases 
	ta ii4_resp_id ii4_resp_same if _me==2	//	some are the same as previous round somehow 
	ta ii4_resp_relhh
	
	bys household_id round (individual_id) : egen _m2 = max(_m==2)
	ta round _m2
// 	li household_id round individual_id ii4_resp_id ii4_resp_same sex age relation ii4_resp_gender ii4_resp_age ii4_resp_relhh _me if _m2==1, sepby(household_id)
	*	no straightforward fix is possible here 
	drop if _merge==2
	
 ta sex ii4_resp_gender if respond==1, m
 compare age ii4_resp_age if respond==1
 ta relation ii4_resp_relhhh if respond==1, m
 
	drop _merge _m2 ii4_*
	
	


** DROP UNNECESSARY VARIABLES		 
      drop key ea_id phw? phw?? bi* cs12_round group*

	  isid household_id individual_id round
	  sort household_id individual_id round
	  sa "${local_storage}/tmp_ETH_p2_ind.dta", replace

	  
*	combine individual datasets
clear 
append using "${local_storage}/tmp_ETH_p1_ind.dta" "${local_storage}/tmp_ETH_p2_ind.dta", gen(phase)
la drop _append
la val phase .
la val relation relation

	*	respondent check
	bys household_id round (individual_id) : egen testresp = sum(respond)
	ta round testresp
	
	*	step 1 replace with prior round respondent if available
	bys household_id individual_id (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

	bys household_id round (individual_id) : egen testresp2 = sum(respond)
	ta round testresp2,m	//	round  13 mainly, as well as 14
	ta respond member,m
	li household_id round individual_id member respond if testresp2==0, sepby(household_id)
	by household_id : egen flagresp = min(testresp2)
	li household_id round individual_id member respond age sex testresp2 if flagresp==0, sepby(household_id)
	li household_id round individual_id member respond age sex testresp2 if flagresp==0 & (respond==1 | testresp2==0), sepby(household_id)
	*	step 2 use respondent from subsequent rounds 
	su round, meanonly
	g backwards = -1 * (round-r(max)-r(min))
	bys household_id individual_id (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 
	*	also code=1 if any singletons exist 
	bys household_id round (individual_id) : replace respond =1 if testresp2!=1 & _N==1	//	none
	
	bys household_id round (individual_id) : egen testresp3 = sum(respond)
	ta round testresp3
	ta household_id if testresp3==0
	dis r(r)	//	11 cases 
	by household_id : egen flagresp2 = min(testresp3)
	li household_id round individual_id member respond age sex relation testresp3 if flagresp2==0, sepby(household_id)
	li household_id round individual_id member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0), sepby(household_id)

	*	these primarily appear to be cases where the respondent was not captured on the household roster
	*	make some choices
	levelsof household_id if flagresp2==0, loc(cases) 
	preserve
	foreach i of local cases {
	u household_id round ii4_* if inlist(household_id,"`i'") using "${local_storage}/tmp_ETH_p2_cover.dta", clear
	li, sep(0)
	}
	restore	//	these are all -96 cases 
	
	*	these two cases are unique and can't be explained by the assumption that the respondent was omitted from the hh roster for some reason
	recode respond (0=1) if household_id=="130108010100301020" & individual_id==1 	//	only two rounds for this hh, both affected
	recode respond (0=1) if household_id=="030614088801003032" & individual_id==3	//	arbitrary 
	*	make a new flag variable to isolate the cases that remain
	bys household_id round (individual_id) : egen testresp4 = sum(respond)
	levelsof household_id if testresp4==0, loc(cases) clean
	
	*	add the round 14 respondent observation as the round 13 respondent for these houseohlds 
	foreach case of local cases {
	expand 2 if household_id=="`case'" & round==14 & respond==1, gen(mark)
	recode round 14=13 if mark==1
	drop mark
	}

	bys household_id round (individual_id) : egen testresp5 = sum(respond)
	assert testresp5==1

	drop surveyed-testresp5
	


*	fill in with prior round information where possible
su
cou
foreach x in age sex relation {
	tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
bys household_id individual_id (round) : egen `maxmiss'= max(mi(`x'))
by  household_id individual_id (round) : egen `maxnmiss'= max(`x')
by  household_id individual_id (round) : egen `minnmiss'= min(`x')
by  household_id individual_id (round), rc0 : egen `modenmiss'= mode(`x')

g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
su `x' if `maxmiss'==1
replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
su `x' if `maxmiss'==1

drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
	}
	

isid household_id individual_id round
sort household_id individual_id round
sa "${local_storage}/tmp_ETH_ind.dta", replace

ta round member

*	use individual panel to make demographics 
u "${local_storage}/tmp_ETH_ind.dta", clear

*	respondent characteristics
foreach x in sex age head relation {
	bys household_id round (individual_id) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys household_id round (individual_id) : egen headtest = sum(head) 
bys household_id round (individual_id) : egen resptest = sum(respond) 
bys household_id round (individual_id) : egen memtest = sum(member) 
tab1 *test,m


	*	restrict sample prior to construction of demographics
	keep if member==1

su 

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

	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(household_id round)	

sa "${local_storage}/tmp_ETH_demog.dta", replace
 
********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment	*/ 
********************************************************************************

/*	employment 
dir "${raw_hfps_eth}", w


*	Phase 1
d em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d em* using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"	, si
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si


#d ;
loc raw1  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw2  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw3  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw4  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw5  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"; 
loc raw6  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw7  "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw8  "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw9  "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw10 "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw11 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	; 
loc raw13 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta";
loc raw14 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta";
loc raw16 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta";
loc raw18 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta";

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2/11 13 14 16 {;
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

sort name
g namesort = cond(substr(name,1,2)=="em",substr(name,3,strpos(name,"_")-3),"")
sort namesort
li name _* if substr(name,1,2)=="em", nol sep(0)

ta matches if !mi(namesort)
*	could add in flagging variables that are of a different type, but going to just ignore for now I htink 
*/


*	check for respondent variables 
*	Phase 1
u "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl *espond* *ESPOND*) detail

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail


*	check for hours variables 
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail


*	check for activity variables 
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl "*hour*")

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl "*hour*")



*	check for closure variables 
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r1
sa		`r1'
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r2
sa		`r2'
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r3
sa		`r3'
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r4
sa		`r4'
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
d em19_bus_*, replace clear
tempfile r5
sa		`r5'
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r6
sa		`r6'
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r7
sa		`r7'
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r8
sa		`r8'
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r9
sa		`r9'
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r10
sa		`r10'
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
d em19_bus_*, replace clear
tempfile r11
sa		`r11'

u `r1', clear
foreach i of numlist 1/11 { 
	mer 1:1 name varlab using `r`i'', gen(_`i')
}
// bro

g label = subinstr(varlab,"EM19: ","",1)
g value = subinstr(vallab,"em19_bus_inc_low_why_","",1)
destring value, replace ignore(_)
keep if isnumeric==1
g lname = "em19_bus_inc_low_why"
keep lname label value 
tempfile em19
sa `em19'

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r13
sa		`r13'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r14
sa		`r14'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r16
sa		`r16'

u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r18
sa		`r18'

u `em19', clear
foreach i of numlist 13 14 16 18 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	/*	need a recode of rounds 14+ 	*/ 

	


********************************************************************************
********************************************************************************
*	end investigations, begin construction
********************************************************************************
********************************************************************************
#d ;
loc raw1  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw2  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw3  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw4  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw5  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"; 
loc raw6  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw7  "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw8  "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw9  "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw10 "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw11 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	; 
loc raw13 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta";
loc raw14 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta";
loc raw16 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta";
loc raw18 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta";

foreach r of numlist 1/11 13 14 16 18 {;
u household_id em* using "`raw`r''", clear;
g round=`r', b(household_id);
tempfile em`r';
sa		`em`r'';
};

clear; 
append using `em1' `em2' `em3' `em4' `em5' `em6' `em7' `em8' `em9' `em10' `em11' 
			 `em13' `em14' `em16' `em18', force;
isid household_id round; 
sort household_id round; 
#d cr
			
// ds em*, not(type string)
// tabstat `r(varlist)', by(round) c(s)


d em*, f

ta em1_work_cur round,m
la li em1_work_cur
g  work_cur = em1_work_cur if inlist(em1_work_cur,0,1)
g nwork_cur=1-work_cur

ta em7_work_cur_status round,m	//	missing in rounds 13+
ta em5_work_cur_status round,m	//	missing in rounds 1-11
ta em7_work_cur_status em1_work_cur,m

la li em7_work_cur_status em5_work_cur_status
egen wage_cur = anymatch(em7_work_cur_status em5_work_cur_status), v(1/6 10/12)
egen biz_cur  = anymatch(em7_work_cur_status em5_work_cur_status), v(7/9)
recode wage_cur biz_cur (nonm=.) if !inlist(em1_work_cur,0,1)

ta round em3_work_no_why

d *_farm
tab2 round em20_farm em21_farm em18_farm, first m
egen temporary = rowfirst(em20_farm em21_farm em18_farm)
g farm_cur = (temporary==1) if !mi(temporary)
drop temporary
ta farm_cur round,m
recode farm_cur (nonm=.) if !inlist(em1_work_cur,0,1)

la var work_cur		"Respondent currently employed"
la var nwork_cur	"Respondent currently unemployed"
la var wage_cur		"Respondent mainly employed for wages"
la var biz_cur		"Respondent mainly employed in household enterprise"
la var farm_cur		"Respondent mainly employed on family farm"

*	sector
tab2 round em6_work_cur_act em4_work_cur_act, m first
egen sector_cur = rowfirst(em6_work_cur_act em4_work_cur_act)
ta sector_cur
recode sector_cur (1=1)(2=2)(3 5=5)(4=6)(6=8)(7 9=9)(8=4)	//	 more limited than NGA/MWI/TZA
run "${hfps_github}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"
			
*	no hours


**	NFE
 tab2 round em15_bus em15a_bus_prev, first m	//	s6q11 changes to continuous in round 20
g		refperiod_nfe = (em15_bus==1) if !mi(em15_bus)
la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"

*	sector 
tab2 round em16_bus_sector ema12_bus_sector, first m
la li em16_bus_sector ema12_bus_sector
egen sector_nfe = rowfirst(em16_bus_sector ema12_bus_sector)
recode sector_nfe (1=1)(2=2)(3 5=5)(4=6)(6=8)(7 9=9)(8=4)	
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"
ta sector_nfe round,m

tab2 round em15_bus em15a_bus ema11_bus, m first
egen temporary = rowfirst(em15_bus ema11_bus)
g open_nfe = (temporary==1) if !mi(temporary)
la var open_nfe		"NFE is currently open"
drop temporary


*	challenges faced	
d em19_bus_inc_low_why_*	//	these do not mesh with the other countries
tabstat em19_bus_inc_low_why_?, by(round)
d em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3
tab2 round em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3, first
la li em17_why_low_inc
	*	adjust the round 14 & 16 versions of em17 to match other codes
	recode em17_why_low_inc? (1=2)(2=3)(3=4)(4=5)(5=6)(6=7)(7=8)(8=9) if round>13

	ta round em16_bus_inc_low_amt
	ta em16_bus_inc_low_amt if !mi(em17_why_low_inc1),m
	
	
	
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/7	{	
	loc v em19_bus_inc_low_why_`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","EM19: `i'. ","",1)
	la var challenge`i'_nfe "`lbl'"
	egen temp = anymatch(em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3), v(`i')
	replace challenge`i'_nfe = (temp==1) if !mi(em17_why_low_inc1)
	drop temp
}
tabstat challenge*_nfe, by(round)	
tabstat challenge*_nfe, by(round) s(n)	


keep household_id round *_cur *_nfe
drop em1_work_cur	//	cleanup 
sa "${local_storage}/tmp_ETH_employment.dta", replace 




********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************


dir "${raw_hfps_eth}", w


*	there is a switch in sample between phases 1 & 2


*	Phase 1
d fi* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d fi* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d fi* using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		




u "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

// g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
// g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
// g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
// g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
// g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)

keep household_id runout-whlday
sa "${local_storage}/tmp_ETH_r1_fies.dta", replace

u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r2_fies.dta", replace

u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r3_fies.dta", replace

u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r4_fies.dta", replace

u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r5_fies.dta", replace

u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r6_fies.dta", replace


u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"		, clear
keep household_id fi*
ds, has(vallabel fi*)
loc list `r(varlist)'
ren fi?_* fi?
la li `list'
la copy `: word 1 of `list'' fi
la val fi? fi

*	question order altered for Ethiopia. 

g worried	= fi1=="Yes":fi if inlist(fi1,"No":fi,"Yes":fi)
g healthy	= fi2=="Yes":fi if inlist(fi2,"No":fi,"Yes":fi)
g fewfood	= fi3=="Yes":fi if inlist(fi3,"No":fi,"Yes":fi)
g skipped	= fi4=="Yes":fi if inlist(fi4,"No":fi,"Yes":fi)
g ateless	= fi5=="Yes":fi if inlist(fi5,"No":fi,"Yes":fi)
g runout	= fi7=="Yes":fi if inlist(fi7,"No":fi,"Yes":fi)
g hungry	= fi8=="Yes":fi if inlist(fi8,"No":fi,"Yes":fi)
g whlday	= fi6=="Yes":fi if inlist(fi6,"No":fi,"Yes":fi)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r11_fies.dta", replace


*	Phase 2
dir "${raw_hfps_eth}/*fies*.dta", w

d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_fies_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_fies_public.dta"	

u "${raw_hfps_eth}//wb_lsms_hfpm_hh_survey_round15_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r15_fies.dta", replace

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r17_fies.dta", replace


u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)
tabstat worried-whlday, by(group) s(n)
keep household_id worried-whlday
sa "${local_storage}/tmp_ETH_r18_fies.dta", replace



*	construct panel to match to cover and demog 
#d ; 
clear; append using 
	"${local_storage}/tmp_ETH_r1_fies.dta"
	"${local_storage}/tmp_ETH_r2_fies.dta"
	"${local_storage}/tmp_ETH_r3_fies.dta"
	"${local_storage}/tmp_ETH_r4_fies.dta"
	"${local_storage}/tmp_ETH_r5_fies.dta"
	"${local_storage}/tmp_ETH_r6_fies.dta"
	"${local_storage}/tmp_ETH_r11_fies.dta"
	"${local_storage}/tmp_ETH_r15_fies.dta"
	"${local_storage}/tmp_ETH_r17_fies.dta"
	"${local_storage}/tmp_ETH_r18_fies.dta"
	, gen(round);
#d cr
la drop _append
la val round 
ta round 
replace round=round+4 if round>6
replace round=round+3 if round>11
replace round=round+1 if round>15
ta round

order round household_id worried healthy fewfood skipped ateless runout hungry whlday
tabstat worried-whlday, by(round) s(n sum) 

isid household_id round
d using "${local_storage}/tmp_ETH_cover.dta"
mer 1:1 household_id round using "${local_storage}/tmp_ETH_cover.dta", keepus(wgt cs4_sector)
ta round _m	//	one _m=1 in round 6 
keep if _m==3
drop _merge
d using "${local_storage}/tmp_ETH_demog.dta"
mer 1:1 household_id round using "${local_storage}/tmp_ETH_demog.dta", keepus(hhsize) assert(2 3) keep(3) nogen



g wgt_hh = hhsize * wgt
assert !mi(wgt_hh)

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

g na="NA"
g urban = (cs4_sector=="Urban":cs4_sector)

cap : erase "${local_storage}/FIES_ETH_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if round!=1 & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_ETH_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3), though hungry is low at .756
	2	Equating: Worried is far above (0.44) global standard, hungry also 
		high (0.33). On balance, most are below, so started by dropping worried. 
		Remainder are all <=.35, though Hungry = 0.32 
	3	downloaded and saved as FIES_ETH_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
2	50.18	5.59	7.77	2.97
3	48.35	5.65	6.94	2.86
4	45.45	5.83	5.58	2.43
5	44.27	6.17	6.75	3.13
6	40.48	6.06	6.79	2.90
11	42.49	7.48	6.40	3.88
15	52.47	14.93	10.50	8.35
17	43.84	16.27	8.83	7.41
18	56.13	13.43	14.61	11.46
*/
					/*	ARCHIVE notes on process done in Shiny app
						1	All infit inrange(0.7,1.3), 
						2	Equating: Worried is far above (0.43) global standard, hungry also high (0.35). On 
							balance, most are below, so started by dropping worried. Remainder are all <=.35
						3	downloaded and saved as FIES_ETH_out.csv
					*/
					
					/*	when using all, individual level (note that here "region" = survey round)
					Prevalence rates of food insecurity by region (% of individuals)
						Moderate or Severe	MoE	Severe	MoE
					2	50.59	5.60	7.81	2.97
					3	48.76	5.66	6.97	2.85
					4	45.84	5.86	5.61	2.43
					5	44.63	6.19	6.80	3.13
					6	40.82	6.07	6.82	2.90
					11	42.88	7.50	6.43	3.88
					15	52.79	14.85	10.60	8.33
					17	44.21	16.23	8.94	7.51
					*/

levelsof round if round>1, loc(rounds)
foreach r of local rounds {
// 	loc r=18
	cap : erase "${local_storage}/FIES_ETH_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_ETH_r`r'_in.csv", delim(",")
}

/*
round 2 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .53 
	3	downloaded and saved as FIES_ETH_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .54 
	3	downloaded and saved as FIES_ETH_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .47 
	3	downloaded and saved as FIES_ETH_r4_out.csv

round 5 
	1	Hungry low at 0.628, retained for consistency with other rounds 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r5_out.csv

round 6 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r6_out.csv

round 11 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Healthy and WholeDay are low 
		at 0.37 and 0.47 respectively, while Hungry is high at 0.47.  
	3	downloaded and saved as FIES_ETH_r11_out.csv

round 15 
	1	Hungry low at 0.652, retained for consistency with other rounds 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r15_out.csv

round 17 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35 though
		skipped is a bit high at 0.34. 
	3	downloaded and saved as FIES_ETH_r17_out.csv

round 18 
	1	Hungry low at 0.630, Runout low at .687. Both are retained for
		consistency with other rounds. 
	2	Equating: Worried initially high at .62. Dropped worried per panel rule. 
		Remaining items are <=.35 though runout is a bit high at 0.31. 
	3	downloaded and saved as FIES_ETH_r18_out.csv



*/




*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${local_storage}/FIES_ETH_out.csv", varn(1) clear
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
import delimited using "${local_storage}/FIES_ETH_r`r'_out.csv", varn(1) clear
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

keep round household_id fies_*
sa "${local_storage}/tmp_ETH_fies.dta", replace
	
	

/*	clean up component datasets	*/
loc toclean : dir "${hfps_github}" files "tmp_ETH_r*_fies.dta"
foreach x of local toclean {
	dis "`x'"
	erase "${hfps_github}/`x'"
}
/*	clean up component CSVs (*_in only)	*/
loc toclean : dir "${hfps_github}" files "FIES_ETH*_in.csv"
foreach x of local toclean {
	dis "`x'"
	erase "${hfps_github}/`x'"
}


********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************
	*	not yet included 
********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************

*	shocks/ income loss  
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*shock_coping*", w

*	Phase 1
d lc* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d lc* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_shock_coping"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si




*	Phase 1
u household_id lc* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
li lc4_total_chg_cope_3 lc4_total_chg_cope_4 if !mi(lc4_total_chg_cope_other)	//	seems reasonable to recode here, 
u household_id lc* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_shock_coping.dta"		, clear
la li shockcode cop3_mechani



#d ;
clear; append using

  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta" 
  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
, gen(round) keep(household_id lc*) force; 

#d cr
isid household_id round 
sort household_id round 
la drop _append 
la val round
ta round

tab2 round lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg, first m
la li lc1_farm lc1_bus lc1_we lc1_rem_dom lc1_rem_for lc1_isp lc1_pen lc1_gov lc1_ngo lc1_other
egen lc1_total = anymatch( lc1_farm lc1_bus lc1_we lc1_rem_dom lc1_rem_for lc1_isp lc1_pen lc1_gov lc1_ngo lc1_other), v(1)		
la li lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg		

*	income loss components 
keep round household_id  lc1_farm-lc3_total_chg 
ren lc1_* inc_d_*
ren lc2_*_chg inc_chg_*

ds inc_d_*, not(type string)
egen inc_d_total = anymatch(`r(varlist)'), v(1)
ta inc_d_total round
la var inc_d_total	"Any income source identified in last year"
ta inc_d_total lc3_total_chg	//	change is identified regardless of whether x was identified as an income source 
ren lc3_total_chg inc_chg_total
order inc_d_total, b(inc_chg_total)

la copy lc1_farm inc_d
ds inc_d_*, not(type string)
la val `r(varlist)' inc_d
la copy lc3_total_chg inc_chg
la val inc_chg_* inc_chg

la li inc_chg
ds inc_chg_*, not(type string)
loc vars `r(varlist)'
foreach x of local vars {
	loc token = substr("`x'",length("inc_chg_")+1,length("`x'")-length("inc_chg_"))
	g inc_loss_`token' = (inlist(`x',3,4)) if !mi(inc_chg_`token'), a(`x')
	loc lbl = substr("`: var lab `x''",length("LC1: ")+1,strpos("`: var lab `x''","Change")-length("LC1: "))
	la var inc_d_`token'	"Any `lbl'"
	la var inc_chg_`token'	"Change in `lbl'"
	la var inc_loss_`token'	"Any loss of `lbl'"
}

ren *_we *_wage	//	switch this token 

sa "${local_storage}/tmp_ETH_hh_income_loss.dta", replace 



#d ;
clear; append using

  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta" 
  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
, gen(round) keep(household_id lc*) force; 

#d cr
isid household_id round 
sort household_id round 
la drop _append 
la val round
ta round

		egen shock_yn = anymatch(lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg), v(3 4)
		la var shock_yn		"Household reported any shock since last asked"
		
		ta shock_yn lc3_total_chg,m
		drop lc1* lc2*
		ta lc3_total_chg if !mi(lc4_total_chg_cope),m
		
		replace shock_yn = (inlist(lc3_total_chg,3,4))
		drop lc3_total_chg lc4_total_chg_cope
		
		ren lc4_total_chg_cope_* sc*
		drop sc_98 sc_99 scother
		ren (sc2 sc3 sc4 sc5  sc6  sc7  sc8  sc9 sc10 sc11 sc12 sc13 sc14 sc15  sc0 sc_96)	/*
		*/	(sc6 sc7 sc8 sc9 sc11 sc12 sc13 sc14 sc15 sc16 sc17 sc18 sc19 sc20 sc21 sc96)
		ren sc* shock_cope_*
	la var shock_cope_1  "Sale of assets (ag and no-ag) to cope with shock"
	la var shock_cope_6  "Engaged in additional income generating activities to cope with shock"
	la var shock_cope_7  "Received assistance from friends & family to cope with shock"
	la var shock_cope_8  "Borrowed from friends & family to cope with shock"
	la var shock_cope_9  "Took a loan from a financial institution to cope with shock"
	la var shock_cope_11 "Credited purchases to cope with shock"
	la var shock_cope_12 "Delayed payment obligations to cope with shock"
	la var shock_cope_13 "Sold harvest in advance to cope with shock"
	la var shock_cope_14 "Reduced food consumption to cope with shock"
	la var shock_cope_15 "Reduced non-food consumption to cope with shock"
	la var shock_cope_16 "Relied on savings to cope with shock"
	la var shock_cope_17 "Received assistance from ngo to cope with shock"
	la var shock_cope_18 "Took advanced payment from employer to cope with shock"
	la var shock_cope_19 "Received assistance from government to cope with shock"
	la var shock_cope_20 "Was covered by insurance policy to cope with shock"
	la var shock_cope_21 "Did nothing to cope with shock"
	la var shock_cope_96 "Other (specify) to cope with shock"

		

sa "${local_storage}/tmp_ETH_hh_shocks.dta", replace 



********************************************************************************
}	/*	Shocks / Coping end	*/ 
********************************************************************************


********************************************************************************
{	/*	label_item_cd	*/ 
********************************************************************************
cap :	program drop	label_item_cd
		program define	label_item_cd
label define item_cd 1 `"1. Teff"', modify
label define item_cd 2 `"2. Wheat"', modify
label define item_cd 3 `"3. Barley"', modify
label define item_cd 4 `"4. Maize"', modify
label define item_cd 5 `"5. Sorghum"', modify
label define item_cd 6 `"6. Millet"', modify
label define item_cd 7 `"7. Horsebeans"', modify
label define item_cd 8 `"8. Field Pea"', modify
label define item_cd 9 `"9. Chick Pea"', modify
label define item_cd 10 `"10. Lentils"', modify
label define item_cd 11 `"11. Haricot Beans"', modify
label define item_cd 12 `"12. Niger Seed"', modify
label define item_cd 13 `"13. Linseed"', modify
label define item_cd 14 `"14. Onion"', modify
label define item_cd 15 `"15. Banana"', modify
label define item_cd 16 `"16. Potato"', modify
label define item_cd 17 `"17. Kocho"', modify
label define item_cd 19 `"19. Milk"', modify
label define item_cd 20 `"20. Cheese"', modify
label define item_cd 21 `"21. Eggs"', modify
label define item_cd 22 `"22. Sugar"', modify
label define item_cd 23 `"23. Salt"', modify
label define item_cd 24 `"24. Coffee"', modify
label define item_cd 25 `"25. Chat / Kat"', modify
label define item_cd 26 `"26. Bula"', modify
label define item_cd 60 `"60. Other cereal (SPECIFY)"', modify
label define item_cd 110 `"110. Ground nuts"', modify
label define item_cd 111 `"111. Other pulse or nut (SPECIFY)"', modify
label define item_cd 131 `"131. Other seed (SPECIFY)"', modify
label define item_cd 141 `"141. Green chili pepper (kariya)"', modify
label define item_cd 142 `"142. Red pepper (berbere)"', modify
label define item_cd 143 `"143. Greens (kale, cabbage, etc.)"', modify
label define item_cd 144 `"144. Tomato"', modify
label define item_cd 145 `"145. Other vegetable (SPECIFY)"', modify
label define item_cd 151 `"151. Orange"', modify
label define item_cd 152 `"152. Other fruit (SPECIFY)"', modify
label define item_cd 170 `"170. Sweet potato"', modify
label define item_cd 171 `"171. Boye/Yam"', modify
label define item_cd 172 `"172. Cassava"', modify
label define item_cd 173 `"173. Godere"', modify
label define item_cd 180 `"180. Goat & mutton meat"', modify
label define item_cd 181 `"181. Beef"', modify
label define item_cd 182 `"182. Poultry"', modify
label define item_cd 183 `"183. Fish"', modify
label define item_cd 195 `"195. Purchased Injera"', modify
label define item_cd 196 `"196. Purchased Bread or Biscuits"', modify
label define item_cd 197 `"197. Pasta\Maccaroni"', modify
label define item_cd 198 `"198. Other prepared food and consumed at home"', modify
label define item_cd 201 `"201. butter/ghee"', modify
label define item_cd 202 `"202. Oils (processed)"', modify
label define item_cd 203 `"203. Tea"', modify
label define item_cd 204 `"204. Soft drinks/Soda"', modify
label define item_cd 205 `"205. Beer"', modify
label define item_cd 206 `"206. Tella"', modify
label define item_cd 901 `"901. Oats"', modify
label define item_cd 902 `"902. Vetch"', modify
label define item_cd 903 `"903. Sesame"', modify
label define item_cd 904 `"904. Sunflower"', modify
label define item_cd 905 `"905. Fenugreek"', modify
label define item_cd 906 `"906. Lemons"', modify
label define item_cd 907 `"907. Mangos"', modify
label define item_cd 908 `"908. Beet root"', modify
label define item_cd 909 `"909. Cabbage"', modify
label define item_cd 910 `"910. Carrot"', modify
label define item_cd 911 `"911. Garlic"', modify
label define item_cd 912 `"912. Kale"', modify
label define item_cd 913 `"913. Pumpkins"', modify
label define item_cd 914 `"914. Gesho"', modify
label define item_cd 915 `"915. Avocados"', modify
		
		end
********************************************************************************
}	/*	label_item_cd end	*/ 
********************************************************************************


********************************************************************************
{	/*	label_unit	*/ 
********************************************************************************
cap :	program drop	label_unit
		program define	label_unit
label define unit 1 `"1. Kilogram"', modify
label define unit 2 `"2. Gram"', modify
label define unit 3 `"3. Quintal"', modify
label define unit 4 `"4. Litres"', modify
label define unit 5 `"5. Mili Liter"', modify
label define unit 6 `"6. Box/Casa"', modify
label define unit 7 `"7. Jenbe"', modify
label define unit 8 `"8. Jog"', modify
label define unit 9 `"9. Melekiya"', modify
label define unit 21 `"21. Akumada/Dawla/Lekota Small"', modify
label define unit 22 `"22. Akumada/Dawla/Lekota Large"', modify
label define unit 31 `"31. Birchiko Small"', modify
label define unit 32 `"32. Birchiko Medium"', modify
label define unit 33 `"33. Birchiko Large"', modify
label define unit 41 `"41. Bunch Small"', modify
label define unit 42 `"42. Bunch Medium"', modify
label define unit 43 `"43. Bunch Large"', modify
label define unit 51 `"51. Chinet Small"', modify
label define unit 52 `"52. Chinet Medium"', modify
label define unit 53 `"53. Chinet Large"', modify
label define unit 61 `"61. Esir Small"', modify
label define unit 62 `"62. Esir Medium"', modify
label define unit 63 `"63. Esir Large"', modify
label define unit 71 `"71. Festal Small"', modify
label define unit 72 `"72. Festal Medium"', modify
label define unit 73 `"73. Festal Large"', modify
label define unit 81 `"81. Joniya/Kasha Small"', modify
label define unit 82 `"82. Joniya/Kasha Medium"', modify
label define unit 83 `"83. Joniya/Kasha Large"', modify
label define unit 91 `"91. Kerchat/Kemba Small"', modify
label define unit 92 `"92. Kerchat/Kemba Medium"', modify
label define unit 93 `"93. Kerchat/Kemba Large"', modify
label define unit 101 `"101. Kubaya/Cup Small"', modify
label define unit 102 `"102. Kubaya/Cup Medium"', modify
label define unit 103 `"103. Kubaya/Cup Large"', modify
label define unit 111 `"111. Kunna/Mishe/Kefer/Enkib Small"', modify
label define unit 112 `"112. Kunna/Mishe/Kefer/Enkib Medium"', modify
label define unit 113 `"113. Kunna/Mishe/Kefer/Enkib Large"', modify
label define unit 121 `"121. Madaberia/Nuse/Shera/Cheret Small"', modify
label define unit 122 `"122. Madaberia/Nuse/Shera/Cheret Medium"', modify
label define unit 123 `"123. Madaberia/Nuse/Shera/Cheret Large"', modify
label define unit 131 `"131. Medeb Small"', modify
label define unit 132 `"132. Medeb Medium"', modify
label define unit 133 `"133. Medeb Large"', modify
label define unit 141 `"141. Piece/number Small"', modify
label define unit 142 `"142. Piece/number Medium"', modify
label define unit 143 `"143. Piece/number Large"', modify
label define unit 151 `"151. Sahin Small"', modify
label define unit 152 `"152. Sahin Medium"', modify
label define unit 153 `"153. Sahin Large"', modify
label define unit 161 `"161. Shekim Small"', modify
label define unit 162 `"162. Shekim Medium"', modify
label define unit 163 `"163. Shekim Large"', modify
label define unit 171 `"171. Sini Small"', modify
label define unit 172 `"172. Sini Medium"', modify
label define unit 181 `"181. Tasa/Tanika/Shember/Selemon Small"', modify
label define unit 182 `"182. Tasa/Tanika/Shember/Selemon Medium"', modify
label define unit 183 `"183. Tasa/Tanika/Shember/Selemon Large"', modify
label define unit 191 `"191. Zorba/Akara Small"', modify
label define unit 192 `"192. Zorba/Akara Medium"', modify
label define unit 193 `"193. Zorba/Akara Large"', modify
label define unit 900 `"900. Other(Specify)"', modify
		
		end
********************************************************************************
}	/*	label_unit end	*/ 
********************************************************************************


********************************************************************************
{	/*	label_item	*/ 
********************************************************************************
cap :	program drop	label_item
		program define	label_item

cap : la drop item
#d ; 
la def item
           2 "wheat grain"
           3 "maize grain"
           4 "sorghum grain"
           5 "bread"
           6 "injera"
           7 "cooking oil"
           8 "onions"
           9 "tomatoes"
          10 "sugar"
          11 "charcoal"
          12 "firewood"
          13 "kerosene"
         111 "red teff grain"
         112 "white teff grain"
         113 "mixed teff grain"

          22 "wheat flour"
          23 "maize flour"
          24 "sorghum flour"
         131 "red teff flour"
         132 "white teff flour"
         133 "mixed teff flour"
		 ;
#d cr
		
		end
********************************************************************************
}	/*	label_item end	*/ 
********************************************************************************


********************************************************************************
{	/*	price_cf	*/ 
********************************************************************************

/*
d using "${et_hfps_out}/dta/r1_cover.dta"
u cs1_region cs4_sector using "${et_hfps_out}/dta/r1_cover.dta", clear
la li cs1_region cs4_sector 
// ta  cs1_region cs4_sector

dir "${raw_lsms_eth1}"
d using "${raw_lsms_eth1}/Food_CF_Wave4.dta"
	*	Addis not represented here... will have to sue national I suppose 
*/	
u "${raw_lsms_eth1}/Crop_CF_Wave4.dta", clear
	
u "${raw_lsms_eth1}/Food_CF_Wave4.dta", clear
/*
duplicates report item_cd unit_cd
duplicates report item_cd_cf item_cd unit_cd	//	identified
duplicates report item_cd_cf unit_cd	//	identified
ta item_cd_cf if mi(item_cd)	//	none of these are considered in the HFPS data
assert item_cd==item_cd_cf if !mi(item_cd)
*/
drop item_cd 
isid item_cd_cf unit_cd	
drop note

ren mean_cf_nat natl_cf
reshape long mean_cf, i(item_cd unit_cd) j(cs1_region)
ren mean_cf rgnl_cf
su rgnl_cf natl_cf

	preserve
bys unit_cd : egen min = min(rgnl_cf)
bys unit_cd : egen max = max(rgnl_cf)
g unity = min if min==max
keep if !mi(unity)
keep unit_cd unity
ta unit_cd
duplicates drop
li, sep(0)
keep if inrange(unit_cd,1,5)
tempfile unity
sa `unity'
	restore
	
	ta unit_cd
reshape wide rgnl_cf natl_cf, i(item_cd cs1_region) j(unit_cd)
reshape long
	ta unit_cd 
	ta unit_cd if mi(rgnl_cf)
mer m:1 unit_cd using `unity', assert(1 3) nogen
replace rgnl_cf = unity if mi(rgnl_cf)
replace natl_cf = unity if mi(natl_cf)
drop unity 


*	construct typical relationship between units S/M/L triplets and fill? 

	*	identify triplet sets
recode unit_cd (31/33=3)(41/43=4)(51/53=5)(61/63=6)(71/73=7)(81/83=8)(91/93=9)(101/103=10)(111/113=11)(121/123=12)(131/133=13)(141/143=14)(151/153=15)(161/163=16)(181/183=18)(191/193=19)(else=.), gen(triplets)
ta item_cd unit_cd 
g s = inlist(unit_cd,31,41,51,61,71,81,91,101,111,121,131,141,151,161,181,191)
g m = inlist(unit_cd,32,42,52,62,72,82,92,102,112,122,132,142,152,162,182,192)
g l = inlist(unit_cd,33,43,53,63,73,83,93,103,113,123,133,143,153,163,183,193)

*	regional conversion factor adjustment 
*	generate the s/m/l values across each triplet 
bys item_cd cs1_region triplets (unit_cd) : egen s_cf = max(rgnl_cf * cond(s==1,1,.))
by  item_cd cs1_region triplets (unit_cd) : egen m_cf = max(rgnl_cf * cond(m==1,1,.))
by  item_cd cs1_region triplets (unit_cd) : egen l_cf = max(rgnl_cf * cond(l==1,1,.))
su s_cf m_cf l_cf	//	m most common, s & l equally common. prefer m as the base where possible 
*	do cases exist where one of S/M/L are not defined? 
cou if mi(s_cf) & !mi(m_cf)	//	891
cou if mi(s_cf) & !mi(l_cf)	//	33
cou if mi(m_cf) & !mi(l_cf)	//	220

*	make the typical relationships between s/m/l for the triplets, accounting for regional difference
bys triplets cs1_region (unit_cd item_cd) : egen l_s = median(l_cf / s_cf)
by  triplets cs1_region (unit_cd item_cd) : egen l_m = median(l_cf / m_cf)
by  triplets cs1_region (unit_cd item_cd) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace rgnl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(rgnl_cf)

*	make typical relationships ignoring regional differences 
drop l_s l_m m_s
bys triplets (cs1_region unit_cd item_cd) : egen l_s = median(l_cf / s_cf)
by  triplets (cs1_region unit_cd item_cd) : egen l_m = median(l_cf / m_cf)
by  triplets (cs1_region unit_cd item_cd) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace rgnl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(rgnl_cf)
	*	none of these add additional data 
drop ?_cf l_s l_m m_s


*	national conversion factor adjustment 
*	generate the s/m/l values across each triplet 
bys item_cd triplets (unit_cd) : egen s_cf = max(natl_cf * cond(s==1,1,.))
by  item_cd triplets (unit_cd) : egen m_cf = max(natl_cf * cond(m==1,1,.))
by  item_cd triplets (unit_cd) : egen l_cf = max(natl_cf * cond(l==1,1,.))
su s_cf m_cf l_cf	//	m most common, s & l equally common. prefer m as the base where possible 
cou if mi(s_cf) & !mi(m_cf)	//	649
cou if mi(s_cf) & !mi(l_cf)	//	24
cou if mi(m_cf) & !mi(l_cf)	//	160

*	make typical relationships between s/m/l for the triplet 
bys triplets (unit_cd item_cd) : egen l_s = median(l_cf / s_cf)
by  triplets (unit_cd item_cd) : egen l_m = median(l_cf / m_cf)
by  triplets (unit_cd item_cd) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace natl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(natl_cf)
replace natl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(natl_cf)
replace natl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(natl_cf)
replace natl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(natl_cf)
replace natl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(natl_cf)
replace natl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(natl_cf)
drop ?_cf l_s l_m m_s

drop s m l triplets


*	two doublets as well 
*	identify doublet sets 
recode unit_cd (21/22=2)(171/172=17)(else=.), gen(doublets)
g s = inlist(unit_cd,21,171)
g l = inlist(unit_cd,22,172)

*	regional conversion factor adjustment 
*	generate the s/l values across each doublet 
bys item_cd cs1_region doublets (unit_cd) : egen s_cf = max(rgnl_cf * cond(s==1,1,.))
by  item_cd cs1_region doublets (unit_cd) : egen l_cf = max(rgnl_cf * cond(l==1,1,.))
su s_cf l_cf	//	s & l equally common. prefer m as the base where possible 
cou if mi(s_cf) & !mi(l_cf)	//	nothing to fix 
cou if mi(l_cf) & !mi(s_cf)	//	nothing to fix 
drop s_cf l_cf

*	national conversion factor adjustment, simply verify that the tests above would also be valid for natl_cf 
assert !mi(natl_cf) if !mi(rgnl_cf)
assert !mi(rgnl_cf) if !mi(natl_cf)
drop doublets s l 





*	following fixes, restrict to cases where we have CFs
drop if mi(rgnl_cf) & mi(natl_cf)



expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=5) if mark==1		//	Somali
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=13) if mark==1	//	Harar
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=15) if mark==1	//	Dire Dawa
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=14) if mark==1	//	Addis
replace rgnl_cf = natl_cf if mark==1	//	special treatment for Addis 
drop mark
drop if cs1_region==99	

*	two new units in the price data
expand 2 if unit_cd==5, gen(mark)
recode unit_cd (5=194) if mark==1
replace rgnl_cf = rgnl_cf * 330 if mark==1
replace natl_cf = natl_cf * 330 if mark==1
drop mark
expand 2 if unit_cd==5, gen(mark)
recode unit_cd (5=195) if mark==1
replace rgnl_cf = rgnl_cf * 475 if mark==1
replace natl_cf = natl_cf * 475 if mark==1
drop mark




sa "${local_storage}/tmp_ETH_price_cf.dta", replace 

********************************************************************************
}	/*	price_cf end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************


*	price 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*price*", w

*	Phase 1
// d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
// d using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta", clear
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta", clear	
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta", clear
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta", clear
la li item	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta", clear
la li item	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type

*	will do reduced set from what is possible here, focusing on panel compatibility
*	not reorganizing the item code as it is stable across rounds
#d ; 
clear; append using
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"
	, gen(round); replace round=round+12;  la drop _append; la val round; 

la def fp_00 11	"Charcoal" 12 "Firewood" 13 "Kerosene", add; 
recode fp_00 (111/113=1)(2=2)(3=4)(4=5)(5=196)(6=195)(7=202)(8=14)(9=144)(10=22)
	(else=.), gen(item_cd_cf);

#d cr
isid household_id round fp_00
ta fp_00 round, m

ta fp_00 fp2_type	//	in round 13 where fp2_type is not available, looks pretty safe to say it's grain
	*	where household always uses the same type, use that type 
bys household_id fp_00 (round) : egen min=min(fp2_type)
bys household_id fp_00 (round) : egen max=max(fp2_type)
replace fp2_type = min if mi(fp2_type) & min==max & !mi(fp2_unit)
ta fp_00 fp2_type
recode fp2_type (.=1) if inlist(fp_00,2,3,4,111,112,113) & !mi(fp2_unit)


*	bring in conversion factor
mer m:1 household_id round using "${local_storage}/tmp_ETH_cover.dta", assert(2 3) keep(3) nogen keepus(cs1_region)

la li fp2_unit
ta fp2_unit
	//	what are 196,197,900
	ta fp_00 round if inlist(fp2_unit,196,197,900)	//	primarily firewood units
	
g unit_cd = fp2_unit

mer m:1 item_cd_cf unit_cd cs1_region using "${local_storage}/tmp_ETH_price_cf.dta", keep(1 3) 
	tab1 item_cd_cf unit_cd cs1_region if _m==1

	
	*	dominated by piece 
	ta fp_00 if inlist(unit_cd,141,142,143) & _m==1	//	injera, bread
	
g kg = fp2_quant * rgnl_cf if fp2_quant>0
ta kg if item_cd_cf==195	//	most are 1 kg 
ta kg if item_cd_cf==196	//	looks fairly reasonable to let a piece of bread = 1 kg 
ta unit_cd item if inlist(item,195,196) & kg 
ta item if inlist(unit_cd,141,142,143) & mi(kg)	//	piece units 

g etb_kg = fp3_price / kg if fp3_price>0
g etb_pc = fp3_price / fp2_quant if inlist(item,195,196) & inlist(unit,141,142,143) & fp3_price>0 & fp2_quant>0
tabstat etb_kg etb_pc, by(item) s(n min p50 max) format(%12.3gc) c(s)
	*	some outliers remain on the high side 
	li round item unit rgnl_cf fp2_quant kg fp3_price etb_kg if etb_kg>8000 & !mi(etb_kg)
	*	looks like 250 gm instead of 25, and 1 kg instead of 1 gm, but safer just to drop 
	li round item unit rgnl_cf fp2_quant kg fp3_price etb_kg if etb_kg<1 & !mi(etb_kg), sepby(round)
	

g unitprice = cond(inlist(item,195,196),etb_pc,cond(inrange(etb_kg,1,8000),etb_kg,.))	//	this 8000 ETB threshold is currently about $150 US
la var unitprice	"Unit Price (LCU/kg)"	//	this includes converted total quantities, noting that "kg" = piece for bread and injera
drop item_cd_cf-_m
drop kg etb_kg etb_pc



tabstat unitprice, by(fp_00) s(n min p50 me max) format(%12.3gc) c(s)	

g price = cond(!inlist(fp_00,5,6) & inlist(fp2_unit,1,4),fp2_quant,cond(inlist(fp_00,5,6) & inlist(fp2_unit,141,142,143),unitprice,.))
la var	price		"Price (LCU/standard unit)"

g unitcost = fp3_price / fp2_quant
la var unitcost		"Unit cost (LCU/unit)"


ta fp_00 fp2_type
la li fp_00
g item=fp_00
replace item=item+20 if fp2_type=="Flour":_type_
label_item
la val item item
inspect item
assert r(N_undoc)==0
ta fp_00 item 
la var item	"Item code"

decode item, gen(itemstr)
la var itemstr	"Item code"
decode fp2_unit, gen(unitstr)
la var unitstr		"Unit"

	
ta fp1_available, m	//	2% don't know, non-trivial... 
ta fp_00 fp1_available,m
la li Yes_No
g 		item_avail = (fp1_available==1) 	//	if inlist(fp1_available,1,0)	//	will presume these to be no since price is missing there anyway
la var	item_avail	"Item is available for sale"
ta fp_00 item_avail,m




keep  household_id round item itemstr item_avail unitstr price unitcost unitprice
order household_id round item itemstr item_avail unitstr price unitcost unitprice
isid  household_id round item
sort  household_id round item
sa "${local_storage}/tmp_ETH_price.dta", replace 


********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************

*	economic sentiment 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*economic_sentiment*", w

*	Phase 1
// d  using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
// d  using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_economic_sentiment_public.dta"	, clear
la li _all


#d ; 
clear; append using 
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_economic_sentiment_public.dta"	
	, gen(round); 
#d cr
la drop _append
la val round .
replace round = round+13
replace round = round+1 if round>15
 ta round

d eco*
la li eco_1 eco_2 eco_3 eco_4 eco_5 eco_6 eco_7 eco_8 eco_9_events

tabstat eco_? eco_9_events?, by(group) s(n)
ta eco_1
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = eco_1==`i' if !mi(eco_1)
	la var sntmnt_last12mohh_cat`l' "`: label eco_1 `i''"
}

ta eco_2 group, m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = eco_2==`i' if !mi(eco_2)
	la var sntmnt_next12mohh_cat`l' "`: label eco_2 `i''"
}

ta eco_3
la li eco_3
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = eco_3==`i' if !mi(eco_3)
	la var sntmnt_last12moNtl_cat`l' "`: label eco_3 `i''"
}

ta eco_4, m
la li eco_4
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = eco_4==`i' if !mi(eco_4)
	la var sntmnt_next12moNtl_cat`l' "`: label eco_4 `i''"
}

ta eco_5, m
la li eco_5
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 -98 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = eco_5==`i' if !mi(eco_5)
	la var sntmnt_last12moPrice_cat`l' "`: label eco_5 `i''"
}


ta eco_6, m
la li eco_6
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = eco_6==`i' if !mi(eco_6)
	la var sntmnt_next12moPrice_cat`l' "`: label eco_6 `i''"
}

ta eco_7, m
la li eco_7
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = eco_7==`i' if !mi(eco_7)
	loc lbl = subinstr("`: label eco_7 `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

ta eco_8, m
la li eco_8
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = eco_8==`i' if !mi(eco_8)
	la var sntmnt_weatherrisk_cat`l' "`: label eco_8 `i''"
}
ren sntmnt_*_cat98 sntmnt_*_cat97


ta eco_8 eco_9_events1, m	//	skips aren't entirely clear, but looks like specifying an event was optional for the likely/very likely responders 
la li eco_9_events

li eco_9_other if eco_9_events1==-96	//	unusual/unseasonal rainfall
ta eco_9_events1, m
g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)5	{
	loc l=abs(`i')
	egen   sntmnt_weatherevent_cat`l' = anymatch(eco_9_events?) if !mi(eco_9_events1), v(`i') 
// 	la var sntmnt_weatherevent_cat`l' "`: label eco_9_events `i''"
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
la var sntmnt_weatherevent_cat5		"Storms"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep household_id round sntmnt_*
isid household_id round
sort household_id round

sa "${local_storage}/tmp_ETH_economic_sentiment.dta", replace 
d using "${local_storage}/tmp_ETH_economic_sentiment.dta",  

********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************

dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*shock_coping*", w

*	Phase 1
// d  using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
// d  using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_subjective_welfare_public.dta"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_subjective_welfare_public.dta"		, clear


la li adequecy_sub
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (sub1_food==`i')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (sub2_food==`i')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (sub3_food==`i')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
recode sub4_food (-97=4)
foreach i of numlist 1(1)3 4 {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (sub4_food==`i')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

ta sub5_food,m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = sub5_food==`i'
	la var sw_income_cat`i'	"`: label (sub5_food) `i''"
}

ta sub6_food, m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = sub6_food==`i'
	la var sw_happy_cat`i'	"`: label (sub6_food) `i''"
}


ta sub7a_acc, m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = sub7a_acc==`i'
	la var ad_accident_cat`i'	"`: label (sub7a_acc) `i''"
}

ta sub7b_my, m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = sub7b_my==`i'
	la var ad_myown_cat`i'	"`: label (sub7b_my) `i''"
}

ta sub7c_feel, m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = sub7c_feel==`i'
	la var ad_otherin_cat`i'	"`: label (sub7c_feel) `i''"
}

ta sub7d_det, m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = sub7d_det==`i'
	la var ad_selfdet_cat`i'	"`: label (sub7d_det) `i''"
}

ta sub7e_cha, m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = sub7e_cha==`i'
	la var ad_noprotect_cat`i'	"`: label (sub7e_cha) `i''"
}

ta sub7f_fam, m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = sub7f_fam==`i'
	la var ad_otherout_cat`i'	"`: label (sub7f_fam) `i''"
}

ta sub7g_pro, m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = sub7g_pro==`i'
	la var ad_iprotect_cat`i'	"`: label (sub7g_pro) `i''"
}

ta sub7h_luck, m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = sub7h_luck==`i'
	la var ad_luck_cat`i'	"`: label (sub7h_luck) `i''"
}

ta sub7i_litt, m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = sub7i_litt==`i'
	la var ad_comprotect_cat`i'	"`: label (sub7i_litt) `i''"
}



d sw_*, f
su sw_*, sep(0)

d ad_*, f
su ad_*, sep(0)

g round=16
keep household_id round sw_* ad_*

sa "${local_storage}/tmp_ETH_subjective_welfare.dta", replace 

********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************

*	shocks/ income loss  
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*agriculture*", w

*	Phase 1
// d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ag* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ag* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ag* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d ag* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ph* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_agriculture_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_shock_coping"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si

*	non-public round 19
dir "${raw_hfps_eth2}"
d using "${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Agriculture_Crop_Public.dta"

********************************************************************************
*	three distinct data structures, thus three distinct sets of syntax 
********************************************************************************
*	version 1
u household_id ag* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear

u household_id ag* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear

u household_id ag* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear

u household_id ag* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear

d ag3_crops_reas* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ag3_crops_reas* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d ag3_crops_reas* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d ag3_crops_reas* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		


{	/*	version 1, rounds 3(1)6 */
	#d ;
clear; append using
  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta" 
  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
, gen(round) keep(household_id ag*) force; 
la drop _append; la val round .;
#d cr
isid household_id round
replace round=round+2

*	1	hh has grown crops since beginning of agricultural season 
loc v1 ag1_crops
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"


*	5	not able to conduct hh ag activities
loc v5 ag3_crops_reas_
d `v5'*,f
tabstat `v5'? `v5'_??, by(round)
la li `v5'1
ta `v5'other
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4?)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'8==1) if !mi(`v5'8)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'9==1) if !mi(`v5'9)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
g		ag_nogrow_cat8 = (`v5'_96==1 & inlist(`v5'other,"Heavy Rain and Flooding")) if !mi(`v5'_96)
la var	ag_nogrow_cat8		"Climate"
g		ag_nogrow_cat9 = (`v5'_96==1 & inlist(`v5'other,"Insects (Non-Locust)","Locusts")) if !mi(`v5'_96)
la var	ag_nogrow_cat9		"Pests"
g		ag_nogrow_cat11= (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat11		"Advised to stay home"
g		ag_nogrow_cat12= (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat12		"Restrictions on movement / travel"
	
*	6	not able to access fertilizer 
loc v6 ag4_crops_reas_fert
ta `v6' round	//	no obs 
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



keep household_id round ag_refperiod_yn ag_nogrow_* ag_nofert_*
isid household_id round
sort household_id round

tempfile vn1
sa		`vn1'
}	/*	end version 1	*/
********************************************************************************
********************************************************************************

********************************************************************************
********************************************************************************
{	/*	version 2, round 9	*/
d ph* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
u household_id ph* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 ph1_crops
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 ph2_crops_main 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	8	harvest
loc v8	ph4_crops_finish
ta		`v8'
la li	`v8'
g		ag_harv_complete = (`v8'==1) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


*	10 area planted
/*
d using "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta"
d using "${local_storage}/tmp_ETH_r9_cover.dta"
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
isid local_unit region zone woreda
*/
preserve
tempfile z_p50 r_p50 u_p50
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit region zone)
sa            `z_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit region)
sa            `r_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit)
sa            `u_p50'
restore

loc v10	ph3_crops_area_
d		`v10'*,f
ta		`v10'u_other	//	Koti
la li	`v10'u
ta		`v10'u
ta		`v10'q,m
g local_unit = `v10'u if inrange(`v10'u,3,6)

mer 1:1 household_id using "${local_storage}/tmp_ETH_r9_cover.dta", assert(3) nogen keepus(cs1_region cs2_zoneid cs3_woredaid)
ren (cs1_region cs2_zoneid cs3_woredaid)(region zone woreda)

mer m:1 local_unit region zone woreda using "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", keep(1 3) nogen keepus(conv)
mer m:1 local_unit region zone using `z_p50', keep(1 3 4 5) nogen keepus(conversion) update
mer m:1 local_unit region      using `r_p50', keep(1 3 4 5) nogen keepus(conversion) update
mer m:1 local_unit             using `u_p50', keep(1 3 4 5) nogen keepus(conversion) update
ta local_unit if  mi(conversion)
ta local_unit if !mi(conversion)
	*	conversion is to sq meters, but we want ha

g		ag_plant_ha = `v10'q						if `v10'u==1
replace ag_plant_ha = `v10'q * 0.0001				if `v10'u==2
replace ag_plant_ha = `v10'q * conversion * 0.0001	if inrange(`v10'u,3,6)

la var	ag_plant_ha	"Hectares planted with main crop"

*	13	expected harvest quantity
loc v13 ph5_crops_harvest_
ta `v13'u_other
g		ag_anteharv_q		= `v13'q		if ag_harv_complete==0
g		ag_anteharv_u		= `v13'u		if ag_harv_complete==0
g		ag_anteharv_u_os	= `v13'u_other	if ag_harv_complete==0
g		ag_postharv_q		= `v13'q		if ag_harv_complete==1
g		ag_postharv_u		= `v13'u		if ag_harv_complete==1
g		ag_postharv_u_os	= `v13'u_other	if ag_harv_complete==1


*	15	normally sell (this is crop + livestock here, best available proxy)
loc v15	ph13_farm_sell
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	17	Pre-sale subjective assessment
loc v17	ph14_farm_sell_expect
ta `v17'
la li `v17'
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




g round=9
keep household_id round ag_* cropcode
isid household_id round
sort household_id round

tempfile vn2
sa		`vn2'
}	/*	end version 2	*/ 

********************************************************************************
********************************************************************************

********************************************************************************
********************************************************************************

{	/*	version 3, round 14	*/
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_agriculture_public.dta"	
u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_agriculture_public.dta", clear	


*	1	hh has grown crops since beginning of agricultural season 
loc v1 fpa1
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 fpa2_reason
d `v5'*,f
tabstat `v5'?
la li `v5'
ta fpa2_other
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1 | `v5'3==1 | `v5'3==1 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'1==2 | `v5'3==2 | `v5'3==2 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'1==3 | `v5'3==3 | `v5'3==3 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'1==4 | `v5'3==4 | `v5'3==4 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4?)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat6 = (`v5'1==5 | `v5'3==5 | `v5'3==5 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'1==6 | `v5'3==6 | `v5'3==6 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
g		ag_nogrow_cat8 = (`v5'1==7 | `v5'3==7 | `v5'3==7 ) if ag_refperiod_yn==1
la var	ag_nogrow_cat8		"Climate"
	


*	7	main crops, taking first 
loc v7 fpa3 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	8	harvest
loc v8	fpa6
ta		`v8'
la li	`v8'harvest
g		ag_harv_complete = (`v8'==1) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


*	10 area planted
/*
d using "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta"
d using "${local_storage}/tmp_ETH_r14_cover.dta"
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
isid local_unit region zone woreda
*/
preserve
tempfile z_p50 r_p50 u_p50
// u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
// collapse (p50) conversion, by(local_unit region zone)
// sa            `z_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit region)
sa            `r_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit)
sa            `u_p50'
restore

loc v10	fpa4_
d		`v10'*,f
ta		`v10'u_other	//	Daga, Erken, Qada
la li	`v10'u
ta		`v10'u
ta		`v10'q,m
g local_unit = `v10'u if inrange(`v10'u,3,6)

mer 1:1 household_id using "${local_storage}/tmp_ETH_r14_cover.dta", assert(3) nogen keepus(cs1_region /*cs2_zoneid cs3_woredaid*/)
ren (cs1_region)(region)

mer m:1 local_unit region      using `r_p50', keep(1 3)     nogen keepus(conversion)
mer m:1 local_unit             using `u_p50', keep(1 3 4 5) nogen keepus(conversion) update
ta local_unit if  mi(conversion)
ta local_unit if !mi(conversion)
	*	conversion is to sq meters, but we want ha

g		ag_plant_ha = `v10'q						if `v10'u==1
replace ag_plant_ha = `v10'q * 0.0001				if `v10'u==2
replace ag_plant_ha = `v10'q * conversion * 0.0001	if inrange(`v10'u,3,6)
replace ag_plant_ha = . if `v10'q<=0
la var	ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
loc v11 fpa5
ta `v11'
la li `v11'moreless
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

*	12	harvest expectation ex ante
loc v12	fpa7
ta `v12'
la li fpaexpect
g ag_anteharv_subj=`v12' if ag_harv_complete==0
g ag_postharv_subj=`v12' if ag_harv_complete==1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
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
la val	ag_anteharv_subj ag_postharv_subj ag_subjective_assessment


*	13	expected harvest quantity
loc v13 fpa8_
ta `v13'u_other
ta `v13'u
g		ag_anteharv_q		= `v13'q		if ag_harv_complete==0
g		ag_anteharv_u		= `v13'u		if ag_harv_complete==0
g		ag_anteharv_u_os	= `v13'u_other	if ag_harv_complete==0
g		ag_postharv_q		= `v13'q		if ag_harv_complete==1
g		ag_postharv_u		= `v13'u		if ag_harv_complete==1
g		ag_postharv_u_os	= `v13'u_other	if ag_harv_complete==1


*	15	normally sell (this is crop + livestock here, best available proxy)
loc v15	fpa9
ta `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	17	Pre-sale subjective assessment
loc v17	fpa10
ta `v17'
la li fpaexpect
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment

*	19	inorg fertilizer dummy
loc v19 fpa11
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	22	fertilizer applied quantity
loc v22	fpa14
ta `v22'
g		ag_fertpost_tot_kg	= `v22'
la var	ag_fertpost_tot_kg	"Total quantity of fertilizer on all plots (kg)"

*	23 reason no [input]
loc v23 fpa12
ta `v23'
la li fertno
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',4,5)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',1)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',2,3)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"

*	24	fertilizer acquired quantity
loc v22	fpa14
ta `v22'
g		ag_fertpurch_tot_kg	= `v22'
la var	ag_fertpurch_tot_kg	"Total quantity of fertilizer acquired (kg)"

*	28	Adaptations for fertilizer issue
loc v28 fpa13
d `v28'*
tab1 `v28'*
la li fertman
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat4=(`v28'==2) if !mi(`v28')	
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_nofert_adapt_cat6=(`v28'==3) if !mi(`v28')	
la var	ag_nofert_adapt_cat6	"Changed crop type"
g		ag_nofert_adapt_cat7=(`v28'==1) if !mi(`v28')	
la var	ag_nofert_adapt_cat7	"Just planted without fertilizer"

*	29	price of fertilizer
loc v29 fpa16
ta `v29'
g		ag_fertcost_cost = `v29' if `v29'>0
g		ag_fertcost_price = `v29' / ag_fertpurch_tot_kg if `v29'>0
la var	ag_fertcost_cost 	"Total cost of fertilizer (LCU)"
la var	ag_fertcost_price	"Fertilizer price (LCU/standard unit)" 

*	30	subjective change in fertilizer price vs last year
loc v30 fpa18
ta `v30'
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"
la li fertprice
la copy fertprice cost_subj
la val ag_fertcost_subj cost_subj

*	31	adaptation to fertilizer prices (building on v28 codes)
loc v31	fpa19
ta `v31'
la li `v31'
g		ag_fertprice_adapt_label=.
la var	ag_fertprice_adapt_label	"Adapted to high fertilizer price by [...]"
g		ag_fertprice_adapt_cat2		=(`v31'==1) if !mi(`v31')	
la var	ag_fertprice_adapt_cat2		"Used lower rate of fertilizer"
g		ag_fertprice_adapt_cat3		=(`v31'==6) if !mi(`v31')	
la var	ag_fertprice_adapt_cat3		"Cultivated a smaller area"
g		ag_fertprice_adapt_cat11	=(`v31'==2) if !mi(`v31')	
la var	ag_fertprice_adapt_cat11	"Borrowed money"
g		ag_fertprice_adapt_cat12	=(`v31'==3) if !mi(`v31')	
la var	ag_fertprice_adapt_cat12	"Sold productive assets"
g		ag_fertprice_adapt_cat13	=(`v31'==4) if !mi(`v31')	
la var	ag_fertprice_adapt_cat13	"Assistance from family/friends"
g		ag_fertprice_adapt_cat14	=(`v31'==5) if !mi(`v31')	
la var	ag_fertprice_adapt_cat14	"Sharecropped/rented out land"

g round=14
keep household_id round ag_* cropcode
isid household_id round
sort household_id round


tempfile vn3
sa		`vn3'
}	/*	end version 3	*/ 

********************************************************************************
********************************************************************************

********************************************************************************
********************************************************************************

{	/*	version 4, round 19 (pre-public)	*/
d using "${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Agriculture_Crop_Public.dta"
u		"${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Agriculture_Crop_Public.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 ac1
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	2	able to farm normally 
loc v2	ac4
ta `v2'
g		ag_normal_yn = (`v2'==1) if !mi(`v2')
la var	ag_normal_yn	"Able to conduct agricultural activies normally"

*	3	reason respondent not able to conduct normal farming activities
loc v3 ac5_reason
d `v3'?
tabstat `v3'?, s(sum)
la li ac2_5

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
egen	ag_resp_no_farm_cat4a = anymatch(`v3'?) if ag_normal_yn==0, v(2)
la var	ag_resp_no_farm_cat4a		"Unable to acquire / transport seeds"
egen	ag_resp_no_farm_cat4b = anymatch(`v3'?) if ag_normal_yn==0, v(3)
la var	ag_resp_no_farm_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_resp_no_farm_cat4c = anymatch(`v3'?) if ag_normal_yn==0, v(4)
la var	ag_resp_no_farm_cat4c		"Unable to acquire / transport other inputs"
egen	ag_resp_no_farm_cat4 = anymatch(`v3'?) if ag_normal_yn==0, v(2 3 4)
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
egen	ag_resp_no_farm_cat5 = anymatch(`v3'?) if ag_normal_yn==0, v(5)
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
egen	ag_resp_no_farm_cat6 = anymatch(`v3'?) if ag_normal_yn==0, v(6)
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
egen	ag_resp_no_farm_cat7 = anymatch(`v3'?) if ag_normal_yn==0, v(11)
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
egen	ag_resp_no_farm_cat8 = anymatch(`v3'?) if ag_normal_yn==0, v(7 8)
la var	ag_resp_no_farm_cat8		"Climate"
egen	ag_resp_no_farm_cat9 = anymatch(`v3'?) if ag_normal_yn==0, v(9)
la var	ag_resp_no_farm_cat9		"Pests"
egen	ag_resp_no_farm_cat10 = anymatch(`v3'?) if ag_normal_yn==0, v(10)
la var	ag_resp_no_farm_cat10		"Insecurity"

*	4	total cultivated area
preserve
tempfile r_p50 u_p50
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit region)
sa            `r_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit)
sa            `u_p50'
restore

loc v4 ac6_
la li `v4'u
g local_unit = `v4'u if inrange(`v4'u,3,6)
ren (cs1_region)(region)
mer m:1 local_unit region      using `r_p50', keep(1 3)     nogen keepus(conversion)
mer m:1 local_unit             using `u_p50', keep(1 3 4 5) nogen keepus(conversion) update
drop local_unit

g		ag_total_ha = `v4'q							if `v4'u==1
replace ag_total_ha = `v4'q * 0.0001				if `v4'u==2
replace ag_total_ha = `v4'q * conversion * 0.0001	if inrange(`v4'u,3,6)
replace ag_total_ha = . if `v4'q<=0
la var	ag_total_ha	"Total area under all crops (ha)"

*	5	not able to conduct hh ag activities
loc v5 ac2_reason
d `v5'*,f
tabstat `v5'?
la li ac2_5
ta ac2_other
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
egen	ag_nogrow_cat4a = anymatch(`v5'?) if ag_refperiod_yn==0, v(2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
egen	ag_nogrow_cat4b = anymatch(`v5'?) if ag_normal_yn==0, v(3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_nogrow_cat4c = anymatch(`v5'?) if ag_normal_yn==0, v(4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = anymatch(`v5'?) if ag_normal_yn==0, v(2 3 4)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
egen	ag_nogrow_cat5 = anymatch(`v5'?) if ag_normal_yn==0, v(5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
egen	ag_nogrow_cat6 = anymatch(`v5'?) if ag_normal_yn==0, v(6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
egen	ag_nogrow_cat7 = anymatch(`v5'?) if ag_normal_yn==0, v(11)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
egen	ag_nogrow_cat8 = anymatch(`v5'?) if ag_normal_yn==0, v(7 8)
la var	ag_nogrow_cat8		"Climate"
egen	ag_nogrow_cat9 = anymatch(`v5'?) if ag_normal_yn==0, v(9)
la var	ag_nogrow_cat9		"Pests"
egen	ag_nogrow_cat10 = anymatch(`v5'?) if ag_normal_yn==0, v(10)
la var	ag_nogrow_cat10		"Insecurity"
	
*	6	not able to access fertilizer 
loc v6 ac3_reason
d `v6'*,f
tabstat `v6'?
la li ac3
ta ac3_other
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
egen	ag_nofert_cat1=anymatch(`v6'?) if ag_nogrow_cat4b==1, v(1)
la var	ag_nofert_cat1	"No supply of fertilizer"
egen	ag_nofert_cat2=anymatch(`v6'?) if ag_nogrow_cat4b==1, v(2)
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
egen	ag_nofert_cat3=anymatch(`v6'?) if ag_nogrow_cat4b==1, v(3)
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"


*	7	main crops, taking first 
loc v7 ac7 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	10 area planted
preserve
tempfile r_p50 u_p50
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit region)
sa            `r_p50'
u "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta", clear
collapse (p50) conversion, by(local_unit)
sa            `u_p50'
restore

loc v10	ac8_
d		`v10'*,f
ta		`v10'u_other	//	Ken
la li	`v10'u
ta		`v10'u
ta		`v10'q,m
g local_unit = `v10'u if inrange(`v10'u,3,6)
// ren (cs1_region)(region)

mer m:1 local_unit region      using `r_p50', keep(1 3)     nogen keepus(conversion)
mer m:1 local_unit             using `u_p50', keep(1 3 4 5) nogen keepus(conversion) update
ta local_unit if  mi(conversion)
ta local_unit if !mi(conversion)
drop local_unit
	*	conversion is to sq meters, but we want ha

g		ag_plant_ha = `v10'q						if `v10'u==1
replace ag_plant_ha = `v10'q * 0.0001				if `v10'u==2
replace ag_plant_ha = `v10'q * conversion * 0.0001	if inrange(`v10'u,3,6)
replace ag_plant_ha = . if `v10'q<=0
la var	ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
loc v11 ac9
ta `v11'
la li `v11'
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
loc v12	ac11
ta `v12'
la li `v12'
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
loc v14 ac10_
ta `v14'u_other
ta `v14'u
g		ag_postharv_q		= `v14'q		
g		ag_postharv_u		= `v14'u		
g		ag_postharv_u_os	= `v14'u_other	
la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"


*	15	normally sell 
loc v15	ac12
ta `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
loc v16	ac13
ta `v16'
la li `v16'
g ag_sale_current = (`v16'==1) if !mi(`v16')

*	17a	Post-sale subjective assessment
loc v17	ac14
ta `v17'
la li `v17'
g		ag_postsale_subj = `v17' if !mi(`v17')
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	Reasoning for subjective assessment of sales
tab2 ac14 ac15a_reason_good1 ac15b_reason_bad1, first m
loc v18g	ac15a_reason_good
loc v18b	ac15b_reason_bad
tab1 `v18g'? `v18b'?
la li ac15a ac15b
/*	emulating code structure from Uganda*/
g		ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
egen	ag_salesubj_why_cat1	= anymatch(`v18g'?) if !mi(ag_postsale_subj), v(1)
egen	ag_salesubj_why_cat2	= anymatch(`v18b'?) if !mi(ag_postsale_subj), v(1)
egen	ag_salesubj_why_cat3	= anymatch(`v18g'?) if !mi(ag_postsale_subj), v(2)
egen	ag_salesubj_why_cat4	= anymatch(`v18b'?) if !mi(ag_postsale_subj), v(2)
egen	ag_salesubj_why_cat5	= anymatch(`v18g'?) if !mi(ag_postsale_subj), v(4)
egen	ag_salesubj_why_cat6	= anymatch(`v18b'?) if !mi(ag_postsale_subj), v(4)
egen	ag_salesubj_why_cat7	= anymatch(`v18g'?) if !mi(ag_postsale_subj), v(3)
egen	ag_salesubj_why_cat8	= anymatch(`v18b'?) if !mi(ag_postsale_subj), v(3)
egen	ag_salesubj_why_cat9	= anymatch(`v18g'?) if !mi(ag_postsale_subj), v(5)
egen	ag_salesubj_why_cat10	= anymatch(`v18b'?) if !mi(ag_postsale_subj), v(5)

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
loc v19 ac16
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	21	fertilizer types
loc v21 ac18_fert_type
la li ac18
d `v21'*
tab1 `v21'?
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'?) if ag_inorgfert_post==1, v(1 3)	//	following on Uganda, binning DAP into compound fertilizer
egen	ag_ferttype_post_cat2 = anymatch(`v21'?) if ag_inorgfert_post==1, v(2)
// egen	ag_ferttype_post_cat3 = anymatch(`v21'?) if ag_inorgfert_post==1, v(3)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
// la var	ag_ferttype_post_cat3	"Phosphate"


*	22	fertilizer applied quantity
loc v22	ac20
ta `v22'
g		ag_fertpost_tot_kg	= `v22' if `v22'>0
la var	ag_fertpost_tot_kg	"Total quantity of fertilizer on all plots (kg)"

*	23 reason no [input]
loc v23 ac17
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
g 		ag_inorgfert_no_cat4 = (inlist(`v23',5)) if !mi(`v23')
la var	ag_inorgfert_no_cat4	"Unable to access due to security issue"

*	24	fertilizer acquired quantity
loc v24	ac19
ta `v24'
g		ag_fertpurch_tot_kg	= `v24' if `v24'>0
la var	ag_fertpurch_tot_kg	"Total quantity of fertilizer acquired (kg)"

*	25 Acquire full amount? 
loc v25 ac21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	ac23
ta `v26'
g		ag_fertpurch_ante_kg	= `v26' if `v26'>0
la var	ag_fertpurch_ante_kg	"Total quantity of fertilizer still desired (kg)"

*	27	reason couldn't acquire fertilizer
loc v27	ac24_noen
tab1 `v27'?
la li ac24
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
egen	ag_fert_partial_cat2 = anymatch(`v27'?) if !mi(`v27'1), v(2)
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
egen	ag_fert_partial_cat3 = anymatch(`v27'?) if !mi(`v27'1), v(1 3)
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 ac22_how_adopt
d `v28'*
tab1 `v28'*
la li ac22
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
egen	ag_nofert_adapt_cat4=anymatch(`v28'?) if !mi(`v28'1), v(3)
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
egen	ag_nofert_adapt_cat5=anymatch(`v28'?) if !mi(`v28'1), v(4)
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"
egen	ag_nofert_adapt_cat6=anymatch(`v28'?) if !mi(`v28'1), v(2)
la var	ag_nofert_adapt_cat6	"Changed crop type"
egen	ag_nofert_adapt_cat7=anymatch(`v28'?) if !mi(`v28'1), v(1)
la var	ag_nofert_adapt_cat7	"Just planted without fertilizer"

loc v28 ac25_cult
d `v28'*
tab1 `v28'*
la li ac25
g		ag_partialfert_adapt_label=.
la var	ag_partialfert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
egen	ag_partialfert_adapt_cat1=anymatch(`v28'?) if !mi(`v28'1), v(1)
la var	ag_partialfert_adapt_cat1	"Only fertilized part of cultivated area"
egen	ag_partialfert_adapt_cat2=anymatch(`v28'?) if !mi(`v28'1), v(2)
la var	ag_partialfert_adapt_cat2	"Used lower rate of fertilizer"
egen	ag_partialfert_adapt_cat3=anymatch(`v28'?) if !mi(`v28'1), v(3)
la var	ag_partialfert_adapt_cat3	"Cultivated a smaller area"
egen	ag_partialfert_adapt_cat4=anymatch(`v28'?) if !mi(`v28'1), v(4)
la var	ag_partialfert_adapt_cat4	"Supplemented with organic fertilizer"
egen	ag_partialfert_adapt_cat5=anymatch(`v28'?) if !mi(`v28'1), v(5)
la var	ag_partialfert_adapt_cat5	"Practiced legume intercropping"


*	29	price of fertilizer
compare ac26_price_1 ac26_price_3	//	either = 0 or missing ac26_price_3. Safe to combine. 
egen	ag_fertcost_quant1	= rowfirst(ac26_quantity_1 ac26_quantity_3) 
egen	ag_fertcost_unit1	= rowfirst(ac26_unit_1 ac26_unit_3) 
egen	ag_fertcost_lcu1	= rowfirst(ac26_price_1 ac26_price_3) 
g 		ag_fertcost_price1	=	cond(ag_fertcost_unit1==1,ag_fertcost_lcu1,	/*
*/								cond(ag_fertcost_unit1==2,ag_fertcost_lcu1/50,.))
recode ag_fertcost_*1 (nonm=.) if ag_fertcost_quant1<=0
la var	ag_fertcost_quant1	"Quantity, Compound fertilizer"
la var	ag_fertcost_unit1	"Unit, Compound fertilizer"
la var	ag_fertcost_lcu1	"LCU/unit, Compound fertilizer"
la var	ag_fertcost_price1	"LCU/standard unit, Compound fertilizer"

egen	ag_fertcost_quant2	= rowfirst(ac26_quantity_2) 
egen	ag_fertcost_unit2	= rowfirst(ac26_unit_2) 
egen	ag_fertcost_lcu2	= rowfirst(ac26_price_2) 
g 		ag_fertcost_price2	=	cond(ag_fertcost_unit2==1,ag_fertcost_lcu2,	/*
*/								cond(ag_fertcost_unit2==2,ag_fertcost_lcu2/50,.))
recode ag_fertcost_*2 (nonm=.) if ag_fertcost_quant2<=0
la var	ag_fertcost_quant2	"Quantity, Nitrogen fertilizer"
la var	ag_fertcost_unit2	"Unit, Nitrogen fertilizer"
la var	ag_fertcost_lcu2	"LCU/unit, Nitrogen fertilizer"
la var	ag_fertcost_price2	"LCU/standard unit, Nitrogen fertilizer"


*	30	subjective change in fertilizer price vs last year
loc v30 ac27
ta `v30'
la li `v30'
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"
la copy `v30' cost_subj
la val ag_fertcost_subj cost_subj

*	31	adaptation to fertilizer prices (building on v28 codes)
loc v31	ac28_high_p
tab1 `v31'?
la li ac28
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

g round=19
keep household_id round ag_* cropcode
isid household_id round
sort household_id round


tempfile vn4
sa		`vn4'
}	/*	end version 3	*/ 


clear
append using `vn1' `vn2' `vn3' `vn4'
isid household_id round
sort household_id round

ta round
assert inlist(round,3,4,5,6,9,14,19)


sa "${local_storage}/tmp_ETH_agriculture.dta", replace 








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


