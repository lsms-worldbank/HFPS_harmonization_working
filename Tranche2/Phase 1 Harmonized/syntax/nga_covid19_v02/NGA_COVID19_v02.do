******************************************************************
**         COVID-19 Phone Survey Harmonized Data Project        **
**                                                              **
**                                                              **
**  Country: Nigeria	YEAR:  2018/2019   			          	**
**                                                              **
**  Program Name:  NGA_COVID19_v02.do		    		    	**
**                                                              **
**  Version: v01 (Round 0-11)                                   **
**                                                              **
**  Description: Generates harmonized dataset				    **
**                                                              **
**  Number of HHs (GHS-P WAVE 4 PH): 4,976                      **
**                                                              **
**  Household: hhid		    			  						**
**                                                              **
**  Program first written: August 23, 2021                   	**
**  Program last revised:                                    	**
**                                                              **
******************************************************************
** NOTE: * Added data up to R11. 
         * Revised disability and respondent variables.
		 * Added consumption variables. 


set more off

** TOTAL NUMBER OF HOUSEHOLDS IN THE LAST FACE-TO-FACE SURVEY
      global totalHH 4976	
	  
** NUMBER OF PHONE SURVEY ROUNDS TO BE HARMONIZED
      global round 11

** PHONE SURVEY ROUNDS WITH FIES QUESTIONS	  
      global fies 0 2 4

****************************************************
**              HOUSEHOLD LEVEL DATA              **
****************************************************

***************************************
**            ROUND 0                **
***************************************

** OPEN DATA 
      use "$original\Round 0\Post Harvest\Household\secta_harvestw4.dta", clear
	  
