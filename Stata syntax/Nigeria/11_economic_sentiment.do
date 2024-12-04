
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"



d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"






#d ; 
clear; append using
	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
, gen(round) keep(hhid  *s11b*);
#d cr

	la drop _append
	la val round 
	replace round=round+15
	ta round 	
	isid hhid round
	sort hhid round

	d using "${tmp_hfps_nga}/cover.dta"
	mer 1:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3

	ta s12q5
	ta round  if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	drop _m s12q5
	
	la li s11bq1 s11bq2 s11bq3 s11bq4 s11bq5 s11bq7 s11bq8 s11bq9
	

d s11*


ta select_s11 round,m
ds s11*, not(type string)
tabstat `r(varlist)', by(select_s11) s(n)


loc q1 s11bq1
ta `q1',m
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s11bq2
ta		`q2', m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s11bq3
ta		`q3', m
la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s11bq4
ta		`q4', m
la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s11bq5
ta		`q5', m
la li	`q5'
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


loc q7	s11bq7
ta		`q7', m
la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s11bq8
ta		`q8', m
la li	`q8'
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s11bq9
ta		`q9', m
la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s11bq10__
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


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${tmp_hfps_nga}/economic_sentiment.dta", replace 


