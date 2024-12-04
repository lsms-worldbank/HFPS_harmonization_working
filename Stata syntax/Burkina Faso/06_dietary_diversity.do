

dir "${raw_hfps_bfa}", w	//we need section 7a 
dir "${raw_hfps_bfa}/r*fcs*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r18_sec7a_fcs_consommation_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r19_sec7a_fcs_consommation_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r20_sec7a_fcs_consommation_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r21_sec7a_fcs_consommation_alimentaire.dta"	
d using	"${raw_hfps_bfa}/r22_sec7a_fcs_consommation_alimentaire.dta"
d using	"${raw_hfps_bfa}/r23_sec7a_fcs_consommation_alimentaire.dta"
	
	

{	/*	simple check for changes across time	*/
loc r=18
u "${raw_hfps_bfa}/r`r'_sec7a_fcs_consommation_alimentaire.dta" , clear
d, replace clear
ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
tempfile base
sa      `base'
foreach r of numlist 19(1)23 {
	u "${raw_hfps_bfa}/r`r'_sec7a_fcs_consommation_alimentaire.dta" , clear
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
ta name matches
ta name matches if matches>=10
ta name matches if matches<10

levelsof name if matches>=10, clean
li name var18 if matches>=10, sep(0)

}
	
	
	
#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec7a_fcs_consommation_alimentaire.dta"	
	"${raw_hfps_bfa}/r19_sec7a_fcs_consommation_alimentaire.dta"	
	"${raw_hfps_bfa}/r20_sec7a_fcs_consommation_alimentaire.dta"	
	"${raw_hfps_bfa}/r21_sec7a_fcs_consommation_alimentaire.dta"	
	"${raw_hfps_bfa}/r22_sec7a_fcs_consommation_alimentaire.dta"	
	"${raw_hfps_bfa}/r23_sec7a_fcs_consommation_alimentaire.dta"	
	, gen(round); 
	la drop _append; la val round .; replace round=round+17; 
#d cr
isid hhid round
ta round subsample	
	drop *__*
	tab2 round s07*, first m	//	perfectly missing according to subsample. 
	d s07*
	keep if (inlist(round,18,20,22) & subsample==1) | (inlist(round,19,21) & subsample==2)
	
*	prepare to reshape to implement syntax as in other countries
ren (s07aq01a s07aq01b s07aq01c s07aq01d s07aq03_1d s07aq03_2d s07aq03_3d s07aq03_4d s07aq01e s07aq03_1e s07aq03_2e s07aq01f s07aq03_1f s07aq01g s07aq01h s07aq01i)	/*
*/	(d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16)
reshape long d, i(hhid round) j(foodcat)

generate days = d if inrange(d,0,7)
replace  days = 0 if d==.
replace  days = 7 if d>7 & !missing(d)
g dum = (inrange(days,1,7))	


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode foodcat (2=12)(3=13)(4=9)(5=9)(6=8)(7=11)(8=10)(9=5)(10=3)(11=4)(12=7)(13=6), copyrest gen(HDDS_codes)
				/*	tubers are binned with category 1, cannot separate. */ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
ta HDDS_cats	//	11 categories since we cannot separate grains and tubers
assert r(r)==11
*	make HDDS scores to combine at household level
bys hhid round HDDS_cats (foodcat) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_cats : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode foodcat
				/*	tubers were omitted	*/ 
	(2=3)		/*	nuts, pulses	*/ 
	(9/11=4)		/*	vegetables	*/
	(12/13=5)		/*	fruits	*/
	(4/8=6	)	/*	meat, fish, eggs	*/
	(3=7)		/*	dairy	*/
	(14=9)		/*	oils, fats	*/
	(15=8)	/*	sugar, sugar products, honey	*/
	(16=.)	/*	exclude condiments	*/ 
	, copyrest gen(fcs_cats);
#d cr 
*	make weights per food consumption score category 
assert inrange(fcs_cats,1,9) | mi(fcs_cats)
ta fcs_cats	//	no code 2-> no tubers 
#d ; 
recode fcs_cats 
	(1=2)	/*	cereals, grains, cereal products	*/
	(2=2)	/*	roots, tubers, plantains	*/
	(3=3)	/*	nuts, pulses	*/
	(4=1)	/*	vegetables	*/
	(5=1)	/*	fruits	*/
	(6=4)	/*	meat, fish, eggs	*/
	(7=4)	/*	dairy	*/
	(8=0.5)	/*	sugar, sugar products, honey	*/
	(9=0.5)	/*	oils, fats	*/
	, gen(fcs_weights);
#d cr 


*	make sum of days by category, truncating at 7 max for combined categories
bys hhid round fcs_cats (foodcat) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${tmp_hfps_bfa}/dietary_diversity.dta", replace 


	su
	
	

