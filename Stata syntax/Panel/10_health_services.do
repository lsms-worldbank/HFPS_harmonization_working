
gl subj health_services

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
mer m:1 hhid round using	"${tmp_hfps_bfa}/pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid
tempfile bfa
sa		`bfa'


u									"${tmp_hfps_eth}/${subj}.dta", clear
mer m:1 household_id round using	"${tmp_hfps_eth}/pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop household_id 
tempfile eth
sa		`eth'


u 							"${tmp_hfps_mwi}/${subj}.dta", clear
mer m:1 y4_hhid round using	"${tmp_hfps_mwi}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_nga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid 
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_tza}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_uga}/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
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

order cc round pnl_hhid item
isid  cc round pnl_hhid item
sort  cc round pnl_hhid item
compress item care*

*	final run of labeling programs 
run "${do_hfps_util}/label_access_item.do"	//	defines item label program 
label_access_item
cap : 	prog drop	label_access_item

run "${do_hfps_util}/label_care_place.do"



order care_place care_oop_any care_oop_d_services care_oop_d_goods care_oop_d_transit care_oop_d_other care_oop_v_services care_oop_v_goods care_oop_v_transit care_oop_v_other care_oop_value care_satisfaction, a(item)
sa	"${tmp_hfps_pnl}/${subj}.dta", replace


u	"${tmp_hfps_pnl}/${subj}.dta", clear
table item (round cc), nototal

