



dir "${raw_hfps_tza}", w


d s* using	"${raw_hfps_tza}/r6_sect_6.dta"
d s* using	"${raw_hfps_tza}/r7_sect_6.dta"
d s* using	"${raw_hfps_tza}/r7_sect_7.dta"
d s* using	"${raw_hfps_tza}/r7_sect_8.dta"	//	ignoring transportation for now 
d s* using	"${raw_hfps_tza}/r8_sect_6.dta"
d s* using	"${raw_hfps_tza}/r8_sect_7.dta"
d s* using	"${raw_hfps_tza}/r8_sect_8.dta"
d s* using	"${raw_hfps_tza}/r9_sect_6.dta"	//	food
d s* using	"${raw_hfps_tza}/r9_sect_7.dta"	//	fuel
d s* using	"${raw_hfps_tza}/r9_sect_8.dta"	//	transportation
d s* using	"${raw_hfps_tza}/r10_sect_6.dta"	//	food
d s* using	"${raw_hfps_tza}/r10_sect_7.dta"	//	fuel
d s* using	"${raw_hfps_tza}/r10_sect_8.dta"	//	transportation
d s* using	"${raw_hfps_tza}/r11_sect_6.dta"	//	food
d s* using	"${raw_hfps_tza}/r11_sect_7.dta"	//	fuel
d s* using	"${raw_hfps_tza}/r11_sect_8.dta"	//	transportation


qui : label_inventory "${raw_hfps_tza}", pre(`"r"') suf(`"_sect_6.dta"') vallab retain
li lname value label matches rounds if strpos(lname,"t0")==0, sepby(lname)
qui : label_inventory "${raw_hfps_tza}", pre(`"r"') suf(`"_sect_7.dta"') vallab retain
li lname value label matches rounds if strpos(lname,"t0")==0, sepby(lname)
qui : label_inventory "${raw_hfps_tza}", pre(`"r"') suf(`"_sect_8.dta"') vallab retain
li lname value label matches rounds if strpos(lname,"t0")==0, sepby(lname)

u	"${raw_hfps_tza}/r6_sect_6.dta", clear 
#d ; 
recode item_cd 
          (10=105) 	/*	Maize flour		*/
          (11=202) 	/*	Cassava flour	*/
          (13=102) 	/*	Rice			*/
          (16=1081) /*	Wheat flour		*/
          (17=301) 	/*	Sugar			*/
          (18=1001) /*	Cooking oil		*/
	, gen(item); 
#d cr 
run "${do_hfps_tza}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta item_cd item 
la var item	"Item code"

decode item, gen(itemstr)
la var itemstr	"Item code"

g item_avail=(s6q1==1)
la var	item_avail	"Item is available for sale"

g unitstr = "KG"	
g price = s6q2
la var price		"Price (LCU/standard unit)"

g unitcost = s6q2	//	no units collected for TZ so these will match
la var	unitcost	"Unit Cost (LCU/unit)"

isid  hhid item
keep  hhid item itemstr item_avail unitstr price unitcost 
g round=6, b(hhid)
tempfile r6
sa		`r6'




#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_7.dta"
	"${raw_hfps_tza}/r8_sect_7.dta"
	"${raw_hfps_tza}/r9_sect_7.dta"
	"${raw_hfps_tza}/r10_sect_7.dta"
	"${raw_hfps_tza}/r11_sect_7.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode fuel_cd 
          (1=7001) 	/*	petrol		*/
		  (2=7002)	/*	diesel		*/
		  (3=7004)	/*	lpg			*/
          (5=7005) 	/*	kerosene	*/
	, gen(item); 
#d cr 
run "${do_hfps_tza}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta fuel_cd item 
la var item	"Item code"

ta s7q2	//	4 categories here 
g item_avail=(inlist(s7q2,1,2,3))
la var	item_avail	"Item is available for sale"

g unitstr = "L" 
la var unitstr		"Unit"

g price = s7q5 / s7q4
la var price		"Price (LCU/standard unit)"


isid round hhid item
keep round hhid item  item_avail unitstr price	// unitcost
tempfile fuel
sa		`fuel'

#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_6.dta"
	"${raw_hfps_tza}/r8_sect_6.dta"
	"${raw_hfps_tza}/r9_sect_6.dta"
	"${raw_hfps_tza}/r10_sect_6.dta"
	"${raw_hfps_tza}/r11_sect_6.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode item_cd 
          (10=105) 	/*	Maize flour		*/
          (11=102) 	/*	Rice			*/
		  (12=401)	/*	Dry beans	*/
		  (14=802)	/*	beef/sausage	*/
          (16=301) 	/*	Sugar			*/
          (17=1001) /*	Cooking oil		*/
          (18=1003) /*	Salt		*/
	, gen(item); 
#d cr 
run "${do_hfps_tza}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta item_cd item 
la var item	"Item code"

g item_avail=(s6q1==1)
la var	item_avail	"Item is available for sale"

g unitstr = "KG" 
la var unitstr		"Unit"

g price = s6q5
la var price		"Price (LCU/standard unit)"


isid round hhid item
keep round hhid item  item_avail unitstr price	// unitcost 


g unitcost = price, a(price)	//	no units collected for TZ so these will match
la var	unitcost	"Unit Cost (LCU/unit)"

append using `fuel'
isid round hhid item
decode item, gen(itemstr)
la var itemstr	"Item code"
append using `r6'

*	harmonization vars 
g q=1
la var	q	"Quantity of [unit]"
g kg=1
la var kg	"Quantity (standard units)"
g lcu=price
la var	lcu	"Cost (LCU)"




keep  hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item


   sa "${tmp_hfps_tza}/price.dta", replace 
   u  "${tmp_hfps_tza}/price.dta", clear 
ta item round	

*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg or cassava?
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)

ex

*	modifications for construction of grand panel 
u "${tmp_hfps_tza}/cover.dta", clear


egen pnl_hhid = group(hhid)
li t0_region t0_district t0_ward t0_village t0_ea in 1/10
li t0_region t0_district t0_ward t0_village t0_ea in 1/10, nol

egen pnl_admin1 = group(t0_region)
egen pnl_admin2 = group(t0_region t0_district)
egen pnl_admin3 = group(t0_region t0_district t0_ward)

ta urban_rural, m
g pnl_urban = (urban_rural==2)
g pnl_wgt = wgt 
sa "${tmp_hfps_tza}/pnl_cover.dta", replace 


