
/**/
dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*prices*", w

d using	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"
d using	"${raw_hfps_mwi}/sect11b_prices_r16.dta"
d using	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"
d using	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"
d using	"${raw_hfps_mwi}/sect11_transportprices_r17.dta"	//	will ignore this for now
d using	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"
d using	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"
d using	"${raw_hfps_mwi}/sect11_transportprices_r19.dta"	//	will ignore this for now

// u	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"		, clear
// la li fooditems__id s11q2
// u	"${raw_hfps_mwi}/sect11b_prices_r16.dta"		, clear
// la li fooditems__id	s11q2	// simple shift in code values, easy to modify r15 
// u	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"		, clear
// la li fooditems__id	//	code shift 
// u	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"		, clear
// la li fuel_items__id
// u	"${raw_hfps_mwi}/sect11_transportprices_r17.dta", clear	//	will ignore this for now
// *	item codes are not harmonized across rounds, necessitating a recode 
//
// u	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"		, clear
// la li fooditems__id	//	code shift 
// u	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"		, clear
// la li fuel_items__id
// u	"${raw_hfps_mwi}/sect11_transportprices_r19.dta", clear	//	will ignore this for now
// *	item codes are not harmonized across rounds, necessitating a recode 
//
// *	unit codes
// u	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"		, clear
// uselabel s11q2
// tempfile r15
// sa		`r15'
// u	"${raw_hfps_mwi}/sect11b_prices_r16.dta"		, clear
// uselabel s11q2
// tempfile r16
// sa		`r16'
// u	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"		, clear
// la li _all
// uselabel s11q6
// tempfile r17
// sa		`r17'
//
// u	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"		, clear
// la li _all
// uselabel s11q6
// tempfile r19
// sa		`r19'
//
// u `r15', clear
// mer 1:1 value label using `r16', gen(_r16)
// mer 1:1 value label using `r17', gen(_r17)
// mer 1:1 value label using `r19', gen(_r19)
// la drop _merge
// sort value label	
// duplicates list value
// list, sep(0)



