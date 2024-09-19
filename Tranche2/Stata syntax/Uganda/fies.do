



/*
dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w

d using	"${raw_hfps_uga}/round1/SEC7.dta"
d using	"${raw_hfps_uga}/round2/SEC8.dta"
d using	"${raw_hfps_uga}/round3/SEC8.dta"
d using	"${raw_hfps_uga}/round4/SEC8.dta"
d using	"${raw_hfps_uga}/round5/SEC8.dta"
d using	"${raw_hfps_uga}/round6/SEC8.dta"
d using	"${raw_hfps_uga}/round7/SEC8.dta"
d using	"${raw_hfps_uga}/round8/SEC8.dta"
d using	"${raw_hfps_uga}/round9/SEC8.dta"
d using	"${raw_hfps_uga}/round10/SEC8.dta"
d using	"${raw_hfps_uga}/round11/SEC8.dta"
d using	"${raw_hfps_uga}/round12/SEC8.dta"
d using	"${raw_hfps_uga}/round13/SEC8.dta"
d using	"${raw_hfps_uga}/round14/SEC8.dta"
d using	"${raw_hfps_uga}/round15/SEC8.dta"
d using	"${raw_hfps_uga}/round16/SEC8.dta"
d using	"${raw_hfps_uga}/round17/SEC8.dta"


*/



*	household level detail from actual completed interview (incl. weights)
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC7.dta"
	"${raw_hfps_uga}/round2/SEC8.dta"
	"${raw_hfps_uga}/round3/SEC8.dta"
	"${raw_hfps_uga}/round4/SEC8.dta"
	"${raw_hfps_uga}/round5/SEC8.dta"
	"${raw_hfps_uga}/round6/SEC8.dta"
	"${raw_hfps_uga}/round7/SEC8.dta"
	"${raw_hfps_uga}/round8/SEC8.dta"
	"${raw_hfps_uga}/round9/SEC8.dta"
	"${raw_hfps_uga}/round10/SEC8.dta"
	"${raw_hfps_uga}/round11/SEC8.dta"
	"${raw_hfps_uga}/round12/SEC8.dta"
	"${raw_hfps_uga}/round13/SEC8.dta"
	"${raw_hfps_uga}/round14/SEC8.dta"
	"${raw_hfps_uga}/round15/SEC8.dta"
	"${raw_hfps_uga}/round16/SEC8.dta"
	"${raw_hfps_uga}/round17/SEC8.dta"
, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 
	format hhid %20.0g
	isid hhid round
	sort hhid round
	
d s8q0*
la li s8q01 s8q02 s8q03 s8q04 s8q05 s8q06 s8q07 s8q08
d s7q0*
la li s7q01 s7q02 s7q03 s7q04 s7q05 s7q06 s7q07 s7q08

forv i=1/8 {
	egen q`i' = rowfirst(s7q0`i' s8q0`i')
// 	tab2 round s7q0`i' s8q0`i' q`i', first m
}

g worried	= q1==1 if inlist(q1,1,2)
g healthy	= q2==1 if inlist(q2,1,2)
g fewfood	= q3==1 if inlist(q3,1,2)
g skipped	= q4==1 if inlist(q4,1,2)
g ateless	= q5==1 if inlist(q5,1,2)
g runout	= q6==1 if inlist(q6,1,2)
g hungry	= q7==1 if inlist(q7,1,2)
g whlday	= q8==1 if inlist(q8,1,2)

keep round hhid worried-whlday

*	get weight and hhsize vars 
d using "${tmp_hfps_uga}/panel/cover.dta"
mer 1:1 round hhid using "${tmp_hfps_uga}/panel/cover.dta", keepus(Rq05 urban /*r0_urban*/ wgt)
ta round _m
keep if _m==3
drop _m

mer 1:1 round hhid using "${tmp_hfps_uga}/panel/demog.dta", keepus(hhsize)
ta round _m
ta Rq05 if _m==1,m
su worried-whlday if _m==1
keep if inlist(_m,1,3)
drop _m


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta round RS,m

