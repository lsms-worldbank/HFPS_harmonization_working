
#d ; 
la def status_nfe
		1	"Open"		
		2	"Temporarily closed"		
		3	"Permanently closed"
		, replace; 
#d cr 


ex




{	/*	r1	*/
u	"${raw_hfps_mwi}/sect6_employment_r1.dta", clear
	
loc r=       1
tempfile    r1
sa         `r1'
}	/*	end r1	*/





u	"${raw_hfps_mwi}/sect6b_nfe_r2.dta", clear
ta s6bq11,m
u	"${raw_hfps_mwi}/sect6a_employment1_r2.dta", clear
ta s6q6_1 s6q7_1,m	//	very few
ta s6q1_1 s6q6_1,m
u	"${raw_hfps_mwi}/sect6a_employment2_r2.dta", clear







