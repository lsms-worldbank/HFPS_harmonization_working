
gl subj access

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





*	make employment panel

u							"${tmp_hfps_bfa}/panel/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_bfa}/panel/pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid
tempfile bfa
sa		`bfa'


u									"${tmp_hfps_eth}/panel/${subj}.dta", clear
mer m:1 household_id round using	"${tmp_hfps_eth}/panel/pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop household_id 
tempfile eth
sa		`eth'


u 							"${tmp_hfps_mwi}/panel/${subj}.dta", clear
mer m:1 y4_hhid round using	"${tmp_hfps_mwi}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${tmp_hfps_nga}/panel/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_nga}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid 
tempfile nga
sa		`nga'

u							"${tmp_hfps_tza}/panel/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_tza}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round item
sort pnl_hhid round item
drop hhid 
tempfile tza
sa		`tza'

u							"${tmp_hfps_uga}/panel/${subj}.dta", clear
mer m:1 hhid round using	"${tmp_hfps_uga}/panel/pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
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
compress item*

*	final run of labeling programs 
run "${do_hfps_util}/label_access_item.do"	//	defines item label program 
run "${do_hfps_util}/label_item_ltfull.do"	//	defines label program for less than full variable labels 

label_access_item
label_item_ltfull noaccess
label_item_ltfull ltfull

cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull




order item_need item_access item_noaccess_* item_fullbuy item_ltfull* item_avail, a(item)
sa	"${tmp_hfps_pnl}/${subj}.dta", replace


u	"${tmp_hfps_pnl}/${subj}.dta", clear
ta item round

egen updated_cats = rownonmiss(item_noaccess_cat4?)
ta item updated_cats
bys cc round item : egen has_updates = max(updated_cats>0)
ta item has_updates

ta cc round if !inlist(item,11,51,52,53,54,55,56,57,58) & has_updates==1
ta cc round if inrange(item,51,58) & mi(item_noaccess_cat41)



