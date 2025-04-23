



dir "${raw_hfps_tza}", w


d s6* using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
// d using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"
// d using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"
// d using	"${raw_hfps_tza}/r4_sect_a_2_3_4_9b_10.dta"
// d using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
// d using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"
d s12* using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
d s12* using	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
d s12* using	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
u "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
d s12* using	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"
d s12* using	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"



*	adopting a round-specific approach since changes occurred between rounds
u "${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear

tab1 s6*,m
d s6*, varlist
la list `r(varlist)'
g worried	= s6q01==1 if inlist(s6q01,1,2)
g healthy	= s6q02==1 if inlist(s6q02,1,2)
g fewfood	= s6q03==1 if inlist(s6q03,1,2)
g skipped	= s6q04==1 if inlist(s6q04,1,2)
g ateless	= s6q05==1 if inlist(s6q05,1,2)
g runout	= s6q06==1 if inlist(s6q06,1,2)
g hungry	= s6q07==1 if inlist(s6q07,1,2)
g whlday	= s6q08==1 if inlist(s6q08,1,2)

keep hhid worried-whlday
g round=1, b(hhid)
tempfile r1
sa		`r1'


#d ; 
clear; 
append using
	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"
	"${raw_hfps_tza}/r8_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
	"${raw_hfps_tza}/r10_sect_a_2_3_4_4a_11_12a_10.dta"
	"${raw_hfps_tza}/r11_sect_a_2_3_4_11_12a_10.dta"
	,  gen(round) force; /* force necessary because of simple ad hoc fix to r9 dataset in v07 of public release */
#d cr
la drop _append
la val round .
replace round=round+6
ta round	//	 again the issue with the corrupt r9 dataset
keep hhid round s12*

tab1 s12*,m
ds s12*, detail
la list `r(varlist)'
g worried	= s12aq1==1 if inlist(s12aq1,1,2)
g healthy	= s12aq2==1 if inlist(s12aq2,1,2)
g fewfood	= s12aq3==1 if inlist(s12aq3,1,2)
g skipped	= s12aq4==1 if inlist(s12aq4,1,2)
g ateless	= s12aq5==1 if inlist(s12aq5,1,2)
g runout	= s12aq6==1 if inlist(s12aq6,1,2)
g hungry	= s12aq7==1 if inlist(s12aq7,1,2)
g whlday	= s12aq8==1 if inlist(s12aq8,1,2)

keep round hhid worried-whlday
append using `r1'
	ta round 	
	isid hhid round
	sort hhid round
	


tabstat worried healthy fewfood skipped ateless runout hungry whlday, by(round) s(n)

*	get weight and hhsize vars 
d using "${tmp_hfps_tza}/cover.dta"
mer 1:1 round hhid using "${tmp_hfps_tza}/cover.dta", keepus(s10q01 urban_rural wgt)
ta round _merge
bys round (hhid) : egen min=min(_merge)
bys round (hhid) : egen max=max(_merge)
assert min==max
keep if _merge==3
drop _merge min max
ta s10q01 round

mer 1:1 round hhid using "${tmp_hfps_tza}/demog.dta", keepus(hhsize)
ta round _merge
ta s10q01 _merge
keep if _merge==3
drop _merge s10q01


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

tabstat worried-whlday, by(round) format(%6.3f)


g na="NA" 
g urban = (urban_rural=="1. RURAL":urban_rural)

cap : erase "${tmp_hfps_tza}/fies/FIES_TZA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_tza}/fies/FIES_TZA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	Worried infit is 1.362-> excluded. All other infit are inrange(0.7,1.3) 
	2	Equating: Skipped -0.59, healthy -.33, fewfood +.35, runout +.47. 
		1	dropped skipped => healthy and runout still outside ±0.35
		2	dropped healthy => runout is +.37, but we will accept this 
			based on prior round implementation and need for at least five 
			components
	3	downloaded and saved as FIES_TZA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
