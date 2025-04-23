



********************************************************************************
********************************************************************************

**#	Commander do-file for graphics that 

********************************************************************************
********************************************************************************
dir "${tmp_hfps_pnl}"
d using "${tmp_hfps_pnl}/cover.dta"
dir "${final_hfps_pnl}"
u "${final_hfps_pnl}/analysis_dataset.dta", clear

isid grand_id

*	no obvious graphics for this one aside from the timeline 

ta pnl_intwk cc



u "${final_hfps_pnl}/analysis_dataset.dta", clear
svyset
loc svy_keepers `r(su1)' `r(wvar)' `r(strata1)'
loc svycall "`r(settings)'"
d `svy_keepers'
dis "`svycall'"
u "${final_hfps_pnl}/individual.dta", clear
mer m:1 cc round pnl_hhid using "${final_hfps_pnl}/analysis_dataset.dta", keepus(`svy_keepers')
svyset `svycall'

table (cc round) _merge, nototal	//	_m=2 are primarily in Uganda round 9
keep if _merge==3



