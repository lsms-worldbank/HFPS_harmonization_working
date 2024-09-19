

dir "${raw_hfps_tza}", w	//	12b is the target 


d using	"${raw_hfps_tza}/r7_sect_12b.dta"
d using	"${raw_hfps_tza}/r8_sect_12b.dta"
d using	"${raw_hfps_tza}/r9_sect_12b.dta"
d using	"${raw_hfps_tza}/r10_sect_12b.dta"
{	/*	comparing value label	*/
forv r=7/10 {
u	"${raw_hfps_tza}/r`r'_sect_12b.dta", clear
la li foodcat_cd
uselabel foodcat_cd
tempfile r`r'
sa		`r`r''
}
u `r7', clear
forv r=8/10 {
	mer 1:1 value label using `r`r'', gen(_`r')
}
li, nol sep(0)

}

#d ; 
clear; append using 
	"${raw_hfps_tza}/r7_sect_12b.dta"
	"${raw_hfps_tza}/r8_sect_12b.dta"
	"${raw_hfps_tza}/r9_sect_12b.dta"
	"${raw_hfps_tza}/r10_sect_12b.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
#d cr 

isid hhid round foodcat_cd
ta round


g		days = s12bq1 if inrange(s12bq1,0,7)
replace days = 0 if s12bq1==.
replace days = 7 if s12bq1>7 & !missing(s12bq1)
g dum = (inrange(days,1,7))


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode foodcat_cd (10=1)(20=2)(30=12)(40=13)(50 51=9)(52=8)(53=11)(54=10)	/*
*/	(60=5)(61=3)(62=4)(70=7)(71=6)(80=14)(90=15)(100=16) , copyrest gen(HDDS_codes)
				/*	tubers were omitted	*/ 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
ta HDDS_cats
assert r(r)==12
*	make HDDS scores to combine at household level
bys hhid round HDDS_cats (foodcat_cd) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_cats : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode foodcat_cd
	(10=1)	/*	cereals, grains, cereal products	*/
	(20=2)	/*	roots, tubers, plantains	*/
	(30=3)	/*	nuts, pulses	*/
	(60/62=4)	/*	vegetables	*/
	(70/71=5)	/*	fruits	*/
	(50/54=6)	/*	meat, fish, eggs	*/
	(40=7)	/*	dairy	*/
	(90=8)	/*	sugar, sugar products, honey	*/
	(80=9)	/*	oils, fats	*/
	(100=.)	/*	condiments	*/ 
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
bys hhid round fcs_cats (foodcat_cd) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${tmp_hfps_tza}/panel/dietary_diversity.dta", replace 



