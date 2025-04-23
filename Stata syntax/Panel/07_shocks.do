
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
g shock_yn_lbl = .
order shock_yn_lbl, b(shock_yn_1)
la var shock_yn_lbl	"Experienced [...] shock since last asked"

order shock_cope_lbl, b(shock_cope_1)


*	some basic combinations
ds shock_yn_? shock_yn_??,  detail
loc fullset `r(varlist)'
loc climate		shock_yn_21 shock_yn_22 shock_yn_23 shock_yn_24 shock_yn_51 shock_yn_65 shock_yn_66 
loc agriculture	shock_yn_8 shock_yn_9 shock_yn_52 shock_yn_67
loc demog		shock_yn_1 shock_yn_25 shock_yn_28 shock_yn_61 shock_yn_62 shock_yn_63 shock_yn_64
loc nonhh		shock_yn_41 shock_yn_42
loc price		shock_yn_10 shock_yn_11 shock_yn_12 shock_yn_13 shock_yn_31
loc business	shock_yn_5 shock_yn_6 shock_yn_27 shock_yn_29 shock_yn_30
loc violence	shock_yn_7 shock_yn_53 shock_yn_68 shock_yn_69 shock_yn_70 shock_yn_71 shock_yn_72

loc claimed `climate' `agriculture' `demog' `nonhh' `price' `business' `violence'
loc check : list dups claimed 
assert length("`checked'")==0
loc testlist : list fullset - claimed
d `testlist'
	*->	unclear how to fit "lack of money" into all this 
		*	by itself it isn't really a shock, it's a condition, possibly a symptom of a shock

foreach x in climate agriculture demog nonhh price business violence	{
egen shock_yn_`x'	= rowmax(``x'')
}
la var shock_yn_climate		"Climate shock"
la var shock_yn_agriculture	"Agricultural production shock"
la var shock_yn_demog		"Death or illness shock"
la var shock_yn_nonhh		"Loss of non-hh member"
la var shock_yn_price		"Price shock"
la var shock_yn_business	"Business/income shock"
la var shock_yn_violence	"Violence/unrest"
su shock_yn_????*, sep(0)
order shock_yn_????*, a(shock_yn_96)

d
notes list	//	a lot from Uganda
notes drop *

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${tmp_hfps_pnl}/hh_shocks.dta", replace






