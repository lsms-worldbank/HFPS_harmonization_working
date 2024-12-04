

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*_r2.dta", w
dir "${raw_hfps_mwi}/*_r3.dta", w
dir "${raw_hfps_mwi}/*agriculture*", w

d using	"${raw_hfps_mwi}/sect13_agriculture_r1.dta"

d using	"${raw_hfps_mwi}/sect6a_employment1_r2.dta"
d using	"${raw_hfps_mwi}/sect6a_employment1_r3.dta"

d using	"${raw_hfps_mwi}/sect6e_agriculture_r4.dta"
d using	"${raw_hfps_mwi}/sect6e_agriculture_r5.dta"
d using	"${raw_hfps_mwi}/sect6e_agriculture_r6.dta"
d using	"${raw_hfps_mwi}/sect6e_agriculture_r7.dta"
d using	"${raw_hfps_mwi}/sect6e_agriculture_r11.dta"
d using	"${raw_hfps_mwi}/sect6e_agriculture_r12.dta"	

d using	"${raw_hfps_mwi}/sect13_agriculture_r17.dta"
d using	"${raw_hfps_mwi}/sect13_agriculture_r18.dta"


u	"${raw_hfps_mwi}/sect13_agriculture_r1.dta", clear
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
u	"${raw_hfps_mwi}/sect6a_employment1_r3.dta", clear

u	"${raw_hfps_mwi}/sect6e_agriculture_r4.dta", clear
u	"${raw_hfps_mwi}/sect6e_agriculture_r5.dta", clear
u	"${raw_hfps_mwi}/sect6e_agriculture_r6.dta", clear
u	"${raw_hfps_mwi}/sect6e_agriculture_r7.dta", clear
u	"${raw_hfps_mwi}/sect6e_agriculture_r11.dta", clear
ta s6eq1,m
la li s6aq13 s6aq15
la li s6aq16
u	"${raw_hfps_mwi}/sect6e_agriculture_r12.dta", clear
ta preload_agric,m

u	"${raw_hfps_mwi}/sect13_agriculture_r17.dta", clear
la li s13q4
la li s13q7
la li s13q8
la li s13q11
u	"${raw_hfps_mwi}/sect13_agriculture_r18.dta", clear
la li s13q8

la li s13q19a s13q20a
la li s13q19c s13q20c

// ex

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect13_agriculture_r1.dta"
	"${raw_hfps_mwi}/sect6a_employment1_r2.dta"
	"${raw_hfps_mwi}/sect6a_employment1_r3.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r4.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r5.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r6.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r7.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r11.dta"
	"${raw_hfps_mwi}/sect6e_agriculture_r12.dta"
	"${raw_hfps_mwi}/sect13_agriculture_r17.dta"
	"${raw_hfps_mwi}/sect13_agriculture_r18.dta"
	, gen(round);
	la drop _append; la val round .; 
#d cr
replace round = round+3 if round>7
replace round = round+4 if round>12
ta round

*	1	hh grown crops since beginning of agricultural season 
d s13q1 s6q16_1 s6qe1
tab2 round s13q1 s6qe1 s6eq1 preload_agric, m first	// s13 added code 3, but success always = 1
g		ag_refperiod_yn = (s13q1==1) if !mi(s13q1) & inlist(round,1,17,18)
replace ag_refperiod_yn = (s6qe1==1) if !mi(s6qe1) & inlist(round,7)
replace ag_refperiod_yn = (s6eq1==1) if !mi(s6eq1) & inlist(round,11)
	*	Yanick calls for round 12, but the value appears to be pre-loaded and thus hard to see its analytical value separate from the round 11 data
la var ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"
	
