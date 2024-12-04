


dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*opinion*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r13_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r14_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r15_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r16_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r18_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r19_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r20_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r21_sec9c_opinion_economique.dta"	
d using	"${raw_hfps_bfa}/r22_sec9c_opinion_economique.dta"	


label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec9c_opinion_economique.dta"') vallab
	*->	very stable
#d ; 
clear; append using 
	"${raw_hfps_bfa}/r13_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r14_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r15_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r16_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r18_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r19_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r20_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r21_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r22_sec9c_opinion_economique.dta"	
	"${raw_hfps_bfa}/r23_sec9c_opinion_economique.dta"	
	, gen(round); la drop _append; la val round .; 
#d cr 
replace round = round+12
replace round = round+1 if round>16



	la li q1 q2 q3 q4 q5 q7 q8 q9 q11

d s09*


ds s09*, not(type string) detail
tabstat `r(varlist)', by(round) s(n)


loc q1 s09cq01
ta		`q1',m
la li	q1
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
// 	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s09cq02
ta		`q2', m
la li	q2
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s09cq03
ta		`q3', m
la li	q3
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s09cq04
ta		`q4', m
la li	q4
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s09cq05
ta		`q5', m
la li	q5
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}


loc q6	s09cq06
ta		`q6', m
g		sntmnt_last12moPricepct = `q6'
la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s09cq07
ta		`q7', m
la li	q7
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s09cq08
ta		`q8', m
la li	q8
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s09cq09
ta		`q9', m
la li	q9
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s09cq10__
tabstat `weather'?, by(round) s(n)	
d `weather'?	//	no storms for UGA 

g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)4 {
	g	   sntmnt_weatherevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"



loc q11	s09cq11
ta		`q11', m
la li	q11
g      sntmnt_securityrisk_label=.
la var sntmnt_securityrisk_label	"Financial effects from extreme violence are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_securityrisk_cat`l' = `q11'==`i' if !mi(`q11')
	la var sntmnt_securityrisk_cat`l' "`: label (`q11') `i''"
}


loc violence s09cq12__
tabstat `violence'?, by(round) s(n)	
d `violence'?	//	no storms for BFA 

g      sntmnt_securityevent_label=.
la var sntmnt_securityevent_label	"Most likely security event to cause financial effects [...]" 
foreach i of numlist 1(1)4 {
	g	   sntmnt_securityevent_cat`i' = (`weather'`i'==1) if !mi(`weather'`i')
}
la var sntmnt_securityevent_cat1		"Terrorism/extreme violence"
la var sntmnt_securityevent_cat2		"Large scale theft"
la var sntmnt_securityevent_cat3		"Community violence"
la var sntmnt_securityevent_cat4		"Political instability/unrest"






	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${tmp_hfps_bfa}/economic_sentiment.dta", replace 

ex




























































