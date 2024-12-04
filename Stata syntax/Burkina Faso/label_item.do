
cap : la drop item
#d ; 
la def item 
	1	"local rice"
	3	"imported rice"
	6	"maize grain"
	7	"millet"
	8	"sorghum"
	12	"maize flour"
	14	"wheat flour"
	17	"bread"
	23	"beef"
	25	"mutton"
	36	"horse mackerel"	/* (modal type in 2018)	*/
	41	"dried fish"
	44	"fresh milk"
	52	"eggs"
	55	"cooking oil"	/*	palm oil */
	75	"fresh beans"
	79	"tomatoes"
	80	"tomato concentrate"
	83	"onions"
	95	"dry beans"
	98	"crushed peanuts"
	114 "sugar"
	118 "salt"
	130	"tea"
	
	104	"cassava"	
	107	"irish potato"	
	109	"sweet potato"	
	111	"cassava flour"	
	222	"sorghum flour"	/*	not coded in 2018 (aside from "other flour" category)	*/ 
	
	601	"maize seed"
	602	"soya seed"
	603	"bean seed"
	
	701	"petrol"
	702	"diesel"
	703	"paraffin"
	704	"LPG"	/*	liquefied petroleum gas (bottled)	*/
	
	801	"fuel for car"
	802	"fuel for motorcycle"
	901	"chemical fertilizer"
	
	
	;
#d cr 











ex	//	following is the raw item code from 2018

u "${raw_lsms_bfa}/s07b_me_bfa2018.dta", clear
la li produitID

