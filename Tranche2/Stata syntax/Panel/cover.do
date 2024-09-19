



d using "${tmp_hfps_bfa}/panel/cover.dta"
d using "${tmp_hfps_eth}/panel/cover.dta"
d using "${tmp_hfps_mwi}/panel/cover.dta"
d using "${tmp_hfps_nga}/panel/cover.dta"
d using "${tmp_hfps_tza}/panel/cover.dta"
d using "${tmp_hfps_uga}/panel/cover.dta"

u "${tmp_hfps_bfa}/panel/cover.dta", clear
u "${tmp_hfps_eth}/panel/cover.dta", clear
u "${tmp_hfps_mwi}/panel/cover.dta", clear
u "${tmp_hfps_nga}/panel/cover.dta", clear
u "${tmp_hfps_tza}/panel/cover.dta", clear
u "${tmp_hfps_uga}/panel/cover.dta", clear

d using "${tmp_hfps_bfa}/panel/pnl_cover.dta"
d using "${tmp_hfps_eth}/panel/pnl_cover.dta"
d using "${tmp_hfps_mwi}/panel/pnl_cover.dta"
d using "${tmp_hfps_nga}/panel/pnl_cover.dta"
d using "${tmp_hfps_tza}/panel/pnl_cover.dta"
d using "${tmp_hfps_uga}/panel/pnl_cover.dta"

u "${tmp_hfps_bfa}/panel/cover.dta", clear
u "${tmp_hfps_eth}/panel/cover.dta", clear
u "${tmp_hfps_mwi}/panel/cover.dta", clear
u "${tmp_hfps_nga}/panel/cover.dta", clear
u "${tmp_hfps_tza}/panel/cover.dta", clear
u "${tmp_hfps_uga}/panel/cover.dta", clear


