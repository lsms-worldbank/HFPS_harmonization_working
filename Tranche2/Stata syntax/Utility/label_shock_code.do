cap : la drop shock_code

label define shock_code 1 `"Illness, injury, or death of income earning member of household"', modify
label define shock_code 5 `"Job loss"', modify
label define shock_code 6 `"Nonfarm business closure"', modify
label define shock_code 7 `"Theft of cash and other property"', modify
label define shock_code 8 `"Disruption of farming, livestock, fishing activities"', modify
label define shock_code 9 `"Rodent or insect infestation causing poor harvest or deterioration of stocks"', modify

label define shock_code 10 `"Increase in price of farming/business inputs"', modify
label define shock_code 11 `"Fall in the price of farming/business output"', modify
label define shock_code 12 `"Increase in price of major food items consumed"', modify
label define shock_code 96 `"Other (specify)"', modify

/*	malawi specific	*/ 
label define shock_code 21 `"Drought"', modify
label define shock_code 22 `"Irregular rainfall"', modify
label define shock_code 23 `"Flooding"', modify
label define shock_code 24 `"Cyclone"', modify
label define shock_code 25 `"Death of Any Other HH member due to COVID-19"', modify

/*	nigeria specific	*/ 
label define shock_code 31 `"Increase in the price of fuel/transportation"', modify


/*	uganda specific	*/ 
label define shock_code 41 `"Death of someone who sends remittances to the household"', modify
label define shock_code 42 `"Loss of an important contact"', modify
label define shock_code 43 `"Increase in fuel price"', modify


/*	burkina faso specific	*/
label define shock_code 51 `"Very high temperatures"', modify	//	 (>40˚C) modifier droppped for broader compatibility
label define shock_code 52 `"Livestock deaths due to disease"', modify
label define shock_code 53 `"Property damage"', modify


/*	ethiopia specific	*/
label define shock_code 61 `"Death of household member (main bread earner)"', modify
label define shock_code 62 `"Death of a child under 5 including miscarriage or stillbirth"', modify
label define shock_code 63 `"Death of other household member"', modify
label define shock_code 64 `"Illness of household member"', modify
label define shock_code 65 `"Landslides / avalanches"', modify
label define shock_code 66 `"Heavy rains preventing work"', modify
label define shock_code 67 `"Other crop damage"', modify
label define shock_code 68 `"Fire"', modify
label define shock_code 69 `"Theft/robbery and other violence"', modify
label define shock_code 70 `"Involuntary loss of house/land"', modify
label define shock_code 71 `"Displacement (due to government development projects)"', modify
label define shock_code 72 `"Local unrest/violence"', modify
