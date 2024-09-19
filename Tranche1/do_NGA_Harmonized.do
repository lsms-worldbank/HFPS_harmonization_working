


********************************************************************************
********************************************************************************

***********************   **    **   ******      **      ***********************
***********************   **    **  ********    ****     ***********************
***********************   **    **  **         **  **    ***********************
***********************   ***   **  **        **    **   ***********************
***********************   ****  **  **  ****  ********   ***********************
***********************   ** ** **  **  ****  ********   ***********************
***********************   **  ****  **    **  **    **   ***********************
***********************   **   ***  **    **  **    **   ***********************
***********************   **    **  ********  **    **   ***********************
***********************   **    **   ******   **    **   ***********************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga1}/r1_sect_1.dta"
d using	"${raw_hfps_nga1}/r2_sect_1.dta"
d using	"${raw_hfps_nga1}/r3_sect_1.dta"
d using	"${raw_hfps_nga1}/r4_sect_1.dta"
d using	"${raw_hfps_nga1}/r5_sect_1.dta"
d using	"${raw_hfps_nga1}/r6_sect_1.dta"
d using	"${raw_hfps_nga1}/r7_sect_1.dta"
d using	"${raw_hfps_nga1}/r8_sect_1.dta"
d using	"${raw_hfps_nga1}/r9_sect_1.dta"
d using	"${raw_hfps_nga1}/r10_sect_1.dta"
d using	"${raw_hfps_nga1}/r11_sect_1.dta"
d using	"${raw_hfps_nga1}/r12_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"


d using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
d using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
d using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
d using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
d using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"
d using	"${raw_hfps_nga1}/r12_sect_a_12.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"



*	household level detail from actual completed interview (incl. weights)
#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"
	"${raw_hfps_nga1}/r12_sect_a_12.dta"
	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
, gen(round);
keep round-interviewer_id wt_baseline 
	s12q3__0 s12q3__1 s12q3__2 s12q3__3 s12q3__4 s12q3__5 s12q3__6 s12q3__7 
	s12q4__0 s12q4__1 s12q4__2 s12q4__3 
	s12q5 s12q9 s12q10 s12q10_os s12q11 s12q14 
	baseline_date wt_round2 s12q10a 
	wt_round3 wt_r3panel filter s12q4a s12q4b 
	wt_round4 wt_r4panel 
	wt_round5 wt_r5panel 
	wt_round6 wt_r6panel 
	wt_round7 wt_r7panel 
	wt_round8 wt_r8panel 
	wt_round9 wt_r9panel 
	wt_round10 wt_r10panel 
	wt_round11 wt_r11panel 
	s12bq1 s12bq1_os s12bq2 s12bq3 s12bq4 s12bq4_os s12bq5 
	wt_youth_r12 wt_youth_r12_panel 
	wt_p2round1 wt_p2round2 
	mig_respondent GHS_state s2aq0a s2aq0b s2aq3 s2aq4 s2aq4_os s2aq5 
	s2aq6 s2aq7 s2aq8 s2aq8_os s2aq9 s2aq10 s2aq10_os s2aq11 
	s2aq12__1 s2aq12__2 s2aq12__3 s2aq12__4 s2aq12__5 s2aq12__6 s2aq12__7 
	s2aq12__8 s2aq12__9 s2aq12__10 s2aq12__11 s2aq12__12 s2aq12__13 s2aq12__14 
	s2aq12__15 s2aq12__96 s2aq12_os 
	s2aq13__1 s2aq13__2 s2aq13__3 s2aq13__4 
	s2aq16 s2aq17__1 s2aq17__2 s2aq17__3 s2aq17__4 s2aq17__5 s2aq17__6 
	s2aq17__7 s2aq17__8 s2aq17__9 s2aq17__10 s2aq17__11 s2aq17__12 s2aq17__13 
	s2aq18 s2aq18_os 
	wt_p2round3 wt_p2round3_panel 
	wt_p2round4 wt_p2round4_panel 
	wt_p2round5 wt_p2round5_panel
	wt_p2round6 wt_p2round6_panel 
	wt_p2round7 wt_p2round7_panel wt_p2round7_farm_hh wt_p2round7_farm_ind 
	wt_p2round8 wt_p2round8_panel 
	wt_p2round9 wt_p2round9_panel
	;
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	isid hhid round
	sort hhid round
	order wt_round* wt_youth_r12 wt_p2round? wt_r*panel wt_youth_r12_panel wt_p2round?_panel, a(wt_baseline)
	d s2a*
	drop s2aq3-s2aq18_os
	
	d
	tabstat wt_*, by(round) s(sum) format(%12.3gc)
	egen wgt = rowfirst(wt_baseline wt_round2 wt_round3 wt_round4 wt_round5 wt_round6 wt_round7 wt_round8 wt_round9 wt_round10 wt_round11 wt_youth_r12 wt_p2round1 wt_p2round2 wt_p2round3 wt_p2round4 wt_p2round5 wt_p2round6 wt_p2round7 wt_p2round8 wt_p2round9)
	tabstat wt_*, by(round) s(n) format(%12.3gc)
	egen wgt_panel = rowfirst(wt_baseline wt_round2 wt_r3panel wt_r4panel wt_r5panel wt_r6panel wt_r7panel wt_r8panel wt_r9panel wt_r10panel wt_r11panel wt_youth_r12_panel wt_p2round3_panel wt_p2round4_panel wt_p2round5_panel wt_p2round6_panel wt_p2round7_panel wt_p2round8_panel wt_p2round9_panel)
	drop wt_*
	order wgt wgt_panel, a(ea)
	la var wgt			"Sampling weight"
	la var wgt_panel	"Panel sampling weight"
	
	tab2 round zone state sector, m first
	d s12q3*	// we don't care
	drop s12q3*
	d s12q4*
	drop s12q4*
	d s12*
	drop s12q11 s12q10a s12bq1 s12bq1_os s12bq2 s12bq3 s12bq4 s12bq4_os s12bq5
	
	ta state s2aq0b
	ta round if !mi(s2aq0a),m	//	round 14 only
	ta GHS_state state	//	identical (GHS_state is string)
	drop GHS_state s2aq0a	//	only round 14, let's ignore for an overall cover 
	
	ta s12q10_os
	ta s12q10	//	english and X responses coded = X where option is available
	g str = strtrim(stritrim(lower(s12q10_os)))
	li str if length(str)>20
	recode s12q10 (96=5) if inlist(str,"english / igbo","english and igbo","igbo and english")
	recode s12q10 (96=4) if inlist(str,"both english and yoruba","english/yoruba","yoruba/english")
	ta str if s12q10==96
	drop str s12q10_os
	
	tabstat s12q5 s12q9 s12q10, s(n) by(round)
	ta round s12q5, m
	li s12q14 in 1/10
	tempfile s12
	sa `s12'
	
	ta round
	
	
	
#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_1.dta"
	"${raw_hfps_nga1}/r2_sect_1.dta"
	"${raw_hfps_nga1}/r3_sect_1.dta"
	"${raw_hfps_nga1}/r4_sect_1.dta"
	"${raw_hfps_nga1}/r5_sect_1.dta"
	"${raw_hfps_nga1}/r6_sect_1.dta"
	"${raw_hfps_nga1}/r7_sect_1.dta"
	"${raw_hfps_nga1}/r8_sect_1.dta"
	"${raw_hfps_nga1}/r9_sect_1.dta"
	"${raw_hfps_nga1}/r10_sect_1.dta"
	"${raw_hfps_nga1}/r11_sect_1.dta"
	"${raw_hfps_nga1}/r12_sect_1.dta"
	"${raw_hfps_nga2}/p2r1_sect_1.dta"
	"${raw_hfps_nga2}/p2r2_sect_1.dta"
	"${raw_hfps_nga2}/p2r3_sect_1.dta"
	"${raw_hfps_nga2}/p2r4_sect_1.dta"
	"${raw_hfps_nga2}/p2r5_sect_1.dta"
	"${raw_hfps_nga2}/p2r6_sect_1.dta"
	"${raw_hfps_nga2}/p2r7_sect_1.dta"
	"${raw_hfps_nga2}/p2r8_sect_1.dta"
	"${raw_hfps_nga2}/p2r9_sect_1.dta"
, gen(round);
#d cr

la drop _append
la val round 
ta round 	

isid hhid call_id round	
duplicates report hhid round

ta round if !mi(s1q2)
ta round if !mi(s1q1b)

*	can we safely assume that the last call is the one we want? 
bys hhid round (call_id) : keep if _n==_N
ta round if mi(s1q2)
replace s1q2 = s1q1b if mi(s1q2) & !mi(s1q1b)
keep hhid round s1q2 
mer 1:1 hhid round using `s12'

