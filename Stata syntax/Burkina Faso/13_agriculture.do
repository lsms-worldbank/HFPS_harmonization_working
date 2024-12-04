
*	two separate directories for phase 1 & 2
dir "${raw_lsms_bfa}", w
d using "${raw_lsms_bfa}/s07b_me_bfa2018.dta"
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/*prix*.dta", w


d using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d using	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6d_emplrev_agr.dta"		
d using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		

d using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
d using	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"		

u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear	
u	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"			, clear
u	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"			, clear
la li s06q14
u	"${raw_hfps_bfa}/r4_sec6d_emplrev_agr.dta"			, clear
u	"${raw_hfps_bfa}/r6_sec6d_emplrev_agr.dta"			, clear
u	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"			, clear

u	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		, clear
la li s06d1q13b
tab1  s06d1q13b__*
u	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"	, clear
la li s06d1q10b s06d1q10c
la li s06d1q26b	//	will assume that sac = 50 kg sac
tab1  s06d1q26b__*


#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r4_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r6_sec6d_emplrev_agr.dta"		
	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		

	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
	
	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"
	, gen(round); 
	la drop _append; la val round .; 
#d cr
isid hhid round
replace round=round+1 if round>4
replace round=round+4 if round>6
replace round=round+4 if round>11
replace round=round+4 if round>16

ta round

*	1	hh has grown crops since beginning of agricultural season 
tab2 round s06q01 s06q14 s06dq01 s06d1q00 s06d1q01, first
g byte	ag_refperiod_yn = (s06q14==1) if !mi(s06q14)
replace	ag_refperiod_yn = (s06dq01==1) if !mi(s06dq01)
replace	ag_refperiod_yn = (s06d1q00==1) if !mi(s06d1q00)
replace	ag_refperiod_yn = (s06d1q01==1) if !mi(s06d1q01)
la var	ag_refperiod_yn	"Since the beginning of the agricultural season, have you or any member of your household grown crops?"


*	2	able to farm normally 
tab2 round s06q15 s06d1q04, first

g byte	ag_normal_yn = (s06q15==1) if !mi(s06q15) & inlist(round,1,2)
replace	ag_normal_yn = (s06d1q14==1) if !mi(s06d1q14) & inlist(round,21)
la var	ag_normal_yn	"Able to conduct agricultural activies normally"


*	3	reason respondent not able to conduct normal farming activities
tab2 round s06q16__1 s06d1q05__1, first	//	per Yanneck, take for rounds 1&2 only. 
	*	per the survey instrument, round 3 q 16 should be crop codes, 
	*	presumably these s06q16__* values were pre-loaded into round 3 
loc v3 s06q16__
tabstat `v3'*, by(round) s(sum)
d `v3'* using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d `v3'* using	"${raw_hfps_bfa}/r2_sec6d_emplrev_agr.dta"		

g byte	ag_resp_no_farm_label=.
la var	ag_resp_no_farm_label	"Respondent did not farm normally because [...]"
g byte	ag_resp_no_farm_cat1 = (`v3'1==1) if !mi(`v3'1) & inlist(round,1,2)
g byte	ag_resp_no_farm_cat2 = (`v3'2==1) if !mi(`v3'2) & inlist(round,1,2)
g byte	ag_resp_no_farm_cat3 = (`v3'3==1) if !mi(`v3'3) & inlist(round,1,2)
g byte	ag_resp_no_farm_cat4 = (`v3'4==1) if !mi(`v3'4) & inlist(round,1,2)
g byte	ag_resp_no_farm_cat5 = (`v3'5==1) if !mi(`v3'5) & round==1
replace	ag_resp_no_farm_cat5 = (`v3'7==1) if !mi(`v3'7) & round==2
g byte	ag_resp_no_farm_cat6 = (`v3'6==1) if !mi(`v3'6) & round==1
replace	ag_resp_no_farm_cat6 = (`v3'8==1) if !mi(`v3'8) & round==2
g byte	ag_resp_no_farm_cat7 = (`v3'7==1) if !mi(`v3'7)  & round==1
replace	ag_resp_no_farm_cat7 = (`v3'9==1) if !mi(`v3'9)  & round==2
g byte	ag_resp_no_farm_cat8 = (`v3'11==1) if !mi(`v3'11) & round==2

loc v3 s06d1q05__
tabstat `v3'*, by(round) s(sum)
d `v3'* using	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"		

replace	ag_resp_no_farm_cat2  = (`v3'1==1)	if !mi(`v3'1)	& round==21
replace	ag_resp_no_farm_cat4  = (`v3'2==1 | `v3'3==1 | `v3'4==1)	if !mi(`v3'2,`v3'3,`v3'4)	& round==21
g byte	ag_resp_no_farm_cat4a = (`v3'2==1)	if !mi(`v3'2)	& round==21
g byte	ag_resp_no_farm_cat4b = (`v3'3==1)	if !mi(`v3'3)	& round==21
g byte	ag_resp_no_farm_cat4c = (`v3'4==1)	if !mi(`v3'4)	& round==21
replace	ag_resp_no_farm_cat5  = (`v3'5==1)	if !mi(`v3'5)	& round==21
replace	ag_resp_no_farm_cat6  = (`v3'6==1)	if !mi(`v3'6)	& round==21
replace	ag_resp_no_farm_cat7  = (`v3'11==1)	if !mi(`v3'11)	& round==21
replace	ag_resp_no_farm_cat8  = (`v3'7==1 | `v3'8==1)	if !mi(`v3'7,`v3'8)	& round==21
g byte	ag_resp_no_farm_cat9  = (`v3'9==1)	if !mi(`v3'9)	& round==21
g byte	ag_resp_no_farm_cat10 = (`v3'10==1)	if !mi(`v3'10)	& round==21


la var	ag_resp_no_farm_cat1		"Advised to stay home"
la var	ag_resp_no_farm_cat2		"Reduced availability of hired labor"
la var	ag_resp_no_farm_cat3		"Restrictions on movement / travel"
la var	ag_resp_no_farm_cat4		"Unable to acquire / transport inputs"
la var	ag_resp_no_farm_cat4a		"Unable to acquire / transport seeds"
la var	ag_resp_no_farm_cat4b		"Unable to acquire / transport fertilizer"
la var	ag_resp_no_farm_cat4c		"Unable to acquire / transport other inputs"
la var	ag_resp_no_farm_cat5		"Unable to sell / transport outputs"
la var	ag_resp_no_farm_cat6		"Ill / need to care for ill family member"
la var	ag_resp_no_farm_cat7		"Delayed planting / not yet planting season"
la var	ag_resp_no_farm_cat8		"Climate"
la var	ag_resp_no_farm_cat9		"Pests"
la var	ag_resp_no_farm_cat10		"Insecurity"


*	5	not able to conduct hh ag activities
d s06q15_1__*	//	r3
d s06dq02__*	//	r11
d s06d1q01__*	//	r16
d s06q15_1__*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d s06dq02__*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d s06d1q01__*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
d s06d1q05__*	using	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"

loc v5r03	s06q15_1__
loc v5r11	s06dq02__
loc v5r16	s06d1q01__
loc v5r21	s06d1q05__
d  `v5r03'*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d  `v5r11'*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d  `v5r16'*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"		
g byte	ag_nogrow_label=.
la var	ag_nogrow_label	"Household did not grow crops because [...]"
g byte	ag_nogrow_cat1 = (`v5r03'1==1) if !mi(`v5r03'1) & round== 3
replace	ag_nogrow_cat1 = (`v5r11'1==1) if !mi(`v5r11'1) & round==11
la var	ag_nogrow_cat1		"Advised to stay home"
g byte	ag_nogrow_cat2 = (`v5r03'2==1) if !mi(`v5r03'2) & round== 3
replace	ag_nogrow_cat2 = (`v5r11'2==1) if !mi(`v5r11'2) & round==11
replace	ag_nogrow_cat2 = (`v5r16'1==1) if !mi(`v5r16'1) & round==16
replace	ag_nogrow_cat2 = (`v5r21'1==1) if !mi(`v5r21'1) & round==21
la var	ag_nogrow_cat2		"Reduced availability of hired labor"
g byte	ag_nogrow_cat3 = (`v5r03'3==1) if !mi(`v5r03'3) & round== 3
replace	ag_nogrow_cat3 = (`v5r11'3==1) if !mi(`v5r11'3) & round==11
la var	ag_nogrow_cat3		"Restrictions on movement / travel"
g byte	ag_nogrow_cat4a = (`v5r03'4==1) if !mi(`v5r03'4) & round== 3
replace	ag_nogrow_cat4a = (`v5r11'4==1) if !mi(`v5r11'4) & round==11
replace	ag_nogrow_cat4a = (`v5r16'2==1) if !mi(`v5r16'2) & round==16
replace	ag_nogrow_cat4a = (`v5r21'2==1) if !mi(`v5r21'2) & round==21
la var	ag_nogrow_cat4a		"Unable to acquire / transport seeds"
g byte	ag_nogrow_cat4b = (`v5r03'5==1) if !mi(`v5r03'5) & round== 3
replace	ag_nogrow_cat4b = (`v5r11'5==1) if !mi(`v5r11'5) & round==11
replace	ag_nogrow_cat4b = (`v5r16'3==1) if !mi(`v5r16'3) & round==16
replace	ag_nogrow_cat4b = (`v5r21'3==1) if !mi(`v5r21'3) & round==21
la var	ag_nogrow_cat4b		"Unable to acquire / transport fertilizer"
g byte	ag_nogrow_cat4c = (`v5r03'6==1) if !mi(`v5r03'6) & round== 3
replace	ag_nogrow_cat4c = (`v5r11'6==1) if !mi(`v5r11'6) & round==11
replace	ag_nogrow_cat4c = (`v5r16'4==1) if !mi(`v5r16'4) & round==16
replace	ag_nogrow_cat4c = (`v5r21'4==1) if !mi(`v5r21'4) & round==21
la var	ag_nogrow_cat4c		"Unable to acquire / transport other inputs"
egen	ag_nogrow_cat4 = rowmax(ag_nogrow_cat4a ag_nogrow_cat4b ag_nogrow_cat4c)
la var	ag_nogrow_cat4		"Unable to acquire / transport inputs"
g byte	ag_nogrow_cat5 = (`v5r03'7==1) if !mi(`v5r03'7) & round== 3
replace	ag_nogrow_cat5 = (`v5r11'7==1) if !mi(`v5r11'7) & round==11
replace	ag_nogrow_cat5 = (`v5r21'5==1) if !mi(`v5r21'5) & round==21
la var	ag_nogrow_cat5		"Unable to sell / transport outputs"
g byte	ag_nogrow_cat6 = (`v5r03'8==1) if !mi(`v5r03'8) & round== 3
replace	ag_nogrow_cat6 = (`v5r11'8==1) if !mi(`v5r11'8) & round==11
replace	ag_nogrow_cat6 = (`v5r16'5==1) if !mi(`v5r16'5) & round==16
replace	ag_nogrow_cat6 = (`v5r21'6==1) if !mi(`v5r21'6) & round==21
la var	ag_nogrow_cat6		"Ill / need to care for ill family member"
g byte	ag_nogrow_cat7 = (`v5r03'9==1) if !mi(`v5r03'9) & round== 3
replace	ag_nogrow_cat7 = (`v5r11'9==1) if !mi(`v5r11'9) & round==11
replace	ag_nogrow_cat7 = (`v5r21'11==1) if !mi(`v5r21'11) & round==21
la var	ag_nogrow_cat7		"Delayed planting / not yet planting season"
g byte	ag_nogrow_cat8 = (`v5r21'7==1) if !mi(`v5r21'7) & round==21
replace	ag_nogrow_cat8 = (`v5r21'8==1) if !mi(`v5r21'8) & round==21
la var	ag_nogrow_cat8		"Climate"
g byte	ag_nogrow_cat9 = (`v5r21'9==1) if !mi(`v5r21'9) & round==21
la var	ag_nogrow_cat9		"Pests"

g byte	ag_nogrow_cat10= (`v5r16'6==1) if !mi(`v5r16'6) & round==16
replace	ag_nogrow_cat10= (`v5r21'10==1) if !mi(`v5r21'10) & round==21
la var	ag_nogrow_cat10		"Insecurity"
	*	ignore the o/s

*	6	not able to access fertilizer 
loc v6r03	s06q20__
loc v6r11	s06dq04_1__
loc v6r16	s06d1q02
loc v6r21	s06d1q03
d  `v6r03'*	using	"${raw_hfps_bfa}/r3_sec6d_emplrev_agr.dta"		
d  `v6r11'*	using	"${raw_hfps_bfa}/r11_sec6d_emplrev_agr.dta"		
d  `v6r16'*	using	"${raw_hfps_bfa}/r16_sec6d1_agriculture.dta"
d  `v6r21'*	using	"${raw_hfps_bfa}/r21_sec6c_emplrev_agriculture.dta"
la li 	`v6r16'
la li 	`v6r21'
ta `v6r21' if round==21, nol
g byte	ag_nofert_label=.
la var	ag_nofert_label	"Household could not access/transport fertilizer because [...]"
g byte	ag_nofert_cat1=(`v6r03'1==1 | `v6r03'2==1) if !mi(`v6r03'1,`v6r03'2) & round== 3
replace	ag_nofert_cat1=(`v6r11'1==1 | `v6r11'2==1) if !mi(`v6r11'1,`v6r11'2) & round==11
replace	ag_nofert_cat1=(inlist(`v6r16',1,3)) if !mi(`v6r16') & round==16
replace	ag_nofert_cat1=(inlist(`v6r21',1)) if !mi(`v6r21') & round==21
la var	ag_nofert_cat1	"No supply of fertilizer"
g byte	ag_nofert_cat2=(`v6r03'6==1) if !mi(`v6r03'6) & round== 3 
replace	ag_nofert_cat2=(`v6r11'6==1) if !mi(`v6r11'6) & round==11 
replace	ag_nofert_cat2=(inlist(`v6r16',2)) if !mi(`v6r16') & round==16
replace	ag_nofert_cat2=(inlist(`v6r21',2)) if !mi(`v6r21') & round==21
la var	ag_nofert_cat2	"Too expensive / not enough money to buy"
g byte	ag_nofert_cat3=(`v6r03'3==1 | `v6r03'4==1) if !mi(`v6r03'3,`v6r03'4) & round== 3
replace	ag_nofert_cat3=(`v6r11'3==1 | `v6r11'4==1) if !mi(`v6r11'3,`v6r11'4) & round==11
replace	ag_nofert_cat3=(inlist(`v6r21',3)) if !mi(`v6r21') & round==21
la var	ag_nofert_cat3	"Unable to travel / transport fertilizer"
g byte	ag_nofert_cat4=(`v6r03'5==1) if !mi(`v6r03'5) & round== 3
replace	ag_nofert_cat4=(`v6r11'5==1) if !mi(`v6r11'5) & round==11
la var	ag_nofert_cat4	"Increase in price of fertilizer"
	*	ignore the o/s
	
*	7	main crop 
la li s06d1q03
la li s06d1q07
tab2 round s06d1q03 s06d1q07, first m

g long	cropcode=s06d1q03 if round==16
replace	cropcode=s06d1q07 if round==21
la var cropcode	"Main crop code"


*	8	harvest complete
loc v8 s06d1q05
ta round `v8'
g		ag_harv_complete = (`v8'==1)		if round==16  & !mi(`v8')

*	10 area planted
loc v10	s06d1q08
ta round `v10'b
la li `v10'b
#d ; 
g		ag_plant_ha = `v10'a * 
	cond(`v10'b==1,`v10'a,
	cond(`v10'b==2,`v10'a * 0.0001,
		.)) if round==21;
#d cr	//	assuming these length units are meant to capture one side, so we square them and then convert squared to hectares 

la var	ag_plant_ha	"Hectares planted with main crop"


*	11	area comparison to last planting
loc v11r16	s06d1q04
ta  round	`v11r16'
la li		`v11r16'
loc v11r21	s06d1q09
ta  round	`v11r21'
la li		`v11r21'
g byte	ag_plant_vs_prior=`v11r16' if round==16
replace	ag_plant_vs_prior=`v11r21' if round==21
recode	ag_plant_vs_prior (min/0 7/max=6)
la var  ag_plant_vs_prior	"Comparative planting area vs last planting"

do "${do_hfps_util}/label_ag_plant_vs_prior.do"
la val ag_plant_vs_prior  ag_plant_vs_prior


*	12	harvest expectation ex post
loc		 v12r21	s06d1q11
ta		`v12r21' round
la li	`v12r21'
g byte	ag_postharv_subj=`v12r21' if round==21
la var	ag_postharv_subj	"Subjective assessment of harvest ex-post"

do "${do_hfps_util}/label_ag_subjective_assessment.do"
la val	ag_postharv_subj  ag_subjective_assessment


*	14	actual harvest quantity
loc v14r06	s06dq07
loc v14r21	s06d1q10
tab2 round	`v14r06'b `v14r06'c, first
d			`v14r06'*
d			`v14r21'*
la li		`v14r06'b `v14r21'b
la li		`v14r06'c `v14r21'c	
g		ag_postharv_q		= `v14r06'a			if round==6
g		ag_postharv_u		= `v14r06'b			if round==6
g		ag_postharv_u_os	= `v14r06'b_autre	if round==6
g		ag_postharv_c		= `v14r06'c			if round==6

replace	ag_postharv_q		= `v14r21'a			if round==21
replace	ag_postharv_u		= `v14r21'b			if round==21 
replace	ag_postharv_u_os	= `v14r21'b_autre	if round==21
replace	ag_postharv_c		= `v14r21'c			if round==21
recode ag_postharv_u (7=96)	//	harmonize the o/s 
recode ag_postharv_c (5=.)	//	set the N/A = missing to match the r6 

la var	ag_postharv_q		"Completed harvest quantity"
la var	ag_postharv_u		"Completed harvest unit"
la var	ag_postharv_u_os	"Completed harvest unit o/s"
la var	ag_postharv_c		"Completed harvest condition"

*	15	normally sell
tab2 round s06q15 s06dq05,first m
loc v15r04	s06q15
loc v15r11	s06dq05
loc v15r21	s06d1q12
tab2 round `v15r04' `v15r11' `v15r21',first m
*	Yannick calls for this variable in round 16 but I am failing to find it? 
g byte	ag_sale_typical	= (`v15r04'==1) if !mi(`v15r04') & inlist(round,4)
replace ag_sale_typical = (`v15r11'==1) if !mi(`v15r11') & round==11
replace ag_sale_typical = (`v15r21'==1) if !mi(`v15r21') & round==21
la var	ag_sale_typical		"Main crop is typically marketed"
	
	
*	16	current marketing
loc v16r21	s06d1q12
ta `v16r21'
la li `v16r21'
g byte	ag_sale_current = (`v16r21'==1) if !mi(`v16r21') & round==21
la var	ag_sale_current		"Main crop marketed this season"


*	17	Pre-sale subjective assessment
tab2 round s06q16 s06dq11 s06dq06 s06d1q14, first
g byte	ag_antesale_subj = s06q16 if round==4
replace	ag_antesale_subj = s06dq11 if round==6
replace	ag_antesale_subj = s06dq06 if round==11
replace	ag_antesale_subj = s06d1q14 if round==21
la var	ag_antesale_subj	"Subjective assessment of expected sales revenues"
la val	ag_antesale_subj ag_subjective_assessment

*	17a	Post-sale subjective assessment
tab2 round s06dq13 s06d1q07, first
g		ag_postsale_subj = s06dq13 if round==6
replace	ag_postsale_subj = s06d1q07 if round==16
la var	ag_postsale_subj	"Subjective assessment of completed sales revenues"
la val	ag_postsale_subj ag_subjective_assessment

*	18	Reasoning for subjective assessment of sales
ta round s06d1q15,m
ta s06d1q15 s06d1q14 if round==21,m	//	meaning is unclear when s06d1q14==3. WIll ignore these, consistent with other rounds
loc v18	s06d1q15
ta `v18'
/*	emulating code structure from Uganda*/
g byte	ag_salesubj_why_label=.
la var	ag_salesubj_why_label	"Sales revenues were [good/bad] because [...]"
g byte	ag_salesubj_why_cat1	= (`v18'==11 & inlist(ag_postsale_subj,1,2))	if inlist(ag_postsale_subj,1,2,4,5) & round==21
g byte	ag_salesubj_why_cat2	= (`v18'==12 & inlist(ag_postsale_subj,4,5))	if inlist(ag_postsale_subj,1,2,4,5) & round==21
g byte	ag_salesubj_why_cat3	= (`v18'==21 & inlist(ag_postsale_subj,1,2))	if inlist(ag_postsale_subj,1,2,4,5) & round==21
g byte	ag_salesubj_why_cat4	= (`v18'==22 & inlist(ag_postsale_subj,4,5))	if inlist(ag_postsale_subj,1,2,4,5) & round==21
g byte	ag_salesubj_why_cat5	= (`v18'==3 & inlist(ag_postsale_subj,1,2))		if inlist(ag_postsale_subj,1,2,4,5) & round==21
	//	cat 6 not coded 
g byte	ag_salesubj_why_cat7	= (`v18'==4 & inlist(ag_postsale_subj,1,2))		if inlist(ag_postsale_subj,1,2,4,5) & round==21
	//	cat 8 not coded 
g byte	ag_salesubj_why_cat9	= (`v18'==5 & inlist(ag_postsale_subj,1,2))		if inlist(ag_postsale_subj,1,2,4,5) & round==21
	//	cat 10 not coded 

la var	ag_salesubj_why_cat1	"Harvested more"
la var	ag_salesubj_why_cat2	"Harvested less"
la var	ag_salesubj_why_cat3	"Sold higher quantities"
la var	ag_salesubj_why_cat4	"Sold lower quantities"
la var	ag_salesubj_why_cat5	"Incured higher production costs"
// la var	ag_salesubj_why_cat6	"Incureed lower production costs"
la var	ag_salesubj_why_cat7	"Prices were higher"
// la var	ag_salesubj_why_cat8	"Prices were lower"
la var	ag_salesubj_why_cat9	"Sold in main market instead of farmgate"
// la var	ag_salesubj_why_cat10	"Sold at farmgate instead of main market"


*	19	inorg fertilizer dummy
tab2 round s06dq16?, first 
tab2 round s06d1q11?, first 
tab2 round s06d1q16, first 
g byte	ag_inorgfert_post 	= (s06dq16a==1) if !mi(s06dq16a)	//	no round requirement necessary
replace	ag_inorgfert_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
replace	ag_inorgfert_post 	= (s06d1q16==1) if !mi(s06d1q16) & round==21
la var	ag_inorgfert_post	"Applied any inorganic fertilizer this season"

g byte	ag_orgfert_post		= (s06dq16b==1) if !mi(s06dq16b)
replace	ag_orgfert_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_orgfert_post		"Applied any organic fertilizer this season"
g byte	ag_pesticide_post	= (s06dq16c==1) if !mi(s06dq16c)
replace	ag_pesticide_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_pesticide_post	"Applied any pesticide / herbicide this season"
g byte	ag_hirelabor_post	= (s06dq16d==1) if !mi(s06dq16d)
replace	ag_hirelabor_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_hirelabor_post	"Applied any hired labor this season"
g byte	ag_draught_post		= (s06dq16e==1) if !mi(s06dq16e)
replace	ag_draught_post 	= (s06d1q11a==1) if !mi(s06d1q11a)
la var	ag_draught_post		"Applied any animal traction this season"



*	21	fertilizer types
loc  v21r16 s06d1q12__
d	`v21r16'*
loc  v21r21 s06d1q18__
d	`v21r21'*
tabstat `v21r16'? `v21r21'?, s(sum) by(round)
g byte	ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen byte	ag_ferttype_post_cat1 = anymatch(`v21r16'3 `v21r16'4 `v21r21'3 `v21r21'4) if ag_inorgfert_post==1 & inlist(round,16,21), v(1)	//	following on Uganda, binning DAP into compound fertilizer
egen byte	ag_ferttype_post_cat2 = anymatch(`v21r16'1 `v21r21'1) if ag_inorgfert_post==1 & inlist(round,16,21), v(1)
egen byte	ag_ferttype_post_cat3 = anymatch(`v21r16'2 `v21r21'2) if ag_inorgfert_post==1 & inlist(round,16,21), v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"


*	22	fertilizer applied quantity
loc v22	s06d1q20
d  `v22'*	
tab2 round `v22'b, first	
la li `v22'b
su `v22'a,d
g		ag_fertpost_tot_q		= `v22'a if `v22'a>0  & round==21
g byte	ag_fertpost_tot_unit	= `v22'b if `v22'a>0  & round==21
recode  ag_fertpost_tot_unit (1=1)(2=21)(3=23)(else=.)
do "${do_hfps_util}/label_fert_unit.do"
la val  ag_fertpost_tot_unit fert_unit
recode  ag_fertpost_tot_unit (1=1)(21=1000)(23=50), gen(conv)
g		ag_fertpost_tot_kg		= `v22'a * conv if round==21
drop conv
la var	ag_fertpost_tot_q		"Total quantity of fertilizer on all plots"
la var	ag_fertpost_tot_unit	"Unit for fertilizer applied on all plots"
la var	ag_fertpost_tot_kg		"Total quantity of fertilizer on all plots (kg)"


*	23 reason no fertilizer
loc v23r6 s06dq17__
tabstat `v23r6'?, by(round) s(sum)
loc v23r16 s06d1q18
loc v23r21 s06d1q17
tab2 round	`v23r16' `v23r21', first m
la li		`v23r16' `v23r21'
g byte	ag_inorgfert_no_label=.
la var	ag_inorgfert_no_label	"Did not apply inorganic fertilizer because [...]"
g byte	ag_inorgfert_no_cat1 = (`v23r6'7==1) if !mi(`v23r6'7)
replace ag_inorgfert_no_cat1 = (inlist(`v23r16',1,2)) if !mi(`v23r16') & round==16
replace ag_inorgfert_no_cat1 = (inlist(`v23r21',1,2)) if !mi(`v23r21') & round==21
la var	ag_inorgfert_no_cat1	"Did not need"
g byte	ag_inorgfert_no_cat2 = (`v23r6'5==1 | `v23r6'6==1) if !mi(`v23r6'5,`v23r6'6)
replace ag_inorgfert_no_cat2 = (inlist(`v23r16',3)) if !mi(`v23r16') & round==16
replace ag_inorgfert_no_cat2 = (inlist(`v23r21',3)) if !mi(`v23r21') & round==21
la var	ag_inorgfert_no_cat2	"Too expensive / could not afford"
g byte	ag_inorgfert_no_cat3 = (`v23r6'1==1 | `v23r6'2==1) if !mi(`v23r6'1,`v23r6'2)
replace ag_inorgfert_no_cat3 = (inlist(`v23r16',4)) if !mi(`v23r16') & round==16
replace ag_inorgfert_no_cat3 = (inlist(`v23r21',4)) if !mi(`v23r21') & round==21
la var	ag_inorgfert_no_cat3	"Not available"
g byte	ag_inorgfert_no_cat4 = (`v23r6'3==1 | `v23r6'4==1) if !mi(`v23r6'3,`v23r6'4)
// replace ag_inorgfert_no_cat4 = (inlist(`v23r16',4)) if !mi(s13q16)
la var	ag_inorgfert_no_cat4	"Unable to travel / transport"
	*	ignore o/s

*	reason no [input]
loc v23br6 s06dq18__
loc v23cr6 s06dq19__
loc v23dr6 s06dq20__
loc v23er6 s06dq21__
tabstat `v23br6'? `v23cr6'? `v23dr6'? `v23er6'?, by(round) s(sum) 

g byte	ag_orgfert_no_label=.
la var	ag_orgfert_no_label	"Did not apply organic fertilizer because [...]"
g byte	ag_orgfert_no_cat1 = (`v23br6'7==1) if !mi(`v23br6'7)
la var	ag_orgfert_no_cat1	"Did not need"
g byte	ag_orgfert_no_cat2 = (`v23br6'5==1 | `v23br6'6==1) if !mi(`v23br6'5,`v23br6'6)
la var	ag_orgfert_no_cat2	"Too expensive / could not afford"
g byte	ag_orgfert_no_cat3 = (`v23br6'1==1 | `v23br6'2==1 | `v23br6'96==1) if !mi(`v23br6'1,`v23br6'2)
la var	ag_orgfert_no_cat3	"Not available"
g byte	ag_orgfert_no_cat4 = (`v23br6'3==1 | `v23br6'4==1) if !mi(`v23br6'3,`v23br6'4)
la var	ag_orgfert_no_cat4	"Unable to travel / transport"

g byte	ag_pesticide_no_label=.
la var	ag_pesticide_no_label	"Did not apply pesticide / herbicide because [...]"
g byte	ag_pesticide_no_cat1 = (`v23cr6'7==1) if !mi(`v23cr6'7)
la var	ag_pesticide_no_cat1	"Did not need"
g byte	ag_pesticide_no_cat2 = (`v23cr6'5==1 | `v23cr6'6==1) if !mi(`v23cr6'5,`v23cr6'6)
la var	ag_pesticide_no_cat2	"Too expensive / could not afford"
g byte	ag_pesticide_no_cat3 = (`v23cr6'1==1 | `v23cr6'2==1) if !mi(`v23cr6'1,`v23cr6'2)
la var	ag_pesticide_no_cat3	"Not available"
g byte	ag_pesticide_no_cat4 = (`v23cr6'3==1 | `v23cr6'4==1) if !mi(`v23cr6'3,`v23cr6'4)
la var	ag_pesticide_no_cat4	"Unable to travel / transport"

g byte	ag_hirelabor_no_label=.
la var	ag_hirelabor_no_label	"Did not hire any labor because [...]"
g byte	ag_hirelabor_no_cat1 = (`v23dr6'7==1) if !mi(`v23dr6'7)
la var	ag_hirelabor_no_cat1	"Did not need"
g byte	ag_hirelabor_no_cat2 = (`v23dr6'2==1 | `v23dr6'5==1 | `v23dr6'96==1) if !mi(`v23dr6'2,`v23dr6'5,`v23dr6'96)
la var	ag_hirelabor_no_cat2	"Too expensive / could not afford"
g byte	ag_hirelabor_no_cat3 = (`v23dr6'1==1 | `v23dr6'3==1) if !mi(`v23dr6'1,`v23dr6'3)
la var	ag_hirelabor_no_cat3	"Not available"
g byte	ag_hirelabor_no_cat4 = (`v23dr6'4==1) if !mi(`v23dr6'4)
la var	ag_hirelabor_no_cat4	"Unable to travel / transport"

g byte	ag_draught_no_label=.
la var	ag_draught_no_label	"Did not use animal traction because [...]"
g byte	ag_draught_no_cat1 = (`v23e6'7==1) if !mi(`v23e6'7)
la var	ag_draught_no_cat1	"Did not need"
g byte	ag_draught_no_cat2 = (`v23e6'2==1 | `v23e6'5==1 | `v23e6'6==1) if !mi(`v23e6'2,`v23e6'5)
la var	ag_draught_no_cat2	"Too expensive / could not afford"
g byte	ag_draught_no_cat3 = (`v23e6'1==1 | `v23e6'3==1) if !mi(`v23e6'1,`v23e6'3)
la var	ag_draught_no_cat3	"Not available"
g byte	ag_draught_no_cat4 = (`v23e6'4==1) if !mi(`v23e6'4)
la var	ag_draught_no_cat4	"Unable to travel / transport"
	*	ignore o/s


*	24	fertilizer acquired quantity
loc v24	s06d1q19
d  `v24'*	
tab2 round `v24'b, first	
su `v24'a,d
la li `v24'b
g		ag_fertpurch_tot_q		= `v24'a if `v24'a>0  & round==21
g byte	ag_fertpurch_tot_unit	= `v24'b if `v24'a>0  & round==21
recode  ag_fertpurch_tot_unit (1=1)(2=21)(3=23)(else=.)
la val  ag_fertpurch_tot_unit fert_unit
recode  ag_fertpurch_tot_unit (1=1)(21=1000)(23=50), gen(conv)
g		ag_fertpurch_tot_kg		= `v24'a * conv if round==21
drop conv
la var	ag_fertpurch_tot_q		"Total quantity of fertilizer acquired"
la var	ag_fertpurch_tot_unit	"Unit for fertilizer applied acquired"
la var	ag_fertpurch_tot_kg		"Total quantity of fertilizer acquired (kg)"

	
*	25 Acquire full amount? 
*	The below is not perfectly comparable with other countries on this question
tab2 round s06d1q16__1 s06d1q21, first  

g byte	ag_fertilizer_fullq = (s06d1q16__1==0) if !mi(s06d1q16__1) & round==16
replace	ag_fertilizer_fullq = (s06d1q21==0) if !mi(s06d1q21) & round==21
la var	ag_fertilizer_fullq	"Able to buy desired quantity of fertilizer"
	
	
*	26	fertilizer desired quantity
loc v26	s06d1q23
d  `v26'*	
tab2 round `v26'b, first	
su `v26'a,d
la li `v26'b
g		ag_fertpurch_ante_tot_q		= `v26'a if `v26'a>0  & round==21
g byte	ag_fertpurch_ante_tot_unit	= `v26'b if `v26'a>0  & round==21
recode  ag_fertpurch_ante_tot_unit (1=1)(2=21)(3=23)(else=.)
la val  ag_fertpurch_ante_tot_unit fert_unit
recode  ag_fertpurch_ante_tot_unit (1=1)(21=1000)(23=50), gen(conv)
g		ag_fertpurch_ante_tot_kg	= `v26'a * conv if round==21
drop conv
la var	ag_fertpurch_ante_tot_q		"Total quantity of fertilizer still desired"
la var	ag_fertpurch_ante_tot_unit	"Unit for fertilizer applied still desired"
la var	ag_fertpurch_ante_tot_kg	"Total quantity of fertilizer still desired (kg)"


*	27	reason couldn't acquire fertilizer
loc v27	s06d1q24
ta round `v27'
la li `v27'
g byte	ag_fert_partial_label=.
la var	ag_fert_partial_label	"Could not acquire desired inorganic fertilizer quantity because [...]"
g byte	ag_fert_partial_cat2 = (inlist(`v27',2)) if !mi(`v27')
la var	ag_fert_partial_cat2	"Too expensive / could not afford"
g byte	ag_fert_partial_cat3 = (inlist(`v27',1,3)) if !mi(`v27')
la var	ag_fert_partial_cat3	"Not available"

	
*	28	Adaptations for fertilizer issue
loc v28r16 s06d1q17__
loc v28r21 s06d1q22__
tabstat `v28r16'? `v28r21'?, by(round)
g byte	ag_nofert_adapt_label=.
la var	ag_nofert_adapt_label	"Adapted to inorganic v28r16 limitation by [...]"
g byte	ag_nofert_adapt_cat1=(`v28r16'1==1) if !mi(`v28'1)
la var	ag_nofert_adapt_cat1	"Only fertilized part of cultivated area"
g byte	ag_nofert_adapt_cat2=(`v28r16'2==1) if !mi(`v28r16'2)
la var	ag_nofert_adapt_cat2	"Used lower rate of fertilizer"
g byte	ag_nofert_adapt_cat3=(`v28r16'3==1) if !mi(`v28r16'3)
la var	ag_nofert_adapt_cat3	"Cultivated a smaller area"
g byte	ag_nofert_adapt_cat4=(`v28r16'4==1) if !mi(`v28r16'4)	
replace	ag_nofert_adapt_cat4=(`v28r21'3==1) if !mi(`v28r21'3)	
la var	ag_nofert_adapt_cat4	"Supplemented with organic fertilizer"
g byte	ag_nofert_adapt_cat5=(`v28r21'4==1) if !mi(`v28r21'4)	
la var	ag_nofert_adapt_cat5	"Practiced legume intercropping"
g byte	ag_nofert_adapt_cat6=(`v28r16'5==1) if !mi(`v28r16'5)	
replace	ag_nofert_adapt_cat6=(`v28r21'2==1) if !mi(`v28r21'2)	
la var	ag_nofert_adapt_cat6	"Changed crop"
g		ag_nofert_adapt_cat7=(`v28r21'1==1) if !mi(`v28r21'1)
la var	ag_nofert_adapt_cat7	"Just planted without fertilizer"

loc v28 s06d1q25__
d `v28'*
tabstat `v28'?, by(round)
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








/*	21	fert types tables 
loc v21 s06d1q12__
d `v21'?
tabstat `v21'?, by(round) s(sum)
g		ag_ferttype_post_label=.
la var	ag_ferttype_post_label	"Applied [...] fertilizer"
egen	ag_ferttype_post_cat1 = anymatch(`v21'3 `v21'4) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat2 = anymatch(`v21'1) if ag_inorgfert_post==1, v(1)
egen	ag_ferttype_post_cat3 = anymatch(`v21'2) if ag_inorgfert_post==1, v(1)
la var	ag_ferttype_post_cat1	"Compound (NPK/DAP)"
la var	ag_ferttype_post_cat2	"Nitrogen (CAN/Urea)"
la var	ag_ferttype_post_cat3	"Phosphate"
*/

*	29	price of fertilizer
*	no conversion for now

*	for ferttype above we combine 3 & 4 into 1, 
preserve 
keep if inlist(round,16,21)
keep hhid round s06d1q13a__? s06d1q13b__? s06d1q15__? s06d1q26a__? s06d1q26b__?
reshape long s06d1q13a__ s06d1q13b__ s06d1q15__ s06d1q26a__ s06d1q26b__, i(hhid round) j(type)
keep if (s06d1q13a__>0 & s06d1q13a__<.) | (s06d1q26a__>0 & s06d1q26a__<.) 
recode type (3 4=1)(2=3)(1=2), gen(t)
duplicates tag hhid round t, gen(tag)
li type s06d1q13a__ s06d1q13b__  s06d1q26a__ s06d1q26b__ if tag>0, sepby(hhid) nol	//	one obs, very similar prices 
ta type, nol	//	determine modal type 
drop if tag>0 & type==3	//	retain the variation since 4 is less common
drop tag type
ren (s06d1q13a__ s06d1q13b__ s06d1q15__)	/*
*/	(ag_fertcost_lcu ag_fertcost_unit ag_fertcost_subj)
replace ag_fertcost_lcu		= s06d1q26a__ if round==21
replace ag_fertcost_unit	= s06d1q26b__ if round==21 
recode  ag_fertcost_unit (1=2)(2=3)(3=6)(96=.) if round==21	//	link 21 to 16 codes
recode  ag_fertcost_unit (1=2)(2=1)(3=21)(4=3)(5=22)(6=23)(7=24)(8=25)	//	link 16 to harmonized codes

// do "${do_hfps_util}/label_fert_unit.do"
la val ag_fertcost_unit fert_unit

g ag_fertcost_quant=1
recode ag_fertcost_unit (1 3=1)(2 4=0.001)(21=1000)(23=50)(else=.), gen(conv)
g ag_fertcost_kg = ag_fertcost_quant * conv
drop conv
g ag_fertcost_price = ag_fertcost_lcu / ag_fertcost_kg

drop s06*
reshape wide ag_fertcost_quant ag_fertcost_unit ag_fertcost_kg ag_fertcost_lcu ag_fertcost_subj ag_fertcost_price, i(hhid round) j(t)

loc lbl1	"Compound"
loc lbl2	"Nitrogen"
loc lbl3	"Phosphate"
forv t=1/3 {
la var ag_fertcost_quant`t'	"Unit, `lbl`t'' fertilizer"
la var ag_fertcost_unit`t'	"Unit, `lbl`t'' fertilizer"
la var ag_fertcost_kg`t'	"Standard unit, `lbl`t'' fertilizer"
la var ag_fertcost_lcu`t'	"LCU/unit, `lbl`t'' fertilizer"
la var ag_fertcost_price`t'	"Price/standard unit, `lbl`t'' fertilizer"
la var ag_fertcost_subj`t'	"Price change, `lbl`t'' fertilizer"
	}

	
isid hhid round
tempfile fertcost
sa		`fertcost'
restore
mer 1:1 hhid round using `fertcost', assert(1 3) nogen


do "${do_hfps_util}/label_cost_subj.do"
la val ag_fertcost_subj? cost_subj 


*	30	subjective change in fertilizer price vs last year
loc v30 s06d1q27
ta `v30'
la li `v30'
g ag_fertcost_subj = `v30'
la var	ag_fertcost_subj	"Fertilizer price change"
la val ag_fertcost_subj cost_subj

*	31	manage high fertilizer price, building on v28 codes
loc v31	s06d1q28__
tabstat `v31'?, by(round)
g byte	ag_fertprice_adapt_label=.
la var	ag_fertprice_adapt_label	"Adapted to high fertilizer price by [...]"
g byte	ag_fertprice_adapt_cat2		=(`v31'1==1) if !mi(`v31'1)	
la var	ag_fertprice_adapt_cat2		"Used lower rate of fertilizer"
g byte	ag_fertprice_adapt_cat3		=(`v31'6==1) if !mi(`v31'6)	
la var	ag_fertprice_adapt_cat3		"Cultivated a smaller area"
g byte	ag_fertprice_adapt_cat11	=(`v31'2==1) if !mi(`v31'2)	
la var	ag_fertprice_adapt_cat11	"Borrowed money"
g byte	ag_fertprice_adapt_cat12	=(`v31'3==1) if !mi(`v31'3)	
la var	ag_fertprice_adapt_cat12	"Sold productive assets"
g byte	ag_fertprice_adapt_cat13	=(`v31'4==1) if !mi(`v31'4)	
la var	ag_fertprice_adapt_cat13	"Assistance from family/friends"
g byte	ag_fertprice_adapt_cat14	=(`v31'5==1) if !mi(`v31'5)	
la var	ag_fertprice_adapt_cat14	"Sharecropped/rented out land"

keep  hhid round ag_* crop*
isid  hhid round 
sort  hhid round 

sa "${tmp_hfps_bfa}/agriculture.dta", replace 

u  "${tmp_hfps_bfa}/agriculture.dta", clear
