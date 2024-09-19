




cap : la drop item
#d ; 
la def item
         113 "maize flour"
         110 "rice"
         114 "bread"
         117 "beef"
         125 "fresh milk"
         124 "eggs"
        1237 "silverfish"
         140 "fresh beans"
         105 "sweet potatoes"
         107 "cassava"	/*	fresh is modal cassava code in 2019 data (though likely seasonal)	*/
         141 "dry beans"
         144 "groundnuts"
         135 "onions"
         136 "tomatoes"
         168 "eggplants"
         138 "greens"
         147 "sugar"
        1271 "cooking oil"
        1491 "tea"			/*	green tea wasn't even selected in 2019	*/
        1501 "salt"
        1082 "cassava flour"	/*	was specified in HFPS round 12	*/ 

         100 "banana food"	
/*         101 "Matooke (Bunch)"	
         102 "Matooke (Cluster)"*/
        1312 "banana sweet"	/*	modal sweet banana type in 2019	*/ 

        4623 "diesel"
        4622 "petrol"
         308 "paraffin or kerosene"
         452 "soap"		/*	modal soap type in 2019	*/ 

        8888 "chemical fertilizer"	/*	special code, not captured in the hh module */
; 
#d cr 		


		ex	//	below is full set of codes, we only keep those we are interested in above this line

u "${raw_lsms_uga}/HH/gsec15b.dta", clear
la li itmcd	//	no conversion factor available, but we will harmonize the codes anyway
	
         100 Matooke
         101 Matooke (Bunch)
         102 Matooke (Cluster)
         103 Matooke (Heap)
         104 Matooke others
         105 Sweet Potatoes
         106 Sweet Potatoes  (Dry)
         107 Cassava (Fresh)
         108 Cassava (Dry)
         109 Irish Potatoes
         110 Rice
         111 Maize grains
         112 Maize cobs
         113 Maize flour
         114 Bread (wheat)
         116 Sorghum
         117 Beef
         118 Pork
         119 Goat Meat
         120 Other Meat (eg duck, rabbit etc)
         121 Chicken
         124 Eggs
         125 Fresh Milk
         126 Infant Formula Foods
         128 Ghee
         129 Margarine
         130 Passion Fruits
         132 Mangoes
         133 Oranges/Tangerines
         134 Other Fruits
         135 Onions
         136 Tomatoes
         137 Cabbages
         138 Dodo/Nakati/gyobyo/Malakwang
         139 Other vegetables
         140 Bean( fresh)
         141 Beans (dry)
         142 Ground nuts (in shell)
         143 Ground nuts (shelled)
         144 Ground nuts (pounded)
         145 Peas(fresh)
         147 Sugar
         148 Coffee instant
         149 Tea
         150 Salt
         151 Soda*
         152 Beer*
         153 Other Alcoholic drinks
         154 Other drinks
         155 Cigarrates
         156 Other Tobacco
         157  Food      in Restaurants
         158 Soda in Restaurants
         159 Beer Restaurants
         160 Other juice Packed in Restaurants
         161 Other foods in  Restaurants
         162 Peas(dry)
         163 Ground nuts (paste)
         164 Green Pepper
         165 Pumpkins
         166 Avocado
         167 Carrots
         168 Egg plants
         169 Watermelon
         170 Pineapple
         171 Pawpaw
         172 Wheat (flour)
         173 Chapati
         174 Apples
         175 Water
        1041 Matooke (Sack)
        1042 Matooke (Piece)
        1043 Matooke (other)
        1051 Sweet Potatoes white/yellow(Fresh)
        1052 Sweet Potatoes-orange fleshed (fresh)
        1061 Sweet Potatoes white/yellow (Dry)
        1062 Sweet Potatoes-orange (Dry)
        1063 Sweet Potatoes white/yellow (flour)
        1064 Sweet Potatoes orange (flour)
        1081 Cassava (Dry)
        1082 Cassava (flour)
        1083 Pancakes(Kabalagala)
        1101 Rice (white)
        1102 Rice (brown)
        1103 Rice flour
        1111 Maize yellow (grains)
        1112 Maize white (grains)
        1121 Maize white  (cobs)
        1122 Maize yellow (cobs)
        1131 Maize white (flour)
        1132 Maize yellow (flour)
        1151 Millet flour
        1171 Beef Liver
        1172 Beef Offals
        1173 Roasted beef
        1174 Sausages
        1181 Pork
        1182 Roasted Pork
        1191 Goat Liver
        1192 Goat offals
        1193 Roasted goat meat
        1201 Roasted other meat
        1211 Chicken off-layer
        1212 Chicken Broiler
        1213 Chicken Kroiler
        1214 Chicken Local
        1215 Roasted Chicken
        1221 Fresh tilapia Fish
        1222 Fresh Nile perch
        1231 Dry/ Smoked tilapia fish
        1232 Dry/Smoked Nile perch
        1234 Dried Nkejje
        1235 Other fresh fish
        1236 Other dry/smoked fish
        1237 Silver Fish (Mukene)
        1241 Eggs  (yellow yolk)
        1242 Eggs  (white  yolk)
        1243 Other eggs (duck, turkey etc)
        1251 Milk Powdered
        1252 Fermented milk (Bongo)
        1253 Ice-cream
        1254 Yoghurt
        1271 Cooking oil refined
        1272 Cooking oil unrefined
        1281 Cheese
        1291 Butter
        1311 Sweet Bananas-Ndiizi
        1312 Sweet Bananas-Bogoya
        1313 Plantain (gonja/kivuvu)
        1351 Garlic
        1352 Ginger fresh
        1353 Ginger powder
        1371 Cabbages – Red leaf
        1372 Cabbage – green leaf
        1391 Other spices
        1461 Simsim
        1462 Simsim paste
        1471 Honey
        1472 Jam/ Mamalede
        1481 Coffee
        1482 Coffee Other
        1491 Tea leaves
        1492 Tea bags
        1493 Green tea
        1501 Salt
        1531 Waragi
        1601 Other juice fresh
        1602 Other juice packed
        1603 Other juice Fresh in Restaurants
        1651 Pumpkin Leaves
        1652 Mushrooms
        1653 Cucumber
        1654 Okra
        1721 Macaroni/Spaghetti
        1731 Biscuits
        1732 Cakes
        1733 Doughnuts
        1734 Cornflakes
        1735 Samosas
        1741 Yarms(arrow root)
        1742 sugarcane
        1743  Jackfruit(ffene)
        1761 Soya beans (fresh)
        1762 Soya beans (dry)

