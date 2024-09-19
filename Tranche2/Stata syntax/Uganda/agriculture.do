


dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
// dir "${raw_hfps_uga}/round8", w
// dir "${raw_hfps_uga}/round9", w
// dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
// dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
// dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w

d using	"${raw_hfps_uga}/round1/SEC5A.dta"
d using	"${raw_hfps_uga}/round2/SEC5B.dta"
d using	"${raw_hfps_uga}/round3/SEC5B.dta"
d using	"${raw_hfps_uga}/round4/SEC5B.dta"
d using	"${raw_hfps_uga}/round5/SEC5B.dta"
d using	"${raw_hfps_uga}/round6/SEC5B.dta"		//	pretty different 
d using	"${raw_hfps_uga}/round7/SEC6E_1.dta"
d using	"${raw_hfps_uga}/round7/SEC6E_2.dta"
// d using	"${raw_hfps_uga}/round8/SEC5B.dta"
// d using	"${raw_hfps_uga}/round9/SEC5B.dta"
// d using	"${raw_hfps_uga}/round10/SEC5B.dta"
d using	"${raw_hfps_uga}/round11/SEC17.dta"
// d using	"${raw_hfps_uga}/round12/SEC5B.dta"
d using	"${raw_hfps_uga}/round13/SEC19_1.dta"
d using	"${raw_hfps_uga}/round13/SEC19_2.dta"
// d using	"${raw_hfps_uga}/round14/SEC5B.dta"
d using	"${raw_hfps_uga}/round15/SEC19.dta"

u	"${raw_hfps_uga}/round7/SEC6E_2.dta", clear
ta crop__id
duplicates report hhid
u "${raw_hfps_uga}/round13/SEC19_2.dta", clear
ta fertilizer_type__id




*	there is substantial variation across rounds. We will just go round by round, 
*	but to economize on lines we will save labeling til a grand append at the end

