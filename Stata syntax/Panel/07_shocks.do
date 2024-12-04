
d using "${tmp_hfps_bfa}/hh_shocks.dta"
d using "${tmp_hfps_eth}/hh_shocks.dta"
d using "${tmp_hfps_mwi}/hh_shocks.dta"
d using "${tmp_hfps_nga}/hh_shocks.dta"
d using "${tmp_hfps_tza}/hh_shocks.dta"
d using "${tmp_hfps_uga}/hh_shocks.dta"

u "${tmp_hfps_bfa}/hh_shocks.dta", clear
u "${tmp_hfps_eth}/hh_shocks.dta", clear
u "${tmp_hfps_mwi}/hh_shocks.dta", clear
u "${tmp_hfps_nga}/hh_shocks.dta", clear
u "${tmp_hfps_tza}/hh_shocks.dta", clear
u "${tmp_hfps_uga}/hh_shocks.dta", clear





*	make shocks panel

u							"${tmp_hfps_bfa}/hh_shocks.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_bfa}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${tmp_hfps_eth}/hh_shocks.dta", clear
mer 1:1 household_id round using	"${tmp_hfps_eth}/pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${tmp_hfps_mwi}/hh_shocks.dta", clear
mer 1:1 y4_hhid round using	"${tmp_hfps_mwi}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/hh_shocks.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_nga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/hh_shocks.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_tza}/pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/hh_shocks.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_uga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"

ta round cc

d
order cc round pnl_hhid shock_yn shock_yn_*, seq
order shock_cope_*, seq a(shock_yn_96)
su shock_cope_*
drop shock_cope_2 shock_cope_3 shock_cope_4 shock_cope_5	//	reshape remnants 
d


order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${tmp_hfps_pnl}/hh_shocks.dta", replace
