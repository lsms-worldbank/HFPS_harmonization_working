
*	economic sentiment 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*economic_sentiment*", w

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
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	, clear
la li _all
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_economic_sentiment_public.dta"	, clear
la li _all

label_inventory "${raw_hfps_eth}", pre(`"wb_lsms_hfpm_hh_survey_round"') suf(`"_economic_sentiment_public.dta"') vardetail
label_inventory "${raw_hfps_eth}", pre(`"wb_lsms_hfpm_hh_survey_round"') suf(`"_economic_sentiment_public.dta"') vallab
	*	consistent across rounds 

#d ; 
clear; append using 
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_economic_sentiment_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_economic_sentiment_public.dta"	
	, gen(round); 
#d cr
la drop _append
la val round .
replace round = round+13
replace round = round+1 if round>15
 ta round

d eco*
la li eco_1 eco_2 eco_3 eco_4 eco_5 eco_6 eco_7 eco_8 eco_9_events

*	v15 item 
ta eco_9 round,m	//	a string concatenation of the unlabeled codes for rounds 14 & 15 only that has been added in the v15 public release
drop eco_9

tabstat eco_? eco_9_events?, by(group) s(n)
ta eco_1
g sntmnt_last12mohh_label=.
la var sntmnt_last12mohh_label	"Household is financially [...] in past 12 months"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_last12mohh_cat`l' = eco_1==`i' if !mi(eco_1)
	la var sntmnt_last12mohh_cat`l' "`: label eco_1 `i''"
}

ta eco_2 group, m
g sntmnt_next12mohh_label=.
la var sntmnt_next12mohh_label	"Household will be financially [...] in next 12 months"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_next12mohh_cat`l' = eco_2==`i' if !mi(eco_2)
	la var sntmnt_next12mohh_cat`l' "`: label eco_2 `i''"
}

ta eco_3
la li eco_3
g		sntmnt_last12moNtl_label=.
la var	sntmnt_last12moNtl_label	"National economic situation has [...] in past 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_last12moNtl_cat`l' = eco_3==`i' if !mi(eco_3)
	la var sntmnt_last12moNtl_cat`l' "`: label eco_3 `i''"
}

ta eco_4, m
la li eco_4
g		sntmnt_next12moNtl_label=.
la var	sntmnt_next12moNtl_label	"National economic situation will [...] in next 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_next12moNtl_cat`l' = eco_4==`i' if !mi(eco_4)
	la var sntmnt_next12moNtl_cat`l' "`: label eco_4 `i''"
}

ta eco_5, m
la li eco_5
g      sntmnt_last12moPrice_label=.
la var sntmnt_last12moPrice_label	"Prices have [...] in past 12 months"
foreach i of numlist 1(1)4 -98 {
	loc l=abs(`i')
	g      sntmnt_last12moPrice_cat`l' = eco_5==`i' if !mi(eco_5)
	la var sntmnt_last12moPrice_cat`l' "`: label eco_5 `i''"
}


ta eco_6, m
la li eco_6
g      sntmnt_next12moPrice_label=.
la var sntmnt_next12moPrice_label	"Prices will [...] in next 12 months"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_next12moPrice_cat`l' = eco_6==`i' if !mi(eco_6)
	la var sntmnt_next12moPrice_cat`l' "`: label eco_6 `i''"
}

ta eco_7, m
la li eco_7
g      sntmnt_majorpurchase_label=.
la var sntmnt_majorpurchase_label	"The timing is [...] to buy major household items"
foreach i of numlist 1(1)3 -98 {
	loc l=abs(`i')
	g      sntmnt_majorpurchase_cat`l' = eco_7==`i' if !mi(eco_7)
	loc lbl = subinstr("`: label eco_7 `i''"," time","",1)
	la var sntmnt_majorpurchase_cat`l' "`lbl'"
}

ta eco_8, m
la li eco_8
g      sntmnt_weatherrisk_label=.
la var sntmnt_weatherrisk_label	"Financial effects from bad weather events are [...]"
foreach i of numlist 1(1)5 -98 {
	loc l=abs(`i')
	g      sntmnt_weatherrisk_cat`l' = eco_8==`i' if !mi(eco_8)
	la var sntmnt_weatherrisk_cat`l' "`: label eco_8 `i''"
}
ren sntmnt_*_cat98 sntmnt_*_cat97


ta eco_8 eco_9_events1, m	//	skips aren't entirely clear, but looks like specifying an event was optional for the likely/very likely responders 
la li eco_9_events

li eco_9_other if eco_9_events1==-96	//	unusual/unseasonal rainfall
ta eco_9_events1, m
g      sntmnt_weatherevent_label=.
la var sntmnt_weatherevent_label	"Most likely weather event to cause financial effects [...]" 
foreach i of numlist 1(1)5	{
	loc l=abs(`i')
	egen   sntmnt_weatherevent_cat`l' = anymatch(eco_9_events?) if !mi(eco_9_events1), v(`i') 
// 	la var sntmnt_weatherevent_cat`l' "`: label eco_9_events `i''"
}
la var sntmnt_weatherevent_cat1		"Drought"
la var sntmnt_weatherevent_cat2		"Delayed rain"
la var sntmnt_weatherevent_cat3		"Floods"
la var sntmnt_weatherevent_cat4		"Heat"
la var sntmnt_weatherevent_cat5		"Storms"
	
su


d sntmnt_*, f
su sntmnt_*, sep(0)


keep household_id round sntmnt_*
isid household_id round
sort household_id round

sa "${tmp_hfps_eth}/economic_sentiment.dta", replace 
d using "${tmp_hfps_eth}/economic_sentiment.dta",  
