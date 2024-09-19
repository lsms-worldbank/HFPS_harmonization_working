
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
	bys round : egen medianday1 = median(dofc(s1q2))
	bys round : egen medianday2 = median(dofc(s12q14))
	tabstat medianday?, by(round) format(%td)
	g keep1 = s1q2		if inrange(dofc(s1q2)  ,medianday1-30,medianday1+30)
	g keep2 = s12q14	if inrange(dofc(s12q14),medianday2-30,medianday2+30)
	egen pnl_intclock = rowfirst(keep1 keep2)
	tabstat s1q2 s12q14 if mi(pnl_intclock), by(round) format(%tc)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday2) if mi(pnl_intclock)
	duplicates report hhid pnl_intclock
	
	format pnl_intclock %tc
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	duplicates report hhid pnl_intdate
	duplicates tag    hhid pnl_intdate, gen(tag)
	li hhid pnl_intdate round s1q2 s12q14 medianday? keep? if tag>0
	
	drop s1q2 s12q14 medianday? keep? tag

g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal

isid hhid round
sort hhid round

sa "${tmp_hfps_nga}/panel/cover.dta", replace 


*	modifications for construction of grand panel 
u "${tmp_hfps_nga}/panel/cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_strata = zone
assert !mi(ea)
egen pnl_cluster = group(ea)
g pnl_wgt = wgt 

sa "${tmp_hfps_nga}/panel/pnl_cover.dta", replace 







