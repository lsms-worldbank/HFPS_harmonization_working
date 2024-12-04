
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


// d s5* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"	//	yes
// d s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"	
// d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"	//	no
// d s5* using	"${raw_hfps_nga1}/r6_sect_5c.dta"	//	no
// d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
// d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	yes
// d s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	not really
// d s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r12_sect_5e_9a.dta"				//	no

// d s5* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r6_sect_5.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	yes, food prices
// d using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	yes
// d using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
// d using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
// d using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices
d using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	s5j & s6 


u	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta", clear
keep hhid select_s5j-s6eq0a

*	1	hh has grown crops since beginning of agricultural season 
ta s6q0
g		ag_refperiod_yn = (s6q0==1) if !mi(s6q0)
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"


*	5	not able to conduct hh ag activities
tabstat s6q2__*,  s(sum)

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (s6q2__1==1) if !mi(s6q2__1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (s6q2__2==1) if !mi(s6q2__2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (s6q2__3==1) if !mi(s6q2__3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (s6q2__4==1) if !mi(s6q2__4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (s6q2__5==1) if !mi(s6q2__5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (s6q2__6==1) if !mi(s6q2__6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (s6q2__7==1) if !mi(s6q2__7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s

*	6	not able to access fertilizer 
ta s6q3,m
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(s6q3==1)	if !mi(s6q3) 
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(s6q3==2)	if !mi(s6q3) 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
	*	ignore the o/s
	
*	7	main crop 
la li s6q4
g cropcode=s6q4 
la var cropcode	"Main crop code"

*	9	planting complete
ta s6q5
g		ag_plant_complete = (s6q5==1) if !mi(s6q5)
la var	ag_plant_complete	"Planting of main crop complete"

*	10 area planted
ta s6q6b	//	how best to convert these non-standard units? 

g ag_plant_q = s6q6
g ag_plant_u = s6q6b
g ag_plant_ha = s6q6 *	cond(s6q6b==5,0.40468564224,/*
*/						cond(s6q6b==6,1,/*
*/						cond(s6q6b==7,0.0001,.)))
la var ag_plant_q	"Number of land units planted with main crop"
la var ag_plant_q	"Land unit for with main crop"
la var ag_plant_ha	"Hectares planted with main crop"

*	11	area comparison to last planting
ta s6q7 
g ag_plant_vs_prior=s6q7
do "${do_hfps_util}/label_ag_plant_vs_prior.do" 
la val ag_plant_vs_prior ag_plant_vs_prior
la var ag_plant_vs_prior	"Comparative planting area vs last planting"

*	12	harvest expectation ex ante
ta s6q8 
g ag_anteharv_subj=s6q8
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"

do "${do_hfps_util}/label_ag_subjective_assessment.do"
la val ag_????harv_subj ag_subjective_assessment


*	15	normally sell
ta s6q10 	//	variable label is wrong, variable captures normal sales 
g		ag_sale_typical	= s6q10==1 if !mi(s6q10) 
la var	ag_sale_typical		"Main crop is typically marketed"

*	17	Pre-sale subjective assessment
ta s6q11 
g		ag_antesale_subj = s6q11 if !mi(s6q11)
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment


*	19	inorg fertilizer dummy
ta s6q12
g		ag_inorgfert_post = (s6q12==1) if !mi(s6q12)	//	no round requirement necessary
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	20	future fertilizer 
ta s6q14	
g		ag_inorgfert_ante = (s6q14==1) if !mi(s6q14)
la var	ag_inorgfert_ante	"Intend to apply inorganic fertilizer this season"

*	21	fert types tables 
loc v21 s6q13__
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'2) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'3) if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
loc v21 s6q15__
g		ag_ferttype_ante_label=.
la var	ag_ferttype_ante_label	"Intends to apply [...] fertilizer"
egen	ag_ferttype_ante_cat1 = anymatch(`v21'2)	if ag_inorgfert_ante==1, v(1)
egen	ag_ferttype_ante_cat2 = anymatch(`v21'3)	if ag_inorgfert_ante==1, v(1)
la var	ag_ferttype_ante_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_ante_cat2	"Nitrogen (CAN/Urea)"


*	23 reason no fertilizer
ta s6q16 
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(s6q16,1,2)) if !mi(s6q16)
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(s6q16,3)) if !mi(s6q16)
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(s6q16,4)) if !mi(s6q16)
la var	ag_inorgfert_no_cat3	"Not available"
	*	ignore o/s

*	25 Acquire full amount? 
ta s6q17 
g ag_fertilizer_fullq = (s6q17==1) if !mi(s6q17)
la var ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	28	Adaptations for fertilizer issue
tab1 s6q18__*
li s6q18_os if s6q18__96==1, sep(0)

g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat1=(s6q18__1==1) if !mi(s6q18__1)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
g		ag_nofert_adapt_cat2=(s6q18__2==1) if !mi(s6q18__2)
la var	ag_nofert_adapt_cat2	"Only fertilized part of cultivated area"
g		ag_nofert_adapt_cat3=(s6q18__3==1) if !mi(s6q18__3)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
g		ag_nofert_adapt_cat4=(s6q18__4==1) if !mi(s6q18__4)
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"


*	29	fertilizer price 
d s5j*	//	variable labels are a bit off here, use qx
ta s5jq2	//	type
ta s5jq2_os	//	type
ta s5jq3	//	q
ta s5jq3b	//	unit
ta s5jq4	//	lcu
preserve
keep hhid s5j*
keep if inlist(s5jq2,2,3) & !mi(s5jq3) & !mi(s5jq3b) & !mi(s5jq4)
ren (s5jq2 s5jq3 s5jq3b s5jq4)(t ag_fertcost_q ag_fertcost_unit ag_fertcost_lcu)
la li s5jq3b
recode ag_fertcost_unit (4=5)(10=44)(11=51)(12=23)(13=52)(30=53)(31=54)(50=55)(51=56)(52=57),copyrest	//	harmonize w/ panel
recode ag_fertcost_unit (1 3=1)(2=0.001)(5=0.01)(44=10)(51=25)(23=50)(52=100)(53/57=.), gen(conv) //	no conversion for the remainder
g ag_fertcost_kg = ag_fertcost_q * conv
g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg

replace t=t-1	//	will match the standard codes we hvae been using
keep hhid t ag_fertcost_*
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price, i(hhid) j(t) 
d

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

do "${do_hfps_util}/label_fert_unit.do"
la val  ag_fertcost_unit? fert_unit





g round=21
keep  hhid round ag_* cropcode
order hhid round 
isid  hhid round
sort  hhid round
sa "${tmp_hfps_nga}/agriculture.dta", replace 
 



































