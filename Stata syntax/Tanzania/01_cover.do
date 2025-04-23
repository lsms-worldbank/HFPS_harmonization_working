

loc inventory=0
if `inventory'==1	{	/*	data inventory	*/

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
d using	"${raw_hfps_tza}/r11_sect_1.dta"


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
d using	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"

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
u	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta", clear
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
u	"${raw_hfps_tza}/r11_sect_1.dta", clear
ds, has(format %t*)	//	none



/*	variable label inventory	*/
label_inventory `"${raw_hfps_tza}"', pre(`"r"') suf(`"_10.dta"')	/*
*/	varname 	/* vallab vardetail diagnostic retain*/  

label_inventory "${raw_hfps_tza}", pre("r") suf("*_10.dta") vardetail retain
li name type vallab varlab rounds matches if strpos(name,"t0_")>0, sep(0)
	*->	value label is present for region and district throughout
	*	only value label for village/ward/ea in 

*	need to manually implement value label inventory in this case 
u	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r1
sa		`r1'
u	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r2
sa		`r2'
u	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r3
sa		`r3'
u	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r4
sa		`r4'
u	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r5
sa		`r5'
u	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r6
sa		`r6'
u	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r7
sa		`r7'
u	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r8
sa		`r8'
// u	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
// ds t0_*, detail has(vallab)
// uselabel `r(varlist)'	//	variable label is not found somehow
// la dir	//	value labels are not present
// tempfile r9
// sa		`r9'
u	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r10
sa		`r10'
u	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta", clear
ds t0_*, detail has(vallab)
uselabel `r(varlist)'
tempfile r11
sa		`r11'


u `r1', clear
foreach r of numlist 1/8 10 11 {
mer 1:1 lname value label using `r`r'', gen(_r`r')
recode _r`r' (2 3=`r')(else=.)
}
la val _r* .
egen rounds = group(_r*), label
ta lname rounds,m	//	what is happening! The labels are not carried through
// li lname value label rounds, sepby(lname)
li lname value label if !mi(rounds), sepby(lname)


}		/*	end data inventory	*/




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
	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"
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
	wt_round11 wt_panel_round11 
	s10q01 s10q05 s10q06 s10q06_os s10q10
	;