********************************************************************************
{	/*round 1*/
u "${raw_hfps_uga}/round1/SEC5A.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5aq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s5qaq17_1
ta `v5'
la li `v5'

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (`v5'==1) if !mi(`v5')
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (`v5'==2) if !mi(`v5')
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (`v5'==3) if !mi(`v5')
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (`v5'==4) if !mi(`v5')
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'==5) if !mi(`v5')
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'==6) if !mi(`v5')
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'==7) if !mi(`v5')
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'==8) if !mi(`v5')
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
	*	ignore the o/s

*	6	not able to access fertilizer 
loc v6 s5aq23
ta `v6'
la li `v6'
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'==1 | `v6'==2)	if !mi(`v6')
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'==6)	if !mi(`v6') 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
g		ag_nofert_cat3=(`v6'==3 |  `v6'==4)	if !mi(`v6')
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"
g		ag_nofert_cat4=(`v6'==5)	if !mi(`v6')
la var	ag_nofert_cat4	"Increase in price of fertilizer"

*	7	main crops, taking first 
loc v7 s5aq18__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"

keep hhid ag_* cropcode
g round=		  1
tempfile		 r1
sa				`r1'
}	/*	end round 1	*/ 
********************************************************************************


********************************************************************************
{	/*round 2*/
u "${raw_hfps_uga}/round2/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq02_ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'1

g 		cropcode = `v7'1
la var cropcode	"Main crop code"


*	8	harvesting complete
loc v8	s5bq03
ta		`v8'
la li	`v8' 
g		ag_harv_complete = (`v8'==3) if !mi(`v8')
la var	ag_harv_complete	"Harvest of main crop complete"


keep hhid ag_* cropcode
g round=		  2
tempfile		 r2
sa				`r2'
}	/*	end round 2	*/ 
********************************************************************************


********************************************************************************
{	/*round 3*/
u "${raw_hfps_uga}/round3/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	12	harvest expectation ex ante
loc v12 s5bq19
ta `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"

*	13	expected harvest quantity
loc v13 s5bq20
g		ag_anteharv_q		= `v13' 
g		ag_anteharv_u		= `v13'b
g		ag_anteharv_cf		= `v13'c
ta ag_anteharv_cf
destring ag_anteharv_cf, replace force
li `v13'c if mi(ag_anteharv_cf)
tabstat ag_anteharv_cf, by(ag_anteharv_u) s(n me min max)
g		ag_anteharv_kg		= ag_anteharv_q * ag_anteharv_cf

*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"


keep hhid ag_* 
g round=		  3
tempfile		 r3
sa				`r3'
}	/*	end round 3	*/ 
********************************************************************************


********************************************************************************
{	/*round 4*/
u "${raw_hfps_uga}/round4/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq18_ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'1

g 		cropcode = `v7'1
la var cropcode	"Main crop code"



*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"


keep hhid ag_* cropcode
g round=		  4
tempfile		 r4
sa				`r4'
}	/*	end round 4	*/ 
********************************************************************************


********************************************************************************
{	/*round 5*/
u "${raw_hfps_uga}/round5/SEC5B.dta", clear

*	1	hh has grown crops since beginning of agricultural season 
loc v1 s5bq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	7	main crops, taking first 
loc v7 s5bq21a 
ta `v7',	//	round 1 only

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	9	planting complete
loc v9 s5bq21b
g		ag_plant_complete = (`v9'==1)	if !mi(`v9')
la var	ag_plant_complete	"Planting of main crop complete"

*	10 area planted
loc v10	s5bq21c
g		ag_plant_ha = `v10' * 0.40468564224 //	acres
la var	ag_plant_ha	"Hectares planted with main crop"


*	12	harvest expectation ex ante
loc v12	s5bq21d
ta `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"


*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
g		ag_antesale_subj = `v17' if !mi(`v17')
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"


keep hhid ag_* cropcode
g round=		  5
tempfile		 r5
sa				`r5'
}	/*	end round 5	*/ 
********************************************************************************


********************************************************************************
{	/*round 6*/
u "${raw_hfps_uga}/round6/SEC5B.dta", clear

*	15	normally sell
loc v15	s5bq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s5bq24
ta `v17'
la li `v17'
g		ag_antesale_subj = `v17' if !mi(`v17') & `v17'!=-97
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val ag_antesale_subj ag_subjective_assessment


keep hhid ag_* 
g round=		  6
tempfile		 r6
sa				`r6'
}	/*	end round 6	*/ 
********************************************************************************


********************************************************************************
{	/*round 7*/
u "${raw_hfps_uga}/round7/SEC6E_2.dta", clear
u "${raw_hfps_uga}/round7/SEC6E_1.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s6eq16
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s6eq21a__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat1 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat1		"Advised to stay home"
g		ag_nogrow_cat2 = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat3 = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g		ag_nogrow_cat4a = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4c = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'8==1) if !mi(`v5'8)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	

*	7	main crops, taking first 
loc v7 s5bq18__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"


*	10 area planted not available, must merge
d using "${raw_hfps_uga}/round7/SEC6E_2.dta"
g crop__id=cropcode
mer 1:1 hhid crop__id using "${raw_hfps_uga}/round7/SEC6E_2.dta", keep(1 3) nogen
loc v10	s6eq21d
g		ag_plant_ha = `v10' * 0.40468564224 //	acres
la var	ag_plant_ha	"Hectares planted with main crop"


*	12	harvest expectation ex ante
loc v12	s6eq21e
ta `v12'
// tab1 s6eq21f s6eq21g
la li `v12'
g ag_anteharv_subj=`v12'+1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"


*	15	normally sell
loc v15	s6eq23
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	17	Pre-sale subjective assessment
loc v17	s6eq24
ta `v17'
la li `v17'
g		ag_antesale_subj = `v17' if !mi(`v17') & `v17'!=-97
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"


keep hhid ag_* 
g round=		  7
tempfile		 r7
sa				`r7'
}	/*	end round 7	*/ 
********************************************************************************


********************************************************************************
{	/*round 11*/
u "${raw_hfps_uga}/round11/SEC17.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s17q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s17q02__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	
*	6	not able to access fertilizer 
loc v6 s17q03
ta `v6'
la li `v6'
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'==1)	if !mi(`v6')
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'==2)	if !mi(`v6') 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"


*	7	main crops, taking first 
loc v7 s17q04__ 
tab1 `v7'?,	//	round 1 only
tabstat `v7'?, s(count)
la li `v7'0

g 		cropcode = `v7'0
la var cropcode	"Main crop code"


*	11	area comparison to last planting
loc v11 s17q07
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,5)
recode  ag_plant_vs_prior (.=6) if `v11'==-97


*	12	harvest expectation ex ante
loc v12	s17q08
ta `v12'
// tab1 s6eq21f s6eq21g
la li `v12'
g ag_anteharv_subj=`v12'+1
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"

