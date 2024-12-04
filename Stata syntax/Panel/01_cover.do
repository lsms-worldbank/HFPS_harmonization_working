



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
	
compress
order cc round pnl_hhid pnl_id grand_id 
isid  cc round pnl_hhid 
sort  cc round pnl_hhid 
sa "${tmp_hfps_pnl}/cover.dta", replace
ex



u "${tmp_hfps_pnl}/cover.dta", clear

table (start_yr start_mo)(round), nototal
ta round cc
ta start_yr cc
recode round (1/12=1 "Phase 1")(13/max=2 "Phase 2"), gen(phase)
recode phase (1=2) if cc=="TZA":cc & round>8
table (phase round)cc, nototal

keep if start_yr>2019
#d ; 
loc bfaclr dkgreen; 
loc ethclr cranberry; 
loc mwiclr dkorange; 
loc ngaclr blue; 
loc tzaclr magenta; 
loc ugaclr chocolate; 
loc j=5; 
loc steps 1.0 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.25 0.2 0.1 0.05; 
forv i=1/`: word count `steps'' {; loc s`i' : word `i' of `steps'; }; 
loc options jitter(`j') msiz(*0.1) ms(o); 



gr twoway 
	(scatter cc pnl_intdate if cc==1 & round== 1, mc(`bfaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 1, mc(`ethclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 1, mc(`mwiclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 1, mc(`ngaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 1, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 1, mc(`ugaclr'*`s1' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 2, mc(`bfaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 2, mc(`ethclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 2, mc(`mwiclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 2, mc(`ngaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 2, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 2, mc(`ugaclr'*`s2' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 3, mc(`bfaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 3, mc(`ethclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 3, mc(`mwiclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 3, mc(`ngaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 3, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 3, mc(`ugaclr'*`s3' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 4, mc(`bfaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 4, mc(`ethclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 4, mc(`mwiclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 4, mc(`ngaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 4, mc(`tzaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 4, mc(`ugaclr'*`s4' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 5, mc(`bfaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 5, mc(`ethclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 5, mc(`mwiclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 5, mc(`ngaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 5, mc(`tzaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 5, mc(`ugaclr'*`s5' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 6, mc(`bfaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 6, mc(`ethclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 6, mc(`mwiclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 6, mc(`ngaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 6, mc(`tzaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 6, mc(`ugaclr'*`s6' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 7, mc(`bfaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 7, mc(`ethclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 7, mc(`mwiclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 7, mc(`ngaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 7, mc(`tzaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 7, mc(`ugaclr'*`s7' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 8, mc(`bfaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 8, mc(`ethclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 8, mc(`mwiclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 8, mc(`ngaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 8, mc(`tzaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 8, mc(`ugaclr'*`s8' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 9, mc(`bfaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 9, mc(`ethclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 9, mc(`mwiclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 9, mc(`ngaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 9, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 9, mc(`ugaclr'*`s9' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round==10, mc(`bfaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==2 & round==10, mc(`ethclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==3 & round==10, mc(`mwiclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==4 & round==10, mc(`ngaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==5 & round==10, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==10, mc(`ugaclr'*`s10') `options')

	(scatter cc pnl_intdate if cc==1 & round==11, mc(`bfaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==2 & round==11, mc(`ethclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==3 & round==11, mc(`mwiclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==4 & round==11, mc(`ngaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==5 & round==11, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==11, mc(`ugaclr'*`s12') `options')

	(scatter cc pnl_intdate if cc==1 & round==12, mc(`bfaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==2 & round==12, mc(`ethclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==3 & round==12, mc(`mwiclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==4 & round==12, mc(`ngaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==5 & round==12, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==12, mc(`ugaclr'*`s12') `options')

	(scatter cc pnl_intdate if cc==1 & round==13, mc(`bfaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==13, mc(`ethclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==13, mc(`mwiclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==13, mc(`ngaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==13, mc(`tzaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==13, mc(`ugaclr'*`s1' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==14, mc(`bfaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==14, mc(`ethclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==14, mc(`mwiclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==14, mc(`ngaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==14, mc(`tzaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==14, mc(`ugaclr'*`s2' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==15, mc(`bfaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==15, mc(`ethclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==15, mc(`mwiclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==15, mc(`ngaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==15, mc(`tzaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==15, mc(`ugaclr'*`s3' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==16, mc(`bfaclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==2 & round==16, mc(`ethclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==3 & round==16, mc(`mwiclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==4 & round==16, mc(`ngaclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==5 & round==16, mc(`tzaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==16, mc(`ugaclr'*`s4') `options')

	(scatter cc pnl_intdate if cc==1 & round==17, mc(`bfaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==17, mc(`ethclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==17, mc(`mwiclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==17, mc(`ngaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==17, mc(`tzaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==17, mc(`ugaclr'*`s5' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==18, mc(`bfaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==18, mc(`ethclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==18, mc(`mwiclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==18, mc(`ngaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==18, mc(`tzaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==18, mc(`ugaclr'*`s6' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==19, mc(`bfaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==19, mc(`ethclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==19, mc(`mwiclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==19, mc(`ngaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==19, mc(`tzaclr'*`s10' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==19, mc(`ugaclr'*`s7') `options')

	(scatter cc pnl_intdate if cc==1 & round==20, mc(`bfaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==20, mc(`ethclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==20, mc(`mwiclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==20, mc(`ngaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==20, mc(`tzaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==6 & round==20, mc(`ugaclr'*`s8' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==21, mc(`bfaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==21, mc(`ethclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==21, mc(`mwiclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==21, mc(`ngaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==21, mc(`tzaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==6 & round==21, mc(`ugaclr'*`s9' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==22, mc(`bfaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==2 & round==22, mc(`ethclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==3 & round==22, mc(`mwiclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==4 & round==22, mc(`ngaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==5 & round==22, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==22, mc(`ugaclr'*`s10') `options')

	(scatter cc pnl_intdate if cc==1 & round==23, mc(`bfaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==2 & round==23, mc(`ethclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==3 & round==23, mc(`mwiclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==4 & round==23, mc(`ngaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==5 & round==23, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==23, mc(`ugaclr'*`s11') `options')


	, ylabel(1(1)6, valuelabel nogrid) ymtick(0.5(1)6.5, grid glcolor(gs14) noticks) 
	legend(off);
#d cr 





