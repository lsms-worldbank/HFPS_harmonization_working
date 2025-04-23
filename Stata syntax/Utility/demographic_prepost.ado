
********************************************************************************
*	simple utility to explore changes pre-and post demographic_shifts program 
********************************************************************************


cap : 	prog drop demographic_prepost
		prog def  demographic_prepost, rclass

		


version 18 


syntax [varlist(numeric default=none)], [outname(name)]



if length("`varlist'")==0	loc cases sex age relation
else						loc cases `varlist'

loc failures 
foreach c of local cases {
	cap : ds pre`c'
	if _rc!=0 {
	loc failures `failures' pre`c'
	continue
	}
}
if length("`failures'")>0 {
	dis as text "variable(s) `failures' are not present"
	error 111
}


cap : ds member
if _rc!=0 {
	dis as text "expected variable member"
	error 111
}


if length("`outname'")>0	loc outmat `outname'
else						loc outmat prepost

			qui {
cap : mat drop `outmat'
foreach c of local cases {
			mat row=J(1,8,.)
			loc col=1
			cou if member==1	//	Total
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 &  mi(`c') &  mi(pre`c')	//	jointly missing
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 & !mi(`c') &  mi(pre`c')	//	pre missing only
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 &  mi(`c') & !mi(pre`c')	//	post missing only
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 & !mi(`c') & !mi(pre`c')	//	joinly non-missing
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 & !mi(`c') & !mi(pre`c') & `c'==pre`c'	//	pre and post match
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 & !mi(`c') & !mi(pre`c') & `c'<pre`c'	//	post < pre match
			mat row[1,`col']=r(N)
			loc ++col
			cou if member==1 & !mi(`c') & !mi(pre`c') & `c'>pre`c'	//	post > pre match
			mat row[1,`col']=r(N)
			loc ++col
			mat rown row="`c'"
			mat `outmat' = (nullmat(`outmat')\row)
			}
		mat coln `outmat' = "total" "jointly missing" "pre missing only" "post missing only"	/*
		*/	"jointly nonmissing" "pre=post" "post<pre" "post>pre"
			}
		mat li `outmat'
		
return matrix prepost `outmat', copy

end 

