
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
// dir "${raw_hfps_eth2}"
// d using "${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Agriculture_Crop_Public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_agg_crop_public.dta"

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


********************************************************************************
********************************************************************************
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
la li yn_lab
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
la var	cropcode	"Main crop code"


*	8	harvest
loc v8	ph4_crops_finish
ta		`v8'
la li	`v8'
g		ag_harv_complete = (`v8'==1) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


*	10 area planted
/*
d using "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta"
d using "${tmp_hfps_eth}/r9/cover.dta"
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

mer 1:1 household_id using "${tmp_hfps_eth}/r9/cover.dta", assert(3) nogen keepus(cs1_region cs2_zoneid cs3_woredaid)
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
la var	cropcode	"Main crop code"


*	8	harvest
loc v8	fpa6
ta		`v8'
la li	`v8'harvest
g		ag_harv_complete = (`v8'==1) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


*	10 area planted
/*
d using "${raw_lsms_eth1}/ET_local_area_unit_conversion.dta"
d using "${tmp_hfps_eth}/r14/cover.dta"
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

mer 1:1 household_id using "${tmp_hfps_eth}/r14/cover.dta", assert(3) nogen keepus(cs1_region /*cs2_zoneid cs3_woredaid*/)
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


*	12	harvest expectation ex ante
loc v12	fpa7
ta `v12'
la li fpaexpect
g ag_anteharv_subj=`v12' if ag_harv_complete==0
g ag_postharv_subj=`v12' if ag_harv_complete==1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"
la var ag_postharv_subj	"Subjective assessment of harvest ex-post"


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

*	19	inorg fertilizer dummy
loc v19 fpa11
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	22	fertilizer applied quantity
loc v22	fpa14
ta `v22'
g		ag_fertpost_tot_q		= `v22' if `v22'>0 & !mi(`v22')
g		ag_fertpost_tot_unit	= 1		if `v22'>0 & !mi(`v22')	//	kg
g		ag_fertpost_tot_kg		= `v22' if `v22'>0 & !mi(`v22')
la var	ag_fertpost_tot_q		"Total quantity of fertilizer on all plots"
la var	ag_fertpost_tot_unit	"Unit for fertilizer applied on all plots"
la var	ag_fertpost_tot_kg		"Total quantity of fertilizer on all plots (kg)"

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
loc v24	fpa14
ta `v24'
g		ag_fertpurch_tot_q		= `v24' if `v24'>0 & !mi(`v24')
g		ag_fertpurch_tot_unit	= 1		if `v24'>0 & !mi(`v24')	//	kg
g		ag_fertpurch_tot_kg		= `v24' if `v24'>0 & !mi(`v24')
la var	ag_fertpurch_tot_q		"Total quantity of fertilizer acquired"
la var	ag_fertpurch_tot_unit	"Unit for fertilizer acquired"
la var	ag_fertpurch_tot_kg		"Total quantity of fertilizer acquired (kg)"

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
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_agg_crop_public.dta"
u		"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_agg_crop_public.dta", clear


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
la li ac5_reason

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
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta"
mer m:1 household_id using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_cover_interview_public.dta", keep(1 3) nogen keepus(cs1_regionid)
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
la li ac2_reason
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
la li ac3_reason
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


*	12	harvest expectation ex post
loc v12	ac11
ta `v12'
la li `v12'
g ag_postharv_subj=`v12' 
la var ag_postharv_subj	"Subjective assessment of harvest ex-post"


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

*	18	Reasoning for subjective assessment of sales
tab2 ac14 ac15a_reason1 ac15b_reason1, first m
loc v18g	ac15a_reason
loc v18b	ac15b_reason
tab1 `v18g'? `v18b'?
la li ac15a_reason ac15b_reason
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
loc v21 ac18_type
la li `v21'
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
g		ag_fertpost_tot_q		= `v22' if `v22'>0 & !mi(`v22')
g		ag_fertpost_tot_unit	= 1		if `v22'>0 & !mi(`v22')	//	kg
g		ag_fertpost_tot_kg		= `v22' if `v22'>0 & !mi(`v22')
la var	ag_fertpost_tot_q		"Total quantity of fertilizer on all plots"
la var	ag_fertpost_tot_unit	"Unit for fertilizer applied on all plots"
la var	ag_fertpost_tot_kg		"Total quantity of fertilizer on all plots (kg)"

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
g		ag_fertpurch_tot_q		= `v24' if `v24'>0 & !mi(`v24')
g		ag_fertpurch_tot_unit	= 1		if `v24'>0 & !mi(`v24')	//	kg
g		ag_fertpurch_tot_kg		= `v24' if `v24'>0 & !mi(`v24')
la var	ag_fertpurch_tot_q		"Total quantity of fertilizer acquired"
la var	ag_fertpurch_tot_unit	"Unit for fertilizer acquired"
la var	ag_fertpurch_tot_kg		"Total quantity of fertilizer acquired (kg)"

