
gl subj employment

cap : noi : d using "${tmp_hfps_bfa}/${subj}.dta"
cap : noi : d using "${tmp_hfps_eth}/${subj}.dta"
cap : noi : d using "${tmp_hfps_mwi}/${subj}.dta"
cap : noi : d using "${tmp_hfps_nga}/${subj}.dta"
cap : noi : d using "${tmp_hfps_tza}/${subj}.dta"
cap : noi : d using "${tmp_hfps_uga}/${subj}.dta"

cap : noi : u "${tmp_hfps_bfa}/${subj}.dta", clear
cap : noi : u "${tmp_hfps_eth}/${subj}.dta", clear
cap : noi : u "${tmp_hfps_mwi}/${subj}.dta", clear
cap : noi : u "${tmp_hfps_nga}/${subj}.dta", clear
cap : noi : u "${tmp_hfps_tza}/${subj}.dta", clear
cap : noi : u "${tmp_hfps_uga}/${subj}.dta", clear





*	make employment panel

u							"${tmp_hfps_bfa}/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_bfa}/pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${tmp_hfps_eth}/${subj}.dta", clear
mer 1:1 household_id round using	"${tmp_hfps_eth}/pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${tmp_hfps_mwi}/${subj}.dta", clear
mer 1:1 y4_hhid round using	"${tmp_hfps_mwi}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_nga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_tza}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/${subj}.dta", clear
mer 1:1 hhid round using	"${tmp_hfps_uga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
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


*	cleaning up order of variables 
order cc round pnl_hhid

ta cc nfe_round, m	//	Tanzania only, and not strictly necessary to include 
drop nfe_round

ds challenge?_nfe  challenge??_nfe, alpha
loc vars `r(varlist)'
order challenge_lbl_nfe, b(`: word 1 of `vars'')
order `vars', a(challenge_lbl_nfe)
order challenge*_nfe, b(event_lbl_nfe)

ta emp_respondent cc	//	id code, not necessary to retain here 
drop emp_respondent

order hours_cur, a(sector_cur)
order lowrev_why_nfe, b(lowrev_why_lbl_nfe)	//	exclusive categorical variable will be before inclusive ones 


ta round cc

isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa	"${tmp_hfps_pnl}/${subj}.dta", replace



ex
u	"${tmp_hfps_pnl}/${subj}.dta", clear
ta open_nfe refperiod_nfe,m
ta round cc if !mi(open_nfe) & refperiod_nfe==0 
*	employment specific validations
ta round cc if mi(sector_nfe) & (open_nfe==1 | refperiod_nfe==1)


ta closed_why_nfe cc
table closed_why_nfe (cc round), nototal

table round cc, stat(mean event*_nfe) nototal
table round cc, stat(mean revenue?_nfe) nformat(%9.3f) nototal
