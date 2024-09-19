

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*subjectivewelfare*", w

d using	"${raw_hfps_mwi}/sect19_subjectivewelfare_r19.dta"
d using	"${raw_hfps_mwi}/sect19_subjectivewelfare_r20.dta"


	
{	/*	simple check for changes across time	*/
loc r=19
u "${raw_hfps_mwi}/sect19_subjectivewelfare_r`r'.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
tempfile base
sa      `base'
foreach r of numlist 20 {
	u "${raw_hfps_mwi}/sect19_subjectivewelfare_r`r'.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches	//	perfect
}


#d ; 
clear; append using
	"${raw_hfps_mwi}/sect19_subjectivewelfare_r19.dta"
	"${raw_hfps_mwi}/sect19_subjectivewelfare_r20.dta"
, gen(round); la drop _append; la val round .; replace round=round+18;
#d cr 
isid y4 round
ta round Sample

la li _all

{	/*	q1-q6	*/	
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

loc q1 s19q1 
g sw_food_label=. 
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (`q1'==`i') if !mi(`q1')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

loc q2 s19q2 
g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (`q2'==`i') if !mi(`q2')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

loc q3 s19q3 
g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (`q3'==`i') if !mi(`q3')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

loc q4 s19q4 
g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
foreach i of numlist 1(1)3 4  {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (`q4'==`i') if !mi(`q4')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

loc q5 s19q5 
la def q5 1 "Well" 2 "Fairly well" 3 "Fairly" 4 "With difficulty"
la val `q5' q5
ta `q5',m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = `q5'==`i' if !mi(`q5')
	la var sw_income_cat`i'	"`: label (`q5') `i''"
}

loc q6 s19q6
la def q6 1 "Very happy " 2 "Fairly happy" 3 "Not very happy" 4 "Not at all happy"
la val `q6' q6
ta `q6', m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = `q6'==`i' if !mi(`q6')
	la var sw_happy_cat`i'	"`: label (`q6') `i''"
}
}	/*	end q1-6	*/

{	/*	q7	*/

d s19q7*

la def agree 1 "Disagree" 2 "Neither agree nor disagree" 3 "Agree"
la val s19q7* agree


loc v s19q7a
ta `v', m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_accident_cat`i'	"`: label (`v') `i''"
}

loc v s19q7b
ta `v', m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_myown_cat`i'	"`: label (`v') `i''"
}

loc v s19q7c
ta `v', m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_otherin_cat`i'	"`: label (`v') `i''"
}

loc v s19q7d
ta `v', m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_selfdet_cat`i'	"`: label (`v') `i''"
}

loc v s19q7e
ta `v', m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_noprotect_cat`i'	"`: label (`v') `i''"
}

loc v s19q7f
ta `v', m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_otherout_cat`i'	"`: label (`v') `i''"
}

loc v s19q7g
ta `v', m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_iprotect_cat`i'	"`: label (`v') `i''"
}

loc v s19q7h
ta `v', m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_luck_cat`i'	"`: label (`v') `i''"
}

loc v s19q7i
ta `v', m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = (`v'==`i') if !mi(`v')
	la var ad_comprotect_cat`i'	"`: label (`v') `i''"
}
	
	}	/*	end q7	*/

keep y4_hhid round sw_* ad_*	


d sw_*, f
su sw_*, sep(0)

d ad_*, f
su ad_*, sep(0)



sa "${tmp_hfps_mwi}/panel/subjective_welfare.dta", replace
	
	
	



























































