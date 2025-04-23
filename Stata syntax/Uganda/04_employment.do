


loc investigation=0
if `investigation'==1	{	/*	shutoff bracket to skip investigation work if we just desire to reset the data	*/

{	/*	data inventory	*/

dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w
dir "${raw_hfps_uga}/round18", w

d using	"${raw_hfps_uga}/round1/SEC5.dta"
d using	"${raw_hfps_uga}/round2/SEC5.dta"
d using	"${raw_hfps_uga}/round3/SEC5.dta"
d using	"${raw_hfps_uga}/round4/SEC5.dta"
d using	"${raw_hfps_uga}/round5/SEC5.dta"
d using	"${raw_hfps_uga}/round6/SEC5_Resp.dta"
d using	"${raw_hfps_uga}/round7/SEC5.dta"
d using	"${raw_hfps_uga}/round8/SEC5.dta"
d using	"${raw_hfps_uga}/round9/SEC5.dta"
d using	"${raw_hfps_uga}/round10/SEC5.dta"
d using	"${raw_hfps_uga}/round11/SEC5.dta"
d using	"${raw_hfps_uga}/round12/SEC5.dta"
d using	"${raw_hfps_uga}/round13/SEC5.dta"
d using	"${raw_hfps_uga}/round14/SEC5.dta"
d using	"${raw_hfps_uga}/round15/SEC5.dta"
d using	"${raw_hfps_uga}/round16/SEC5.dta"
d using	"${raw_hfps_uga}/round17/SEC5.dta"
d using	"${raw_hfps_uga}/round18/SEC5.dta"


*	NFE
d using	"${raw_hfps_uga}/round1/SEC5A.dta"	//	ag in this round
d using	"${raw_hfps_uga}/round2/SEC5A.dta"
d using	"${raw_hfps_uga}/round3/SEC5A.dta"
d using	"${raw_hfps_uga}/round4/SEC5A.dta"
d using	"${raw_hfps_uga}/round5/SEC5A.dta"
d using	"${raw_hfps_uga}/round6/SEC5A.dta"
d using	"${raw_hfps_uga}/round7/SEC5A.dta"
d using	"${raw_hfps_uga}/round8/SEC5A.dta"
d using	"${raw_hfps_uga}/round9/SEC5A.dta"
d using	"${raw_hfps_uga}/round10/SEC5A.dta"
d using	"${raw_hfps_uga}/round11/SEC5A.dta"
d using	"${raw_hfps_uga}/round12/SEC5A.dta"
d using	"${raw_hfps_uga}/round14/SEC5A.dta"
d using	"${raw_hfps_uga}/round16/SEC5A.dta"
d using	"${raw_hfps_uga}/round18/SEC5A.dta"
}	/*	end data inventory	*/



{	/*	automated variable label inventory - sec5 	*/
preserve
// u "${raw_hfps_uga}/round1/SEC5.dta" , clear
// d, replace clear
qui {
foreach r of numlist 1/5 7/18 {
	u "${raw_hfps_uga}/round`r'/SEC5.dta" , clear
	d, replace clear
// 	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
}

	u `r1', clear
foreach r of numlist 1/5 7/18 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
}


egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
li name rounds if matches>3,  sep(0)
li name varlab rounds if matches>3, sep(0)
restore
}

{	/*	automated value label inventory - sec5 	*/

preserve
qui {
foreach r of numlist 1/5 7/18 {
	u "${raw_hfps_uga}/round`r'/SEC5.dta" , clear
	la dir
	uselabel `r(labels)', replace clear
	tempfile r`r'
	sa      `r`r''
	}
	u `r1', clear
foreach r of numlist 1/5 7/18 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	}

	
egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
li lname value label rounds,  sepby(lname)
li lname value label rounds if matches>3, sepby(lname)
restore
}




{	/*	automated variable label inventory - sec5a 	*/
preserve
// u "${raw_hfps_uga}/round1/SEC5.dta" , clear
// d, replace clear
qui {
	gl rounds 2 3 4 5 6 7 8 9 10 11 12 14 16 18
foreach r of numlist 2/12 14(2)18 {
	u "${raw_hfps_uga}/round`r'/SEC5A.dta" , clear
	d, replace clear