ta round if _m==2
drop _m

*	dates 
li s1q2 s12q14 in 1/10
convert_date_time s1q2 s12q14
egen double pnl_intclock = rowfirst(s1q2 s12q14)
format pnl_intclock %tc
drop s1q2 s12q14
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td

g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal

isid hhid round
sort hhid round

sa "${local_storage}/tmp_NGA_cover.dta", replace 


*	modifications for construction of grand panel 
u "${local_storage}/tmp_NGA_cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_wgt = wgt 

sa "${local_storage}/tmp_NGA_pnl_cover.dta", replace 






********************************************************************************
}	/*	end Cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************


*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga1}/r1_sect_2.dta"
d using	"${raw_hfps_nga1}/r2_sect_2.dta"
d using	"${raw_hfps_nga1}/r3_sect_2.dta"
d using	"${raw_hfps_nga1}/r4_sect_2.dta"
d using	"${raw_hfps_nga1}/r5_sect_2.dta"
d using	"${raw_hfps_nga1}/r6_sect_2.dta"
d using	"${raw_hfps_nga1}/r7_sect_2.dta"
d using	"${raw_hfps_nga1}/r8_sect_2.dta"
d using	"${raw_hfps_nga1}/r8_sect_2.dta"
d using	"${raw_hfps_nga1}/r9_sect_2.dta"
d using	"${raw_hfps_nga1}/r10_sect_2.dta"
d using	"${raw_hfps_nga1}/r11_sect_2.dta"
d using	"${raw_hfps_nga1}/r12_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"	//	this is what we need for p2r2
d using	"${raw_hfps_nga2}/p2r2_sect_2a.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2a_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_2b.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_2.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta"

*	need an automated check for value label changes
u	"${raw_hfps_nga1}/r1_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r1
sa		`r1'
u	"${raw_hfps_nga1}/r2_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r2
sa		`r2'
u	"${raw_hfps_nga1}/r3_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r3
sa		`r3'
u	"${raw_hfps_nga1}/r4_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r4
sa		`r4'
u	"${raw_hfps_nga1}/r5_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r5
sa		`r5'
u	"${raw_hfps_nga1}/r6_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r6
sa		`r6'
u	"${raw_hfps_nga1}/r7_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r7
sa		`r7'
u	"${raw_hfps_nga1}/r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r8
sa		`r8'
u	"${raw_hfps_nga1}/r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r9
sa		`r9'
u	"${raw_hfps_nga1}/r9_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r10
sa		`r10'
u	"${raw_hfps_nga1}/r10_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r11
sa		`r11'
u	"${raw_hfps_nga1}/r11_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r12
sa		`r12'
u	"${raw_hfps_nga1}/r12_sect_2.dta"		, clear
la li s2q7_r11
la copy s2q7_r11 s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r13
sa		`r13'
u	"${raw_hfps_nga2}/p2r1_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r14
sa		`r14'
u	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r15
sa		`r15'
u	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r16
sa		`r16'
u	"${raw_hfps_nga2}/p2r4_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r17
sa		`r17'
u	"${raw_hfps_nga2}/p2r5_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r18
sa		`r18'
u	"${raw_hfps_nga2}/p2r6_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r19
sa		`r19'
u	"${raw_hfps_nga2}/p2r7_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r20
sa		`r20'
u	"${raw_hfps_nga2}/p2r8_sect_2.dta"		, clear
la li s2q7
uselabel s2q7, clear	// using "${local_storage}/tmp_NGA_r1_s2q7"
tempfile r21
sa		`r21'

u `r1', clear
forv i=2/21 {
	mer 1:1 value label using `r`i'', gen(_`i')
}
egen matches = anycount(_2-_21), v(3)
recode _* (3=1)(else=.)
la drop _merge
la val _* .
li value label _* if matches<21, nol
sort value label
li value label matches _*, nol sep(0)
*	leave as-is for the country-specific panel, but reconcile in the grand panel


#d ; 
loc raw1	"${raw_hfps_nga1}/r1_sect_2.dta";
loc raw2	"${raw_hfps_nga1}/r2_sect_2.dta";
loc raw3	"${raw_hfps_nga1}/r3_sect_2.dta";
loc raw4	"${raw_hfps_nga1}/r4_sect_2.dta";
loc raw5	"${raw_hfps_nga1}/r5_sect_2.dta";
loc raw6	"${raw_hfps_nga1}/r6_sect_2.dta";
loc raw7	"${raw_hfps_nga1}/r7_sect_2.dta";
loc raw8	"${raw_hfps_nga1}/r8_sect_2.dta";
loc raw9	"${raw_hfps_nga1}/r9_sect_2.dta";
loc raw10	"${raw_hfps_nga1}/r10_sect_2.dta";
loc raw11	"${raw_hfps_nga1}/r11_sect_2.dta";
loc raw12	"${raw_hfps_nga1}/r12_sect_2.dta";
loc raw13	"${raw_hfps_nga2}/p2r1_sect_2.dta";
loc raw14	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta";		
loc raw15	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta";	
loc raw16	"${raw_hfps_nga2}/p2r4_sect_2.dta";			
loc raw17	"${raw_hfps_nga2}/p2r5_sect_2.dta";			
loc raw18	"${raw_hfps_nga2}/p2r6_sect_2.dta";			
loc raw19	"${raw_hfps_nga2}/p2r7_sect_2.dta";			
loc raw20	"${raw_hfps_nga2}/p2r8_sect_2.dta";			
loc raw21	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta";		

u "`raw1'" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)21 {;
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

levelsof name if matches>=10, clean
li name var1 matches if matches>=10, sep(0)
li name var1 matches if matches<10, sep(0)

*	which round is missing indiv or hhid? 
li _* matches if inlist(name,"hhid","indiv"), nol	//	how can these possibly differ? 



*	household level detail from actual completed interview (incl. weights)
u "${raw_hfps_nga1}/r8_sect_2.dta", clear
la li s2q7


#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_2.dta"
	"${raw_hfps_nga1}/r2_sect_2.dta"
	"${raw_hfps_nga1}/r3_sect_2.dta"
	"${raw_hfps_nga1}/r4_sect_2.dta"
	"${raw_hfps_nga1}/r5_sect_2.dta"
	"${raw_hfps_nga1}/r6_sect_2.dta"
	"${raw_hfps_nga1}/r7_sect_2.dta"
	"${raw_hfps_nga1}/r8_sect_2.dta"
	"${raw_hfps_nga1}/r9_sect_2.dta"
	"${raw_hfps_nga1}/r10_sect_2.dta"
	"${raw_hfps_nga1}/r11_sect_2.dta"
	"${raw_hfps_nga1}/r12_sect_2.dta"
	"${raw_hfps_nga2}/p2r1_sect_2.dta"
	"${raw_hfps_nga2}/p2r2_sect_2_2a.dta"	//	this is what we need for p2r2
	"${raw_hfps_nga2}/p2r3_sect_2_6b_6c.dta"
	"${raw_hfps_nga2}/p2r4_sect_2.dta"
	"${raw_hfps_nga2}/p2r5_sect_2.dta"
	"${raw_hfps_nga2}/p2r6_sect_2.dta"
	"${raw_hfps_nga2}/p2r7_sect_2.dta"
	"${raw_hfps_nga2}/p2r8_sect_2.dta"
	"${raw_hfps_nga2}/p2r9_sect_2_6e.dta"
, gen(round);
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	isid hhid indiv round
	sort hhid indiv round
	format hhid %20.0f
	format indiv %9.0f
	d s2a*
	drop s2a*
	drop s6*
	drop wt_*
	drop zone-ea

	
	d
	  //demographic information
	     gen member=(s2q2==1|s2q3==1)
		 replace member = 1 if round==12	//	youth round, no comparable questions
		 gen sex=s2q5
		 gen age=s2q6
	     gen head=(s2q7==1|s2q9==1)
	     gen relation=s2q7 
		 replace relation=s2q9 if relation==. & s2q9!=.
		 label copy s2q9 relation
		 label val relation relation
		 gen relation_os=s2q7_os
		 replace relation_os=s2q9_os if relation_os=="" & s2q9_os!=""
		 		 
	  //respondent		 	  
	  ta round respondent, m	//	only available in rounds 14/15
	  d using "${local_storage}/tmp_NGA_cover.dta"
		g s12q9=indiv
		mer 1:1 hhid round s12q9 using "${local_storage}/tmp_NGA_cover.dta", keepus(s12q5 s12q9)
		ta round _m
		ta s12q9 if _m==2, m	//	dominated by missing
		ta s12q5 _m, m	//	most of these are just incomplete interviews
	ta _m respondent	//	imperfect... 
		keep if inlist(_m,1,3)
		g respond = (_m==3)
		
		 bys hhid round (indiv) : egen testresp = sum(respond)
		ta round testresp,m	//	widely distributed, rounds 12 and 19 noticeably high, serveral zero 
		ta respond member,m
		
		*	step 1 assume prior round respondent was interviewed again if available 
		bys hhid indiv (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (indiv) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	round 1 most pronounced
		li hhid round indiv member respond if testresp2==0, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round indiv member respond age sex testresp2 if flagresp==0, sepby(hhid)
		li hhid round indiv member respond if flagresp==0 & (respond==1 | testresp2==0), sepby(hhid)

	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min))
		bys hhid indiv (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1])	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys hhid round (indiv) : replace respond =1 if testresp2!=1 & _N==1	//	2
			
		
		bys hhid round (indiv) : egen testresp3 = sum(respond)
		ta round testresp3
		by hhid : egen flagresp2 = min(testresp3)
		li hhid round indiv member respond age sex relation testresp3 if flagresp2==0, sepby(hhid)
		li hhid round indiv member respond age sex relation if flagresp2==0 & (respond==1 | testresp3==0), sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the head
		recode respond (0=1) if inlist(hhid,39048,149091,160053,169065,210033,300035) & round==1 & relation==1

		*	can't really resolve the remainder 
	  drop testresp-flagresp2

		*	fill in with prior round information where possible
		su
		cou
		foreach x in age sex relation {
			tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
		bys hhid indiv (round) : egen `maxmiss'= max(mi(`x'))
		by  hhid indiv (round) : egen `maxnmiss'= max(`x')
		by  hhid indiv (round) : egen `minnmiss'= min(`x')
		by  hhid indiv (round), rc0 : egen `modenmiss'= mode(`x')
		
		g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
		replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
		su `x' if `maxmiss'==1
		replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
		su `x' if `maxmiss'==1
		
		drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
			}
		
** DROP UNNECESSARY VARIABLES		 
      keep phase-indiv member-relation_os respond

	  isid hhid indiv round
	  sort hhid indiv round
	  sa "${local_storage}/tmp_NGA_ind.dta", replace

	  		
			
*	use individual panel to make demographics 
u "${local_storage}/tmp_NGA_ind.dta", clear
ta member round,m

*	respondent characteristics
foreach x in sex age head relation {
	bys hhid round (indiv) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}


*	do we still have a respondent and a head for all
bys hhid round (indiv) : egen headtest = sum(head) 
bys hhid round (indiv) : egen resptest = sum(respond) 
bys hhid round (indiv) : egen memtest = sum(member) 
tab1 *test,m


keep if member==1
format hhid indiv %9.3g



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
			


sa "${local_storage}/tmp_NGA_demog.dta", replace
 

********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d using	"${raw_hfps_nga1}/r1_sect_1.dta"
d using	"${raw_hfps_nga1}/r2_sect_1.dta"
d using	"${raw_hfps_nga1}/r3_sect_1.dta"
d using	"${raw_hfps_nga1}/r4_sect_1.dta"
d using	"${raw_hfps_nga1}/r5_sect_1.dta"
d using	"${raw_hfps_nga1}/r6_sect_1.dta"
d using	"${raw_hfps_nga1}/r7_sect_1.dta"
d using	"${raw_hfps_nga1}/r8_sect_1.dta"
d using	"${raw_hfps_nga1}/r9_sect_1.dta"
d using	"${raw_hfps_nga1}/r10_sect_1.dta"
d using	"${raw_hfps_nga1}/r11_sect_1.dta"
d using	"${raw_hfps_nga1}/r12_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"


d using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
d using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
d using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
d using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
d using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"

d using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"		//	has emp_respondent->	pull into individual
d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	has emp_respondent->	pull into individual
d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	has emp_respondent->	pull into individual	
d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"		//	has emp_respondent->	pull into individual

d using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
	*	this p2r9 section 6 is actually ag 

*	NFE modules 
u s6* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"		, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"			, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"		, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"			, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"		, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"			, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"				, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		, clear
la li s6q11
u s6* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	, clear
la li s6q11
u s6* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"		, clear
la li s6q12
u s6* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	, clear
la li s6q12
	
	

	
*	track reason closed label 
u s6* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"		, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r1
// sa		`r1'
u s6* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r2
sa		`r2'
u s6* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r3
sa		`r3'
u s6* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r4
sa		`r4'
u s6* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r5
sa		`r5'
u s6* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r6
sa		`r6'
u s6* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r7
sa		`r7'
u s6* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"				, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r8
sa		`r8'
u s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r9
sa		`r9'
u s6* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r10
sa		`r10'
u s6* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r11
sa		`r11'
u s6* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r2
// sa		`r2'
u s6* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r2
// sa		`r2'
	
u `r2', clear
foreach i of numlist 3/11 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	/*	us round 9+ as the standard	*/ 

	
	*	track sector label across all rounds 
