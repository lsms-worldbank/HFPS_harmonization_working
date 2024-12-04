
*	subjective welfare  
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*shock_coping*", w
// dir "${raw_hfps_eth2}", w

*	Phase 1
// d  using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d  using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
// d  using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"	, si
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_subjective_welfare_public.dta"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_subjective_welfare_public.dta"		, clear


la li adequecy_sub
la def adeq 1 "Less than adequate" 2 "Adequate" 3 "More than adequate" 4 "N/A"

g sw_food_label=.
la var sw_food_label	"Food consumption last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_food_cat`abs' = (sub1_food==`i')
	la var sw_food_cat`abs'	"`: label adeq `abs''"
}

g      sw_housing_label=.
la var sw_housing_label	"Housing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_housing_cat`abs' = (sub2_food==`i')
	la var sw_housing_cat`abs'	"`: label adeq `abs''"
}

g      sw_clothing_label=.
la var sw_clothing_label	"Clothing last month was [...]"
forv i=1/3 {
	loc abs=abs(`i')
	g      sw_clothing_cat`abs' = (sub3_food==`i')
	la var sw_clothing_cat`abs'	"`: label adeq `abs''"
}

g      sw_healthcare_label=.
la var sw_healthcare_label	"Health care last month was [...]"
recode sub4_food (-97=4)
foreach i of numlist 1(1)3 4 {
	loc abs=abs(`i')
	g      sw_healthcare_cat`abs' = (sub4_food==`i')
	la var sw_healthcare_cat`abs'	"`: label adeq `abs''"
}

ta sub5_food,m
g      sw_income_label=.
la var sw_income_label	"Given household income last month, are you living [...]"
forv i=1/4 {
	g      sw_income_cat`i' = sub5_food==`i'
	la var sw_income_cat`i'	"`: label (sub5_food) `i''"
}

ta sub6_food, m
g      sw_happy_label=.
la var sw_happy_label	"Overall happiness last month"
forv i=1/4 {
	g      sw_happy_cat`i' = sub6_food==`i'
	la var sw_happy_cat`i'	"`: label (sub6_food) `i''"
}


d sub7*
la li agree2_sub

ta sub7a_acc, m
g      ad_accident_label=.
la var ad_accident_label	"Life is controlled by accidental happenings"
forv i=1/3 {
	g      ad_accident_cat`i' = sub7a_acc==`i'
	la var ad_accident_cat`i'	"`: label (sub7a_acc) `i''"
}

ta sub7b_my, m
g      ad_myown_label=.
la var ad_myown_label	"Life is controlled by my own actions"
forv i=1/3 {
	g      ad_myown_cat`i' = sub7b_my==`i'
	la var ad_myown_cat`i'	"`: label (sub7b_my) `i''"
}

ta sub7c_feel, m
g      ad_otherin_label=.
la var ad_otherin_label	"Life is controlled by others in household"
forv i=1/3 {
	g      ad_otherin_cat`i' = sub7c_feel==`i'
	la var ad_otherin_cat`i'	"`: label (sub7c_feel) `i''"
}

ta sub7d_det, m
g      ad_selfdet_label=.
la var ad_selfdet_label	"I can determine what will happen in life"
forv i=1/3 {
	g      ad_selfdet_cat`i' = sub7d_det==`i'
	la var ad_selfdet_cat`i'	"`: label (sub7d_det) `i''"
}

ta sub7e_cha, m
g      ad_noprotect_label=.
la var ad_noprotect_label	"Often no chance of protecting my personal interests"
forv i=1/3 {
	g      ad_noprotect_cat`i' = sub7e_cha==`i'
	la var ad_noprotect_cat`i'	"`: label (sub7e_cha) `i''"
}

ta sub7f_fam, m
g      ad_otherout_label=.
la var ad_otherout_label	"Life is controlled by family outside household"
forv i=1/3 {
	g      ad_otherout_cat`i' = sub7f_fam==`i'
	la var ad_otherout_cat`i'	"`: label (sub7f_fam) `i''"
}

ta sub7g_pro, m
g      ad_iprotect_label=.
la var ad_iprotect_label	"I am able to protect my interests"
forv i=1/3 {
	g      ad_iprotect_cat`i' = sub7g_pro==`i'
	la var ad_iprotect_cat`i'	"`: label (sub7g_pro) `i''"
}

ta sub7h_luck, m
g      ad_luck_label=.
la var ad_luck_label	"When I get what I want it is usually because of luck"
forv i=1/3 {
	g      ad_luck_cat`i' = sub7h_luck==`i'
	la var ad_luck_cat`i'	"`: label (sub7h_luck) `i''"
}

ta sub7i_litt, m
g      ad_comprotect_label=.
la var ad_comprotect_label	"Unable to protect my interests if they conflict with community members"
forv i=1/3 {
	g      ad_comprotect_cat`i' = sub7i_litt==`i'
	la var ad_comprotect_cat`i'	"`: label (sub7i_litt) `i''"
}



d sw_*, f
su sw_*, sep(0)

d ad_*, f
su ad_*, sep(0)

g round=16
keep household_id round sw_* ad_*

sa "${tmp_hfps_eth}/subjective_welfare.dta", replace 