ta CEB01 if CEB03==1
		
		
		
		
		
u "${raw_lsms_uga}/HH/gsec15c.dta", clear
la li CEC02
         108 Public Transport - Bus
         109 Public transport – Others (Truck,)
         301 Rent of rented house
         302 Imputed rent of owned house
         303 Imputed rent of free house
         304 Maintenance and repair expenses
         306 Electricity
         307 Generators/lawn mower fuels
         308 Paraffin or kerosene
         309 Charcoal
         310 Firewood
         311 Others
         452 Washing soap
         453 Bathing soap
         454 Tooth paste
         455 Cosmetics (body lotion, deodorant etc)
         456 Handbags, travel bags etc
         457 Batteries (Dry cells)
         458 Newspapers or magazines
         459 Others
         460 Diapers
         461 Tyres, tubes, spares, brake pads etc
         463 Public transport - Taxi/Minibus
         465 Public transport – Bodaboda-Bicycle
         466 Stamps, envelops, etc.
         468 Expenditure on phone calls for phones not owned
         469 Others
         470 Sanitary Towels
         501 Consultation Fees
         502 Medicines etc
         503 Hospital/ clinic charges
         504 Traditional Doctors fees/ medicines
         505 Others
         506 Total expenditure on health
         507 Total expenditure on health
         601 Sports, theaters, etc
         602 Dry Cleaning and Laundry
         603 Houseboys/ girls, Shamba boys etc
         604 Barber and Beauty Shops
         605 Expenses in hotels, lodging, etc
        3051 Water NWSC
        3052 Water Other sources
        3111 Candles
        3112 Matches
        3121 Refuse collection
        4501 Internet fees
        4511 Mobile money charges
        4521 Detergent
        4541 Tooth brush
        4542 Toilet Paper
        4591 Toys, games etc
        4621 Lubricants (, engine oil, grease, coolant etc)
        4622 Petrol
        4623 Diesel
        4624 Maintenance,repair of vehicles,motorcycles, bicycles
        4631 Public transport - Bus
        4632 Public transport – Others (Truck,)
        4651 Maintenance and repair of vehicles, motorcycles and bicycles
        4661 Postal Services
        4671 Air time for fixed phones
        4672 Air time for mobile phones
        5041 Transport to and From health facility
        6061 Security fees (guard, LC defense, community security)
		
		
ta CEC02 if CEC02_1==1





