u	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"						, clear 
ds, has(varl *activity* *ACTIVITY* *Activity*) detail 
uselabel s6q5, clear
tempfile r1
sa		`r1'
u	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r2
sa		`r2'
u	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r3
sa		`r3'
u	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r4
sa		`r4'
u	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r5
sa		`r5'
u	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r6
sa		`r6'
u	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r7
sa		`r7'
u	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"								, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r8
sa		`r8'
u	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r9
sa		`r9'
u	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r10
sa		`r10'
u	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r11
sa		`r11'
u	"${raw_hfps_nga1}/r12_sect_a_12.dta"								, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r12
// sa		`r12'
u	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r13
sa		`r13'
u	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r14
sa		`r14'
u	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b s6cq3, clear
tempfile r15
sa		`r15'
u	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r16
sa		`r16'
u	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r17
sa		`r17'
u	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r18
sa		`r18'
u	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r19
// sa		`r19'
u	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r20
sa		`r20'
u	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r21
// sa		`r21'

u `r1', clear
foreach i of numlist 2/11 13/18 20 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	/*	perfectly aligned. These will be the standard we align all others to.	*/ 

	


#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"

	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"

	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"

	, gen(round);
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	replace round=round+1 if round>11
	replace round=round+1 if round>18
	isid hhid round
	sort hhid round
	assert !inlist(round,12,19,21)	//	no employment modules in these rounds

	d using "${local_storage}/tmp_NGA_cover.dta"
	mer 1:1 hhid round using "${local_storage}/tmp_NGA_cover.dta"
	ta round _m	//	perfect
	keep if _m==3
	ta s12q5
	ta s12q5 s6q1,m
ta round s6q1 if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	
	keep hhid round *_case emp_respondent s6*
	drop s6a*	//	farming items 
	drop s6q17-s6q8f_os	//	farming items 
	drop s6q2a-s6q2e	//	farming items
	drop s6b*	//	livestock items

	d *_case
	tab2 round *_case, first m
	d s6*
	ds s6*, not(type string)
	tabstat `r(varlist)', by(round) format(%12.3gc)


