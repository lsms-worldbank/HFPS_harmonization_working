
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d s5* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"	//	yes
d s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"	
d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r6_sect_5c.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	yes
d s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	not really
d s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r12_sect_5e_9a.dta"				//	no

d s5* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
// d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	yes, food prices
d s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
d s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices
d s5* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	fuel 
d s5* using	"${raw_hfps_nga2}/p2r10_sect_5.dta"	//	access only, no price 
u	"${raw_hfps_nga2}/p2r10_sect_5.dta", clear	//	base module, 9 items





d using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	
d using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	

u	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	, clear
la li food_code s5hq5
u	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	, clear
la li food_code 
u	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	, clear
la li destination_code 
	*	ignoring this module for now
	*	food codes are consistent between the two rounds so this is simplified 

dir "${raw_lsms_nga}"
u "${raw_lsms_nga}/sect10b_harvestw4.dta", clear
la li LABA
	*	food_code coding is already consistent with the LSMS coding 
	*	simply change the label for easier comparisons to the panel 


#d ; 
clear; append using 
	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	
	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	
	, gen(round);
#d cr
la drop _append
la val round 
ta round

replace round=round+18

g item=food_code 
run "${do_hfps_nga}/label_item.do"
la val item item
tab2 round s5hq1 s5hq2 s5hq3, first m




	compare s5hq4 s5hq6
	egen lcu = rowfirst(s5hq4 s5hq6)
	ta lcu
	la var	lcu	"Cost (LCU)"
	g q =1
	la var	q	"Quantity of [unit]"
	g kg=1 if !mi(s5hq4)
	la var kg		"Quantity (standard units)"
	
decode item, gen(itemstr)
ta itemstr

g		item_avail = (s5hq1==1)
la var	item_avail	"Item is available for sale"

g		price = lcu / kg
la var	price		"Price (LCU/standard unit)"

ta s5hq5 food_code, m
g		unitcost = lcu / q 
la var	unitcost	"Unit Cost (LCU/unit)"

*	bring the raw unit through 
decode s5hq5, gen(unitstr)
la var unitstr		"Unit"

		qui	{	/*	convert to standard units where possible	*/
		d using	"${hfps}/Input datasets/Nigeria/kgitemunit_new_NGA.dta"
		preserve
		u		"${hfps}/Input datasets/Nigeria/kgitemunit_new_NGA.dta", clear
		isid zone item_cd_alt s06bq02b s06bq02c, missok
		
		compare s06bq02_cvn s06bq07_cvn
		compare s06bq02b s06bq07b
		compare s06bq02c s06bq07c
		drop s06bq07*	//	identical
		
		ta zone
		ta item_cd_alt	//	matches 
		ren item_cd_alt item	//	simpler 
			
		ta s06bq02b	//	let's try string concatenation 
		tab1 s06bq02b s06bq02c 
		decode s06bq02b, gen(u)
		decode s06bq02c, gen(c)
		ta c
		g unitstr = u 
		replace unitstr = unitstr + substr(c,strpos(c,".")+1,length(c)-strpos(c,".")) if !mi(c)
		isid zone item unitstr,missok
		
		drop if mi(zone)	//shea butter, not relevant for us 
		isid zone item unitstr
		keep if !mi(s06bq02_cvn)
		keep zone item unitstr s06bq02_cvn
		tempfile cf 
		sa		`cf'
		restore
		
		d using "${tmp_hfps_nga}/cover.dta"
		
		mer m:1 hhid round using "${tmp_hfps_nga}/cover.dta", keepus(zone) assert(2 3) keep(3) nogen
		ta zone,m
		
		mer m:1 item unitstr zone using `cf', keepus(s06bq02_cvn)
		
		ta item if _merge==1
		ta unitstr _merge if item=="sorghum":item
		ta unitstr _merge if item=="rice":item
		ta unitstr _merge if item=="cassava":item
		ta unitstr _merge if item=="sweet potato":item
		ta unitstr _merge if item=="dry beans":item
		ta unitstr _merge if item=="onions":item
			*	need to massage the CFs to fill in more combinations potentially
		ta unitstr _merge
		keep if inlist(_merge,1,3)
		ta unitstr _merge
			*	next development - massage CFs and see if we can expand them, compare w/2018 as well 
		}	/*	end quiet brackets to bring in conversion factor	*/ 
		
		replace kg = s06bq02_cvn if _merge==3
		replace price = lcu / kg
		



*	assess values (briefly)
tabstat price, by(item) s(n me min max) format(%12.3gc)	//	1.5m for 1 kg of cassava?
ta price round if item=="cassava":item
li item lcu q kg unitstr s06bq02_cvn price if price>10000 & !mi(price), sepby(item)
tabstat price if price<10000, by(item) s(n me min p5 p50 p95 max) format(%12.0fc)	//	1.5m for 1 kg of cassava?
replace price=. if price>20000 	// these do not appear plausible

tabstat unitcost, by(item) s(n me min max) format(%12.3gc)
li item lcu q kg unitstr s06bq02_cvn unitcost price if unitcost>1000000 & !mi(unitcost), sepby(item)
drop if lcu==1500050	//	this case is not plausible 


keep  hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  hhid round item
sort  hhid round item
sa "${tmp_hfps_nga}/price.dta", replace 
 
 ex

dir "${raw_lsms_nga}"

*	take the above as starting point and merge to conversion factors provided
u "${tmp_hfps_nga}/price.dta", clear 
ta item round
la li item
ta unitstr




























