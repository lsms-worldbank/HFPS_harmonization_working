


dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*subjectif*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r18_sec9f1_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r19_sec9f1_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r19_sec9f2_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r20_sec9f1_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r21_sec9f1_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r22_sec9f1_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r22_sec9f2_bienetre_subjectif.dta"	
d using	"${raw_hfps_bfa}/r23_sec9f1_bienetre_subjectif.dta"	

label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec9f1_bienetre_subjectif.dta"') vallab
label_inventory "${raw_hfps_bfa}", pre(`"r"') suf(`"_sec9f2_bienetre_subjectif.dta"') vallab

{	/*	q1-6	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec9f1_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r19_sec9f1_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r20_sec9f1_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r21_sec9f1_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r22_sec9f1_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r23_sec9f1_bienetre_subjectif.dta" 
	, gen(round);

	la drop _append; la val round .; replace round=round+17; 
#d cr
isid hhid round

la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s09f1q01 
g sw_food_label=. 
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s09f1q02 
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s09f1q03 
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s09f1q04 
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s09f1q05 
la def q5 1 "Well" 2 "Fairly well" 3 "Fairly" 4 "With difficulty"
la val `q5' q5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s09f1q06
la def q6 1 "Very happy " 2 "Fairly happy" 3 "Not very happy" 4 "Not at all happy"
la val `q6' q6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}

keep hhid round sw_*	
tempfile q1q6
sa		`q1q6'
}/*	end q1-6	*/

{	/*	q7	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r19_sec9f2_bienetre_subjectif.dta" 
	"${raw_hfps_bfa}/r22_sec9f2_bienetre_subjectif.dta" 
	, gen(round);

	la drop _append; la val round .; 
	replace round=round+18; 
	replace round=round+2 if round>19; 
#d cr
isid hhid round
ta round subsample
tabstat s09* if subsample==1, by(round) s(n)
tabstat s09* if subsample==2, by(round) s(n)
	*	no A/B for this module 
	
d s09*
la li s09fq07a s09fq07b s09fq07c s09fq07d s09fq07e s09fq07f s09fq07g s09fq07h s09fq07i
la def agree 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree"
la val s09* agree


loc v s09f2q07a
ta `v', m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_accident_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07b
ta `v', m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_myown_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07c
ta `v', m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_otherin_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07d
ta `v', m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_selfdet_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07e
ta `v', m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_noprotect_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07f
ta `v', m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_otherout_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07g
ta `v', m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_iprotect_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07h
ta `v', m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_luck_cat`i'	"`: label (`v') `i''"
}

loc v s09f2q07i
ta `v', m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_comprotect_cat`i'	"`: label (`v') `i''"
}
	
keep hhid round ad_*	
tempfile q7
sa		`q7'
	}	/*	end q7	*/

u `q1q6', clear
mer 1:1 hhid round using `q7'
ta round _merge
drop _merge

d sw_*, f
su sw_*, sep(0)

d ad_*, f
su ad_*, sep(0)



sa "${tmp_hfps_bfa}/subjective_welfare.dta", replace
	
	
	



























