ta round s6q1,m 
ta s6q6 round,m
ta s6q6 s6q1, m
	
g work_cur = (s6q1==1) if inlist(s6q1,1,2)
g nwork_cur=1-work_cur
la li s6q6
recode s6q6 (4/6=1)(1 2=2)(3=3), gen(category_cur)
la def category_cur 1 "Wage" 2 "Non-farm enterprise" 3 "Family farm"
g wage_cur = (s6q1==1 & inlist(s6q6,4,5)) if inlist(s6q1,1,2)
g biz_cur  = (s6q1==1 & inlist(s6q6,1,2)) if inlist(s6q1,1,2)
g farm_cur = (s6q1==1 & inlist(s6q6,3))   if inlist(s6q1,1,2)
la var work_cur		"Respondent currently employed"
la var nwork_cur	"Respondent currently unemployed"
la var wage_cur		"Respondent mainly employed for wages"
la var biz_cur		"Respondent mainly employed in household enterprise"
la var farm_cur		"Respondent mainly employed on family farm"

*	sector
tab2 round s6q4 s6q5 s6q5b s6cq3, first m
ta s6q5 round,m
egen sector_cur = rowfirst(s6q5 s6q5b)
run "${hfps_github}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"
	
tabstat s6q8b s6q8b1, by(round) s(n)	//	skip codes changed between these two
egen hours_cur = rowfirst(s6q8b s6q8b1)
ta hours_cur
assert hours_cur<=168 if !mi(hours_cur)
la var hours_cur	"Hours respondent worked in current employment"


