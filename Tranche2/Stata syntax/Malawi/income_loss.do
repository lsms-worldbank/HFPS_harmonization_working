

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*income_loss*", w

d using	"${raw_hfps_mwi}/sect7_income_loss_r1.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r2.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r3.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r4.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r7.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r9.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r11.dta"
d using	"${raw_hfps_mwi}/sect7_income_loss_r13.dta"

u	"${raw_hfps_mwi}/sect7_income_loss_r1.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r2.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r3.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r4.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r7.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r9.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r11.dta"	, clear
la li _all
u	"${raw_hfps_mwi}/sect7_income_loss_r13.dta"	, clear
la li _all

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect7_income_loss_r1.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r2.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r3.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r4.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r7.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r9.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r11.dta"
	"${raw_hfps_mwi}/sect7_income_loss_r13.dta"
, gen(round);
#d cr 
isid y4 income_source round
la drop _append
la val round 
ta round 
replace round=round+2 if round>4
replace round=round+1 if round>7
replace round=round+1 if round>9
replace round=round+1 if round>11
ta round
	la var round	"Survey round"

	
ta income_source_os	//	GANYU WAS AN O/S! 
la li y
ta income_source if s7q1==1
	g str = strtrim(lower(income_source_os))
	li str if !mi(str) & income_source==96 & !inlist(str,"ganyu","casual labour"), sepby(round)	
	recode income_source (96=6) if inlist(str,"church","religion bodies")
	recode income_source (96=7) if inlist(str,"houses for rent","income from matured life insurance")
	recode income_source (96=8) if inlist(str,"pension scheme")
	ta str if income_source==96	//	remainder dominated by ganyu, a few loans 
	duplicates tag y4 income_source round, gen(tag)
	li y4 income_source round str s7* if tag>0, sepby(y4)	
	drop if tag>0 & s7q1==2	
	la li x s7q2	//	4 N/A was added later 
	g inc=(s7q1==1) if !mi(s7q1)
	g loss=(s7q2==3) if !mi(s7q2)
	collapse (max) inc loss, by(y4 income_source round)
	
	
sa "${tmp_hfps_mwi}/panel/income_loss.dta", replace 
ex


*	modifications for construction of grand panel 
u  "${tmp_hfps_mwi}/panel/cover.dta", clear


egen pnl_hhid = group(y4_hhid)
egen pnl_admin1 = group(hh_a00)
egen pnl_admin2 = group(hh_a01)
egen pnl_admin3 = group(r0_ta_code)

g pnl_urban = urb_rural=="urban":hh_a03b
g pnl_wgt = wgt 

sa "${tmp_hfps_mwi}/panel/pnl_cover.dta", replace 











