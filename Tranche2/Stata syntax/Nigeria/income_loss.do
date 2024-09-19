
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d using	"${raw_hfps_nga1}/r1_sect_10.dta"
d using	"${raw_hfps_nga1}/r1_sect_7.dta"
d using	"${raw_hfps_nga1}/r2_sect_7.dta"
d using	"${raw_hfps_nga1}/r3_sect_7.dta"
d using	"${raw_hfps_nga1}/r4_sect_7.dta"
d using	"${raw_hfps_nga1}/r5_sect_7.dta"
d using	"${raw_hfps_nga1}/r6_sect_7.dta"
// d using	"${raw_hfps_nga1}/r7_sect_7.dta"
d using	"${raw_hfps_nga1}/r8_sect_10.dta"
d using	"${raw_hfps_nga1}/r9_sect_7.dta"
// d using	"${raw_hfps_nga1}/r10_sect_7.dta"
// d using	"${raw_hfps_nga1}/r11_sect_7.dta"
// d using	"${raw_hfps_nga1}/r12_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r1_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r2_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r3_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r4_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r5_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r6_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r7_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r8_sect_7.dta"
// d using	"${raw_hfps_nga2}/p2r9_sect_7.dta"


u "${raw_hfps_nga1}/r1_sect_7.dta", clear
la li source_cd s7q1 s7q2 
u "${raw_hfps_nga1}/r2_sect_7.dta", clear
la li source_cd s7q1  
u "${raw_hfps_nga1}/r3_sect_7.dta", clear
la li source_cd s7q1  
u "${raw_hfps_nga1}/r4_sect_7.dta", clear
la li source_cd s7q1 s7q2 //	added an n/a category (4)
u "${raw_hfps_nga1}/r5_sect_7.dta", clear
la li source_cd s7q1 
u "${raw_hfps_nga1}/r6_sect_7.dta", clear
la li source_cd s7q1  
u "${raw_hfps_nga1}/r9_sect_7.dta", clear
la li source_cd s7q1 s7q2 





#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_7.dta"
	"${raw_hfps_nga1}/r2_sect_7.dta"
	"${raw_hfps_nga1}/r3_sect_7.dta"
	"${raw_hfps_nga1}/r4_sect_7.dta"
	"${raw_hfps_nga1}/r5_sect_7.dta"
	"${raw_hfps_nga1}/r6_sect_7.dta"
	"${raw_hfps_nga1}/r9_sect_7.dta"
, gen(round);
#d cr

	la drop _append
	la val round 
	replace round=round+2 if round>6
	ta round 	
	isid hhid source_cd round
	sort hhid source_cd round

	d using "${tmp_hfps_nga}/panel/cover.dta"
	mer m:1 hhid round using "${tmp_hfps_nga}/panel/cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3
	ta s12q5
	
	ta source_cd round
	
	ta source_cd_os
	g str = strtrim(lower(source_cd_os))
	li str if !mi(str) & source_cd==96, sepby(round)
	la li source_cd
	recode source_cd (96=1) if inlist(str,"sells of palm furit","i have harvest all my crop")
	recode source_cd (96=2) if inlist(str,"voice over","driving","footballer / beauty industry","trading","clergy works","he refines palm oil and sells.he also sells yams.","he's an instrumentalist and gets paid sometimes.","she's also a tailor.")
	recode source_cd (96=5) if inlist(str,"i also got assistance from my children","the son bring money for mama")
	recode source_cd (96=6) if inlist(str,"from neighbours","through contributions","from community donors","another source of livelihood is the loan from cooperative in his place of work.")
	recode source_cd (96=8) if inlist(str,"retired civil servant")
	recode source_cd (96=10) if inlist(str,"project money")
	li str s7* if !mi(str) & source_cd==96, sepby(round)
	duplicates tag hhid source_cd round, gen(tag)
	li hhid source_cd round str s7* if tag>0, sepby(hhid)
	drop if tag>0 & s7q1==2	
	ta source_cd
	la li s7q1 s7q2	//	4 total loss was added later 
	g inc_d_=(s7q1==1) if !mi(s7q1)
	g inc_loss_=(inlist(s7q2,3,4)) if !mi(s7q2)
	collapse (max) inc_d_ (min) inc_chg_=s7q2 (max) inc_loss_, by(hhid source_cd round)
sa "${tmp_hfps_nga}/panel/income_loss.dta", replace 
u  "${tmp_hfps_nga}/panel/income_loss.dta", clear 

	la li source_cd
	
	reshape wide inc_d_ inc_chg_ inc_loss_, i(hhid round) j(source_cd)
	loc stubs	farm bus we rem_for rem_dom ast_fam ast_com isp pen gov ngo other total
	loc lbl1	=strlower("HOUSEHOLD FARMING, LIVESTOCK OR FISHING")
    loc lbl2	=strlower("NON-FARM FAMILY BUSINESS")
    loc lbl3	=strlower("WAGE EMPLOYMENT OF HOUSEHOLD MEMBERS")
    loc lbl4	=strlower("REMITTANCES FROM ABROAD")
    loc lbl5	=strlower("REMITTANCES FROM FAMILY WITHIN THE COUNTRY")
    loc lbl6	=strlower("ASSISTANCE FROM OTHER NON-FAMILY INDIVIDUALS")
    loc lbl7	=strlower("INCOME FROM PROPERTIES, INVESTMENTS OR SAVINGS")
    loc lbl8	=strlower("PENSION")
    loc lbl9	=strlower("ASSISTANCE FROM THE GOVERNMENT")
    loc lbl10	=strlower("ASSISTANCE FROM NGOS / CHARITABLE ORGANIZATION")
    loc lbl96	=strlower("OTHER")
    loc lbl99	=strlower("TOTAL HOUSEHOLD INCOME")
	
	loc s=0
	foreach i of numlist 1/10 96 99 {
		loc ++s
		loc stub : word `s' of `stubs'
		la var inc_d_`i'	"Any `lbl`i'' income"
		la var inc_chg_`i'	"Change in `lbl`i'' income"
		la var inc_loss_`i'	"Any loss of `lbl`i'' income"
		}
	
	

sa "${tmp_hfps_nga}/panel/hh_income_loss.dta", replace 

ex
*	modifications for construction of grand panel 
u "${tmp_hfps_nga}/panel/cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_wgt = wgt 

sa "${tmp_hfps_nga}/panel/pnl_cover.dta", replace 







