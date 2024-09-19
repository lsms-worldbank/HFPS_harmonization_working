
loc investigation=0
if `investigation'==1	{	/*	shutoff bracket to skip investigation work if we just desire to reset the data	*/


{	/*	data inventory	*/
dir "${raw_hfps_mwi}", w
dir "${raw_hfps_mwi}/*employment*", w
dir "${raw_hfps_mwi}/*nfe*", w

d using	"${raw_hfps_mwi}/sect6_employment_r1.dta"
d using	"${raw_hfps_mwi}/sect6a_employment1_r2.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r2.dta"
d using	"${raw_hfps_mwi}/sect6a_employment1_r3.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r3.dta"
d using	"${raw_hfps_mwi}/sect6a_employment1_r4.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r4.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r5.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r6.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r7.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r8.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r9.dta"
// d using	"${raw_hfps_mwi}/sect6a_employment_r10.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r11.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r12.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r13.dta"
d using	"${raw_hfps_mwi}/sect6a_employment2_r14.dta"
// d using	"${raw_hfps_mwi}/sect6a_employment_r15.dta"
d using	"${raw_hfps_mwi}/sect6_employment_r16.dta"
d using	"${raw_hfps_mwi}/sect6_employment_r17.dta"
d using	"${raw_hfps_mwi}/sect6_employment_r18.dta"
d using	"${raw_hfps_mwi}/sect6_employment_r19.dta"
d using	"${raw_hfps_mwi}/sect6_employment_r20.dta"

*	non-farm enterprise 
d using	"${raw_hfps_mwi}/sect6b_nfe_r2.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r3.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r4.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r5.dta"
// d using	"${raw_hfps_mwi}/sect6b_nfe_r6.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r7.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r8.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r9.dta"
// d using	"${raw_hfps_mwi}/sect6b_nfe_r10.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r11.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r12.dta"
d using	"${raw_hfps_mwi}/sect6b_nfe_r20.dta"

*	how to deal with the split modules in r2-4

d using	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", si
d using	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", si
}	/*	end data inventory	*/


{	/*	check s6q5 sector labels	*/
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
la dir
uselabel `r(names)', clear
tempfile r1
sa		`r1'
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
la dir
uselabel `r(names)', clear
tempfile r2a
sa		`r2a'
u	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", clear
la dir
uselabel `r(names)', clear
tempfile r2b
sa		`r2b'
u	"${raw_hfps_mwi}/sect6a_employment1_r3.dta", clear
la dir
uselabel `r(names)', clear
tempfile r3a
sa		`r3a'
u	"${raw_hfps_mwi}/sect6a_employment2_r3.dta", clear
la dir
uselabel `r(names)', clear
tempfile r3b
sa		`r3b'
u	"${raw_hfps_mwi}/sect6a_employment1_r4.dta", clear
la dir
uselabel `r(names)', clear
tempfile r4a
sa		`r4a'
u	"${raw_hfps_mwi}/sect6a_employment2_r4.dta", clear
la dir
uselabel `r(names)', clear
tempfile r4b
sa		`r4b'
u	"${raw_hfps_mwi}/sect6a_employment2_r5.dta", clear
la dir
uselabel `r(names)', clear
tempfile r5
sa		`r5'
u	"${raw_hfps_mwi}/sect6a_employment2_r6.dta", clear
la dir
uselabel `r(names)', clear
tempfile r6
sa		`r6'
u	"${raw_hfps_mwi}/sect6a_employment2_r7.dta", clear
la dir
uselabel `r(names)', clear
tempfile r7
sa		`r7'
u	"${raw_hfps_mwi}/sect6a_employment2_r8.dta", clear
la dir
uselabel `r(names)', clear
tempfile r8
sa		`r8'
u	"${raw_hfps_mwi}/sect6a_employment2_r9.dta", clear
la dir
uselabel `r(names)', clear
tempfile r9
sa		`r9'
u	"${raw_hfps_mwi}/sect6a_employment2_r11.dta", clear
la dir
uselabel `r(names)', clear
tempfile r11
sa		`r11'
u	"${raw_hfps_mwi}/sect6a_employment2_r12.dta", clear
la dir
uselabel `r(names)', clear
tempfile r12
sa		`r12'
u	"${raw_hfps_mwi}/sect6a_employment2_r13.dta", clear
la dir
uselabel `r(names)', clear
tempfile r13
sa		`r13'
u	"${raw_hfps_mwi}/sect6a_employment2_r14.dta", clear
la dir
uselabel `r(names)', clear
tempfile r14
sa		`r14'
u	"${raw_hfps_mwi}/sect6_employment_r16.dta", clear	//	none
la dir
uselabel `r(names)', clear
u	"${raw_hfps_mwi}/sect6_employment_r17.dta", clear	//	none
la dir
uselabel `r(names)', clear
u	"${raw_hfps_mwi}/sect6_employment_r18.dta", clear
la dir
uselabel `r(names)', clear
tempfile r18
sa		`r18'
u	"${raw_hfps_mwi}/sect6_employment_r19.dta", clear
la dir
uselabel `r(names)', clear
tempfile r18
sa		`r18'

u `r1', clear
foreach i in 1 2a 2b 3a 3b 4a 4b 5 6 7 8 9 11 12 13 14 {
mer 1:1 lname value label using `r`i'', gen(_r`i')
recode _r`i' (1 .=.)(2 3=1)
la val _r`i' .
}
egen rounds = group(_r*), missing label
ta rounds

sort lname value label
li lname value label rounds if inlist, sepby(value)
li lname value label _*, sepby(value) nol
}	/*	end s6q5 investigation	*/


{	/*	check s6q6 employer type labels 	*/
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
uselabel s6q6, clear
tempfile r1
sa		`r1'
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
ta s6q6_1,m
uselabel s6q6_1, clear
tempfile r2a
sa		`r2a'
u	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", clear
uselabel s6q6, clear
tempfile r2b
sa		`r2b'
u	"${raw_hfps_mwi}/sect6a_employment1_r3.dta", clear
uselabel s6q6_1, clear
tempfile r3a
sa		`r3a'
u	"${raw_hfps_mwi}/sect6a_employment2_r3.dta", clear
uselabel s6q6, clear
tempfile r3b
sa		`r3b'
u	"${raw_hfps_mwi}/sect6a_employment1_r4.dta", clear
uselabel s6q6_1, clear
tempfile r4a
sa		`r4a'
u	"${raw_hfps_mwi}/sect6a_employment2_r4.dta", clear
uselabel s6q6, clear
tempfile r4b
sa		`r4b'
u	"${raw_hfps_mwi}/sect6a_employment2_r5.dta", clear
uselabel s6q6, clear
tempfile r5
sa		`r5'
u	"${raw_hfps_mwi}/sect6a_employment2_r6.dta", clear
uselabel s6q6, clear
tempfile r6
sa		`r6'
u	"${raw_hfps_mwi}/sect6a_employment2_r7.dta", clear
uselabel s6q6, clear
tempfile r7
sa		`r7'
u	"${raw_hfps_mwi}/sect6a_employment2_r8.dta", clear
uselabel s6q6, clear
tempfile r8
sa		`r8'
u	"${raw_hfps_mwi}/sect6a_employment2_r9.dta", clear
uselabel s6q6, clear
tempfile r9
sa		`r9'
u	"${raw_hfps_mwi}/sect6a_employment2_r11.dta", clear
uselabel s6q6, clear
tempfile r11
sa		`r11'
u	"${raw_hfps_mwi}/sect6a_employment2_r12.dta", clear
uselabel s6q6, clear
tempfile r12
sa		`r12'
u	"${raw_hfps_mwi}/sect6a_employment2_r13.dta", clear
uselabel s6q6, clear
tempfile r13
sa		`r13'
u	"${raw_hfps_mwi}/sect6a_employment2_r14.dta", clear
uselabel s6q6, clear
tempfile r14
sa		`r14'
u	"${raw_hfps_mwi}/sect6_employment_r16.dta", clear	//	none
uselabel s6q1_1, clear
tempfile r16
sa		`r16'
u	"${raw_hfps_mwi}/sect6_employment_r17.dta", clear	//	none
uselabel s6q1_1, clear
tempfile r17
sa		`r17'
u	"${raw_hfps_mwi}/sect6_employment_r18.dta", clear
uselabel s6q6, clear
tempfile r18
sa		`r18'
u	"${raw_hfps_mwi}/sect6_employment_r19.dta", clear
uselabel s6q6, clear
tempfile r19
sa		`r19'

u `r1', clear
foreach i in 2a 2b 3a 3b 4a 4b 5 6 7 8 9 11 12 13 14 16 17 18 19 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol

}	/*	end s6q6 label work	*/


{	/*	all employment module value labels */
preserve
qui {
	loc files : dir "${raw_hfps_mwi}" files "sect6*employment*.dta" 
	dis `"`files'"'
	dis `: word count "`files'"'
	loc stubs=subinstr(subinstr(subinstr(`"`files'"',"sect","s",.),"_employment","",.),".dta","",.)
	dis `"`stubs'"'
forv r=1/`: word count "`files'"' {
	loc file : word `r' of `files'
	dis "`r'", _cont
	dis "`file'"
	if length("`file'")>0 {
	u "${raw_hfps_mwi}/`file'", clear
	la dir 
	uselabel `r(labels)', clear var
	tempfile r`r'
	sa		`r`r''
	}
	else continue, break
}
dis as yellow "stage 1 complete"
u `r1', clear
cap : la drop round
forv r=1/`: word count "`files'"' {
	dis "`r'"
	loc stub : word `r' of `stubs'
	if length("`stub'")>0 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	la def round `r' "`stub'", add
	}
	else continue, break
}
la li round 
la val _? _?? round
egen rounds = group(_? _??), label missing
}
li lname value label rounds, sepby(lname)
restore
}


