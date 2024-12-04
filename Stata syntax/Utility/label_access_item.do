

{	/*	program to label item, developed in NG first, 
		expanded successively for UG, MW, TZ, ET, & BF 	*/
cap : 	prog drop	label_access_item
		prog def	label_access_item
#d ; 
la def item 
	/*	round 1	*/ 
	1	"medicine"
	2	"soap"
	3	"cleaning supplies"
	4	"rice"
	5	"beans"		/*	both dry and fresh	*/
	6	"cassava"
	7	"yam"		/*	also sweet potato	*/
	8	"guinea corn/sorghum"
	
	/*	round 2	*/ 
	9	"drinking water"
	10	"washing water"
	11	"medical treatment"
	
	/*	round 3	*/
	12	"child vaccination"
	13	"public transit"
	
	/*	round 9	*/
	14	"onion"
	
	51	"family planning"
	52	"vaccination"
	53	"maternal health/pregnancy care"
	54	"child health"
	55	"adult health"	//	binning with general health 
	56	"emergency care"
	57	"pharmacy/other"	//	
	
	/*	round 13	*/ 
	58 "COVID-19 related"
	59 "Ebola related"	/*	UG rounds 11 & 12 only */
	
	/*	round 16	*/
	21	"fuel"
	
	/*	round 20 */
	/*	31	"travel to nearest market"
		32	"travel to place of worship"	*/
	31	"bus"
	32	"train"
	33	"bicycle"
	34	"motorcycle"
	35	"car"
	36	"taxi"
	37	"tricycle/keke/rickshaw"
	38	"boat/canoe"
	39	"truck/lorry/ox cart"	/*	add ox cart for MW round 17	*/
	
	/*	round 21	*/
	40	"any fertilizer"
	41	"organic fertilizer"
	42	"inorg fert - NPK"
	43	"inorg fert - UREA"
	44	"inorg fert - other types"
	/*	BF round 18+ */
	45	"maize seed"
	46	"soy seed"
	47	"bean seed"
	/*	Eth	*/
	48	"teff"
	49	"injera"
	
	/*	UG round 1	*/
	15	"staple"
	16	"maize"			/*	equating to maize flour as well	*/
	17	"matooke"
	18	"millet"
	19	"sorghum"
	20	"irish potato"

	60	"sauce"
	61	"fish"			/*	binning silverfish into this as well (UG)	*/
	62	"mukene"
	63	"meat/beef"		/*	equating this to beef and mutton	*/ 
	64	"chicken"
	65	"greens"
	66	"peas"
	67	"groundnuts"
	68	"ghee/oil"		/*	binning this with oil	*/
	
	25	"financial services"
	/*	UG round 3	*/
	26	"mask"
	
	/*	UG round 6	*/ 
	22	"egg"
	71	"detergent"
	72	"internet access"
	
	/*	UG round 8+	*/
	81	"bread"
	82	"milk"
	83	"dry beans"
	84	"fresh beans"
	85	"tomato"
	86	"eggplant"
	87	"sugar"
	88	"tea"
	89	"salt"
	
	/*	MW round 1	*/
	90	"sesame"
	
	/*	MW fuels (r16+)	*/
	91	"petrol"
	92	"diesel"
	93	"paraffin"	/*	binning with kerosene	*/ 
	94	"liquefied petroleum gas (LPG)"
	95	"firewood"	/*	MW r20	*/
	96	"charcoal"	/*	ET r13+	*/
	
	/*	BF round 18+ */
	69	"wheat"
	, replace 
	;  
#d cr 
la val item item
format item %30.0g
inspect item
assert r(N_undoc)==0
ta item
end
}




ex	//	not yet operations

// cap : 	prog def	label_access_item
// 		prog drop	label_access_item
#d ; 
la def item 
	1	"medicine"
	2	"soap"
	3	"cleaning supplies"
	4	"rice"
	5	"beans"
	6	"cassava"
	7	"yam"
	8	"guinea corn/sorghum"
	
	9	"drinking water"
	10	"washing water"
	11	"medical treatment"
	;  
#d cr 
la val item item
inspect item
// end