*	19	inorg fertilizer dummy
loc v19 s17q12
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	20	future fertilizer 
loc v20 s17q14
ta `v20'
g		ag_inorgfert_ante = (`v20'==1) if !mi(`v20')
la var	ag_inorgfert_ante	"Intend to apply inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s17q13__
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'11 `v21'12 `v21'13)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'14 `v21'15 `v21'16)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'17 `v21'18)			if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"
loc v21 s17q15__
g		ag_ferttype_ante_label=.
la var	ag_ferttype_ante_label	"Intends to apply [...] fertilizer"
egen	ag_ferttype_ante_cat1 = anymatch(`v21'11 `v21'12 `v21'13)	if ag_inorgfert_ante==1, v(1)
egen	ag_ferttype_ante_cat2 = anymatch(`v21'14 `v21'15 `v21'16)	if ag_inorgfert_ante==1, v(1)
egen	ag_ferttype_ante_cat3 = anymatch(`v21'17 `v21'18)			if ag_inorgfert_ante==1, v(1)
la var	ag_ferttype_ante_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_ante_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_ante_cat3	"Phosphate"

*	23 reason no fertilizer
loc v23 s17q16
ta `v23' 
la li `v23'
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',1,2)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',3)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',4)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"
	*	ignore o/s

*	25 Acquire full amount? 
loc v25 s17q17
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"
	
	
keep hhid ag_* 
g round=		  11
tempfile		 r11
sa				`r11'
}	/*	end round 11	*/ 
********************************************************************************


********************************************************************************
{	/*round 13*/
u "${raw_hfps_uga}/round13/SEC19_1.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s19q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	5	not able to conduct hh ag activities
loc v5 s19q02__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
	
*	6	not able to access fertilizer 
loc v6 s19q03__
tabstat `v6'*, s(n me)
d `v6'*
g		ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g		ag_nofert_cat1=(`v6'1==1)	if !mi(`v6'1)
la var	ag_nofert_cat1	"No supply of fertilizer"
g		ag_nofert_cat2=(`v6'2==1)	if !mi(`v6'2) 
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"


*	7	main crops, taking first 
loc v7 s19q04 
ta `v7',
la li `v7'

g 		cropcode = `v7'
la var cropcode	"Main crop code"


*	9	planting complete	//	unclear that this is referencing a single crop
loc v9 s19q05__
tabstat `v9'?, s(n me)
g		ag_plant_complete = (`v9'1==1)	if !mi(`v9'1)
la var	ag_plant_complete	"Planting of main crop complete"


*	10 area planted
loc v10	s19q06
ta `v10'b
la li `v10'b
ta `v10'b_Other
#d ; 
g		ag_plant_ha = `v10'a * 
	cond(`v10'b==1,0.40468564224,
	cond(`v10'b==2,`v10'a * 0.0001,
	cond(`v10'b==3,`v10'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 

la var	ag_plant_ha	"Hectares planted with main crop"


*	11	area comparison to last planting
loc v11 s19q07
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,5)
recode  ag_plant_vs_prior (.=6) if `v11'==-97
la var ag_plant_vs_prior	"Comparative planting area vs last planting"


*	12	harvest expectation ex ante
loc v12	s19q08
ta `v12'
la li `v12'
g ag_anteharv_subj=`v12'
la var ag_anteharv_subj	"Subjective assessment of harvest ex-ante"

*	13	expected harvest quantity
loc v13	s19q09
ta `v13'b
g		ag_anteharv_q		= `v13'a
g		ag_anteharv_u		= `v13'b
g		ag_anteharv_u_os	= `v13'b_Other
la var	ag_anteharv_q		"Expected harvest quantity"
la var	ag_anteharv_u		"Expected harvest unit"
la var	ag_anteharv_u_os	"Expected harvest unit o/s"


*	15	normally sell
loc v15	s19q10
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"


*	29	price of fertilizer
preserve
u "${raw_hfps_uga}/round13/SEC19_2.dta", clear
ta fertilizer_type__id
la li fertilizer_type__id
recode fertilizer_type__id (11/13=1)(14/16=2)(17/18=3)(else=.), gen(ag_fertcost_type)
g ag_fertcost_q=1
loc unit s19q12c
ta `unit'
la li `unit'
g ag_fertcost_unit=`unit' if `unit'!=-96
recode	ag_fertcost_unit (1=2)(2=1)(3=4)(4=3)(-96=.)	//	harmonize. No o/s is present 
do "${do_hfps_util}/label_fert_unit.do"
la val ag_fertcost_unit fert_unit
recode	ag_fertcost_unit (1 3=1)(2 4=0.001)(else=.), gen(conv)
g		ag_fertcost_kg = ag_fertcost_q * conv

loc lcu  s19q12b
g ag_fertcost_lcu = `lcu'

g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg
keep if !mi(ag_fertcost_type) & !mi(ag_fertcost_unit) & !mi(ag_fertcost_lcu)
cou
duplicates report hhid ag_fertcost_type
duplicates tag hhid ag_fertcost_type, gen(tag)
li if tag>0, sepby(hhid)	//	in all cases, the LCU/unit cost are identical
duplicates drop hhid ag_fertcost_type, force


loc subj s19q13
la li `subj'
g ag_fertcost_subj = `subj'
do "${do_hfps_util}/label_cost_subj.do"
la val ag_fertcost_subj cost_subj
keep hhid ag_fertcost_*
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price ag_fertcost_subj	/*
*/	, i(hhid) j(ag_fertcost_type)

loc lbl1	"Compound"
loc lbl2	"Nitrogen"
loc lbl3	"Phosphate"
forv t=1/3 {
la var ag_fertcost_q`t'		"Quantity, `lbl`t'' fertilizer"
la var ag_fertcost_unit`t'	"Unit, `lbl`t'' fertilizer"
la var ag_fertcost_kg`t'	"Standard quantity, `lbl`t'' fertilizer"
la var ag_fertcost_lcu`t'	"LCU/unit, `lbl`t'' fertilizer"
la var ag_fertcost_price`t'	"Price/standard unit, `lbl`t'' fertilizer"
la var ag_fertcost_subj`t'	"Subjective price change, `lbl`t'' fertilizer"
	}
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid using `fertcost', assert(1 3) nogen


	
keep hhid ag_* crop
g round=		  13
tempfile		 r13
sa				`r13'
}	/*	end round 13	*/ 
********************************************************************************


********************************************************************************
{	/*round 15*/
u "${raw_hfps_uga}/round15/SEC19.dta", clear


*	1	hh has grown crops since beginning of agricultural season 
loc v1 s19q01
ta `v1'
g		ag_refperiod_yn = (`v1'==1) if !mi(`v1')
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"

*	2	able to farm normally 
loc v2	s19q04
ta `v2'
g		ag_normal_yn = (`v2'==1) if !mi(`v2')
la var	ag_normal_yn	"Able to conduct agricultural activies normally"

*	3	reason respondent not able to conduct normal farming activities
loc v3 s19q02
ta `v3'
la li `v3'

g		ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
// g		ag_resp_no_farm_cat1 = (s6q17_1__1==1) if !mi(s6q17_1__1)
// la var	ag_resp_no_farm_cat1		"Advised to stay home"
g		ag_resp_no_farm_cat2 = (`v3'==1) if !mi(`v3')
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
// g		ag_resp_no_farm_cat3 = (s6q17_1__3==1) if !mi(s6q17_1__3)
// la var	ag_resp_no_farm_cat3		"Restrictions on movement / travel"
g		ag_resp_no_farm_cat4 = (inlist(`v3',2,3,4)) if !mi(`v3')
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
g		ag_resp_no_farm_cat5 = (`v3'==5) if !mi(`v3')
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
g		ag_resp_no_farm_cat6 = (`v3'==6) if !mi(`v3')
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
g		ag_resp_no_farm_cat7 = (`v3'==11) if !mi(`v3')
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
g		ag_resp_no_farm_cat8 = (inlist(`v3',7,8)) if !mi(`v3')
la var	ag_resp_no_farm_cat8		"Climate"
g		ag_resp_no_farm_cat9 = (`v3'==9) if !mi(`v3')
la var	ag_resp_no_farm_cat9		"Pests"
g		ag_resp_no_farm_cat10= (`v3'==10) if !mi(`v3')
la var	ag_resp_no_farm_cat10		"Insecurity"

*	4	total cultivated area
loc v4 s19q06
la li `v4'b
#d ; 
g		ag_total_ha = `v4'a * 
	cond(`v4'b==1,0.40468564224,
	cond(`v4'b==2,`v4'a * 0.0001,
	cond(`v4'b==3,`v4'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 
la var ag_total_ha	"Total area under all crops (ha)"

*	5	not able to conduct hh ag activities
loc v5 s19q05__
d `v5'*
tabstat `v5'*
la li `v5'1

g		ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g		ag_nogrow_cat2 = (`v5'1==1) if !mi(`v5'1)
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g		ag_nogrow_cat4a = (`v5'2==1) if !mi(`v5'2)
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g		ag_nogrow_cat4b = (`v5'3==1) if !mi(`v5'3)
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g		ag_nogrow_cat4c = (`v5'4==1) if !mi(`v5'4)
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g		ag_nogrow_cat5 = (`v5'5==1) if !mi(`v5'5)
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g		ag_nogrow_cat6 = (`v5'6==1) if !mi(`v5'6)
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g		ag_nogrow_cat7 = (`v5'7==1) if !mi(`v5'7)
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
	*	ignore the o/s
egen	ag_nogrow_cat8 = rowmax(`v5'7 `v5'8) if !mi(`v5'7)
la var	ag_nogrow_cat8		"Climate"
g		ag_nogrow_cat9 = (`v5'9==1) if !mi(`v5'9)
la var	ag_nogrow_cat9		"Pests"
g		ag_nogrow_cat10= (`v5'10==1) if !mi(`v5'10)
la var	ag_nogrow_cat10		"Insecurity"
	
*	6	not able to access fertilizer 
loc v6 s19q03
ta `v6'	//	no obs 


*	7	main crops, taking first 
loc v7 s19q07 
ta `v7',
la li `v7'

g 		cropcode = `v7'
la var cropcode	"Main crop code"




*	10 area planted
loc v10	s19q08
ta `v10'b
la li `v10'b
#d ; 
g		ag_plant_ha = `v10'a * 
	cond(`v10'b==1,0.40468564224,
	cond(`v10'b==2,`v10'a * 0.0001,
	cond(`v10'b==3,`v10'a * 0.000009290304,
		.)));
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 

la var	ag_plant_ha	"Hectares planted with main crop"


*	11	area comparison to last planting
loc v11 s19q09
ta `v11'
la li `v11'
g ag_plant_vs_prior=`v11' if inrange(`v11',1,6)
la var ag_plant_vs_prior	"Comparative planting area vs last planting"


*	12	harvest expectation ex post
loc v12	s19q11
ta `v12'
la li `v12'
g		ag_postharv_subj=`v12'
la var	ag_postharv_subj	"Subjective assessment of harvest ex-post"

*	14	completed harvest quantity
loc v14	s19q10
ta `v14'b
g		ag_postharv_q		= `v14'a
g		ag_postharv_u		= `v14'b
la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"


*	15	normally sell
loc v15	s19q12
ta `v15'
la li `v15'
g		ag_sale_typical	= (`v15'==1) if !mi(`v15')
la var	ag_sale_typical		"Main crop is typically marketed"

*	16	current marketing
loc v16	s19q13
ta `v16'
la li `v16'
g		ag_sale_current = (`v16'==1) if !mi(`v16')
la var	ag_sale_current		"Main crop marketed this season"


*	17a	Post-sale subjective assessment
loc v17	s19q14
ta `v17'
la li `v17'
g		ag_postsale_subj = `v17' if !mi(`v17')
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"

*	18	Reasoning for subjective assessment of sales
ta s19q15 s19q14,m
loc v18	s19q15
ta `v18'
la li `v18'	
/*
         -96 Other specify
           1 Harvested more
           2 Harvested less
           3 Sold higher quantities
           4 Sold lower quantities
           5 Incured higher production costs
           6 Incureed lower production costs
           7 Prices were higher
           8 Prices were lower
           9 Sold them in the main market instead of farmgate
          10 Sold them at farmgate  instead of the main market inst


*/

g		ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
forv i=1/10 {
g		ag_salesubj_why_cat`i' = (`v18'==`i') if !mi(`v18')
la var	ag_salesubj_why_cat`i'	"`: label `v18' `i''"
}

*	19	inorg fertilizer dummy
loc v19 s19q16
ta `v19'
g		ag_inorgfert_post = (`v19'==1) if !mi(`v19')
la var	ag_inorgfert_post		"Applied any inorganic fertilizer this season"

*	21	fertilizer types
loc v21 s19q18__
la li `v21'1
d `v21'*
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'1 `v21'3 `v21'4)	if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'2 `v21'5 `v21'6)	if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"

*	22	fertilizer applied quantity
loc v22	s19q20
ta `v22'b
g		ag_fertpost_tot_q		= `v22'a
g		ag_fertpost_tot_unit	= `v22'b
recode	ag_fertpost_tot_unit (1=2)(2=1)(3=4)(4=3)	//	harmonize
recode	ag_fertpost_tot_unit (1 3=1)(2 4=0.001), gen(conv)	//	harmonize
g		ag_fertpost_tot_kg = ag_fertpost_tot_q * conv
drop conv
la var	ag_fertpost_tot_q	"Total quantity of fertilizer applied on all plots"
la var	ag_fertpost_tot_unit	"Unit for fertilizer applied on all plots"
la var	ag_fertpost_tot_kg	"Standard quantity for fertilizer applied on all plots"

*	23 reason no [input]
loc v23 s19q17
ta `v23'
la li `v23'
g		ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g 		ag_inorgfert_no_cat1 = (inlist(`v23',1,2)) if !mi(`v23')
la var	ag_inorgfert_no_cat1	"Did not need"
g 		ag_inorgfert_no_cat2 = (inlist(`v23',3)) if !mi(`v23')
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g 		ag_inorgfert_no_cat3 = (inlist(`v23',4)) if !mi(`v23')
la var	ag_inorgfert_no_cat3	"Not available"


*	24	fertilizer acquired quantity
loc v24	s19q19
ta `v24'b
g		ag_fertpurch_tot_q		= `v24'a
g		ag_fertpurch_tot_unit	= `v24'b
recode	ag_fertpurch_tot_unit (1=2)(2=1)(3=4)(4=3)	//	harmonize
recode	ag_fertpurch_tot_unit (1 3=1)(2 4=0.001), gen(conv)	//	convert to kg/l 
g		ag_fertpurch_tot_kg = ag_fertpurch_tot_q * conv
drop conv
la var	ag_fertpurch_tot_q		"Total quantity of fertilizer acquired"
la var	ag_fertpurch_tot_unit	"Unit for fertilizer acquired for all plots"
la var	ag_fertpurch_tot_kg		"Standard quantity for fertilizer acquired"

*	25 Acquire full amount? 
loc v25 s19q21
ta `v25' 
g		ag_fertilizer_fullq = (`v25'==1) if !mi(`v25')
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"

*	26	fertilizer desired quantity
loc v26	s19q23
ta `v26'b
g		ag_fertpurch_ante_q		= `v26'a
g		ag_fertpurch_ante_unit	= `v26'b
recode	ag_fertpurch_ante_unit (1=2)(2=1)(3=4)(4=3)	//	harmonize
recode	ag_fertpurch_ante_unit (1 3=1)(2 4=0.001), gen(conv)	//	convert to kg/l 
g		ag_fertpurch_ante_kg = ag_fertpurch_ante_q * conv
drop conv
la var	ag_fertpurch_ante_q		"Total quantity of fertilizer still desired"
la var	ag_fertpurch_ante_unit	"Unit for fertilizer still desired on all plots"
la var	ag_fertpurch_ante_kg	"Standard quantity for fertilizer still desired"

*	27	reason couldn't acquire fertilizer
loc v27	s19q24
ta `v27'
la li `v27'
g		ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
g 		ag_fert_partial_cat2 = (inlist(`v27',2)) if !mi(`v27')
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
g 		ag_fert_partial_cat3 = (inlist(`v27',1,3)) if !mi(`v27')
la var	ag_fert_partial_cat3	"Not available"


*	28	Adaptations for fertilizer issue
loc v28 s19q22__
d `v28'*
g		ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_nofert_adapt_cat4=(`v28'3==1) if !mi(`v28'3) 
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_nofert_adapt_cat5=(`v28'4==1) if !mi(`v28'4)
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"
g		ag_nofert_adapt_cat6=(`v28'2==1) if !mi(`v28'2)
la var	ag_nofert_adapt_cat6	"Changed crop type"
g		ag_nofert_adapt_cat7=(`v28'1==1) if !mi(`v28'1)
la var	ag_nofert_adapt_cat7	"Just planted without fertilizer"

loc v28 s19q25__
d `v28'*
g		ag_partialfert_adapt_label=.
la var	ag_partialfert_adapt_label	"Adapted to inorganic fertilizer limitation by [...]"
g		ag_partialfert_adapt_cat1=(`v28'1==1) if !mi(`v28'1)
la var	ag_partialfert_adapt_cat1	"Only fertilized part of cultivated area"
g		ag_partialfert_adapt_cat2=(`v28'2==1) if !mi(`v28'2)
la var	ag_partialfert_adapt_cat2	"Used lower rate of fertilizer"
g		ag_partialfert_adapt_cat3=(`v28'3==1) if !mi(`v28'3)
la var	ag_partialfert_adapt_cat3	"Cultivated a smaller area"
g		ag_partialfert_adapt_cat4=(`v28'4==1) if !mi(`v28'4)
la var	ag_partialfert_adapt_cat4	"Supplemented with organic fertilizer"
g		ag_partialfert_adapt_cat5=(`v28'5==1) if !mi(`v28'5)
la var	ag_partialfert_adapt_cat5	"Practiced legume intercropping"


*	29	price of fertilizer
preserve
u "${raw_hfps_uga}/round15/SEC19_2.dta", clear
ta fertilizer_type__id
la li fertilizer_type__id
recode fertilizer_type__id (1 3=1)(2 5 6=2)(4=3)(else=.), gen(ag_fertcost_type)
g ag_fertcost_q=1
loc unit s19q26c
ta `unit'
la li `unit'
g ag_fertcost_unit=`unit' if `unit'!=-96
recode	ag_fertcost_unit (1=2)(2=1)(3=4)(4=3)(-96=.)	//	harmonize. No o/s is present 
do "${do_hfps_util}/label_fert_unit.do"
la val ag_fertcost_unit fert_unit
recode	ag_fertcost_unit (1 3=1)(2 4=0.001)(else=.), gen(conv)
g		ag_fertcost_kg = ag_fertcost_q * conv

loc lcu  s19q26b
g ag_fertcost_lcu = `lcu'

g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg
keep if !mi(ag_fertcost_type) & !mi(ag_fertcost_unit) & !mi(ag_fertcost_lcu)
cou
duplicates report hhid ag_fertcost_type
duplicates tag hhid ag_fertcost_type, gen(tag)
li if tag>0, sepby(hhid)	//	in all cases, the LCU/unit cost are identical
duplicates drop hhid ag_fertcost_type, force

loc subj s19q27
la li `subj'
g ag_fertcost_subj = `subj'
do "${do_hfps_util}/label_cost_subj.do"
la val ag_fertcost_subj cost_subj
keep hhid ag_fertcost_*
reshape wide ag_fertcost_q ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_price ag_fertcost_subj	/*
*/	, i(hhid) j(ag_fertcost_type)

loc lbl1	"Compound"
loc lbl2	"Nitrogen"
loc lbl3	"Phosphate"
forv t=1/2 {
la var ag_fertcost_q`t'		"Quantity, `lbl`t'' fertilizer"
la var ag_fertcost_unit`t'	"Unit, `lbl`t'' fertilizer"
la var ag_fertcost_kg`t'	"Standard quantity, `lbl`t'' fertilizer"
la var ag_fertcost_lcu`t'	"LCU/unit, `lbl`t'' fertilizer"
la var ag_fertcost_price`t'	"Price/standard unit, `lbl`t'' fertilizer"
la var ag_fertcost_subj`t'	"Subjective price change, `lbl`t'' fertilizer"
	}
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid using `fertcost', assert(1 3) nogen


	
keep hhid ag_* crop
g round=		  15
tempfile		 r15
sa				`r15'
}	/*	end round 15	*/ 
********************************************************************************





#d ; 
clear; append using `r1' `r2' `r3' `r4' `r5' `r6' `r7' `r11' `r13' `r15'; 
#d cr 

isid hhid round
ta round

do "${do_hfps_util}/label_ag_subjective_assessment.do"
la val	ag_????sale_subj ag_????harv_subj ag_subjective_assessment
do "${do_hfps_util}/label_ag_plant_vs_prior.do"
la val ag_plant_vs_prior ag_plant_vs_prior


// keep  hhid round item itemstr item_avail unitstr price unitcost 
// order hhid round item itemstr item_avail unitstr price unitcost
isid  hhid round 
sort  hhid round 
sa "${tmp_hfps_uga}/panel/agriculture.dta", replace 
u  "${tmp_hfps_uga}/panel/agriculture.dta", clear 
 