*	25 Acquire full amount? 
loc v25 ac21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	ac23
ta `v26'
g		ag_fertpurch_ante_q		= `v26' if `v26'>0 & !mi(`v26')
g		ag_fertpurch_ante_unit	= 1		if `v26'>0 & !mi(`v26')	//	kg
g		ag_fertpurch_ante_kg	= `v26' if `v26'>0 & !mi(`v26')
la var	ag_fertpurch_ante_q		"Total quantity of fertilizer still desired"
la var	ag_fertpurch_ante_unit	"Unit for fertilizer still desired"
la var	ag_fertpurch_ante_kg	"Total quantity of fertilizer still desired (kg)"


*	27	reason couldn't acquire fertilizer
loc v27	ac24_reason
tab1 `v27'?
la li `v27'
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
egen	ag_fert_partial_cat2 = anymatch(`v27'?) if !mi(`v27'1), v(2)
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
egen	ag_fert_partial_cat3 = anymatch(`v27'?) if !mi(`v27'1), v(1 3)
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 ac22_adapt
d `v28'*
tab1 `v28'*
la li `v28'
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

loc v28 ac25_adapt
d `v28'*
tab1 `v28'*
la li `v28'
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
preserve
keep household_id fert_label_? ac26_*
reshape long fert_label_ ac26_price_ ac26_unit_ ac26_quantity_, i(household_id) j(rank)
keep if !mi(fert_label_) & !inlist(ac26_price_,0,.) & !inlist(ac26_quantity_,0,.) 
ta fert_label_
g		fert_type = 1 if inlist(fert_label_,"DAP","NPS")
replace	fert_type = 2 if inlist(fert_label_,"UREA")

duplicates report household_id fert_type
duplicates tag household_id fert_type, gen(tag)
li fert_type fert_label_ ac26* if tag>0, sepby(household_id)
duplicates drop household_id fert_type, force	//	the quantitative data are identical

g ag_fertcost_q = ac26_quantity_
recode ac26_unit_ (1=1)(2=23)(3=31), gen(ag_fertcost_unit)
recode ag_fertcost_unit (1=1)(23=50)(31=100), gen(conv)
g ag_fertcost_kg = ag_fertcost_q * conv
g ag_fertcost_lcu = ac26_price_
g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg

keep household_id fert_type ag_fertcost_*
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price	/*
*/	, i(household_id) j(fert_type)

loc lbl1	"Compound"
loc lbl2	"Nitrogen"
loc lbl3	"Phosphate"
forv t=1/2 {
la var ag_fertcost_q`t'		"Quantity, `lbl`t'' fertilizer"
la var ag_fertcost_unit`t'	"Unit, `lbl`t'' fertilizer"
la var ag_fertcost_kg`t'	"Standard quantity, `lbl`t'' fertilizer"
la var ag_fertcost_lcu`t'	"LCU/unit, `lbl`t'' fertilizer"
la var ag_fertcost_price`t'	"Price/standard unit, `lbl`t'' fertilizer"
	}

tempfile fertcost
sa		`fertcost'
restore
mer 1:1 household_id using `fertcost', assert(1 3) nogen

su ag_fertcost*, sep(5)


*	30	subjective change in fertilizer price vs last year
loc v30 ac27
ta `v30'
la li `v30'
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"


*	31	adaptation to fertilizer prices (building on v28 codes)
loc v31	ac28_method
tab1 `v31'?
la li ac28_method
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
}	/*	end version 4	*/ 
********************************************************************************
********************************************************************************


clear
append using `vn1' `vn2' `vn3' `vn4'
isid household_id round
sort household_id round

ta round
assert inlist(round,3,4,5,6,9,14,19)

do "${do_hfps_util}/label_fert_unit.do"
la val  ag_fert*_unit ag_fertcost_unit? fert_unit
do "${do_hfps_util}/label_cost_subj.do"
la val  ag_fert*_unit ag_fertcost_unit? fert_unit
do "${do_hfps_util}/label_ag_plant_vs_prior.do"
la val ag_plant_vs_prior ag_plant_vs_prior
do "${do_hfps_util}/label_ag_subjective_assessment.do"
la val	ag_postharv_subj ag_antesale_subj ag_subjective_assessment




sa "${tmp_hfps_eth}/agriculture.dta", replace 




























