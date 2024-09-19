loc investigation=0
if `investigation'==1	{	/*	shutoff bracket to skip investigation work if we just desire to reset the data	*/

{	/*	data iventory	*/
dir "${raw_hfps_eth}", w
// dir "${raw_hfps_eth2}", w


*	Phase 1
d em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
d em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
d em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d em* using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"	
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"	
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_cover_interview_public.dta"
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"
// d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_cover_interview_public.dta"
d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"
// d em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round19_employment_public.dta"

/**/

/*
u "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ta em15_bus em15a_bus,m
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ta em15_bus em15a_bus,m
*/
}	/*	end data inventory	*/


{	/*	variable label inventory	*/
preserve
#d ;
qui {; 
loc raw1  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw2  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw3  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw4  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw5  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"; 
loc raw6  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw7  "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw8  "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw9  "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw10 "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw11 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	; 
loc raw13 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta";
loc raw14 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta";
loc raw16 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta";
loc raw18 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta";

u "`raw1'" , clear;
d em*, replace clear;

foreach r of numlist 1/11 13 14 16 18 {;
	u "`raw`r''" , clear;
	d em*, replace clear;
	replace varlab = strtrim(strlower(varlab)); 
	tempfile r`r';
	sa      `r`r'';
}; 
u `r1', clear; 
foreach r of numlist 1/11 13 14 16 18 {;
	mer 1:1 name varlab using `r`r'', gen(_`r');
	recode _`r' (. 1=.)(2 3=`r'); 
	la val _`r' .; la drop _merge; 
	};
#d cr 
egen matches = rownonmiss(_? _??)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

sort name
g namesort = cond(substr(name,1,2)=="em",substr(name,3,strpos(name,"_")-3),"")
sort namesort

egen rounds = group(_? _??), label missing
}
li name varlab rounds if substr(name,1,2)=="em", sep(0)

// ta matches if !mi(namesort)
restore
*	could add in flagging variables that are of a different type, but going to just ignore for now I htink 
}


{	/*	value label inventory	*/
preserve
#d ;
loc raw1  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw2  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw3  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw4  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw5  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"; 
loc raw6  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw7  "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw8  "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw9  "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw10 "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw11 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	; 
loc raw13 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta";
loc raw14 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta";
loc raw16 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta";
loc raw18 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta";

u em* using "`raw1'" , clear;
	la dir; 
	uselabel `r(labels)', clear replace; 

	foreach r of numlist 1/11 13 14 16 18 {;
	u em* using "`raw`r''" , clear;
	la dir; 
	uselabel `r(labels)', clear replace; 
	tempfile r`r';
	sa      `r`r'';
	}; 

	u `r1', clear;
	foreach r of numlist 1/11 13 14 16 18 {;
	mer 1:1 lname value label using `r`r'', gen(_`r');
	replace label=strtrim(label); 
	recode _`r' (1 .=.)(2 3=`r'); 
	la val _`r' .; 
	};

	#d cr 
egen matches = rownonmiss(_? _??)
ta matches
// ta lname matches if matches>=10
// ta lname matches if matches<10
egen rounds = group(_? _??), label missing
ta rounds

sort lname value label
li  lname value label rounds,  sepby(lname)
restore
}


{	/*	check for respondent variables	*/
*	Phase 1
u "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl *espond* *ESPOND*) detail

*	Phase 2
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl *espond* *ESPOND*) detail
}	/*	end respondent vars check	*/


{	/*	check for hours variables	*/
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl *hour* *Hour* *HOUR*) detail
}	/*	end hours vars check	*/


{	/*	check for activity variables	*/
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds *, has(varl "*hour*")

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl "*hour*")
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl "*hour*")
}	/*	end activity check	*/


{	/*	check for closure variables	*/
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r1
sa		`r1'
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r2
sa		`r2'
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r3
sa		`r3'
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r4
sa		`r4'
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
d em19_bus_*, replace clear
tempfile r5
sa		`r5'
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r6
sa		`r6'
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r7
sa		`r7'
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r8
sa		`r8'
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r9
sa		`r9'
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
d em19_bus_*, replace clear
tempfile r10
sa		`r10'
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
d em19_bus_*, replace clear
tempfile r11
sa		`r11'

u `r1', clear
foreach i of numlist 1/11 { 
	mer 1:1 name varlab using `r`i'', gen(_`i')
}
// bro

g label = subinstr(varlab,"EM19: ","",1)
g value = subinstr(vallab,"em19_bus_inc_low_why_","",1)
destring value, replace ignore(_)
keep if isnumeric==1
g lname = "em19_bus_inc_low_why"
keep lname label value 
tempfile em19
sa `em19'
li, sep(0)	

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r13
sa		`r13'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r14
sa		`r14'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r16
sa		`r16'

u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds *, has(varl "EM17*")
uselabel em17_why_low_inc
tempfile r18
sa		`r18'

u `em19', clear
foreach i of numlist 13 14 16 18 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_??), v(3)
ta matches

	sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
}	/*	need a recode of rounds 14+ 	*/ 


