
*	
label define emp_sector 1 `"AGRICULTURE, HUNTING, FISHING"', modify
label define emp_sector 2 `"MINING, MANUFACTURING"', modify
label define emp_sector 3 `"ELECTRICITY, GAS, WATER SUPPLY"', modify
label define emp_sector 4 `"CONSTRUCTION"', modify
label define emp_sector 5 `"BUYING & SELLING GOODS, REPAIR OF GOODS, HOTELS & RESTAURANTS"', modify
label define emp_sector 6 `"TRANSPORT, DRIVING, POST, TRAVEL AGENCIES"', modify
label define emp_sector 7 `"PROFESSIONAL ACTIVITIES: FINANCE, LEGAL, ANALYSIS, COMPUTER, REAL ESTATE"', modify
label define emp_sector 8 `"PUBLIC ADMINISTRATION"', modify
label define emp_sector 9 `"PERSONAL SERVICES, EDUCATION, HEALTH, CULTURE, SPORT, DOMESTIC WORK, OTHER"', modify


ex
/*
u	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"						, clear 
la copy s6q5 emp_sector

la save emp_sector using "${do_hfps_util}/label_emp_sector.do"
*/
*	the below were saved from the above 
label define emp_sector 1 `"1. AGRICULTURE, HUNTING, FISHING"', modify
label define emp_sector 2 `"2. MINING, MANUFACTURING"', modify
label define emp_sector 3 `"3. ELECTRICITY, GAS, WATER SUPPLY"', modify
label define emp_sector 4 `"4. CONSTRUCTION"', modify
label define emp_sector 5 `"5. BUYING &amp; SELLING GOODS, REPAIR OF GOODS, HOTELS &amp; RESTAURANTS"', modify
label define emp_sector 6 `"6. TRANSPORT, DRIVING, POST, TRAVEL AGENCIES"', modify
label define emp_sector 7 `"7. PROFESSIONAL ACTIVITIES: FINANCE, LEGAL, ANALYSIS, COMPUTER, REAL ESTATE"', modify
label define emp_sector 8 `"8. PUBLIC ADMINISTRATION"', modify
label define emp_sector 9 `"9. PERSONAL SERVICES, EDUCATION, HEALTH, CULTURE, SPORT, DOMESTIC WORK, OTHER"', modify
