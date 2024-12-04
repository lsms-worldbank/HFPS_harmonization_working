
cap : prog drop	country_data_signature
      prog def	country_data_signature, rclass
	  
	  *	no arguments
loc signature = ""
assert length("`signature'")==0
foreach x in bfa eth mwi nga tza uga {
if strpos("`c(filename)'","${tmp_hfps_`x'}")>0 {
	loc lngth=strpos("${tmp_hfps_`x'}","Temporary datasets")+length("Temporary datasets/")
	loc signature=substr("${tmp_hfps_`x'}",`lngth',length("${tmp_hfps_`x'}")-(`lngth'-1))
	loc stub="`x'"
}
}
dis "`signature'"
return local signature	"`signature'"
return local stub 		"`stub'"
end 
country_data_signature
ret li