** GENERATE VARIABLES
      //basic household information
	     mmerge hhid using "$original\Round 0\NGA_HouseholdGeovars_Y4.dta", ukeep(lat_dd_mod lon_dd_mod) unmatched(master)
         gen year=2018
		 gen wt_r0=wt_wave4
	     gen rural=sector
		 gen ea_latitude=lat_dd_mod 
		 gen ea_longitude=lon_dd_mod
		 
		 label variable zone "Zone Code"
		 label variable state "State Code"
		 label variable ea "EA Code"
		 keep hhid-lga ea year-ea_longitude interview_result
	
	  //dwelling information	 
	     mmerge hhid using "$original\Round 0\Post Planting\Household\sect11_plantingw4.dta", ukeep(s11q1 s11q6 s11q6_os s11q7 s11q7b s11q8 s11q8b s11q9 s11q47 s11q36* s11q33b* s11q59 s11q60*) unmatched(master)
	     gen dwelling=(s11q1==1 & s11q1!=.) 
	     gen roof=(inlist(s11q7,2,3,4,5,6,8,9) & s11q7!=.)
		 recode roof (0=1) if inlist(s11q7b,"ALLUMINIUM","ZINC","ZINC ROOF","ZNIC")
	     gen floor=(inlist(s11q8,3,4,5,7) & s11q8!=.)
	     gen walls=(inlist(s11q6,4,5,7) & s11q6!=.)
	     gen toilet=(inlist(s11q36,1,2,3,6,7,9,14) & s11q36!=.)
	     gen water=(inlist(s11q60,1,2,3,4,5,6,8,10,11,12,14,15) & s11q60!=.)
		 recode water (0=1) if (inlist(s11q33b,1,2,3,4,5,6,8,10,11,12,14,15) & s11q33b!=. & s11q60==. & s11q59==1)
	     gen rooms=s11q9
	     gen elect=(s11q47==1)
		 drop s11q1-_merge

	  //asset information
	     preserve
		    use "$original\Round 0\Post Planting\Household\sect5_plantingw4.dta",clear
			gen tv=(item_cd==327 & s5q1a==1)
			gen radio=(item_cd==322 & s5q1a==1)
			gen refrigerator=(item_cd==312 & s5q1a==1)
			gen bicycle=(item_cd==317 & s5q1a==1)
			gen mcycle=(item_cd==318 & s5q1a==1)
			gen car=(item_cd==319 & s5q1a==1)
			gen mphone=(inlist(item_cd,3321,3322) & s5q1a==1)		
			gen computer=(item_cd==328 & s5q1a==1)		 
			gen generator=(item_cd==320 & s5q1a==1)		
			collapse (max) tv-generator, by(hhid)
			//assume NO for missing cases
			   recode tv-generator (.=0)
			tempfile asset
			save `asset', replace
		 restore		
         mmerge hhid using `asset', unmatched(master)
	     preserve
		    use "$original\Round 0\Post Planting\Household\sect4b_plantingw4.dta",clear         
	        gen internet=(s4bq15__1==1|s4bq15__2==1)
			collapse (max) internet, by(hhid)
			tempfile internet
			save `internet', replace
         restore
		 mmerge hhid using `internet', unmatched(master)
		 
	  //finance and income information	
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect13_harvestw4", clear
	        gen rent=(source_cd==102 & s13q1==1)
			collapse (max) rent, by(hhid)
			tempfile rent
			save `rent', replace
		 restore
		 mmerge hhid using `rent', unmatched(master)
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect6_harvestw4", clear		 
	        gen remit=(s6q1__1==1|s6q1__2==1|s6q1__3==1|s6q1__4==1)
			collapse (max) remit, by(hhid)
			tempfile remittance
			save `remittance', replace
		 restore	
		 mmerge hhid using `remittance', unmatched(master)
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect14a_harvestw4", clear		 
	        gen assist=(s14q1b==1)
			collapse (max) assist, by(hhid)
			tempfile assistance
			save `assistance', replace		 
		 restore	
		 mmerge hhid using `assistance', unmatched(master) 
	     preserve
		    use "$original\Round 0\Post Planting\Household\sect4a1_plantingw4", clear
			gen finance=(s4aq1==1|s4aq8==1)
			collapse (max) finance, by(hhid)
			tempfile finance
			save `finance', replace
		 restore	
		 mmerge hhid using `finance', unmatched(master) 	     
		 
	  //labor information
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect3a_harvestw4", clear
			mmerge hhid indiv using "$original\Round 0\Post Harvest\Household\sect1_harvestw4", ukeep(s1q4) unmatched(master)
	        gen ag=(s3q5==1 & inrange(s1q4,15,64))
	        gen nfe=(s3q6==1 & inrange(s1q4,15,64))
	        gen ext=(s3q4==1 & inrange(s1q4,15,64))
	        gen any=(ag==1|nfe==1|ext==1|(s3q7a==1 & inrange(s1q4,15,64)))    
			gen person=(inrange(s1q4,15,64))
			collapse (sum) ag-person, by(hhid)
			gen ag_work=ag/person*100
			gen nfe_work=nfe/person*100
			gen ext_work=ext/person*100
			gen any_work=any/person*100
			keep hhid ag_work-any_work
			tempfile work
			save `work', replace
         restore
		 mmerge hhid using `work', unmatched(master)
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect9a_harvestw4", clear	
			gen nfe=(s9q1d==1)
			keep hhid nfe
			tempfile nfe
			save `nfe', replace
         restore
		 mmerge hhid using `nfe', unmatched(master)	
	 
	  //land information    
	     preserve
		    use "$original\Round 0\Post Planting\Agriculture\sect11a1_plantingw4", clear
		    mmerge hhid plotid using "$original\Round 0\Post Planting\Agriculture\sect11b1_plantingw4"		 
			
	        //generating estimated conversions for self reported (even standard units)
		       gen conv = s11aq4c/ s11aq4aa
		       egen med_conv_zn = median(conv), by(zone s11aq4b)
		       gen SR_ha = (s11aq4aa*med_conv_zn)/10000
		         
			//plot area
		        gen plotsize = s11aq4c/10000
		        replace plotsize = SR_ha if plotsize==.
				
		        //winsorize
			       winsor2 plotsize, cuts(1 99) by(zone)
			
	        egen land_tot=sum(plotsize_w*(inlist(s11b1q4,1,4,5))), by(hhid)
		    note land_tot: Limited to agricultural land. 
		    gen land=(land_tot!=0)		 
		    note land: Limited to agricultural land.
		    egen land_cultivated = sum(plotsize_w*(s11b1q27==1)), by(hhid)
			gen crop=(land_cultivated!=0)
		    keep hhid land* crop
		 	duplicates drop
		    isid hhid
		    tempfile land 
			save `land', replace
		 restore
		 mmerge hhid using `land', unmatched(master)
		 recode land crop (.=0)
		 recode land_tot (.=0) if land==0
		 recode land_cultivated (.=0) if crop==0
		 order land land_tot crop land_cultivated, after(nfe)
		 drop _merge
	
	  //food security information	
	     mmerge hhid using "$original\Round 0\NG_FIES_harvest_full.dta", umatch(HHID) ukeep(p_mod p_sev)
	     gen fies_mod_r0=(p_mod>=0.5 & p_mod!=.)
	     gen fies_sev_r0=(p_sev>=0.5 & p_sev!=.)
		 drop p_mod p_sev

	  //consumption information
	     preserve
	        use "$original\Round 0\totcons_final.dta", clear
		    mmerge hhid using "$original\Round 0\Post Harvest\Household\secta_harvestw4.dta", ukeep(wt_wave4) unmatched(master)
			assert _m==3
			egen foodcons=rowtotal(food_own1-food_meals20)
	        egen nonfoodcons=rowtotal(nonfood21-rent33)
	        gen double totcons=foodcons+nonfoodcons	
	        gen foodcons_adj=foodcons/reg_def_mean
	        gen nonfoodcons_adj=nonfoodcons/reg_def_mean
			drop totcons_adj
			gen double totcons_adj=foodcons_adj+nonfoodcons_adj
	        xtile cons_quint=totcons_adj_norm [pw=wt_wave4], nq(5)			
			keep hhid cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj
			tempfile cons
			save `cons', replace
         restore
		 mmerge hhid using `cons', unmatched(master)	
         
		
	  //agricultural information
	     preserve
		    use "$original\Round 0\Post Planting\Agriculture\sect11f_plantingw4.dta", clear 
		    gen crop_number=1
			gen cash_crop=(inlist(cropcode,1060,3040,3180,2040))
			collapse (sum) crop_number (max) cash_crop, by(hhid)
			tempfile crop_number
			save `crop_number', replace
		 restore
		 mmerge hhid using `crop_number', unmatched(master)
		 note cash_crop: GROUND NUT/PEANUTS, COCOA, OIL PALM FRUIT and BEENI-SEED/SESAME	
		 
	     preserve
		    use "$original\Round 0\Post Harvest\Agriculture\secta11c2_harvestw4.dta", clear
			gen org_fert=(s11dq36==1)
			gen inorg_fert=(s11dq1a==1)
			gen pest_fung_herb=(s11c2q1==1|s11c2q10==1)
			collapse (max) org_fert inorg_fert pest_fung_herb, by(hhid)
			tempfile fertilizer
			save `fertilizer', replace
		 restore
		 mmerge hhid using `fertilizer', unmatched(master)
		 
	     preserve
		    use "$original\Round 0\Post Planting\Agriculture\sect11c1b_plantingw4.dta", clear
			mmerge hhid plotid using "$original\Round 0\Post Harvest\Agriculture\secta2b_harvestw4.dta"
			gen hired_lab=(s11c1q2a==1|s11c1q5a==1|s11c1q8a==1|sa2bq2a==1|sa2bq5a==1|sa2bq8a==1)
			gen ex_fr_lab=(s11c1q13a==1|s11c1q13b==1|s11c1q13c==1|sa2bq13a==1|sa2bq13b==1|sa2bq13c==1)
			collapse (max) hired_lab ex_fr_lab, by(hhid)
			tempfile ag_labor
			save `ag_labor', replace
		 restore
		 mmerge hhid using `ag_labor', unmatched(master)
		 
		 //for those are missing, assume NO
		    recode hired_lab ex_fr_lab (.=0) if crop==1		
			
	     preserve
		    use "$original\Round 0\Post Planting\Agriculture\sect11b1_plantingw4.dta", clear
            gen tractor=(s11b1q11a==1)
			collapse (max) tractor, by(hhid)
		    tempfile tractor
			save `tractor', replace
		 restore
		 mmerge hhid using `tractor', unmatched(master)
		 replace tractor=. if crop==0			
		 preserve
		    use "$original\Round 0\Post Harvest\Agriculture\sectaphl2_harvestw4", clear
			gen hired_lab_ph=(phl_q02_1==1|phl_q02_2==1|phl_q02_3==1)
			gen ex_fr_lab_ph=(phl_q08__1==1|phl_q08__2==1|phl_q08__3==1)
			collapse (max) hired_lab_ph ex_fr_lab_ph, by(hhid)
			tempfile ag_labor_ph
			save `ag_labor_ph', replace
		 restore
		 mmerge hhid using `ag_labor_ph', unmatched(master)
		 
		 //for those are missing, assume NO
            recode  hired_lab_ph ex_fr_lab_ph (.=0) if crop==1
			
		 preserve
		    use "$original\Round 0\Post Harvest\Agriculture\secta3ii_harvestw4.dta", clear 
			gen sell_crop=(sa3iiq3==1|sa3iiq10a_9==1)
			gen sell_unprocess=(sa3iiq3==1)
			gen sell_process=(sa3iiq10a_9==1)
			gen ph_loss=(sa3iiq10a_8==1)
			collapse (max) sell_crop sell_unprocess sell_process ph_loss, by(hhid)
			tempfile harvest
			save `harvest', replace
		 restore
		 mmerge hhid using `harvest', unmatched(master) 
		 //for those are missing, assume NO
            recode  sell_crop sell_unprocess sell_process ph_loss (.=0) if crop==1
			
		 order crop crop_number cash_crop org_fert inorg_fert pest_fung_herb tractor hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ph_loss sell_crop sell_unprocess sell_process, after(cons_quint)
	
	  //livestock information
	     preserve
		    use "$original\Round 0\Post Planting\Agriculture\sect11i_plantingw4.dta", clear
	        gen lruminant=(livestock_cd==1 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
	        gen sruminant=(livestock_cd==3 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
	        gen poultry=(livestock_cd==5 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
			recode poultry (0=1) if animal_other=="PIGEON" & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0))
	        gen equines=(livestock_cd==2 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
	        gen camelids=(livestock_cd==6 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
	        gen pig=(livestock_cd==4 & (s11iq2b==1|(s11iq2b==2 & s11iq2!=0)))
	        gen bee=.
			note bee: Data not collected.
	        gen livestock=(lruminant==1|sruminant==1|poultry==1|equines==1|camelids==1|pig==1)			
			collapse (max) lruminant-livestock, by(hhid)
			tempfile livestock
			save `livestock', replace
		 restore
		 mmerge hhid using `livestock', unmatched(master)
		 recode lruminant-pig livestock (.=0)
		 
	  //demographic information
	     preserve
		    use "$original\Round 0\Post Harvest\Household\sect1_harvestw4", clear
			drop if s1q4a==2
		    gen hhsize_r0=1
		    gen m0_14_r0  = 1  if (s1q2==1 & inrange(s1q4,0,14)) 
		    gen m15_64_r0 = 1 if (s1q2==1 & inrange(s1q4,15,64))
		    gen m65_r0    = 1 if (s1q2==1 & s1q4>=65 & s1q4!=.) 
		    gen f0_14_r0  = 1 if (s1q2==2 & inrange(s1q4,0,14)) 
		    gen f15_64_r0 = 1 if (s1q2==2 & inrange(s1q4,15,64))
		    gen f65_r0    = 1 if (s1q2==2 & s1q4>=65 & s1q4!=.) 
		    gen adulteq_r0=. 
            replace adulteq_r0 = 0.27 if (s1q2==1 & s1q4==0) 
            replace adulteq_r0 = 0.45 if (s1q2==1 & inrange(s1q4,1,3)) 
            replace adulteq_r0 = 0.61 if (s1q2==1 & inrange(s1q4,4,6)) 
            replace adulteq_r0 = 0.73 if (s1q2==1 & inrange(s1q4,7,9)) 
            replace adulteq_r0 = 0.86 if (s1q2==1 & inrange(s1q4,10,12)) 
            replace adulteq_r0 = 0.96 if (s1q2==1 & inrange(s1q4,13,15)) 
            replace adulteq_r0 = 1.02 if (s1q2==1 & inrange(s1q4,16,19)) 
            replace adulteq_r0 = 1.00 if (s1q2==1 & s1q4 >=20) 
            replace adulteq_r0 = 0.27 if (s1q2==2 & s1q4 ==0) 
            replace adulteq_r0 = 0.45 if (s1q2==2 & inrange(s1q4,1,3)) 
            replace adulteq_r0 = 0.61 if (s1q2==2 & inrange(s1q4,4,6)) 
            replace adulteq_r0 = 0.73 if (s1q2==2 & inrange(s1q4,7,9)) 
            replace adulteq_r0 = 0.78 if (s1q2==2 & inrange(s1q4,10,12)) 
            replace adulteq_r0 = 0.83 if (s1q2==2 & inrange(s1q4,13,15)) 
            replace adulteq_r0 = 0.77 if (s1q2==2 & inrange(s1q4,16,19)) 
            replace adulteq_r0 = 0.73 if (s1q2==2 & s1q4 >=20)      
			collapse (sum) hhsize_r0-adulteq_r0, by(hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize', unmatched(master)
		 drop _m

** KEEP ONLY HHS WITH COMPLETED INTERVIEW
      keep if interview_result==1
	  drop interview_result
	  
** SAVE INTERMEDIATE FILES
      save "$intermed\Round0_hh.dta", replace
		 
***************************************
**            ROUND 1                **
***************************************	
** GENERATE VARIABLES	 
	  //interview results
         use "$original\Round 1\sect12_interview_result", clear
		 gen phone_sample=1		 
		 gen contact_r1=(inrange(s12q5,1,3))		 
		 gen interview_r1=(inlist(s12q5,1,2)) if contact_r1==1
		 gen complete_r1=(s12q5==1) if interview_r1==1
	     keep hhid phone_sample contact_r1 interview_r1 complete_r1
		 
	  //weights
	     mmerge hhid using "$original\Round 1\secta_cover", ukeep(wt_baseline) urename(wt_baseline wt_r1)
		 assert _m==3	
		 
	  //demographic information
	     preserve
		 use "$original\Round 1\sect2_household_roster", clear
	        drop if s2q3==2
		    gen hhsize_r1=1
		    gen m0_14_r1  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r1 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r1    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r1  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r1 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r1    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r1=. 
            replace adulteq_r1 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r1 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r1 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r1 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r1 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r1 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r1 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r1 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r1 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r1 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r1 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r1 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r1 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r1 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r1 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r1 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r1-adulteq_r1, by(hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'
		 foreach x in hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 {
		 	replace `x'=. if complete_r1!=1
		 }
		 keep hhid *_r1 phone_sample
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round1_hh.dta", replace
	  
***************************************
**            ROUND 2                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 2\sect12_interview_result", clear
		 gen contact_r2=(inrange(s12q5,1,3))		 
		 gen interview_r2=(inlist(s12q5,1,2)) if contact_r2==1
		 gen complete_r2=(s12q5==1) if interview_r2==1
	     keep hhid contact_r2 interview_r2 complete_r2
	
	  //weights
	     mmerge hhid using "$original\Round 2\secta_cover", ukeep(wt_round2) urename(wt_round2 wt_r2)
		 assert _m==3
		 
	  //demographic information
	     preserve
		 use "$original\Round 2\sect2_household_roster", clear
	        drop if s2q3==2
		    gen hhsize_r2=1
		    gen m0_14_r2  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r2 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r2    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r2  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r2 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r2    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r2=. 
            replace adulteq_r2 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r2 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r2 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r2 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r2 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r2 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r2 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r2 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r2 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r2 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r2 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r2 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r2 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r2 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r2 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r2 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r2-adulteq_r2, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	   
         loc x hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2
		 foreach X in `x' {
		 	replace `X'=. if complete_r2!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 2\NG_FIES_round2", clear
			destring HHID, gen(hhid) 
		    gen fies_mod_r2=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r2=(p_sev>=0.5 & p_sev!=.)
			keep hhid *_r2
			tempfile fies_r2
			save `fies_r2', replace
		 restore
		 mmerge hhid using `fies_r2', unmatched(master)
		 keep hhid *_r2

** SAVE INTERMEDIATE FILES
      save "$intermed\Round2_hh.dta", replace
	  
***************************************
**            ROUND 3                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 3\sect12_interview_result", clear
		 gen contact_r3=(inrange(s12q5,1,3))		 
		 gen interview_r3=(inlist(s12q5,1,2)) if contact_r3==1
		 gen complete_r3=(s12q5==1) if interview_r3==1
	     keep hhid contact_r3 interview_r3 complete_r3
	
	  //weights
	     mmerge hhid using "$original\Round 3\secta_cover", ukeep(wt_round3 wt_r3panel) urename(wt_round3 wt_r3\wt_r3panel wt_panel_r3)
		 assert _m==3

	  //demographic information
	     preserve
		 use "$original\Round 3\sect2_household_roster", clear
	        drop if s2q3==2
		    gen hhsize_r3=1
		    gen m0_14_r3  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r3 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r3    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r3  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r3 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r3    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r3=. 
            replace adulteq_r3 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r3 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r3 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r3 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r3 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r3 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r3 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r3 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r3 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r3 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r3 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r3 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r3 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r3 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r3 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r3 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r3-adulteq_r3, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3
		 foreach X in `x' {
		 	replace `X'=. if complete_r3!=1
		 }		 
		 keep hhid *_r3
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round3_hh.dta", replace
	  
***************************************
**            ROUND 4                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 4\r4_sect_a_2_5_5b_6_8_9_12", clear
		 gen contact_r4=(inrange(s12q5,1,3))		 
		 gen interview_r4=(inlist(s12q5,1,2)) if contact_r4==1
		 gen complete_r4=(s12q5==1) if interview_r4==1
		 rename wt_round4 wt_r4
		 rename wt_r4panel wt_panel_r4
	     keep hhid contact_r4 interview_r4 complete_r4 wt_r4 wt_panel_r4

	  //demographic information
	     preserve
		    use "$original\Round 4\r4_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r4=1
		    gen m0_14_r4  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r4 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r4    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r4  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r4 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r4    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r4=. 
            replace adulteq_r4 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r4 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r4 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r4 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r4 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r4 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r4 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r4 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r4 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r4 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r4 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r4 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r4 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r4 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r4 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r4 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r4-adulteq_r4, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4
		 foreach X in `x' {
		 	replace `X'=. if complete_r4!=1
		 }		 
		 
	  //fies
	     preserve
	        use "$original\Round 4\NG_FIES_round4", clear
			destring HHID, gen(hhid) 
		    gen fies_mod_r4=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r4=(p_sev>=0.5 & p_sev!=.)
			keep hhid *_r4
			tempfile fies_r4
			save `fies_r4', replace
		 restore
		 mmerge hhid using `fies_r4', unmatched(master)		 
		 keep hhid *_r4
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round4_hh.dta", replace
	  
***************************************
**            Round 5                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 5\r5_sect_a_2_5c_6_12", clear
		 gen contact_r5=(inrange(s12q5,1,3))		 
		 gen interview_r5=(inlist(s12q5,1,2)) if contact_r5==1
		 gen complete_r5=(s12q5==1) if interview_r5==1
		 rename wt_round5 wt_r5
		 rename wt_r5panel wt_panel_r5
	     keep hhid contact_r5 interview_r5 complete_r5 wt_r5 wt_panel_r5

	  //demographic information
	     preserve
		    use "$original\Round 5\r5_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r5=1
		    gen m0_14_r5  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r5 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r5    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r5  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r5 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r5    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r5=. 
            replace adulteq_r5 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r5 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r5 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r5 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r5 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r5 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r5 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r5 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r5 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r5 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r5 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r5 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r5 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r5 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r5 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r5 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r5-adulteq_r5, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5
		 foreach X in `x' {
		 	replace `X'=. if complete_r5!=1
		 }		 
		 
		 keep hhid *_r5
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round5_hh.dta", replace
	
***************************************
**            Round 6                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 6\r6_sect_a_2_3a_6_9a_12", clear
		 gen contact_r6=(inrange(s12q5,1,3))		 
		 gen interview_r6=(inlist(s12q5,1,2)) if contact_r6==1
		 gen complete_r6=(s12q5==1) if interview_r6==1
		 rename wt_round6 wt_r6
		 rename wt_r6panel wt_panel_r6
	     keep hhid contact_r6 interview_r6 complete_r6 wt_r6 wt_panel_r6

	  //demographic information
	     preserve
		    use "$original\Round 6\r6_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r6=1
		    gen m0_14_r6  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r6 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r6    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r6  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r6 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r6    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r6=. 
            replace adulteq_r6 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r6 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r6 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r6 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r6 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r6 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r6 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r6 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r6 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r6 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r6 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r6 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r6 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r6 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r6 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r6 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r6-adulteq_r6, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6
		 foreach X in `x' {
		 	replace `X'=. if complete_r6!=1
		 }		 
		 
		 keep hhid *_r6
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round6_hh.dta", replace
	  
***************************************
**            Round 7                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 7\r7_sect_a_5_6_8_9_12", clear
		 gen contact_r7=(inrange(s12q5,1,3))		 
		 gen interview_r7=(inlist(s12q5,1,2)) if contact_r7==1
		 gen complete_r7=(s12q5==1) if interview_r7==1
		 rename wt_round7 wt_r7
		 rename wt_r7panel wt_panel_r7
	     keep hhid contact_r7 interview_r7 complete_r7 wt_r7 wt_panel_r7

	  //demographic information
	     preserve
		    use "$original\Round 7\r7_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r7=1
		    gen m0_14_r7  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r7 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r7    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r7  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r7 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r7    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r7=. 
            replace adulteq_r7 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r7 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r7 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r7 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r7 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r7 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r7 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r7 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r7 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r7 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r7 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r7 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r7 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r7 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r7 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r7 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r7-adulteq_r7, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7
		 foreach X in `x' {
		 	replace `X'=. if complete_r7!=1
		 }		 
		 
		 keep hhid *_r7
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round7_hh.dta", replace	
	  
	  
***************************************
**            Round 8                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 8\r8_sect_a_2_6_12", clear
		 gen contact_r8=(inrange(s12q5,1,3))		 
		 gen interview_r8=(inlist(s12q5,1,2)) if contact_r8==1
		 gen complete_r8=(s12q5==1) if interview_r8==1
		 rename wt_round8 wt_r8
		 rename wt_r8panel wt_panel_r8
	     keep hhid contact_r8 interview_r8 complete_r8 wt_r8 wt_panel_r8

	  //demographic information
	     preserve
		    use "$original\Round 8\r8_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r8=1
		    gen m0_14_r8  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r8 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r8    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r8  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r8 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r8    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r8=. 
            replace adulteq_r8 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r8 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r8 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r8 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r8 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r8 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r8 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r8 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r8 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r8 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r8 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r8 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r8 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r8 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r8 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r8 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r8-adulteq_r8, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8
		 foreach X in `x' {
		 	replace `X'=. if complete_r8!=1
		 }		 
		 
		 keep hhid *_r8
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round8_hh.dta", replace	  
	  
***************************************
**            Round 9                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 9\r9_sect_a_2_5_5c_5d_6_12", clear
		 gen contact_r9=(inrange(s12q5,1,3))		 
		 gen interview_r9=(inlist(s12q5,1,2)) if contact_r9==1
		 gen complete_r9=(s12q5==1) if interview_r9==1
		 rename wt_round9 wt_r9
		 rename wt_r9panel wt_panel_r9
	     keep hhid contact_r9 interview_r9 complete_r9 wt_r9 wt_panel_r9

	  //demographic information
	     preserve
		    use "$original\Round 9\r9_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r9=1
		    gen m0_14_r9  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r9 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r9    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r9  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r9 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r9    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r9=. 
            replace adulteq_r9 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r9 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r9 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r9 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r9 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r9 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r9 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r9 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r9 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r9 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r9 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r9 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r9 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r9 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r9 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r9 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r9-adulteq_r9, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9
		 foreach X in `x' {
		 	replace `X'=. if complete_r9!=1
		 }		 
		 
		 keep hhid *_r9
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round9_hh.dta", replace	  	  
	  
***************************************
**            Round 10                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 10\r10_sect_a_2_5_6_9_9a_12", clear
		 gen contact_r10=(inrange(s12q5,1,3))		 
		 gen interview_r10=(inlist(s12q5,1,2)) if contact_r10==1
		 gen complete_r10=(s12q5==1) if interview_r10==1
		 rename wt_round10 wt_r10
		 rename wt_r10panel wt_panel_r10
	     keep hhid contact_r10 interview_r10 complete_r10 wt_r10 wt_panel_r10

	  //demographic information
	     preserve
		    use "$original\Round 10\r10_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r10=1
		    gen m0_14_r10  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r10 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r10    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r10  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r10 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r10    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r10=. 
            replace adulteq_r10 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r10 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r10 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r10 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r10 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r10 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r10 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r10 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r10 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r10 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r10 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r10 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r10 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r10 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r10 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r10 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r10-adulteq_r10, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r10 m0_14_r10 m15_64_r10 m65_r10 f0_14_r10 f15_64_r10 f65_r10 adulteq_r10
		 foreach X in `x' {
		 	replace `X'=. if complete_r10!=1
		 }		 
		 
		 keep hhid *_r10
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round10_hh.dta", replace	
	 
***************************************
**            Round 11                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 11\r11_sect_a_2_5_5b_6_12b_12", clear
		 gen contact_r11=(inrange(s12q5,1,3))		 
		 gen interview_r11=(inlist(s12q5,1,2)) if contact_r11==1
		 gen complete_r11=(s12q5==1) if interview_r11==1
		 rename wt_round11 wt_r11
		 rename wt_r11panel wt_panel_r11
	     keep hhid contact_r11 interview_r11 complete_r11 wt_r11 wt_panel_r11

	  //demographic information
	     preserve
		    use "$original\Round 11\r11_sect_2", clear
	        drop if s2q3==2
		    gen hhsize_r11=1
		    gen m0_14_r11  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r11 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r11    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r11  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r11 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r11    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r11=. 
            replace adulteq_r11 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r11 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r11 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r11 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r11 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r11 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r11 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r11 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r11 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r11 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r11 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r11 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r11 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r11 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r11 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r11 = 0.73 if (s2q5==2 & s2q6 >=20)      
	        collapse (sum) hhsize_r11-adulteq_r11, by(hhid)	
			save `hhsize', replace
		 restore
		 mmerge hhid using `hhsize'	
         loc x hhsize_r11 m0_14_r11 m15_64_r11 m65_r11 f0_14_r11 f15_64_r11 f65_r11 adulteq_r11
		 foreach X in `x' {
		 	replace `X'=. if complete_r11!=1
		 }		 
		 
		 keep hhid *_r11
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round11_hh.dta", replace	
	  	 
***************************************
**          HEAD CHANGE              **
***************************************
** GENERATE HOUSEHOLD HEAD ID
      use "$original\Round 0\Post Harvest\Household\sect1_harvestw4", clear
	  keep if s1q3==1
	  drop if inlist(hhid,99002,159067,249203,270008)
	  rename indiv headid_r0
	  keep hhid headid_r0
	  isid hhid
	  preserve
         use "$original\Round 1\sect2_household_roster", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r1
		 keep hhid headid_r1
		 isid hhid
		 tempfile headid_r1
		 save `headid_r1', replace
	  restore
	  mmerge hhid using `headid_r1'
	  preserve
         use "$original\Round 2\sect2_household_roster", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r2
		 keep hhid headid_r2
		 isid hhid
		 tempfile headid_r2
		 save `headid_r2', replace
	  restore
	  mmerge hhid using `headid_r2'	  
	  preserve
         use "$original\Round 3\sect2_household_roster", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r3
		 keep hhid headid_r3
		 isid hhid
		 tempfile headid_r3
		 save `headid_r3', replace
	  restore
	  mmerge hhid using `headid_r3'
	  preserve
         use "$original\Round 4\r4_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r4
		 keep hhid headid_r4
		 isid hhid
		 tempfile headid_r4
		 save `headid_r4', replace
	  restore
	  mmerge hhid using `headid_r4'	
	  preserve
         use "$original\Round 5\r5_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r5
		 keep hhid headid_r5
		 isid hhid
		 tempfile headid_r5
		 save `headid_r5', replace
	  restore	  
	  mmerge hhid using `headid_r5'	  
	  preserve
         use "$original\Round 6\r6_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r6
		 keep hhid headid_r6
		 isid hhid
		 tempfile headid_r6
		 save `headid_r6', replace
	  restore	  
	  mmerge hhid using `headid_r6'	  
	  preserve
         use "$original\Round 7\r7_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r7
		 keep hhid headid_r7
		 isid hhid
		 tempfile headid_r7
		 save `headid_r7', replace
	  restore	
	  mmerge hhid using `headid_r7'		  
	  preserve
         use "$original\Round 8\r8_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r8
		 keep hhid headid_r8
		 isid hhid
		 tempfile headid_r8
		 save `headid_r8', replace
	  restore		  	  	 
	  mmerge hhid using `headid_r8'	 
	  preserve
         use "$original\Round 9\r9_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r9
		 keep hhid headid_r9
		 isid hhid
		 tempfile headid_r9
		 save `headid_r9', replace
	  restore		  	  	 
	  mmerge hhid using `headid_r9'		  
	  preserve
         use "$original\Round 10\r10_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r10
		 keep hhid headid_r10
		 isid hhid
		 tempfile headid_r10
		 save `headid_r10', replace
	  restore		  	  	 
	  mmerge hhid using `headid_r10'	
	  preserve
         use "$original\Round 11\r11_sect_2", clear
	     keep if s2q7==1|s2q9==1
		 rename indiv headid_r11
		 keep hhid headid_r11
		 isid hhid
		 tempfile headid_r11
		 save `headid_r11', replace
	  restore		  	  	 
	  mmerge hhid using `headid_r11'	  
	  mmerge hhid using "$intermed\Round1_hh.dta", ukeep(complete_r1)	  
	  mmerge hhid using "$intermed\Round2_hh.dta", ukeep(complete_r2)
	  mmerge hhid using "$intermed\Round3_hh.dta", ukeep(complete_r3)	
	  mmerge hhid using "$intermed\Round4_hh.dta", ukeep(complete_r4)	
	  mmerge hhid using "$intermed\Round5_hh.dta", ukeep(complete_r5)
	  mmerge hhid using "$intermed\Round6_hh.dta", ukeep(complete_r6)
	  mmerge hhid using "$intermed\Round7_hh.dta", ukeep(complete_r7)
	  mmerge hhid using "$intermed\Round8_hh.dta", ukeep(complete_r8)	  
	  mmerge hhid using "$intermed\Round9_hh.dta", ukeep(complete_r9)	
	  mmerge hhid using "$intermed\Round10_hh.dta", ukeep(complete_r10)	
	  mmerge hhid using "$intermed\Round11_hh.dta", ukeep(complete_r11)	  
	  forvalues i=1/$round {
	     replace headid_r`i'=. if complete_r`i'!=1
	  }
	  gen head_chg_r1=(headid_r0!=headid_r1) if complete_r1==1 
	  gen head_chg_r2=(headid_r1!=headid_r2) if complete_r2==1
      gen head_chg_r3=(headid_r2!=headid_r3) if complete_r3==1 & complete_r2==1
	  recode head_chg_r3 (.=0) if (headid_r1==headid_r3) & complete_r3==1 & complete_r2!=1
	  recode head_chg_r3 (.=1) if (headid_r1!=headid_r3) & complete_r3==1 & complete_r2!=1
	  gen head_chg_r4=(headid_r3!=headid_r4) if complete_r4==1 & complete_r3==1	  
	  recode head_chg_r4 (.=0) if (headid_r2==headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2==1  
	  recode head_chg_r4 (.=1) if (headid_r2!=headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r4 (.=0) if (headid_r1==headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2!=1	& complete_r1==1		  
	  recode head_chg_r4 (.=1) if (headid_r1!=headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  gen head_chg_r5=(headid_r4!=headid_r5) if complete_r5==1 & complete_r4==1	 	  
	  recode head_chg_r5 (.=0) if (headid_r3==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r5 (.=1) if (headid_r3!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r5 (.=0) if (headid_r2==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r5 (.=1) if (headid_r2!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r5 (.=0) if (headid_r1==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r5 (.=1) if (headid_r1!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  gen head_chg_r6=(headid_r5!=headid_r6) if complete_r6==1 & complete_r5==1	 	  
	  recode head_chg_r6 (.=0) if (headid_r4==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=1) if (headid_r4!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=0) if (headid_r3==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r6 (.=1) if (headid_r3!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r6 (.=0) if (headid_r2==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r6 (.=1) if (headid_r2!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1	  
	  recode head_chg_r6 (.=0) if (headid_r1==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r6 (.=1) if (headid_r1!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1     
	  gen head_chg_r7=(headid_r6!=headid_r7) if complete_r7==1 & complete_r6==1	 	  
	  recode head_chg_r7 (.=0) if (headid_r5==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r7 (.=1) if (headid_r5!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r7 (.=0) if (headid_r4==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r7 (.=1) if (headid_r4!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r7 (.=0) if (headid_r3==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r7 (.=1) if (headid_r3!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1	  
	  recode head_chg_r7 (.=0) if (headid_r2==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r7 (.=1) if (headid_r2!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 	  
	  recode head_chg_r7 (.=0) if (headid_r1==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r7 (.=1) if (headid_r1!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1 	  
	  gen head_chg_r8=(headid_r7!=headid_r8) if complete_r8==1 & complete_r7==1	 	  
	  recode head_chg_r8 (.=0) if (headid_r6==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r8 (.=1) if (headid_r6!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r8 (.=0) if (headid_r5==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r8 (.=1) if (headid_r5!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r8 (.=0) if (headid_r4==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r8 (.=1) if (headid_r4!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1	  
	  recode head_chg_r8 (.=0) if (headid_r3==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r8 (.=1) if (headid_r3!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 	  
	  recode head_chg_r8 (.=0) if (headid_r2==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r8 (.=1) if (headid_r2!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 	 
	  recode head_chg_r8 (.=0) if (headid_r1==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1
	  recode head_chg_r8 (.=1) if (headid_r1!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1 
	  gen head_chg_r9=(headid_r8!=headid_r9) if complete_r9==1 & complete_r8==1	 	  
	  recode head_chg_r9 (.=0) if (headid_r7==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=1) if (headid_r7!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=0) if (headid_r6==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r9 (.=1) if (headid_r6!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r9 (.=0) if (headid_r5==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r9 (.=1) if (headid_r5!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1	  
	  recode head_chg_r9 (.=0) if (headid_r4==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r9 (.=1) if (headid_r4!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1 	  
	  recode head_chg_r9 (.=0) if (headid_r3==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r9 (.=1) if (headid_r3!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 	 
	  recode head_chg_r9 (.=0) if (headid_r2==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1  & complete_r2==1
	  recode head_chg_r9 (.=1) if (headid_r2!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1  & complete_r2==1 	
	  recode head_chg_r9 (.=0) if (headid_r1==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1  & complete_r2!=1 & complete_r1==1
	  recode head_chg_r9 (.=1) if (headid_r1!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1  & complete_r2!=1 & complete_r1==1 	  
	  gen head_chg_r10=(headid_r9!=headid_r10) if complete_r10==1 & complete_r9==1	 	  
	  recode head_chg_r10 (.=0) if (headid_r8==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r10 (.=1) if (headid_r8!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r10 (.=0) if (headid_r7==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r10 (.=1) if (headid_r7!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r10 (.=0) if (headid_r6==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r10 (.=1) if (headid_r6!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1	  
	  recode head_chg_r10 (.=0) if (headid_r5==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r10 (.=1) if (headid_r5!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1 	  
	  recode head_chg_r10 (.=0) if (headid_r4==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r10 (.=1) if (headid_r4!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1 	 
	  recode head_chg_r10 (.=0) if (headid_r3==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3==1
	  recode head_chg_r10 (.=1) if (headid_r3!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3==1 	
	  recode head_chg_r10 (.=0) if (headid_r2==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3!=1 & complete_r2==1
	  recode head_chg_r10 (.=1) if (headid_r2!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r10 (.=0) if (headid_r1==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r10 (.=1) if (headid_r1!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1  & complete_r3!=1 & complete_r2!=1 & complete_r1==1	  
	  gen head_chg_r11=(headid_r10!=headid_r11) if complete_r11==1 & complete_r10==1	 	  
	  recode head_chg_r11 (.=0) if (headid_r9==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9==1
	  recode head_chg_r11 (.=1) if (headid_r9!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9==1
	  recode head_chg_r11 (.=0) if (headid_r8==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r11 (.=1) if (headid_r8!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r11 (.=0) if (headid_r7==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r11 (.=1) if (headid_r7!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1	  
	  recode head_chg_r11 (.=0) if (headid_r6==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r11 (.=1) if (headid_r6!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1 	  
	  recode head_chg_r11 (.=0) if (headid_r5==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r11 (.=1) if (headid_r5!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1 	 
	  recode head_chg_r11 (.=0) if (headid_r4==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4==1
	  recode head_chg_r11 (.=1) if (headid_r4!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4==1 	
	  recode head_chg_r11 (.=0) if (headid_r3==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3==1
	  recode head_chg_r11 (.=1) if (headid_r3!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3==1 
	  recode head_chg_r11 (.=0) if (headid_r2==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r11 (.=1) if (headid_r2!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r11 (.=0) if (headid_r1==headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r11 (.=1) if (headid_r1!=headid_r11) & complete_r11==1 & complete_r10!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1  & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1	  
	  keep hhid head_chg_r*
	    
** SAVE INTERMEDIATE FILES
      save "$intermed\Head.dta", replace
	  
***************************************
**       RESPONDENT CHANGE           **
***************************************	
** GENERATE RESPONDENT ID		 
      use "$original\Round 1\sect12_interview_result", clear
      rename s12q9 respid_r1
      keep hhid respid_r1
	  isid hhid
	  tempfile respid_r1
	  save `respid_r1', replace
	  preserve
         use "$original\Round 2\sect12_interview_result", clear
         rename s12q9 respid_r2
         keep hhid respid_r2
		 isid hhid
		 tempfile respid_r2
		 save `respid_r2', replace
	  restore
	  mmerge hhid using `respid_r2'	  
	  preserve
         use "$original\Round 3\sect12_interview_result", clear
         rename s12q9 respid_r3
         keep hhid respid_r3
		 isid hhid
		 tempfile respid_r3
		 save `respid_r3', replace
	  restore
	  mmerge hhid using `respid_r3'  
	  preserve
         use "$original\Round 4\r4_sect_a_2_5_5b_6_8_9_12", clear
         rename s12q9 respid_r4
         keep hhid respid_r4
		 isid hhid
		 tempfile respid_r4
		 save `respid_r4', replace
	  restore
	  mmerge hhid using `respid_r4' 	
	  preserve
         use "$original\Round 5\r5_sect_a_2_5c_6_12", clear
         rename s12q9 respid_r5
         keep hhid respid_r5
		 isid hhid
		 tempfile respid_r5
		 save `respid_r5', replace
	  restore
	  mmerge hhid using `respid_r5'   	  
	  preserve
         use "$original\Round 6\r6_sect_a_2_3a_6_9a_12", clear
         rename s12q9 respid_r6
         keep hhid respid_r6
		 isid hhid
		 tempfile respid_r6
		 save `respid_r6', replace
	  restore
	  mmerge hhid using `respid_r6'  
	  preserve
         use "$original\Round 7\r7_sect_a_5_6_8_9_12", clear
         rename s12q9 respid_r7
         keep hhid respid_r7
		 isid hhid
		 tempfile respid_r7
		 save `respid_r7', replace
	  restore
	  mmerge hhid using `respid_r7'	  
	  preserve
         use "$original\Round 8\r8_sect_a_2_6_12", clear
         rename s12q9 respid_r8
         keep hhid respid_r8
		 isid hhid
		 tempfile respid_r8
		 save `respid_r8', replace
	  restore
	  mmerge hhid using `respid_r8'	 
	  preserve
         use "$original\Round 9\r9_sect_a_2_5_5c_5d_6_12", clear
         rename s12q9 respid_r9
         keep hhid respid_r9
		 isid hhid
		 tempfile respid_r9
		 save `respid_r9', replace
	  restore
	  mmerge hhid using `respid_r9'	 	  
	  preserve
         use "$original\Round 10\r10_sect_a_2_5_6_9_9a_12", clear
         rename s12q9 respid_r10
         keep hhid respid_r10
		 isid hhid
		 tempfile respid_r10
		 save `respid_r10', replace
	  restore
	  mmerge hhid using `respid_r10'		  
	  preserve
         use "$original\Round 11\r11_sect_a_2_5_5b_6_12b_12", clear
         rename s12q9 respid_r11
         keep hhid respid_r11
		 isid hhid
		 tempfile respid_r11
		 save `respid_r11', replace
	  restore
	  mmerge hhid using `respid_r11'		  	  	  
	  
	  forvalues i=1/$round {
	  	 mmerge hhid using "$intermed\Round`i'_hh.dta", ukeep(interview_r`i')
	     replace respid_r`i'=. if interview_r`i'!=1
	  }	  	  
	  gen respond_chg_r2=(respid_r1!=respid_r2) if respid_r1!=. & respid_r2!=.
      gen respond_chg_r3=(respid_r2!=respid_r3) if respid_r2!=. & respid_r3!=.
	  recode respond_chg_r3 (.=0) if (respid_r1==respid_r3) & respid_r1!=. & respid_r3!=.
	  recode respond_chg_r3 (.=1) if (respid_r1!=respid_r3) & respid_r1!=. & respid_r3!=.
	  gen respond_chg_r4=(respid_r3!=respid_r4) if respid_r3!=. & respid_r4!=.	  
	  recode respond_chg_r4 (.=0) if (respid_r2==respid_r4) & respid_r2!=. & respid_r3==. & respid_r4!=.
	  recode respond_chg_r4 (.=1) if (respid_r2!=respid_r4) & respid_r2!=. & respid_r3==. & respid_r4!=.	  
	  recode respond_chg_r4 (.=0) if (respid_r1==respid_r4) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4!=.
	  recode respond_chg_r4 (.=1) if (respid_r1!=respid_r4) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4!=.	
	  gen respond_chg_r5=(respid_r4!=respid_r5) if respid_r4!=. & respid_r5!=.	  
	  recode respond_chg_r5 (.=0) if (respid_r3==respid_r5) & respid_r3!=. & respid_r4==. & respid_r5!=.
	  recode respond_chg_r5 (.=1) if (respid_r3!=respid_r5) & respid_r3!=. & respid_r4==. & respid_r5!=.	  
	  recode respond_chg_r5 (.=0) if (respid_r2==respid_r5) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5!=.
	  recode respond_chg_r5 (.=1) if (respid_r2!=respid_r5) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5!=.	
	  recode respond_chg_r5 (.=0) if (respid_r1==respid_r5) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5!=.
	  recode respond_chg_r5 (.=1) if (respid_r1!=respid_r5) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5!=.
	  gen respond_chg_r6=(respid_r5!=respid_r6) if respid_r5!=. & respid_r6!=.	  
	  recode respond_chg_r6 (.=0) if (respid_r4==respid_r6) & respid_r4!=. & respid_r5==. & respid_r6!=.
	  recode respond_chg_r6 (.=1) if (respid_r4!=respid_r6) & respid_r4!=. & respid_r5==. & respid_r6!=.	  
	  recode respond_chg_r6 (.=0) if (respid_r3==respid_r6) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6!=.
	  recode respond_chg_r6 (.=1) if (respid_r3!=respid_r6) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6!=.	
	  recode respond_chg_r6 (.=0) if (respid_r2==respid_r6) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6!=.
	  recode respond_chg_r6 (.=1) if (respid_r2!=respid_r6) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6!=.
	  recode respond_chg_r6 (.=0) if (respid_r1==respid_r6) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6!=.
	  recode respond_chg_r6 (.=1) if (respid_r1!=respid_r6) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6!=.	
	  gen respond_chg_r7=(respid_r6!=respid_r7) if respid_r6!=. & respid_r7!=.	  
	  recode respond_chg_r7 (.=0) if (respid_r5==respid_r7) & respid_r5!=. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=1) if (respid_r5!=respid_r7) & respid_r5!=. & respid_r6==. & respid_r7!=.	  
	  recode respond_chg_r7 (.=0) if (respid_r4==respid_r7) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=1) if (respid_r4!=respid_r7) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7!=.	
	  recode respond_chg_r7 (.=0) if (respid_r3==respid_r7) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=1) if (respid_r3!=respid_r7) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=0) if (respid_r2==respid_r7) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=1) if (respid_r2!=respid_r7) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=0) if (respid_r1==respid_r7) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.
	  recode respond_chg_r7 (.=1) if (respid_r1!=respid_r7) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7!=.	  
	  gen respond_chg_r8=(respid_r7!=respid_r8) if respid_r7!=. & respid_r8!=.	  
	  recode respond_chg_r8 (.=0) if (respid_r6==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6!=.
	  recode respond_chg_r8 (.=1) if (respid_r6!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6!=.	  
	  recode respond_chg_r8 (.=0) if (respid_r5==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5!=.
	  recode respond_chg_r8 (.=1) if (respid_r5!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5!=.	
	  recode respond_chg_r8 (.=0) if (respid_r4==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=.
	  recode respond_chg_r8 (.=1) if (respid_r4!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=.  
	  recode respond_chg_r8 (.=0) if (respid_r3==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.
	  recode respond_chg_r8 (.=1) if (respid_r3!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=. 
	  recode respond_chg_r8 (.=0) if (respid_r2==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=. 
	  recode respond_chg_r8 (.=1) if (respid_r2!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=. 
	  recode respond_chg_r8 (.=0) if (respid_r1==respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=. 
	  recode respond_chg_r8 (.=1) if (respid_r1!=respid_r8) & respid_r8!=. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.  
	  gen respond_chg_r9=(respid_r8!=respid_r9) if respid_r8!=. & respid_r9!=.	  
	  recode respond_chg_r9 (.=0) if (respid_r7==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7!=.
	  recode respond_chg_r9 (.=1) if (respid_r7!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7!=.	  
	  recode respond_chg_r9 (.=0) if (respid_r6==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6!=.
	  recode respond_chg_r9 (.=1) if (respid_r6!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6!=.	
	  recode respond_chg_r9 (.=0) if (respid_r5==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=.
	  recode respond_chg_r9 (.=1) if (respid_r5!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=.  
	  recode respond_chg_r9 (.=0) if (respid_r4==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=.
	  recode respond_chg_r9 (.=1) if (respid_r4!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=. 
	  recode respond_chg_r9 (.=0) if (respid_r3==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=. 
	  recode respond_chg_r9 (.=1) if (respid_r3!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=. 
	  recode respond_chg_r9 (.=0) if (respid_r2==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=. 
	  recode respond_chg_r9 (.=1) if (respid_r2!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.
	  recode respond_chg_r9 (.=0) if (respid_r1==respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	 
	  recode respond_chg_r9 (.=1) if (respid_r1!=respid_r9) & respid_r9!=. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==.	& respid_r1!=.		
	  gen respond_chg_r10=(respid_r9!=respid_r10) if respid_r9!=. & respid_r10!=.	  
	  recode respond_chg_r10 (.=0) if (respid_r8==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8!=.
	  recode respond_chg_r10 (.=1) if (respid_r8!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8!=.	  
	  recode respond_chg_r10 (.=0) if (respid_r7==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7!=.
	  recode respond_chg_r10 (.=1) if (respid_r7!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7!=.	
	  recode respond_chg_r10 (.=0) if (respid_r6==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6!=.
	  recode respond_chg_r10 (.=1) if (respid_r6!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6!=.  
	  recode respond_chg_r10 (.=0) if (respid_r5==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=.
	  recode respond_chg_r10 (.=1) if (respid_r5!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=. 
	  recode respond_chg_r10 (.=0) if (respid_r4==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=. 
	  recode respond_chg_r10 (.=1) if (respid_r4!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=. 
	  recode respond_chg_r10 (.=0) if (respid_r3==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=. 
	  recode respond_chg_r10 (.=1) if (respid_r3!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.
	  recode respond_chg_r10 (.=0) if (respid_r2==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.	 
	  recode respond_chg_r10 (.=1) if (respid_r2!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.		
	  recode respond_chg_r10 (.=0) if (respid_r1==respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	 
	  recode respond_chg_r10 (.=1) if (respid_r1!=respid_r10) & respid_r10!=. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	
	  gen respond_chg_r11=(respid_r10!=respid_r11) if respid_r10!=. & respid_r11!=.	  
	  recode respond_chg_r11 (.=0) if (respid_r9==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9!=.
	  recode respond_chg_r11 (.=1) if (respid_r9!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9!=.	  
	  recode respond_chg_r11 (.=0) if (respid_r8==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8!=.
	  recode respond_chg_r11 (.=1) if (respid_r8!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8!=.	
	  recode respond_chg_r11 (.=0) if (respid_r7==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7!=.
	  recode respond_chg_r11 (.=1) if (respid_r7!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7!=.  
	  recode respond_chg_r11 (.=0) if (respid_r6==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6!=.
	  recode respond_chg_r11 (.=1) if (respid_r6!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6!=. 
	  recode respond_chg_r11 (.=0) if (respid_r5==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=. 
	  recode respond_chg_r11 (.=1) if (respid_r5!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5!=. 
	  recode respond_chg_r11 (.=0) if (respid_r4==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=. 
	  recode respond_chg_r11 (.=1) if (respid_r4!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4!=.
	  recode respond_chg_r11 (.=0) if (respid_r3==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.	 
	  recode respond_chg_r11 (.=1) if (respid_r3!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.		
	  recode respond_chg_r11 (.=0) if (respid_r2==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.	 
	  recode respond_chg_r11 (.=1) if (respid_r2!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.	
	  recode respond_chg_r11 (.=0) if (respid_r1==respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	 
	  recode respond_chg_r11 (.=1) if (respid_r1!=respid_r11) & respid_r11!=. & respid_r10==. & respid_r9==. & respid_r8==. & respid_r7==. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	  
	  
      keep hhid respond_chg_r*

** SAVE INTERMEDIATE FILES
      save "$intermed\Respondent.dta", replace

** MERGING ALL THE FILES
      use "$intermed\Round0_hh.dta", clear
	  forvalues i=1/$round {
	     mmerge hhid using "$intermed\Round`i'_hh.dta"		
	  }
	  mmerge hhid using "$intermed\Head.dta"
	  mmerge hhid using "$intermed\Respondent.dta"
	  drop _m
	  
** UPDATE VARIABLE
      recode phone_sample (.=0)	  
	  recode contact_r* (.=0) if phone_sample==1
	  
** DROP UNNECESSARY VARIABLES & LABELS

** VALIDATE
      run "$dofiles\hh_validation.do"
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\hh_label.do"	  
	  
** CHECK FOR DUPLICATES
      bysort hhid: assert _n==1
	  assert _N==$totalHH
	
** LABEL DATA 
      label data "Nigeria COVID-19 - Harmonized Dataset (Household Level)"
      label var hhid "Household ID"
		
** ORDER VARIABLES
      order hhid hhid zone state lga ea year rural ea_latitude ea_longitude dwelling roof floor walls toilet water rooms elect ///
            tv radio refrigerator bicycle mcycle car mphone computer internet generator land land_tot land_cultivated ///
			cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj rent remit assist finance ///
			any_work ag_work nfe_work ext_work nfe crop crop_number cash_crop org_fert inorg_fert pest_fung_herb hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ///
			tractor ph_loss sell_crop sell_process sell_unprocess livestock lruminant sruminant poultry equines camelids pig bee ///
			hhsize_r0 m0_14_r0 m15_64_r0 m65_r0 f0_14_r0 f15_64_r0 f65_r0 adulteq_r0 fies_mod_r0 fies_sev_r0 wt_r0 ///
			phone_sample contact_r1 interview_r1 complete_r1 hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 head_chg_r1 wt_r1 ///
            contact_r2 interview_r2 complete_r2 hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2 fies_mod_r2 fies_sev_r2 head_chg_r2 respond_chg_r2 wt_r2 ///
            contact_r3 interview_r3 complete_r3 hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3 head_chg_r3 respond_chg_r3 wt_r3 wt_panel_r3 ///
			contact_r4 interview_r4 complete_r4 hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4 fies_mod_r4 fies_sev_r4 head_chg_r4 respond_chg_r4 wt_r4 wt_panel_r4 ///
			contact_r5 interview_r5 complete_r5 hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5 head_chg_r5 respond_chg_r5 wt_r5 wt_panel_r5 ///
            contact_r6 interview_r6 complete_r6 hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6 head_chg_r6 respond_chg_r6 wt_r6 wt_panel_r6 ///
            contact_r7 interview_r7 complete_r7 hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7 head_chg_r7 respond_chg_r7 wt_r7 wt_panel_r7 ///
			contact_r8 interview_r8 complete_r8 hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8 head_chg_r8 respond_chg_r8 wt_r8 wt_panel_r8 ///
			contact_r9 interview_r9 complete_r9 hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9 head_chg_r9 respond_chg_r9 wt_r9 wt_panel_r9 ///
			contact_r10 interview_r10 complete_r10 hhsize_r10 m0_14_r10 m15_64_r10 m65_r10 f0_14_r10 f15_64_r10 f65_r10 adulteq_r10 head_chg_r10 respond_chg_r10 wt_r10 wt_panel_r10 ///
			contact_r11 interview_r11 complete_r11 hhsize_r11 m0_14_r11 m15_64_r11 m65_r11 f0_14_r11 f15_64_r11 f65_r11 adulteq_r11 head_chg_r11 respond_chg_r11 wt_r11 wt_panel_r11	  			
			
** SAVE FILE 
      isid hhid
	  sort hhid
	  compress
      saveold "$harmonized\NGA_HH.dta", replace
	  
****************************************************
**             INDIVIDUAL LEVEL DATA              **
****************************************************
***************************************
**            ROUND 0                **
***************************************

** OPEN DATA 
      use "$original\Round 0\Post Harvest\Household\sect1_harvestw4", clear
	  	  
** GENERATE VARIABLES
	  //demographic information  
         gen sex=s1q2
         gen age=s1q4
		 gen member_r0=1
	     gen head_r0=(s1q3==1)
	     gen relation_r0=s1q3
		 label copy s1q3 relation_r0
		 label val relation_r0 relation_r0		 
		 gen relation_os_r0=s1q3_os
	     gen married=(inlist(s1q7,1,2,3))
		 gen form_married=(inlist(s1q7,4,5,6))
		 gen nev_married=(s1q7==7)
	     gen religion=s1q17
	     keep hhid indiv sex-religion s1q4a
		 
      //disability
	     mmerge hhid indiv using "$original\Round 0\Post Harvest\Household\sect4a_harvestw4", ukeep(s4aq23 s4aq25 s4aq27 s4aq29 s4aq31 s4aq33) unmatched(master)
		 gen vision=(inlist(s4aq23,3,4)) if s4aq23!=.
		 gen hearing=(inlist(s4aq25,3,4)) if s4aq25!=.
		 gen mobility=(inlist(s4aq27,3,4)) if inrange(s4aq27,1,4)
		 gen communication=(inlist(s4aq33,3,4)) if inrange(s4aq33,1,4)
		 gen selfcare=(inlist(s4aq31,3,4)) if inrange(s4aq31,1,4)
		 gen cognition=(inlist(s4aq29,3,4)) if inrange(s4aq29,1,4)
		 gen disability=(vision==1|hearing==1|mobility==1|communication==1|selfcare==1|cognition==1)
		 replace disability=. if vision==. & hearing==. & mobility==. & communication==. & selfcare==. & cognition==.
		 drop s4aq23-cognition
		 
	  //education		 
	     mmerge hhid indiv using "$original\Round 0\Post Harvest\Household\sect2_harvestw4", ukeep(s2aq2 s2aq5 s2aq6 s2aq9) unmatched(master)
	     gen literacy=(s2aq5==1) if s2aq2==1 
		 gen educ=. 
		 recode educ (.=0) if s2aq6==2|s2aq9==0|inrange(s2aq9,11,15)|inlist(s2aq9,3,51)
		 recode educ (.=1) if inrange(s2aq9,16,25)|s2aq9==27|s2aq9==52
	     recode educ (.=2) if s2aq9==26|inlist(s2aq9,321,28,33,61)
		 recode educ (.=3) if inlist(s2aq9,41,411,412,421,422,423,424,43,322,31,34,35)
	     recode educ (.=0) if s2aq2==1 
		 
	  //work
	     mmerge hhid indiv using "$original\Round 0\Post Harvest\Household\sect3a_harvestw4", ukeep(s3q1 s3q4 s3q5 s3q6 s3q7a)
         gen work=(s3q4==1|s3q5==1|s3q6==1|s3q7a==1) if s3q1==1
	  
** DROP HOUSEHOLDS WITH INCOMPLETE INTERVIEWS
      drop if inlist(hhid,99002,159067,249203,270008)	  

** KEEP ONLY MEMBERS
      drop if s1q4a==2
	  drop s1q4a
	  
** DROP UNNECESSARY VARIABLES
      drop s2aq2 s2aq5 s2aq6 s2aq9 s3q1 s3q4 s3q5 s3q6 s3q7a _merge
	  
** CHECK HEAD
      preserve
	     collapse (max) head_r0, by(hhid)
		 assert head_r0==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r0, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r0) unmatched(master)
		 assert member_r0==hhsize_r0
		 assert _m==3
	  restore	  
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv
      sort hhid indiv
      save "$intermed\Round0_ind.dta", replace
	  
***************************************
**            ROUND 1                **
***************************************	 
** OPEN DATA
      use "$original\Round 1\sect2_household_roster", clear 
	  mmerge hhid using "$original\Round 1\sect12_interview_result", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r1) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r1=(s2q2==1|s2q3==1)
		 gen sex_r1=s2q5
		 gen age_r1=s2q6
	     gen head_r1=(s2q7==1|s2q9==1)
	     gen relation_r1=s2q7 
		 replace relation_r1=s2q9 if relation_r1==. & s2q9!=.
		 label copy s2q9 relation_r1
		 label val relation_r1 relation_r1
		 gen relation_os_r1=s2q7_os
		 replace relation_os_r1=s2q9_os if relation_os_r1=="" & s2q9_os!=""
		 		 
	  //respondent		 	     
	     gen respond_r1=(indiv==s12q9) if s12q9!=.
		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r1)
	     collapse (max) head_r1, by(hhid complete_r1)
		 assert head_r1==1 if complete_r1==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r1, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r1 complete_r1) unmatched(master)
		 assert member_r1==hhsize_r1 if complete_r1==1
		 assert _m==3
	  restore	 
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv
      sort hhid indiv
      save "$intermed\Round1_ind.dta", replace		 

***************************************
**            ROUND 2                **
***************************************	 
** OPEN DATA
      use "$original\Round 2\sect2_household_roster", clear 
	  mmerge hhid using "$original\Round 2\sect12_interview_result", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r2) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r2=(s2q2==1|s2q3==1)
		 gen sex_r2=s2q5
		 gen age_r2=s2q6
	     gen head_r2=(s2q7==1|s2q9==1)
	     gen relation_r2=s2q7 
		 replace relation_r2=s2q9 if relation_r2==. & s2q9!=.
		 label copy s2q7 relation_r2
		 label val relation_r2 relation_r2		 
		 gen relation_os_r2=s2q7_os
		 replace relation_os_r2=s2q9_os if relation_os_r2=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r2=(indiv==s12q9) if s12q9!=.
	
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r2)
	     collapse (max) head_r2, by(hhid complete_r2)
		 assert head_r2==1 if complete_r2==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r2, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r2 complete_r2) unmatched(master)
		 assert member_r2==hhsize_r2 if complete_r2==1
		 assert _m==3
	  restore	 
	  	 
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round2_ind.dta", replace	
	  
***************************************
**            ROUND 3                **
***************************************	 
** OPEN DATA
      use "$original\Round 3\sect2_household_roster", clear 
	  mmerge hhid using "$original\Round 3\sect12_interview_result", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r3) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r3=(s2q2==1|s2q3==1)
		 gen sex_r3=s2q5
		 gen age_r3=s2q6
	     gen head_r3=(s2q7==1|s2q9==1)
	     gen relation_r3=s2q7
		 replace relation_r3=s2q9 if relation_r3==. & s2q9!=.
		 label copy s2q7 relation_r3
		 label val relation_r3 relation_r3			 
		 gen relation_os_r3=s2q7_os
		 replace relation_os_r3=s2q9_os if relation_os_r3=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r3=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r3)
	     collapse (max) head_r3, by(hhid complete_r3)
		 assert head_r3==1 if complete_r3==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r3, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r3 complete_r3) unmatched(master)
		 assert member_r3==hhsize_r3 if complete_r3==1
		 assert _m==3
	  restore	 
	  	 
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round3_ind.dta", replace
	  
	  
***************************************
**            ROUND 4                **
***************************************	 
** OPEN DATA
      use "$original\Round 4\r4_sect_2", clear 
	  mmerge hhid using "$original\Round 4\r4_sect_a_2_5_5b_6_8_9_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r4=(s2q2==1|s2q3==1)
		 gen sex_r4=s2q5
		 gen age_r4=s2q6
	     gen head_r4=(s2q7==1|s2q9==1)
	     gen relation_r4=s2q7
		 replace relation_r4=s2q9 if relation_r4==. & s2q9!=.
		 label copy s2q7 relation_r4
		 label val relation_r4 relation_r4			 
		 gen relation_os_r4=s2q7_os
		 replace relation_os_r4=s2q9_os if relation_os_r4=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r4=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r4)
	     collapse (max) head_r4, by(hhid complete_r4)
		 assert head_r4==1 if complete_r4==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r4, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r4 complete_r4) unmatched(master)
		 assert member_r4==hhsize_r4 if complete_r4==1
		 assert _m==3
	  restore	 
	  	  
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round4_ind.dta", replace	  
	
***************************************
**            ROUND 5                **
***************************************	 
** OPEN DATA
      use "$original\Round 5\r5_sect_2", clear 
	  mmerge hhid using "$original\Round 5\r5_sect_a_2_5c_6_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r5=(s2q2==1|s2q3==1)
		 gen sex_r5=s2q5
		 gen age_r5=s2q6
	     gen head_r5=(s2q7==1|s2q9==1)
	     gen relation_r5=s2q7
		 replace relation_r5=s2q9 if relation_r5==. & s2q9!=.
		 label copy s2q7 relation_r5
		 label val relation_r5 relation_r5			 
		 gen relation_os_r5=s2q7_os
		 replace relation_os_r5=s2q9_os if relation_os_r5=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r5=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r5)
	     collapse (max) head_r5, by(hhid complete_r5)
		 assert head_r5==1 if complete_r5==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r5, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r5 complete_r5) unmatched(master)
		 assert member_r5==hhsize_r5 if complete_r5==1
		 assert _m==3
	  restore	 
	  	  
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round5_ind.dta", replace	
	  
***************************************
**            ROUND 6                **
***************************************	 
** OPEN DATA
      use "$original\Round 6\r6_sect_2", clear 
	  mmerge hhid using "$original\Round 6\r6_sect_a_2_3a_6_9a_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r6=(s2q2==1|s2q3==1)
		 gen sex_r6=s2q5
		 gen age_r6=s2q6
	     gen head_r6=(s2q7==1|s2q9==1)
	     gen relation_r6=s2q7
		 replace relation_r6=s2q9 if relation_r6==. & s2q9!=.
		 label copy s2q7 relation_r6
		 label val relation_r6 relation_r6			 
		 gen relation_os_r6=s2q7_os
		 replace relation_os_r6=s2q9_os if relation_os_r6=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r6=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q10_os s12q9 _merge
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r6)
	     collapse (max) head_r6, by(hhid complete_r6)
		 assert head_r6==1 if complete_r6==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r6, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r6 complete_r6) unmatched(master)
		 assert member_r6==hhsize_r6 if complete_r6==1
		 assert _m==3
	  restore	 
	  	  
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round6_ind.dta", replace		  
	  
***************************************
**            ROUND 7                **
***************************************	 
** OPEN DATA
      use "$original\Round 7\r7_sect_2", clear 
	  mmerge hhid using "$original\Round 7\r7_sect_a_5_6_8_9_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r7=(s2q2==1|s2q3==1)
		 gen sex_r7=s2q5
		 gen age_r7=s2q6
	     gen head_r7=(s2q7==1|s2q9==1)
	     gen relation_r7=s2q7
		 replace relation_r7=s2q9 if relation_r7==. & s2q9!=.
		 label copy s2q7 relation_r7
		 label val relation_r7 relation_r7			 
		 gen relation_os_r7=s2q7_os
		 replace relation_os_r7=s2q9_os if relation_os_r7=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r7=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q11_os s12q9 _merge
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r7)
	     collapse (max) head_r7, by(hhid complete_r7)
		 assert head_r7==1 if complete_r7==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r7, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r7 complete_r7) unmatched(master)
		 assert member_r7==hhsize_r7 if complete_r7==1
		 assert _m==3
	  restore	 
	  	 
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round7_ind.dta", replace	
	
***************************************
**            ROUND 8                **
***************************************	 
** OPEN DATA
      use "$original\Round 8\r8_sect_2", clear 
	  mmerge hhid using "$original\Round 8\r8_sect_a_2_6_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r8=(s2q2==1|s2q3==1)
		 gen sex_r8=s2q5
		 gen age_r8=s2q6
	     gen head_r8=(s2q7==1|s2q9==1)
	     gen relation_r8=s2q7
		 replace relation_r8=s2q9 if relation_r8==. & s2q9!=.
		 label copy s2q7 relation_r8
		 label val relation_r8 relation_r8			 
		 gen relation_os_r8=s2q7_os
		 replace relation_os_r8=s2q9_os if relation_os_r8=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r8=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r8)
	     collapse (max) head_r8, by(hhid complete_r8)
		 assert head_r8==1 if complete_r8==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r8, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r8 complete_r8) unmatched(master)
		 assert member_r8==hhsize_r8 if complete_r8==1
		 assert _m==3
	  restore	 
	  	  
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round8_ind.dta", replace	
	  
***************************************
**            ROUND 9                **
***************************************	 
** OPEN DATA
      use "$original\Round 9\r9_sect_2", clear 
	  mmerge hhid using "$original\Round 9\r9_sect_a_2_5_5c_5d_6_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r9=(s2q2==1|s2q3==1)
		 gen sex_r9=s2q5
		 gen age_r9=s2q6
	     gen head_r9=(s2q7==1|s2q9==1)
	     gen relation_r9=s2q7
		 replace relation_r9=s2q9 if relation_r9==. & s2q9!=.
		 label copy s2q7 relation_r9
		 label val relation_r9 relation_r9			 
		 gen relation_os_r9=s2q7_os
		 replace relation_os_r9=s2q9_os if relation_os_r9=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r9=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r9)
	     collapse (max) head_r9, by(hhid complete_r9)
		 assert head_r9==1 if complete_r9==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r9, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r9 complete_r9) unmatched(master)
		 assert member_r9==hhsize_r9 if complete_r9==1
		 assert _m==3
	  restore	 
	  	 
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round9_ind.dta", replace	
	  	  
***************************************
**            ROUND 10               **
***************************************	 
** OPEN DATA
      use "$original\Round 10\r10_sect_2", clear 
	  mmerge hhid using "$original\Round 10\r10_sect_a_2_5_6_9_9a_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r10=(s2q2==1|s2q3==1)
		 gen sex_r10=s2q5
		 gen age_r10=s2q6
	     gen head_r10=(s2q7==1|s2q9==1)
	     gen relation_r10=s2q7
		 replace relation_r10=s2q9 if relation_r10==. & s2q9!=.
		 label copy s2q7 relation_r10
		 label val relation_r10 relation_r10			 
		 gen relation_os_r10=s2q7_os
		 replace relation_os_r10=s2q9_os if relation_os_r10=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r10=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s12q9 _merge
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r10)
	     collapse (max) head_r10, by(hhid complete_r10)
		 assert head_r10==1 if complete_r10==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r10, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r10 complete_r10) unmatched(master)
		 assert member_r10==hhsize_r10 if complete_r10==1
		 assert _m==3
	  restore	 
	  	  
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round10_ind.dta", replace	
	  
***************************************
**            ROUND 11               **
***************************************	 
** OPEN DATA
      use "$original\Round 11\r11_sect_2", clear 
	  mmerge hhid using "$original\Round 11\r11_sect_a_2_5_5b_6_12b_12", ukeep(s12q9) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r11=(s2q2==1|s2q3==1)
		 gen sex_r11=s2q5
		 gen age_r11=s2q6
	     gen head_r11=(s2q7==1|s2q9==1)
	     gen relation_r11=s2q7
		 replace relation_r11=s2q9 if relation_r11==. & s2q9!=.
		 label copy s2q7 relation_r11
		 label val relation_r11 relation_r11			 
		 gen relation_os_r11=s2q7_os
		 replace relation_os_r11=s2q9_os if relation_os_r11=="" & s2q9_os!=""
		 
	  //respondent		 	     
	     gen respond_r11=(indiv==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      drop zone-ea s2q2-s2q9_os s2q11 s12q9 _merge
	
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r11)
	     collapse (max) head_r11, by(hhid complete_r11)
		 assert head_r11==1 if complete_r11==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r11, by(hhid)
		 mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(hhsize_r11 complete_r11) unmatched(master)
		 assert member_r11==hhsize_r11 if complete_r11==1
		 assert _m==3
	  restore	 
	  	
** SAVE INTERMEDIATE FILE 
      sort hhid indiv
      save "$intermed\Round11_ind.dta", replace	
	  
** MERGING THE FILES
      use "$intermed\Round0_ind.dta", clear  
	  forvalues i=1/$round {
	  	 mmerge hhid indiv using "$intermed\Round`i'_ind.dta"
	  }
	  mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(complete_r*) unmatched(master)	  
	  forvalues i=1/$round {	  
		 replace member_r`i'=. if complete_r`i'!=1
	     replace head_r`i'=. if complete_r`i'!=1
		 replace relation_r`i'=. if complete_r`i'!=1
		 replace relation_os_r`i'="" if complete_r`i'!=1	  	
	  }

** MERGE WITH HOUSEHOLD LEVEL FILES
      mmerge hhid using "$harmonized\NGA_HH.dta", ukeep(contact_r* interview_r* head_chg_r* respond_chg_r*) unmatched(master)
	
** UPDATE SEX AND AGE INFORMATION
      gen age_p=.
      forvalues i=1/$round {
	  	replace sex=sex_r`i' if sex==.
		replace age_p=age_r`i' if age_r`i'!=.
	  }
 	  drop sex_r* age_r* _m
	  
** UPDATE MEMBER AND HEAD VARIABLES 
      recode member_r0 (.=0)
      recode member_r1 (.=0) if complete_r1==1
	  forvalues i=2/$round {
	     recode member_r`i' (.=0) if complete_r`i'==1	
	  }
	  forvalues i=0/$round {
	  	 recode head_r`i' (.=0) if member_r`i'==0
	  }
	  forvalues i=1/$round {
	     recode respond_r`i' (.=0) if interview_r`i'==1	
	  }	  
	  
** VALIDATE
      run "$dofiles\ind_validation.do"
	  foreach x in relation_r0 married form_married nev_married religion literacy educ work {
	     assert `x'==. if indiv>=100	
	  }
	  assert member_r0==1 if indiv<100
	  assert member_r0==0 if indiv>=100
	  assert member_r1==0 if indiv>=200 & complete_r1==1
	  assert member_r2==0 if indiv>=300 & complete_r2==1
	  assert member_r3==0 if indiv>=400 & complete_r3==1 
	  assert member_r4==0 if indiv>=500 & complete_r4==1
	  assert member_r5==0 if indiv>=600 & complete_r5==1
	  assert member_r6==0 if indiv>=700 & complete_r6==1
	  assert member_r7==0 if indiv>=800 & complete_r7==1
	  assert member_r8==0 if indiv>=900 & complete_r8==1
	  assert member_r9==0 if indiv>=1000 & complete_r9==1
	  assert member_r10==0 if indiv>=1100 & complete_r10==1
	  
	  assert indiv>=100 if member_r0==0
	  assert inrange(indiv,100,200) if member_r1==1 & member_r0==0
	  assert indiv>=200 if member_r1==0 & member_r0==0 
	  assert indiv>=300 if member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=400 if member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0	
	  assert indiv>=500 if member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
      assert indiv>=600 if member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=700 if member_r6==0 & member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=800 if member_r7==0 & member_r6==0 & member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=900 if member_r8==0 & member_r7==0 & member_r6==0 & member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=1000 if member_r9==0 & member_r8==0 & member_r7==0 & member_r6==0 & member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=1100 if member_r10==0 & member_r9==0 & member_r8==0 & member_r7==0 & member_r6==0 & member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	  
** DROP UNNECESSARY VARIABLES
      drop contact_r* interview_r* head_chg_r* respond_chg_r* complete_r*	
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\ind_label.do"
	  
** CHECK FOR DUPLICATES
      bysort hhid indiv: assert _n==1
	  preserve
	     collapse (count) indiv, by(hhid)
		 assert _N==$totalHH
	  restore
	  isid hhid indiv
	
** LABEL DATA 
      label data "Nigeria COVID-19 - Harmonized Dataset (Individual Level)"
      label var hhid "Household ID"
      label var indiv "Individual ID"
	  	  
** ORDER VARIABLES
      order hhid indiv sex age age_p married form_married nev_married disability religion literacy educ work ///
            member_r0 head_r0 relation_r0 relation_os_r0 ///
            member_r1 head_r1 respond_r1 relation_r1 relation_os_r1 ///
            member_r2 head_r2 respond_r2 relation_r2 relation_os_r2 ///
            member_r3 head_r3 respond_r3 relation_r3 relation_os_r3 ///
			member_r4 head_r4 respond_r4 relation_r4 relation_os_r4 ///
            member_r5 head_r5 respond_r5 relation_r5 relation_os_r5 ///
			member_r6 head_r6 respond_r6 relation_r6 relation_os_r6 ///
			member_r7 head_r7 respond_r7 relation_r7 relation_os_r7 ///
			member_r8 head_r8 respond_r8 relation_r8 relation_os_r8 ///
			member_r9 head_r9 respond_r9 relation_r9 relation_os_r9 ///
            member_r10 head_r10 respond_r10 relation_r10 relation_os_r10  ///
            member_r11 head_r11 respond_r11 relation_r11 relation_os_r11
			
** CHECKING IND FILE WILL MERGE WITH HH FILE
      preserve
         mmerge hhid using "$harmonized\NGA_HH.dta"	
		 assert _m==3
	  restore	 
	  
** SAVE FILE  
      isid hhid indiv
      sort hhid indiv
	  compress
      saveold "$harmonized\NGA_IND.dta", replace
	   