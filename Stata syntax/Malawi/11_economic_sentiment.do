

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*sentiment*", w
dir "${raw_hfps_mwi}/*nfe*", w

d using	"${raw_hfps_mwi}/sect8c_sentiments_r14.dta"
d using	"${raw_hfps_mwi}/sect8c_sentiments_r16.dta"
d using	"${raw_hfps_mwi}/sect8c_sentiments_r17.dta"



label_inventory "${raw_hfps_mwi}", pre(`"sect8c_sentiments_r"') suf(`".dta"') vallab	
	*->	stable

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect8c_sentiments_r14.dta"
	"${raw_hfps_mwi}/sect8c_sentiments_r16.dta"
	"${raw_hfps_mwi}/sect8c_sentiments_r17.dta"
	"${raw_hfps_mwi}/sect8c_sentiments_r19.dta"
	"${raw_hfps_mwi}/sect8c_sentiments_r20.dta"
	"${raw_hfps_mwi}/sect8c_sentiments_r21.dta"
, gen(round);
#d cr 
isid y4_hhid round
la drop _append
la val round 
ta round 
replace round=round+13
replace round=round+1 if round>14
replace round=round+1 if round>17
ta round
	la var round	"Survey round"

	

d s8*

la li s9q1 s9q2 s9q3 s9q4 s9q5   s9q7 s9q8 s9q9

ta Sample_Type_hiddenn round,m
ta Sample_Type round,m
egen Sample = rowfirst(Sample_Type_hiddenn Sample_Type)
ta Sample round
tabstat s8q? s8q10__?, by(Sample) s(n)


loc q1 s8q1
ta `q1',m
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = `q1'==`i' if !mi(`q1')
	la var sntmnt_last12mohh_cat`l' "`: label (`q1') `i''"
}


loc q2	s8q2
ta		`q2', m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = `q2'==`i' if !mi(`q')
	la var sntmnt_next12mohh_cat`l' "`: label (`q2') `i''"
}


loc q3	s8q3
ta		`q3', m
la li	s9q3
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = `q3'==`i' if !mi(`q3')
	la var sntmnt_last12moNtl_cat`l' "`: label (`q3') `i''"
}

loc q4	s8q4
ta		`q4', m
la li	s9q4
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = `q4'==`i' if !mi(`q4')
	la var sntmnt_next12moNtl_cat`l' "`: label (`q4') `i''"
}

loc q5	s8q5
ta		`q5', m
la li	s9q5
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 97 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = `q5'==`i' if !mi(`q5')
	la var sntmnt_last12moPrice_cat`l' "`: label (`q5') `i''"
}

loc q6	s8q6
ta		`q6', m
// la li	s9q6
g		sntmnt_last12moPricepct = `q6'
la var	sntmnt_last12moPricepct	"Percent change in prices in past 12 months"

loc q7	s8q7
ta		`q7', m
la li	s9q7
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 97 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = `q7'==`i' if !mi(`q7')
	la var sntmnt_next12moPrice_cat`l' "`: label (`q7') `i''"
}

loc q8	s8q8
ta		`q8', m
la li	s9q8
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 97 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = `q8'==`i' if !mi(`q8')
	loc lbl = subinstr("`: label (`q8') `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

loc q9	s8q9
ta		`q9', m
la li	s9q9
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 6 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = `q9'==`i' if !mi(`q9')
	la var sntmnt_weatherrisk_cat`l' "`: label (`q9') `i''"
}

ren sntmnt_weatherrisk_cat6 sntmnt_weatherrisk_cat97



loc weather s8q10__
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

	preserve
egen zzz = group(round Sample ), label
tabstat sntmnt_*, by(zzz)
	restore
	
keep y4_hhid round sntmnt_*
isid y4_hhid round
sort y4_hhid round

sa "${tmp_hfps_mwi}/economic_sentiment.dta", replace 











