





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

d using	"${raw_hfps_uga}/round1/SEC5.dta"
d using	"${raw_hfps_uga}/round2/SEC5.dta"
d using	"${raw_hfps_uga}/round3/SEC5.dta"
d using	"${raw_hfps_uga}/round4/SEC5.dta"
d using	"${raw_hfps_uga}/round5/SEC5.dta"
d using	"${raw_hfps_uga}/round6/SEC5_Resp.dta"
d using	"${raw_hfps_uga}/round7/SEC5.dta"
d using	"${raw_hfps_uga}/round8/SEC5.dta"
d using	"${raw_hfps_uga}/round9/SEC5.dta"
d using	"${raw_hfps_uga}/round10/SEC5.dta"
d using	"${raw_hfps_uga}/round11/SEC5.dta"
d using	"${raw_hfps_uga}/round12/SEC5.dta"
d using	"${raw_hfps_uga}/round13/SEC13.dta"	//	where is s9q05? 
d using	"${raw_hfps_uga}/round14/SEC13.dta"	//	where is s9q05? 
d using	"${raw_hfps_uga}/round15/SEC13.dta"
d using	"${raw_hfps_uga}/round16/SEC13.dta"
d using	"${raw_hfps_uga}/round17/SEC13.dta"

*/




#d ; 
clear; append using
	"${raw_hfps_uga}/round13/SEC13.dta"
	"${raw_hfps_uga}/round14/SEC13.dta"
	"${raw_hfps_uga}/round15/SEC13.dta"
	"${raw_hfps_uga}/round16/SEC13.dta"
	"${raw_hfps_uga}/round17/SEC13.dta"
, gen(round); la drop _append; la val round .; replace round=round+12;
#d cr 
isid hhid round
ta round

	
	ta round s9q05_1,m
	ta round s9q05,m
	la li s9q01 s9q02 s9q03 s9q04 s9q05_1 s9q06 s9q05
	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s9q01 
g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s9q02 
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s9q03
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4  s9q04 
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3   {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

// g zzz = cond(!mi(s9q05),s9q05,s9q05_1)	//	prefer the standard version where available 
loc q5 s9q05 
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s9q06
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}


d s9q7?
la li s9q7a s9q7b s9q7c s9q7d s9q7e s9q7f s9q7g s9q7h s9q7i
loc q7a s9q7a
ta `q7a', m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = `q7a'==`i' if !mi(`q7a')
	la var ad_accident_cat`i'	"`: label (`q7a') `i''"
}


loc q7b s9q7b
ta `q7b', m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = `q7b'==`i' if !mi(`q7b')
	la var ad_myown_cat`i'	"`: label (`q7b') `i''"
}

loc q7c s9q7c
ta `q7c', m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = `q7c'==`i' if !mi(`q7c')
	la var ad_otherin_cat`i'	"`: label (`q7c') `i''"
}

loc q7d s9q7d
ta `q7d', m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = `q7d'==`i' if !mi(`q7d')
	la var ad_selfdet_cat`i'	"`: label (`q7d') `i''"
}

loc q7e s9q7e
ta `q7e', m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = `q7e'==`i' if !mi(`q7e')
	la var ad_noprotect_cat`i'	"`: label (`q7e') `i''"
}

loc q7f s9q7f
ta `q7f', m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = `q7f'==`i' if !mi(`q7f')
	la var ad_otherout_cat`i'	"`: label (`q7f') `i''"
}

loc q7g s9q7g
ta `q7g', m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = `q7g'==`i' if !mi(`q7g')
	la var ad_iprotect_cat`i'	"`: label (sub7g_pro) `i''"
}

loc q7h s9q7h
ta `q7h', m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = `q7h'==`i' if !mi(`q7h')
	la var ad_luck_cat`i'	"`: label (`q7h') `i''"
}

loc q7i s9q7i
ta `q7i', m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = `q7i'==`i' if !mi(`q7i')
	la var ad_comprotect_cat`i'	"`: label (`q7i') `i''"
}


	

// ren HHID hhid
keep hhid round sw_* ad_*
sa "${tmp_hfps_uga}/panel/subjective_welfare.dta", replace 
ex