1	50.94	3.97	17.15	2.77
7	55.10	6.96	18.74	4.65
8	37.64	6.79	9.54	3.44
9	43.06	7.18	12.44	4.20
10	26.63	6.45	7.09	3.37
11	22.76	6.14	4.35	2.27
*/
								/*	ARCHIVE: notes on process done in Shiny app
									1	Worried infit is 1.360-> excluded. All other infit are inrange(0.7,1.3) 
									2	Equating: Skipped -0.65, healthy -.29, fewfood +.36, runout +.48. 
										1	dropped skipped => healthy and runout still outside ±0.35
										2	dropped healthy => runout is +.37, but we will accept this 
											based on prior round implementation and need for at least five 
											components
									3	downloaded and saved as FIES_TZA_out.csv
								*/
								
								/*	when using all, individual level (note that here "region" = survey round)
								Prevalence rates of food insecurity by region (% of individuals)
								Moderate or Severe	MoE	Severe	MoE
								1	50.76	3.97	17.71	2.83
								7	54.94	6.96	19.37	4.76
								8	37.48	6.78	9.88	3.53
								9	42.91	7.17	12.89	4.30
								10	26.50	6.44	7.33	3.46
								*/

levelsof round, loc(rounds)
foreach r of local rounds {
// 	loc r=11
	cap : erase "${tmp_hfps_tza}/fies/FIES_TZA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_tza}/fies/FIES_TZA_r`r'_in.csv", delim(",")
}



/*
round 1 
	1	Worried infit is 1.259, which is inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped and healthy are >.35, as is runout. After dropping 
		skipped and healthy, runout is .4, but we retain for consistency (and to
		keep at least 5 items for analysis)
	3	downloaded and saved as FIES_TZA_r1_out.csv

round 7 
	1	Worried infit is 1.387, otherwise inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped >.35, as is runout and fewfood. healthy is .14, but we 
		drop for consistency. After dropping remainder are <=.35
	3	downloaded and saved as FIES_TZA_r7_out.csv

round 8 
	1	Worried infit is 1.322, otherwise inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped >.35, as is runout and fewfood. healthy is .34, but we 
		drop for consistency. After dropping skipped and healthy, remainder are <=.35
	3	downloaded and saved as FIES_TZA_r8_out.csv

round 9 
	1	Worried infit is 1.403, otherwise inrange(0.7,1.3). Dropped worried 
		for consistency across rounds. 
	2	Equating: skipped -.59, runout +.53, remainder <±.35.  Dropping 
		skipped and healthy for consistency with pooled analysis. Healthy -.42. 
	3	downloaded and saved as FIES_TZA_r9_out.csv

round 10 
	1	Worried infit is 1.201, and all others are inrange(0.7,1.3). 
		Dropped worried for consistency across rounds. 
	2	Equating: skipped -.59, runout +.60, fewfood +.36, ateless + .37. 
		Remainder are <±.35.  Dropping skipped and healthy for consistency 
		with pooled analysis. runout +.43, remainder <±.35.
	3	downloaded and saved as FIES_TZA_r10_out.csv

round 11 
	1	Worried infit is 0.960, and all others are inrange(0.7,1.3). 
		Dropped worried for consistency across rounds. 
	2	Equating: healthy-.47, runout+.39. 
		Remainder are <±.35.  Dropping skipped and healthy for consistency 
		with pooled analysis. remainder <±.35.
	3	downloaded and saved as FIES_TZA_r11_out.csv



*/

	
*	before merging, need to account for the exclusion of -worried- from the analysis
ren RS fies_rawscore
la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

egen RS = rowtotal(/*worried*/ healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(/*worried,*/healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${hfps}/Input datasets/FIES/FIES_TZA_out.csv", varn(1) clear
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
mer m:1 RS using `out',	assert(3) nogen

tabstat fies_mod fies_sev [aw=wgt_hh], by(round)

la var fies_mod	"Probability of moderate + severe food insecurity"
la var fies_sev	"Probability of severe food insecurity"
 
ren fies_??? fies_pooled_???


	preserve 
levelsof round if !mi(RS), loc(rounds)
loc toappend ""
foreach r of local rounds {
import delimited using "${hfps}/Input datasets/FIES/FIES_TZA_r`r'_out.csv", varn(1) clear
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

mer m:1 RS round using `tomerge', assert(3) nogen

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

// ren RS fies_rawscore	//->	this step was moved earlier to manage the worried change
// la var fies_rawscore	"Food Insecurity Experience Scale - Raw Score"

keep round hhid fies_*
sa "${tmp_hfps_tza}/fies.dta", replace
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	