{	/*	all NFE module value labels */
preserve
qui {
foreach r of numlist 2/4 7/9 11 12 20 {
	u "${raw_hfps_mwi}/sect6b_nfe_r`r'.dta", clear
	la dir 
	uselabel `r(labels)', clear var
	tempfile r`r'
	sa		`r`r''
}
u `r2', clear
foreach r of numlist 2/4 7/9 11 12 20 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
}
egen rounds = group(_? _??), label missing
}
li lname value label rounds, sepby(lname)
restore
}



{	/*	all employment module variable labels */
preserve
qui {
	loc files : dir "${raw_hfps_mwi}" files "sect6*employment*.dta" 
	dis `"`files'"'
	dis `: word count "`files'"'
	loc stubs=subinstr(subinstr(subinstr(`"`files'"',"sect","s",.),"_employment","",.),".dta","",.)
	dis `"`stubs'"'
forv r=1/`: word count "`files'"' {
	loc file : word `r' of `files'
	dis "`r'", _cont
	dis "`file'"
	if length("`file'")>0 {
	u "${raw_hfps_mwi}/`file'", clear
	d, replace clear
	tempfile r`r'
	sa		`r`r''
	}
	else continue, break
}
dis as yellow "stage 1 complete"
u `r1', clear
cap : la drop round
forv r=1/`: word count "`files'"' {
	dis "`r'"
	loc stub : word `r' of `stubs'
	if length("`stub'")>0 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	la def round `r' "`stub'", add
	}
	else continue, break
}
la li round 
la val _? _?? round
egen rounds = group(_? _??), label missing
}
egen 
sort name varlab
li name varlab rounds, sep(0) str(100)
restore
}


{	/*	all NFE module value labels */
preserve
qui {
foreach r of numlist 2/4 7/9 11 12 20 {
	u "${raw_hfps_mwi}/sect6b_nfe_r`r'.dta", clear
	la dir 
	uselabel `r(labels)', clear var
	tempfile r`r'
	sa		`r`r''
}
u `r2', clear
foreach r of numlist 2/4 7/9 11 12 20 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
}
egen rounds = group(_? _??), label missing
}
li lname value label rounds, sepby(lname)
restore
}


*	will implement this here as a one-off 
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
la li s6q5
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
la li s6q5_1
recode s6q5_1 (1 15=1)(2 3=2)(5=3)(6=4)(7=6)(8 14=5)(9=7)(10/12=9)(13 16 96=8), gen(emp_sector)

u	"${raw_hfps_mwi}/sect6a_employment2_r13.dta", clear
la li s6q5b	//	this is reconciled with the 9-code NGA codes



{	/*	reason stopped working	*/
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
ds , has(varl "*reason you stopped working*") detail
uselabel s6q3a, clear
tempfile r1
sa		`r1'
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
ds , has(varl "*reason you stopped working*") detail
uselabel s6q3a_1, clear
tempfile r2a
sa		`r2a'
u	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r2b
sa		`r2b'
u	"${raw_hfps_mwi}/sect6a_employment1_r3.dta", clear
ds , has(varl "*reason you stopped working*") detail
uselabel s6q3a_1, clear
tempfile r3a
sa		`r3a'
u	"${raw_hfps_mwi}/sect6a_employment2_r3.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r3b
sa		`r3b'
u	"${raw_hfps_mwi}/sect6a_employment1_r4.dta", clear
ds , has(varl "*reason you stopped working*") detail
uselabel s6q3a_1, clear
tempfile r4a
sa		`r4a'
u	"${raw_hfps_mwi}/sect6a_employment2_r4.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r4b
sa		`r4b'
u	"${raw_hfps_mwi}/sect6a_employment2_r5.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r5
sa		`r5'
u	"${raw_hfps_mwi}/sect6a_employment2_r6.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r6
sa		`r6'
u	"${raw_hfps_mwi}/sect6a_employment2_r7.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r7
sa		`r7'
u	"${raw_hfps_mwi}/sect6a_employment2_r8.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r8
sa		`r8'
u	"${raw_hfps_mwi}/sect6a_employment2_r9.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r9
sa		`r9'
u	"${raw_hfps_mwi}/sect6a_employment2_r11.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r11
sa		`r11'
u	"${raw_hfps_mwi}/sect6a_employment2_r12.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r12
sa		`r12'
u	"${raw_hfps_mwi}/sect6a_employment2_r13.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r13
sa		`r13'
u	"${raw_hfps_mwi}/sect6a_employment2_r14.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r14
sa		`r14'
u	"${raw_hfps_mwi}/sect6_employment_r18.dta", clear
ds , has(varl "*reason you stopped working*") detail
// uselabel s6q3a, clear
ds , has(varl "Why did you not work last week*") detail
d `r(varlist)', replace clear
tempfile r18
sa		`r18'

*	single select results
u `r1', clear
foreach i in 2a 3a 4a {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_?a), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol

*	multi select results
qui {
u `r2b', clear
foreach i in 3b 4b 5 6 7 8 9 11 12 13 14 18 {
mer 1:1 name varlab using `r`i'', gen(_`i')
}
egen matches = anycount(_? _?b), v(3)
ta matches
}
sort name varlab
li name varlab matches, sep(0)
}	/*	end reasons not worked investigation	*/


*	different refperiod_nfe/status_nfe structures in different rounds 
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
ta s6q6 s6q9,m
table (s6q6 s6q9) s6q11, m
g refperiod_nfe = (inlist(s6q6,1,2) | s6q11==1)
tab2 s6q12 s6q11 s6q6,m first
ta s6q11 s6q9,m

g open_nfe1 = (inlist(s6q6,1,2))
g open_nfe2 = inlist(s6q13,1,2) | (s6q13==3 & !inlist(s6q14,1,2,3)) if s6q11==1

ta open_nfe1 open_nfe2,m
egen open_nfe = rowmax(open_nfe1 open_nfe2)
ta s6q12 open_nfe,m

ta s6q5 s6q12 if !mi(open_nfe)	//	prefer s6q12 sector


u	"${raw_hfps_mwi}/sect6b_nfe_r2.dta", clear
ta s6bq11,m
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
ta s6q6_1 s6q7_1,m	//	very few
ta s6q1_1 s6q6_1,m
u	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", clear


*	how to deal with the split modules in r2-4

d using	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", si
d using	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", si


}	/*	close brackets for preamble	*/


