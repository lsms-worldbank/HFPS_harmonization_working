

dir "${raw_hfps_mwi}", w	//	12b is the target 
dir "${raw_hfps_mwi}/sect8b_dietarydiversity_r*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_mwi}/sect8b_dietarydiversity_r19.dta"
d using	"${raw_hfps_mwi}/sect8b_dietarydiversity_r20.dta"

{	/*	comparing value label	*/
forv r=19/20 {
u	"${raw_hfps_mwi}/sect8b_dietarydiversity_r`r'.dta", clear
la li food_cat__id
uselabel food_cat__id
tempfile r`r'
sa		`r`r''
}
u `r19', clear
foreach r of numlist 20 {
	mer 1:1 value label using `r`r'', gen(_`r')
}
li, nol sep(0)

}

#d ; 
clear; append using 
	"${raw_hfps_mwi}/sect8b_dietarydiversity_r19.dta"
	"${raw_hfps_mwi}/sect8b_dietarydiversity_r20.dta"
	, gen(round); replace round=round+18; la drop _append; la val round; 
#d cr 

isid y4_hhid round food_id
ta round
ta round Sample_Type,m
drop s8bq2*	//	 we will ignore the source var 

*	partial reshape needed
/*	1	verify logical relationship

	*	51-4 are exhaustive for 50, but could overlap. Thus, we should expect 50>=max(51-4)
compare s8bq1 s8bq1_51 if food_id==50
compare s8bq1 s8bq1_52 if food_id==50
compare s8bq1 s8bq1_53 if food_id==50
compare s8bq1 s8bq1_54 if food_id==50

	*	61 & 62 are subsets but could overlap, we do not expect 61 | 62 > 60, but 60 can be > 61 + 62
compare s8bq1 s8bq1_61 if food_id==60
compare s8bq1 s8bq1_62 if food_id==60

	*	71 is a subset of 70, so must be 71<= 70
compare s8bq1 s8bq1_71 if food_id==70
*/

egen xxx = rowtotal(s8bq1_??)
compare s8bq1 xxx if food_id==50
compare s8bq1 xxx if food_id==60
compare s8bq1 xxx if food_id==70
ta xxx food_id,m

egen yyy = rowmax(s8bq1 xxx)
ta yyy
g zzz = min(yyy,7)
ta zzz s8bq1
// replace s8bq1 = zzz	//	don't take this step, since this represents an improvement 




	
ta s8bq1,m
su s8bq1_?? if !inrange(s8bq1,1,7)
su s8bq1_?? if  inrange(s8bq1,1,7)
preserve
collapse (max) s8bq1_?? , by(y4_hhid round)
reshape long s8bq1_, i(y4_hhid round) j(food_id)
ren s8bq?_ s8bq?
tempfile extracats
sa		`extracats'
restore
drop s8bq1_?? 
mer 1:1 y4_hhid round food_id using `extracats', assert(1 2) gen(_extra)
ta food_id _extra

g		days = s8bq1 if inrange(s8bq1,0,7)
replace days = 0 if s8bq1==.
replace days = 7 if s8bq1>7 & !missing(s8bq1)
g dum = (inrange(days,1,7))


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode food_id (10=1)(20=2)(30=12)(40=13)(50 51=9)(52=8)(53=11)(54=10)	/*
*/	(60=5)(61=3)(62=4)(70=7)(71=6)(80=14)(90=15)(100=16)(else=.), gen(HDDS_codes)
				 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
ta HDDS_cats
assert r(r)==12
*	make HDDS scores to combine at household level
bys y4_hhid round HDDS_cats (food_id) : egen HDDS_cat_max = max(dum)
by  y4_hhid round HDDS_cats : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode food_id
	(10=1)	/*	cereals, grains, cereal products	*/
	(20=2)	/*	roots, tubers, plantains	*/
	(30=3)	/*	nuts, pulses	*/
	(60/*62*/=4)	/*	vegetables	*/
	(70/*71*/=5)	/*	fruits	*/
	(51/54=6)	/*	meat, fish, eggs	*/
	(40=7)	/*	dairy	*/
	(90=8)	/*	sugar, sugar products, honey	*/
	(80=9)	/*	oils, fats	*/
	(100=.)	/*	condiments	*/
	(61 62 71 50=.)	/*	62, 71, 50 to drop	*/
	, copyrest gen(fcs_cats);
#d cr 
*	make weights per food consumption score category 
assert inrange(fcs_cats,1,9) | mi(fcs_cats)
ta fcs_cats
assert r(r)==9
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
bys y4_hhid round fcs_cats (food_id) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  y4_hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(y4_hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${tmp_hfps_mwi}/panel/dietary_diversity.dta", replace 



