

dir "${raw_hfps_eth}", w


*	there is a switch in sample between phases 1 & 2


*	Phase 1
d fi* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d fi* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d fi* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d fi* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d fi* using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		




u "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

// g worried	= fi1==1 if inlist(fi1,0,1)
// g healthy	= fi2==1 if inlist(fi2,0,1)
// g fewfood	= fi3==1 if inlist(fi3,0,1)
// g skipped	= fi4==1 if inlist(fi4,0,1)
// g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)

keep household_id runout-whlday
tempfile r1
sa		`r1'
// sa "${tmp_hfps_eth}/r1/fies.dta", replace

u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r2
sa		`r2'
// sa "${tmp_hfps_eth}/r2/fies.dta", replace

u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r3
sa		`r3'
// sa "${tmp_hfps_eth}/r3/fies.dta", replace

u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r4
sa		`r4'
// sa "${tmp_hfps_eth}/r4/fies.dta", replace

u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?
*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r5
sa		`r5'
// sa "${tmp_hfps_eth}/r5/fies.dta", replace

u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"			, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r6
sa		`r6'
// sa "${tmp_hfps_eth}/r6/fies.dta", replace


u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"		, clear
keep household_id fi*
ren fi?_* fi?
numlabel, add
tab1 fi?

*	question order altered for Ethiopia. 

g worried	= fi1==1 if inlist(fi1,0,1)
g healthy	= fi2==1 if inlist(fi2,0,1)
g fewfood	= fi3==1 if inlist(fi3,0,1)
g skipped	= fi4==1 if inlist(fi4,0,1)
g ateless	= fi5==1 if inlist(fi5,0,1)
g runout	= fi7==1 if inlist(fi7,0,1)
g hungry	= fi8==1 if inlist(fi8,0,1)
g whlday	= fi6==1 if inlist(fi6,0,1)
keep household_id worried-whlday
tempfile r11
sa		`r11'
// sa "${tmp_hfps_eth}/r11/fies.dta", replace


*	Phase 2
dir "${raw_hfps_eth}/*fies*.dta", w

d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_fies_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_fies_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_fies_public.dta"	

u "${raw_hfps_eth}//wb_lsms_hfpm_hh_survey_round15_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)

la li frequency	//	coded
ta fies_7 fies_7a,m
ta fies_8 fies_8a,m
ta fies_6 fies_6a,m
g runout_freq = fies_7a if runout==1
g hungry_freq = fies_8a if hungry==1
g whlday_freq = fies_6a if whlday==1
la val *_freq frequency

keep household_id worried-whlday *_freq
tempfile r15
sa		`r15'
// sa "${tmp_hfps_eth}/r15/fies.dta", replace

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)

la li fies_6a fies_7a fies_8a	//	same as frequency, do not copy labels over we will just use frequency 
ta fies_7 fies_7a,m
ta fies_8 fies_8a,m
ta fies_6 fies_6a,m
g runout_freq = fies_7a if runout==1
g hungry_freq = fies_8a if hungry==1
g whlday_freq = fies_6a if whlday==1

keep household_id worried-whlday *_freq
tempfile r17
sa		`r17'
// sa "${tmp_hfps_eth}/r17/fies.dta", replace


u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_fies_public.dta"		, clear

*	question order altered for Ethiopia. 
g worried = fies_1==1 if inlist(fies_1,1,0)
g healthy = fies_2==1 if inlist(fies_2,1,0)
g fewfood = fies_3==1 if inlist(fies_3,1,0)
g skipped = fies_4==1 if inlist(fies_4,1,0)
g ateless = fies_5==1 if inlist(fies_5,1,0)
g runout  = fies_7==1 if inlist(fies_7,1,0)
g hungry  = fies_8==1 if inlist(fies_8,1,0)
g whlday  = fies_6==1 if inlist(fies_6,1,0)
tabstat worried-whlday, by(group) s(n)

la li fies_6a fies_7a fies_8a	//	same as frequency, do not copy labels over we will just use frequency 
ta fies_7 fies_7a,m
ta fies_8 fies_8a,m
ta fies_6 fies_6a,m
g runout_freq = fies_7a if runout==1
g hungry_freq = fies_8a if hungry==1
g whlday_freq = fies_6a if whlday==1

keep household_id worried-whlday *_freq
tempfile r18
sa		`r18'
// sa "${tmp_hfps_eth}/r18/fies.dta", replace



