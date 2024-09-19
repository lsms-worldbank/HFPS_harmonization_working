
cap :	prog drop	label_item_ltfull
		prog def	label_item_ltfull
syntax name(name=stub)

qui : ds item_`stub'_cat*, alpha varw(24)	//	here to ensure an order comes if the stub is not present


*	routine to automatically order the variables
qui {
	cap : ds item_`stub'_cat?, alpha
	if _rc==0 {
	loc order1 `r(varlist)'
	}
	cap : ds item_`stub'_cat??, alpha
	if _rc==0 {
	loc order2 `r(varlist)'
	}
	loc orderset `order1' `order2'
	cap : g item_`stub'_lbl=., b(`: word 1 of `orderset'')
	order `orderset', a(item_`stub'_lbl)
}
		if "`stub'"=="noaccess"	{
		la var item_`stub'_lbl		"Failed to access item because [...]"
		}
		if "`stub'"=="ltfull"	{
		la var item_`stub'_lbl		"Failed to access full amount of item because [...]"
		}
		
		cap : drop item_`stub'_label	//	simple cleanup step 
		
cap : la var item_`stub'_cat1 "Shops have run out of stock"				/*	binning quotas here as well	*/	
cap : la var item_`stub'_cat2 "Local markets not operating / closed"		
cap : la var item_`stub'_cat3 "Limited / no transportation"				
cap : la var item_`stub'_cat4 "Restriction to go outside"					
cap : la var item_`stub'_cat5 "Increase in price"							
cap : la var item_`stub'_cat6 "Decrease in regular income"		/*	cannot afford	*/			
				
				/*	TZ round 1, possibly should go back retroactively to NG/MW/UG	*/
cap : la var item_`stub'_cat8	"Traditional or herbal medicine"
cap : la var item_`stub'_cat9	"Did not try/did nothing"	/*	bin religious efforts here too	*/ 

cap : la var item_`stub'_cat11	"Afraid to go out because of Coronavirus"	
cap : la var item_`stub'_cat12	"On suspicion of having Coronavirus"		
cap : la var item_`stub'_cat13	"Refused treatment by facility"				
				/*	UG round 11	*/
cap : la var item_`stub'_cat32	"Ebola"

cap : la var item_`stub'_cat21	"Security concerns"	/*	7 in ET	*/

				/*	UG round 1	*/ 
cap : la var item_`stub'_cat31	"No access to cash and cannot pay with credit card"

				/*	phase 2 health codes	*/
cap : la var item_`stub'_cat41	"Lack of money"
cap : la var item_`stub'_cat42	"No medical personnel available"
cap : la var item_`stub'_cat43	"Turned away because facility was full"
cap : la var item_`stub'_cat44	"Facility was closed"
cap : la var item_`stub'_cat45	"Facility not having enough supplies or tests"
cap : la var item_`stub'_cat46	"Health facility is too far"
cap : la var item_`stub'_cat47	"Fear of contracting coronavirus"
cap : la var item_`stub'_cat48	"Lockdown/travel restrictions"
cap : la var item_`stub'_cat49	"Lack of transportation"
cap : la var item_`stub'_cat50	"Used traditional medicine/self medicated/did nothing"


cap : la var item_`stub'_cat91 "Water supply no longer available"			
cap : la var item_`stub'_cat92 "Water supply reduced"						
cap : la var item_`stub'_cat93 "Unable to access communal water sources"	

d item_`stub'_*, fullnames


end

ex	//	notes follow 

, replace; 
#d cr 

{	/*	UG	*/

	*	round 1
s4q02:
         -96 other
           1 SHOPS HAVE RUN OUT OF STOCK
           2 LOCAL MARKETS NOT OPERATING / CLOSED
           3 LIMITED / NO TRANSPORTATION
           4 RESTRICTION TO GO OUTSIDE
           5 INCREASE IN PRICE
           6 NO ACCESS TO CASH AND CANNOTPAY WITH CREDIT CARD
           7 CANNOT AFFORD IT
           8 AFRAID TO GET OUT AND GETTING THE VIRUS
          99 REFUSED TO RESPOND
s4q04:
         -96 other
           1 WATER SUPPLY NO LONGER AVAILABLE
           2 WATER SUPPLY REDUCED
           3 UNABLE TO ACCESS COMMUNAL SOURCES
           4 SHOPS HAVE RUN OUT OF STOCK
           5 LOCAL MARKETS NOT OPERATING / CLOSED
           6 LIMITED / NO TRANSPORTATION
           7 RESTRICTION TO GO OUTSIDE
           8 INCREASE IN PRICE
           9 NO ACCESS TO CASH AND CANNOTPAY WITH CREDIT CARD
          10 CANNOT AFFORD IT
          11 AFRAID TO GET OUT AND GETTING THE VIRUS
          99 REFUSED TO RESPOND
s4q11:
         -96 OTHER(SPECIFY)
           1 LACK OF MONEY
           2 NO MEDICAL PERSONNEL AVAILABLE
           3 TURNED AWAY BECAUSE FACILITY WAS FULL
           4 FEAR TO GET INFECTED AT THE HEALTH FACILITY
           5 FACILITY WAS CLOSED
           6 DID NOT GET CLEARANCE FROM THE AUTHORITIES TO TRAVEL TO A FACILITY
           7 LACK OF TRANSPORATION
          99 REFUSED TO RESPOND

	
}	/*	end UG	*/





{	/*	NG	*/
	1	"OUT OF STOCK"
	2	"LOCAL MARKETS NOT OPERATING/CLOSED"
	3	"LIMITED/NO TRANSPORTATION"
	4	"RESTRICTION TO GO OUTSIDE"
	5	"PRICE TOO HIGH"
	6	"NO MONEY TO BUY"

	*	NG round 2 drinking water, also round 7
	s5q1f:
           1 1. WATER SUPPLY NO LONGER AVAILABLE	//	->	91
           2 2. WATER SUPPLY REDUCED				//	->	92
           3 3. UNABLE TO ACCESS COMMUNAL SOURCES	//	->	93
           4 4. SHOPS HAVE RUN OUT OF STOCK
           5 5. LOCAL MARKETS NOT OPERATING / CLOSED
           6 6. LIMITED / NO TRANSPORTATION
           7 7. RESTRICTION TO GO OUTSIDE
           8 8. INCREASE IN PRICE
          10 10. CANNOT AFFORD IT
          11 11. AFRAID TO GET OUT AND GETTING THE VIRUS	//	->	11
          96 96. OTHER (SPECIFY)
s5q1a1:	/*	NG round 2 soap	*/
           1 1. SHOPS HAVE RUN OUT OF STOCK
           2 2. LOCAL MARKETS NOT OPERATING / CLOSED
           3 3. LIMITED / NO TRANSPORTATION
           4 4. RESTRICTION TO GO OUTSIDE
           5 5. INCREASE IN PRICE
           7 7. CANNOT AFFORD IT
           8 8. AFRAID TO GET OUT AND GETTING THE VIRUS
          96 96. OTHER (SPECIFY)

s5q4:/*	NG round 2 medical treatment	*/
           1 1. LACK OF MONEY
           2 2. NO MEDICAL PERSONNEL AVAILABLE
           3 3. TURNED AWAY BECAUSE FACILITY WAS FULL
           4 4. DUE TO MOVEMENT RESTRICTIONS
          96 96. OTHER (SPECIFY)
/*	NG round 3 child vaccination	*/ 
s5q3c__1    ACK OF MONEY
s5q3c__2    NO MEDICAL PERSONNEL AVAILABLE			//	->	not operating
s5q3c__3    TURNED AWAY BECAUSE FACILITY WAS FULL	//	->	out of stock
s5q3c__4    DUE TO MOVEMENT RESTRICTIONS
s5q3c__5    ON SUSPICION OF HAVING CORONAVIRUS		//	->	12
s5q3c__6    REFUSED TREATMENT BY FACILITY			//	->	13
s5q3c__96   OTHER (SPECIFY)
s5q3c_os    PLEASE SPECIFY OTHER
/*	NG round 3 public transit	*/
s5q13__1      Why not able to access it: CESSATION OF SERVICE	//->	2 not operating
s5q13__2      Why not able to access it: MOVEMENT RESTRICTION	//->	4
s5q13__3      Why not able to access it: AFRAID TO GO OUT BECAUSE OF CORONAVIRUS	//->11
s5q13__4      Why not able to access it: INCREASE IN COST OF TRANSPORTATION	//->	5
s5q13__96     Why not able to access it: OTHER (SPECIFY)
s5q13_os      Specify other education/learning activity
s5q13a        Did you face any difficulties accessing it?
s5q13b__1     What difficulties did you face accessing the public transport?:REDUCED FREQUENCY	//->	2 not operating
s5q13b__2     What difficulties did you face accessing the public transport?:REDUCED CAPACITY	//->	1 out of stock		//	these decisions are 
s5q13b__3     What difficulties did you face accessing the public transport?:HIGHER PRICES		//->	5
s5q13b__96    What difficulties did you face accessing the public transport?:OTHER (SPECIFY)
s5q13b_os     Specify other education/learning activity
*	avoiding code 3 limited/no transportation as it does not provide specificity 
*	within transport issues. to use it, we would need to bin some of these. 

/*	NG round 4 medial treatment	*/
s5q4:
           1 1. LACK OF MONEY							6
           2 2. NO MEDICAL PERSONNEL AVAILABLE			2
           3 3. TURNED AWAY BECAUSE FACILITY WAS FULL	1
           4 4. DUE TO MOVEMENT RESTRICTIONS			4
           5 5. ON SUSPICION OF HAVING CORONAVIRUS		12
           6 6. REFUSED TREATMENT  BY FACILITY			13
          96 96. OTHER (SPECIFY)

		  
/*	NG round 15 medical treatment, also r17 	*/
s5fq6_2:
           1 1. LACK OF MONEY
           2 2. NO MEDICAL PERSONNEL AVAILABLE
           3 3. TURNED AWAY BECAUSE FACILITY WAS FULL
           4 4. TURNED AWAY BECAUSE FACILITY WAS CLOSED
           5 5. HOSPITAL/CLINIC NOT HAVING ENOUGH SUPPLIES OR TESTS
           6 6. HEALTH FACILITY IS TOO FAR
           7 7. FEAR OF CONTRACTING CORONAVIRUS
           8 8. LOCKDOWN/TRAVEL RESTRICTIONS
           9 9. LACK OF TRANSPORTATION
          96 96. OTHER (SPECIFY)

/*	NG round 16 petrol	*/
s5gq2__1	Having to queue for a long time
s5gq2__2	Having to pay more than official price
s5gq2__3	Petrol not available at all at filling stations
/*	NG round 19 petrol	*/	
s5gq2__1	Having to queue for a long time
s5gq2__2	Petrol/fuel not available at all at filling stat
s5gq2__3	Having to pay extra to avoid queuing at the fill
s5gq2__4	Having to pay extra at the filling station to ge
s5gq2__5	Having to travel extra distance to get petrol

















}	/*	end NG	*/	



*	et phase 1
         -99 Refused
         -98 Don't Know
         -96 Other (specify)
           1 Shops have run out of stock
           2 Local markets not operating / closed
           3 Limited / no transportation
           4 Restriction to go outside
           5 Increase in price
           6 Decrease in regular income





	*	et phase 2
         -96 Other (specify)
           1 Out of stock
           2 Price has increased
           3 Due to quotas
           5 Inferior quality or availability of items
           6 Not enough money to buy
           7 Not able to go to market due to security reasons
