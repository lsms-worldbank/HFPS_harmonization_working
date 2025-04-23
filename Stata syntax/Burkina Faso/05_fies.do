

*	FIES
// u "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", clear
// d fies_mod_r*
// u "${hfps}/Phase 1 Harmonized/data/MWI_2020_HFPS_v01_M_v01_A_COVID_Stata/mwi_hh.dta", clear
// d fies_mod_r*
// u "${hfps}/Phase 1 Harmonized/data/NGA_2020_NLPS_v01_M_v02_A_COVID_Stata/nga_hh.dta", clear
// d fies_mod_r*
// u "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", clear
// d fies_mod_r*
//
//
// dir "${fies_hfps_bfa}", w
// dir "${fies_hfps_eth}", w
// dir "${fies_hfps_mwi}", w
// dir "${fies_hfps_nga}", w
// dir "${fies_hfps_tza}", w
// dir "${fies_hfps_uga}", w
//
// d using "${fies_hfps_bfa}/BFA_FIES_round2_raw.dta"
// d using "${fies_hfps_bfa}/BF_FIES_round3_raw.dta"
//
// dir "${raw_hfps_bfa}", w	//we need section 7 
// dir "${raw_hfps_bfa}/r*_sec7_securite_alimentaire.dta", w	//we need section 7 


// d using	"${raw_hfps_bfa}/r1_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r2_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r3_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r4_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r5_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r6_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r7_sec7_securite_alimentaire.dta"		
// d using	"${raw_hfps_bfa}/r8_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r9_sec7_securite_alimentaire.dta"		
d using	"${raw_hfps_bfa}/r10_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r11_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r12_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r13_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r14_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r15_sec7_securite_alimentaire.dta"	
// d using	"${raw_hfps_bfa}/r16_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r17_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r18_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r19_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r20_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r21_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r22_sec7_securite_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r23_sec7_securite_alimentaire.dta"	



u "${raw_hfps_bfa}/r2_sec2_liste_membre_menage.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos2 type2 isnum2 fmt2 val2 var2)
tempfile base
sa      `base'
foreach r of numlist 3/7 9/11 13 15 17/23 {
	u "${raw_hfps_bfa}/r`r'_sec2_liste_membre_menage.dta" , clear
	d, replace clear
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
	u `base', clear
	mer 1:1 name using `r`r'', gen(_`r')
	sa `base', replace 
}
u `base', clear

egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var2 if matches>=10, sep(0)



*	variable label inventory
label_inventory `"${raw_hfps_bfa}"', pre(`"r"') suf(`"_sec7_securite_alimentaire.dta"')	/*
*/	varname vallab 	/*vardetail varname diagnostic retain*/  



#d ; 
clear; append using

	"${raw_hfps_bfa}/r2_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r3_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r4_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r5_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r6_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r7_sec7_securite_alimentaire.dta"		

	"${raw_hfps_bfa}/r9_sec7_securite_alimentaire.dta"		
	"${raw_hfps_bfa}/r10_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r11_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r13_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r15_sec7_securite_alimentaire.dta"	

	"${raw_hfps_bfa}/r17_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r18_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r19_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r20_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r21_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r22_sec7_securite_alimentaire.dta"	
	"${raw_hfps_bfa}/r23_sec7_securite_alimentaire.dta"	

, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
replace round=round+1
replace round=round+1 if round>7
replace round=round+1 if round>11
replace round=round+1 if round>13
replace round=round+1 if round>15
	ta round
	
	la li onnspr
g worried	= s07q01=="Oui":onnspr if inlist(s07q01,"Non":onnspr,"Oui":onnspr)
g healthy	= s07q02=="Oui":onnspr if inlist(s07q02,"Non":onnspr,"Oui":onnspr)
g fewfood	= s07q03=="Oui":onnspr if inlist(s07q03,"Non":onnspr,"Oui":onnspr)
g skipped	= s07q04=="Oui":onnspr if inlist(s07q04,"Non":onnspr,"Oui":onnspr)
g ateless	= s07q05=="Oui":onnspr if inlist(s07q05,"Non":onnspr,"Oui":onnspr)
g runout	= s07q06=="Oui":onnspr if inlist(s07q06,"Non":onnspr,"Oui":onnspr)
g hungry	= s07q07=="Oui":onnspr if inlist(s07q07,"Non":onnspr,"Oui":onnspr)
g whlday	= s07q08=="Oui":onnspr if inlist(s07q08,"Non":onnspr,"Oui":onnspr)