*	construct panel to match to cover and demog 
#d ; 
clear; append using 
	`r1'
	`r2'
	`r3'
	`r4'
	`r5'
	`r6'
	`r11'
	`r15'
	`r17'
	`r18'
	, gen(round);
#d cr
la drop _append
la val round 
ta round 
replace round=round+4 if round>6
replace round=round+3 if round>11
replace round=round+1 if round>15
ta round

order round household_id worried healthy fewfood skipped ateless runout hungry whlday
tabstat worried-whlday, by(round) s(n sum) 

isid household_id round
d using "${tmp_hfps_eth}/cover.dta"
mer 1:1 household_id round using "${tmp_hfps_eth}/cover.dta", keepus(wgt cs4_sector)
ta round _merge	//	one _m=1 in round 6 
keep if _merge==3
drop _merge
d using "${tmp_hfps_eth}/demog.dta"
mer 1:1 household_id round using "${tmp_hfps_eth}/demog.dta", keepus(hhsize) assert(2 3) keep(3) nogen



g wgt_hh = hhsize * wgt
assert !mi(wgt_hh)

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

g na="NA"
g urban = (cs4_sector=="Urban":cs4_sector)

cap : erase "${tmp_hfps_eth}/fies/FIES_ETH_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if round!=1 & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_eth}/fies/FIES_ETH_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3), though hungry is low at .756
	2	Equating: Worried is far above (0.44) global standard, hungry also 
		high (0.33). On balance, most are below, so started by dropping worried. 
		Remainder are all <=.35, though Hungry = 0.32 
	3	downloaded and saved as FIES_ETH_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
2	50.18	5.59	7.77	2.97
3	48.35	5.65	6.94	2.86
4	45.45	5.83	5.58	2.43
5	44.27	6.17	6.75	3.13
6	40.48	6.06	6.79	2.90
11	42.49	7.48	6.40	3.88
15	52.47	14.93	10.50	8.35
17	43.84	16.27	8.83	7.41
18	56.13	13.43	14.61	11.46
*/
					/*	ARCHIVE notes on process done in Shiny app
						1	All infit inrange(0.7,1.3), 
						2	Equating: Worried is far above (0.43) global standard, hungry also high (0.35). On 
							balance, most are below, so started by dropping worried. Remainder are all <=.35
						3	downloaded and saved as FIES_ETH_out.csv
					*/
					
					/*	when using all, individual level (note that here "region" = survey round)
					Prevalence rates of food insecurity by region (% of individuals)
						Moderate or Severe	MoE	Severe	MoE
					2	50.59	5.60	7.81	2.97
					3	48.76	5.66	6.97	2.85
					4	45.84	5.86	5.61	2.43
					5	44.63	6.19	6.80	3.13
					6	40.82	6.07	6.82	2.90
					11	42.88	7.50	6.43	3.88
					15	52.79	14.85	10.60	8.33
					17	44.21	16.23	8.94	7.51
					*/

levelsof round if round>1, loc(rounds)
foreach r of local rounds {
// 	loc r=18
	cap : erase "${tmp_hfps_eth}/fies/FIES_ETH_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_eth}/fies/FIES_ETH_r`r'_in.csv", delim(",")
}

