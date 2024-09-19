
*	two separate directories for phase 1 & 2
dir "${raw_lsms_bfa}", w
d using "${raw_lsms_bfa}/s07b_me_bfa2018.dta"
u "${raw_lsms_bfa}/s07b_me_bfa2018.dta", clear
la li produitID
// la save produitID using "${do_hfps_bfa}/label_item.do", replace	//starting point
ta s07bq01 if s07bq02==1
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/*prix*.dta", w


d using	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r18_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r19_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r19_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r19_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r20_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r20_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r20_sec5t_prix_transport.dta"		
d using	"${raw_hfps_bfa}/r21_sec5c_prix_carburant.dta"		
d using	"${raw_hfps_bfa}/r21_sec5p_prix_denrees_alimentaires.dta"		
d using	"${raw_hfps_bfa}/r21_sec5t_prix_transport.dta"		

u	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta", clear
la li produit		//	coding hsa a spatial strata (Ougadougou vs oth urban vs rural)
u	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta", clear
la li produit		
la li s09eq02a_1
u	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta", clear
la li da
la li s05fq02
u	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta", clear
la li da
u	"${raw_hfps_bfa}/r18_sec5t_prix_transport.dta", clear
la li da

*	item codes are not harmonized across rounds, necessitating a recode 
foreach r of numlist 18(1)21 {
u	"${raw_hfps_bfa}/r`r'_sec5p_prix_denrees_alimentaires.dta", clear
uselabel da, clear
tempfile r`r'
sa		`r`r''
}
clear 
u `r18', clear
mer 1:1 value label using `r19', gen(_19)
mer 1:1 value label using `r20', gen(_20)
mer 1:1 value label using `r21', gen(_21)
*	code is stable, though 22 shifts slightly. Ignoring the shift 


{	/*	r18+ version	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r19_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r20_sec5c_prix_carburant.dta"
	"${raw_hfps_bfa}/r21_sec5c_prix_carburant.dta"
	, gen(round); la drop _append; la val round .;
#d cr
replace round=round+17
g item=carburant__id + 691
run "${do_hfps_bfa}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta carburant__id item 
la var item	"Item code"


g item_avail = inlist(s05cq02,1,2)	//	this is actual purchase here, not truly availability
la var	item_avail	"Item is available for sale"
g q=s05cq04
g kg=q
g lcu = s05cq05
g price =  s05cq05/s05cq04
la var	price		"Price (LCU/standard unit)"
g unitcost = price	//	in this case we will construct them as identical, though the LCU for total could also be of interest in the price variable
la var	unitcost	"Unit Cost (LCU/unit)"

g unit=302
g unitstr="Litre"
la var unitstr		"Unit"

keep  hhid round item item_avail q unitstr kg lcu price unitcost 
order hhid round item item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item
tempfile fuel
sa		`fuel'




dir "${hfps}/Input datasets/Burkina Faso"
d using "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta"
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li _all

u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
duplicates report
duplicates report	region milieu codpr uniteID tailleID
duplicates report	strate codpr uniteID tailleID
duplicates tag		strate codpr uniteID tailleID, gen(tag)
sort codpr uniteID tailleID region milieu 
li if tag>0, sepby(region milieu)	//	has two different results wit no label for why they are idfferent
ta codpr if tag>0
ta region milieu
la li s00q01 s00q04
recode region ( 9= 1)( 1= 2)(12= 3)( 8= 4)(13= 5)( 5= 6)( 6= 7)(11= 8)(10= 9)( 3=11)( 2=12)( 7=13)
collapse (p50) cf=poids_median, by(region milieu codpr uniteID tailleID)
replace cf=cf/1000	//	convert gm to kg 
tempfile cf
sa		`cf'

/*
u "${tmp_hfps_bfa}/panel/cover.dta", clear
ta strate milieu
ta region milieu
la li regione labmilieu
*/
	


#d ; 
clear; append using
	"${raw_hfps_bfa}/r18_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r19_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r20_sec5p_prix_denrees_alimentaires.dta"
	"${raw_hfps_bfa}/r21_sec5p_prix_denrees_alimentaires.dta"
	, gen(round); la drop _append; la val round .; 
#d cr 
replace round=round+17
isid hhid round denrees_alimentaires__id
la li da
#d ; 
recode denrees_alimentaires__id
	(10=6)		/*	maize grain	*/ 
	(11=3)		/*	imported rice	*/ 
	(12=104)	/*	cassava	*/
	(13=107)	/*	irish potato	*/
	(14=109)	/*	sweet potato	*/ 
	(15=12)		/*	maize flour	*/
	(16=111)	/*	cassava flour	*/
	(17=222)	/*	sorghum flour	*/
	(18=14)		/*	wheat flour	*/
	(19=95)		/*	dry bean	*/
	(20=75)		/*	fresh beans	*/
	(21=98)		/*	crushed peanuts	*/
	(22=23)		/*	beef	*/
	(23=44)		/*	fresh milk	*/
	(24=52)		/*	eggs	*/
	(25=17)		/*	bread	*/
	(26=83)		/*	onions	*/
	(27=79)		/*	tomato	*/
	(28=114)	/*	sugar	*/
	(29=55)		/*	cooking oil=palm oil here for simplicity	*/
	(30=130)	/*	tea	*/
	(31=118)	/*	salt	*/
	(32=901)	/*	fertilizer	*/
	(33=601)	/*	maize seed	*/
	(34=602)	/*	soy seed	*/
	(35=603)	/*	bean seed	*/