foreach x in bfa eth mwi nga tza uga {
u "${tmp_hfps_`x'}/panel/pnl_cover.dta", clear
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

*	 in order to xtset, we need a country x hh identifier
	egen pnl_id = group(cc pnl_hhid)
	isid	pnl_id pnl_intdate	//	thus we know that the next condition will also be met
	isid	pnl_id pnl_intclock
	duplicates report pnl_id pnl_intwk	//	one duplicate week exists?
	
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
	tabstat pnl_cluster pnl_strata, by(cc) s(min max) format(%12.0g)	//	in Uganda, we have retained the code to enable stable combination across two sources 
	format pnl_cluster %12.0g
	
		/*
	mat clusters = J(1,6,.)
	mat stratum = J(1,6,.)
	forv i=1/6 {
		qui : levelsof pnl_cluster if cc==`i', loc(c`i')
		mat clusters[1,`i']==`: word count `c`i'''	
		qui : levelsof pnl_strata if cc==`i', loc(s`i')
		mat stratum[1,`i']==`: word count `s`i'''	
		}
	mat li clusters	//	we will make a country-stratified cluster identifier 
	mat li stratum	//	we will make a country-stratified cluster identifier 
	mat drop clusters
	mat drop stratum
		*/
		
	g pnl_cc_cluster	= cc * 10000
	g pnl_cc_strata		= cc * 100
	forv i=1/6 {
		qui : levelsof pnl_cluster if cc==`i', loc(c`i')
		loc mk=1
		foreach c of local c`i' {
			replace pnl_cc_cluster = pnl_cc_cluster+`mk' if cc==`i' & pnl_cluster==`c'
			loc ++mk
			}
		qui : levelsof pnl_strata if cc==`i', loc(s`i')
		loc mk=1
		foreach s of local s`i' {
			replace pnl_cc_strata = pnl_cc_strata+`mk' if cc==`i' & pnl_strata==`s'
			loc ++mk
			}
	}
	
	ta round cc if  mi(pnl_wgt)
	ta round cc if !mi(pnl_wgt)
	table round cc, stat(count pnl_wgt) stat(min pnl_wgt) stat(mean pnl_wgt) stat(max pnl_wgt) stat(sum pnl_wgt) nformat(%12.0fc) nototal
	
	svyset pnl_cc_cluster [pw=pnl_wgt], strata(pnl_cc_strata)
	
	
	

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${tmp_hfps_pnl}/cover.dta", replace
ex



u "${tmp_hfps_pnl}/cover.dta", clear

table (start_yr start_mo)(round), nototal
ta round cc
ta start_yr cc

#d ; 
loc bfaclr dkgreen; 
loc ethclr cranberry; 
loc mwiclr dkorange; 
loc ngaclr blue; 
loc tzaclr magenta; 
loc ugaclr chocolate; 
loc j=5; 
gr twoway 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 1, mc(`bfaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 1, mc(`ethclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 1, mc(`mwiclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 1, mc(`ngaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 1, mc(`tzaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 1, mc(`ugaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 2, mc(`bfaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 2, mc(`ethclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 2, mc(`mwiclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 2, mc(`ngaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 2, mc(`tzaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 2, mc(`ugaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 3, mc(`bfaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 3, mc(`ethclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 3, mc(`mwiclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 3, mc(`ngaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 3, mc(`tzaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 3, mc(`ugaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 4, mc(`bfaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 4, mc(`ethclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 4, mc(`mwiclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 4, mc(`ngaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 4, mc(`tzaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 4, mc(`ugaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 5, mc(`bfaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 5, mc(`ethclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 5, mc(`mwiclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 5, mc(`ngaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 5, mc(`tzaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 5, mc(`ugaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 6, mc(`bfaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 6, mc(`ethclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 6, mc(`mwiclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 6, mc(`ngaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 6, mc(`tzaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 6, mc(`ugaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 7, mc(`bfaclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 7, mc(`ethclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 7, mc(`mwiclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 7, mc(`ngaclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 7, mc(`tzaclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 7, mc(`ugaclr'*0.4 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 8, mc(`bfaclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 8, mc(`ethclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 8, mc(`mwiclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 8, mc(`ngaclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==5 & start_yr>2019 & round== 8, mc(`tzaclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 8, mc(`ugaclr'*0.3 ) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round== 9, mc(`bfaclr'*0.25) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round== 9, mc(`ethclr'*0.25) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round== 9, mc(`mwiclr'*0.25) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round== 9, mc(`ngaclr'*0.25) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round== 9, mc(`ugaclr'*0.25) jitter(`j') msiz(*0.1) ms(o))
 
	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==10, mc(`bfaclr'*0.2 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==10, mc(`ethclr'*0.2 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==10, mc(`mwiclr'*0.2 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==10, mc(`ngaclr'*0.2 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round==10, mc(`ugaclr'*0.2 ) jitter(`j') msiz(*0.1) ms(o))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==11, mc(`bfaclr'*0.1 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==11, mc(`ethclr'*0.1 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==11, mc(`mwiclr'*0.1 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==11, mc(`ngaclr'*0.1 ) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round==11, mc(`ugaclr'*0.1 ) jitter(`j') msiz(*0.1) ms(o))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==12, mc(`bfaclr'*0.05) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==12, mc(`ethclr'*0.05) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==12, mc(`mwiclr'*0.05) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==12, mc(`ngaclr'*0.05) jitter(`j') msiz(*0.1) ms(o))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round==12, mc(`ugaclr'*0.05) jitter(`j') msiz(*0.1) ms(o))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==13, mc(`bfaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==13, mc(`ethclr'*1.0 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==13, mc(`mwiclr'*1.0 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==13, mc(`ngaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==6 & start_yr>2019 & round==13, mc(`ugaclr'*1.0 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==14, mc(`bfaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==14, mc(`ethclr'*0.9 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==14, mc(`mwiclr'*0.9 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==14, mc(`ngaclr'*0.9 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==15, mc(`bfaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==15, mc(`ethclr'*0.8 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==15, mc(`mwiclr'*0.8 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==15, mc(`ngaclr'*0.8 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==16, mc(`bfaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==16, mc(`ethclr'*0.7 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==16, mc(`mwiclr'*0.7 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==16, mc(`ngaclr'*0.7 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==17, mc(`bfaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==2 & start_yr>2019 & round==17, mc(`ethclr'*0.6 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==17, mc(`mwiclr'*0.6 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==17, mc(`ngaclr'*0.6 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==1 & start_yr>2019 & round==18, mc(`bfaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==3 & start_yr>2019 & round==18, mc(`mwiclr'*0.5 ) jitter(`j') msiz(*0.1) ms(oh))
	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==18, mc(`ngaclr'*0.5 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==19, mc(`ngaclr'*0.4 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==20, mc(`ngaclr'*0.3 ) jitter(`j') msiz(*0.1) ms(oh))

	(scatter cc pnl_intdate if cc==4 & start_yr>2019 & round==21, mc(`ngaclr'*0.2 ) jitter(`j') msiz(*0.1) ms(oh))

	, ylabel(1(1)6, valuelabel nogrid) ymtick(0.5(1)6.5, grid glcolor(gs14) noticks) legend(off);
#d cr 