{	/*	check for challenges variables	*/
*	Phase 1
u household_id em* using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r1
sa		`r1'
u household_id em* using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r2
sa		`r2'
u household_id em* using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r3
sa		`r3'
u household_id em* using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r4
sa		`r4'
u household_id em* using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	, clear
ds, has(varl *chall*)
tempfile r5
sa		`r5'
u household_id em* using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *chall*)
tempfile r6
sa		`r6'
u household_id em* using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r7
sa		`r7'
u household_id em* using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r8
sa		`r8'
u household_id em* using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r9
sa		`r9'
u household_id em* using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		, clear
ds, has(varl *halle*)
tempfile r10
sa		`r10'
u household_id em* using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	, clear
ds, has(varl *halle*)
tempfile r11
sa		`r11'

*	Phase 2
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta"		, clear
ds, has(varl *halle*)
uselabel em17_why_low_inc
tempfile r13
sa		`r13'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta"		, clear
ds, has(varl *halle*)
uselabel em17_why_low_inc
tempfile r14
sa		`r14'
u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta"		, clear
ds, has(varl *halle*)
tempfile r16
sa		`r16'

u household_id em* using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta"		, clear
ds, has(varl *halle*)
tempfile r18
sa		`r18'
//
// u `em19', clear
// foreach i of numlist 13 14 16 18 {
// mer 1:1 lname value label using `r`i'', gen(_`i')
// }
// egen matches = anycount(_??), v(3)
// ta matches
//
// 	sort value label lname
// li lname value label matches, sepby(value)
// li lname value label _*, sepby(value) nol
}	/*	not asked in ETH 	*/ 

	
}	/*	end investigations bracket	*/