, gen(item); 
	#d cr
	
run "${do_hfps_bfa}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta denrees_alimentaires__id item 
la var item	"Item code"

g item_avail = (s05pq01==1)
la var	item_avail	"Item is available for sale"


la li s05pq03a
ta s05pq03a
compare s05pq05 s05pq07	//	never jointly defined

*	lacking a conversion factor, we will simply bring the raw unit through 
compare s05pq05 s05pq07		//	never jointly defined 
compare s05pq03a s05pq06a	//	some are jointly defined so greater care is needed
g q=1
g unit=cond(!mi(s05pq05),s05pq03a,cond(!mi(s05pq07),s05pq06a,.))
g size=cond(!mi(s05pq05),s05pq03b,cond(!mi(s05pq07),s05pq06b,.))
g kg = 1 if inlist(unit,100,302)	//	kg, l
recode kg (.=1000) if unit==301		//	tonne
egen lcu = rowfirst(s05pq05 s05pq07)
recode lcu (0=.)	//	free is not an acceptable price

la copy s05pq03a unit
la val unit unit
la copy s05pq03b size
la val size size
la li unit size

*	prepare to merge 
d using "${tmp_hfps_bfa}/panel/cover.dta"
mer m:1 hhid round using "${tmp_hfps_bfa}/panel/cover.dta" , assert(2 3) keep(3) nogen keepus(region milieu)
preserve 
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li l_Unite
restore 
la li unit
recode unit (302=102)(256 257 260 301=.), gen(uniteID)

preserve 
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li l_Taille
restore 
la li size
recode size (98 99=.), gen(tailleID)

g codpr = item
mer m:1 region milieu codpr uniteID tailleID using `cf'
bys codpr : egen zzz = min(_m)
ta codpr _m if zzz==1
ta codpr _m if zzz==1 & !mi(q) & !mi(lcu)

keep if inlist(_m,1,3)
replace kg = cf if mi(kg) & !mi(cf)

ta item unit if mi(kg) & !mi(lcu)
*	what about hte sacs with a specified nominal weight.
ta kg unit if inrange(unit,135,138)
recode kg (.=100) if unit==135 & !mi(lcu)
recode kg (.= 25) if unit==136 & !mi(lcu)
recode kg (.=  5) if unit==137 & !mi(lcu)
recode kg (.= 50) if unit==138 & !mi(lcu)
recode kg (.=1000) if unit==301 & !mi(lcu)
ta item unit if mi(kg) & !mi(lcu)



decode unit, gen(xx)
decode size, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

g price = lcu / kg
la var price		"Price (LCU/standard unit)"

g unitcost = lcu / q 
la var	unitcost	"Unit Cost (LCU/unit)"


keep  hhid round item item_avail q unitstr kg lcu price unitcost 
order hhid round item item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item

append using `fuel'
isid hhid item round

decode item, gen(itemstr)
la var itemstr	"Item code"

keep  hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item
tempfile r18 
sa		`r18'
}	/*	end r18+ version	*/


{	/*	r15/16 version	*/
#d ; 
clear; append using
	"${raw_hfps_bfa}/r15_sec9e_prix_denr_es_alimentaires.dta"
	"${raw_hfps_bfa}/r16_sec9e_prix_denr_es_alimentaires.dta"
	, gen(round); replace round=round+14; la val round .; la drop _append; 
recode produit__id (100/199=1)(200/299=2)(300/399=3), gen(urb); 
recode produit__id 
	(101 202 304=3)	/*	imported rice	*/ 
	(203=1)			/*	local rice	*/ 
	(102 201 301=6)	/*	maize grain	*/ 
	(103 205=12)	/*	maize flour	*/
	(104 204 305=17)	/*	modern bread	*/
	(105 303=7)	/*	millet	*/
	(302=8)	/*	Sorghum	*/
	(106 206 306=79)	/*	fresh tomato	*/
	(107 207 307=80)	/*	tomato concentrate	*/
	(108 208 308=95)	/*	cowpea / dried bean	*/
	(109 209 309=114)	/*	sugar	*/
	(110 210 310=52)	/*	eggs	*/
	(111 211 311=23)	/*	beef	*/
	(112 212 312=25)	/*	mutton	*/
	(113 213 313=36)	/*	horse mackerel (modal type in 2018)	*/
	(114 214 314=41)	/*	dried fish	*/
	(115 215 315=55)	/*	palm oil	*/
	
	(116 216 316=801)	/*	fuel for car	*/
	(117 217 317=802)	/*	fuel for motorcycle	*/
	(318=901)	/*	chemical fertilizer	*/
	, gen(item);
	#d cr
	
run "${do_hfps_bfa}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta produit__id item 
la var urb	"Spatial domain for prices"
la var item	"Item code"

ta sec9e round,m
drop if sec9e!=1
isid hhid round produit__id


decode item, gen(itemstr)
la var itemstr	"Item code"

g item_avail = (s09eq01==1)
la var	item_avail	"Item is available for sale"


la li s09eq02a_1
ta s09eq02a

g q=1
g unit=s09eq02a
la copy s09eq02a_1 unit
la val unit unit
g size=s09eq02b
la copy s09eq02b_1 size
la val size size
la li unit size
g kg = 1 if inlist(unit,100,302)	//	kg, l
recode kg (.=1000) if unit==301		//	tonne
g lcu = s09eq03 if s09eq03>0
la var	q		"Quantity of [unit]"
la var	kg		"Quantity (standard units)"
la var	lcu		"Cost (LCU)"


*	prepare to merge 
d using "${tmp_hfps_bfa}/panel/cover.dta"
mer m:1 hhid round using "${tmp_hfps_bfa}/panel/cover.dta" , assert(2 3) keep(3) nogen keepus(region milieu)
preserve 
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li l_Unite
restore 
la li unit
recode unit (302=102)(256 257 260 301=.), gen(uniteID)

preserve 
u "${hfps}/Input datasets/Burkina Faso/ehcvm_nsu_bfa2021.dta", clear
la li l_Taille
restore 
la li size
recode size (98 99=.), gen(tailleID)

g codpr = item
mer m:1 region milieu codpr uniteID tailleID using `cf'
bys codpr : egen zzz = min(_m)
ta codpr _m if zzz==1
ta codpr _m if zzz==1 & !mi(q) & !mi(lcu)

