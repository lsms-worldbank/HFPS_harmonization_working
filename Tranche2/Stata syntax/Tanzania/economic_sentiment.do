



dir "${raw_hfps_tza}", w

*	s3=employment, s4=nfe, s5=tourism nfe 
d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"			//	s5* 
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"		//	s4*
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	s4* 
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"	//	s4* 
d using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"	//	s4* 

*	have to harmonize prior to append 
u	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta", clear		//	s5* 
keep hhid s5q1-s5q9_os
g round=  6
tempfile r6
sa		`r6'
u	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta", clear		//	s4*
keep hhid select_s4-s4q9_os
g round=  7
tempfile r7
sa		`r7'
u	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta", clear	//	s4* 
keep hhid select_s4a-s4q9_os
g round=  8
tempfile r8
sa		`r8'
u	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear	//	s4* 
keep hhid select_s4-s4q9_os
g round=  9
tempfile r9
sa		`r9'
u	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta", clear	//	s4* 
keep hhid select_s4-s4q9_os
g round=  10
tempfile r10
sa		`r10'

clear
append using `r6' `r7' `r8' `r9' `r10'
la li _all

*	now that value labels are checked, combine 
foreach s5 of varlist s5* {
	loc s4 = subinstr("`s5'","s5","s4",1)
	replace `s5'=`s4' if round!=6
	drop `s4'
}
replace select_s4 = select_s4a if round==8
drop select_s4a


ta select_s4 round,m
ds s5*, not(type string)
tabstat `r(varlist)', by(select_s4) s(n)
ds s5*, not(type string)
tabstat `r(varlist)', by(round) s(n)


loc q1 s5q1
ta `q1',m
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s5q2
ta		`q2', m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s5q3
ta		`q3', m
// la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s5q4
ta		`q4', m
// la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s5q5
ta		`q5', m
// la li	`q5'
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

// loc q6	s11bq6
// ta		`q6', m
// la li	s9q6
// g		sntmnt_last12moPricepct = `q6'
// la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s5q6
ta		`q7', m
// la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}


// ta s5q7	//->this q was included in the round 6 qx, but is not present in the public data used here 
loc q8	s4q7	//	did not exist in round 6 
ta		round `q8', m
// la li	`q8'
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s5q8
ta		`q9', m
// la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}



loc weather s5q9__
tabstat `weather'1 `weather'2 `weather'3 `weather'4 `weather'5, by(`q9') s(n)	
d `weather'1 `weather'2 `weather'3 `weather'4 `weather'5

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)5 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
la var sntmnt_weatherevent_cat5		"Storms"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)
tabstat sntmnt_*_cat?, by(round) s(n sum) longstub

keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${tmp_hfps_tza}/panel/economic_sentiment.dta", replace 
u  "${tmp_hfps_tza}/panel/economic_sentiment.dta", clear 




