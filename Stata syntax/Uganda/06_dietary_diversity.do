


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
dir "${raw_hfps_uga}/round18", w




*/



d using "${raw_hfps_uga}/round12/SEC18.dta"	//	no
d using "${raw_hfps_uga}/round13/SEC18.dta"
d using "${raw_hfps_uga}/round14/SEC18.dta"
d using "${raw_hfps_uga}/round15/SEC18.dta"
d using "${raw_hfps_uga}/round16/SEC18.dta"
d using "${raw_hfps_uga}/round17/SEC18.dta"
d using "${raw_hfps_uga}/round18/SEC18.dta"

*	verify consistent structure across time 
foreach r of numlist 13/18 {
	u  "${raw_hfps_uga}/round`r'/SEC18.dta", clear
	la dir
	uselabel `r(names)', clear
	tempfile r`r'
	sa		`r`r''
	}
u `r13', clear
foreach r of numlist 14/18 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
}
sort lname value label
egen short = ends(label), head punct(:)
li short value _*, sepby(lname) nol
*	code does switch between 14 and 15, 
li value label if lname=="food_consumpn_score__id" & inlist(_14,3), sep(0)
li value label if lname=="food_consumpn_score__id" & inlist(_15,2,3), sep(0)
li value short if lname=="food_consumpn_score__id" & inlist(_14,3), sep(0)
li value short if lname=="food_consumpn_score__id" & inlist(_15,2,3), sep(0)

#d ; 
clear; append using
	"${raw_hfps_uga}/round13/SEC18.dta"
	"${raw_hfps_uga}/round14/SEC18.dta"
	"${raw_hfps_uga}/round15/SEC18.dta"
	"${raw_hfps_uga}/round16/SEC18.dta"
	"${raw_hfps_uga}/round17/SEC18.dta"
	"${raw_hfps_uga}/round18/SEC18.dta"
	, gen(round); la drop _append; la val round .; replace round=round+12; 
#d cr 
isid hhid round food_consumpn

ta food_consumpn s18q01,m


generate days = s18q01 if inrange(s18q01,0,7)
replace  days = 0 if s18q01==.
replace  days = 7 if s18q01>7 & !missing(s18q01)
g dum = (inrange(days,1,7))


*	code 4 appears to be an overall sum constructed for codes 5-8 -> is it mechanical, or can the results differ? 
ta days food_ if round==15 & inrange(food_,4,8),m
ta days food_ if round==16 & inrange(food_,4,8),m
ta days food_ if round==17 & inrange(food_,4,8),m	//	everybody is eating meat at least once a week
bys hhid round (food_) : egen aaa = sum(days) if inrange(food,5,8) & inrange(round,15,17)
bys hhid round (food_) : egen bbb = max(aaa)
compare bbb days if food_==4	//	majority the sum is greater than the value under component 4 
	*->	we will prefer the parts, since sum of parts can exceed total meat days 
	*	in cases when the hh ate meat items from two groups in the same day. 
bys hhid round (food_) : egen ccc = max(bbb<days & food_==4)
ta bbb days if food_==4 & ccc==1	//	59 cases 
ta round if food_==4 & ccc==1
	*	corollary to the assumption above, we will assume these are cases where 
	*	the detailed data are more reliable. 
	
drop if round>14 & food_==4
replace food_=food_-1 if food_>4 & round>14

drop aaa bbb ccc

**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
	*	due to code switch, this is done in two versions 
recode food_consumpn_score__id (2=12)(3=13)(4=9)(5=8)(6=11)(7=10)(8=5)(9=3)(10=4)(11=7)(12=6)(13=14)(14=15)(15=16), copyrest gen(HDDS_codes)
				/*	tubers were binned with code 1	*/ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
*	make HDDS scores to combine at household level
bys hhid round HDDS_cats (food_consumpn_score__id) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_cats : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode food_consumpn_score__id
				/*	tubers were omitted	*/ 
	(2=3)		/*	nuts, pulses	*/ 
	(8/10=4)		/*	vegetables	*/
	(11/12=5)		/*	fruits	*/
	(4/7=6	)	/*	meat, fish, eggs	*/
	(3=7)		/*	dairy	*/
	(13=9)		/*	oils, fats	*/
	(14=8)	/*	sugar, sugar products, honey	*/
	(15=.)	/*	exclude condiments	*/ 
	, copyrest gen(fcs_cats);
#d cr 
*	make weights per food consumption score category 
assert inrange(fcs_cats,1,9) | mi(fcs_cats)
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
bys hhid round fcs_cats (food_consumpn_score__id) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${tmp_hfps_uga}/dietary_diversity.dta", replace 