**	NFE
g nfe_round = (inrange(round,1,11) | inlist(round,13,18))
tab2 round s6q11 s6q11a if nfe_round==1, first m	//	s6q11 changes to continuous in round 20
g		refperiod_nfe = (s6q11==1) if nfe_round==1 & !mi(s6q11)
la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"

*	activity 
d s6q11c	//	this is just a string, not particularly useful without the categorization, though can be used to check categorization

*	sector 
tab2 round s6q12 if nfe_round==1, m first
la li s6q12 
la val sector_cur emp_sector
g sector_nfe = s6q12 if nfe_round==1
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"
ta sector_nfe round,m

*	currently operational->	not collected for NGA

*	events experienced
d s6q14__* 
tabstat s6q14__*, by(round)	//	verified that this is only in round 18
egen xx = rowmax(s6q14__1-s6q14__96)
ta xx s6q14__9	//	good 
drop xx
g event_lbl_nfe =.
la var event_lbl_nfe	"Events experienced by NFE"
foreach i of numlist 1/9 96 {
	loc v s6q14__`i'
	g event`i'_nfe = (`v'==1) if !mi(`v') 
	loc lbl = subinstr("`: var lab `v''","Events experienced:","",1)
	la var event`i'_nfe	"`lbl'"
}

*	challenges faced
d s6q15__*
tabstat s6q15__*, by(round)
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/6 96	{
	loc v s6q15__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
	loc lbl = subinstr("`: var lab `v''","Challenges faced: ","",1)
	la var challenge`i'_nfe "`lbl'"
}
tabstat challenge*_nfe, by(round)	

*	closed why
d s6q11b
ta s6q11b round, m	//	labels undocumented for 11 12 13
g closed_why_nfe = s6q11b
la copy s6q11b closed_why_nfe
la def closed_why_nfe  1  "USUAL PLACE OF BUSINESS CLOSED DUE TO CORONAVIRUS RECOMMENDATIONS", modify	//	change in round 4
la def closed_why_nfe 11  "LACK OF CAPITAL OR LOSS OF WORKING CAPITAL", modify	//	change in round 5
la def closed_why_nfe 12  "USUAL PLACE OF BUSINESS CLOSED DUE TO ENDSARS PROTESTS", modify	//	change in round 7
la def closed_why_nfe 13  "INCREASE IN THE PRICE OF INPUTS", modify	//	change in round 9
la val closed_why_nfe closed_why_nfe
la var closed_why_nfe	"Reason NFE was closed"

*	respondent where available 
d using  "${local_storage}/tmp_NGA_ind.dta"
g indiv = emp_respondent
mer m:1 hhid indiv round using "${local_storage}/tmp_NGA_ind.dta", keep(1 3)
ta round _m, nol
ta respond if _m==3,m	//	99% same person 
g emp_resp_main = respond
foreach x in sex age head relation {
g emp_resp_`x' = `x' 
}
drop indiv-_merge
order emp_resp_*, a(emp_respondent)
la var emp_resp_main		"Employment respondent = primary respondent"
la var emp_resp_sex			"Sex of employment respondent"
la var emp_resp_age			"Age of employment respondent"
la var emp_resp_head		"Employment respondent is head"
la var emp_resp_relation	"Employment respondent relationship to household head"

d *_cur *_nfe
keep hhid round *_cur *_nfe emp_resp*
isid hhid round
sort hhid round
sa "${local_storage}/tmp_NGA_employment.dta", replace 


********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2

