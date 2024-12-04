


*	Populate initial folder structure

if c(username)=="joshbrubaker" {
	run "/Users/joshbrubaker/Dropbox/Consulting/stata_tools/startup.do"
	gl hfps "${dbox}/Consulting/WB/HFPS2"
}
cd "${hfps}"
dir "${hfps}"

// loc sub1 `"Stata syntax"' `"Temporary datasets"' `"Final datasets"' `"Log files"' `"Data visualization"' `"Excel documentation"'
// loc sub2 `"Burkina Faso"' `"Ethiopia"' `"Malawi"' `"Nigeria"' `"Uganda"' `"Tanzania"' 

*	mkdir does not like these since they have spaces. Just doing manually 

mkdir "${hfps}/Stata syntax"
mkdir "${hfps}/Stata syntax/Burkina Faso"
mkdir "${hfps}/Stata syntax/Ethiopia"
mkdir "${hfps}/Stata syntax/Malawi"
mkdir "${hfps}/Stata syntax/Nigeria"
mkdir "${hfps}/Stata syntax/Uganda"
mkdir "${hfps}/Stata syntax/Tanzania"
mkdir "${hfps}/Stata syntax/Panel"

mkdir "${hfps}/Temporary datasets"
mkdir "${hfps}/Temporary datasets/Burkina Faso"
mkdir "${hfps}/Temporary datasets/Ethiopia"
mkdir "${hfps}/Temporary datasets/Malawi"
mkdir "${hfps}/Temporary datasets/Nigeria"
mkdir "${hfps}/Temporary datasets/Uganda"
mkdir "${hfps}/Temporary datasets/Tanzania"
mkdir "${hfps}/Temporary datasets/Panel"

mkdir "${hfps}/Final datasets"
mkdir "${hfps}/Final datasets/Burkina Faso"
mkdir "${hfps}/Final datasets/Ethiopia"
mkdir "${hfps}/Final datasets/Malawi"
mkdir "${hfps}/Final datasets/Nigeria"
mkdir "${hfps}/Final datasets/Uganda"
mkdir "${hfps}/Final datasets/Tanzania"
mkdir "${hfps}/Final datasets/Panel"

mkdir "${hfps}/Log files"
mkdir "${hfps}/Log files/Burkina Faso"
mkdir "${hfps}/Log files/Ethiopia"
mkdir "${hfps}/Log files/Malawi"
mkdir "${hfps}/Log files/Nigeria"
mkdir "${hfps}/Log files/Uganda"
mkdir "${hfps}/Log files/Tanzania"
mkdir "${hfps}/Log files/Panel"

mkdir "${hfps}/Data visualization"
mkdir "${hfps}/Data visualization/Burkina Faso"
mkdir "${hfps}/Data visualization/Ethiopia"
mkdir "${hfps}/Data visualization/Malawi"
mkdir "${hfps}/Data visualization/Nigeria"
mkdir "${hfps}/Data visualization/Uganda"
mkdir "${hfps}/Data visualization/Tanzania"
mkdir "${hfps}/Data visualization/Panel"

mkdir "${hfps}/Excel documentation"
mkdir "${hfps}/Excel documentation/Burkina Faso"
mkdir "${hfps}/Excel documentation/Ethiopia"
mkdir "${hfps}/Excel documentation/Malawi"
mkdir "${hfps}/Excel documentation/Nigeria"
mkdir "${hfps}/Excel documentation/Uganda"
mkdir "${hfps}/Excel documentation/Tanzania"
mkdir "${hfps}/Excel documentation/Panel"


foreach r of numlist 1(1)18 {
	mkdir       "${hfps}/Stata syntax/Burkina Faso/r`r'"
	mkdir "${hfps}/Temporary datasets/Burkina Faso/r`r'"
	mkdir     "${hfps}/Final datasets/Burkina Faso/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Burkina Faso/panel"
	mkdir "${hfps}/Temporary datasets/Burkina Faso/panel"
	mkdir     "${hfps}/Final datasets/Burkina Faso/panel"

foreach r of numlist 1(1)17 {
	mkdir       "${hfps}/Stata syntax/Ethiopia/r`r'"
	mkdir "${hfps}/Temporary datasets/Ethiopia/r`r'"
	mkdir     "${hfps}/Final datasets/Ethiopia/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Ethiopia/panel"
	mkdir "${hfps}/Temporary datasets/Ethiopia/panel"
	mkdir     "${hfps}/Final datasets/Ethiopia/panel"

foreach r of numlist 1(1)18 {
	mkdir       "${hfps}/Stata syntax/Malawi/r`r'"
	mkdir "${hfps}/Temporary datasets/Malawi/r`r'"
	mkdir     "${hfps}/Final datasets/Malawi/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Malawi/panel"
	mkdir "${hfps}/Temporary datasets/Malawi/panel"
	mkdir     "${hfps}/Final datasets/Malawi/panel"

foreach r of numlist 1(1)21 {	//	Nigeria raw follows a phased structure, but we will ignore it for the purposes of a harmonized data structure
	mkdir       "${hfps}/Stata syntax/Nigeria/r`r'"
	mkdir "${hfps}/Temporary datasets/Nigeria/r`r'"
	mkdir     "${hfps}/Final datasets/Nigeria/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Nigeria/panel"
	mkdir "${hfps}/Temporary datasets/Nigeria/panel"
	mkdir     "${hfps}/Final datasets/Nigeria/panel"

foreach r of numlist 1(1)13 {
	mkdir       "${hfps}/Stata syntax/Uganda/r`r'"
	mkdir "${hfps}/Temporary datasets/Uganda/r`r'"
	mkdir     "${hfps}/Final datasets/Uganda/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Uganda/panel"
	mkdir "${hfps}/Temporary datasets/Uganda/panel"
	mkdir     "${hfps}/Final datasets/Uganda/panel"

foreach r of numlist 1(1)8 {
	mkdir       "${hfps}/Stata syntax/Tanzania/r`r'"
	mkdir "${hfps}/Temporary datasets/Tanzania/r`r'"
	mkdir     "${hfps}/Final datasets/Tanzania/r`r'"
}
	mkdir       "${hfps}/Stata syntax/Tanzania/panel"
	mkdir "${hfps}/Temporary datasets/Tanzania/panel"
	mkdir     "${hfps}/Final datasets/Tanzania/panel"


