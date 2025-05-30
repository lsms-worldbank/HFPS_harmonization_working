

dir "${raw_hfps_mwi}", w
label_inventory `"${raw_hfps_mwi}"', pre(`"sect1_interview_info_r"') suf(`".dta"')	/*
*/	vallab 	/*vardetail varname diagnostic retain*/  
label_inventory `"${raw_hfps_mwi}"', pre(`"sect1_interview_info_r"') suf(`".dta"')	/*
*/	varname vallab	/*vardetail vallab diagnostic retain*/  

d using	"${raw_hfps_mwi}/sect1_interview_info_r1.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r2.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r3.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r4.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r5.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r6.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r7.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r8.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r9.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r10.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r11.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r12.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r13.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r14.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r15.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r16.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r17.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r18.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r19.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r20.dta"
d using	"${raw_hfps_mwi}/sect1_interview_info_r21.dta"

d using	"${raw_hfps_mwi}/sect12_interview_result_r1.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r2.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r3.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r4.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r5.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r6.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r7.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r8.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r9.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r10.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r11.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r12.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r13.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r14.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r15.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r16.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r17.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r18.dta"
d using	"${raw_hfps_mwi}/sect12_interview_result_r19.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r20.dta"
// d using	"${raw_hfps_mwi}/sect12_interview_result_r21.dta"

d using	"${raw_hfps_mwi}/sect2_household_roster_r1.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r2.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r3.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r4.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r5.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r6.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r7.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r8.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r9.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r10.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r11.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r12.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r13.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r14.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r15.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r16.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r17.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r18.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r19.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r20.dta"
d using	"${raw_hfps_mwi}/sect2_household_roster_r21.dta"

d using	"${raw_hfps_mwi}/secta_cover_page_r1.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r2.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r3.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r4.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r5.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r6.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r7.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r8.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r9.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r10.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r11.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r12.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r13.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r14.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r15.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r16.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r17.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r18.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r19.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r20.dta"
d using	"${raw_hfps_mwi}/secta_cover_page_r21.dta"


*	get round zero identification information to augment this data
dir "${raw_lsms_mwi}"
u "${raw_lsms_mwi}/hh_mod_a_filt_19.dta", clear
inspect region district ta_code reside 

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect2_household_roster_r1.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r2.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r3.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r4.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r5.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r6.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r7.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r8.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r9.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r10.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r11.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r12.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r13.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r14.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r15.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r16.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r17.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r18.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r19.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r20.dta"
	"${raw_hfps_mwi}/sect2_household_roster_r21.dta"
, gen(round);
#d cr 
// isid y4_hhid round pid
inspect pid PID
replace pid=PID if mi(pid)
isid y4_hhid round pid
keep y4_hhid round pid s2q5 s2q6
tempfile sexage
sa		`sexage'

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect1_interview_info_r1.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r2.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r3.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r4.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r5.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r6.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r7.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r8.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r9.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r10.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r11.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r12.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r13.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r14.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r15.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r16.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r17.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r18.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r19.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r20.dta"
	"${raw_hfps_mwi}/sect1_interview_info_r21.dta"
, gen(round);
#d cr
bys y4_hhid round (attempts__id) : keep if _n==_N
isid y4_hhid round


keep y4_hhid round s1q2 s1q9
g pid=s1q9
mer m:1 y4_hhid round pid using `sexage', keep(1 3) nogen

tempfile resp_date
sa		`resp_date'

#d ; 
clear; append using
	"${raw_hfps_mwi}/secta_cover_page_r1.dta"
	"${raw_hfps_mwi}/secta_cover_page_r2.dta"
	"${raw_hfps_mwi}/secta_cover_page_r3.dta"
	"${raw_hfps_mwi}/secta_cover_page_r4.dta"
	"${raw_hfps_mwi}/secta_cover_page_r5.dta"
	"${raw_hfps_mwi}/secta_cover_page_r6.dta"
	"${raw_hfps_mwi}/secta_cover_page_r7.dta"
	"${raw_hfps_mwi}/secta_cover_page_r8.dta"
	"${raw_hfps_mwi}/secta_cover_page_r9.dta"
	"${raw_hfps_mwi}/secta_cover_page_r10.dta"
	"${raw_hfps_mwi}/secta_cover_page_r11.dta"
	"${raw_hfps_mwi}/secta_cover_page_r12.dta"
	"${raw_hfps_mwi}/secta_cover_page_r13.dta"
	"${raw_hfps_mwi}/secta_cover_page_r14.dta"
	"${raw_hfps_mwi}/secta_cover_page_r15.dta"
	"${raw_hfps_mwi}/secta_cover_page_r16.dta"
	"${raw_hfps_mwi}/secta_cover_page_r17.dta"
	"${raw_hfps_mwi}/secta_cover_page_r18.dta"
	"${raw_hfps_mwi}/secta_cover_page_r19.dta"
	"${raw_hfps_mwi}/secta_cover_page_r20.dta"
	"${raw_hfps_mwi}/secta_cover_page_r21.dta"
, gen(round);
#d cr
isid y4_hhid round
mer 1:1 y4_hhid round using `resp_date', gen(_m)
ta result _m
ta round if result!=1 & _m==3
su wt_p2round3 if result!=1 & _m==3	//	keep these 
su wt_* if _m==1
keep if _m==3
drop _m 
la drop _append
la val round 
ta round 
	g phase=cond(round<=12,1,2), b(round)	