#d ; 
forv r=2/4 {;
	u "${raw_hfps_mwi}/sect6a_employment1_r`r'.dta", clear;
	mer 1:1 y4_hhid using "${raw_hfps_mwi}/sect6a_employment2_r`r'.dta", assert(3) nogen;
	mer 1:1 y4_hhid using "${raw_hfps_mwi}/sect6b_nfe_r`r'.dta", assert(3) nogen;
	tempfile r`r';
	sa `r`r'';
};
foreach r of numlist 5 7/9 11 12 {; 
	u "${raw_hfps_mwi}/sect6a_employment2_r`r'.dta", clear;
	mer 1:1 y4_hhid using "${raw_hfps_mwi}/sect6b_nfe_r`r'.dta", assert(3) nogen;
	tempfile r`r';
	sa `r`r'';
};
clear; append using
	"${raw_hfps_mwi}/sect6_employment_r1.dta"
	`r2'
	`r3'
	`r4'
	`r5'
	"${raw_hfps_mwi}/sect6a_employment2_r6.dta"
	`r7'
	`r8'
	`r9'

	`r11'
	`r12'
	"${raw_hfps_mwi}/sect6a_employment2_r13.dta"
	"${raw_hfps_mwi}/sect6a_employment2_r14.dta"

	"${raw_hfps_mwi}/sect6_employment_r16.dta"
	"${raw_hfps_mwi}/sect6_employment_r17.dta"
	"${raw_hfps_mwi}/sect6_employment_r18.dta"
	"${raw_hfps_mwi}/sect6_employment_r19.dta"
	"${raw_hfps_mwi}/sect6b_nfe_r20.dta"
, gen(round);
#d cr 
isid y4 round
la drop _append
la val round 
ta round 
replace round=round+1 if round>9
replace round=round+1 if round>14
ta round
	la var round	"Survey round"

	
	tab2 round *_case, first m
d
drop s6q10b__*	//	dropping a few things we don't plan to use 
preserve
d, replace clear
li pos name vallab varlab if isnumeric==1, sep(0)
restore

ds s6*, not(type string)
tabstat `r(varlist)', by(round) s(n)

ta round s6q1,m 
ta s6q6 round,m
ta s6q6 s6q1, m
	
	ta round if !mi(s6q1_1)
	ta s6q1_1 s6q1,m
	ta round if !inlist(s6q1_1,1,2,.)
	
g work_cur = (s6q1==1) if inlist(s6q1,1,2)
replace work_cur = (s6q1_1==1) if mi(s6q1) & !mi(s6q1_1) & inrange(round,2,4)
g nwork_cur=1-work_cur

	tab2 round s6q6 s6q6_1, first m
	ta s6q6_1 round,m
	ta s6q1 s6q6,m
	ta round if s6q6==6
g		wage_cur = (s6q1==1 & inlist(s6q6,4)) if inlist(s6q1,1,2)
recode	wage_cur (0=1) if s6q1==1 & s6q6==5 & inrange(round,13,19)
recode	wage_cur (0=1) if s6q1_1==1 & s6q6_1==4 & inrange(round,2,4)
recode	wage_cur (0=1) if s6q1_1==1 & s6q6_1==6 & round==4	//	one-off Ganyu code in r4 only 
recode	wage_cur (0=1) if s6q1==1 & s6q1_1==4 & inrange(round,16,17)
g		biz_cur  = (s6q1==1 & inlist(s6q6,1,2)) if inlist(s6q1,1,2)
recode	biz_cur (0=1) if s6q1_1==1 & inlist(s6q6_1,1,2) & inrange(round,2,4)
recode	biz_cur (0=1) if s6q1==1 & inlist(s6q1_1,1,2) & inrange(round,16,17)
g		farm_cur = (s6q1==1 & inlist(s6q6,3))   if inlist(s6q1,1,2)
recode	farm_cur (0=1) if s6q1_1==1 & s6q6_1==3 & inrange(round,2,4)
recode	farm_cur (0=1) if s6q1==1 & inlist(s6q1_1,3) & inrange(round,16,17)
la var	work_cur	"Respondent currently employed"
la var	nwork_cur	"Respondent currently unemployed"
la var	wage_cur	"Respondent mainly employed for wages"
la var	biz_cur		"Respondent mainly employed in household enterprise"
la var	farm_cur	"Respondent mainly employed on family farm"
	
	tabstat *_cur, by(round) s(n sum) 
// 	recode wage_cur biz_cur farm_cur (0=.) if inlist(round,16,17)
	tabstat *_cur, by(round) s(n sum) 
	
/*	reason for stopping working
d s6q3a
ds , has(varl "*reason you stopped working*") detail
tabstat `r(varlist)', by(round) s(n)
la li s6q3a s6q3a_1	
tab2 round s6q3a s6q3a_1, first
ds , has(varl "Why did you not work last week*") detail
tabstat `r(varlist)', by(round) s(n)
la li s6q1c 	//	4 add'l codes were added 
ta round if !mi(s6q1c)

foreach i of numlist 1/13 96 {
	egen nwork_why_`i'_cur = rowmax(s6q1c__`i' s6q3__`i')
	replace nwork_why_`i'_cur = (s6q1c==`i') if inlist(round,13,14,18) & !mi(s6q1c)
	if `i'!=13 {
	replace nwork_why_`i'_cur = (s6q3a==`i') if inlist(round,1) & !mi(s6q3a)
	}
	}