*	looking for section 8 
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga1}/r1_sect_1.dta"
d using	"${raw_hfps_nga1}/r2_sect_1.dta"
d using	"${raw_hfps_nga1}/r3_sect_1.dta"
d using	"${raw_hfps_nga1}/r4_sect_1.dta"
d using	"${raw_hfps_nga1}/r5_sect_1.dta"
d using	"${raw_hfps_nga1}/r6_sect_1.dta"
d using	"${raw_hfps_nga1}/r7_sect_1.dta"
d using	"${raw_hfps_nga1}/r8_sect_1.dta"
d using	"${raw_hfps_nga1}/r9_sect_1.dta"
d using	"${raw_hfps_nga1}/r10_sect_1.dta"
d using	"${raw_hfps_nga1}/r11_sect_1.dta"
d using	"${raw_hfps_nga1}/r12_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"


d s8* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d s8* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
// d s8* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d s8* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
// d s8* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d s8* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
// d s8* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
// d s8* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"
// d s8* using	"${raw_hfps_nga1}/r12_sect_a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
d s8* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d s8* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"





#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
, gen(round);

#d cr
keep hhid round s8q*

	la drop _append
	la val round 
	ta round 	
	replace round=round+1 if round>2
	replace round=round+2 if round>4
	replace round=round+10 if round>7
	replace round=round+2 if round>18
	ta round
	
d s8q?
la li s8q1 s8q2 s8q3 s8q4 s8q5 s8q6 s8q7 s8q8

g worried	= s8q1=="1. YES":s8q1 if inlist(s8q1,"2. NO":s8q1,"1. YES":s8q1)
g healthy	= s8q2=="1. YES":s8q2 if inlist(s8q2,"2. NO":s8q2,"1. YES":s8q2)
g fewfood	= s8q3=="1. YES":s8q3 if inlist(s8q3,"2. NO":s8q3,"1. YES":s8q3)
g skipped	= s8q4=="1. YES":s8q4 if inlist(s8q4,"2. NO":s8q4,"1. YES":s8q4)
g ateless	= s8q5=="1. YES":s8q5 if inlist(s8q5,"2. NO":s8q5,"1. YES":s8q5)
g runout	= s8q6=="1. YES":s8q6 if inlist(s8q6,"2. NO":s8q6,"1. YES":s8q6)
g hungry	= s8q7=="1. YES":s8q7 if inlist(s8q7,"2. NO":s8q7,"1. YES":s8q7)
g whlday	= s8q8=="1. YES":s8q8 if inlist(s8q8,"2. NO":s8q8,"1. YES":s8q8)


*	get weight and hhsize vars 
d using "${local_storage}/tmp_NGA_cover.dta"
mer 1:1 round hhid using "${local_storage}/tmp_NGA_cover.dta", keepus(sector wgt)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
assert min==max
keep if _m==3
drop _m min max

mer 1:1 round hhid using "${local_storage}/tmp_NGA_demog.dta", keepus(hhsize)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
keep if _m==3 | min!=max
drop _m min max


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m
tabstat wgt wgt_hh, by(round) s(n)

g na="NA" 
g urban = (sector=="1. Urban":sector)

cap : erase "${local_storage}/FIES_NGA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if round!=1 & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_NGA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried very high at 0.99, skipped very low at 0.71. Several 
		others >0.35
		1	dropped worried => fewfood high at .50 skipped low at .53
		2	dropped skipped => fewfood still hgh at .40
		3	dropped fewfood => remainder <=.35 
	3	downloaded and saved as FIES_NGA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
	Moderate or Severe	MoE	Severe	MoE
2	75.82	4.93	32.95	4.93
4	71.66	5.60	34.72	5.25
7	60.10	5.52	19.68	4.01
18	64.91	5.31	25.77	4.61
21	57.52	7.98	18.33	5.71
*/

levelsof round if round!=1, loc(rounds)
foreach r of local rounds {
	cap : erase "${local_storage}/FIES_NGA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${local_storage}/FIES_NGA_r`r'_in.csv", delim(",")
}


/*

round 2 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r2_out.csv

round 4 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r4_out.csv

round 7 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r7_out.csv

round 18 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r18_out.csv

round 21 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r21_out.csv


*/




*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${local_storage}/FIES_NGA_out.csv", varn(1) clear
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
import delimited using "${local_storage}/FIES_NGA_r`r'_out.csv", varn(1) clear
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
sa "${local_storage}/tmp_NGA_fies.dta", replace
	
	
	

********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************

********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d shock_cd* s10* using	"${raw_hfps_nga1}/r1_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r3_sect_10.dta"
d shock_cd* s10* using	"${raw_hfps_nga1}/r8_sect_10.dta"

d using	"${raw_hfps_nga2}/p2r6_sect_10.dta"	//	simplified capture of coping mechanisms 



u "${raw_hfps_nga1}/r1_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r3_sect_10.dta", clear
la li shock_cd s10q1
u "${raw_hfps_nga1}/r8_sect_10.dta", clear
la li shock_cd s10q1	//	added 13 fuel cost
u "${raw_hfps_nga2}/p2r6_sect_10.dta", clear
la li shock_cd s10q1 s10q3 	//	code shift 

ta shock_cd s10q1
recode shock_cd (1=5)(2=6)(3=7)(4=10)(5/7=13)(8=11)(9=12)(10=8)(11=1)(12=96), copyrest gen(shock_alt)
replace shock_cd_os="Reduction in work hours" if shock_cd==12 & s10q1==1
bys hhid (shock_cd) : egen multios = sum(shock_alt==96 & s10q1==1)
ta multios
li shock_cd shock_cd_os if multios==2, sepby(hhid) nol
g shock_alt_os = shock_cd_os
bys hhid (shock_cd) : replace shock_alt_os = shock_cd_os[_n-1] + " + " + shock_alt_os if shock_cd[_n-1]==12 & s10q1[_n-1]==1 & s10q1==1
li shock_cd shock_cd_os shock_alt_os if multios==2 & inlist(shock_cd,12,96), sepby(hhid) nol

