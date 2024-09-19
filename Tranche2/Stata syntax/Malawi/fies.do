

dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*_food_security_*", w

d using	"${raw_hfps_mwi}/sect8_food_security_r1.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r2.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r3.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r4.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r5.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r6.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r7.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r8.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r9.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r10.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r11.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r12.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r13.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r14.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r15.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r16.dta"
// d using	"${raw_hfps_mwi}/sect8_food_security_r17.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r18.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r19.dta"
d using	"${raw_hfps_mwi}/sect8_food_security_r20.dta"
u	"${raw_hfps_mwi}/sect8_food_security_r20.dta", clear	
su s8q?	//	all null????	what?->	 now fixed with a non-public version (updates to v19, hopefully v20+ will have this resolved)




#d ; 
clear; append using
	"${raw_hfps_mwi}/sect8_food_security_r1.dta"
	"${raw_hfps_mwi}/sect8_food_security_r2.dta"
	"${raw_hfps_mwi}/sect8_food_security_r3.dta"

	"${raw_hfps_mwi}/sect8_food_security_r5.dta"
	"${raw_hfps_mwi}/sect8_food_security_r6.dta"
	"${raw_hfps_mwi}/sect8_food_security_r7.dta"
	"${raw_hfps_mwi}/sect8_food_security_r8.dta"
	"${raw_hfps_mwi}/sect8_food_security_r9.dta"
	
	"${raw_hfps_mwi}/sect8_food_security_r11.dta"
	"${raw_hfps_mwi}/sect8_food_security_r12.dta"

	

	"${raw_hfps_mwi}/sect8_food_security_r16.dta"
	
	"${raw_hfps_mwi}/sect8_food_security_r18.dta"
	"${raw_hfps_mwi}/sect8_food_security_r19.dta"
	"${raw_hfps_mwi}/sect8_food_security_r20.dta"
, gen(round);
#d cr
isid y4 round
replace round=round+1 if round>3
replace round=round+1 if round>9
replace round=round+3 if round>12
replace round=round+1 if round>16
la drop _append
la val round 
ta round


la li s8q1 s8q2 s8q3 s8q4 s8q5 s8q6 s8q7 s8q8
tab2 round s8q1 s8q2 s8q3 s8q4 s8q5 s8q6 s8q7 s8q8, first m
g worried	= s8q1==1 if inlist(s8q1,1,2)
g healthy	= s8q2==1 if inlist(s8q2,1,2)
g fewfood	= s8q3==1 if inlist(s8q3,1,2)
g skipped	= s8q4==1 if inlist(s8q4,1,2)
g ateless	= s8q5==1 if inlist(s8q5,1,2)
g runout	= s8q6==1 if inlist(s8q6,1,2)
g hungry	= s8q7==1 if inlist(s8q7,1,2)
g whlday	= s8q8==1 if inlist(s8q8,1,2)
nmissing worried-whlday

*	get weight and hhsize vars 
d using "${tmp_hfps_mwi}/panel/cover.dta"
mer 1:1 y4 round using "${tmp_hfps_mwi}/panel/cover.dta", keepus(result urb_rural r0_reside wgt) assert(2 3) keep(3) nogen
mer 1:1 y4 round using "${tmp_hfps_mwi}/panel/demog.dta", keepus(hhsize) keep(1 3) nogen

*	in some cases, the reference group is "adults in the household" rather than the full household
g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

g na="NA" 
g urban = (urb_rural=="urban":hh_a03b)

ta round if !mi(wgt_hh) & !mi(RS)	

cap : erase "${tmp_hfps_mwi}/fies/FIES_MWI_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_mwi}/fies/FIES_MWI_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3), 
	2	Equating: Worried +0.84, skipped -0.65, hungry -.49
		step 1 drop worried=>	skipped -.50
		step 2 drop skipped=>	hungry -.47
		step 3 drop hungry=>	Remainder are all <=.35
		 
	3	downloaded and saved as FIES_MWI_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
1	72.57	5.03	25.33	4.79
2	68.44	5.43	21.97	4.59
3	67.91	5.52	22.95	4.82
5	62.73	5.62	17.51	3.80
6	67.60	5.45	23.21	4.50
7	64.99	5.98	24.03	4.57
8	68.65	5.67	25.09	4.69
9	58.96	6.12	16.48	4.13
11	48.42	5.98	9.71	3.38
12	46.52	5.95	10.91	3.81
16	77.98	5.56	31.61	5.36
18	68.58	5.81	21.49	4.63
19	84.79	6.47	38.90	7.40
*/
				/*	ARCHIVE: notes on process done in Shiny app
					1	All infit inrange(0.7,1.3), 
					2	Equating: Worried is far above (0.85) global standard, skipped far below (0.67)
						step 1 drop worried=>	skipped low at 0.51
						step 2 drop skipped=>	hungry low at 0.47
						step 3 drop hungry=>	Remainder are all <=.35
						
					3	downloaded and saved as FIES_MWI_out.csv
				*/
				
				/*	when using all, individual level (note that here "region" = survey round)
				Prevalence rates of food insecurity by region (% of individuals)
					Moderate or Severe	MoE	Severe	MoE
				1	72.58	5.03	25.25	4.76
				2	68.44	5.43	21.92	4.57
				3	67.91	5.52	22.90	4.79
				5	62.74	5.62	17.48	3.78
				6	67.61	5.45	23.15	4.48
				7	65.00	5.98	23.97	4.54
				8	68.65	5.67	25.03	4.66
				9	58.97	6.12	16.45	4.11
				11	48.43	5.98	9.69	3.36
				12	46.53	5.95	10.88	3.79
				16	77.99	5.56	31.53	5.32
				18	68.59	5.81	21.44	4.60
				*/

levelsof round, loc(rounds)
foreach r of local rounds {
// 	loc r=19
	cap : erase "${tmp_hfps_mwi}/fies/FIES_MWI_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_mwi}/fies/FIES_MWI_r`r'_in.csv", delim(",")
}



/*
round 1 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r1_out.csv

round 2 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r3_out.csv

round 5 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r5_out.csv

round 6 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r6_out.csv

round 7 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r7_out.csv

round 8 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r8_out.csv

round 9 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r9_out.csv

round 11 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r11_out.csv

round 12 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r12_out.csv

round 16 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r16_out.csv

round 18 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r18_out.csv

round 19 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, hungry. Ateless is low at 0.39, others all <=0.35
	3	downloaded and saved as FIES_MWI_r19_out.csv

round 20 
	1	All infit inrange(0.7,1.3), though ateless=.712
	2	Followed panel finding -> drop worried, skipped, hungry. Remainder all <=0.35
	3	downloaded and saved as FIES_MWI_r20_out.csv


*/





*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${tmp_hfps_mwi}/fies/FIES_MWI_out.csv", varn(1) clear
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
import delimited using "${tmp_hfps_mwi}/fies/FIES_MWI_r`r'_out.csv", varn(1) clear
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

mer m:1 RS round using `tomerge', //	assert(3) nogen
ta round _m
drop _m
dis as red	"Malawi r20 currently all null"
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

keep round y4_hhid fies_*
sa "${tmp_hfps_mwi}/panel/fies.dta", replace
	
	
	