forv i=14/18 { 
	g nwork_why_`i'_cur = (s6q1c==`i') if inlist(round,13,14,18) & !mi(s6q1c)
}

g		nwork_why_lab_cur=.
la var	nwork_why_lab_cur	"Not working currently because [...]"
foreach i of numlist 1/18 96 {
	loc lbl = strupper(substr("`: label s6q1c `i''",1,1)) + strlower(substr("`: label s6q1c `i''",2,length("`: label s6q1c `i''")-1))
	la var nwork_why_`i'_cur	"`lbl'"
}
*/
	
*	sector
d s6q5*
la li  s6q5 s6q4c_1 s6q5_1 s6q5b	//	investigation above reveals that codes do not overlap within each set across rounds, so a simple recode is fine 
tab2 round s6q5 s6q5_1 s6q5b , first m
tab2 round s6q5 s6q5_1 s6q5b , first 

recode s6q5		(1 15=1)(2 3=2)(5=3)(6=4)(7=6)(8 14=5)(4 9=7)(10/12 16 96=9)(13=8), gen(sctr1)
recode s6q5_1	(1 15=1)(2 3=2)(5=3)(6=4)(7=6)(8 14=5)(4 9=7)(10/12 16 96=9)(13=8), gen(sctr2)
tab2 round sctr1 sctr2 s6q5b, first

