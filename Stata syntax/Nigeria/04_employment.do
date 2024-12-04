




loc investigation=0
if `investigation'==1	{	/*	shutoff bracket to skip investigation work if we just desire to reset the data	*/


{	/*	data inventory	*/
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d using	"${raw_hfps_nga1}/r1_sect_1.dta"
d using	"${raw_hfps_nga1}/r2_sect_1.dta"
d using	"${raw_hfps_nga1}/r3_sect_1.dta"
d using	"${raw_hfps_nga1}/r4_sect_1.dta"
d using	"${raw_hfps_nga1}/r5_sect_1.dta"
d using	"${raw_hfps_nga1}/r6_sect_1.dta"
d using	"${raw_hfps_nga1}/r7_sect_1.dta"
d using	"${raw_hfps_nga1}/r8_sect_1.dta"
d using	"${raw_hfps_nga1}/r9_sect_1.dta"
d using	"${raw_hfps_nga1}/r10_sect_1.dta"
d using	"${raw_hfps_nga1}/r11_sect_1.dta"
d using	"${raw_hfps_nga1}/r12_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r1_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r4_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r5_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r6_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r7_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r8_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r10_sect_1.dta"
d using	"${raw_hfps_nga2}/p2r11_sect_1.dta"


d s6* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d s6* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
d s6* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d s6* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
d s6* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
d s6* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d s6* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
d s6* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
d s6* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
d s6* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"

d s6* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
d s6* using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
d s6* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"		//	has emp_respondent->	pull into individual
d s6* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	has emp_respondent->	pull into individual
d s6* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	has emp_respondent->	pull into individual	
d s6* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"		//	has emp_respondent->	pull into individual

d s6* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d s6* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
// d s6* using	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"
d s6* using	"${raw_hfps_nga2}/p2r11_sect_a_6_6d_13b_12.dta"	//	nfe as well
	*	this p2r9 section 6 is actually ag 

d using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
d using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
d using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
d using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
d using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
d using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
d using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
d using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"

d using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
d using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"		//	has emp_respondent->	pull into individual
d using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	has emp_respondent->	pull into individual
d using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	has emp_respondent->	pull into individual	
d using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"		//	has emp_respondent->	pull into individual

d using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"
d using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"
// d using	"${raw_hfps_nga2}/p2r10_sect_a_2_8_11c_12.dta"
d using	"${raw_hfps_nga2}/p2r11_sect_a_6_6d_13b_12.dta"	//	nfe as well
	*	this p2r9 section 6 is actually ag 




*	NFE modules 
u s6* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"			, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"			, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"			, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"				, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"		, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	, clear
la li s6q11 s6q12
u s6* using	"${raw_hfps_nga2}/p2r11_sect_a_6_6d_13b_12.dta"	, clear
la li s6q11 s6q12
	
}	/*	end data inventory	*/

		*	inventory program
label_inventory `"${raw_hfps_nga1}"', pre(`"r"')	suf(`"_12.dta"') varname retain	/*vardetail varname diagnostic retain*/  
label_inventory `"${raw_hfps_nga2}"', pre(`"p2r"' )	suf(`"_12.dta"') varname retain	/*vardetail varname diagnostic retain*/  
li name-rounds if strpos(name,"s6")>0, sepby(rounds)
label_inventory `"${raw_hfps_nga1}"', pre(`"r"')	suf(`"_12.dta"') vallab retain	/*vardetail varname diagnostic retain*/  
qui : label_inventory `"${raw_hfps_nga2}"', pre(`"p2r"' )	suf(`"_12.dta"') vallab retain	/*vardetail varname diagnostic retain*/  
li lname value label rounds if strpos(lname,"s6")>0

label_inventory `"${raw_hfps_nga1}"', pre(`"r"')	suf(`"_sect_1.dta"') varname vallab 	/*vardetail varname diagnostic retain*/  
label_inventory `"${raw_hfps_nga2}"', pre(`"p2r"' )	suf(`"_sect_1.dta"') varname vallab 	/*vardetail varname diagnostic retain*/  


{	/*	track reason closed label	*/
u s6* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"		, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r1
// sa		`r1'
u s6* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r2
sa		`r2'
u s6* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r3
sa		`r3'
u s6* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r4
sa		`r4'
u s6* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r5
sa		`r5'
u s6* using	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r6
sa		`r6'
u s6* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"			, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r7
sa		`r7'
u s6* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"				, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r8
sa		`r8'
u s6* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r9
sa		`r9'
u s6* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r10
sa		`r10'
u s6* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	, clear
ds, has(varl *closed*) detail 
uselabel s6q11b, clear
tempfile r11
sa		`r11'
u s6* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"		, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r2
// sa		`r2'
u s6* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	, clear
ds, has(varl *closed*) detail 
// uselabel s6q11b, clear
// tempfile r2
// sa		`r2'
	
u `r2', clear
foreach i of numlist 2/11 {
mer 1:1 lname value label using `r`i'', gen(_`i')
recode _`i' (1 .=.)(2 3=`i')
la drop _merge
la val _`i' .
}

egen rounds = group(_? _??), label missing
ta rounds

	sort value label lname
li lname value label rounds, sepby(value)
li lname value label _*, sepby(value) nol
	}	/*	us round 9+ as the standard	*/ 

	
{	/*	track sector label across all rounds	*/
u	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"						, clear 
ds, has(varl *activity* *ACTIVITY* *Activity*) detail 
uselabel s6q5, clear
tempfile r1
sa		`r1'
u	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r2
sa		`r2'
u	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r3
sa		`r3'
u	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r4
sa		`r4'
u	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r5
sa		`r5'
u	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r6
sa		`r6'
u	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"							, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r7
sa		`r7'
u	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"								, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r8
sa		`r8'
u	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r9
sa		`r9'
u	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r10
sa		`r10'
u	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r11
sa		`r11'
u	"${raw_hfps_nga1}/r12_sect_a_12.dta"								, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r12
// sa		`r12'
u	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r13
sa		`r13'
u	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"						, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5, clear
tempfile r14
sa		`r14'
u	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b s6cq3, clear
tempfile r15
sa		`r15'
u	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r16
sa		`r16'
u	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r17
sa		`r17'
u	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r18
sa		`r18'
u	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"					, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r19
// sa		`r19'
u	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"				, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
uselabel s6q5b, clear
tempfile r20
sa		`r20'
u	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	, clear
ds, has(varl *activity* *ACTIVITY* *Activity*) detail
// uselabel s6q5, clear
// tempfile r21
// sa		`r21'

u `r1', clear
foreach i of numlist 2/11 13/18 20 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
}	/*	perfectly aligned. These will be the standard we align all others to.	*/ 

	
{	/*	track nfe_case label	*/
u	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"		, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r1
sa		`r1'
u	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"			, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r2
sa		`r2'
u	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"		, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r3
sa		`r3'
u	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r4
sa		`r4'
u	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"			, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r5
sa		`r5'
u	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"		, clear
ds, has(vall *nfe_case*)  
uselabel `r(varlist)', clear
tempfile r6
sa		`r6'
u	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"			, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r7
sa		`r7'
u	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"				, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r8
sa		`r8'
u	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r9
sa		`r9'
u	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r10
sa		`r10'
u	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	, clear
ds, has(vall *nfe_case*) 
uselabel `r(varlist)', clear
tempfile r11
sa		`r11'
u	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"		, clear
ds, has(vall *nfe_case*)  
uselabel `r(varlist)', clear
tempfile r13
sa		`r13'
u	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	, clear
ds, has(vall *nfe_case*)  
uselabel `r(varlist)', clear
tempfile r18
sa		`r18'
	
u `r1', clear
foreach i of numlist 2/11 13 18 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
keep if lname=="nfe_case"
egen matches = anycount(_? _??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	}	/*	end nfe_case investgation
		rounds 4+ dispense with a code for s6q6 respondent working
		in an NFE	*/ 


{	/*	challenges	*/
d s6q15__* using 	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
d s6q15__* using 	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
d s6q15__* using 	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"
	*	identical across rounds 
}		
}	/*	end investigation shutoff brackets	*/

#d ; 
clear; append using
	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"
	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"
	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"
	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"
	"${raw_hfps_nga1}/r6_sect_a_2_3a_6_9a_12.dta"
	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"
	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"
	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"
	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"

	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"
	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"
	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"
	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"
	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"

	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"

	"${raw_hfps_nga2}/p2r11_sect_a_6_6d_13b_12.dta"

	, gen(round);
#d cr

	la drop _append
	la val round .
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	replace round=round+1 if round>11
	replace round=round+1 if round>18
	replace round=round+2 if round>20
	isid hhid round
	sort hhid round
	assert !inlist(round,12,19,21)	//	no employment modules in these rounds

	d using "${tmp_hfps_nga}/cover.dta"
	mer 1:1 hhid round using "${tmp_hfps_nga}/cover.dta"
	ta round _m	//	perfect
	keep if _m==3
	ta s12q5
	ta s12q5 s6q1,m
ta round s6q1 if inlist(s12q5,1,2), m
	keep if inlist(s12q5,1,2)
	
	keep hhid round *_case emp_respondent s6*
	drop s6a*	//	farming items 
	drop s6q17-s6q8f_os	//	farming items 
	drop s6q2a-s6q2e	//	farming items
	drop s6b*	//	livestock items

	d *_case
	tab2 round *_case, first m
	d s6*
	ds s6*, not(type string)
	tabstat `r(varlist)', by(round) format(%12.3gc)


ta round s6q1,m 
ta s6q6 round,m
ta s6q6 s6q1, m
	
g work_cur = (s6q1==1) if inlist(s6q1,1,2)
g nwork_cur=1-work_cur
la li s6q6
recode s6q6 (4/6=1)(1 2=2)(3=3), gen(category_cur)
la def category_cur 1 "Wage" 2 "Non-farm enterprise" 3 "Family farm"
g wage_cur = (s6q1==1 & inlist(s6q6,4,5)) if inlist(s6q1,1,2)
g biz_cur  = (s6q1==1 & inlist(s6q6,1,2)) if inlist(s6q1,1,2)
g farm_cur = (s6q1==1 & inlist(s6q6,3))   if inlist(s6q1,1,2)
la var work_cur		"Respondent currently employed"
la var nwork_cur	"Respondent currently unemployed"
la var wage_cur		"Respondent mainly employed for wages"
la var biz_cur		"Respondent mainly employed in household enterprise"
la var farm_cur		"Respondent mainly employed on family farm"

*	sector
tab2 round s6q4 s6q5 s6q5b s6cq3, first m
ta s6q5 round,m
egen sector_cur = rowfirst(s6q5 s6q5b)
run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"
	ta sector_cur work_cur,m

{	/*	deal with missingness in sector	*/
bys hhid (round) : replace sector_cur = sector_cur[_n-1] if mi(sector_cur) & work_cur==1
bys hhid (round) : egen aaa = mode(sector_cur)
replace sector_cur = aaa if mi(sector_cur) & work_cur==1
bys hhid (round) : egen bbb = mode(sector_cur), minmode
replace sector_cur = bbb if mi(sector_cur) & work_cur==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
}	/*	end missingness in sector work	*/
	ta sector_cur work_cur,m
	
tabstat s6q8b s6q8b1, by(round) s(n)	//	skip codes changed between these two
egen hours_cur = rowfirst(s6q8b s6q8b1)
ta hours_cur
assert hours_cur<=168 if !mi(hours_cur)
la var hours_cur	"Hours respondent worked in current employment"


**	NFE
g nfe_round = (inrange(round,1,11) | inlist(round,13,18,23))
tab2 round s6q11 s6q11a if nfe_round==1, first m	//	s6q11 changes to continuous in round 20
ta s6q11 round if nfe_round==1,m	//	this question is not documented in r2 qx? 

*	round-specific, following Malawi 
ta s6q6 s6q11 if round==1,m
ta s6q6 s6q11 if round!=1 & nfe_round==1,m
bys nfe_round round : ta s6q6 s6q11 if nfe_round==1,m	//	no longer exclusive as of r4, but we will ignore 
bys nfe_round round : ta s6q11 s6q11a if nfe_round==1,m	//	no longer exclusive as of r4, but we will ignore 
ta s6q11 s6q11a if nfe_round==1,m

*	r1
gl r "round==1"
g		refperiod_nfe = (inlist(s6q6,1,2) | s6q11==1)  if ${r}
g 		open_nfe = (inlist(s6q6,1,2) | (s6q11==1 & inlist(s6q13,1,2,3))) if refperiod_nfe==1 & ${r} 
	*	no direct way to get at temporary vs permanent closure in round 1
g		status_nfe=1 if open_nfe==1 & ${r}==1
recode  status_nfe (.=3) if refperiod_nfe==1 & open_nfe==0
ta open_nfe refperiod_nfe if ${r}

compare s6q5 s6q12 if inlist(s6q6,1,2) & ${r}	//	substantial minority do not match
g		sector_nfe = s6q5 if s6q1==1 & inlist(s6q6,1,2) & ${r}
replace	sector_nfe = s6q12 if s6q11==1 & mi(sector_nfe) & ${r}

ta round nfe_case	//	5 cases represented, but no individual module implemented as per Malawi

*	r2-3 ->	5 nfe_case codes
gl r "inlist(round,2,3)"
g cond1 = inlist(s6q6,1,2)			if ${r}	//	same respondent, currently employed in NFE
g cond2 = s6q11a==1 & nfe_case==1	if ${r}	//	existed before prev round but closed at prev round 
g cond3 = !mi(s6q11a) & nfe_case!=1	if ${r}	//	could increase the requirement to have this inlist(nfe_case,4,5)
egen zzz = rowmax(cond?)
ta zzz round
replace	refperiod_nfe = zzz			if ${r}
drop cond? zzz 
ta refperiod_nfe round,m
ta refperiod_nfe s6q11a if ${r},m
replace	status_nfe = s6q11a			if ${r} & refperiod_nfe==1
replace	open_nfe = (status_nfe==1)	if ${r} & refperiod_nfe==1
ta round refperiod_nfe if nfe_round==1,m
ta refperiod_nfe s6q11a if nfe_round==1,m
replace	sector_nfe = s6q12		if ${r} & refperiod_nfe==1
replace	sector_nfe = s6q5		if ${r} & refperiod_nfe==1 & inlist(s6q6,1,2) & mi(sector_nfe)
bys hhid (round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & ${r}
ta sector_nfe refperiod_nfe			if ${r},m

*	r4-11 -> 3 nfe_case codes 
gl r "inrange(round,4,11)"
ta s6q6 if ${r}, m
ta s6q11a if ${r},m
ta s6q6 s6q11a if ${r},m
g cond1 = inlist(s6q6,1,2)			if ${r}	//	same respondent, currently employed in NFE
g cond2 = s6q11a==1 & nfe_case==1	if ${r}	//	existed before prev round but closed at prev round 
g cond3 = !mi(s6q11a) & nfe_case!=1	if ${r}	//	could increase the requirement to have this inlist(nfe_case,4,5)
tabstat cond?, by(round) s(n sum)
egen zzz = rowmax(cond?)
ta zzz round
replace	refperiod_nfe = zzz			if ${r}
drop cond? zzz 
ta refperiod_nfe round if nfe_round==1,m
ta refperiod_nfe s6q11a if ${r},m
replace	status_nfe = s6q11a			if ${r} & refperiod_nfe==1
replace	open_nfe = (status_nfe==1)	if ${r} & refperiod_nfe==1
ta round refperiod_nfe	if nfe_round==1,m
ta refperiod_nfe s6q11a	if nfe_round==1,m
replace	sector_nfe = s6q12		if ${r} & refperiod_nfe==1
replace	sector_nfe = s6q5		if ${r} & refperiod_nfe==1 & inlist(s6q6,1,2) & mi(sector_nfe)
bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & ${r}
ta sector_nfe refperiod_nfe			if ${r},m



*	r13, r18 
gl r "inlist(round,13)"
ta s6q6		if ${r}, m	//	
ta s6q11	if ${r},m	//	
ta s6q6 s6q11 if ${r},m	//	
gl r "inlist(round,18)"
ta s6q6		if ${r}, m	//	
ta s6q11	if ${r},m	//	
ta s6q6 s6q11 if ${r},m	//	
gl r "inlist(round,23)"
ta s6q6		if ${r}, m	//	
ta s6q11	if ${r},m	//	
ta s6q6 s6q11 if ${r},m	//	yes
gl r "inlist(round,13,18,23)"
ta s6q6		if ${r}, m	//	
ta s6q11	if ${r},m	//	
ta s6q6 s6q11 if ${r},m	//	

g cond1 = inlist(s6q6,1,2)	if ${r}	//	same respondent, currently employed in NFE
g cond2 = s6q11==1			if ${r}	//	existed before prev round but closed at prev round 

tabstat cond?, by(round) s(n sum)
egen zzz = rowmax(cond?)
ta zzz round
replace	refperiod_nfe = zzz			if ${r}
drop cond? zzz 
ta refperiod_nfe round if nfe_round==1,m
// ta refperiod_nfe s6q11a if ${r},m	//	not asked in these rounds
// replace	status_nfe = s6q11a			if ${r} & refperiod_nfe==1
// replace	open_nfe = (status_nfe==1)	if ${r} & refperiod_nfe==1
ta round refperiod_nfe	if nfe_round==1,m
ta refperiod_nfe s6q11a	if nfe_round==1,m
replace	sector_nfe = s6q12		if ${r} & refperiod_nfe==1
replace	sector_nfe = s6q5		if ${r} & refperiod_nfe==1 & inlist(s6q6,1,2) & mi(sector_nfe)
bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & ${r}
ta sector_nfe refperiod_nfe			if ${r},m



la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"

qui {	/*	deal with missingness in sector	*/

*	missingness can occur if the respondent is in the same employment as previous round
	*	put in the previous round's sector if it was non-missing 
	bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	take mode following this first round and fill in
	bys hhid (round) : egen aaa = mode(sector_nfe)
	replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	fill in with the solve ties moving away from sector 9 if there are alternatives
	bys hhid (round) : egen bbb = mode(sector_nfe), minmode
	replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
	}	/*	end missingness in sector	*/

ta sector_nfe refperiod_nfe if nfe_round==1,m
ta round if !mi(sector_nfe) & mi(refperiod_nfe)

*	currently operational->	only rounds 2-11
run "${do_hfps_util}/label_status_nfe.do" 
la val status_nfe status_nfe
la var status_nfe	"Current operational status of NFE"
la var open_nfe		"NFE is currently open"

ta refperiod_nfe status_nfe if nfe_round==1,m
ta round if mi(refperiod_nfe) & nfe_round==1

*	revenue
ta s6q13 round
g revenue_lbl_nfe = .
la var revenue_lbl_nfe		"Revenue was [...] compared to last month"
numlabel s6q13, remove
la li s6q13
foreach i of numlist 1/4 {
	loc v s6q13
	g revenue`i'_nfe = (`v'==1) if !mi(`v')
}
la var revenue1_nfe		"Higher"
la var revenue2_nfe		"The same"
la var revenue3_nfe		"Lower"
la var revenue4_nfe		"No revenue from sales"

*	events experienced
d s6q14__* 
tabstat s6q14__* if nfe_round==1, by(round)	//	verified that this is only in round 18
egen xx = rowmax(s6q14__1-s6q14__96)
ta xx s6q14__9	//	good 
drop xx
g event_lbl_nfe =.
la var event_lbl_nfe	"Events experienced by NFE"
foreach i of numlist 1/9 96 {
	loc v s6q14__`i'
	g event`i'_nfe = (`v'==1) if !mi(`v') 
	loc lbl = subinstr("`: var lab `v''","Events experienced:","",1)
	la var event`i'_nfe	"`lbl'"
}

*	challenges faced
d s6q15__*
tabstat s6q15__*, by(round)
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/6 96	{
	loc v s6q15__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
}
la var challenge1_nfe	"Buying and receiving supplies and inputs"
la var challenge2_nfe	"Raising money for the business"
la var challenge3_nfe	"Repaying loans or other debt obligations"
la var challenge4_nfe	"Paying rent for business location"
la var challenge5_nfe	"Paying workers"
la var challenge6_nfe	"Selling goods or services to customers"
tabstat challenge*_nfe, by(round) s(n sum)

*	closed why
d s6q11b
ta s6q11b round, m	//	labels undocumented for 11 12 13
g closed_why_nfe = s6q11b
run "${do_hfps_util}/label_closed_why_nfe.do"
ta closed_why_nfe round

tab2 round s6*q13, first


*	respondent where available 
d using  "${tmp_hfps_nga}/ind.dta"
g indiv = emp_respondent
mer m:1 hhid indiv round using "${tmp_hfps_nga}/ind.dta", keep(1 3)
ta round _m, nol
ta respond if _m==3,m	//	99% same person 
g emp_resp_main = respond
foreach x in sex age head relation {
g emp_resp_`x' = `x' 
}
drop indiv-_merge
order emp_resp_*, a(emp_respondent)
la var emp_resp_main		"Employment respondent = primary respondent"
la var emp_resp_sex			"Sex of employment respondent"
la var emp_resp_age			"Age of employment respondent"
la var emp_resp_head		"Employment respondent is head"
la var emp_resp_relation	"Employment respondent relationship to household head"

d *_cur *_nfe
keep hhid round *_cur *_nfe emp_resp*
isid hhid round
sort hhid round
sa "${tmp_hfps_nga}/employment.dta", replace 


ex 	
dir "${tmp_hfps_nga}/panel"
u  "${tmp_hfps_nga}/employment.dta", clear 




















	*	previous employment, just has reference in first round 
	*	in principle, this is fine to just carry forward, though should be linked to roster to be sure at individual level
	*	at household level though, reasonable to carry forward I think in principle
d s6q2 s6q9a s6q9b s6q9c s6q9d
tab2 round s6q2 s6q9a s6q9b s6q9c s6q9d, first m	

ta s6q2 s6q1, m	//	s6q2 is only populated for s6q1==2 
ta s6q2 s6q3, m
// bys hhid (round) : egen work_pre = max(s6q2==1)
// ta work_pre s6q9d,m

*	sector
tab2 round s6q4 s6q5 s6q5b s6cq3, first m
la li s6q5 s6q5b s6cq3
egen work_cur_act = rowfirst(s6q5 s6cq3)
la copy s6q5 work_cur_act
la val work_cur_act work_cur_act
la var work_cur_act	"Sector of current work" 


*	type
tab2 round s6q6, first m
la li s6q6	//	these are a mix of non-farm enterprise, farm labor, and employment 
la copy s6q6 work_cur_status
g work_cur_status = s6q6 if inlist(s6q6,4,5,6)
la val work_cur_status work_cur_status
la var work_cur_status	"Type of current work" 



*************************
*	business
*************************
ta s6q6 s6q1, m
g biz_main = inlist(s6q6,1,2) if s6q1==1
la var biz_main	"Household mainly operated a business in last two months"
ta biz_main s6q11 if round!=20, m
ta biz_main s6q11a, m
ta round if !mi(s6q11c)

ta round s11qa,m
g biz_oper = s6q11a
la var biz_oper	"Current status of household business"
la copy s6q11a biz_oper
la val biz_oper biz_oper 



ta round s6q8, m

*************************
*	farm employment
*************************
ta round s6q6a,m


sa "${tmp_hfps_nga}/employment.dta", replace 
u  "${tmp_hfps_nga}/employment.dta", clear 

ex
*	modifications for construction of grand panel 
u "${tmp_hfps_nga}/cover.dta", clear

egen pnl_hhid = group(hhid)
li zone state lga sector ea in 1/10
li zone state lga sector ea in 1/10, nol
egen pnl_admin1 = group(zone)
egen pnl_admin2 = group(zone state)
egen pnl_admin3 = group(zone state lga)

g pnl_urban = (sector==1)
g pnl_wgt = wgt 

sa "${tmp_hfps_nga}/pnl_cover.dta", replace 







