

dir "${raw_hfps_tza}"
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"	//	s5j & s6 




********************************************************************************
********************************************************************************

u t0_region-hhid s14* using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s14q1
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	2	able to farm normally 
loc v2	s14q4
ta `v2'
g		ag_normal_yn = (`v2'==1) if !mi(`v2')
la var	ag_normal_yn	"Able to conduct agricultural s14qtivies normally"

*	5	reason respondent not able to conduct normal farming activities
loc v3 s14q5_
d `v3'*
tabstat `v3'? `v3'1?, s(sum)

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
egen	ag_resp_no_farm_cat2 = anymatch(`v3'1) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
egen	ag_resp_no_farm_cat4a = anymatch(`v3'2) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4a		"Unable to acquire / transport seeds"
egen	ag_resp_no_farm_cat4b = anymatch(`v3'3) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_resp_no_farm_cat4c = anymatch(`v3'4) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4c		"Unable to acquire / transport other inputs"
egen	ag_resp_no_farm_cat4 = anymatch(`v3'2 `v3'3 `v3'4) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
egen	ag_resp_no_farm_cat5 = anymatch(`v3'5) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
egen	ag_resp_no_farm_cat6 = anymatch(`v3'6) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
egen	ag_resp_no_farm_cat7 = anymatch(`v3'11) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
egen	ag_resp_no_farm_cat8 = anymatch(`v3'7 `v3'8) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat8		"Climate"
egen	ag_resp_no_farm_cat9 = anymatch(`v3'9) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat9		"Pests"
egen	ag_resp_no_farm_cat10 = anymatch(`v3'10) if ag_normal_yn==0, v(1)
la var	ag_resp_no_farm_cat10		"Insecurity"

*	4	total cultivated area
loc v4 s14q6
su `v4',d
g		ag_total_ha = `v4' * 0.40468564224 if `v4'>0
la var	ag_total_ha	"Total area under all crops (ha)"

*	5	not able to conduct hh ag activities
loc v5 s14q2_
d `v5'*,f
tabstat `v5'? `v5'1?
ta s14q2_96_os
g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
egen	ag_nogrow_cat2 = anymatch(`v5'1) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
egen	ag_nogrow_cat4a = anymatch(`v5'2) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
egen	ag_nogrow_cat4b = anymatch(`v5'3) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
egen	ag_nogrow_cat4c = anymatch(`v5'4) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = anymatch(`v5'2 `v5'3 `v5'4) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
egen	ag_nogrow_cat5 = anymatch(`v5'5) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
egen	ag_nogrow_cat6 = anymatch(`v5'6) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
egen	ag_nogrow_cat7 = anymatch(`v5'11) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
egen	ag_nogrow_cat8 = anymatch(`v5'7 `v3'8) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat8		"Climate"
egen	ag_nogrow_cat9 = anymatch(`v5'9) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat9		"Pests"
egen	ag_nogrow_cat10 = anymatch(`v5'10) if ag_refperiod_yn==0, v(1)
la var	ag_nogrow_cat10		"Insecurity"
	
*	6	not able to access fertilizer 
loc v6 s14q3
d `v6',f
ta `v6'
la li labels47
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
egen	ag_nofert_cat1=anymatch(`v6') if ag_nogrow_cat4b==1, v(1)
la var	ag_nofert_cat1	"No supply of fertilizer"
egen	ag_nofert_cat2=anymatch(`v6') if ag_nogrow_cat4b==1, v(2)
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
egen	ag_nofert_cat3=anymatch(`v6') if ag_nogrow_cat4b==1, v(3)
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"


*	7	main crops, taking first 
loc v7 s14q7 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	10 area planted
loc v10	s14q8
su `v10',d	//	why are zero values present? 
g		ag_plant_ha = `v10' * 0.40468564224 if `v10'>0
la var	ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
loc v11 s14q9
ta `v11'
d  `v11'
la li labels50
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
loc v12	s14q11
ta `v12'
d  `v12'
la li labels51
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
ta s14q8 if s14q10==0,m
ta s14q10 if s14q8==0,m	
loc v14 s14q10
su `v14', d
d  `v14'
g		ag_postharv_kg		= `v14'		
la var	ag_postharv_kg		"Completed harvest quantity (kg)"


*	15	normally sell 
loc v15	s14q12
ta `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
loc v16	s14q13
ta `v16'
g		ag_sale_current = (`v16'==1) if !mi(`v16')
la var	ag_sale_current		"Main crop was sold from most recent harvest"

*	17a	Post-sale subjective assessment
loc v17	s14q14
ta `v17'
g		ag_postsale_subj = `v17' if !mi(`v17')
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	Reasoning for subjective assessment of sales
loc v18	s14q15
ta `v18'
d  `v18'
la li labels55
ta s14q15 s14q14,m	//	meaning is unclear when s14q14==3. WIll ignore these, consistent with other rounds
/*	emulating code structure from Uganda*/
g		ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
g		ag_salesubj_why_cat1	= (`v18'==1 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat2	= (`v18'==1 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat3	= (`v18'==2 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat4	= (`v18'==2 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat5	= (`v18'==3 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat6	= (`v18'==3 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat7	= (`v18'==4 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat8	= (`v18'==4 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat9	= (`v18'==5 & inlist(ag_postsale_subj,1,2)) if inlist(ag_postsale_subj,1,2,4,5)
g		ag_salesubj_why_cat10	= (`v18'==5 & inlist(ag_postsale_subj,4,5)) if inlist(ag_postsale_subj,1,2,4,5)

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
loc v19 s14q16
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s14q18_
d `v21'*
tabstat `v21'?, s(sum)
ta `v21'8_os
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'1 `v21'4 `v21'6 ) if ag_inorgfert_post==1, v(1)	//	following on Uganda, binning DAP into compound fertilizer
egen	ag_ferttype_post_cat2 = anymatch(`v21'2 `v21'5 ) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'3 `v21'7 ) if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"


*	22	fertilizer applied quantity
loc v22	s14q20_
d  `v22'*	
tab1 `v22'*	
g		ag_fertpost_tot_kg	= `v22'1 if `v22'1>0
la var	ag_fertpost_tot_kg	"Total quantity of fertilizer on all plots (kg)"

*	23 reason no [input]
loc v23 s14q17
ta `v23'
la li labels57
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
loc v24	s14q19_
d  `v24'*
ta `v24'2	//	all are standard units (kg or l)
g		ag_fertpurch_tot_kg	= `v24'1 if `v24'1>0
la var	ag_fertpurch_tot_kg	"Total quantity of fertilizer acquired (kg)"

*	25 acquire full amount? 
loc v25 s14q21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	s14q22_
d  `v26'*
ta `v26'2
g		ag_fertpurch_ante_kg	= `v26'1 if `v26'1>0
la var	ag_fertpurch_ante_kg	"Total quantity of fertilizer still desired (kg)"

*	27	reason couldn't acquire fertilizer
loc v27	s14q23
ta `v27'
d  `v27'
la li labels62
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
egen	ag_fert_partial_cat2 = anymatch(`v27') if !mi(`v27'), v(2)
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
egen	ag_fert_partial_cat3 = anymatch(`v27') if !mi(`v27'), v(1 3)
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 s14q24_
d `v28'*
tabstat `v28'? `v28'??, s(sum)
ta `v28'96_os
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
egen	ag_nofert_adapt_cat1=anymatch(`v28'1) if !mi(`v28'1), v(1)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
egen	ag_nofert_adapt_cat2=anymatch(`v28'2) if !mi(`v28'2), v(1)
la var	ag_nofert_adapt_cat2	"Used lower rate of fertilizer"
egen	ag_nofert_adapt_cat3=anymatch(`v28'3) if !mi(`v28'3), v(1)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
egen	ag_nofert_adapt_cat4=anymatch(`v28'4) if !mi(`v28'4), v(1)
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
egen	ag_nofert_adapt_cat5=anymatch(`v28'5) if !mi(`v28'5), v(1)
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"


*	29	price of fertilizer
d s14q25_1?
d s14q25_?a
la li labels63
tab1 s14q25_3?
compare s14q25_1a s14q25_1d	//	majority are equal, let's rule out zero + u/q differences and compare
loc y s14q25_
foreach x in a b c d e f g	{
	g `y'4`x'= `y'1`x' / (`y'2`x' * cond(inlist(`y'3`x',2,4),.001,1)), a(`y'3`x')
}
tabstat s14q25_4?, s(n me sd min p1 p5 p50 p95 p99 max) format(%12.3gc) c(s)
li s14q25_?a if s14q25_4a>9000 & !mi(s14q25_4a)
li s14q25_?b if s14q25_4b>9000 & !mi(s14q25_4b)
li s14q25_?e if s14q25_4e>9000 & !mi(s14q25_4e)
li s14q25_?g if s14q25_4g>9000 & !mi(s14q25_4g)


su s14q25_4a s14q25_4d s14q25_4f, d
compare s14q25_4a s14q25_4d
compare s14q25_4a s14q25_4f
compare s14q25_4d s14q25_4f
	*	unlike the other situations, we do not have consistency between these prices within type
	*	algorithm to select/construct price data: 
	*	1	fertcat shall = the three basic types following derinitions in ag_ferttype_post_cat
	*	2	modal unit, using minmode to prefer kg to gram, L to mL, kg to L
	*	3	quantity/lcu = median where unit=modal unit
	*	4	price = median lcu / median quant
preserve 
keep hhid  	s14q25_??
ren (s14q25_?a s14q25_?b s14q25_?c s14q25_?d s14q25_?e s14q25_?f s14q25_?g)	/*
*/	(q?1 q?2 q?3 q?4 q?5 q?6 q?7)
ren (q1? q2? q3? q4?)(  lcu? quant?  unit? price?)
d
reshape long lcu quant unit price, i(hhid) j(ferttype) 
recode ferttype (1 4 6=1)(2 5=2)(3 7=3), gen(fertcat)
sort hhid fertcat ferttype
keep if quant>0 & !mi(quant) & lcu>0 & !mi(lcu)	//	get rid of zeroes 
g zzz = unit if !mi(price)
bys hhid fertcat (ferttype) : egen modal_unit = mode(zzz), minmode
keep if !mi(modal_unit) & unit==modal_unit
collapse (median) quant unit lcu price, by(hhid fertcat)
g kg = quant * cond(inlist(unit,2,4),.001,1), a(unit)
ren (quant unit kg lcu price)(ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price)
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price, i(hhid) j(fertcat)

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
mer 1:1 hhid using `fertcost', assert(1 3) nogen

*	case Yannick is investigating
li s14q25_?a s14q25_?d s14q25_?f	if hhid=="10607102005025", ab(10)
li ag_fertcost_*1					if hhid=="10607102005025", ab(18)
	*->	all is as expected. issue lies with the append. 

tab1 ag_fertcost_unit?
li ag_fertcost_*1 s14q25_?a s14q25_?d s14q25_?f	if inlist(ag_fertcost_unit1,2,3,4), ab(10)
li ag_fertcost_*2 s14q25_?b s14q25_?e			if inlist(ag_fertcost_unit2,2,3,4), ab(10)
li ag_fertcost_*3 s14q25_?c s14q25_?g			if inlist(ag_fertcost_unit3,2,3,4), ab(10)

*	no unit recode necessary 
do "${do_hfps_util}/label_fert_unit.do"
la val ag_fertcost_unit? fert_unit


*	30	subjective change in fertilizer price vs last year
loc v30 s14q26
ta `v30'
la li labels70
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"
la copy labels70 ag_fertcost_subj
la val ag_fertcost_subj ag_fertcost_subj

*	31	adaptation to fertilizer prices (building on v28 codes)
loc v31	s14q27_
tabstat `v31'?
d `v31'?

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

g round=9
keep hhid round ag_* cropcode
isid hhid round
sort hhid round


sa "${tmp_hfps_tza}/panel/agriculture.dta", replace 
 



