//  s6q5b codes match standard 9 code structure 
egen sector_cur = rowfirst(sctr1 sctr2 s6q5b)
run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur emp_sector
ta sector_cur round, m
ta sector_cur work_cur,m
*	hours
ds, has(varl *hour* *HOUR* *Hour*) detail 
ta work_cur sector_cur,m


d s6q8b1
g hours_cur = s6q8b1
la var hours_cur	"Hours respondent worked in current employment"
tabstat hours_cur, by(work_cur) s(n)

*	NFE
g nfe_round = inrange(round,1,5) | inrange(round,7,9) | inrange(round,11,12)
ta s6q6 round,m

*	just go round by round, expand to add'l rounds as possible
tab2 round s6q6 s6q11 s6bq11 if nfe_round==1, first m
*	r1	
g		refperiod_nfe = (s6q1==1 & inlist(s6q6,1,2)) | s6q11==1 if round==1
g		open_nfe = (s6q1==1 & inlist(s6q6,1,2)) | (s6q11==1 & inlist(s6q13,1,2,3)) if refperiod_nfe==1 & round==1
	*	no direct way to get at temporary vs permanent closure 
g		status_nfe=1 if open_nfe==1 & round==1
recode  status_nfe (.=3) if refperiod_nfe==1 & open_nfe==0
ta open_nfe refperiod_nfe if round==1