tabstat worried healthy fewfood skipped ateless runout hungry whlday, by(round) s(n)
tabstat s07q01 s07q02 s07q03 s07q04 s07q05 s07q06 s07q07 s07q08, by(round) s(n)


*	get weight and hhsize vars 
d using "${tmp_hfps_bfa}/cover.dta"
mer 1:1 round hhid using "${tmp_hfps_bfa}/cover.dta", keepus(strate wgt)
ta round _merge
bys round (hhid) : egen min=min(_merge)
bys round (hhid) : egen max=max(_merge)
assert min==max
keep if _merge==3
drop _merge min max

mer 1:1 round hhid using "${tmp_hfps_bfa}/demog.dta", keepus(hhsize)
ta round _merge
bys round (hhid) : egen min=min(_merge)
bys round (hhid) : egen max=max(_merge)
keep if _merge==3 | min!=max
drop _merge min max


g wgt_hh = hhsize * wgt

egen RS = rowtotal(worried healthy fewfood skipped ateless runout hungry whlday), m
ta RS, m
recode RS (nonm=.) if mi(worried,healthy,fewfood,skipped,ateless,runout,hungry,whlday)
ta RS round,m

g na="NA" 
g urban = (strate!="Rural":strate)

cap : erase "${tmp_hfps_bfa}/fies/FIES_BFA_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban round	/*
*/	if /*!mi(RS) &*/ !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_bfa}/fies/FIES_BFA_in.csv", delim(",")
/*	notes on process done in Shiny app
	1	All infit inrange(0.7,1.3)
	2	Equating: Dropped runout (0.43), after that all items are <=.35
	3	downloaded and saved as FIES_BFA_out.csv
*/

