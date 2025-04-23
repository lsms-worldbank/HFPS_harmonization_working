

cap :	prog drop label_inventory
		prog def  label_inventory, rclass
	
	syntax anything(name=folders), PREfix(string) SUFfix(string)	/*
	*/	[RETAIN] [DIAGNOSTIC] [VALLab] [VARName] [VARDETAIL] 

	

********************************************************************************
	*	retain this as diagnostic for now
	loc foldercount : word count `folders'
	loc prefixcount : word count `prefix'
	loc suffixcount : word count `suffix'
if length("`diagnostic'")>0 	dis `foldercount'
if length("`diagnostic'")>0 	dis `prefixcount'
if length("`diagnostic'")>0 	dis `suffixcount'
	
	loc z=0 //	iteration counter for the chronological sorting protocol
foreach i of numlist 1(1)`foldercount' {
	
loc folder`i' : word `i' of `folders' 
loc prefix`i' : word `i' of `prefix'
loc suffix`i' : word `i' of `suffix'
if length("`diagnostic'")>0	dis "`folder`i''"
	local fullset`i' : dir "`folder`i''" files "`prefix`i''*`suffix`i''"
	local rounds`i'
	foreach file of local fullset`i' {
if length("`diagnostic'")>0 		dis "`file'"	
		loc round = substr("`file'",length("`prefix'")+1,	/*
		*/	length("`file'")-length("`prefix'")-length("`suffix'"))
if length("`diagnostic'")>0 		dis `round'
		loc rounds`i' `rounds`i'' `round'
		loc ++z
	}
loc filescount`i' : word count `fullset`i''
loc roundcount`i' : word count  `rounds`i''
	assert `filescount`i''==`roundcount`i''
}
********************************************************************************

*	we want a chronological sorting of the rounds, relying on the _r* part of the file name
*	so, we will make a dataset and sort it, then re-extract these macros 
	if length("`retain'")==0 preserve
clear
qui : set obs `z'
		qui : g str300 folder	= ""
		qui : g str300 file		= ""
		qui : g str300 round	= ""

	loc z=0 //	iteration counter for the tempfile protocol
foreach i of numlist 1(1)`foldercount' {
	loc folder`i' : word `i' of `folders' 
	foreach fi of numlist 1(1)`filescount`i'' {
		loc ++z
		loc f	: word `fi' of `fullset`i''
		loc r	: word `fi' of `rounds`i''
		qui : replace folder	= "`folder`i''"	in `z'
		qui : replace file	= "`f'"			in `z'
		qui : replace round	= "`r'"			in `z'
	}
}
qui : destring round, replace
sort round file folder
li, sepby(folder)

qui : cou
loc max=r(N)	
qui : tempfile   reordered
qui : sa		`reordered'
	if length("`retain'")==0 restore


********************************************************************************
*	everything following can be coded in terms of its order in this dataset
********************************************************************************
	if length("`varname'")>0 {	/*	variable name inventory if called	*/
	if length("`retain'")==0 preserve
	
if length("`diagnostic'")>0 	dis as text "variable name inventory"
	
foreach z of numlist 1(1)`max' {
		qui : u `reordered', clear
		loc folder=folder[`z']
		loc file=file[`z']
if length("`diagnostic'")>0 		dis "`folder'/`file'"
		qui : u "`folder'/`file'", clear
// 		u "`=folder[`z']'/`=file[`z']'", clear
		qui : d, replace clear
		qui : tempfile   r`z'
		qui : sa		`r`z''
	}


u `r1', clear
foreach z of numlist 1(1)`max' {
	qui :	mer 1:1 name using `r`z''
	qui :	recode _merge (2 3=`z')(1 .=.), gen(_`z')
	qui :	drop _merge
	}

qui : ds _?, alpha
loc set1 `r(varlist)'
cap : ds _??, alpha
if _rc==0	loc set2 `r(varlist)'
else		loc set2

qui : order `set1' `set2'
qui : egen rounds = group(`set1' `set2'), label missing 
qui : egen matches = rownonmiss(`set1' `set2')
qui : sort name 
li name varlab matches rounds, sep(0)

	if length("`retain'")==0 restore
	}	/*	end variable name inventory	*/
********************************************************************************

	
********************************************************************************
	if length("`vardetail'")>0 {	/*	detailed variable name inventory if called	*/
	if length("`retain'")==0 preserve
	
if length("`diagnostic'")>0 	dis as text "variable name inventory"

foreach z of numlist 1(1)`max' {
		qui : u `reordered', clear
		loc folder=folder[`z']
		loc file=file[`z']
if length("`diagnostic'")>0 		dis "`folder'/`file'"
		qui : u "`folder'/`file'", clear
// 		u "`=folder[`z']'/`=file[`z']'", clear
		qui : d, replace clear
		qui : tempfile r`z'
		qui : sa		`r`z''
	}

qui : u `r1', clear
foreach z of numlist 1(1)`max' {
		qui : mer 1:1 name type varlab vallab using `r`z''
		qui : recode _merge (2 3=`z')(1 .=.), gen(_`z')
		qui : drop _merge
	}
qui : ds _?, alpha	//	must be populated at this point 
loc set1 `r(varlist)'

cap : ds _??, alpha
if _rc==0	loc set2 `r(varlist)'
else		loc set2

qui : order `set1' `set2'
qui : egen rounds = group(`set1' `set2'), label missing 
qui : egen matches = rownonmiss(`set1' `set2')
qui : sort name varlab vallab type
li name type varlab matches rounds, sepby(name)

	if length("`retain'")==0 restore
	}	/*	end detailed variable name inventory	*/
********************************************************************************


********************************************************************************
	if length("`vallab'")>0 {	/*	value label inventory if called	*/
	if length("`retain'")==0 preserve
	
if length("`diagnostic'")>0 	dis as text "value label inventory"

foreach z of numlist 1(1)`max' {
		u `reordered', clear
		loc folder=folder[`z']
		loc file=file[`z']
if length("`diagnostic'")>0 		dis "`folder'/`file'"
		qui : u "`folder'/`file'", clear
		qui : numlabel, remove
		qui : la dir 
		qui : uselabel `r(labels)', replace clear
		qui : tempfile r`z'
		qui : sa		`r`z''
}

qui : u `r1', clear
foreach z of numlist 1(1)`max' {
		qui : mer 1:1 lname value label using `r`z''
		qui : recode _merge (2 3=`z')(1 .=.), gen(_`z')
		qui : drop _merge
}
qui : ds _?, alpha
loc set1 `r(varlist)'
cap : ds _??, alpha
if _rc==0	loc set2 `r(varlist)'
else		loc set2

qui : order `set1' `set2'
qui : egen rounds = group(`set1' `set2'), label missing 
qui : egen matches = rownonmiss(`set1' `set2')
qui : sort lname value label
li lname value label matches rounds, sepby(lname)

	if length("`retain'")==0 restore
	}	/*	end value label inventory	*/
********************************************************************************


		
	
	
end
	ex
	
	
	

label_inventory `"${raw_hfps_mwi}"', pre(`"sect2_household_roster_r"') suf(`".dta"')
label_inventory `"${raw_hfps_mwi}"', pre(`"sect2_household_roster_r"') suf(`".dta"')	/*
*/	varname vardetail vallab retain diagnostic
// label_inventory `"${raw_hfps_mwi}"', 



