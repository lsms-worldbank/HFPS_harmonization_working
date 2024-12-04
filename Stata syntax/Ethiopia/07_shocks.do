
*	shocks/ income loss  
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*shock_coping*", w

*	Phase 1
d lc* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d lc* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d lc* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
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
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_shock_coping"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"	, si




*	Phase 1
u household_id lc* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
li lc4_total_chg_cope_3 lc4_total_chg_cope_4 if !mi(lc4_total_chg_cope_other)	//	seems reasonable to recode here, 
u household_id lc* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)
u household_id lc* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
li lc4_total_chg_cope_other if !mi(lc4_total_chg_cope_other)

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_shock_coping.dta"		, clear
g round=16
la li shockcode cop3_mechani

	
*	harmonize shock_code
inspect cop_code
run "${do_hfps_util}/label_shock_code.do"
la li shockcode shock_code 
g shock_code=cop_code, a(cop_code)
recode shock_code (1=61)(2=62)(3=63)(4=64)(6=21)(7=23)(8=65)(9=66)(10=67)(13=10)	/*
*/	(14=52)(15=68)(16=69)(17=70)(18=71)(19=72)(20=96)
la val shock_code shock_code
inspect shock_code
assert r(N_undoc)==0
ta cop_code shock_code
drop cop_code
isid household_id round shock_code


