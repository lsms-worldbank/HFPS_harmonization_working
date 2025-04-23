


  
	  
*	use individual panel to make demographics 
u "${tmp_hfps_mwi}/ind.dta", clear

*	respondent characteristics
foreach x in sex age head pnl_rltn {
	bys y4_hhid round (pid) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}
ren resp_pnl_rltn resp_relation


*	do we still have a respondent and a head for all
bys y4_hhid round (pid) : egen headtest = sum(head) 
bys y4_hhid round (pid) : egen resptest = sum(respond) 
bys y4_hhid round (pid) : egen memtest = sum(member) 
tab1 *test,m
ta round resptest,m	//	have already maximized the work from the public data to identify these respondents
ta round if memtest<1	//	distributed between 7, 8, 20
ta memtest if round==10



keep if member==1
	  


g hhsize=1
*	assume all missing ages are labor age 
*	assume all missing sexes are female 
g m0_14 	= (sex==1 & inrange(age,0,14))
g m15_64	= (sex==1 & (inrange(age,15,64) | mi(age)))	//	all missing age will be adult age
g m65		= (sex==1 & (age>64 & !mi(age)))
g f0_14 	= (sex==2 & inrange(age,0,14))
g f15_64	= (sex>=2 & (inrange(age,15,64) | mi(age)))	//	all missing sex will be female
g f65		= (sex==2 & (age>64 & !mi(age)))

		    g		adulteq=. 
            replace adulteq = 0.27 if (sex==1 & age==0) 
            replace adulteq = 0.45 if (sex==1 & inrange(age,1,3)) 
            replace adulteq = 0.61 if (sex==1 & inrange(age,4,6)) 
            replace adulteq = 0.73 if (sex==1 & inrange(age,7,9)) 
            replace adulteq = 0.86 if (sex==1 & inrange(age,10,12)) 
            replace adulteq = 0.96 if (sex==1 & inrange(age,13,15)) 
            replace adulteq = 1.02 if (sex==1 & inrange(age,16,19)) 
            replace adulteq = 1.00 if (sex==1 & age >=20) 	//	assumes all missing ages are adults 
            replace adulteq = 0.27 if (sex==2 & age ==0) 
            replace adulteq = 0.45 if (sex==2 & inrange(age,1,3)) 
            replace adulteq = 0.61 if (sex==2 & inrange(age,4,6)) 
            replace adulteq = 0.73 if (sex==2 & inrange(age,7,9)) 
            replace adulteq = 0.78 if (sex==2 & inrange(age,10,12)) 
            replace adulteq = 0.83 if (sex==2 & inrange(age,13,15)) 
            replace adulteq = 0.77 if (sex==2 & inrange(age,16,19)) 
            replace adulteq = 0.73 if (sex>=2 & age >=20)   //	assumes all missing sex are female 

			su adulteq

	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(y4_hhid round)	

sa "${tmp_hfps_mwi}/demog.dta", replace
 
	  	  ex	  
	  








