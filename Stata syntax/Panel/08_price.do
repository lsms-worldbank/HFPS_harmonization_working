
d using "${tmp_hfps_bfa}/price.dta"
d using "${tmp_hfps_eth}/price.dta"
d using "${tmp_hfps_mwi}/price.dta"
d using "${tmp_hfps_nga}/price.dta"
d using "${tmp_hfps_tza}/price.dta"
d using "${tmp_hfps_uga}/price.dta"

u "${tmp_hfps_bfa}/cover.dta", clear
u "${tmp_hfps_eth}/cover.dta", clear
u "${tmp_hfps_mwi}/cover.dta", clear
u "${tmp_hfps_nga}/cover.dta", clear
u "${tmp_hfps_tza}/cover.dta", clear
u "${tmp_hfps_uga}/cover.dta", clear





*	make price panel

u "${tmp_hfps_bfa}/price.dta", clear
mer m:1 hhid round using "${tmp_hfps_bfa}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop hhid item
tempfile bfa
sa		`bfa'


u 									"${tmp_hfps_eth}/price.dta", clear
mer m:1 household_id round using	"${tmp_hfps_eth}/pnl_cover.dta", keepus(pnl_hhid) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop household_id item
tempfile eth
sa		`eth'

u 							"${tmp_hfps_mwi}/price.dta", clear
mer m:1 y4_hhid round using	"${tmp_hfps_mwi}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop y4_hhid item
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/price.dta", clear
mer m:1 hhid round using	"${tmp_hfps_nga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop hhid item
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/price.dta", clear
mer m:1 hhid round using	"${tmp_hfps_tza}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop hhid item
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/price.dta", clear
mer m:1 hhid round using	"${tmp_hfps_uga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
drop hhid item
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc			"Country Code"
la var round 		"Survey Round"
la var pnl_hhid		"Household ID Code"

ta itemstr cc
la var itemstr		"Item code (string)"
la var unitstr		"Unit code (string)"

*	a little bit of cleanup
su item_avail q kg lcu price unitcost
ta q if mi(lcu)
su q kg lcu price unitcost if item_avail==0
recode q (1=.) if mi(unitstr) & mi(kg) & mi(lcu)


order cc round pnl_hhid itemstr
isid  cc round pnl_hhid itemstr
sort  cc round pnl_hhid itemstr
sa "${tmp_hfps_pnl}/price.dta", replace
u  "${tmp_hfps_pnl}/price.dta", clear


*	areas for future development	
	*	convert to USD
	*	inflation correction
	*	possible further outlier checks - need to further understand SurSol validations that may already have been in effect though 












