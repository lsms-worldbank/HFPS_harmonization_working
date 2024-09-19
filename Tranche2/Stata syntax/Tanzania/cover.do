



dir "${raw_hfps_tza}", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_1.dta"
d using	"${raw_hfps_tza}/r9_sect_1.dta"
d using	"${raw_hfps_tza}/r10_sect_1.dta"


d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
d using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"

*	which of these are time format
u	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
// u	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
// ds, has(format %t*)	//	none
// ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10
u	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta", clear
ds, has(format %t*)	//	none
ds, has(varl *time* *Time* *TIME*) detail	//	Sec2_StartTime s10q10



u	"${raw_hfps_tza}/r1_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r2_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r3_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r4_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r5_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r6_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r7_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r8_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r9_sect_1.dta", clear
ds, has(format %t*)	//	none
u	"${raw_hfps_tza}/r10_sect_1.dta", clear
ds, has(format %t*)	//	none

















*	household level detail from actual completed interview (incl. weights)


#d ; 
clear; append using
	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"
	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"
	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"
	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"
	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"
	,  gen(round) force; /* force necessary because of simple ad hoc fix to r9 dataset in v07 of public release */
keep round-interviewer_id wt_round1 wt_round2 
	wt_round3  wt_panel_round3  
	wt_round4  wt_panel_round4  
	wt_round5  wt_panel_round5  
	wt_round6  wt_panel_round6  
	wt_round7  wt_panel_round7  
	wt_round8  wt_panel_round8  
	wt_round9  wt_panel_round9  
	wt_round10 wt_panel_round10 
	s10q01 s10q05 s10q06 s10q06_os s10q10
	;
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)	//	only one phase for the TZ data
	isid hhid round
	sort hhid round
	order wt_*, a(frame)
	
	d
	tabstat wt_*, by(round) s(sum) format(%12.3gc)
	ds wt_round*
	egen wgt = rowfirst(`r(varlist)')
	tabstat wt_*, by(round) s(n) format(%12.3gc)
	ds wt_panel_round*
	egen wgt_panel = rowfirst(wt_round1 wt_round2 `r(varlist)')
	drop wt_*
	order wgt wgt_panel, a(t0_ea)
	la var wgt			"Sampling weight"
	la var wgt_panel	"Panel sampling weight"
	
	g wtd = !mi(wgt)
	ta round wtd
	g pwtd = !mi(wgt_panel)
	ta round pwtd
	drop wtd pwtd
	
	
	ta t0_region urban_rural, missing	//	these are the design strata from the HBS and NPS frames (tzhfwms_bid_september_2023.pdf, footnote 1 p. 7.)
	
	su, sep(0)
	
*	dates 
	li Sec2 in 1/10
	convert_date_time Sec2 s10q10
	d Sec2 s10q10
	compare Sec2 s10q10
	g  intdur = clockdiff(Sec2,s10q10,"second")/60
	su intdur,d	//	wow, many major outliers
	bys round : egen medianday1 = median(dofc(Sec2))
	bys round : egen medianday2 = median(dofc(s10q10))
	tabstat medianday1 medianday2, by(round) format(%td)
	g keep1 = Sec2 if inrange(dofc(Sec2),medianday1-30,medianday1+30)
	g keep2 = s10q10 if inrange(dofc(s10q10),medianday2-30,medianday2+30)
	egen pnl_intclock = rowfirst(keep1 keep2)
	tabstat Sec2 s10q10 if mi(pnl_intclock), by(round) format(%tc)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday2) if mi(pnl_intclock)
	
	
	format pnl_intclock %tc
	drop Sec2 s10q10 intdur-keep2
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	g long start_yr= Clockpart(pnl_intclock, "year")
	g long start_mo= Clockpart(pnl_intclock, "month")
	g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal
duplicates report	hhid pnl_intdate	//	fixed 
isid hhid pnl_intdate


	/*
li interviewer_id Sec2 if round==6 & start_yr==2017
ta interviewer_id round
g odd = (start_yr==2017) if round==6 & !mi(Sec2)
ta interviewer_id odd	//	three interviewers only

sort Sec2
li hhid Sec2 if round==6 & interviewer_id==17 & !mi(Sec2), sepby(start_mo)

bys interviewer_id round start_yr : egen mindate = min(Sec2)
bys interviewer_id round start_yr : egen maxdate = max(Sec2)
bys interviewer_id round (start_yr) : egen minmindate = min(mindate)
bys interviewer_id round (start_yr) : egen maxmindate = max(mindate)
g interview_date = Sec2 if odd!=1
replace interview_date = Sec2 + (maxmindate-minmindate) if odd==1 



	g long start_yr2= Clockpart(interview_date, "year")
	g long start_mo2= Clockpart(interview_date, "month")
	g long start_dy2= Clockpart(interview_date, "day")
	
table (start_yr2 start_mo2) round, nototal	//	not fixed, ignoring for now
	*/

	
isid hhid round
sort hhid round

sa "${tmp_hfps_tza}/panel/cover.dta", replace 


*	modifications for construction of grand panel 
u "${tmp_hfps_tza}/panel/cover.dta", clear


egen pnl_hhid = group(hhid)
li t0_region t0_district t0_ward t0_village t0_ea in 1/10
li t0_region t0_district t0_ward t0_village t0_ea in 1/10, nol

egen pnl_admin1 = group(t0_region)
egen pnl_admin2 = group(t0_region t0_district)
egen pnl_admin3 = group(t0_region t0_district t0_ward)

ta urban_rural, m
g pnl_urban = (urban_rural==2)
ta t0_region urban_rural,m
egen pnl_strata = group(t0_region urban_rural)
egen pnl_cluster = group(clusterID)
g pnl_wgt = wgt 
sa "${tmp_hfps_tza}/panel/pnl_cover.dta", replace 