// 	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
}

	u `r2', clear
foreach r of numlist 2/12 14(2)18 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
}


egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
li name rounds if matches>3,  sep(0)
li name varlab rounds if matches>3, sep(0)
restore
}

{	/*	automated value label inventory - sec5a 	*/


preserve
qui {
foreach r of numlist 2/12 14(2)18 {
	u "${raw_hfps_uga}/round`r'/SEC5A.dta" , clear
	la dir
	uselabel `r(labels)', replace clear
	tempfile r`r'
	sa      `r`r''
	}
	u `r2', clear
foreach r of numlist 2/12 14(2)18 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	}

	
egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
li lname value label rounds,  sepby(lname)
li lname value label rounds if strpos(lname,"q14")>0, sepby(lname)
restore
}




{	/*	one-off	*/
	/*	investigate the admin codes in this specific round, why the second set? */
u	"${raw_hfps_uga}/round3/Cover.dta", clear 
ta DistrictName DistrictName2	//	identical
ta DistrictCode DistrictCode2	//	identical
ta ParishName ParishName2
assert ParishName==ParishName2 if !mi(ParishName2)
	*-> don't care, drop them 

*	NFE low/no income codes 
foreach r of numlist 2/12 14 {
	u "${raw_hfps_uga}/round`r'/SEC5A.dta", clear
	uselabel s5aq14_1 s5aq14_2
	tempfile r`r'
	sa		`r`r''
}
u `r2', clear
foreach r of numlist 3/12 14 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	*	these shift over time. But they are not currently requested for analysis 
}	/*	end one-off	*/

}	/*	end investigation	*/



