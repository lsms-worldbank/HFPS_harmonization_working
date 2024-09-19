/*
Program Author :	Josh Brubaker
Last Edited : 		23 Aug 2024
Description : 
	This program is a quick utility to clean up other/specify strings, converting
	strings to lower case. It will drop at least one variable named str if 
	present in the data and namelist or stub is not otherwise specified. 

*/



cap : program drop cleanstr
      program def  cleanstr
	  

	  
syntax namelist(name=toclean) [if] [in], [STUB(namelist)] [NAMES(namelist)]

*	verify that only one of stub or names are specified 
if length("`stub'")>0 & length("`names'")>0 {
	dis as red "cannot specify both a stub and a namelist"
	error 119
}

if length("`names'")>0 {
	*	verify that enough names are specified
	cap : assert `: word count `names''>=`: word count `toclean''
	if _rc!=0 {
		dis as red "number of names specified must at least match number of variables"
		error 119
	}
	*	verify that names specified are not already found in the dataset
	cap : ds `toclean'
	loc found `r(varlist)'
	assert `: word count `found''==0 
	if _rc!=0 {
		dis as red "`found' already exist in the dataset"
		error 119
	}
}

*	populate local stub with default if no stub or namelist is specified
if length("`stub'")==0 & length("`names'")==0 {
	loc stub str
}


*	verify that all toclean are present and are string
ds `toclean', has(type string)
loc found `r(varlist)'
cap : assert `: word count `found''==`: word count `toclean''
if _rc!=0 {
	dis as text "you specified `toclean' as string to clean, but only `found' are actually string"
	error 119
}


loc k : word count `toclean'
loc cleaned
forv i=1/`k' {
	loc tc : word `i' of `toclean'
	
	if length("`stub'")>0 & `k'==1 {
		loc cln `stub'
		cap : drop `cln'
	}
	else if length("`stub'")>0 {
		loc cln `stub'`i'
		cap : drop `cln'
	}
	else {	/* through tests above we know that all other cases must have a names call with at least sufficient values to fill in the missing	*/
		loc cln : word `i' of `names'
	}
	
	qui : g `cln' = `tc' `if' `in'
	qui : replace `cln' = strlower(`cln')
	qui : replace `cln' = strtrim(`cln')
	qui : replace `cln' = stritrim(`cln')
	
	loc cleaned `cleaned' `cln'
}

dis 
d `toclean'
d `cleaned'
end

ex

cleanstr s5q9f_oth
ta str



