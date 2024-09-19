


cap : la drop item
#d ; 
la def item
           2 "wheat grain"
           3 "maize grain"
           4 "sorghum grain"
           5 "bread"
           6 "injera"
           7 "cooking oil"
           8 "onions"
           9 "tomatoes"
          10 "sugar"
          11 "charcoal"
          12 "firewood"
          13 "kerosene"
         111 "red teff grain"
         112 "white teff grain"
         113 "mixed teff grain"

          22 "wheat flour"
          23 "maize flour"
          24 "sorghum flour"
         131 "red teff flour"
         132 "white teff flour"
         133 "mixed teff flour"
		 ;
#d cr

ex

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
	305	"grondnut flour"	/*	- pounded gnuts */
	
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
	7005	"kerosene"
	7006	"charcoal"
	7007	"firewood"
	
	8001	"fuel for car"
	8002	"fuel for motorcycle"
	8003	"transport to nearest market"
	9001	"chemical fertilizer"
	
	
	;
#d cr 


recode fp_00 (111/113=1)(2=2)(3=4)(4=5)(5=196)(6=195)(7=202)(8=14)(9=144)(10=22)
	(else=.), gen(item_cd_cf);