compare s6q5 s6q12 if inlist(s6q6,1,2) & round==1	//	most match, but not all
g		sector_nfe = s6q5 if s6q1==1 & inlist(s6q6,1,2) & round==1
replace	sector_nfe = s6q12 if s6q11==1 & mi(sector_nfe) & round==1


*	r2-r4 have a consistent structure 
ta s6q6_1 s6q6 if round==2,m
ta round s6q6_1,m

assert mi(s6q6_1,s6q6)	//	either one or both are always missing, regardless of round
*	refperiod conditions
	*	these conditions 1-5 do not equate directly to cases 1-5 in the qx 
g cond1 = inlist(s6q6_1,1,2) if inrange(round,2,4)	//	different respondent, currently employed in NFE
g cond2 = inlist(s6q6  ,1,2) if inrange(round,2,4)	//	same respondent, currently employed in NFE
g cond3	= s6bq11a_1==1 if inrange(round,2,4)		//	respondent not currently employed, but a pre-existing business or business that existed but with no income in previous round is now open 
g cond4	= !mi(s6bq11a_2) if inrange(round,2,4)		//	business was operational in previous round
g cond5	= !mi(s6bq11a_3) if inrange(round,2,4)		//	newly operational business as identified in cond1, cond2, or s5q11==1
egen zzz = rowmax(cond?)
ta zzz round
replace	refperiod_nfe = zzz if inrange(round,2,4)
drop cond? zzz 

