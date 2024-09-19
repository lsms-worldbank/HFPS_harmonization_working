


cap : la drop item
#d ; 
la def item 
	102	"maize flour"		/*	lsms code for maize ufa refined, as this is modal option in 2019, though	*/
	104	"maize grain"		
	106	"rice"
	111	"bread"
	121	"sorghum flour"	/*	not an LSMS code	*/

	
	201	"cassava"	
	202	"cassava flour"	
	205	"irish potato"	
	203	"sweet potato"	
	
	
	321	"dry beans"	/*	not an LSMS code	*/
	322	"fresh beans"	/*	not an LSMS code	*/
	305	"groundnut flour"	/*	- pounded gnuts */
	
	408	"tomatoes"
	
	501	"eggs"
	504	"beef"
	
	801	"sugar"
	803	"cooking oil"
	
	6001	"maize seed"
	6002	"soya seed"
	6003	"bean seed"
	
	7001	"petrol"
	7002	"diesel"
	7003	"paraffin"
	7004	"LPG"	/*	liquefied petroleum gas (bottled)	*/
	
	8001	"fuel for car"
	8002	"fuel for motorcycle"
	8003	"transport to nearest market"
	9001	"chemical fertilizer"
	
	
	;
#d cr 











ex	//	below is the raw 

u "${raw_lsms_mwi}/hh_mod_g1_19.dta", clear
la li item_labels
la copy item_labels item
la save item using "${do_hfps_mwi}/label_item.do"

u "${raw_lsms_mwi}/hh_mod_g1_19.dta", clear
ta hh_g02 if hh_g01==1 & inrange(hh_g02,101,105)	//	maize options

