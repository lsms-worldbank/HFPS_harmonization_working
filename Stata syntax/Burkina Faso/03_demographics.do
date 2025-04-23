 

*	use individual panel to make demographics 
u "${tmp_hfps_bfa}/ind.dta", clear

*	respondent characteristics
foreach x in sex age head pnl_rltn {
	bys hhid round (membres__id) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}
ren resp_pnl_rltn resp_relation


*	do we still have a respondent and a member for all
	*	rule is not strictly enforced that a single head be identified. 
bys hhid round (membres__id) : egen headtest = sum(head) 
bys hhid round (membres__id) : egen resptest = sum(respond) 
bys hhid round (membres__id) : egen memtest = sum(member) 
tab1 *test,m
assert resptest==1
assert memtest>=1


ta round member,m
keep if member==1
su 

g hhsize=1
*	assume all missing ages are labor age 
*	assume all missing sexes are female 
g m0_14 	= (sex==1 & inrange(age,0,14))
g m15_64	= (sex==1 & (inrange(age,15,64) | mi(age)))	//	all missing age will be adult age
g m65		= (sex==1 & (age>64 & !mi(age)))
g f0_14 	= (sex==2 & inrange(age,0,14))
g f15_64	= (sex>=2 & (inrange(age,15,64) | mi(age)))	//	all missing sex will be female
g f65		= (sex==2 & (age>64 & !mi(age)))

			*	FAO equivalence scale
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
			

	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(hhid round)	

sa "${tmp_hfps_bfa}/demog.dta", replace
 
	  	  ex





