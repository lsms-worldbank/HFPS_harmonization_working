

cap : la drop item
#d ; 
la def item
	10	"sorghum"
	13	"rice"
	30	"cassava"
	31	"sweet potato"
	42	"dry beans"	/*	this is just an assumption	*/
	72	"onions"
;
#d cr

ex

u "${raw_lsms_nga}/sect10b_harvestw4.dta", clear
la li LABA

          10 10. Guinea corn/sorghum
          11 11. Millet
          13 13. Rice  - local
          14 14. Rice - imported
          16 16. Maize flour
          17 17. Yam flour
          18 18. Cassava  flour
          19 19. Wheat flour
          20 20. Maize (On the cob)
          22 22. Maize (Off the cob/grains)
          23 23. Other grains and flour (specify)
          25 25. Bread
          26 26. Cake
          27 27. Buns/Pofpof/Donuts
          28 28. Biscuits
          29 29. Meat Pie/Sausage Roll
          30 30. Cassava - roots
          31 31. Yam - roots
          32 32. Gari - white
          33 33. Gari - yellow
          34 34. Cocoyam
          35 35. Plantains
          36 36. Sweet potatoes
          37 37. Potatoes
          38 38. Other roots and tuber
          40 40. Soya beans
          41 41. Brown beans
          42 42. White beans
          43 43. Groundnuts (Unshelled, in the pod)
          44 44. Groundnuts (Shelled, removed from the pod)
          45 45. Other nuts/seeds/pulses
          46 46. Coconut
          47 47. Kola nut
          48 48. Cashew nut
          50 50. Palm oil
          51 51. Butter/ Margarine
          52 52. Groundnuts Oil
          53 53. Other oil and Fat(specify)
          56 56. Animal fat
          60 60. Bananas
          61 61. Orange/tangerine
          62 62. Mangoes
          63 63. Avocado pear
          64 64. Pineapples
          65 65. Fruit canned
          66 66. Other fruits(specify)
          67 67. Pawpaw
          68 68. Watermelon
          69 69. Apples
          70 70. Tomatoes
          71 71. Tomato puree/paste (canned/sachet)
          72 72. Onions
          73 73. Garden eggs/egg plant
          74 74. Okra - fresh
          75 75. Okra - dried
          76 76. Fresh Pepper
          77 77. Dried Peppers (EXCLUDING GROUND PEPPER)
          78 78. Leaves (Cocoyam, Spinach, etc.)
          79 79. Other vegetables (fresh or canned)(specify)
          80 80. Chicken
          81 81. Duck
          82 82. Other domestic poultry
          83 83. Agricultural eggs
          84 84. Local eggs
          90 90. Beef
          91 91. Mutton
          92 92. Pork
          93 93. Goat
          94 94. Wild game/bush meat
          96 96. Other meat (excl. poultry)(specify)
         100 100. Fish - fresh
         101 101. Fish - frozen
         102 102. Fish - smoked
         103 103. Fish - dried
         104 104. Snails
         105 105. Seafood (lobster, crab, prawns, etc)
         106 106. Canned fish/seafood
         107 107. Other fish or seafood(specify)
         110 110. Fresh milk
         111 111. Milk powder
         112 112. Baby milk powder
         113 113. Milk tinned
         114 114. Cheese (wara)
         115 115. Other milk products(specify)
         120 120. Coffee
         121 121. Chocolate drinks (including Milo)
         122 122. Tea
         130 130. Sugar
         132 132. Honey
         133 133. Other sweets and confectionery(specify)
         141 141. Salt
         142 142. Unground Ogbono
         143 143. Ground Ogbono
         144 144. Ground Pepper
         145 145. Melon (shelled)
         146 146. Melon (unshelled)
         147 147. Melon (ground)
         148 148. Other Spices (e.g. maggi)
         150 150. Bottled water
         151 151. Sachet water
         152 152. Malt drinks
         153 153. Soft drinks (Coca Cola, spirit, etc)
         154 154. Fruit juice canned/Pack
         155 155. Other non-alcoholic drinks (specify)
         160 160. Beer (local and imported)
         161 161. Palm wine
         162 162. Pito
         163 163. Gin
         164 164. Other alcoholic beverages
         231 231. Semovita/semolina
         232 232. Akanu/Pap/Obi
         233 233. Fufu
         234 234. Plantain flour
         235 235. Macoroni/pasta/noodles
         236 236. Custard
         237 237. Acha/fonio
         381 381. Yam - second variety
         382 382. Muruchi
         452 452. Beniseed/Sesame
         453 453. Bambara nut
         454 454. Palm nut
         455 455. Palm kernal
         456 456. Locust beans
         457 457. Walnut
         532 532. Vegetable oil
         533 533. Shea butter oil
         601 601. Guava
         661 661. Agbalumo/Udara/Star apple
         662 662. Cashew fruit
         663 663. Cherry
         664 664. Pear
         665 665. Date
         791 791. Cucumber
         792 792. Leaves (second variety)
         793 793. Kuka/Baobab
         794 794. Carrot
         795 795. Dried tomatoes
         796 796. Cabbage
         821 821. Guinea fowl
         822 822. Turkey
         851 851. Guinea fowl eggs
         852 852. Turkey eggs
         961 961. Ponmo/cow skin
         962 962. Donkey
         963 963. Dog meat
        1071 1071. Crayfish
        1072 1072. Periwinkle
        1151 1151. Sour milk/nono
        1152 1152. Yoghurt
        1153 1153. Soya milk
        1331 1331. Sugar cane
        1551 1551. Zobo
        1552 1552. Kunu
        1641 1641. Burkutu