*	now adjust the coping mechanisms and reshape to match phase 1 version
la li s10q3
egen s10q3__1 = anymatch(s10q3_?), v(1)
egen s10q3__6 = anymatch(s10q3_?), v(2)
egen s10q3__7 = anymatch(s10q3_?), v(3)
egen s10q3__8 = anymatch(s10q3_?), v(4)
egen s10q3__9 = anymatch(s10q3_?), v(5)
egen s10q3__11= anymatch(s10q3_?), v(6)
egen s10q3__12= anymatch(s10q3_?), v(7)
egen s10q3__13= anymatch(s10q3_?), v(8)
egen s10q3__14= anymatch(s10q3_?), v(9)
egen s10q3__15= anymatch(s10q3_?), v(10)
egen s10q3__16= anymatch(s10q3_?), v(11)
egen s10q3__17= anymatch(s10q3_?), v(12)
egen s10q3__18= anymatch(s10q3_?), v(13)
egen s10q3__19= anymatch(s10q3_?), v(14)
egen s10q3__20= anymatch(s10q3_?), v(15)
// egen s10q3__22= anymatch(s10q3_?), v(1)	//	not a coded option in r18 
egen s10q3__21= anymatch(s10q3_?), v(16)
egen s10q3__96= anymatch(s10q3_?), v(96)

bys hhid shock_alt (shock_cd) : egen multicopeos = sum(s10q3__96==1 & s10q1==1)
ta multicopeos

li hhid shock_cd shock_alt s10q3_os if multicopeos==3, sepby(shock_alt)
*	just ignoring the string s10q3_os for now 

*	this simple approach will mean we lose some of the o/s  
collapse (lastnm) shock_alt_os (min) s10q1 (max) s10q3__*, by(hhid shock_alt)
ren shock_alt* shock_cd*
tempfile r18
sa		`r18'
#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_10.dta"
	"${raw_hfps_nga1}/r3_sect_10.dta"
	"${raw_hfps_nga1}/r8_sect_10.dta"
	
	`r18'	
, gen(round);
#d cr

	la drop _append
	la val round 
	replace round=round+1 if round>1
	replace round=round+4 if round>3
	replace round=round+9 if round>8
	assert inlist(round,1,3,8,18)
	ta round 	
	isid hhid shock_cd round
	sort hhid shock_cd round

	d using "${local_storage}/tmp_NGA_cover.dta"
	mer m:1 hhid round using "${local_storage}/tmp_NGA_cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3
	ta s12q5
	drop _m s12q5
	
	ta shock_cd round if s10q1==1
	la def shock_cd 13 "13. Increase in the price of fuel/transportation", add
	
	ta shock_cd_os
	g str = strtrim(lower(shock_cd_os))
	li str if !mi(str) & shock_cd==96, sep(20)
	ta str	//	several of these seem more like the result of shocks than a specific shock
	drop str
	
	*	make slightly cleaner but leave at shock level, then collapse to hh level in a second step
	g shock_yn = (s10q1==1) if !mi(s10q1)
	la var shock_yn	"Affected by shock since last interaction"
	ds s10q3__*, not(type string)
	loc vars `r(varlist)'	//	this is simply automated here, could manually set the order to harmonize later
// 	loc vars s10q3__1 s10q3__6 s10q3__7 s10q3__8 s10q3__9 s10q3__11 s10q3__12 s10q3__13 s10q3__14 s10q3__15 s10q3__16 s10q3__17 s10q3__18 s10q3__19 s10q3__20 s10q3__21 s10q3__22 s10q3__96
	foreach v of local vars {
		loc i = substr("`v'",strpos("`v'","__")+2,length("`v'")-strpos("`v'","__")-1)
		g shock_cope_`i' = `v'
		loc rawlbl : var lab `v'	//	 makes subsequent line shorter to write
		loc stub = substr("`rawlbl'",strpos("`rawlbl'",":")+1,length("`rawlbl'")-strpos("`rawlbl'",":"))
		loc clnlbl = strupper(substr("`stub'",1,1)) + strlower(substr("`stub'",2,length("`stub'")-1))
		la var shock_cope_`i'	"`clnlbl' to cope with shock"
		}
	g shock_cope_os = strtrim(lower(s10q3_os))
	la var shock_cope_os	"Specify other way to cope with shock"

	
	
	keep hhid round shock*
	isid hhid round shock_cd
	sort hhid round shock_cd
	
*	harmonize shock_code
run "${hfps_github}/label_shock_code.do"
la li shock_cd shock_code 
g shock_code=shock_cd, a(shock_cd)
recode shock_code 13=31
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta shock_cd shock_code
drop shock_cd

	isid hhid round shock_code
	sort hhid round shock_code
sa "${local_storage}/tmp_NGA_shocks.dta", replace 

*	move to household level for analysis
u  "${local_storage}/tmp_NGA_shocks.dta", clear

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
sa "${local_storage}/tmp_NGA_hh_shocks.dta", replace 


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
	10	"sorghum"
	13	"rice"
	30	"cassava"
	31	"sweet potato"
	42	"dry beans"	/*	this is just an assumption	*/
	72	"onions"