label define produitID 1 `"Riz local (BagrÃ© Sourou et Bama)"', modify
label define produitID 2 `"Autre riz local (riz pluvial)"', modify
label define produitID 3 `"Riz importÃ© long grain"', modify
label define produitID 4 `"Autre riz importÃ© (brisure, etc.)"', modify
label define produitID 5 `"MaÃ¯s en Ã©pi"', modify
label define produitID 6 `"MaÃ¯s en grain"', modify
label define produitID 7 `"Petit Mil"', modify
label define produitID 8 `"Sorgho"', modify
label define produitID 9 `"BlÃ©"', modify
label define produitID 10 `"Fonio"', modify
label define produitID 12 `"Farine de maÃ¯s"', modify
label define produitID 13 `"Farine de mil"', modify
label define produitID 14 `"Farine de blÃ© local ou importÃ©"', modify
label define produitID 16 `"PÃ¢tes alimentaires"', modify
label define produitID 17 `"Pain moderne"', modify
label define produitID 18 `"Pain traditionnel"', modify
label define produitID 19 `"Croissants"', modify
label define produitID 20 `"Biscuits"', modify
label define produitID 21 `"GÃ¢teaux"', modify
label define produitID 22 `"Beignets, galettes"', modify
label define produitID 23 `"Viande de bÅuf"', modify
label define produitID 24 `"Viande de chameau"', modify
label define produitID 25 `"Viande de mouton"', modify
label define produitID 26 `"Viande de chÃ¨vre"', modify
label define produitID 27 `"Abats et tripes (foie, rognon, etc.)"', modify
label define produitID 28 `"Viande de porc"', modify
label define produitID 29 `"Poulet sur pied"', modify
label define produitID 30 `"Viande de poulet"', modify
label define produitID 31 `"Viande d'autres volailles domestiques"', modify
label define produitID 32 `"Charcuterie (jambon, saucisson), conserves de viandes"', modify
label define produitID 33 `"Gibiers"', modify
label define produitID 34 `"Autres viandes n.d.a"', modify
label define produitID 35 `"Poisson frais carpe"', modify
label define produitID 36 `"Poisson frais chinchard"', modify
label define produitID 37 `"Poisson frais maquereau"', modify
label define produitID 38 `"Autres poissons frais"', modify
label define produitID 39 `"Poisson fumÃ© siliure/carpe"', modify
label define produitID 40 `"Autre poisson fumÃ©"', modify
label define produitID 41 `"Poisson sÃ©chÃ©"', modify
label define produitID 43 `"Conserves de poisson"', modify
label define produitID 44 `"Lait frais"', modify
label define produitID 45 `"Lait caillÃ©, yaourt"', modify
label define produitID 46 `"Lait concentrÃ© sucrÃ©"', modify
label define produitID 47 `"Lait concentrÃ© non-sucrÃ©"', modify
label define produitID 48 `"Lait en poudre"', modify
label define produitID 49 `"Fromage"', modify
label define produitID 50 `"Lait et farines pour bÃ©bÃ©"', modify
label define produitID 51 `"Autres produits laitiers"', modify
label define produitID 52 `"Oeufs"', modify
label define produitID 53 `"Beurre"', modify
label define produitID 54 `"Beurre de karitÃ©"', modify
label define produitID 55 `"Huile de palme rouge"', modify
label define produitID 56 `"Huile d'arachide"', modify
label define produitID 57 `"Huile de coton"', modify
label define produitID 58 `"Huile de palme raffinÃ©e"', modify
label define produitID 59 `"Autres huiles n.d.a. (maÃ¯s, soja, huile palmiste, etc.)"', modify
label define produitID 60 `"Mangue"', modify
label define produitID 61 `"Ananas"', modify
label define produitID 62 `"Orange"', modify
label define produitID 63 `"Banane douce"', modify
label define produitID 64 `"Citrons"', modify
label define produitID 65 `"Autres agrumes"', modify
label define produitID 66 `"Avocats"', modify
label define produitID 67 `"PastÃ¨que, Melon"', modify
label define produitID 68 `"Dattes"', modify
label define produitID 69 `"Noix de coco"', modify
label define produitID 70 `"Canne Ã  sucre"', modify
label define produitID 71 `"Autres fruits (pommes, raisin, etc.)"', modify
label define produitID 72 `"Salade (laitue)"', modify
label define produitID 73 `"Choux"', modify
label define produitID 74 `"Carotte"', modify
label define produitID 75 `"Haricot vert"', modify
label define produitID 76 `"Concombre"', modify
label define produitID 77 `"Aubergine, Courge/Courgette"', modify
label define produitID 78 `"Poivron frais"', modify
label define produitID 79 `"Tomate fraÃ®che"', modify
label define produitID 80 `"Tomate sÃ©chÃ©e"', modify
label define produitID 81 `"Gombo frais"', modify
label define produitID 82 `"Gombo sec"', modify
label define produitID 83 `"Oignon frais"', modify
label define produitID 84 `"Ail"', modify
label define produitID 85 `"Feuilles d'oseille"', modify
label define produitID 86 `"Feuilles de baobab"', modify
label define produitID 87 `"Feuilles de haricot"', modify
label define produitID 88 `"Feuilles locales (Boulvanka)"', modify
label define produitID 89 `"Feuilles de manioc, feuilles de taro et, autres feuilles"', modify
label define produitID 90 `"Autre lÃ©gumes frais n.d.a (Kapok, Voaga)"', modify
label define produitID 91 `"ConcentrÃ© de tomate"', modify
label define produitID 92 `"Petits pois"', modify
label define produitID 93 `"Petit pois secs"', modify
label define produitID 94 `"Autres lÃ©gumes secs n.d.a"', modify
label define produitID 95 `"NiÃ©bÃ©/Haricots secs"', modify
label define produitID 96 `"Arachides fraÃ®ches en coques"', modify
label define produitID 97 `"Arachides sÃ©chÃ©es en coques"', modify
label define produitID 98 `"Arachides dÃ©cortiquÃ©es ou pilÃ©es"', modify
label define produitID 99 `"Arachide grillÃ©e"', modify
label define produitID 100 `"PÃ¢te d'arachide"', modify
label define produitID 101 `"SÃ©same"', modify
label define produitID 102 `"Noix de cajou"', modify
label define produitID 103 `"Noix de karitÃ©"', modify
label define produitID 104 `"Manioc"', modify
label define produitID 105 `"Igname"', modify
label define produitID 106 `"Plantain"', modify
label define produitID 107 `"Pomme de terre"', modify
label define produitID 108 `"Taro, macabo"', modify
label define produitID 109 `"Patate douce"', modify
label define produitID 110 `"Autres tubercules n.d.a"', modify
label define produitID 111 `"Farines de manioc"', modify
label define produitID 112 `"Gari, tapioca"', modify
label define produitID 113 `"AttiÃ©ke"', modify
label define produitID 114 `"Sucre (poudre ou morceaux)"', modify
label define produitID 115 `"Miel"', modify
label define produitID 116 `"Chocolat Ã  croquer, pÃ¢te Ã  tartiner"', modify
label define produitID 117 `"Caramel, bonbons, confiseries, etc"', modify
label define produitID 118 `"Sel"', modify
label define produitID 119 `"Piment"', modify
label define produitID 120 `"Gingembre"', modify
label define produitID 121 `"Cube alimentaire (Maggi, Jumbo, )"', modify
label define produitID 122 `"ArÃ´me (Maggi, Jumbo, etc.)"', modify
label define produitID 123 `"Soumbala (moutarde africaine)"', modify
label define produitID 124 `"Mayonnaise"', modify
label define produitID 125 `"Vinaigre /moutarde"', modify
label define produitID 126 `"Autres condiments (poivre etc.)"', modify
label define produitID 127 `"Noix de cola"', modify
label define produitID 128 `"Autres produits alimentaires"', modify
label define produitID 129 `"CafÃ©"', modify
label define produitID 130 `"ThÃ©"', modify
label define produitID 131 `"Chocolat en poudre"', modify
label define produitID 132 `"Autres tisanes et infusions n.d.a. (quinquelibat, citronelle, etc.)"', modify
label define produitID 133 `"Jus de fruits (orange, bissap, gingembre, jus de cajou,etc.)"', modify
label define produitID 134 `"Eau minÃ©rale/ filtrÃ©e"', modify
label define produitID 135 `"Boissons gazeuses (coca, etc.)"', modify
label define produitID 136 `"Jus en poudre"', modify
label define produitID 137 `"BiÃ¨res et vins traditionnels (dolo, vin de palme, vin de raphia, etc.)"', modify
label define produitID 138 `"BiÃ¨res industrielles"', modify
