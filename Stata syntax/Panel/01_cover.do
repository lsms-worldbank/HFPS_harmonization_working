



d using "${tmp_hfps_bfa}/cover.dta"
d using "${tmp_hfps_eth}/cover.dta"
d using "${tmp_hfps_mwi}/cover.dta"
d using "${tmp_hfps_nga}/cover.dta"
d using "${tmp_hfps_tza}/cover.dta"
d using "${tmp_hfps_uga}/cover.dta"

u "${tmp_hfps_bfa}/cover.dta", clear
u "${tmp_hfps_eth}/cover.dta", clear
u "${tmp_hfps_mwi}/cover.dta", clear
u "${tmp_hfps_nga}/cover.dta", clear
u "${tmp_hfps_tza}/cover.dta", clear
u "${tmp_hfps_uga}/cover.dta", clear

d using "${tmp_hfps_bfa}/pnl_cover.dta"
d using "${tmp_hfps_eth}/pnl_cover.dta"
d using "${tmp_hfps_mwi}/pnl_cover.dta"
d using "${tmp_hfps_nga}/pnl_cover.dta"
d using "${tmp_hfps_tza}/pnl_cover.dta"
d using "${tmp_hfps_uga}/pnl_cover.dta"

u "${tmp_hfps_bfa}/cover.dta", clear
u "${tmp_hfps_eth}/cover.dta", clear
u "${tmp_hfps_mwi}/cover.dta", clear
u "${tmp_hfps_nga}/cover.dta", clear
u "${tmp_hfps_tza}/cover.dta", clear
u "${tmp_hfps_uga}/cover.dta", clear


foreach x in bfa eth mwi nga tza uga {
u "${tmp_hfps_`x'}/pnl_cover.dta", clear
d, varlist
loc hhid : word 1 of `r(sortlist)'
g `x'_hhid = `hhid'
la var `x'_hhid	"`hhid' = `X' HH identifier"
keep round `x'_hhid pnl_* start_*

tempfile `x'
sa		``x''
}
clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var	pnl_intclock	"Time and date of survey"
la var	pnl_intdate		"Date of survey"
g		pnl_intmo=mofd(pnl_intdate), a(pnl_intdate)
format	pnl_intmo %tmMon_CCYY
la var	pnl_intmo		"Month and year of survey"

duplicates report pnl_hhid pnl_intmo	//	duplicate months exist, not much to do here 
// drop pnl_intmo
g		pnl_intwk=wofd(pnl_intdate), a(pnl_intdate)
format pnl_intwk %tw
format	pnl_intwk %twCCYY_!w!e!e!k_ww
ta pnl_intwk
la var	pnl_intwk		"Year and week of survey"
la var	start_yr		"Year of survey"
la var	start_mo		"Month of survey"
la var	start_dy		"Day of survey"

la var pnl_hhid			"Household ID Code"
la var pnl_admin1		"Admin unit 1"
la var pnl_admin2		"Admin unit 2"
la var pnl_admin3		"Admin unit 3"
la var pnl_urban		"Urban=1"
la var pnl_wgt			"Sample weight"

	*	verification prior to constructing some additional id vars for various applications
	su cc
	assert r(max) < 10
	su pnl_hhid
	assert r(max) < 10000
	su round
	assert r(max)<100
	
	recode round (1/12=1 "Phase 1")(13/max=2 "Phase 2"), gen(phase)
	recode phase (1=2) if cc=="BFA":cc & round>11
	recode phase (1=2) if cc=="TZA":cc & round>8
	recode phase (1=2) if cc=="UGA":cc & round>7
	recode phase (2=3) if cc=="UGA":cc & round>12
	order  phase, a(round)
	la var phase	"Data collection phase"

	*	country x hh identifier (used for xtset)
	g pnl_id = (cc * 100000) + pnl_hhid
	la var pnl_id	"Country x household identifier"
	isid pnl_id round
	
	*	country x round x hh identifier 
	g grand_id = (cc * 1000) + (round * 1)
	format grand_id %20.0fc
	ta grand_id
	replace grand_id = (grand_id * 100000) + pnl_hhid
	la var grand_id	"Country x round x household identifier"
	isid grand_id
	
	