*	3	reason respondent not able to conduct normal farming activities
ta round s6q16_1, m
// g ag_resp_yn = (s6q16_1==1) if !mi(s6q16_1)	//	not called for
d s6q17_1__*
tabstat s6q17_1__*, by(round) s(sum)
g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
g		ag_resp_no_farm_cat1 = (s6q17_1__1==1) if !mi(s6q17_1__1)
la var	ag_resp_no_farm_cat1		"Advised to stay home"
g		ag_resp_no_farm_cat2 = (s6q17_1__2==1) if !mi(s6q17_1__2)
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
g		ag_resp_no_farm_cat3 = (s6q17_1__3==1) if !mi(s6q17_1__3)
la var	ag_resp_no_farm_cat3		"Restrictions on movement / travel"
g		ag_resp_no_farm_cat4 = (s6q17_1__4==1) if !mi(s6q17_1__4)
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
g		ag_resp_no_farm_cat5 = (s6q17_1__5==1) if !mi(s6q17_1__5)
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
g		ag_resp_no_farm_cat6 = (s6q17_1__6==1) if !mi(s6q17_1__6)
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
g		ag_resp_no_farm_cat7 = (s6q17_1__7==1) if !mi(s6q17_1__7)
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"

*	5	not able to conduct hh ag activities
d s6qe3__*
tabstat s6qe3__*, by(round) s(sum)
d s13q2__*	//	dropped two codes, 1 & 3 from the 
tabstat s13q2__*, by(round) s(sum)
la li selection

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (s6qe3__1==1) if !mi(s6qe3__1)
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (s6qe3__2==1) if !mi(s6qe3__2)
replace	ag_nogrow_cat2 = (s13q2__1==1) if !mi(s13q2__1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (s6qe3__3==1) if !mi(s6qe3__3)
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (s6qe3__4==1) if !mi(s6qe3__4)
replace	ag_nogrow_cat4a = (s13q2__2==1) if !mi(s13q2__2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (s6qe3__5==1) if !mi(s6qe3__5)
replace	ag_nogrow_cat4b = (s13q2__3==1) if !mi(s13q2__3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (s6qe3__6==1) if !mi(s6qe3__6)
replace	ag_nogrow_cat4c = (s13q2__4==1) if !mi(s13q2__4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (s6qe3__7==1) if !mi(s6qe3__7)
replace	ag_nogrow_cat5 = (s13q2__5==1) if !mi(s13q2__5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (s6qe3__8==1) if !mi(s6qe3__8)
replace	ag_nogrow_cat6 = (s13q2__6==1) if !mi(s13q2__6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (s6qe3__9==1) if !mi(s6qe3__9)
replace	ag_nogrow_cat7 = (s13q2__7==1) if !mi(s13q2__7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s

*	6	not able to access fertilizer 
	d s13q3 s6qe8__*
tab2 round s13q3 //	our data is in r17 
tabstat s6qe8__*, by(round) s(sum count)
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(s6qe8__1==1 |  s6qe8__2==1 | s13q3==1)	if !mi(s6qe8__1) | !mi(s6qe8__2) | (!mi(s13q3) & round==17)
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(s6qe8__6==1 | s13q3==2)	if !mi(s6qe8__6) | (!mi(s13q3) & round==17)
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
g		ag_nofert_cat3=(s6qe8__3==1 |  s6qe8__4==1)	if !mi(s6qe8__3) | !mi(s6qe8__4)
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"
g		ag_nofert_cat4=(s6qe8__5==1)	if !mi(s6qe8__5)
la var	ag_nofert_cat4	"Increase in price of fertilizer"


*	7	main crop 
tab2 round s13q2a s13q2b s13q2c,first	//	round 1 only
tabstat s13q2?, by(round) s(count)
la li crops
// recode s13q2a s13q2b s13q2c (1/4=1)(5/10=5)(11/16=11)(17/26=17), copyrest gen(r1_crop1 r1_crop2 r1_crop3)

ta s6eq5 round	//	r11 only
ta s6eq5_ot 
la li s6aq5	//	truncated value label
ta s6aq5 round	//	r12 only

ta s13q4 round	//	rounds 17 & 18 (not round 1)
la li crops s6aq5	//	truncated value label

g 		cropcode = s13q2a if round==1
replace cropcode = s6eq5  if round==11
replace cropcode = s6aq5  if round==12
replace cropcode = s13q4  if inlist(round,17,18)
la var cropcode	"Main crop code"


*	8	harvesting complete
tab2 round s13q3 s6eq8 s6eq16 s6aq6 s13q8_1, first
la li s13q3 
g		ag_harv_complete = . 
replace	ag_harv_complete = s13q3==3		if round==1  & !mi(s13q3)
replace	ag_harv_complete = s6eq16==1	if round==11 & !mi(s6eq16)
replace	ag_harv_complete = s6aq6==1		if round==12 & !mi(s6aq6)
replace	ag_harv_complete = s13q8_1==1	if round==18 & !mi(s13q8_1)
la var	ag_harv_complete	"Harvest of main crop complete"

*	9	planting complete
ta s13q5 round
g		ag_plant_complete = (s13q5==1) if round==17 & !mi(s13q5)
la var	ag_plant_complete	"Planting of main crop complete"


*	10 area planted
ta s6eq7_units round
ta s6eq7_units_ot
li s6eq6 s6eq7 s6eq7_units s6eq7_units_ot if !mi(s6eq7_units_ot)
la li s6aq7_units
recode s6eq7_units (96=3) 		if s6eq7_units_ot=="70 by 70 square meters each plot"
replace s6eq7 = 70 * 70 * s6eq6	if s6eq7_units_ot=="70 by 70 square meters each plot"  
g		ag_plant_ha = s6eq7 if s6eq7_units==2	//	hectares
replace ag_plant_ha = s6eq7 * 0.40468564224 if s6eq7_units==1	//	acres
replace ag_plant_ha = s6eq7 * 0.0001 if s6eq7_units==3		//	square meters

ta s13q6b round
ta s13q6b_oth	//	"plot"
replace ag_plant_ha = s13q6a if s13q6b==2	//	hectares
replace ag_plant_ha = s13q6a * 0.40468564224 if s13q6b==1	//	acres
replace ag_plant_ha = s13q6a * 0.0001 if s13q6b==3		//	square meters
la var ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
ta s13q7 round
g ag_plant_vs_prior=s13q7 if round==17
la var ag_plant_vs_prior	"Comparative planting area vs last planting"

*	12	harvest expectation ex ante
ta s13q8 round
g ag_anteharv_subj=s13q8 if round==17
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"

*	12b harvest assessment ex post
g ag_postharv_subj=s13q8 if round==18
la var ag_postharv_subj	"Subjective assessment of harvest ex-post"

*	13	expected harvest quantity
ta s13q9 round
ta s13q9b round
// dir "${raw_lsms_mwi}"
// d using "${raw_lsms_mwi}/ihs_seasonalcropconversion_factor_2020.dta"
// d using "${tmp_hfps_mwi}/pnl_cover.dta"
// mer 1:1 y4 round using "${tmp_hfps_mwi}/cover.dta", keepus(hh_a00)	
g		ag_anteharv_q		= s13q9			if round==17
g		ag_anteharv_u		= s13q9b		if round==17
g		ag_anteharv_u_os	= s13q9b_oth	if round==17
replace	ag_anteharv_q		= s13q9_1		if round==18
replace	ag_anteharv_u		= s13q9b_1		if round==18
replace	ag_anteharv_u_os	= s13q9b_oth_1	if round==18
replace	ag_anteharv_q		= s6eq17a		if round==11
replace	ag_anteharv_u		= s6eq17b		if round==11
g		ag_anteharv_c		= s6eq17c		if round==11
la var	ag_anteharv_q		"Expected harvest quantity"
la var	ag_anteharv_u		"Expected harvest unit"
la var	ag_anteharv_u_os	"Expected harvest unit o/s"
la var	ag_anteharv_c		"Expected harvest condition"
	
*	14	actual harvest quantity
g		ag_postharv_q		= s13q9			if round==18
g		ag_postharv_u		= s13q9b		if round==18
g		ag_postharv_u_os	= s13q9b_oth	if round==18
replace	ag_postharv_q		= s6eq9a		if round==11
replace	ag_postharv_u		= s6eq9b		if round==11
replace	ag_postharv_u_os	= s6eq9b_ot		if round==11
g		ag_postharv_c		= s6eq9c		if round==11
la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"
la var	ag_postharv_u_os	"Completed harvest unit o/s"
la var	ag_postharv_c		"Completed harvest condition"
	
compare ag_anteharv_q ag_postharv_q if round==18	//	exclusive
compare ag_anteharv_q ag_postharv_q if round==11	//	not exclusive

*	15	normally sell
ta s13q10 round
tab2 round s6eq13 s6eq15,first m
g		ag_sale_typical	= s13q10==1 if !mi(s13q10) & inlist(round,17,18)
replace ag_sale_typical = (s6eq13==99 & inlist(s6eq15,99,.)) if !mi(s6eq13) & round==11
replace ag_sale_typical = (s6eq15==99 & inlist(s6eq13,99,.)) if !mi(s6eq15) & round==11
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
ta s6eq10 round
g ag_sale_current = (s6eq10==1) if !mi(s6eq10) & round==11

*	17	Pre-sale subjective assessment
ta s13q11 round
ta s13q11_1 round
ta s6eq15 round
g		ag_antesale_subj = s13q11 if round==17
replace	ag_antesale_subj = s13q11_1 if round==18
replace	ag_antesale_subj = s6eq15 if round==11 & inrange(s6eq15,1,5)
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment

*	17a	Post-sale subjective assessment
ta s13q11 round
ta s6eq13 round
g		ag_postsale_subj = s13q11 if round==18
replace	ag_postsale_subj = s13q11_1 if round==18
replace	ag_postsale_subj = s6eq13 if round==11 & inrange(s6eq13,1,5)
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	why harvest low/high/etc

*	19	inorg fertilizer dummy
ta s13q12 round
tab2 round s6eq18?, first 
g		ag_inorgfert_post = (s13q12==1) if !mi(s13q12)	//	no round requirement necessary
replace	ag_inorgfert_post = (s6eq18a==1) if !mi(s6eq18a)
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

g		ag_orgfert_post = (s6eq18b==1) if !mi(s6eq18b)
la var	ag_orgfert_post	"Applied any organic fertilizer this season"
g		ag_pesticide_post = (s6eq18c==1) if !mi(s6eq18c)
la var	ag_pesticide_post	"Applied any pesticide / herbicide this season"
g		ag_hirelabor_post = (s6eq18d==1) if !mi(s6eq18d)
la var	ag_hirelabor_post	"Applied any hired labor this season"
g		ag_draught_post = (s6eq18e==1) if !mi(s6eq18e)
la var	ag_draught_post	"Applied any animal traction this season"

*	20	future fertilizer 
ta s13q14 round
g		ag_inorgfert_ante = (s13q14==1) if round==17 & !mi(s13q14)
la var	ag_inorgfert_ante	"Intend to apply inorganic fertilizer this season"

*	21	SKIPPING FERTILIZER TYPES FOR NOW, want to see codes in other surveys first 

*	22	Q of input not available

*	23 reason no [input]
ta s13q16 round
tabstat s6eq19a__*, s(sum) by(round)
tab1 s6eq19?_ot	//	many of these should be a coded response, particularly the org fert-> not available 
la li s13q16
d s6eq19a__*	
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (s6eq19a__7==1) if !mi(s6eq19a__7)
replace ag_inorgfert_no_cat1 = (inlist(s13q16,1,2)) if !mi(s13q16)
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (s6eq19a__5==1 | s6eq19a__6==1) if !mi(s6eq19a__5,s6eq19a__6)
replace ag_inorgfert_no_cat2 = (inlist(s13q16,3)) if !mi(s13q16)
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (s6eq19a__1==1 | s6eq19a__2==1) if !mi(s6eq19a__1,s6eq19a__2)
replace ag_inorgfert_no_cat3 = (inlist(s13q16,4)) if !mi(s13q16)
la var	ag_inorgfert_no_cat3	"Not available"
g 		ag_inorgfert_no_cat4 = (s6eq19a__3==1 | s6eq19a__4==1) if !mi(s6eq19a__3,s6eq19a__4)
// replace ag_inorgfert_no_cat4 = (inlist(s13q16,4)) if !mi(s13q16)
la var	ag_inorgfert_no_cat4	"Unable to travel / transport"

g		ag_orgfert_no_label=.
la var	ag_orgfert_no_label	"Did not apply organic fertilizer because [...]"
g 		ag_orgfert_no_cat1 = (s6eq19b__7==1) if !mi(s6eq19b__7)
la var	ag_orgfert_no_cat1	"Did not need"
g 		ag_orgfert_no_cat2 = (s6eq19b__5==1 | s6eq19b__6==1) if !mi(s6eq19b__5,s6eq19b__6)
la var	ag_orgfert_no_cat2	"Too expensive / could not afford"
g 		ag_orgfert_no_cat3 = (s6eq19b__1==1 | s6eq19b__2==1 | s6eq19b__96==1) if !mi(s6eq19b__1,s6eq19b__2)
la var	ag_orgfert_no_cat3	"Not available"
g 		ag_orgfert_no_cat4 = (s6eq19b__3==1 | s6eq19b__4==1) if !mi(s6eq19b__3,s6eq19b__4)
la var	ag_orgfert_no_cat4	"Unable to travel / transport"

g		ag_pesticide_no_label=.
la var	ag_pesticide_no_label	"Did not apply pesticide / herbicide because [...]"
g 		ag_pesticide_no_cat1 = (s6eq19c__7==1) if !mi(s6eq19c__7)
la var	ag_pesticide_no_cat1	"Did not need"
g 		ag_pesticide_no_cat2 = (s6eq19c__5==1 | s6eq19c__6==1) if !mi(s6eq19c__5,s6eq19c__6)
la var	ag_pesticide_no_cat2	"Too expensive / could not afford"
g 		ag_pesticide_no_cat3 = (s6eq19c__1==1 | s6eq19c__2==1) if !mi(s6eq19c__1,s6eq19c__2)
la var	ag_pesticide_no_cat3	"Not available"
g 		ag_pesticide_no_cat4 = (s6eq19c__3==1 | s6eq19c__4==1) if !mi(s6eq19c__3,s6eq19c__4)
la var	ag_pesticide_no_cat4	"Unable to travel / transport"

g		ag_hirelabor_no_label=.
la var	ag_hirelabor_no_label	"Did not hire any labor because [...]"
g 		ag_hirelabor_no_cat1 = (s6eq19d__7==1) if !mi(s6eq19d__7)
la var	ag_hirelabor_no_cat1	"Did not need"
g 		ag_hirelabor_no_cat2 = (s6eq19d__2==1 | s6eq19d__5==1 | s6eq19d__96==1) if !mi(s6eq19d__2,s6eq19d__5,s6eq19d__96)
la var	ag_hirelabor_no_cat2	"Too expensive / could not afford"
g 		ag_hirelabor_no_cat3 = (s6eq19d__1==1 | s6eq19d__3==1) if !mi(s6eq19d__1,s6eq19d__3)
la var	ag_hirelabor_no_cat3	"Not available"
g 		ag_hirelabor_no_cat4 = (s6eq19d__4==1) if !mi(s6eq19d__4)
la var	ag_hirelabor_no_cat4	"Unable to travel / transport"

g		ag_draught_no_label=.
la var	ag_draught_no_label	"Did not use animal traction because [...]"
g 		ag_draught_no_cat1 = (s6eq19e__7==1) if !mi(s6eq19e__7)
la var	ag_draught_no_cat1	"Did not need"
g 		ag_draught_no_cat2 = (s6eq19e__2==1 | s6eq19e__5==1 | s6eq19e__6==1 | (s6eq19e__96==1 &  inlist(s6eq19e_ot,"its expensive","lack of money"))) if !mi(s6eq19e__2,s6eq19e__5,s6eq19e__96)
la var	ag_draught_no_cat2	"Too expensive / could not afford"
g 		ag_draught_no_cat3 = (s6eq19e__1==1 | s6eq19e__3==1 | (s6eq19e__96==1 & !inlist(s6eq19e_ot,"its expensive","lack of money"))) if !mi(s6eq19e__1,s6eq19e__3,s6eq19e__96)
la var	ag_draught_no_cat3	"Not available"
g 		ag_draught_no_cat4 = (s6eq19e__4==1) if !mi(s6eq19e__4)
la var	ag_draught_no_cat4	"Unable to travel / transport"

*	24 q purchased

*	25 Acquire full amount? 
ta s13q17 round
g ag_fertilizer_fullq = (s13q17==1) if !mi(s13q17)
la var ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	how much more still desired? 

*	27	Why unable to acquire enough fert

*	28	Adaptations for fertilizer issue
ta s13q18 round
li s13q18_oth if s13q18==4, sep(0)
recode s13q18 (4=1) if inlist(s13q18_oth,"apply part of the garden the other part was not applied",	/*
*/	"applied fertiliser half of the cultivated area",	/*
*/	"applied other part left other part un applied",	/*
*/	"applied on other part","applied  one part")

recode s13q18 (4=2) if inlist(s13q18_oth,"The whole plot by scattering",	/*
*/	"didn't apply")
replace s13q18_oth="" if s13q18!=4

g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat1=(s13q18==1) if !mi(s13q18)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
g		ag_nofert_adapt_cat2=(s13q18==2) if !mi(s13q18)
la var	ag_nofert_adapt_cat2	"Used lower rate of fertilizer"
g		ag_nofert_adapt_cat3=(s13q18==3) if !mi(s13q18)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
g		ag_nofert_adapt_cat4=(s13q18==4) if !mi(s13q18)	//	imperfect but fairly close following cleaning 
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"


*	29	price of fertilizer
preserve
u	"${raw_hfps_mwi}/sect13_agriculture_r18.dta", clear
la li s13q19a s13q20a
la li s13q19c s13q20c
restore
tab1 s13q19a s13q19a_oth s13q20a s13q20a_oth,	//	type	manually looking at labels in round 18 which are complete. 
tab1 s13q19c s13q19c_oth s13q20c s13q20c_oth,	//	u
d s13q19* s13q20*
	*	the s13q20a_oth are not exported properly they just ca

preserve
keep y4_hhid round s13q19a-s13q19b s13q20a-s13q20b
// bro if !mi(s13q19a)
ren (s13q19a s13q19a_oth s13q19c s13q19c_oth s13q19b	/*
*/	 s13q20a s13q20a_oth s13q20c s13q20c_oth s13q20b)	/*
*/	(t1 tos1 u1 uos1 lcu1 t2 tos2 u2 uos2 lcu2)
ta   tos2	//	not exported properly it's numeric, coded as "other specify"
drop tos2	//	
reshape long t tos u uos lcu, i(y4_hhid round) j(rank)
su if mi(t)
drop if mi(t)
ta round
	/*	how shall we categorize CHITOWE -> compound?	*/ 
	replace tos =strtrim(strlower(tos))
	li tos if !mi(tos), sep(0)
recode t (1 2 3 5=1)(4=2)(else=.), gen(fert_type)
recode fert_type (.=1) if inlist(tos,"super d compound","super d","supper d","npk")
recode fert_type (.=2) if inlist(tos,"sa")
ta tos if mi(fert_type)
drop if mi(fert_type)
drop if mi(lcu) | lcu<0
drop if inlist(lcu,999999,99999,9999,999,99,0)



g ag_fertcost_q =	1 if !mi(u)
recode u (1=2)(2=1)(3=41)(4=42)(5=43)(6=44)(7=23)(else=.), gen(ag_fertcost_unit)
recode ag_fertcost_unit (1=1)(2=0.001)(41=2)(42=3)(43=5)(44=10)(23=50), gen(conv)
	replace uos =strtrim(strlower(uos))
	ta ag_fertcost_*
recode conv (.=2.5)		if inlist(uos,"2.5 kg","2.5kg")
recode conv (.=3)		if inlist(uos,"3")
recode conv (.=4)		if inlist(uos,"4kg","4kg bag")
recode conv (.=5)		if inlist(uos,"5kgs")
recode conv (.=8)		if inlist(uos,"8kgs")
recode conv (.=9)		if inlist(uos,"9kgs")
recode conv (.=10)		if inlist(uos,"10 kgs")
recode conv (.=12)		if inlist(uos,"12kgs")
recode conv (.=15)		if inlist(uos,"15","15 kg","15kg","15kgs")
recode conv (.=16)		if inlist(uos,"16kgs")
recode conv (.=18)		if inlist(uos,"18kg")
recode conv (.=20)		if inlist(uos,"20","20 kg","20kg","20kg bag","20kgs")
recode conv (.=25)		if inlist(uos,"25","25 kg","25 kgs","25,kg","25kg","25kg bag","25kgs")
recode conv (.=30)		if inlist(uos,"30","30 kg","30,kg","30kg","30kgs")
recode conv (.=35)		if inlist(uos,"35 kgs","35kg")
recode conv (.=40)		if inlist(uos,"40","40 kg","40kg","40kgs")
recode conv (.=60)		if inlist(uos,"60kg")
recode conv (.=70)		if inlist(uos,"70 kg","70,kg","70kg")
recode conv (.=75)		if inlist(uos,"75","75 kg","75kg","75kgs")
recode conv (.=100)		if inlist(uos,"100","100 kg","100,kg","100kg","100kgs","2bags ,50 kg bag")
recode conv (.=125)		if inlist(uos,"125 kg")
recode conv (.=150)		if inlist(uos,"150","150 kg","150 kg","150kg","150kgs")
recode conv (.=175)		if inlist(uos,"175 kg")
recode conv (.=200)		if inlist(uos,"200","200 kg","200kgs","200kg","200kgs","4 bags 50 kg","4 bags of 50kg","4bags 50kgs")
recode conv (.=250)		if inlist(uos,"250 kg","250 kgs","250kg","250kgs","5 bags 50kg")
recode conv (.=300)		if inlist(uos,"300","300 kg","300kg")
recode conv (.=400)		if inlist(uos,"400","8 bags 50 kg")
recode conv (.=500)		if inlist(uos,"10 ,50kgs bag","10, 50kgs","500kgs")
recode conv (.=1000)	if inlist(uos,"1000")
recode conv (.=2000)	if inlist(uos,"2000","2000kgs")
	ta uos if mi(conv)

g ag_fertcost_kg	= ag_fertcost_q * conv
ta lcu
g ag_fertcost_lcu	= lcu if !mi(ag_fertcost_q) & lcu>0 & !mi(lcu)
g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg

su ag_fertcost_*

duplicates report y4_hhid round fert_type
duplicates report y4_hhid round fert_type if !mi(ag_fertcost_price)
duplicates tag y4_hhid round fert_type, gen(tag)
sort y4 round fert_type u lcu
li t tos u uos lcu fert_type ag_fertcost_* if tag>0, sepby(y4_hhid)

keep if !mi(ag_fertcost_price)
li t tos u uos lcu fert_type ag_fertcost_* if inlist(y4_hhid,`"0026-003"',`"0165-001"',`"0204-003"',`"0268-003"',`"0369-001"',`"1125-001"',`"2441-001"'), sepby(y4_hhid)

collapse (median) ag_fertcost_*, by(y4_hhid round fert_type) 
ta ag_fertcost_unit
levelsof y4 if !inlist(ag_fertcost_unit,1,2,41,42,43,44,23,.), sep(,) 
replace ag_fertcost_unit=. if !inlist(ag_fertcost_unit,1,2,41,42,43,44,23,.)	//	kg still a median, but unit will not be usable for these observations as they stand here
ta fert_type
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price	/*
*/	, i(y4_hhid round) j(fert_type)

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
mer 1:1 y4_hhid round using `fertcost', assert(1 3) nogen

do "${do_hfps_util}/label_fert_unit.do"
la val  ag_fertcost_unit? fert_unit





*	30	
*	31

do "${do_hfps_util}/label_ag_plant_vs_prior.do"
la val ag_plant_vs_prior ag_plant_vs_prior
do "${do_hfps_util}/label_ag_subjective_assessment.do"
la val ag_????harv_subj ag_subjective_assessment

keep  y4_hhid round ag_* cropcode
isid  y4_hhid round
sort  y4_hhid round
sa "${tmp_hfps_mwi}/agriculture.dta", replace 
u  "${tmp_hfps_mwi}/agriculture.dta", clear 






















