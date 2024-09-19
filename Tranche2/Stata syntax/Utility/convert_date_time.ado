
*	need to diagnose changes in this file prior to a grand append 
cap :	program drop	convert_date_time
		program def		convert_date_time
*	1 var name to be converted if string

syntax varlist 

foreach v of local varlist {
cap : ds `v', has(type string)
if _rc==0 & length("`r(varlist)'")>0	{
	 g datetime = clock(`v',"YMD#hms#"), a(`v')
la var datetime	"`: var lab `v''"
format datetime %tc
li `v' datetime in 1/3

cap : assert !mi(datetime) if !inlist(`v',"","##N/A##") 	//	verify that no information is being lost
if _rc!=0 {
	g `v'rmdr = `v' if mi(datetime) & !mi(`v')
	dis as yellow "ALERT: `v' has values that don't fit mask YMD#hms#, captured in variable `v'rmdr "
}

else {
	dis as green "`v' successfully converted"
}

drop `v'
ren datetime `v'

}

else {
	dis as green "`v' non-string, no action taken"
}
}
end