/*	when using all, individual level (note that here "region" = survey round)
Prevalence rates of food insecurity by region (% of individuals)
Moderate or Severe	MoE	Severe	MoE
2	45.69	6.34	9.21	3.53
3	42.06	5.38	8.05	2.99
4	30.22	5.19	4.48	2.09
5	24.25	4.91	3.73	2.06
6	19.95	4.10	3.28	1.71
7	24.30	4.58	2.32	1.30
9	22.66	4.01	1.46	1.17
10	23.86	4.78	0.95	0.65
11	27.38	4.86	1.71	1.34
13	44.92	5.61	6.47	2.65
15	34.04	4.99	4.09	2.16
17	33.71	5.60	4.65	2.43
18	49.33	7.63	14.13	4.52
19	46.16	8.15	10.71	4.61
20	42.80	8.02	13.54	5.51
21	36.64	7.74	7.70	4.00
22	35.29	8.30	8.91	4.97
23	36.14	10.17	8.32	6.63
*/
										*	archive
										/*	notes on process done in Shiny app
											1	All infit inrange(0.7,1.3)
											2	Equating: Dropped runout (0.43), after that all items are <=.35
											3	downloaded and saved as FIES_BFA_out.csv
										*/
										
										/*	when using all, individual level (note that here "region" = survey round)
										Prevalence rates of food insecurity by region (% of individuals)
										Moderate or Severe	MoE	Severe	MoE
										2	45.69	6.35	9.12	3.51
										3	42.05	5.38	7.98	2.97
										4	30.21	5.19	4.44	2.08
										5	24.23	4.91	3.70	2.05
										6	19.93	4.10	3.25	1.70
										7	24.29	4.58	2.29	1.30
										9	22.63	4.01	1.45	1.16
										10	23.85	4.79	0.93	0.64
										11	27.36	4.86	1.70	1.33
										13	44.92	5.62	6.41	2.64
										15	34.04	4.99	4.05	2.14
										17	33.70	5.61	4.61	2.42
										18	49.33	7.63	14.00	4.49
										19	46.16	8.15	10.62	4.58
										20	42.79	8.03	13.45	5.49
										21	36.63	7.75	7.64	3.98
										22	35.29	8.31	8.85	4.95
										*/
										/*	notes on process done in Shiny app
											1	All infit inrange(0.7,1.3), though worried on the high side at 1.208
											2	Equating: Dropped runout (0.41), after that all items are <=.35
											3	downloaded and saved as FIES_BFA_out.csv
										*/
										
										/*	when using all, individual level (note that here "region" = survey round)
										Prevalence rates of food insecurity by region (% of individuals)
										Moderate or Severe	MoE	Severe	MoE
										2	45.94	6.38	8.51	3.35
										3	42.29	5.43	7.49	2.86
										4	30.35	5.24	4.15	1.99
										5	24.31	4.95	3.47	1.96
										6	19.96	4.13	3.05	1.62
										7	24.39	4.63	2.12	1.23
										9	22.76	4.07	1.33	1.10
										10	24.01	4.84	0.83	0.59
										11	27.57	4.92	1.57	1.27
										13	45.28	5.66	5.96	2.52
										15	34.31	5.05	3.79	2.06
										17	33.94	5.67	4.33	2.33
										18	49.50	7.68	13.06	4.32
										19	46.39	8.20	9.94	4.38
										*/
										/*	notes on process done in Shiny app
											1	All infit inrange(0.7,1.3), though worried on the high side at 1.218
											2	Equating: Dropped runout (0.41), after that all items are <=.35
											3	downloaded and saved as FIES_BFA_out.csv
										*/
										
										/*	when using all, individual level (note that here "region" = survey round)
										Prevalence rates of food insecurity by region (% of individuals)
										Moderate or Severe	MoE	Severe	MoE
										2	44.36	6.44	7.14	2.95
										3	40.62	5.44	6.36	2.54
										4	28.89	5.19	3.50	1.76
										5	22.90	4.90	2.95	1.74
										6	18.75	4.06	2.58	1.41
										7	22.88	4.56	1.75	1.08
										9	21.02	3.95	1.10	0.97
										10	22.39	4.76	0.64	0.49
										11	25.71	4.85	1.31	1.11
										13	43.39	5.66	4.96	2.22
										15	32.45	4.98	3.20	1.82
										17	32.26	5.60	3.67	2.08
										18	48.46	7.69	10.95	3.85
										*/

levelsof round, loc(rounds)
foreach r of local rounds {
// 	loc r=23
	cap : erase "${tmp_hfps_bfa}/fies/FIES_BFA_r`r'_in.csv"
export delim worried healthy fewfood skipped ateless runout hungry whlday wgt wgt_hh urban na	/*
*/	if round==`r' & !mi(wgt) & !mi(wgt_hh) using "${tmp_hfps_bfa}/fies/FIES_BFA_r`r'_in.csv", delim(",")
}

*	If we do round by round, the results do differ. 
*	however, the round 3 constructed using this data also differs from the round 3 previously constructed
*	it is possible that the weight changed and this was the entire driver of difference, 
	*-> we ahve to compare these somehow 
	/*
	preserve
import delim using "${tmp_hfps_bfa}/fies/FIES_BFA_r3_in.csv", delim(",") clear 
g row=_n
tempfile public
sa		`public'
import delim using "${fies_hfps_bfa}/FIES_BFround3_in.csv", delim(",") clear 
g row=_n
d
append using `public', gen(public)
isid row public
la val public 
ta public	
tabstat hhwcovid_r3_cs wt_hh wgt wgt_hh, by(public) s(sum) format(%12.0gc)	//	identical
tabstat worried-whlday, by(public) s(sum) format(%12.0gc)	//	identical
tabstat urban, by(public) s(sum) format(%12.0gc)	//	identical
	restore
	*/
	


