
*	two separate directories for phase 1 & 2

*	looking for section 8 
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w

d using	"${raw_hfps_nga1}/r1_sect_1.dta"
d using	"${raw_hfps_nga1}/r2_sect_1.dta"
d using	"${raw_hfps_nga1}/r3_sect_1.dta"
d using	"${raw_hfps_nga1}/r4_sect_1.dta"
d using	"${raw_hfps_nga1}/r5_sect_1.dta"
d using	"${raw_hfps_nga1}/r6_sect_1.dta"
d using	"${raw_hfps_nga1}/r7_sect_1.dta"
d using	"${raw_hfps_nga1}/r8_sect_1.dta"
d using	"${raw_hfps_nga1}/r9_sect_1.dta"
d using	"${raw_hfps_nga1}/r10_sect_1.dta"
d using	"${raw_hfps_nga1}/r11_sect_1.dta"
d using	"${raw_hfps_nga1}/r12_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r10_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r11_sect_1.dta"


d s8* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d s8* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
// d s8* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d s8* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
// d s8* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d s8* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
// d s8* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
// d s8* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
// d s8* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"
// d s8* using	"${raw_hfps_nga1}/r12_sect_a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
d s8* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d s8* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
d s8* using	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"
// d s8* using	"${raw_hfps_nga2}/p2r11_sect_a_6_6d_13b_12.dta"





#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"
, gen(round);

#d cr
keep hhid round s8q*

	la drop _append
	la val round 
	ta round 	
	replace round=round+1 if round>2
	replace round=round+2 if round>4
	replace round=round+10 if round>7
	replace round=round+2 if round>18
	ta round
	
d s8q?
la li s8q1 s8q2 s8q3 s8q4 s8q5 s8q6 s8q7 s8q8

g worried	= s8q1=="1. YES":s8q1 if inlist(s8q1,"2. NO":s8q1,"1. YES":s8q1)
g healthy	= s8q2=="1. YES":s8q2 if inlist(s8q2,"2. NO":s8q2,"1. YES":s8q2)
g fewfood	= s8q3=="1. YES":s8q3 if inlist(s8q3,"2. NO":s8q3,"1. YES":s8q3)
g skipped	= s8q4=="1. YES":s8q4 if inlist(s8q4,"2. NO":s8q4,"1. YES":s8q4)
g ateless	= s8q5=="1. YES":s8q5 if inlist(s8q5,"2. NO":s8q5,"1. YES":s8q5)
g runout	= s8q6=="1. YES":s8q6 if inlist(s8q6,"2. NO":s8q6,"1. YES":s8q6)
g hungry	= s8q7=="1. YES":s8q7 if inlist(s8q7,"2. NO":s8q7,"1. YES":s8q7)
g whlday	= s8q8=="1. YES":s8q8 if inlist(s8q8,"2. NO":s8q8,"1. YES":s8q8)

la li s8q6a s8q7a s8q8a	//	same as frequency, do not copy labels over we will just use frequency 
for num 6 7 8 : ta s8qX s8qXa,m
g runout_freq = s8q6a if runout==1
g hungry_freq = s8q7a if hungry==1
g whlday_freq = s8q8a if whlday==1
la copy s8q6a frequency
la val *_freq frequency


*	get weight and hhsize vars 
d using "${tmp_hfps_nga}/cover.dta"
mer 1:1 round hhid using "${tmp_hfps_nga}/cover.dta", keepus(sector wgt)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
assert min==max
keep if _m==3
drop _m min max

mer 1:1 round hhid using "${tmp_hfps_nga}/demog.dta", keepus(hhsize)
ta round _m
bys round (hhid) : egen min_m=min(_merge)
bys round (hhid) : egen max_m=max(_merge)
keep if _m==3 | min!=max
drop _m min max


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m
tabstat wgt wgt_hh, by(round) s(n)

g na="NA" 
g urban = (sector=="1. Urban":sector)

cap : erase "${tmp_hfps_nga}/fies/FIES_NGA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if round!=1 & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_nga}/fies/FIES_NGA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3)
	2	Equating: Worried +.97, skipped -.70. Several 
		others >0.35
		1	dropped worried => fewfood +.48, skipped -.52
		2	dropped skipped => fewfood still hgh at .38
		3	dropped fewfood => remainder <=.35 
	3	downloaded and saved as FIES_NGA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
2	75.88	4.94	33.21	4.91
4	71.70	5.61	34.93	5.21
7	60.16	5.54	19.91	3.99
18	64.96	5.32	25.98	4.59
21	57.56	8.00	18.55	5.69
22	69.94	6.59	26.97	6.08
*/
					/*	ARCHIVE: notes on process done in Shiny app
						1	All infit inrange(0.7,1.3)
						2	Equating: Worried very high at 0.99, skipped very low at 0.71. Several 
							others >0.35
							1	dropped worried => fewfood high at .50 skipped low at .53
							2	dropped skipped => fewfood still hgh at .40
							3	dropped fewfood => remainder <=.35 
						3	downloaded and saved as FIES_NGA_out.csv
					*/
					
					/*	when using all, individual level (note that here "region" = survey round)
					Prevalence rates of food insecurity by region (% of individuals)
						Moderate or Severe	MoE	Severe	MoE
					2	75.82	4.93	32.95	4.93
					4	71.66	5.60	34.72	5.25
					7	60.10	5.52	19.68	4.01
					18	64.91	5.31	25.77	4.61
					21	57.52	7.98	18.33	5.71
					*/

levelsof round if round!=1, loc(rounds)
foreach r of local rounds {
// 	loc r=22
	cap : erase "${tmp_hfps_nga}/fies/FIES_NGA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_nga}/fies/FIES_NGA_r`r'_in.csv", delim(",")
}


/*

round 2 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r2_out.csv

round 4 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r4_out.csv

round 7 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r7_out.csv

round 18 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r18_out.csv

round 21 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r21_out.csv

round 21 
	1	All infit inrange(0.7,1.3)
	2	Followed panel finding -> drop worried, skipped, fewfood. Remainder all <=0.35
	3	downloaded and saved as FIES_NGA_r22_out.csv


*/




*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${tmp_hfps_nga}/fies/FIES_NGA_out.csv", varn(1) clear
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
import delimited using "${tmp_hfps_nga}/fies/FIES_NGA_r`r'_out.csv", varn(1) clear
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

la var runout_freq	"Frequency of running out of food"
la var hungry_freq	"Frequency of being hungry but not eating"
la var whlday_freq	"Frequency of not eating for a whole day"
la val *_freq frequency
ren *_freq fies_*_freq


keep round hhid fies_*
sa "${tmp_hfps_nga}/fies.dta", replace
	
	
	

