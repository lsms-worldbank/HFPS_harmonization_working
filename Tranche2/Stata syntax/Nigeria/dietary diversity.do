

dir "${raw_hfps_nga2}", w	//	12b is the target 


d *s8a* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
u	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta", clear

keep hhid select_s8a-s8aq9 
g round=12+9
ta select_s8a
su if select_s8a!=1
keep if (round==21 & select_s8a==1)
ta round
ta round select_s8a,m

/*	1	verify logical relationship

	*	51-4 are exhaustive for 50, but could overlap. Thus, we should expect 50>=max(51-4)
compare s8aq4 s8aq4a 
compare s8aq4 s8aq4b 
compare s8aq4 s8aq4c 
compare s8aq4 s8aq4d 


	*	61 & 62 are subsets but could overlap, we do not expect 61 | 62 > 60, but 60 can be > 61 + 62
compare s8aq5 s8aq5a
compare s8aq5 s8aq5b

	*	71 is a subset of 70, so must be 71<= 70
compare s8aq6 s8aq6a
*/

#d ; 
ren (s8aq1 s8aq2 s8aq3 
	 s8aq4 s8aq4a s8aq4b s8aq4c s8aq4d 
	 s8aq5 s8aq5a s8aq5b 
	 s8aq6 s8aq6a 
	 s8aq7 s8aq8 s8aq9)
	(d10 d30 d40
	 d50 d51 d52 d53 d54
	 d60 d61 d62
	 d70 d71 
	 d80 d90 d100); 
reshape long d, i(hhid round) j(food); 
#d cr 
ta food d,m

g		days = d if inrange(d,0,7)
replace days = 0 if d==.
replace days = 7 if d>7 & !missing(d)
g dum = (inrange(days,1,7))


**	HDDS 
*	setting group codes equal to codes in dietary diversity questionnaire on p. 8 of FAO HDDS guidance (2010)  
recode food (10=1)(20=2)(30=12)(40=13)(50 51=9)(52=8)(53=11)(54=10)	/*
*/	(60=5)(61=3)(62=4)(70=7)(71=6)(80=14)(90=15)(100=16)(else=.), gen(HDDS_codes)
				 
*	making categories following table 3 p. 24 of FAO HDDS guidance (2010) 
recode HDDS_codes (3 4 5=3)(6 7=6)(8 9=8), gen(HDDS_cats)
ta HDDS_cats
assert r(r)==11	/*	tubers were binned with cereals	*/
*	make HDDS scores to combine at household level
bys hhid round HDDS_cats (food) : egen HDDS_cat_max = max(dum)
by  hhid round HDDS_cats : replace HDDS_cat_max = . if _n>1


**	FCS
*	make food consumption score categories
#d ; 
recode food
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
assert r(r)==8	/*	no distinct tubers	*/
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
bys hhid round fcs_cats (food) : egen fcs_cat_sum = sum(days)
*	truncate at 7, one obs per category 
by  hhid round fcs_cats : g fcs_cat_trunc = min(fcs_cat_sum,7) if _n==1
*	apply weights 
g fcs_cat_wtd = fcs_cat_trunc * fcs_weights


**	take to household level with collapse
collapse (sum) HDDS_w=HDDS_cat_max fcs_raw=fcs_cat_sum fcs_wtd=fcs_cat_wtd, by(hhid round)

la var HDDS_w		"Household Dietary Diversity Score (7 day)"
la var fcs_raw		"Food Consumption Score, Raw"
la var fcs_wtd		"Food Consumption Score, Weighted"


sa "${tmp_hfps_nga}/panel/dietary_diversity.dta", replace 



