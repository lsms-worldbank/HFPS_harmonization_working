


gl subj agriculture

cap : noi : d using "${tmp_hfps_bfa}/panel/${subj}.dta"
cap : noi : d using "${tmp_hfps_eth}/panel/${subj}.dta"
cap : noi : d using "${tmp_hfps_mwi}/panel/${subj}.dta"
cap : noi : d using "${tmp_hfps_nga}/panel/${subj}.dta"
cap : noi : d using "${tmp_hfps_tza}/panel/${subj}.dta"
cap : noi : d using "${tmp_hfps_uga}/panel/${subj}.dta"

cap : noi : u "${tmp_hfps_bfa}/panel/${subj}.dta", clear
cap : noi : u "${tmp_hfps_eth}/panel/${subj}.dta", clear
cap : noi : u "${tmp_hfps_mwi}/panel/${subj}.dta", clear
cap : noi : u "${tmp_hfps_nga}/panel/${subj}.dta", clear
cap : noi : u "${tmp_hfps_tza}/panel/${subj}.dta", clear
cap : noi : u "${tmp_hfps_uga}/panel/${subj}.dta", clear


cap : noi : u "${tmp_hfps_mwi}/panel/${subj}.dta", clear
d, varlist
ds `r(sortlist)', not
d `r(varlist)', replace clear
sa "${tmp_hfps_pnl}/varlabs.dta", replace

*	make employment panel

u							"${tmp_hfps_bfa}/panel/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_bfa}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${tmp_hfps_eth}/panel/${subj}.dta", clear
mer 1:1 household_id round using	"${tmp_hfps_eth}/panel/pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${tmp_hfps_mwi}/panel/${subj}.dta", clear
mer 1:1 y4_hhid round using	"${tmp_hfps_mwi}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
g cc=3
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/panel/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_nga}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/panel/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_tza}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/panel/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_uga}/panel/pnl_cover.dta", keepus(pnl_hhid round)	// assert(2 3) keep(3) nogen
keep if _m==3
drop _m
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' /**/`eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
// replace cc=cc+1 if cc>1
// replace cc = cc+1 if cc>4	
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"

ta round cc

mer 1:1 _n using "${tmp_hfps_pnl}/varlabs.dta", keepus(name varlab) nogen
cou if !mi(name)
forv r=1/`=r(N)' {
	la var `=name[`r']' "`=varlab[`r']'"
}
drop name varlab

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${tmp_hfps_pnl}/${subj}.dta", replace

erase "${tmp_hfps_pnl}/varlabs.dta"



