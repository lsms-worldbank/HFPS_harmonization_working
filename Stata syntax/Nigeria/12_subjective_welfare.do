
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"



d *s11c* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d *s11c* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
d *s11c* using	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"






#d ; 
clear; append using
	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"
, gen(round) keep(hhid  *s11c*);
#d cr

	la drop _append
	la val round 
	replace round=round+19
	ta round 	
	isid hhid round
	sort hhid round

	d using "${tmp_hfps_nga}/cover.dta"
	mer 1:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(s12q5)
	ta round _m	//	perfect
	keep if _m==3

	ta s12q5
	ta round s11cq1 if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	drop _m s12q5
	
	la li s11cq1 s11cq2 s11cq3 s11cq4 s11cq5 s11cq6 s11cq7a s11cq7b s11cq7c s11cq7d s11cq7e s11cq7f s11cq7g s11cq7h s11cq7i
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s11cq1
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s11cq2
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s11cq3
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s11cq4
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s11cq5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s11cq6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

loc q7a s11cq7a
ta `q7a', m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = `q7a'==`i' if !mi(`q7a')
	la var ad_accident_cat`i'	"`: label (`q7a') `i''"
}


loc q7b s11cq7b
ta `q7b', m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = `q7b'==`i' if !mi(`q7b')
	la var ad_myown_cat`i'	"`: label (`q7b') `i''"
}

loc q7c s11cq7c
ta `q7c', m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = `q7c'==`i' if !mi(`q7c')
	la var ad_otherin_cat`i'	"`: label (`q7c') `i''"
}

loc q7d s11cq7d
ta `q7d', m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = `q7d'==`i' if !mi(`q7d')
	la var ad_selfdet_cat`i'	"`: label (`q7d') `i''"
}

loc q7e s11cq7e
ta `q7e', m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = `q7e'==`i' if !mi(`q7e')
	la var ad_noprotect_cat`i'	"`: label (`q7e') `i''"
}

loc q7f s11cq7f
ta `q7f', m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = `q7f'==`i' if !mi(`q7f')
	la var ad_otherout_cat`i'	"`: label (`q7f') `i''"
}

loc q7g s11cq7g
ta `q7g', m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = `q7g'==`i' if !mi(`q7g')
	la var ad_iprotect_cat`i'	"`: label (sub7g_pro) `i''"
}

loc q7h s11cq7h
ta `q7h', m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = `q7h'==`i' if !mi(`q7h')
	la var ad_luck_cat`i'	"`: label (`q7h') `i''"
}

loc q7i s11cq7i
ta `q7i', m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = `q7i'==`i' if !mi(`q7i')
	la var ad_comprotect_cat`i'	"`: label (`q7i') `i''"
}


	
	
	
keep hhid round sw_* ad_*
sa "${tmp_hfps_nga}/subjective_welfare.dta", replace 


