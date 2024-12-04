cap : la drop shock_code

label define shock_code 1 `"Illness, injury, or death of income earning member of household"', add
label define shock_code 5 `"Job loss"', add
label define shock_code 6 `"Nonfarm business closure"', add
label define shock_code 7 `"Theft of cash and other property"', add
label define shock_code 8 `"Disruption of farming, livestock, fishing activities"', add
label define shock_code 9 `"Rodent or insect infestation causing poor harvest or deterioration of stocks"', add

label define shock_code 10 `"Increase in price of farming/business inputs"', add
label define shock_code 11 `"Fall in the price of farming/business output"', add
label define shock_code 12 `"Increase in price of major food items consumed"', add
label define shock_code 96 `"Other (specify)"', add

/*	malawi specific	*/ 
label define shock_code 21 `"Drought"', add
label define shock_code 22 `"Irregular rainfall"', add
label define shock_code 23 `"Flooding"', add
label define shock_code 24 `"Cyclone"', add
label define shock_code 25 `"Death of Any Other HH member due to COVID-19"', add
// label define shock_code 26 `"Disruption of farming, livestock, fishing activities"', add	//-> code 8
label define shock_code 27 `"Reduction in working hours"', add
label define shock_code 97 `"Other climate shocks (specify)"', add

/*	nigeria specific	*/ 
label define shock_code 31 `"Increase in the price of fuel/transportation"', add


/*	uganda specific	*/ 
label define shock_code 41 `"Death of someone who sends remittances to the household"', add
label define shock_code 42 `"Loss of an important contact"', add
// label define shock_code 43 `"Increase in fuel price"', add	//->	code 31 


/*	burkina faso specific	*/
label define shock_code 51 `"Very high temperatures"', add	//	 (>40˚C) modifier droppped for broader compatibility
label define shock_code 52 `"Livestock deaths due to disease"', add
label define shock_code 53 `"Property damage"', add


/*	ethiopia specific	*/
label define shock_code 61 `"Death of household member (main bread earner)"', add
label define shock_code 62 `"Death of a child under 5 including miscarriage or stillbirth"', add
label define shock_code 63 `"Death of other household member"', add
label define shock_code 64 `"Illness of household member"', add
label define shock_code 65 `"Landslides / avalanches"', add
label define shock_code 66 `"Heavy rains preventing work"', add
label define shock_code 67 `"Other crop damage"', add
label define shock_code 68 `"Fire"', add
label define shock_code 69 `"Theft/robbery and other violence"', add
label define shock_code 70 `"Involuntary loss of house/land"', add
label define shock_code 71 `"Displacement (due to government development projects)"', add
label define shock_code 72 `"Local unrest/violence"', add


/*	added to manage some common other, specify responses	*/
label define shock_code 13 `"Increase in price of non-food items"', add
label define shock_code 14 `"Lack of money"', add	//	adding since this is distinct from price increase, but the respondent is not linking it to lack of demand as coded below 
label define shock_code 28 `"Breakup of household"', add
label define shock_code 29 `"Lack of demand for products/services"', add
label define shock_code 30 `"Lack of supply of products/services"', add