/*
round 2 
	1	Hungry infit is 0.698, otherwise inrange(0.7,1.3). Retained as this is 
		not seen in other rounds for BF 
	2	Equating: All items are <=.35, though runout is close at 0.34 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r2_out.csv

round 3 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.27 
	2	Equating: All items are <=.35, though runout is close at 0.35 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r3_out.csv

round 4 
	1	All infit inrange(0.7,1.3). 
	2	Equating: runout is 0.36, droppedn and then all items are <=.35
	3	downloaded and saved as FIES_BFA_r4_out.csv

round 5 
	1	Worried high at 1.393, retained for consistency with other rounds 
	2	Equating: runout is 0.42 - dropped. 
	3	downloaded and saved as FIES_BFA_r5_out.csv

round 6 
	1	Worried high at 1.411, but retained for conssitency with other rounds. 
		All other infit inrange(0.7,1.3).
	2	Equating: runout is 0.50 - dropped.
	3	downloaded and saved as FIES_BFA_r6_out.csv

round 7 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.22 
	2	Equating: runout is 0.63 - dropped.
	3	downloaded and saved as FIES_BFA_r7_out.csv

round 9 
	1	Healthy high at 1.392. Retained for consistency with other rounds.  
	2	Equating: runout is 0.53 - dropped.
	3	downloaded and saved as FIES_BFA_r9_out.csv

round 10 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.299 
	2	Equating: runout is 0.56 - dropped.
	3	downloaded and saved as FIES_BFA_r10_out.csv

round 11 
	1	All infit inrange(0.7,1.3). Worried a bit high at 1.23 
	2	Equating: All items are <=.35, though runout is close at 0.31 - dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r11_out.csv

round 13 
	1	All infit inrange(0.7,1.3). 
	2	Equating: All items are <=.35, runout is fine at 0.21, but dropped
		for consistency with other roudns
	3	downloaded and saved as FIES_BFA_r13_out.csv

round 15 
	1	All infit inrange(0.7,1.3). 
	2	Equating: runout is 0.41 - dropped.
	3	downloaded and saved as FIES_BFA_r15_out.csv

round 17 
	1	All infit inrange(0.7,1.3).
	2	Equating: runout is 0.38 - dropped.
	3	downloaded and saved as FIES_BFA_r17_out.csv

round 18 
	1	Hungry low at 0.678. Retained for consistency with other rounds. 
	2	Equating: runout is 0.53 - dropped.
	3	downloaded and saved as FIES_BFA_r18_out.csv

round 19 
	1	All infit inrange(0.7,1.3).
	2	Equating: runout is 0.29 while skipped is .43. Dropped runout for  
		consistency with other rounds, though note that Skipped is now still .39
	3	downloaded and saved as FIES_BFA_r19_out.csv

round 20 
	1	All infit inrange(0.7,1.3). Fewfood very high at 1.299, but retain for 
		consistency
	2	Equating: runout is 0.52 while skipped is low at .49. Dropped runout for  
		consistency with other rounds, though note that Skipped is now still -.41
		and Hungry at +.38
	3	downloaded and saved as FIES_BFA_r20_out.csv

round 21 
	1	All infit inrange(0.7,1.3).
	2	Equating: runout is 0.29 while skipped is very low at -.64. 
		Dropped runout for consistency with other rounds, leaving Skipped
		at -.61	
	3	downloaded and saved as FIES_BFA_r21_out.csv

round 22 
	1	All infit inrange(0.7,1.3), though hungry is low at 0.71
	2	Equating: runout is 0.82 while wholeday and skipped are low at -.76 and
		-.66 respectively. 
		Dropped runout for consistency with other rounds, leaving Skipped
		at -.61	
	3	downloaded and saved as FIES_BFA_r22_out.csv

round 23 
	1	All infit inrange(0.7,1.3), though hungry is low at 0.73
	2	Equating: skipped is low at -.59. 
		Dropped runout for consistency with other rounds, leaving Skipped
		at -.55	
	3	downloaded and saved as FIES_BFA_r23_out.csv


*/





*	merge the downloaded files back in 
	preserve
tempfile out
import delimited using "${hfps}/Input datasets/FIES/FIES_BFA_out.csv", varn(1) clear
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
import delimited using "${hfps}/Input datasets/FIES/FIES_BFA_r`r'_out.csv", varn(1) clear
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

keep round hhid fies_*
sa "${tmp_hfps_bfa}/fies.dta", replace
	
	
	



























