/*
round 2 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .53 
	3	downloaded and saved as FIES_ETH_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .54 
	3	downloaded and saved as FIES_ETH_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Sticking with panel rule (drop worried). Hungry is high at .47 
	3	downloaded and saved as FIES_ETH_r4_out.csv

round 5 
	1	Hungry low at 0.628, retained for consistency with other rounds 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r5_out.csv

round 6 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r6_out.csv

round 11 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Healthy and WholeDay are low 
		at 0.37 and 0.47 respectively, while Hungry is high at 0.47.  
	3	downloaded and saved as FIES_ETH_r11_out.csv

round 15 
	1	Hungry low at 0.652, retained for consistency with other rounds 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35. 
	3	downloaded and saved as FIES_ETH_r15_out.csv

round 17 
	1	All infit inrange(0.7,1.3). 
	2	Equating: Dropped worried per panel rule. Remaining items are <=.35 though
		skipped is a bit high at 0.34. 
	3	downloaded and saved as FIES_ETH_r17_out.csv

round 18 
	1	Hungry low at 0.630, Runout low at .687. Both are retained for
		consistency with other rounds. 
	2	Equating: Worried initially high at .62. Dropped worried per panel rule. 
		Remaining items are <=.35 though runout is a bit high at 0.31. 
	3	downloaded and saved as FIES_ETH_r18_out.csv



*/




*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${hfps}/Input datasets/FIES/FIES_ETH_out.csv", varn(1) clear
ds rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev, has(type string)
if length("`r(varlist)'")>0 {
destring rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev, replace ignore("NA")
	}
ren (rawscore /*rawscorepar rawscoreparerr*/ probmod_sev probsev)(RS fies_mod fies_sev)
keep RS fies_mod fies_sev
duplicates drop
isid RS, missok
sa `out'
	restore
mer m:1 RS using `out', assert(3) nogen

tabstat fies_mod fies_sev [aw=wgt_hh], by(round)

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
ren fies_??? fies_pooled_???


	preserve 
levelsof round if !mi(RS), loc(rounds)
loc toappend ""
foreach r of local rounds {
import delimited using "${hfps}/Input datasets/FIES/FIES_ETH_r`r'_out.csv", varn(1) clear
ds rawscore probmod_sev probsev, has(type string)
if length("`r(varlist)'")>0 {
destring rawscore probmod_sev probsev, replace ignore("NA")
	}
ren (rawscore probmod_sev probsev)(RS fies_mod fies_sev)
keep RS fies_mod fies_sev
duplicates drop
g round=`r'
tempfile r`r'
sa		`r`r''
loc toappend "`toappend' `r`r''"
}
clear
append using `toappend'
ta round RS
tempfile tomerge 
sa		`tomerge'
	restore

mer m:1 RS round using `tomerge'
ta RS round if _merge!=3,	m
drop _merge

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
tabstat fies_mod fies_sev fies_pooled_mod fies_pooled_sev [aw=wgt_hh], by(round) format(%9.3f)

la var worried	"Worried about not having enough food to eat"
la var healthy	"Unable to eat healthy and nutritious/preferred foods"
la var fewfood	"Ate only a few kinds of foods"
la var skipped	"Had to skip a meal"
la var ateless	"Ate less than you thought you should"
la var runout	"Ran out of food"
la var hungry	"Were hungry but did not eat"
la var whlday	"Went without eating for a whole day"

ren (worried healthy fewfood skipped ateless runout hungry whlday)	/*
*/	(fies_worried fies_healthy fies_fewfood fies_skipped fies_ateless fies_runout fies_hungry fies_whlday)

ren RS fies_rawscore
la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

la var runout_freq	"Frequency of running out of food"
la var hungry_freq	"Frequency of being hungry but not eating"
la var whlday_freq	"Frequency of not eating for a whole day"
la val *_freq frequency
ren *_freq fies_*_freq

keep round household_id fies_*
sa "${tmp_hfps_eth}/fies.dta", replace
u  "${tmp_hfps_eth}/fies.dta", clear
ta round
	
	
	