isid y4_hhid round
	la var round	"Survey round"
	la var phase	"Survey phase"

*	weights
d wt_*	// one weight per round 
tabstat wt_*, by(round) s(sum) format(%12.3gc)
egen wgt = rowfirst(wt_*)
drop wt_*
la var wgt	"Sampling round"

*	dates
ren pid temppid
cap : ds p??
assert _rc!=0

d interviewDate s1q2
li interviewDate s1q2 in 1/10
	convert_date_time interviewDate s1q2
	ta interviewDatermdr
	g fmt1 = cofd(date(interviewDatermdr,"YMD")), a(interviewDate)
	ta interviewDatermdr if mi(fmt1)	//	perfect
	egen pnl_intclock = rowfirst(interviewDate fmt1 s1q2)
	li round interviewDate interviewDatermdr fmt1 s1q2 wgt if mi(pnl_intclock)	// 	one case
		*	make an assumption based on this household's typial position in previous rounds
		cap : assert !mi(pnl_intclock)
		if _rc!=0 {
		bys round : egen min=min(pnl_intclock)
		by  round : egen max=max(pnl_intclock)
		foreach p of numlist 10(10)90 {
			by  round : egen p`p'=pctile(pnl_intclock), p(`p')
		}
		g clock_pctile = . 
		replace clock_pctile = 1 if pnl_intclock>=min & pnl_intclock<p10
		replace clock_pctile = 2 if pnl_intclock>=p10 & pnl_intclock<p20
		replace clock_pctile = 3 if pnl_intclock>=p20 & pnl_intclock<p30
		replace clock_pctile = 4 if pnl_intclock>=p30 & pnl_intclock<p40
		replace clock_pctile = 5 if pnl_intclock>=p40 & pnl_intclock<p50
		replace clock_pctile = 6 if pnl_intclock>=p50 & pnl_intclock<p60
		replace clock_pctile = 7 if pnl_intclock>=p60 & pnl_intclock<p70
		replace clock_pctile = 8 if pnl_intclock>=p70 & pnl_intclock<p80
		replace clock_pctile = 9 if pnl_intclock>=p80 & pnl_intclock<p90
		replace clock_pctile =10 if pnl_intclock>=p90 & pnl_intclock<=max
		
		bys y4_hhid (round) : replace clock_pctile=clock_pctile[_n-1] if mi(clock_pctile)
 		bys round clock_pctile : egen fill = median(pnl_intclock)
		replace pnl_intclock = fill if mi(pnl_intclock)
		drop min max p?? clock_pctile fill 
		}
		assert !mi(pnl_intclock)
		
	format pnl_intclock %tc
	drop interviewDate interviewDatermdr fmt1 s1q2
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	
ren temppid pid

g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal


*	admin details (compare with current data captured in the form here )
mer m:1 y4_hhid using "${raw_lsms_mwi}/hh_mod_a_filt_19.dta",  keepus(region district ta_code reside ea_id) gen(_m)
ta round if _m==1	//	check how they handled this in the harmonized data as it currently stands 
keep if _m != 2
drop _m
ren (region district ta_code reside)(r0_region r0_district r0_ta_code r0_reside)
compare r0_region hh_a00
compare r0_district hh_a01
compare r0_reside urb_rural
ta r0_reside urb_rural

isid y4_hhid round
sort y4_hhid round

sa "${tmp_hfps_mwi}/cover.dta", replace 

d using "${raw_lsms_mwi}/hh_mod_a_filt_19.dta"
*	modifications for construction of grand panel 
u  "${tmp_hfps_mwi}/cover.dta", clear


egen pnl_hhid = group(y4_hhid)
egen pnl_admin1 = group(hh_a00)
egen pnl_admin2 = group(hh_a01)
egen pnl_admin3 = group(r0_ta_code)

g pnl_urban = urb_rural=="URBAN":hh_a03b
g pnl_strata = urb_rural
egen pnl_cluster = group(ea_id)
g pnl_wgt = wgt 

sa "${tmp_hfps_mwi}/pnl_cover.dta", replace 


svyset pnl_cluster [pw=pnl_wgt], strata(pnl_strata)









