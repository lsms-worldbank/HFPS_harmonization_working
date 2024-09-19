
label define closed_why_nfe 1 `"USUAL PLACE OF BUSINESS CLOSED DUE TO CORONAVIRUS RECOMMENDATIONS"', modify
label define closed_why_nfe 2 `"USUAL PLACE OF BUSINESS CLOSED FOR ANOTHER REASON"', modify
label define closed_why_nfe 3 `"NO COSTUMERS / FEWER CUSTOMERS"', modify
label define closed_why_nfe 4 `"CAN'T GET INPUTS"', modify
label define closed_why_nfe 5 `"CAN'T TRAVEL / TRANSPORT GOODS FOR TRADE"', modify
label define closed_why_nfe 6 `"ILL / QUARANTINED DUE TO CORONAVIRUS"', modify
label define closed_why_nfe 7 `"ILL WITH ANOTHER DISEASE"', modify
label define closed_why_nfe 8 `"NEED TO TAKE CARE OF A FAMILY MEMBER"', modify
label define closed_why_nfe 9 `"SEASONAL CLOSURE"', modify
label define closed_why_nfe 10 `"VACATION"', modify
label define closed_why_nfe 11 `"LACK OF CAPITAL OR LOSS OF WORKING CAPITAL"', modify
label define closed_why_nfe 12 `"USUAL PLACE OF BUSINESS CLOSED DUE TO ENDSARS PROTESTS"', modify
label define closed_why_nfe 13 `"INCREASE IN THE PRICE OF INPUTS"', modify
label define closed_why_nfe 96 `"OTHER (SPECIFY)"', modify






ex
u s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
la save s6q11b using "${do_hfps_util}/label_closed_why_nfe.do", replace

label define s6q11b 1 `"1. USUAL PLACE OF BUSINESS CLOSED DUE TO CORONAVIRUS RECOMMENDATIONS"', modify
label define s6q11b 2 `"2. USUAL PLACE OF BUSINESS CLOSED FOR ANOTHER REASON"', modify
label define s6q11b 3 `"3. NO COSTUMERS / FEWER CUSTOMERS"', modify
label define s6q11b 4 `"4. CAN'T GET INPUTS"', modify
label define s6q11b 5 `"5. CAN'T TRAVEL / TRANSPORT GOODS FOR TRADE"', modify
label define s6q11b 6 `"6. ILL / QUARANTINED DUE TO CORONAVIRUS"', modify
label define s6q11b 7 `"7. ILL WITH ANOTHER DISEASE"', modify
label define s6q11b 8 `"8. NEED TO TAKE CARE OF A FAMILY MEMBER"', modify
label define s6q11b 9 `"9. SEASONAL CLOSURE"', modify
label define s6q11b 10 `"10. VACATION"', modify
label define s6q11b 11 `"11. LACK OF CAPITAL OR LOSS OF WORKING CAPITAL"', modify
label define s6q11b 12 `"12. USUAL PLACE OF BUSINESS CLOSED DUE TO ENDSARS PROTESTS"', modify
label define s6q11b 13 `"13. INCREASE IN THE PRICE OF INPUTS"', modify
label define s6q11b 96 `"96. OTHER (SPECIFY)"', modify
