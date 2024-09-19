

#d ; 
la def care_place

           1 "HOSPITAL"
           2 "CLINIC/HEALTH POST/PRIMARY HEALTH CARE"
           3 "PHARMACY"
           4 "CHEMIST SHOP (DRUG SHOP)"
           5 "MATERNITY HOME/ MATERNAL AND CHILD HEALTH POST"
           6 "CONSULTANT HOME"
           7 "PATIENT HOME"
           8 "TRADITIONAL HEALER HOME"
           9 "FAITH BASED HOME"
          96 "OTHER, SPECIFY"
		  
, replace; 

#d cr 

cap : la val care_place care_place
if _rc==0 {
	inspect care_place
	assert r(N_undoc)==0
}

ex

