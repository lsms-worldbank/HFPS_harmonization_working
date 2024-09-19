

d using "${tmp_hfps_bfa}/panel/dietary_diversity.dta"
// d using "${tmp_hfps_eth}/panel/dietary_diversity.dta"
d using "${tmp_hfps_mwi}/panel/dietary_diversity.dta"
d using "${tmp_hfps_nga}/panel/dietary_diversity.dta"
d using "${tmp_hfps_tza}/panel/dietary_diversity.dta"
d using "${tmp_hfps_uga}/panel/dietary_diversity.dta"

loc dographs=0
if `dographs'==1	{
u "${tmp_hfps_bfa}/panel/dietary_diversity.dta", clear
dens_by_round HDDS_w
u "${tmp_hfps_mwi}/panel/dietary_diversity.dta", clear
dens_by_round HDDS_w
u "${tmp_hfps_nga}/panel/dietary_diversity.dta", clear
dens_by_round HDDS_w
u "${tmp_hfps_tza}/panel/dietary_diversity.dta", clear
dens_by_round HDDS_w
u "${tmp_hfps_uga}/panel/dietary_diversity.dta", clear
dens_by_round HDDS_w
}



*	make dietary diversity panel

u							"${tmp_hfps_bfa}/panel/dietary_diversity.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_bfa}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u							"${tmp_hfps_mwi}/panel/dietary_diversity.dta", clear
mer 1:1 y4_hhid round using	"${tmp_hfps_mwi}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop y4_hhid
tempfile mwi
sa		`mwi'


u							"${tmp_hfps_nga}/panel/dietary_diversity.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_nga}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid
tempfile nga
sa		`nga'


u							"${tmp_hfps_tza}/panel/dietary_diversity.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_tza}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/panel/dietary_diversity.dta", clear
mer m:1 hhid round using	"${tmp_hfps_uga}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
replace cc = cc+1 if cc>1
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"

ta round cc

isid pnl_hhid round cc
sa "${tmp_hfps_pnl}/dietary_diversity.dta", replace
u "${tmp_hfps_pnl}/dietary_diversity.dta", clear