*	 in order to xtset, we need a time identifier. 
*	round will not suffice since the time periods between rounds are not fixed, nor comparable across country
	isid	pnl_id pnl_intdate	//	thus we know that the next condition will also be met
	isid	pnl_id pnl_intclock
	duplicates report pnl_id pnl_intwk	//	one duplicate week exists
	
	duplicates tag pnl_id pnl_intwk, gen(tag)
	li cc round pnl_intwk pnl_intmo pnl_intclock cc if tag>0	//	one case
	li eth_hhid if tag>0
	li cc round pnl_intwk pnl_intmo pnl_intclock cc if eth_hhid=="020301088800303109"
	replace pnl_intwk = pnl_intwk+1 if tag>0 & eth_hhid=="020301088800303109" & cc=="ETH":cc & round==7
	
	isid pnl_id pnl_intwk
	drop tag pnl_intmo
	
*	set survey structures
	xtset pnl_id pnl_intwk, weekly
	
	
	*	to svyset, we need to differentiate the clusters by cc and the strata by cc 
	la var pnl_cluster	"Primary sampling unit"
	la var pnl_strata	"Survey strata"
	tabstat pnl_cluster pnl_strata, by(cc) s(min max) format(%12.0g)	//	in Uganda, we have retained the code to enable stable combination across two sources 
	format pnl_cluster %12.0g

	g pnl_cc_cluster	= cc * 10000
	g pnl_cc_strata		= cc * 100
	forv i=1/6 {
		dis as yellow "begin `: label (cc) `i''"
		dis as yellow "clusters"
		qui : levelsof pnl_cluster if cc==`i', loc(c`i')
		loc mk=1
		foreach c of local c`i' {
			qui : replace pnl_cc_cluster = pnl_cc_cluster+`mk' if cc==`i' & pnl_cluster==`c'
			dis as green `mk', _cont
			loc ++mk
			}
		dis as yellow "strata"
		qui : levelsof pnl_strata if cc==`i', loc(s`i')
		loc mk=1
		foreach s of local s`i' {
			qui : replace pnl_cc_strata = pnl_cc_strata+`mk' if cc==`i' & pnl_strata==`s'
			dis as green `mk', _cont
			loc ++mk
			}
		dis as yellow "end `: label (cc) `i''"
	}
		duplicates report cc pnl_cluster
		loc raw=r(unique_value)
		duplicates report pnl_cc_cluster
		assert `r(unique_value)'==`raw'
	
	ta round cc if  mi(pnl_wgt)
	ta round cc if !mi(pnl_wgt)
	table round cc, stat(count pnl_wgt) stat(min pnl_wgt) stat(mean pnl_wgt) stat(max pnl_wgt) stat(sum pnl_wgt) nformat(%12.0fc) nototal
	
	svyset pnl_cc_cluster [pw=pnl_wgt], strata(pnl_cc_strata)
	
	la var pnl_cc_cluster	"Country x primary sampling unit"
	la var pnl_cc_strata	"Country x survey strata"
	order pnl_cc_cluster pnl_cc_strata, a(pnl_wgt)
	
	*	make a string variable suitable for merge to the baseline datasets
	ds bfa_hhid eth_hhid mwi_hhid nga_hhid tza_hhid uga_hhid, has(type string) detail
	ds bfa_hhid eth_hhid mwi_hhid nga_hhid tza_hhid uga_hhid, not(type string) detail
	tostring `r(varlist)', replace
	foreach x of varlist bfa_hhid eth_hhid mwi_hhid nga_hhid tza_hhid uga_hhid {
	replace `x' = subinstr(`x',".","",1) if length(`x')==1
	}
	
	egen str32 pnl_hhstr = rowfirst(bfa_hhid eth_hhid mwi_hhid nga_hhid tza_hhid uga_hhid)
	la var pnl_hhstr	"household identifier for merge with baseline data"
	
compress
order cc round pnl_hhid pnl_hhstr pnl_id grand_id 
isid  cc round pnl_hhid 
sort  cc round pnl_hhid 
sa "${tmp_hfps_pnl}/cover.dta", replace
u  "${tmp_hfps_pnl}/cover.dta", clear
ex