tabstat s6bq11a_? if inrange(round,2,4), by(refperiod_nfe) m s(n sum)
egen zzz = rowmin(s6bq11a_?)
ta zzz refperiod_nfe if inrange(round,2,4),m
tabstat s6bq11a_? if zzz!=. & refperiod_nfe==0 & inrange(round,2,4)

replace	status_nfe = zzz if refperiod_nfe==1 & inrange(round,2,4)
drop zzz
recode	status_nfe (.=1) if (inlist(s6q6_1,1,2) | inlist(s6q6,1,2)) & inrange(round,2,4)

ta status_nfe refperiod_nfe if inrange(round,2,4),m
replace	open_nfe = (status_nfe==1) if refperiod_nfe==1 & inrange(round,2,4)


compare s6q5 s6q12 if refperiod_nfe==1 & inrange(round,2,4)
ta s6qb12 refperiod_nfe if inrange(round,2,4)
replace	sector_nfe = s6qb12	if refperiod_nfe==1 & inrange(round,2,4)
replace	sector_nfe = s6q5 	if inlist(s6q6  ,1,2) & mi(sector_nfe) & refperiod_nfe==1 & inrange(round,2,4)
replace	sector_nfe = s6q5_1	if inlist(s6q6_1,1,2) & mi(sector_nfe) & refperiod_nfe==1 & inrange(round,2,4)
bys y4 (round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & inrange(round,2,4)
ta sector_nfe refperiod_nfe if round==1,m
ta sector_nfe refperiod_nfe if round==2,m
ta sector_nfe refperiod_nfe if round==3,m
ta sector_nfe refperiod_nfe if round==4,m

	*	syntax to deal with missingness still needed

*	r5 dispenses with split modules for old vs new respondents 
	*	did include a module for asking individual level emplyoment information, but we ignore this for harmonization purposes here 
gl round "inlist(round,5)"
ta s6q5 s6q6 if ${round},m
*	refperiod conditions
	*	these conditions 1-5 do not equate directly to cases 1-5 in the qx 
g cond2 = inlist(s6q6,1,2)	if ${round}	//	respondent currently employed in NFE
g cond3	= s6bq11a_1==1		if ${round}	//	respondent not currently employed, but a pre-existing business or business that existed but with no income in previous round is now open 
g cond4	= !mi(s6bq11a_2)	if ${round}	//	business was operational in previous round
g cond5	= !mi(s6bq11a_3)	if ${round}	//	newly operational business as identified in cond1, cond2, or s5q11==1
egen zzz = rowmax(cond?)
ta zzz round,m
replace	refperiod_nfe = zzz if ${round}
drop cond? zzz 

tabstat s6bq11a_? if ${round}, by(refperiod_nfe) m s(n sum)
egen zzz = rowmin(s6bq11a_?)
ta zzz refperiod_nfe if ${round},m
tabstat s6bq11a_? if zzz!=. & refperiod_nfe==0 & ${round}

replace	status_nfe = zzz if refperiod_nfe==1 & ${round}
drop zzz
recode	status_nfe (.=1) if inlist(s6q6,1,2) & ${round}

ta status_nfe refperiod_nfe if ${round},m
replace	open_nfe = (status_nfe==1) if refperiod_nfe==1 & ${round}


compare s6q5 s6qb12 if refperiod_nfe==1 & ${round}
ta s6qb12 refperiod_nfe if ${round}
replace	sector_nfe = s6qb12	if refperiod_nfe==1 & ${round}
replace	sector_nfe = s6q5 	if inlist(s6q6  ,1,2) & mi(sector_nfe) & refperiod_nfe==1 & ${round}
bys y4 (round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & ${round}
ta sector_nfe refperiod_nfe if ${round},m	//	still 12 cases 



*	r6 no NFE 
*	r7-9 & 11-12 NFE are stable in the vars we are interested about
gl round "inlist(round,7,8,9,11,12)"
ta s6q5 s6q6 if ${round},m
*	refperiod conditions
	*	these conditions 1-5 do not equate directly to cases 1-5 in the qx 
g cond2 = inlist(s6q6,1,2)	if ${round}	//	respondent currently employed in NFE
g cond3	= s6bq11a_1==1		if ${round}	//	respondent not currently employed, but a pre-existing business or business that existed but with no income in previous round is now open 
g cond4	= !mi(s6bq11a_2)	if ${round}	//	business was operational in previous round
g cond5	= !mi(s6bq11a_3)	if ${round}	//	newly operational business as identified in cond1, cond2, or s5q11==1
egen zzz = rowmax(cond?)
ta zzz round,m
replace	refperiod_nfe = zzz if ${round}
drop cond? zzz 

tabstat s6bq11a_? if ${round}, by(refperiod_nfe) m s(n sum)
egen zzz = rowmin(s6bq11a_?)
ta zzz refperiod_nfe if ${round},m
tabstat s6bq11a_? if zzz!=. & refperiod_nfe==0 & ${round}

replace	status_nfe = zzz if refperiod_nfe==1 & ${round}
drop zzz
recode	status_nfe (.=1) if inlist(s6q6,1,2) & ${round}

ta status_nfe refperiod_nfe if ${round},m
replace	open_nfe = (status_nfe==1) if refperiod_nfe==1 & ${round}


compare s6q5 s6qb12 if refperiod_nfe==1 & ${round}
ta s6qb12 refperiod_nfe if ${round}
replace	sector_nfe = s6qb12	if refperiod_nfe==1 & ${round}
replace	sector_nfe = s6q5 	if inlist(s6q6  ,1,2) & mi(sector_nfe) & refperiod_nfe==1 & ${round}
bys y4 (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & ${round} & nfe_round==1
ta sector_nfe refperiod_nfe if ${round},m	//	slight change to sort in preceding line deals with several, but more is needed  

la var refperiod_nfe	"Household operated a non-farm enterprise (NFE) since previous contact"
run "${do_hfps_util}/label_status_nfe.do" 
la val status_nfe status_nfe
la var status_nfe		"Current operational status of NFE"
la var open_nfe		"NFE is currently open"

recode sector_nfe (1 15=1)(2 3=2)(5=3)(6=4)(7=6)(8 14=5)(9=7)(10/12=9)(13 16 96=8)(.a=.)
la val sector_nfe emp_sector	//	already defined above 
la var sector_nfe	"Sector of NFE"
ta sector_nfe round if nfe_round==1,m
ta sector_nfe refperiod_nfe if nfe_round==1,m

qui {	/*	deal with missingness in sector	*/

*	missingness can occur if the respondent is in the same employment as previous round
	*	put in the previous round's sector if it was non-missing 
	bys y4_hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	take mode following this first round and fill in
	bys y4_hhid (round) : egen aaa = mode(sector_nfe)
	replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	fill in with the solve ties moving away from sector 9 if there are alternatives
	bys y4_hhid (round) : egen bbb = mode(sector_nfe), minmode
	replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
	}	/*	end missingness in sector	*/

ta sector_nfe refperiod_nfe if nfe_round==1,m

*	closed why 
d s6bq11b
la li s6bq11b
ta s6bq11b round
g closed_why_nfe = cond(s6bq11b==11,96,s6bq11b)	//	only rounds 2/4 
run "${do_hfps_util}/label_closed_why_nfe.do"
la val closed_why_nfe closed_why_nfe 
ta closed_why_nfe  
tab2 closed_why_nfe open_nfe refperiod_nfe,m first



*	reason for low revenue
tab2 round s6q14 s6qb14, first 
la li  s6q14 s6qb14	//	identical
// 	*-> these were single-select. Just exporting the categorical variable 
egen lowrev_why_nfe = rowfirst(s6q14 s6qb14)
recode lowrev_why_nfe (11=96)
la copy closed_why_nfe lowrev_why_nfe
la val lowrev_why_nfe closed_why_nfe
la var lowrev_why_nfe	"Reason NFE revenue was low"

*	don't have "events experienced"

*	challenges faced
d s6qb15__*
tabstat s6qb15__?, m by(round) s(sum)
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
forv i=1/7 {
	loc v s6qb15__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
}
tabstat challenge*_nfe, by(round)	




keep y4_hhid round *_cur *_nfe
	
sa "${tmp_hfps_mwi}/panel/employment.dta", replace 
ex


u  "${tmp_hfps_mwi}/panel/employment.dta", clear
ta sector_cur work_cur,m
ta sector_nfe refperiod_nfe,m