#d cr

	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=6,1,2), b(round)	//	only one phase for the TZ data
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
	
	*	interrogate spatial dynamics
	ds t0_*	//	 as in the raw data
	foreach x in ea village ward district region {
		cap : drop `x'
		la copy t0_`x' `x', replace
		clonevar `x'=t0_`x'	//	a play copy to test with
		la val `x' `x'
	}
	*	nesting - do the lower level codes nest within a single higher level one?
	loc spatial_vars ea village ward district region 
	
	bys ea : egen min=min(village)
	bys ea : egen max=max(village)
	compare min max	//	nope, nesting breaks in most cases at EA level
	drop min max
	
	bys village : egen min=min(ward)
	bys village : egen max=max(ward)
	compare min max	//	large majority not nested
	drop min max
	
	bys ward : egen min=min(district)
	bys ward : egen max=max(district)
	compare min max	//	again majority not nested
	drop min max
	
	bys district : egen min=min(region)
	bys district : egen max=max(region)
	compare min max	//	here all are nested at least
	drop min max
	
	ta ward,m
	ta village,m

	*	extent of change - need a reshape wide to make this syntax simpler
	preserve
	keep if inlist(s10q01,1,2)
	keep hhid round ea village ward district region 
	ren (ea village ward district region)(ea vg wd dt rg)
	reshape wide ea vg wd dt rg, i(hhid) j(round)
	foreach x in rg dt wd vg ea {
	egen min_`x' = rowmin(`x'*)
	egen max_`x' = rowmax(`x'*)
	compare min_`x' max_`x'
	}
	*	district and region are static, but below that the strong majority move across time
	restore
	
	*	is the code stable across rounds? 
	bys hhid (round) : g wardz = (ward!=ward[_n-1])
	ta round wardz	//	static between rounds 2-4 - these look much more like a data artifact than true change
		/*	
		investigation of the lables in the preamble of this do-file has shown 
		that district and region are stable but below that codes are not 
		definitively stable across rounds, so we cannot rule out a simple 
		coding change leading to all of these changes rather than actual spatial
		shifts. 
		*/
	ta round if inlist(s10q01,1,2)
	*	verify that there is a round 1 observation for every household 
	bys hhid : egen zzz = min(round * cond(inlist(s10q01,1,2),1,.))
	ta round zzz,m
	assert inlist(zzz,1,.)
	drop zzz
	
	/*	
		we will make the t0_* a true baseline version. Since we lack the raw 
		baseline data for half of the sample frame, we will simply take the 
		round 1 data to be accurate and apply it to all subsequent observations. 
		
		Could attempt to back out a linkage between the baseline and the values 
		that were entered, but we will not spend that effort without clearer 
		indication that this is necessary. 
	*/
	foreach x of varlist ea village ward district region {
		tempvar r0
		g `r0' = `x' if round==1
		bys hhid (round) : replace `r0' = `r0'[_n-1] if mi(`r0')
		li hhid round `x' `r0' in 1/20, sepby(hhid)
		replace t0_`x' = `r0'
		drop `r0'
	}


	
*	dates 
	li Sec2_StartTime in 1/10
	convert_date_time Sec2_StartTime s10q10
	d Sec2_StartTime s10q10
	compare Sec2_StartTime s10q10
	g  intdur = clockdiff(Sec2_StartTime,s10q10,"second")/60
	su intdur,d	//	wow, many major outliers
	bys round : egen medianday1 = median(dofc(Sec2_StartTime))
	bys round : egen medianday2 = median(dofc(s10q10))
	tabstat medianday1 medianday2, by(round) format(%td)
	g keep1 = Sec2_StartTime if inrange(dofc(Sec2_StartTime),medianday1-30,medianday1+30)
	g keep2 = s10q10 if inrange(dofc(s10q10),medianday2-30,medianday2+30)
	egen pnl_intclock = rowfirst(keep1 keep2)
	tabstat Sec2_StartTime s10q10 if mi(pnl_intclock), by(round) format(%tc)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday2) if mi(pnl_intclock)
	
	
	format pnl_intclock %tc
	drop Sec2_StartTime s10q10 intdur-keep2
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td
	g long start_yr= Clockpart(pnl_intclock, "year")
	g long start_mo= Clockpart(pnl_intclock, "month")
	g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal
duplicates report	hhid pnl_intdate	//	fixed 
isid hhid pnl_intdate


	/*
li interviewer_id Sec2_StartTime if round==6 & start_yr==2017
ta interviewer_id round
g odd = (start_yr==2017) if round==6 & !mi(Sec2_StartTime)
ta interviewer_id odd	//	three interviewers only

sort Sec2_StartTime
li hhid Sec2_StartTime if round==6 & interviewer_id==17 & !mi(Sec2_StartTime), sepby(start_mo)

bys interviewer_id round start_yr : egen mindate = min(Sec2_StartTime)
bys interviewer_id round start_yr : egen maxdate = max(Sec2_StartTime)
bys interviewer_id round (start_yr) : egen minmindate = min(mindate)
bys interviewer_id round (start_yr) : egen maxmindate = max(mindate)
g interview_date = Sec2_StartTime if odd!=1
replace interview_date = Sec2_StartTime + (maxmindate-minmindate) if odd==1 



	g long start_yr2= Clockpart(interview_date, "year")
	g long start_mo2= Clockpart(interview_date, "month")
	g long start_dy2= Clockpart(interview_date, "day")
	
table (start_yr2 start_mo2) round, nototal	//	not fixed, ignoring for now
	*/

	
isid hhid round
sort hhid round

sa "${tmp_hfps_tza}/cover.dta", replace 


*	modifications for construction of grand panel 
u "${tmp_hfps_tza}/cover.dta", clear


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
sa "${tmp_hfps_tza}/pnl_cover.dta", replace 