label define item 101 `"Maize ufa mgaiwa (normal flour)"', modify
label define item 102 `"Maize ufa refined (fine flour)"', modify
label define item 103 `"Maize ufa processed madeya (bran flour - processed)"', modify
label define item 104 `"Maize grain (not as ufa)"', modify
label define item 105 `"Green Maize"', modify
label define item 106 `"Rice"', modify
label define item 107 `"Finger millet (mawere)"', modify
label define item 108 `"Sorghum (mapira)"', modify
label define item 109 `"Pearl millet (mchewere)"', modify
label define item 110 `"Wheat flour"', modify
label define item 111 `"Bread"', modify
label define item 112 `"Buns, scones"', modify
label define item 113 `"Biscuits"', modify
label define item 114 `"Spaghetti, macaroni, pasta"', modify
label define item 115 `"Breakfast cereals"', modify
label define item 116 `"Infant feeding cereals"', modify
label define item 117 `"Other (specify)"', modify
label define item 118 `"Maize ufa raw madeya (bran flour - unprocessed)"', modify
label define item 201 `"Cassava tubers"', modify
label define item 202 `"Cassava flour"', modify
label define item 203 `"White sweet potato"', modify
label define item 204 `"Orange sweet potato"', modify
label define item 205 `"Irish Potato"', modify
label define item 206 `"Potato crisps"', modify
label define item 207 `"Plantain, cooking banana"', modify
label define item 208 `"Cocoyam (masimbi)"', modify
label define item 209 `"Other (specify)"', modify
label define item 301 `"Bean, white"', modify
label define item 302 `"Bean, brown"', modify
label define item 303 `"Pigeon pea (nandolo)"', modify
label define item 305 `"Groundnut flour"', modify
label define item 306 `"Soyabean flour"', modify
label define item 307 `"Ground bean (nzama)"', modify
label define item 308 `"Cowpea (khobwe)"', modify
label define item 309 `"Macademia nuts"', modify
label define item 310 `"Other (specify)"', modify
label define item 311 `"Groundnut (Shelled)"', modify
label define item 312 `"Groundnut Dried (UnShelled)"', modify
label define item 313 `"Groundnut Fresh (UnShelled)"', modify
label define item 401 `"Onion"', modify
label define item 402 `"Cabbage"', modify
label define item 403 `"Tanaposi/Rape"', modify
label define item 404 `"Nkhwani"', modify
label define item 405 `"Chinese cabbage"', modify
label define item 406 `"Other cultivated green leafy vegetables"', modify
label define item 407 `"Gathered wild green leaves"', modify
label define item 408 `"Tomato"', modify
label define item 409 `"Cucumber"', modify
label define item 410 `"Pumpkin"', modify
label define item 411 `"Okra / Therere"', modify
label define item 412 `"Tinned vegetables (specify)"', modify
label define item 413 `"Mushroom"', modify
label define item 414 `"Other (specify)"', modify
label define item 501 `"Eggs"', modify
label define item 504 `"Beef"', modify
label define item 505 `"Goat"', modify
label define item 506 `"Pork"', modify
label define item 507 `"Mutton"', modify
label define item 508 `"Chicken - Whole"', modify
label define item 509 `"Other poultry - guinea fowl, doves, etc"', modify
label define item 510 `"Small animal – rabbit, mice, etc"', modify
label define item 511 `"Termites, other insects (eg Ngumbi, caterpillar)"', modify
label define item 512 `"Tinned meat or fish"', modify
label define item 514 `"Fish Soup/Sauce"', modify
label define item 515 `"Other (specify)"', modify
label define item 522 `"Chicken - Pieces"', modify
label define item 601 `"Mango"', modify
label define item 602 `"Banana"', modify
label define item 603 `"Citrus – naartje, orange, etc"', modify
label define item 604 `"Pineapple"', modify
label define item 605 `"Papaya"', modify
label define item 606 `"Guava"', modify
label define item 607 `"Avocado"', modify
label define item 608 `"Wild fruit (masau, malambe, etc)"', modify
label define item 609 `"Apple"', modify
label define item 610 `"Other fruits (specify)"', modify
label define item 701 `"Fresh milk"', modify
label define item 702 `"Powdered milk"', modify
label define item 703 `"Margarine - Blue band"', modify
label define item 704 `"Butter"', modify
label define item 705 `"Chambiko - soured milk"', modify
label define item 706 `"Yoghurt"', modify
label define item 707 `"Cheese"', modify
label define item 708 `"Infant feeding formula (for bottle)"', modify
label define item 709 `"Other (specify)"', modify
label define item 801 `"Sugar"', modify
label define item 802 `"Sugar cane"', modify
label define item 803 `"Cooking oil"', modify
label define item 804 `"Other (specify)"', modify
label define item 810 `"Salt"', modify
label define item 811 `"Spices"', modify
label define item 812 `"Yeast, baking powder, bicarbonate of soda"', modify
label define item 813 `"Tomato sauce (bottle)"', modify
label define item 814 `"Hot sauce (Nali, etc)"', modify
label define item 815 `"Jam, jelly"', modify
label define item 816 `"Sweets, candy, chocolates"', modify
label define item 817 `"Honey"', modify
label define item 818 `"Other (specify)"', modify
label define item 820 `"Maize - boiled or roasted (vendor)"', modify
label define item 821 `"Chips (vendor)"', modify
label define item 822 `"Cassava - boiled (vendor)"', modify
label define item 823 `"Eggs - boiled (vendor)"', modify
label define item 824 `"Chicken (vendor)"', modify
label define item 825 `"Meat (vendor)"', modify
label define item 826 `"Fish (vendor)"', modify
label define item 827 `"Mandazi, doughnut (vendor)"', modify
label define item 828 `"Samosa (vendor)"', modify
label define item 829 `"Meal eaten at restaurant"', modify
label define item 830 `"Other (specify)"', modify
label define item 831 `"Boiled sweet potatoes"', modify
label define item 832 `"Roasted sweet potatoes"', modify
label define item 833 `"Boiled groundnuts"', modify
label define item 834 `"Roasted groundnuts"', modify
label define item 835 `"Popcorn"', modify
label define item 836 `"Zikondamoyo / Nkate"', modify
label define item 837 `"KALONGONDA (Mucuna)"', modify
label define item 838 `"Cassava - roasted (vendor)"', modify
label define item 901 `"Tea"', modify
label define item 902 `"Coffee"', modify
label define item 903 `"Cocoa, milo"', modify
label define item 904 `"Squash (Sobo drink concentrate)"', modify
label define item 905 `"Fruit juice"', modify
label define item 906 `"Freezes (flavoured ice)"', modify
label define item 907 `"Soft drinks (Coca-cola, Fanta, Sprite, etc)"', modify
label define item 908 `"Chibuku(commercial traditional-style beer)"', modify
label define item 909 `"Bottled water"', modify
label define item 910 `"Maheu"', modify
label define item 911 `"Bottled / canned beer (Carlsberg, etc)"', modify
label define item 912 `"Thobwa"', modify
label define item 913 `"Traditional beer (masese)"', modify
label define item 914 `"Wine or commercial liquor"', modify
label define item 915 `"Locally brewed liquor (kachasu )"', modify
label define item 916 `"Other (specify)"', modify
label define item 5021 `"Sun Dried fish (Large Variety)"', modify
label define item 5022 `"Sun Dried fish (Medium Variety)"', modify
label define item 5023 `"Sun Dried fish (Small Variety)"', modify
label define item 5031 `"Fresh fish (Large Variety)"', modify
label define item 5032 `"Fresh fish (Medium Variety)"', modify
label define item 5033 `"Fresh fish (Small Variety)"', modify
label define item 5121 `"Smoked fish (Large Variety)"', modify
label define item 5122 `"Smoked fish (Medium Variety)"', modify
label define item 5123 `"Smoked fish (Small Variety)"', modify