;
#d cr
end
********************************************************************************
}	/*	label_item end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d s5* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"	//	yes
d s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"	
d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r6_sect_5c.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	yes
d s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	not really
d s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r12_sect_5e_9a.dta"				//	no

d s5* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	yes, food prices
d s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
d s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices
d s5* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	fuel 




d using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	
d using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	

u	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	, clear
la li food_code s5hq5
u	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	, clear
la li food_code 
u	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	, clear
la li destination_code 
	*	ignoring this module for now
	*	food codes are consistent between the two rounds so this is simplified 

dir "${raw_lsms_nga}"
u "${raw_lsms_nga}/sect10b_harvestw4.dta", clear
la li LABA
	*	food_code coding is already consistent with the LSMS coding 
	*	simply change the label for easier comparisons to the panel 


#d ; 
clear; append using 
	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	
	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	
	, gen(round);
#d cr
la drop _append
la val round 
ta round

replace round=round+18

g item=food_code 
label_item
la val item item

tab2 round s5hq1 s5hq2 s5hq3, first m




	
	
decode item, gen(itemstr)
ta itemstr

g		item_avail = (s5hq1==1)
la var	item_avail	"Item is available for sale"

g		price = s5hq4
la var	price		"Price (LCU/standard unit)"

ta s5hq5 food_code, m
g		unitcost = s5hq6 
la var	unitcost	"Unit Cost (LCU/unit)"

*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
ta price round if item=="cassava":item
replace price=. if price>10000 & item=="cassava":item
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)

*	lacking a conversion factor, we will simply bring the raw unit through 
decode s5hq5, gen(unitstr)
la var unitstr		"Unit"

keep  hhid round item itemstr item_avail unitstr price unitcost 
order hhid round item itemstr item_avail unitstr price unitcost
isid  hhid round item
sort  hhid round item
sa "${local_storage}/tmp_NGA_price.dta", replace 
 




********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"



d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"






#d ; 
clear; append using
	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
, gen(round) keep(hhid  *s11b*);
#d cr

	la drop _append
	la val round 
	replace round=round+15
	ta round 	
	isid hhid round
	sort hhid round

	d using "${local_storage}/tmp_NGA_cover.dta"
	mer 1:1 hhid round using "${local_storage}/tmp_NGA_cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3

	ta s12q5
	ta round  if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	drop _m s12q5
	
	la li s11bq1 s11bq2 s11bq3 s11bq4 s11bq5 s11bq7 s11bq8 s11bq9
	

d s11*


ta select_s11 round,m
ds s11*, not(type string)
tabstat `r(varlist)', by(select_s11) s(n)


loc q1 s11bq1
ta `q1',m
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s11bq2
ta		`q2', m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s11bq3
ta		`q3', m
la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s11bq4
ta		`q4', m
la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s11bq5
ta		`q5', m
la li	`q5'
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

// loc q6	s11bq6
// ta		`q6', m
// la li	s9q6
// g		sntmnt_last12moPricepct = `q6'
// la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s11bq7
ta		`q7', m
la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s11bq8
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

loc q9	s11bq9
ta		`q9', m
la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s11bq10__
tabstat `weather'1 `weather'2 `weather'3 `weather'4 `weather'5, by(`q9') s(n)	
d `weather'1 `weather'2 `weather'3 `weather'4 `weather'5

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)5 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
la var sntmnt_weatherevent_cat5		"Storms"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${local_storage}/tmp_NGA_economic_sentiment.dta", replace 



********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************

*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"



d using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"






#d ; 
clear; append using
	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
, gen(round) keep(hhid  *s11c*);
#d cr

	la drop _append
	la val round 
	replace round=round+19
	ta round 	
	isid hhid round
	sort hhid round

	d using "${local_storage}/tmp_NGA_cover.dta"
	mer 1:1 hhid round using "${local_storage}/tmp_NGA_cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3

	ta s12q5
	ta round s11cq1 if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	drop _m s12q5
	
	la li s11cq1 s11cq2 s11cq3 s11cq4 s11cq5 s11cq6 s11cq7a s11cq7b s11cq7c s11cq7d s11cq7e s11cq7f s11cq7g s11cq7h s11cq7i
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s11cq1
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s11cq2
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s11cq3
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s11cq4
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s11cq5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s11cq6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

loc q7a s11cq7a
ta `q7a', m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = `q7a'==`i' if !mi(`q7a')
	la var ad_accident_cat`i'	"`: label (`q7a') `i''"
}


loc q7b s11cq7b
ta `q7b', m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = `q7b'==`i' if !mi(`q7b')
	la var ad_myown_cat`i'	"`: label (`q7b') `i''"
}

loc q7c s11cq7c
ta `q7c', m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = `q7c'==`i' if !mi(`q7c')
	la var ad_otherin_cat`i'	"`: label (`q7c') `i''"
}

loc q7d s11cq7d
ta `q7d', m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = `q7d'==`i' if !mi(`q7d')
	la var ad_selfdet_cat`i'	"`: label (`q7d') `i''"
}

loc q7e s11cq7e
ta `q7e', m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = `q7e'==`i' if !mi(`q7e')
	la var ad_noprotect_cat`i'	"`: label (`q7e') `i''"
}

loc q7f s11cq7f
ta `q7f', m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = `q7f'==`i' if !mi(`q7f')
	la var ad_otherout_cat`i'	"`: label (`q7f') `i''"
}

loc q7g s11cq7g
ta `q7g', m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = `q7g'==`i' if !mi(`q7g')
	la var ad_iprotect_cat`i'	"`: label (sub7g_pro) `i''"
}

loc q7h s11cq7h
ta `q7h', m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = `q7h'==`i' if !mi(`q7h')
	la var ad_luck_cat`i'	"`: label (`q7h') `i''"
}

loc q7i s11cq7i
ta `q7i', m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = `q7i'==`i' if !mi(`q7i')
	la var ad_comprotect_cat`i'	"`: label (`q7i') `i''"
}


	
	
	
keep hhid round sw_* ad_*
sa "${local_storage}/tmp_NGA_subjective_welfare.dta", replace 



********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************

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
ta s6q8 
g ag_anteharv_subj=s6q8
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
g ag_fertcost1_type = s5jq2  if !mi(s5jq2) & !mi(s5jq3) & !mi(s5jq3b) & !mi(s5jq4)
g ag_fertcost1_q 	= s5jq3  if !mi(s5jq2) & !mi(s5jq3) & !mi(s5jq3b) & !mi(s5jq4)
g ag_fertcost1_unit	= s5jq3b if !mi(s5jq2) & !mi(s5jq3) & !mi(s5jq3b) & !mi(s5jq4)
g ag_fertcost1_lcu	= s5jq4  if !mi(s5jq2) & !mi(s5jq3) & !mi(s5jq3b) & !mi(s5jq4)



g round=21
keep  hhid round ag_* cropcode
order hhid round 
isid  hhid round
sort  hhid round
sa "${local_storage}/tmp_NGA_agriculture.dta", replace 
 



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