********************************************************************************
********************************************************************************
*	end investigations, begin construction
********************************************************************************
********************************************************************************
#d ;
loc raw1  "${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw2  "${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw3  "${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw4  "${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw5  "${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"; 
loc raw6  "${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw7  "${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw8  "${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw9  "${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw10 "${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		; 
loc raw11 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	; 
loc raw13 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_employment_public.dta";
loc raw14 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_employment_public.dta";
loc raw16 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_employment_public.dta";
loc raw18 "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_employment_public.dta";

foreach r of numlist 1/11 13 14 16 18 {;
u household_id em* using "`raw`r''", clear;
g round=`r', b(household_id);
tempfile em`r';
sa		`em`r'';
};

clear; 
append using `em1' `em2' `em3' `em4' `em5' `em6' `em7' `em8' `em9' `em10' `em11' 
			 `em13' `em14' `em16' `em18', force;
isid household_id round; 
sort household_id round; 
#d cr
ta round	
// ds em*, not(type string)
// tabstat `r(varlist)', by(round) c(s)


d em*, f

ta em1_work_cur round,m
la li em1_work_cur
g  work_cur = em1_work_cur if inlist(em1_work_cur,0,1)
g nwork_cur=1-work_cur

ta em7_work_cur_status round,m	//	missing in rounds 13+
ta em5_work_cur_status round,m	//	missing in rounds 1-11
ta em7_work_cur_status em1_work_cur,m

la li em7_work_cur_status em5_work_cur_status
egen wage_cur = anymatch(em7_work_cur_status em5_work_cur_status), v(1/6 10/12)
egen biz_cur  = anymatch(em7_work_cur_status em5_work_cur_status), v(7/9)
recode wage_cur biz_cur (nonm=.) if !inlist(em1_work_cur,0,1)

ta round em3_work_no_why

d *_farm
tab2 round em20_farm em21_farm em18_farm, first m
egen temporary = rowfirst(em20_farm em21_farm em18_farm)
g farm_cur = (temporary==1) if !mi(temporary)
drop temporary
ta farm_cur round,m
recode farm_cur (nonm=.) if !inlist(em1_work_cur,0,1)

la var work_cur		"Respondent currently employed"
la var nwork_cur	"Respondent currently unemployed"
la var wage_cur		"Respondent mainly employed for wages"
la var biz_cur		"Respondent mainly employed in household enterprise"
la var farm_cur		"Respondent mainly employed on family farm"

*	sector
tab2 round em6_work_cur_act em4_work_cur_act, m first
egen sector_cur = rowfirst(em6_work_cur_act em4_work_cur_act)
ta sector_cur
recode sector_cur (1=1)(2=2)(3 5=5)(4=6)(6=8)(7 9=9)(8=4)	//	 more limited than NGA/MWI/TZA
run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"

ta sector_cur work_cur,m	
*	no hours


**	NFE
 tab2 round em15_bus em15a_bus_prev ema11_bus, first m	//	s6q11 changes to continuous in round 20
ta round 
 ta round em7_work_cur_status,m
 la li em7_work_cur_status
 g cond1 = inlist(em7_work_cur_status,7,8,9) & inrange(round,1,11)
 g sctr1 = em6_work_cur_act if cond1==1
 ta round em15_bus,m
 ta round em15a_bus_prev,m	//	variable names not well linked with the qx
 ta round em15c_bus_new,m
 ta round em15a_bus,m
 tab2 em15_bus em15a_bus_prev em15c_bus_new,m first
 g cond2 = (em15_bus==1) if !mi(em15_bus) & inrange(round,1,11)
 g cond3 = (em15a_bus_prev==1) if !mi(em15a_bus_prev) & inrange(round,2,10)
 g cond4 = (em15c_bus_new==1) if !mi(em15c_bus_new) & (round==2 | inrange(round,4,10))
 g cond5 = (em15a_bus==1) if !mi(em15a_bus) & inlist(round,7,11)
 
 ta round em5_work_cur_status,m
 la li em5_work_cur_status
 g cond6 = inlist(em5_work_cur_status,7,8,9) & inlist(round,13,14,16,18)
 g sctr2 = em4_work_cur_act if cond6==1
 ta round ema11_bus
 ta round em13_bus_oper
 g cond7 = (ema11_bus==1) if !mi(ema11_bus) & inlist(round,13,14,16,18)
 g cond8 = (em13_bus_oper==1) if !mi(em13_bus_oper) & inlist(round,13,14,16,18)
 egen zzz = rowmax(cond?)
 ta round zzz,m 
 tabstat cond? zzz, by(round) s(sum) missing
 
 
 
 g		refperiod_nfe = (zzz==1) if !mi(zzz)
 drop zzz //	cond?	//	keep the cond? for construction of open_nfe 

la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"
ta round refperiod_nfe,m


*	currently operational. We are utilizing some of the current operation vars 
*	to construct refperiod_nfe. 
ta round em17_bus_inc,m
tab2 round em15_bus em15a_bus ema11_bus, m first
// egen temporary = rowfirst(em15_bus ema11_bus)
g open_nfe = 1 if refperiod_nfe==1	
recode open_nfe (1=0) if em17_bus_inc==4 & round==1 
*	why is em15c_bus_new always missing in round 3? -> perhaps we should set this to missing?  
recode open_nfe (1=0) if em15a_bus_prev!=1 & em15c_bus_new!=1 & cond1!=1 ///
	& inrange(round,2,10)
recode open_nfe (1=0) if em15_bus!=1 & cond1!=1 & round==11
recode open_nfe (1=0) if ema11_bus!=1 & em13_bus_oper!=1 & cond6!=1 ///
	& inrange(round,13,18)

	ta open_nfe refperiod_nfe,m



la var open_nfe		"NFE is currently open"
drop cond?

ta open_nfe refperiod_nfe,m

*	sector 
tab2 round sctr1 sctr2, first m
la li em6_work_cur_act em4_work_cur_act
tab2 round em16_bus_sector ema12_bus_sector, first m
la li em16_bus_sector ema12_bus_sector
recode sctr? (min/0=.)
recode em16_bus_sector ema12_bus_sector (min/0=.), gen(sctr3 sctr4)
egen sector_nfe = rowfirst(sctr?) if refperiod_nfe==1
ta sector_nfe 
recode sector_nfe (1=1)(2=2)(3 5=5)(4=6)(6=8)(7 9=9)(8=4)	
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"
ta sector_nfe round,m
drop sctr?

ta sector_nfe refperiod_nfe, m
g nfe_round=1	//	all are NFE rounds in ETH
ta sector_nfe refperiod_nfe if nfe_round==1,m

qui {	/*	deal with missingness in sector	*/

*	missingness can occur if the respondent is in the same employment as previous round
	*	put in the previous round's sector if it was non-missing 
	bys household_id (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	take mode following this first round and fill in
	bys household_id (round) : egen aaa = mode(sector_nfe)
	replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	fill in with the solve ties moving away from sector 9 if there are alternatives
	bys household_id (round) : egen bbb = mode(sector_nfe), minmode
	replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
	}	/*	end missingness in sector	*/

ta sector_nfe refperiod_nfe if nfe_round==1,m

/*	reasons for closure	*/
tab2 round em15b_bus_prev_closed em14_bus_close, first 
recode em15b_bus_prev_closed (-99 -98=.)(-96=96)(3=9)(4=3)(5=4)(6=5)(7=6), copyrest gen(r2r9)
recode em14_bus_close (-99 -98=.)(-96=96)(3=9)(4=3)(5 6=4)(7=6), copyrest gen(r13)
replace r13=.  if round!=13
recode em14_bus_close (-99 -98=.)(-96=96)(2=9)(7=17)(8=13), copyrest gen(r14r16)
replace r14r16=.  if !inlist(round,14,16,18)

egen closed_why_nfe = rowfirst(r2r9 r13 r14r16)
run "${do_hfps_util}/label_closed_why_nfe.do"
ta closed_why_nfe round



d em19_bus_inc_low_why_*	//	these do not mesh with the other countries, and are multi-select
tabstat em19_bus_inc_low_why_? em19_bus_inc_low_why__96, by(round) s(n sum)	//	multi-select in rounds 1-11
ta round em19_bus_inc_low_why	//	this is a group() of the responses in rounds 1-11 
d em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3
tab2 round em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3, first
d em19_bus_inc_low_why_*	//	these do not mesh with the other countries, and are multi-select
la li em17_why_low_inc
	*	em19 codes are consistent between the rounds here. verified in variable label inventory above
	*	em17 shifts across time
	recode em17_why_low_inc? (1=2)(2=3)(3=4)(4=5)(5=6)(6=7)(7=17)(8=13) if inrange(round,14,18)
	tab2 round em17_why_low_inc?, first
	ta round em16_bus_inc_low_amt
	ta em16_bus_inc_low_amt if !mi(em17_why_low_inc1),m

g		lowrev_why_lbl_nfe = .
la var	lowrev_why_lbl_nfe	"NFE revenue was low because [...]"

egen em17mark = rownonmiss(em17_why_low_inc?)
ta em17mark
foreach i of numlist 1/7 13 17 -96 -98 -99	{
	loc j=subinstr("`i'","-","_",1)
	egen em17_`j' = anymatch(em17_why_low_inc?), v(`i')
	replace em17_`j' = . if em17mark==0
} 
tabstat em17_1-em17__99, by(round) s(n sum)	//	perfect

*	change codes in variable names to match harmonized coding
	egen lowrev_why_cat1_nfe	= rowmax(em19_bus_inc_low_why_1		em17_1		)
	egen lowrev_why_cat2_nfe	= rowmax(em19_bus_inc_low_why_2		em17_2		)
	egen lowrev_why_cat9_nfe	= rowmax(em19_bus_inc_low_why_3		em17_3		)
	egen lowrev_why_cat3_nfe	= rowmax(em19_bus_inc_low_why_4		em17_4		)
	egen lowrev_why_cat4_nfe	= rowmax(em19_bus_inc_low_why_5		em17_5		)
	egen lowrev_why_cat5_nfe	= rowmax(em19_bus_inc_low_why_6		em17_6		)
	egen lowrev_why_cat6_nfe	= rowmax(em19_bus_inc_low_why_7		em17_7		)
	egen lowrev_why_cat13_nfe	= rowmax(							em17_13		)
	egen lowrev_why_cat17_nfe	= rowmax(							em17_17		)
	egen lowrev_why_cat96_nfe	= rowmax(em19_bus_inc_low_why__96	em17__96	)

foreach i of numlist 1/6 9 13 17 96	{
	la var lowrev_why_cat`i'_nfe	"`: label closed_why_nfe `i'"
}
	d lowrev_why_cat*_nfe
	
	
// g closure_lbl_nfe = .
// la var closure_lbl_nfe	"NFE closed because [...]"
// foreach i of numlist 1/7	{	
// 	loc v em19_bus_inc_low_why_`i'
// 	g closure`i'_nfe = (`v'==1) if !mi(`v')
// 	egen temp = anymatch(em17_why_low_inc1 em17_why_low_inc2 em17_why_low_inc3), v(`i')
// 	replace closure`i'_nfe = (temp==1) if !mi(em17_why_low_inc1)
// 	drop temp
// }
//
// do "${do_hfps_util}/label_closure_nfe.do"
// tabstat closure*_nfe, by(round)	
// tabstat closure*_nfe, by(round) s(n)	
 

keep household_id round *_cur *_nfe
drop em1_work_cur	//	cleanup 
sa	"${tmp_hfps_eth}/panel/employment.dta", replace 
u	"${tmp_hfps_eth}/panel/employment.dta", clear
ta sector_nfe refperiod_nfe,m
ta round if mi(sector_nfe) & refperiod_nfe==1	// widely distributed





ex	





d *_work_pre
tab2 round em2_work_pre ema2_work_pre, first m
la li em2_work_pre ema2_work_pre
replace em2_work_pre=ema2_work_pre if round>12
g  work_pre = em2_work_pre if inlist(em2_work_pre,0,1)
g nwork_pre=1-work_pre, a(work_pre)
la var  work_cur	"Currently Working"
la var nwork_cur	"Currently Not Working"
la var  work_pre	"Previously Working"
la var nwork_pre	"Previously Not Working"


ta round em3_work_no_why,m
	*	unable to work due to security reasons added in rounds 14 & 16
ta em3_work_no_why_other
g str=strtrim(strlower(em3_work_no_why_other))
chartab str
ta str
la li em3_work_no_why
la def em3_work_no_why 8 "Unable to work due to security reasons", add
ta str if em3_work_no_why==-96 & !mi(str)
recode em3_work_no_why	-96=8 if inlist(str,"lack of stability/security","security issues","security reasons")
recode em3_work_no_why	-96=1 if inlist(str,"because of rain","displacement (flood)","due to draught","seasonal work","works on his farm","it's not a farming season")
recode em3_work_no_why	-96=3 if inlist(str,"quit for fear of coronavirus")

*	Many can reasonably be classified as either 2/4/5, but this is a difficult
*	distinction to make. leaving for the analyst to decide themselves. 


*	type
tab2 round em?_work_cur_status, first m
la li em5_work_cur_status em7_work_cur_status
egen work_cur_status = rowfirst(em7_work_cur_status em5_work_cur_status)
la copy em7_work_cur_status work_cur_status
la val work_cur_status work_cur_status
la var work_cur_status	"Type of current work" 



*	what can we make as a panel 
*************************
*	business
*************************
d *_bus
tab2 round em15_bus em15a_bus ema11_bus, m first
egen temporary = rowfirst(em15_bus ema11_bus)

g biz_cur = (temporary==1) if !mi(temporary)
la var biz_cur	"Household owned businesses in last two months"
drop temporary 


ta round em13_bus_oper


*************************
*	farm employment
*************************
d *_farm
tab2 round em20_farm em21_farm em18_farm, first m
egen temporary = rowfirst(em20_farm em21_farm em18_farm)
g farm_cur = (temporary==1) if !mi(temporary)
drop temporary
ta farm_cur round,m
la var farm_cur	"Household member worked on family farm"


*************************
*	employment loss
*************************
d *_we
tab2 round em23_we em24_we em21_we, first
g nrespwork_pre = (em21_we==1)
la var nrespwork_pre	"Non-respondent employed two months ago"
ta em22_we_layoff
g nrespwork_cur = (em22_we_layoff==0) if !mi(em22_we_layoff)
la var nrespwork_cur	"Non-respondent currently employed"
g nrespwork_loss = (em22_we_layoff==1) if !mi(em22_we_layoff)
la var nrespwork_loss	"Non-respondent lost employment" 
g nrespwork_now = (em21_we==1 & em22_we_layoff==0)
la var nrespwork_now	"Full sample, non-respondent currently employed"





sa "${tmp_hfps_eth}/panel/employment.dta", replace 
u  "${tmp_hfps_eth}/panel/employment.dta", clear 
ta sector_cur work_cur,m
ta sector_nfe refperiod_nfe,m


















