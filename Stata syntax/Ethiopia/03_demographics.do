
*	use individual panel to make demographics 
u "${tmp_hfps_eth}/ind.dta", clear

*	respondent characteristics
foreach x in sex age head pnl_rltn {
	bys household_id round (individual_id) : egen resp_`x' = max(`x' * cond(respond==1,1,.))
}
ren resp_pnl_rltn resp_relation


*	do we still have a respondent and a member for all
	*	rule is not strictly enforced that a single head be identified. 
bys household_id round (individual_id) : egen headtest = sum(head) 
bys household_id round (individual_id) : egen resptest = sum(respond) 
bys household_id round (individual_id) : egen memtest = sum(member) 
tab1 *test,m
assert resptest==1
assert memtest>=1


	*	restrict sample prior to construction of demographics
	keep if member==1

su 

g hhsize=1
*	assume all missing ages are labor age 
*	assume all missing sexes are female 
g m0_14 	= (sex==1 & inrange(age,0,14))
g m15_64	= (sex==1 & (inrange(age,15,64) | mi(age)))
g m65		= (sex==1 & (age>64 & !mi(age)))
g f0_14 	= (sex==2 & inrange(age,0,14))
g f15_64	= (sex>=2 & (inrange(age,15,64) | mi(age)))
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

	        collapse (sum) hhsize-adulteq (firstnm) resp_*, by(household_id round)	

sa "${tmp_hfps_eth}/demog.dta", replace
 
	  	  ex

*	validation work 		  
		  
u "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", clear
keep household_id complete_r* hhsize_r* m0_14_r* m15_64_r* m65_r* f0_14_r* f15_64_r* f65_r* adulteq_r*

reshape long complete_r hhsize_r m0_14_r m15_64_r m65_r f0_14_r f15_64_r f65_r adulteq_r	/*
*/	, i(household_id) j(round)
	  la val round 
	  la var round	"survey round"
	  
ta complete round, m
keep if complete==1
drop complete

mer 1:1 household_id round using "${tmp_hfps_eth}/demog.dta"
ta round _m

	keep if _m==3
	compare hhsize hhsize_r
	compare adulteq adulteq_r
	plot adulteq adulteq_r	// ignorable
	
	
	


u "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_ind.dta", clear
	  
	  keep household_id individual_id *_r* 
	  reshape long member_r head_r respond_r relation_r relation_os_r	/*
	  */	, i(household_id individual_id) j(round)
	  d round
	  la val round 
	  la var round	"survey round"
	  
	  
isid household_id individual_id round
mer 1:1  household_id individual_id round using "${tmp_hfps_eth}/p1_demog.dta"

ta round _m
keep if inrange(round,1,10)
ta round _m
ta household_id if _m==2
ta member member_r, m