g na="NA" 
ta urban,m
recode urban (1/2=1)(3=0)

cap : erase "${tmp_hfps_uga}/fies/FIES_UGA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_uga}/fies/FIES_UGA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35, though worried is high at 0.32 
	3	downloaded and saved as FIES_UGA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
1	43.95	4.71	8.34	2.13
2	31.70	4.49	5.28	1.71
3	20.70	3.73	2.39	1.19
4	20.73	3.96	2.18	1.31
5	19.54	3.81	2.60	1.36
6	22.18	4.25	2.67	1.35
7	46.22	5.17	10.58	2.58
8	50.56	5.20	11.65	2.66
9	48.10	5.14	10.41	2.61
10	53.24	5.69	13.46	3.34
11	38.77	5.56	8.66	2.64
12	33.96	4.85	7.62	2.47
13	41.79	7.01	5.06	2.74
14	39.41	7.88	5.16	4.17
15	33.44	6.63	2.86	2.04
16	48.12	6.72	3.95	2.54
17	44.43	6.98	4.95	2.79
			*/

levelsof round, loc(rounds)
foreach r of local rounds {
// 	loc r=15
	cap : erase "${tmp_hfps_uga}/fies/FIES_UGA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_uga}/fies/FIES_UGA_r`r'_in.csv", delim(",")
}

	
	
	

/*
round 1 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r1_out.csv

round 2 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.36 & Healthy -0.38, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.45, but retained for consistency. All others 
		are <=.35
	3	downloaded and saved as FIES_UGA_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.47 & Healthy -0.39, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r4_out.csv

round 5 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.51 & Healthy -0.46, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r5_out.csv

round 6 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.57 & Healthy -0.37, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r6_out.csv

round 7 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.40 & Runout +0.45, but retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r7_out.csv

round 8 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r8_out.csv

round 9 
	1	All infit inrange(0.7,1.3)
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r9_out.csv

round 10 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +0.44, but retained for consistency. All others 
		are <=.35
	3	downloaded and saved as FIES_UGA_r10_out.csv

round 11 
	1	All infit inrange(0.7,1.3), though worried is 1.266
	2	Equating: All items are <=.35
	3	downloaded and saved as FIES_UGA_r11_out.csv

round 12 
	1	All infit inrange(0.7,1.3), although hungry is 0.730
	2	Equating: All items are <=.35, though healthy is -.33
	3	downloaded and saved as FIES_UGA_r12_out.csv

round 13 
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried is +.39 and skipped is -.45, but retained for 
		consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r13_out.csv

round 14 
	1	Worried at 1.343, Ateless at .680 & Hungry at .686, but retained all 
		according to pooled approach
	2	Equating: Skipped is -.51, RunOut is +.39 & Hungry is +.37. All are 
		retained for consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r14_out.csv

round 15 
	1	All infit inrange(0.7,1.3)
	2	Equating: Skipped is -.52, RunOut is +.39. All are retained for 
		consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r15_out.csv

round 16 
	1	All infit inrange(0.7,1.3)
	2	Equating: Skipped is -.38, retained for consistency. 
		All others are <=.35
	3	downloaded and saved as FIES_UGA_r16_out.csv

round 17 
	1	All infit inrange(0.7,1.3)
	2	Equating: Skipped is -.50, healthy is -.36. All are retained for 
		consistency. All others are <=.35
	3	downloaded and saved as FIES_UGA_r17_out.csv


*/


*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${tmp_hfps_uga}/fies/FIES_UGA_out.csv", varn(1) clear
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
import delimited using "${tmp_hfps_uga}/fies/FIES_UGA_r`r'_out.csv", varn(1) clear
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
ta RS round if _m!=3,	m
drop _m

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

keep round hhid fies_*
sa "${tmp_hfps_uga}/panel/fies.dta", replace
	
	
	