{	/*	make combined dataset	*/
#d ; 
foreach r of numlist 1/5 7/12 14(2)18  {;
	u							"${raw_hfps_uga}/round`r'/SEC5.dta", clear;
cap : noi : mer 1:1 hhid using	"${raw_hfps_uga}/round`r'/SEC5A.dta", assert(3) nogen; 
	if _rc==0 {; 
	g nfe_round=1; 
	tempfile r`r'; sa `r`r''; };
	else {; 
	u					"${raw_hfps_uga}/round`r'/SEC5.dta", clear;
	mer 1:1 hhid using	"${raw_hfps_uga}/round`r'/SEC5A.dta", assert(1 3) gen(_`r'); 
	g nfe_round=1; 
	tempfile r`r'; sa `r`r''; };
};
	loc r=6; 	/*	one-off to deal with file naming convention difference	*/
	u					"${raw_hfps_uga}/round`r'/SEC5_Resp.dta", clear;
	mer 1:1 hhid using	"${raw_hfps_uga}/round`r'/SEC5A.dta", assert(3) nogen; 
	g nfe_round=1; 
	tempfile r`r'; sa `r`r'';

clear; append using
 `r1'
 `r2'
 `r3'
 `r4'
 `r5'
 `r6'
 `r7'
 `r8'
 `r9'
 `r10'
 `r11'
 `r12'
 "${raw_hfps_uga}/round13/SEC5.dta"
 `r14'
 "${raw_hfps_uga}/round15/SEC5.dta"
 `r16'
 "${raw_hfps_uga}/round17/SEC5.dta"
 `r18'

, gen(round);
#d cr

	
	la drop _append
	la val round .
	
	isid hhid round
	sort hhid round
	}
	ta round 	

ta round s5q01,m 
ta s5q06 round,m
ta s5q06 s5q01, m
	
g work_cur = (s5q01==1) if inlist(s5q01,1,2)
g nwork_cur=1-work_cur
g wage_cur = (s5q01==1 & inlist(s5q06,4,5)) if inlist(s5q01,1,2)
g biz_cur  = (s5q01==1 & inlist(s5q06,1,2)) if inlist(s5q01,1,2)
g farm_cur = (s5q01==1 & inlist(s5q06,3))   if inlist(s5q01,1,2)
la var work_cur			"Respondent currently employed"
la var nwork_cur		"Respondent currently unemployed"
la var wage_cur			"Respondent mainly employed for wages"
la var biz_cur			"Respondent mainly employed in household enterprise"
la var farm_cur			"Respondent mainly employed on family farm"
	
*	sector 
tab2 round s504 s5q05,m first
d s5q05
la li s5q05	
recode s5q05 (11111 201111=1)(21111 31111=2)(41111 51111=3)(61111=4)	/*
*/	(71111 91111=5)(81111=6)(101111 111111 121111 131111 141111=7)(151111=8)	/*
*/	(161111 171111 181111 191111 211111 -96=9), copyrest gen(sector_cur)
run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur emp_sector
la var sector_cur	"Sector of respondent current employment"
ta round sector_cur
ta round sector_cur, row nofreq nokey
ta sector_cur work_cur,m
ta sector_cur wage_cur,m
ta round if mi(sector_cur) & work_cur==1	//	widely distributed after round 1

	*	deal with missingness in sector
bys hhid (round) : egen yyy = mode(sector_cur)
bys hhid (round) : egen zzz = mode(sector_cur), minmode
ta yyy zzz,m

bys hhid (round) : replace sector_cur = sector_cur[_n-1] if mi(sector_cur) & work_cur==1
bys hhid (round) : egen aaa = mode(sector_cur)
replace sector_cur = yyy if mi(sector_cur) & work_cur==1
replace sector_cur = aaa if mi(sector_cur) & work_cur==1
bys hhid (round) : egen bbb = mode(sector_cur), minmode
replace sector_cur = bbb if mi(sector_cur) & work_cur==1

	ta sector_cur work_cur,m
ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==4
drop ???
	ta round sector_cur,m
	ta round if mi(sector_cur) & work_cur==1


*	hours
tabstat s5q08b s5q8b1 s5q8c1, by(round)
egen hours_cur = rowfirst(s5q08b s5q8b1)
ta hours_cur round
replace hours_cur=. if mi(hours_cur)
assert hours_cur<=168 if !mi(hours_cur)
la var hours_cur	"Hours respondent worked in current employment"


{	/*	obsolete code retained here in its original position	*/
/*keep hhid round *_cur
	tempfile cur
	sa		`cur'
	
	
**	NFE separate entirely
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC5.dta"
	"${raw_hfps_uga}/round2/SEC5A.dta"
	"${raw_hfps_uga}/round3/SEC5A.dta"
	"${raw_hfps_uga}/round4/SEC5A.dta"
	"${raw_hfps_uga}/round5/SEC5A.dta"
	"${raw_hfps_uga}/round6/SEC5A.dta"
	"${raw_hfps_uga}/round7/SEC5A.dta"
	"${raw_hfps_uga}/round8/SEC5A.dta"
	"${raw_hfps_uga}/round9/SEC5A.dta"
	"${raw_hfps_uga}/round10/SEC5A.dta"
	"${raw_hfps_uga}/round11/SEC5A.dta"
	"${raw_hfps_uga}/round12/SEC5A.dta"
	"${raw_hfps_uga}/round14/SEC5A.dta"

, gen(round);
#d cr
	la drop _append
	la val round 
	replace round=round+1 if round>12
	ta round 	
	isid hhid round
	sort hhid round
*/
}
	*	refperiod operational 
tab2 round s5q11 s5aq11 /*s5aq11a*/ s5aq1 if nfe_round==1, first m
	egen xx = rowfirst(s5q11 s5aq11 s5aq1)
	g refperiod_nfe = (xx==1) if !mi(xx)
	drop xx
	tabstat s5aq11a s5aq11a_? s5aq1, by(round)
	egen yy = rowfirst(s5aq11a s5aq11a_?)
	ta round yy,m
	replace refperiod_nfe = (yy==1) if !mi(yy) & mi(refperiod_nfe) & nfe_round==1
	drop yy
la var	refperiod_nfe "Household operated a non-farm enterprise (NFE) since previous contact"
ta round refperiod_nfe,m

	*	activity
	tab2 round s5q12 s5aq12 s5aq3 if nfe_round==1,m first
	la li s5q12
	egen xx = rowfirst(s5q12 s5aq12 s5aq3)
	
recode xx (11111 201111=1)(21111 31111=2)(41111 51111=3)(61111=4)	/*
*/	(71111 91111=5)(81111=6)(101111 111111 121111 131111 141111=7)(151111=8)	/*
*/	(161111 171111 181111 191111 211111 -96=9)(.a=.), copyrest gen(sector_nfe)
run "${do_hfps_util}/label_emp_sector.do"
la val sector_nfe emp_sector
la var sector_nfe	"Sector of NFE"
ta round sector_nfe
drop xx
ta sector_nfe refperiod_nfe,m
ta sector_nfe refperiod_nfe if nfe_round==1,m

qui	{	/*	deal with missingness in sector	*/
bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1
bys hhid (round) : egen aaa = mode(sector_nfe)
replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1
bys hhid (round) : egen bbb = mode(sector_nfe), minmode
replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	}	/*	end missingness in sector	*/
ta sector_nfe refperiod_nfe if nfe_round==1,m
ta sector_nfe refperiod_nfe,m
g sector_biz = sector_cur if biz_cur==1
bys hhid (round) : egen xyz = mode(sector_biz)
replace sector_nfe=xyz if mi(sector_nfe) & refperiod_nfe==1
drop sector_biz xyz 
	
	*	currently operational
	tab2 round s5aq11a s5aq11a_? s5aq1,m first	//	not asked in round 18 
	egen status_nfe = rowfirst(s5aq11a s5aq11a_?) if nfe_round==1
	la copy s5aq11a_1 status_nfe
	la val status_nfe status_nfe
	ta round status_nfe,m
	la var status_nfe	"Current operational status of NFE"
	
	g open_nfe = (status_nfe==1) if !mi(status_nfe)
	la var open_nfe		"NFE is currently open"
	
	ta status_nfe sector_nfe,m
	
*	closed why
tab2 round s5aq11b	//	NFE rounds 3-16 
tabstat s5aq11b__*, by(round)	//	administered as multi-select in round 2... 
egen yyy = rowtotal(s5aq11b__1-s5aq11b__n96), m
ta yyy
tabstat s5aq11b__*, s(n sum)
forv i=1/10 {
	g z`i' = `i' if s5aq11b__`i'==1
}
g zn96 = -96 if s5aq11b__n96==1
egen zzz = group(z1-zn96), label missing
ta zzz if yyy>1
tabstat s5aq11b__* if yyy==1, s(n sum)
	*	could take the modal response as dominant, or could highlight less frequent responses where they are given 
	ta s5aq11b if inlist(round,3), nol
	egen	aaa = rowfirst(z1-zn96) if yyy==1
	foreach r of numlist 1 4 3 2 -96 9 7 8 5 6 {
		if `r'<0 {
			loc s = subinstr("`r'","-","n",1)
		}
		else loc s=`r'
		replace	aaa = `r' if s5aq11b__`s'==1 & yyy>1 & mi(aaa)
		}
	assert !mi(aaa) if !mi(yyy)
	ta aaa
	
	

	*	dealing with "it's not profitable" vs "inputs too expensive"
	g		closed_why_nfe = abs(s5aq11b)		//	sets -96 to 96 
	replace	closed_why_nfe = abs(aaa) if round==2	
	drop yyy-aaa
	recode	closed_why_nfe (1=3)(2=13)(3=4)(4=8)(5=14) if round==10
	recode	closed_why_nfe (2=3)(3=13)(5=11)(6=14)(7=6)(8=7)(9=8)(10=9)(11=10)(12=4)(13=5) if inlist(round,11,12,14,16)
run "${do_hfps_util}/label_closed_why_nfe.do"
	ta closed_why_nfe open_nfe,m
	ta round if mi(closed_why_nfe) & open_nfe==0	//	primarily round 2 
	
	
*	revenue
tab2 round s5aq13	//	not asked in round 18 
g revenue_lbl_nfe = .
la var revenue_lbl_nfe		"Revenue was [...] compared to last month"
foreach i of numlist 1/4 {
	loc v s5aq13
	g revenue`i'_nfe = (`v'==`i') if !mi(`v')
}
la var revenue1_nfe		"Higher"
la var revenue2_nfe		"The same"
la var revenue3_nfe		"Lower"
la var revenue4_nfe		"No revenue from sales"
	
*	reason for no/low revenue -> Uganda differentiates between low and none, but we will consider both 
tab2 round s5q14 s5aq14_1 s5aq14_2, first m	//	check labels in round 11+ for code 12 
la li  s5q14 s5aq14_1 s5aq14_2	//	identical	
		preserve
	u "${raw_hfps_uga}/round11/SEC5A.dta", clear
	la li s5aq14_1 s5aq14_2	//	identical	
	d using "${raw_hfps_uga}/round1/SEC5.dta"
		restore
	*	the round 10 code 5 change is not present 
egen	lowrev_why_nfe = rowfirst(s5q14 s5aq14_1 s5aq14_2)
recode	lowrev_why_nfe (-96=96)
recode	lowrev_why_nfe (1=3)(2=13)(3=4) if round==10
recode	lowrev_why_nfe (2=3)(3=13)(12 13=5) if inrange(round,11,16)
recode	lowrev_why_nfe (5=14)(6=15)(10=6)(7=6)(8=7)(9=8)(10=9)(11=10) if inrange(round,10,16)

la copy	closed_why_nfe lowrev_why_nfe
la val	lowrev_why_nfe closed_why_nfe
la var	lowrev_why_nfe	"Reason NFE revenue was low"



*	challenges
tab2 round s5aq15__? s5aq5_?, first m
d s5aq15__? s5aq5_?, f
g challenge_lbl_nfe = .
la var challenge_lbl_nfe	"Challenges to NFE [...]"
foreach i of numlist 1/6 {
	loc v s5aq15__`i'
	g challenge`i'_nfe = (`v'==1) if !mi(`v')
}
// g challenge7_nfe = (s5aq15__n96==1) if !mi(s5aq15__n96)
do "${do_hfps_util}/label_chal_nfe.do"

*	no event, only present in NG and don't have harmonized codes 



	
	*	combine and export 
keep hhid round *_cur *_nfe
	

sa "${tmp_hfps_uga}/employment.dta", replace	
u  "${tmp_hfps_uga}/employment.dta", clear	

ta round sector_nfe,m