label_inventory "${raw_hfps_mwi}", pre(`"sect11_foodprices_r"') suf(`".dta"') vallab
label_inventory "${raw_hfps_mwi}", pre(`"sect11_fuelprices_r"') suf(`".dta"') vallab
label_inventory "${raw_hfps_mwi}", pre(`"sect11_transportprices_r"') suf(`".dta"') vallab



u "${raw_lsms_mwi}/hh_mod_g1_19.dta", clear
la li item_labels 
la li hh_g03b
ta hh_g03b_label hh_g03c	//	C=large, A=small
	*	modifier units = pail, bunch, heap, satchet/tube, tina, cluster


u	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"		, clear
la li fooditems__id
la li s11q2
u	"${raw_hfps_mwi}/sect11b_prices_r16.dta"		, clear
la li fooditems__id	// simple shift in code values, easy to modify r15 
la li s11q2	//	transport units added, but also L & KG 



{	/*	end round 17+ version	*/

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect11_fuelprices_r17.dta"		
	"${raw_hfps_mwi}/sect11_fuelprices_r19.dta"		
	"${raw_hfps_mwi}/sect11_fuelprices_r20.dta"		
	"${raw_hfps_mwi}/sect11_fuelprices_r21.dta"		
	, gen(round); la drop _append; la var round .; 
#d cr
replace round=round+16
replace round=round+1 if round>17
g item=fuel_id+6991
run "${do_hfps_mwi}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta fuel_id item 
la var item	"Item code"

la li s11cq2
g item_avail = inlist(s11cq2,1,2)	//	this is actual purchase here, not truly availability
la var	item_avail	"Item is available for sale"

g q=s11cq4
la var	q	"Quantity of [unit]"
g unit="15"
g unitstr="Litre"
la var unitstr		"Unit"
g kg=q * 1
la var kg		"Quantity (standard units)"
g lcu = s11cq5
la var	lcu	"Cost (LCU)"

g price =  lcu/kg
la var	price		"Price (LCU/standard unit)"
g unitcost = lcu / q	//	in this case we will construct them as identical, though the LCU for total could also be of interest in the price variable
la var	unitcost	"Unit Cost (LCU/unit)"



keep  y4_hhid round item item_avail q unitstr kg lcu price unitcost
order y4_hhid round item item_avail q unitstr kg lcu price unitcost
isid  y4_hhid round item
sort  y4_hhid round item
tempfile fuel
sa		`fuel'

#d ; 
clear; append using
	"${raw_hfps_mwi}/sect11_foodprices_r17.dta"		
	"${raw_hfps_mwi}/sect11_foodprices_r19.dta"		
	"${raw_hfps_mwi}/sect11_foodprices_r20.dta"		
	"${raw_hfps_mwi}/sect11_foodprices_r21.dta"		
	, gen(round); la drop _append; la var round .; 
#d cr
replace round=round+16
replace round=round+1 if round>17
#d ; 
recode food_code 
	(10=104)	/*	maize grain (not ufa)	*/
	(11=106)	/*	rice	*/
	(12=201)	/*	cassava (tubers)	*/
	(13=205)	/*	irish potato	*/
	(14=203)	/*	sweet potato (white flesh)	*/
	(15=102)	/*	maize flour -> coding as ufa refined as this is modal in 2019	*/
	(16=202)	/*	cassava flour	*/
	(17=121)	/*	sorghum flour	*/
	
	(19=321)	/*	dry beans	*/
	(20=322)	/*	fresh beans	*/
	(21=305)	/*	groundnut flour (proxying "Groundnuts (Pounded)") 	*/
	(22=504)	/*	beef	*/
	(24=501)	/*	eggs	*/
	(25=111)	/*	bread	*/
	(27=408)	/*	tomatoes	*/
	(28=801)	/*	sugar	*/
	(29=803)	/*	cooking oil	*/
	
	(32=9001)	/*	chemical fertilizer	*/
	
	(35=508)	/*	chicken	*/
	(36=505)	/*	goat	*/
	, gen(item);
#d cr

run "${do_hfps_mwi}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta food_code item 
la var item	"Item code"


g item_avail = (s11q1==1)
la var	item_avail	"Item is available for sale"

g		q=1		//	 this is an implied variable, but filling in to make harmonized data more sensible
la var	q			"Quantity of [unit]"

*	lacking a conversion factor, we will simply bring the raw unit through 
decode s11q6, gen(xx)
compare s11q3 s11q6	//	substantial jointly defined, rule will be determined by presence of s11q5/7
tab1 s11q3 s11q6
g unitstr = cond(!mi(s11q5),s11q3,cond(!mi(s11q7),xx,""))
replace unitstr = strupper(strtrim(stritrim(unitstr)))
la var unitstr		"Unit"
ta unitstr

compare s11q5 s11q7
egen lcu = rowfirst(s11q5 s11q7)
replace lcu=. if lcu<=0
la var	lcu			"Cost (LCU)"



g str3  unit = "", b(unitstr)
replace unit =  "1"		if inlist(unitstr,"1 KG","1 KG BAG","1 KILOGRAM","1KG","1KG BAG","1KILOGRAM")
replace unit =  "1"		if inlist(unitstr,"2 KG","25KG","25KGS","2KG","5KG","5KILOGRAM","KG","KILOGRAM")
replace unit = "4A"		if inlist(unitstr,"SMALLPAIL","PAIL SMALL","SMALL PAIL")
replace unit = "4B"		if inlist(unitstr,"MEDIUM PAIL","PAIL MEDIUM")
replace unit = "4C"		if inlist(unitstr,"BIG PAIL","PAIL BIG")
replace unit =  "6"		if inlist(unitstr,"PLATE","SMALL PLATE","SMALL PLATE 500")
replace unit =  "7"		if inlist(unitstr,"PLATE - BAWO","PLATE-BAWO")
replace unit =  "9"		if inlist(unitstr,"1","1 EACH","1 PIECE","1 TOMATO","1EGG","EACH","ONE")
replace unit =  "9"		if inlist(unitstr,"PEICE","PIECE","PIECES")
replace unit = "9C"		if inlist(unitstr,"1 LARGE PIECE")
replace unit = "10"		if inlist(unitstr,"HEAP")
replace unit ="10A"		if inlist(unitstr,"SMALL HEAP","1 HEAP SMALL")
replace unit ="10B"		if inlist(unitstr,"MEDIUM HEAP")
replace unit ="10C"		if inlist(unitstr,"1 BIG HEAP")
replace unit = "15"		if inlist(unitstr,"0.25LITRE","0.5 LITRE","1 LITRE","10 LITRES","1LITLER","2 LITRE","LITRES","QUARTER LITRE","PAIL 10 LITRES")
replace unit = "16"		if inlist(unitstr,"CUP","SMALL CUP")
replace unit = "19"		if inlist(unitstr,"500 ML")
replace unit = "20"		if inlist(unitstr,"TABLE SPOON")
replace unit = "22"		if inlist(unitstr,"TUBE")
replace unit ="22A"		if inlist(unitstr,"TUBES-SMALL","SMALL TUBE")
replace unit ="22B"		if inlist(unitstr,"TUBES-MEDIUM")
replace unit ="22C"		if inlist(unitstr,"TUBES-LARGE")
replace unit = "25"		if inlist(unitstr,"TINA","TRAY")
replace unit = "26"		if inlist(unitstr,"CHIGOBA","CHOGOBA","CHIGOBA (5L BUCKET)","5L BUCKET CHIGOBA","5LITLES 3500","5 L BUCKET (CHIGOBA)")
replace unit = "27"		if inlist(unitstr,"BASIN","BASIN SMALL","SMALL BASIN")
replace unit = "28"		if inlist(unitstr,"BASIN MEDIUM")
replace unit = "29"		if inlist(unitstr,"BASIN LARGE","BIG BASIN (DISH)")
replace unit = "31"		if inlist(unitstr,"LOAF 300G")
replace unit = "32"		if inlist(unitstr,"LOAF 600G")
replace unit = "33"		if inlist(unitstr,"700 G LOAF","750 LOAF","750G LOAF","LOAF")
replace unit = "51"		if inlist(unitstr,"PACKET")
replace unit ="101"		if inlist(unitstr,"50 KG","50 KG BAG","50 LOOKKG BAG","50KG","50KG BAG","50KGS","KG 50")
replace unit ="102"		if inlist(unitstr,"90 KG BAG")
// replace unit = ""		if inlist(unitstr,"")
ta unitstr if mi(unit)	//	TRAY->TINA?  AND OTHER SPECIFY...
g os_str = strupper(strtrim(stritrim(s11q6_Oth)))

ta os_str if mi(unit) & unitstr=="OTHER SPECIFY"

replace unit =  "1"		if inlist(os_str,"0.5 KG","0.5KG","1 KG","10 KG","10 KG BAG","10KG","10KG BAG") & unitstr=="OTHER SPECIFY"
replace unit =  "1"		if inlist(os_str,"15KG","1KG","2 KG","20 KG","20,,KG","20KG","20KG BAG","25 KG") & unitstr=="OTHER SPECIFY"
replace unit =  "1"		if inlist(os_str,"25 KG BAG","25K BAG","25KG","25KG BAG","25KGS","2KG","2KG BAG") & unitstr=="OTHER SPECIFY"
replace unit =  "1"		if inlist(os_str,"2KGS","5KG","5KG BAG","5KGS","70 KG","HALF KG","HALF KILOGRAMME") & unitstr=="OTHER SPECIFY"
replace unit =  "1"		if inlist(os_str,"QUARTER KG") & unitstr=="OTHER SPECIFY"
replace unit =  "6"		if inlist(os_str,"MEDIUM PLATE","NO 10 PLATE","NUMBER 10 PLATE","PLATE","PLATE SMALL","PLATE-PHAZI","PLATE.COFFEE","SMALL PLATE","SMALL PLATE _ BAWO") & unitstr=="OTHER SPECIFY"
replace unit =  "6"		if inlist(os_str,"COFFEE PLATE") & unitstr=="OTHER SPECIFY"
replace unit =  "7"		if inlist(os_str,"BAWO","MBALE/PLATE","PLATE - BAWO","PLATE BAWO","PLATE _BAWO","PLATE-BAWO") & unitstr=="OTHER SPECIFY"
replace unit =  "9"		if inlist(os_str,"1 EGG","1 PEACE","1EBG","1EGG","EACH","UNIT") & unitstr=="OTHER SPECIFY"
replace unit = "9A"		if inlist(os_str,"SMALL HEAD") & unitstr=="OTHER SPECIFY"
replace unit ="10B"		if inlist(os_str,"HEAP UNSHELLED","UNSHELLED HEAP","USHELLED HEAP") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"0.25 L","0.25 LITRE","0.25LT","0.5 LITRE","O.5 LITRES","0.5L","0.5LITRE","0.5LT") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"10 LITRE","10 LITRES","10 LITRES PAIL","15LITRE","2 LITRE","2 LITRES","2 LTR","2 LTS") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"20 L","20 LITRES","20 LITRES PAIL","20LITRES PAIL","2LITRE","2LITRES","2LITRES BOTTLE") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"2LTS","5 LITRE","5 LITRES","5 LTRS","5LITRE","5LITRE BOTTLE","5LITRES","HALF LITRE") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"HALF LITTER","HALF LT","QUARTER LITRE","QUATRE LITTER","0.5 LITRES","2 LTRS","0.5 LITRES") & unitstr=="OTHER SPECIFY"

replace unit = "16"		if inlist(os_str,"CUP","CUP UKONDE","CUP YA MATCHERA","CUP YA UKONDE","CUP YAUKONDE","PHAZI CUP") & unitstr=="OTHER SPECIFY"
replace unit ="16A"		if inlist(os_str,"SMALL CUP") & unitstr=="OTHER SPECIFY"
replace unit ="16B"		if inlist(os_str,"CUP MEDIUM","MEDIUM CUP") & unitstr=="OTHER SPECIFY"
replace unit ="16C"		if inlist(os_str,"BIG CUP") & unitstr=="OTHER SPECIFY"
replace unit = "18"		if inlist(os_str,"500GRAMS","GRAMS") & unitstr=="OTHER SPECIFY"
replace unit = "19"		if inlist(os_str,"125MLS","250 MILLILITERS","250ML","250MLS","300 ML","300 MLS","300ML") & unitstr=="OTHER SPECIFY"
replace unit = "19"		if inlist(os_str,"300MLS","330 ML","330ML","350 ML","350ML","500ML","500MLS") & unitstr=="OTHER SPECIFY"
replace unit = "20"		if inlist(os_str,"KITCHEN SPOON","LARGE SPOON","TABLE SPOON","TABLESPOON","TEASPOON","1 TABLESPOON","SPOON") & unitstr=="OTHER SPECIFY"
replace unit = "22"		if inlist(os_str,"1 TUBE","SACHET","TUBE") & unitstr=="OTHER SPECIFY"
replace unit ="22A"		if inlist(os_str,"SACHET SMALL","SMALL TUBE") & unitstr=="OTHER SPECIFY"
replace unit = "25"		if inlist(os_str,"MBALE-TINA","PLATE -TINA","PLATE TINA","PLATE,TINA","PLATE-TINA","PLATE_TINA") & unitstr=="OTHER SPECIFY"
replace unit = "25"		if inlist(os_str,"TINA","TINA PLATE","TINA.","TINNA SMALL","TINQ","TINA PLATE (ABIT BIGER THAN PLATE _ BAWO)") & unitstr=="OTHER SPECIFY"
replace unit ="25A"		if inlist(os_str,"SMALL TINA") & unitstr=="OTHER SPECIFY"
replace unit = "26"		if inlist(os_str,"5LITRE CHIGOBA") & unitstr=="OTHER SPECIFY"
replace unit = "27"		if inlist(os_str,"BASIN DISH") & unitstr=="OTHER SPECIFY"
ta os_str if mi(unit) & unitstr=="OTHER SPECIFY"

*	additional r19 
replace unit =  "1"		if inlist(os_str,"0.25 KG","10KGS","1KG BAG","2 KG TUBE","20KGS","25 KGS","25KGBAG") & unitstr=="OTHER SPECIFY" 
replace unit =  "1"		if inlist(os_str,"3KGS","5 KG","50KG","5KG BASIN","70KGBAG","70KG BAG","HALF KILOGRAMMES","¾KG") & unitstr=="OTHER SPECIFY" 
replace unit =  "6"		if inlist(os_str,"COFFEE","SMALL COFFEE PLATE") & unitstr=="OTHER SPECIFY"
replace unit = "10"		if inlist(os_str,"USHALLED HEAP") & unitstr=="OTHER SPECIFY"
replace unit ="10C"		if inlist(os_str,"LARGE HEAP") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"0. 5 LITRE","0.4 LITRE","1/4 LITRE","10 LITRES","10LITRES","1LITRES","20 LITRE UNSHELLED","20 LITTRES PAIL UNSHELLED") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"2LITRS","2LTRS","40 LITRES","5L","¾LITRE") & unitstr=="OTHER SPECIFY"
replace unit = "15"		if inlist(os_str,"QUARTER LITER","QUARTER LITREL","QUATER LITER","QUATER LITRE","QUEATER LITRE") & unitstr=="OTHER SPECIFY"
replace unit = "16"		if inlist(os_str,"CUP OKONDE","UKONDE CUP") & unitstr=="OTHER SPECIFY"
replace unit ="16B"		if inlist(os_str,"MEDIM CUP") & unitstr=="OTHER SPECIFY"
replace unit ="16C"		if inlist(os_str,"LARGE CUP") & unitstr=="OTHER SPECIFY"
replace unit = "18"		if inlist(os_str/*,"0.25G"*/,"250 GRAMS PAPER BAG") & unitstr=="OTHER SPECIFY"
replace unit = "19"		if inlist(os_str,"25 MILL","300ML BOTTLE","500ML BOTTLE") & unitstr=="OTHER SPECIFY"
replace unit = "20"		if inlist(os_str,"3 TABLE SPOON","TABLESPPON") & unitstr=="OTHER SPECIFY"
replace unit = "25"		if inlist(os_str,"TIAN") & unitstr=="OTHER SPECIFY"

*	additional round 20 & 21 
replace unit =  "1"		if inlist(os_str,"0,5 KG","10 KGS","10KGBAG","18 KG","2 KGS","25 KILOGRAM","5 KGS") & unitstr=="OTHER SPECIFY" 
replace unit =  "15"	if inlist(os_str,"10LITRES PAIL","1LITRE BACKET","1LITRE BASIN","2 LITERS","20 LITRE PAIL","20LITRE","2L","2LITRE BOTTLE") & unitstr=="OTHER SPECIFY" 
replace unit =  "15"	if inlist(os_str,"2LT","5LT","LITRE BASIN","LITRE SADO","QUARTER LITRES","QUARTER LITTRE","QUATRE LITER","QUATRE LITRE","HALF LITRES") & unitstr=="OTHER SPECIFY" 
replace unit =  "19"	if inlist(os_str,"200ML","200MML","250 MLS","250MLS","300ML ENERGY BOTTLE","300ML ENERGY DRINK BOTTLE","330MLS","500 ML") & unitstr=="OTHER SPECIFY" 
replace unit =  "19"	if inlist(os_str,"ENERGY BOTTLE 300 ML","ENERGY BOTTLE 300ML") & unitstr=="OTHER SPECIFY" 
replace unit =  "20"	if inlist(os_str,"TABLE SPOO","TABLET SPOON","SPOO","SPOON SMALL") & unitstr=="OTHER SPECIFY" 
replace unit =  "22"	if inlist(os_str,"SUCHETE") & unitstr=="OTHER SPECIFY" 
replace unit =  "25"	if inlist(os_str,"TIINA","TIMA","TINAA","TINNA") & unitstr=="OTHER SPECIFY" 
replace unit =  "33"	if inlist(os_str,"0.25 GRAMS","0.25G") & unitstr=="OTHER SPECIFY" 
replace unit =  "51"	if inlist(os_str,"PACKET") & unitstr=="OTHER SPECIFY" 

li round item os_str if mi(unit) & unitstr=="OTHER SPECIFY" & strpos(os_str,"QUA")>0
replace unit =  "15"	if strpos(os_str,"QUA")>0 & unitstr=="OTHER SPECIFY" 
li round item os_str if mi(unit) & unitstr=="OTHER SPECIFY" & strpos(os_str,"PHAZI")>0	//	google says Phazi=foot




ta os_str if mi(unit) & unitstr=="OTHER SPECIFY"
li item os_str if mi(unit) & unitstr=="OTHER SPECIFY" & length(os_str)>15


*	reliance on string necessitates changes to quantity variable
recode q (1=0.25)	if inlist(unitstr,"0.25LITRE","QUARTER LITRE")
recode q (1=0.5)	if inlist(unitstr,"0.5 LITRE")
recode q (1=2)		if inlist(unitstr,"2 KG","2KG","2 LITRE")
recode q (1=5)		if inlist(unitstr,"5KG","5KILOGRAM")
recode q (1=10)		if inlist(unitstr,"10 LITRES","PAIL 10 LITRES")
recode q (1=25)		if inlist(unitstr,"25KG","25KGS")
recode q (1=0.25)	if inlist(os_str,"QUARTER KG","0.25 L","0.25 LITRE","0.25LT","QUARTER LITRE","QUATRE LITTER") & unitstr=="OTHER SPECIFY"
recode q (1=0.5)	if inlist(os_str,"0.5 KG","0.5KG","HALF KG","HALF KILOGRAMME","0.5 LITRE","O.5 LITRES","0.5L") & unitstr=="OTHER SPECIFY"
recode q (1=0.5)	if inlist(os_str,"0.5LITRE","0.5LT","HALF LITRE","HALF LITTER","HALF LT","0.5 LITRES","0.5 LITRES") & unitstr=="OTHER SPECIFY"
recode q (1=2)		if inlist(os_str,"2 KG","2KG","2KG BAG","2KGS","2 LITRE","2 LITRES","2 LTR","2 LTS","2LITRE") & unitstr=="OTHER SPECIFY"
recode q (1=2)		if inlist(os_str,"2LITRES","2LITRES BOTTLE","2LTS","2 LTRS") & unitstr=="OTHER SPECIFY"
recode q (1=5)		if inlist(os_str,"5KG","5KG BAG","5KGS","5 LITRE","5 LITRES","5 LTRS","5LITRE","5LITRE BOTTLE","5LITRES") & unitstr=="OTHER SPECIFY"
recode q (1=10)		if inlist(os_str,"10 KG","10 KG BAG","10KG","10KG BAG","10 LITRE","10 LITRES","10 LITRES PAIL") & unitstr=="OTHER SPECIFY"
recode q (1=15)		if inlist(os_str,"15LITRE") & unitstr=="OTHER SPECIFY"
recode q (1=20)		if inlist(os_str,"20 KG","20,,KG","20KG","20KG BAG","20 L","20 LITRES","20 LITRES PAIL","20LITRES PAIL") & unitstr=="OTHER SPECIFY"
recode q (1=25)		if inlist(os_str,"25 KG","25 KG BAG","25K BAG","25KG","25KG BAG","25KGS") & unitstr=="OTHER SPECIFY"
recode q (1=70)		if inlist(os_str,"70 KG") & unitstr=="OTHER SPECIFY"
recode q (1=500)	if inlist(os_str,"500GRAMS","500 ML","500ML","500MLS") & unitstr=="OTHER SPECIFY"
recode q (1=125)	if inlist(os_str,"125MLS") & unitstr=="OTHER SPECIFY"
recode q (1=250)	if inlist(os_str,"250 MILLILITERS","250ML","250MLS") & unitstr=="OTHER SPECIFY"
recode q (1=300)	if inlist(os_str,"300 ML","300 MLS","300ML","300MLS") & unitstr=="OTHER SPECIFY"
recode q (1=330)	if inlist(os_str,"330 ML","330ML") & unitstr=="OTHER SPECIFY"
recode q (1=350)	if inlist(os_str,"350 ML","350ML") & unitstr=="OTHER SPECIFY"
recode q (1=500)	if inlist(os_str,"500ML","500MLS") & unitstr=="OTHER SPECIFY"
*	add'l round 19 
recode q (1=0.25)	if inlist(os_str,"0.25 KG","1/4 LITRE","QUARTER LITER","QUARTER LITREL","QUATER LITER","QUATER LITRE","QUEATER LITRE"/*,"0.25G"*/)
recode q (1=0.4)	if inlist(os_str,"0.4 LITRE")
recode q (1=0.5)	if inlist(os_str,"HALF KILOGRAMMES","0. 5 LITRE")
recode q (1=0.75)	if inlist(os_str,"¾KG","¾LITRE")
recode q (1=2)		if inlist(os_str,"2 KG TUBE","2LITRS","2LTRS")
recode q (1=3)		if inlist(os_str,"3KGS","3 TABLE SPOON")
recode q (1=5)		if inlist(os_str,"5 KG","5KG BASIN","5L")
recode q (1=10)		if inlist(os_str,"10KGS","10 LITRES","10LITRES")
recode q (1=20)		if inlist(os_str,"20KGS","20 LITRE UNSHELLED","20 LITTRES PAIL UNSHELLED")
recode q (1=25)		if inlist(os_str,"25 KGS","25KGBAG","25 MILL")
recode q (1=40)		if inlist(os_str,"40 LITRES")
recode q (1=50)		if inlist(os_str,"50KG")
recode q (1=70)		if inlist(os_str,"70KGBAG","70KG BAG")
recode q (1=250)	if inlist(os_str,"250 GRAMS PAPER BAG")
recode q (1=300)	if inlist(os_str,"300ML BOTTLE")
recode q (1=500)	if inlist(os_str,"500ML BOTTLE")
*	add'l round 20+21
recode q (1=0.25)	if inlist(os_str,"QUARTER LITRES","QUARTER LITTRE","QUATRE LITER","QUATRE LITRE","QUARTER","0.25 GRAMS","0.25G")
recode q (1=0.5)	if inlist(os_str,"0,5 KG","HALF LITRES")
recode q (1=2)		if inlist(os_str,"2 KGS","2 LITERS","2L","2LITRE BOTTLE","2LT")
recode q (1=5)		if inlist(os_str,"5 KGS","5LT")
recode q (1=10)		if inlist(os_str,"10 KGS","10KGBAG","10LITRES PAIL")
recode q (1=18)		if inlist(os_str,"18 KG")
recode q (1=20)		if inlist(os_str,"20 LITRE PAIL","20LITRE")
recode q (1=25)		if inlist(os_str,"25 KILOGRAM")
recode q (1=200)	if inlist(os_str,"200ML","200MML")
recode q (1=250)	if inlist(os_str,"250 MLS","250MLS")
recode q (1=300)	if inlist(os_str,"300ML ENERGY BOTTLE","300ML ENERGY DRINK BOTTLE","ENERGY BOTTLE 300 ML","ENERGY BOTTLE 300ML")
recode q (1=330)	if inlist(os_str,"330MLS")
recode q (1=500)	if inlist(os_str,"500 ML")


*	combine the unit strings into what we will save 
replace unitstr = os_str if unitstr=="OTHER SPECIFY"

g		unitcost=lcu/q
la var	unitcost	"Unit cost (LCU/unit)"

*	prepare to merge 




isid y4_hhid round item
keep y4_hhid round item item_avail q unit unitstr lcu unitcost

append using `fuel'
isid y4_hhid round item

decode item, gen(itemstr)
la var itemstr	"Item code"

tempfile r17 
sa		`r17'

}	/*	end round 17+ version	*/

{	/*	round 15/16 version	*/ 
#d ;
clear; append using 
	"${raw_hfps_mwi}/sect11_foodprices_r15.dta"
	"${raw_hfps_mwi}/sect11b_prices_r16.dta"
	, gen(round); replace round=round+14; la drop _append; la val round; 
replace item_code=food_code+9 if round==15;
recode item_code
	(10=104)	/*	maize grain (not ufa)	*/
	(11=106)	/*	rice	*/
	(12=201)	/*	cassava (tubers)	*/
	(13=205)	/*	irish potato	*/
	(14=203)	/*	sweet potato (white flesh)	*/
	(15=102)	/*	maize flour -> coding as ufa refined as this is modal in 2019	*/
	(16=202)	/*	cassava flour	*/

	(20=7004)	/*	lpg	*/
	(21=7001)	/*	petrol	*/
	(22=7002)	/*	diesel	*/
	(23=7003)	/*	paraffin	*/
	
	(30=9001)	/*	fertilizer	*/
	(31=6001)	/*	maize seed	*/
	(32=6002)	/*	soya seed	*/
	(33=6003)	/*	bean seed	*/
	
	(40=8003)	/*	transport to nearest market	*/
	, gen(item); 
#d cr 
run "${do_hfps_mwi}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta item_code item 
la var item	"Item code"

isid y4_hhid item round

decode item, gen(itemstr)
la var itemstr	"Item code"

g item_avail = (s11q0==1)
la var	item_avail	"Item is available for sale"

tabstat s11q3 s11q3_tpt, by(item) s(n)
compare s11q3 s11q3_tpt	//	never jointly defined

recode s11q2 12=96 if round==15
#d ; 	
la def s11q2
		12 "Packet"
		20 "Motor Vehicle"
		21 "Motor Cycle"
		22 "Bicycle"
		23 "Litres"
		24 "Kilogram"
		96 "Other Specify"
	, modify; 
#d cr


g		unit = "1"		if s11q2==24	/*	kg	*/
replace	unit = "4"		if s11q2== 1	/*	Pail Big	*/
replace	unit = "4"		if s11q2== 2	/*	Pail Medium	*/
replace	unit = "4"		if s11q2== 3	/*	Pail Small	*/
replace	unit = "101"	if s11q2== 4	/*	50 kg bag (not coded in IHS4)	*/
replace	unit = "102"	if s11q2== 5	/*	90 kg bag (not coded in IHS4)	*/
replace	unit = "27"		if s11q2== 6	/*	Basin Small	*/
replace	unit = "28"		if s11q2== 7	/*	Basin Medium	(not coded)	*/
replace	unit = "29"		if s11q2== 8	/*	Basin Large		(not coded)	*/
replace	unit = "9"		if s11q2== 9	/*	Piece	*/
replace	unit = "26"		if s11q2==10	/*	5 L Bucket (chigoba)	*/
replace	unit = "10"		if s11q2==11	/*	Heap	*/
replace	unit = "51"		if s11q2==12	/*	Packet	*/
replace	unit = "15"		if s11q2==23	/*	Liter	*/
replace	unit = "43"		if s11q2==25	/*	Satchet/tube 100g	*/
replace	unit = "42"		if s11q2==26	/*	Satchet/tube 50g	*/
replace	unit = "41"		if s11q2==27	/*	Satchet/tube 25g	*/
replace	unit = "31"		if s11q2==28	/*	LOAF (300G)	*/
replace	unit = "32"		if s11q2==29	/*	LOAF (600G)	*/
replace	unit = "33"		if s11q2==30	/*	LOAF (700G)	*/
decode s11q2, gen(unitstr)
la var unitstr		"Unit"

g		q=1
la var	q	"Quantity of [unit]"
ta s11q3
g		lcu=s11q3 if s11q3>0 & !inlist(s11q3,999,9999,99999)
la var	lcu	"Cost (LCU)"
g		unitcost=lcu/q
la var	unitcost	"Unit cost (LCU/unit)"



*	assess values (briefly)
tabstat unitcost, by(item) s(n me min max) format(%12.3gc)


keep  y4_hhid round item itemstr item_avail q unit unitstr lcu unitcost 
order y4_hhid round item itemstr item_avail q unit unitstr lcu unitcost
isid  y4_hhid round item
}	/*	end round 15/16 version	*/


append using `r17'	/*	bring in the round 17 things	*/ 
isid  y4_hhid round item
sort  y4_hhid round item
sa "${tmp_hfps_mwi}/price.dta", replace 
u  "${tmp_hfps_mwi}/price.dta", clear 


u "${raw_lsms_mwi}/hh_mod_g1_19.dta", clear
la li item_labels 
la li hh_g03b
ta hh_g03b hh_g03c,m


*	take the above as a starting point and attempt conversions

dir		"${hfps}/Input datasets/Malawi"
d using	"${hfps}/Input datasets/Malawi/IHS4 Conversion Factor Database"
u		"${hfps}/Input datasets/Malawi/IHS4 Conversion Factor Database.dta", clear
duplicates report region item unit
duplicates report
duplicates drop

isid region item unit
egen cf = rowfirst(ihps_plus_aug ihps_plus ihs3_plus ihs3)
keep region item unit cf 
	*	 have to bring add'l info to make unitstr 
tempfile cf
sa		`cf'


u "${raw_lsms_mwi}/ihs_seasonalcropconversion_factor_2020.dta", clear

ta crop_code if inlist(unit_code,"2","3") & condition==1
la li crops
recode crop_code (1/4=104)(17/26=106)(34=6002)(35=6003)(else=.), gen(item)
keep if !mi(item) & inlist(unit_code,"2","3") & condition==1
g		unit = "101" if unit_code=="2"
replace	unit = "102" if unit_code=="3"
collapse (p50) conversion, by(item unit)
expand 2 if item==104, gen(mark)	//	maize grain = maize seed for our purposes here 
recode item (104=6001) if mark==1
isid item unit
tempfile bag_cf
sa		`bag_cf'



u  "${tmp_hfps_mwi}/price.dta", clear 
ta item round
bys item : keep if _n==1
li item itemstr, nol
u  "${tmp_hfps_mwi}/price.dta", clear 
mer m:1 y4_hhid round using "${tmp_hfps_mwi}/cover.dta", assert(2 3) keep(3) nogen keepus(r0_region)
g region = r0_region/100


mer m:1 region item unit using `cf', keep(1 3)

ta item unit if _merge==1
recode cf (.=1) if _merge==1 & inlist(unit,"1","15") & !mi(item)	//	kg & litre
recode cf (.=0.001) if _merge==1 & inlist(unit,"18","19") & !mi(item)	//	g & ml

ta item if inlist(unit,"101","102")	//	50 & 90 sacks 
	//	maize grain & rice predominate 	
mer m:1 item unit using `bag_cf', keepus(conversion) keep(1 3) nogen

ta item unit if !mi(conversion)
replace cf = conversion if mi(cf) & !mi(conversion)

ta item round if mi(q)
ta item unit if mi(q)
recode q (.=1)

replace kg=q * cf if mi(kg)
replace price = lcu / kg if mi(price)
replace unitcost = lcu / q if mi(unitcost)
su q lcu price kg unitcost

tabstat price, by(item) s(n me min p5 p50 p95 max) format(%12.0fc)
sort item price
li round item q unit unitstr kg lcu price if price>95000 & !mi(price), sepby(item)
tabstat unitcost, by(item) s(n me min p5 p50 p95 max) format(%12.0fc)
recode price unitcost kg (0=.)

su price kg unitcost

la var	lcu			"Cost (LCU)"
la var	unitstr		"Unit"
la var	kg			"Quantity (standard units)"
drop r0_region-conversion

keep  y4_hhid round item itemstr item_avail q unitstr kg lcu price unitcost 
order y4_hhid round item itemstr item_avail q unitstr kg lcu price unitcost
isid  y4_hhid round item
sort  y4_hhid round item
sa "${tmp_hfps_mwi}/price.dta", replace 

ex