keep if inlist(_m,1,3)
replace kg = cf if mi(kg) & !mi(cf)


ta item unit if mi(kg) & !mi(lcu)
*	what about hte sacs with a specified nominal weight.
ta kg unit if inrange(unit,135,138)
recode kg (.=100) if unit==135 & !mi(lcu)
recode kg (.= 25) if unit==136 & !mi(lcu)
recode kg (.=  5) if unit==137 & !mi(lcu)
recode kg (.= 50) if unit==138 & !mi(lcu)
recode kg (.=1000) if unit==301 & !mi(lcu)
ta item unit if mi(kg) & !mi(lcu)



decode unit, gen(xx)
decode size, gen(yy)
egen unitstr = concat(xx yy)
assert !mi(unitstr) if !mi(xx)
ta unitstr if mi(yy)
la var unitstr		"Unit"

g price = lcu / kg
la var price		"Price (LCU/standard unit)"

g unitcost = lcu / q 
la var	unitcost	"Unit Cost (LCU/unit)"


keep  hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item

}	/*	end r15/16 version	*/


append using `r18'	/*	bring in the round 18 things	*/ 
isid  hhid round item
sort  hhid round item

su
tabstat kg lcu price unitcost, by(item) s(n)
tabstat kg lcu price unitcost, by(round) s(n)


su price unitcost 
replace price = . if price<=0
replace unitcost = . if unitcost<=0

sa "${tmp_hfps_bfa}/panel/price.dta", replace 

u  "${tmp_hfps_bfa}/panel/price.dta", clear
*	assess values (briefly)
tabstat price	, by(item) s(n me min max) format(%12.0fc)
tabstat unitcost, by(item) s(n me min max) format(%12.0fc)

li if price>25000 & !mi(price), 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
ex	
/*	access to food items, could be included but not currently 
d using	"${raw_hfps_bfa}/r1_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"		
d using	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"	
d using	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"	
// d using	"${raw_hfps_bfa}/r12_sec5_acces_service_base.dta"	
// d using	"${raw_hfps_bfa}/r13_sec5_acces_service_base.dta"	
// d using	"${raw_hfps_bfa}/r14_sec5_acces_service_base.dta"	
d using	"${raw_hfps_bfa}/r15_sec5_acces_aliments_base.dta"	
// d using	"${raw_hfps_bfa}/r16_sec5_acces_service_base.dta"	
// d using	"${raw_hfps_bfa}/r17_sec5_acces_service_base.dta"	
d using	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"	



u	"${raw_hfps_bfa}/r1_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"	, clear
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"	, clear
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r15_sec5_acces_aliments_base.dta"	, clear	
tab1 AlimBase?	//	staple grains
u	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"	, clear
tab1 AlimBase?	//	staple grains



#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r2_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r3_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r4_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r5_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r6_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r7_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r8_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r9_sec5_acces_service_base.dta"		
	"${raw_hfps_bfa}/r10_sec5_acces_service_base.dta"	
	"${raw_hfps_bfa}/r11_sec5_acces_service_base.dta"	

	"${raw_hfps_bfa}/r15_sec5_acces_aliments_base.dta"	

	"${raw_hfps_bfa}/r18_sec5_acces_aliments_biens_essentiels.dta"	

, gen(round);
#d cr
	la drop _append
	la val round 
	ta round 	
	la var round	"Survey round"
	isid hhid round
	sort hhid round
	
	*	this is all just availability stuff though
	

	*/
