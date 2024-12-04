



dir "${raw_hfps_tza}", w
dir "${raw_hfps_tza}/r8_*.dta", w
dir "${raw_hfps_tza}/*_11_*.dta", w

d using	"${raw_hfps_tza}/r1_sect_1.dta"
d using	"${raw_hfps_tza}/r2_sect_1.dta"
d using	"${raw_hfps_tza}/r3_sect_1.dta"
d using	"${raw_hfps_tza}/r4_sect_1.dta"
d using	"${raw_hfps_tza}/r5_sect_1.dta"
d using	"${raw_hfps_tza}/r6_sect_1.dta"
d using	"${raw_hfps_tza}/r7_sect_1.dta"
d using	"${raw_hfps_tza}/r8_sect_7.dta"

*	s3=employment, s4=nfe, s5=tourism nfe 
d using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"	
d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	
d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	
d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"		
d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	
d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"		
d using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	
d using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"	//	no s11q7* at?  
d using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"	
d using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"	
d using	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"	


#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	
	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"
, gen(round) keep(hhid  *s11*);
la drop _append; la val round.; replace round = round+6; 
#d cr
isid hhid round
ta round select_s11,m
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s11q1
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s11q2
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s11q3
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s11q4
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s11q5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s11q6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

keep hhid round sw_*
sa "${tmp_hfps_tza}/subjective_welfare.dta", replace 
ex