*	deal with potential duplicate shock codes 
ta cop1_affect
bys household_id round (shock_code) : egen shock_yn = max(cop1_affect==1)
g yn = (cop1_affect==1)
la li cop3_mechani
ds cop3_mechani*, not(type string)	//	 need to make these "wide" format prior to collapse 
loc sc `r(varlist)'
d `sc'
egen shock_cope_16	= anymatch(`sc'), v(1)
egen shock_cope_7	= anymatch(`sc'), v(2)
egen shock_cope_19	= anymatch(`sc'), v(3)
egen shock_cope_17	= anymatch(`sc'), v(4)
egen shock_cope_14	= anymatch(`sc'), v(5)
egen shock_cope_6	= anymatch(`sc'), v(6 7 16)
egen shock_cope_31	= anymatch(`sc'), v(8 17)
egen shock_cope_15	= anymatch(`sc'), v(9)
egen shock_cope_9	= anymatch(`sc'), v(10)	//	coding it as financial institution in absence of specifics about where the loan is from
egen shock_cope_1	= anymatch(`sc'), v(11/15)	
egen shock_cope_22	= anymatch(`sc'), v(18)	
egen shock_cope_21	= anymatch(`sc'), v(19)	
egen shock_cope_96	= anymatch(`sc'), v(-96)	

ta cop3_mech_oth
cleanstr cop3_mech_oth, names(shock_cope_os)

// 	bys household_id round shock_code : g obs=_n
// 	su obs
// 	gl max=r(max)
// 	for num 1(1)${max} : g osX = shock_cope_os if obs==X
//
//
// 	ds shock_cope*, not(type string)
// 	loc d_shock_cope `r(varlist)'
//
//
// collapse (max) yn `d_shock_cope', by(household_id round shock_code)

isid household_id round shock_code 
sort household_id round shock_code 
keep household_id round shock_code shock_*
order shock_cope_*, seq a(shock_yn)
// tabstat shock_cope_*, by(round) s(min max)	//	coding is 0/1

do "${do_hfps_util}/label_coping_vars.do"
d shock_cope_*, f

// tabstat shock_cope_*, by(round)



	
sa "${tmp_hfps_eth}/shocks.dta", replace
	
	
*	move to household level for analysis
u  "${tmp_hfps_eth}/shocks.dta", clear

ta shock_code
la li shock_code
levelsof shock_code, loc(codes)
foreach c of local codes {
	g shock_yn_`c' = (shock_code==`c' & shock_yn==1)
	la var shock_yn_`c'	"`: label (shock_code) `c''"
}


*	simply drop the string variables for expediency in the remainder
// ds shock*, has(type string)
// drop `r(varlist)'

*	verify that missing-ness is intact
tabstat shock_yn_*, by(round) s(n)	//	no missingness as we expect
	ds shock_cope*, not(type string)
	loc d_shock_cope `r(varlist)'
tabstat `d_shock_cope', by(round) s(n)	//	missing shock_cope_17, as we expect (added in round 8 only)


	bys household_id round (shock_code) : g obs=_n
	su obs
	gl max=r(max)
	for num 1(1)${max} : g osX = shock_cope_os if obs==X

 foreach x of varlist shock_yn* shock_cope* {
 	loc lbl`x' : var lab `x'
 }
collapse (max) shock_yn* `d_shock_cope' (firstnm) os*, by(household_id round)
 foreach x of varlist shock_yn* shock_cope* {
 	la var `x' "`lbl`x''"
 }

tabstat shock_yn*, by(round) s(n)	
tabstat shock_cope*, by(round) s(n)	

	g shock_cope_os=""
	forv i=1/$max {
		tempvar l0 
		g `l0'=length(shock_cope_os)
		replace shock_cope_os = os`i' if `l0'==0 & !mi(os`i')
		replace shock_cope_os = shock_cope_os + "^ " + os`i' if `l0'>0 & !mi(os`i') & strpos(shock_cope_os,os`i')==0
		drop `l0'
	}
	li shock_cope_os if strpos(shock_cope_os,"^")>0, sep(0)
	replace shock_cope_os = subinstr(shock_cope_os,"^",", ",.)
	drop os* 
	
	run "${do_hfps_util}/label_coping_vars"
	

isid household_id round
sort household_id round
tempfile r16
sa		`r16'





#d ;
clear; append using

  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta" 
  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
, gen(round) keep(household_id lc*) force; 

#d cr
isid household_id round 
sort household_id round 
la drop _append 
la val round
ta round

		egen shock_yn = anymatch(lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg), v(3 4)
		la var shock_yn		"Household reported any shock since last asked"
		
		ta shock_yn lc3_total_chg,m
		drop lc1* lc2*
		ta lc3_total_chg if !mi(lc4_total_chg_cope),m
		
		replace shock_yn = (inlist(lc3_total_chg,3,4))
		drop lc3_total_chg lc4_total_chg_cope
		
		ren lc4_total_chg_cope_* sc*
		ta scother
		cleanstr scother, names(shock_cope_os)
		drop sc_98 sc_99 scother
		ren (sc2 sc3 sc4 sc5  sc6  sc7  sc8  sc9 sc10 sc11 sc12 sc13 sc14 sc15  sc0 sc_96)	/*
		*/	(sc6 sc7 sc8 sc9 sc11 sc12 sc13 sc14 sc15 sc16 sc17 sc18 sc19 sc20 sc21 sc96)
		ren sc* shock_cope_*
do "${do_hfps_util}/label_coping_vars.do"

		
isid household_id round
sort household_id round
append using `r16'

order shock_yn_* shock_cope_*, seq a(shock_yn)
tabstat shock_yn*, by(round)
ds shock_cope_*, not(type string)
tabstat `r(varlist)', by(round)

sa "${tmp_hfps_eth}/hh_shocks.dta", replace 




ex	//	old below -> income loss 

#d ;
clear; append using

  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta" 
  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		 
, gen(round) keep(household_id lc*) force; 

#d cr
isid household_id round 
sort household_id round 
la drop _append 
la val round
ta round

tab2 round lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg, first m
la li lc1_farm lc1_bus lc1_we lc1_rem_dom lc1_rem_for lc1_isp lc1_pen lc1_gov lc1_ngo lc1_other
egen lc1_total = anymatch( lc1_farm lc1_bus lc1_we lc1_rem_dom lc1_rem_for lc1_isp lc1_pen lc1_gov lc1_ngo lc1_other), v(1)		
la li lc2_farm_chg lc2_bus_chg lc2_we_chg lc2_rem_dom_chg lc2_rem_for_chg lc2_isp_chg lc2_pen_chg lc2_gov_chg lc2_ngo_chg lc2_other_chg lc3_total_chg		

*	income loss components 
keep round household_id  lc1_farm-lc3_total_chg 
ren lc1_* inc_d_*
ren lc2_*_chg inc_chg_*

ds inc_d_*, not(type string)
egen inc_d_total = anymatch(`r(varlist)'), v(1)
ta inc_d_total round
la var inc_d_total	"Any income source identified in last year"
ta inc_d_total lc3_total_chg	//	change is identified regardless of whether x was identified as an income source 
ren lc3_total_chg inc_chg_total
order inc_d_total, b(inc_chg_total)

la copy lc1_farm inc_d
ds inc_d_*, not(type string)
la val `r(varlist)' inc_d
la copy lc3_total_chg inc_chg
la val inc_chg_* inc_chg

la li inc_chg
ds inc_chg_*, not(type string)
loc vars `r(varlist)'
foreach x of local vars {
	loc token = substr("`x'",length("inc_chg_")+1,length("`x'")-length("inc_chg_"))
	g inc_loss_`token' = (inlist(`x',3,4)) if !mi(inc_chg_`token'), a(`x')
	loc lbl = substr("`: var lab `x''",length("LC1: ")+1,strpos("`: var lab `x''","Change")-length("LC1: "))
	la var inc_d_`token'	"Any `lbl'"
	la var inc_chg_`token'	"Change in `lbl'"
	la var inc_loss_`token'	"Any loss of `lbl'"
}

ren *_we *_wage	//	switch this token 

sa "${tmp_hfps_eth}/hh_income_loss.dta", replace 



