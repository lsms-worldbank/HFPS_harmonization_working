



cap : la drop item
#d ; 
la def item 
	105		"maize flour"	
	102		"rice"
	202		"cassava flour"	
	1081	"wheat flour"
	301		"sugar"
	1001	"cooking oil"
	401		"dry beans"
	802		"beef"
	1003	"salt"
	
	

	6001	"maize seed"
	6002	"soya seed"
	6003	"bean seed"
	
	7001	"petrol"
	7002	"diesel"
	7003	"paraffin"
	7004	"LPG"	/*	liquefied petroleum gas (bottled)	*/
	7005	"kerosene"	
	
	8001	"fuel for car"
	8002	"fuel for motorcycle"
	8003	"transport to nearest market"
	9001	"chemical fertilizer"
	
	
	;
#d cr 




ex
d using "${raw_lsms_tza}/HH_SEC_J1.dta"
u "${raw_lsms_tza}/HH_SEC_J1.dta", clear
la copy itemcode item
la save item using "${do_hfps_tza}/label_item.do"

label define item 101 `"RICE (PADDY)"', modify
label define item 102 `"RICE (HUSKED)"', modify
label define item 103 `"MAIZE (GREEN, COB)"', modify
label define item 104 `"MAIZE (GRAIN)"', modify
label define item 105 `"MAIZE (FLOUR)"', modify
label define item 106 `"MILLET AND SORGHUM (GRAIN)"', modify
label define item 107 `"MILLET AND SORGHUM (FLOUR)"', modify
label define item 109 `"BREAD"', modify
label define item 110 `"BUNS, CAKES AND BISCUITS"', modify
label define item 111 `"MACARONI, SPAGHETTI"', modify
label define item 112 `"OTHER CEREAL PRODUCTS"', modify
label define item 201 `"CASSAVA FRESH"', modify
label define item 202 `"CASSAVA DRY/FLOUR"', modify
label define item 203 `"SWEET POTATOES"', modify
label define item 204 `"YAMS/COCOYAMS"', modify
label define item 205 `"IRISH POTATOES"', modify
label define item 206 `"COOKING BANANAS, PLANTAINS"', modify
label define item 207 `"OTHER STARCHES"', modify
label define item 301 `"SUGAR"', modify
label define item 302 `"SWEETS"', modify
label define item 303 `"HONEY, SYRUPS, JAMS, MARMALADE, JELLIES, CANNED FRUITS"', modify
label define item 401 `"PEAS, BEANS, LENTILS AND OTHER PULSES"', modify
label define item 501 `"GROUNDNUTS IN SHELL/SHELLED"', modify
label define item 502 `"COCONUTS (MATURE/IMMATURE)"', modify
label define item 503 `"CASHEW, ALMONDS AND OTHER NUTS"', modify
label define item 504 `"SEEDS AND PRODUCTS FROM NUTS/SEEDS (EXCL. COOKING OIL)"', modify
label define item 601 `"ONIONS, TOMATOES, CARROTS AND GREEN PEPPER, OTHER VIUNGO"', modify
label define item 602 `"SPINACH, CABBAGE AND OTHER GREEN VEGETABLES"', modify
label define item 603 `"CANNED, DRIED AND WILD VEGETABLES"', modify
label define item 701 `"RIPE BANANAS"', modify
label define item 702 `"CITRUS FRUITS (ORANGES, LEMON, TANGERINES, ETC.)"', modify
label define item 703 `"MANGOES, AVOCADOES AND OTHER FRUITS"', modify
label define item 704 `"SUGARCANE"', modify
label define item 801 `"GOAT MEAT"', modify
label define item 802 `"BEEF INCLUDING MINCED SAUSAGE"', modify
label define item 803 `"PORK INCLUDING SAUSAGES AND BACON"', modify
label define item 804 `"CHICKEN AND OTHER POULTRY"', modify
label define item 805 `"WILD BIRDS AND INSECTS"', modify
label define item 806 `"OTHER DOMESTIC/WILD MEAT PRODUCTS"', modify
label define item 807 `"EGGS"', modify
label define item 808 `"FRESH FISH AND SEAFOOD (INCLUDING DAGAA)"', modify
label define item 809 `"DRIED/SALTED/CANNED FISH AND SEAFOOD (INCL. DAGAA)"', modify
label define item 810 `"PACKAGE FISH"', modify
label define item 901 `"FRESH MILK"', modify
label define item 902 `"MILK PRODUCTS (LIKE CREAM, CHEESE, YOGHURT ETC)"', modify
label define item 903 `"CANNED MILK/MILK POWDER"', modify
label define item 1001 `"COOKING OIL"', modify
label define item 1002 `"BUTTER, MARGARINE, GHEE AND OTHER FAT PRODUCTS"', modify
label define item 1003 `"SALT"', modify
label define item 1004 `"OTHER SPICES"', modify
label define item 1081 `"WHEAT FLOUR"', modify
label define item 1082 `"WHEAT, BARLEY GRAIN AND OTHER CEREALS"', modify
label define item 1101 `"TEA DRY"', modify
label define item 1102 `"COFFEE AND COCOA"', modify
label define item 1103 `"OTHER RAW MATERIALS FOR DRINKS"', modify
label define item 1104 `"BOTTLED/CANNED SOFT DRINKS (SODA, JUICE, WATER)"', modify
label define item 1105 `"PREPARED TEA, COFFEE"', modify
label define item 1106 `"BOTTLED BEER"', modify
label define item 1107 `"LOCAL BREWS"', modify
label define item 1108 `"WINE AND SPIRITS"', modify
