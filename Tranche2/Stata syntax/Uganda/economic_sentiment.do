





/*
dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w

// d using	"${raw_hfps_uga}/round1/SEC12.dta"
// d using	"${raw_hfps_uga}/round2/SEC12.dta"
// d using	"${raw_hfps_uga}/round3/SEC12.dta"
// d using	"${raw_hfps_uga}/round4/SEC12.dta"
// d using	"${raw_hfps_uga}/round5/SEC12.dta"
// d using	"${raw_hfps_uga}/round6/SEC12.dta"
// d using	"${raw_hfps_uga}/round7/SEC12.dta"
d using	"${raw_hfps_uga}/round8/SEC12.dta"
// d using	"${raw_hfps_uga}/round9/SEC12.dta"
d using	"${raw_hfps_uga}/round10/SEC12.dta"
// d using	"${raw_hfps_uga}/round11/SEC12.dta"
d using	"${raw_hfps_uga}/round12/SEC12.dta"
d using	"${raw_hfps_uga}/round13/SEC12.dta"
d using	"${raw_hfps_uga}/round14/SEC12.dta"
d using	"${raw_hfps_uga}/round15/SEC12.dta"
d using	"${raw_hfps_uga}/round16/SEC12.dta"
d using	"${raw_hfps_uga}/round17/SEC12.dta"

*/

u	"${raw_hfps_uga}/round8/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round10/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round12/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round13/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round14/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round15/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round16/SEC12.dta"		, clear
la li _all
u	"${raw_hfps_uga}/round17/SEC12.dta"		, clear
la li _all


#d ; 
clear; append using
	"${raw_hfps_uga}/round8/SEC12.dta"	
	"${raw_hfps_uga}/round10/SEC12.dta"	
	"${raw_hfps_uga}/round12/SEC12.dta"	
	"${raw_hfps_uga}/round13/SEC12.dta"	
	"${raw_hfps_uga}/round14/SEC12.dta"	
	"${raw_hfps_uga}/round15/SEC12.dta"	
	"${raw_hfps_uga}/round16/SEC12.dta"	
	"${raw_hfps_uga}/round17/SEC12.dta"	
	, gen(round); la drop _append; la val round .; 
#d cr 

replace round=round+7
replace round=round+1 if round>8
replace round=round+1 if round>10

// replace hhid=HHID if round==13
isid hhid round

	
	
	la li s12q01 s12q02 s12q03 s12q04 s12q05 s12q07 s12q08 s12q09
	

d s12*


ds s12*, not(type string)
tabstat `r(varlist)', by(round) s(n)


loc q1 s12q01
ta		`q1',m
la li	`q1'
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s12q02
ta		`q2', m
la li	`q2'
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s12q03
ta		`q3', m
la li	`q3'
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s12q04
ta		`q4', m
la li	`q4'
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s12q05
ta		`q5', m
la li	`q5'
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

d s12q06* s12q07
ta s12q06 s12q07,m
compare s12q07 s12q06
replace s12q07=s12q06 if mi(s12q07)
drop s12q06
tabstat s12q06*, by(round)
compare s12q06?	//	never jointly defined, as we expect
g s12q06 = s12q06a
replace s12q06 = s12q06b * -1 if mi(s12q06)

loc q6	s12q06
ta		`q6', m
g		sntmnt_last12moPricepct = `q6'
la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"


loc q7	s12q07
ta		`q7', m
la li	`q7'
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s12q08
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

loc q9	s12q09
ta		`q9', m
la li	`q9'
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}




loc weather s12q10__
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
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)
tabstat sntmnt_*_cat?, by(round) s(n me) longstub

keep hhid round sntmnt_*
isid hhid round
sort hhid round

sa "${tmp_hfps_uga}/panel/economic_sentiment.dta", replace 








