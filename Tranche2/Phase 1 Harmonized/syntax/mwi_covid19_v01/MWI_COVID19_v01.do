******************************************************************
**         COVID-19 Phone Survey Harmonized Data Project        **
**                                                              **
**                                                              **
**  Country: Malawi		YEAR:  2019/2020   			          	**
**                                                              **
**  Program Name:  MWI_COVID19_v01.do		    		    	**
**                                                              **
**  Version: v01 (Round 0-9)                                    **
**                                                              **
**  Description: Generates harmonized dataset				    **
**                                                              **
**  Number of HHs (GHS-P WAVE 4 PH): 3,178                      **
**                                                              **
**  Household: hhid		    			  						**
**                                                              **
**  Program first written: July 9, 2021		                	**
**  Program last revised:                                    	**
**                                                              **
******************************************************************
set more off

** TOTAL NUMBER OF HOUSEHOLDS IN THE LAST FACE-TO-FACE SURVEY
      global totalHH 3178	
	  
** NUMBER OF PHONE SURVEY ROUNDS TO BE HARMONIZED
      global round 12

** PHONE SURVEY ROUNDS WITH FIES QUESTIONS	  
      global fies 1 2 3	5

********************************************************************************
**                            HOUSEHOLD LEVEL DATA                            **
********************************************************************************

********************************************************************************
**                                 ROUND 0                                    **
********************************************************************************

** OPEN DATA 
      use "$original\Round 0\Household\hh_mod_a_filt_19.dta", clear
	  
** GENERATE VARIABLES
      //basic household information
         gen year=2019
		 gen wt_r0=hh_wgt
	     gen rural=.
		 replace rural = 1 if reside == 2
		 replace rural = 2 if reside == 1 
		 gen ea=ea_id
		 gen interview_result=.
		 
		 label variable region "Region Code"
		 label variable district "District Code"
		 label variable ea "EA Code"
		 keep y4_hhid ea year-interview_result
	
	  //dwelling information	 
	     mmerge y4_hhid using "$original\Round 0\Household\hh_mod_f_19.dta", ukeep(hh_f01 hh_f07 hh_f07_oth hh_f08 hh_f08_oth hh_f09 hh_f09_oth hh_f10 hh_f19 hh_f41 hh_f40 hh_f36) unmatched(master)
	     gen dwelling=(inlist(hh_f01,1,2) & hh_f01!=.) 
	     gen roof=(inlist(hh_f08,2,3,4,5) & hh_f08!=.)
		 recode roof (0=1) if inlist(hh_f08_oth, "ASBESTOS","TILES") & hh_f08==6
	     gen floor=(inlist(hh_f09,3,4,5) & hh_f09!=.)
		 recode floor (0=1) if inlist(hh_f09_oth, "CEMENT", "CONCRETE") & hh_f09==6
	     gen walls=(inlist(hh_f07,5,6,8) & hh_f07!=.)
	     gen toilet=(inlist(hh_f41,1,2,3,5,6,7,9) & hh_f41!=.)
	     gen water=(inlist(hh_f36,1,2,3,4,5,6,7,8,9,13,14,15,17) & hh_f36!=.)
		 recode water (0=1) if (inlist(hh_f40,1,2,3,4,5,6,7,8,9,13,14,15) & hh_f40!=.)
	     gen rooms=hh_f10
	     gen elect=(hh_f19==1)
		 
		 keep y4_hhid-interview_result dwelling-elect

	  // Latitude and longitude
	     preserve
  		    use "$original\Round 0\Household\householdgeovariables_y4.dta",clear
			 gen ea_latitude=lat_mod
			 gen ea_longitude=lon_mod
			 keep y4_hhid ea_lat ea_long
			tempfile coor
			save `coor', replace
 		 restore		
         mmerge y4_hhid using `coor', unmatched(master)
			drop _m
		 
	  //asset information
	     preserve
		    use "$original\Round 0\Household\hh_mod_l_19.dta",clear
			gen tv=(hh_l02==509 & hh_l01==1)
			gen radio=(inlist(hh_l02,507,5081) & hh_l01==1)
			gen refrigerator=(hh_l02==514 & hh_l01==1)
			gen bicycle=(hh_l02==516 & hh_l01==1)
			gen mcycle=(hh_l02==517 & hh_l01==1)
			gen car=(hh_l02==518 & hh_l01==1)
			gen computer=(hh_l02==529 & hh_l01==1)		 
			gen generator=(hh_l02==532 & hh_l01==1)		
			collapse (max) tv-generator, by(y4_hhid)
			//assume NO for missing cases
			   recode tv-generator (.=0)
			tempfile asset
			save `asset', replace
		 restore		
         mmerge y4_hhid using `asset', unmatched(master)
	     preserve 
		
		    use "$original\Round 0\Household\hh_mod_f_19.dta",clear 
			gen mphone=(hh_f34>0 & hh_f34!=.)
	        gen internet=(hh_f35_2>0 & hh_f35!=.)			 		
			collapse (max) mphone internet, by(y4_hhid)
			tempfile  internet
			save `internet', replace
         restore
		 mmerge y4_hhid using `internet', unmatched(master)
		 
	  //finance and income information	
	     preserve
		    use "$original\Round 0\Household\hh_mod_p_19", clear
	        gen rent=(inlist(hh_p0a,106,107,108,109) & hh_p01==1)
			gen remit=(hh_p0a==101 & hh_p01==1)
			collapse (max) remit rent, by(y4_hhid)
			tempfile rent
			save `rent', replace
		 restore
		 mmerge y4_hhid using `rent', unmatched(master)
	     preserve
		    use "$original\Round 0\Household\hh_mod_o_19", clear
	        gen remit2=(hh_o11==1)
			collapse (max) remit2, by(y4_hhid)
			tempfile remittance
			save `remittance', replace
		 restore	
		 mmerge y4_hhid using `remittance', unmatched(master)
		 recode remit (0=1) if remit2==1
		 
	     preserve
		    use "$original\Round 0\Household\hh_mod_r_19", clear		 
	        gen assist=(hh_r01==1)
			collapse (max) assist, by(y4_hhid)
			tempfile assistance
			save `assistance', replace		 
		 restore	
		 mmerge y4_hhid using `assistance', unmatched(master) 
	     preserve
		    use "$original\Round 0\Household\hh_mod_f_19", clear
			gen finance=(hh_f48==1)
			collapse (max) finance, by(y4_hhid)
			tempfile finance
			save `finance', replace
		 restore	
		 mmerge y4_hhid using `finance', unmatched(master) 	     
		 
	  //labor information
	     preserve
		    use "$original\Round 0\Household\hh_mod_e_19", clear
			mmerge y4_hhid PID using "$original\Round 0\Household\hh_mod_b_19", ukeep(hh_b05a) unmatched(master)
	        gen ag=(hh_e06_1a==1 & inrange(hh_b05a,15,64))
			recode ag (0=1) if (hh_e06_1b==1 & inrange(hh_b05a,15,64))
			recode ag (0=1) if (hh_e06_1c==1 & inrange(hh_b05a,15,64))
	        gen nfe=(hh_e06_2==1 & inrange(hh_b05a,15,64))
			recode nfe (0=1) if (hh_e06_3==1 & inrange(hh_b05a,15,64))
	        gen ext=(hh_e06_4==1 & inrange(hh_b05a,15,64))
	        gen any=(ag==1|nfe==1|ext==1| hh_e06_5==1 & inrange(hh_b05a,15,64))    // ¿We need to add Ganyu?
			gen person=(inrange(hh_b05a,15,64))
			collapse (sum) ag-person, by(y4_hhid)
			gen ag_work=ag/person*100
			gen nfe_work=nfe/person*100
			gen ext_work=ext/person*100
			gen any_work=any/person*100
			keep y4_hhid ag_work-any_work
			tempfile work
			save `work', replace
         restore
		 mmerge y4_hhid using `work', unmatched(master)
	     preserve
		    use "$original\Round 0\Household\hh_mod_n1_19", clear	
			recode hh_n01-hh_n08 (2=0)
			egen any=rowtotal(hh_n01-hh_n08)
			gen nfe=(any>=1 & any!=.)
			keep y4_hhid nfe
			tempfile nfe
			save `nfe', replace
         restore
		 mmerge y4_hhid using `nfe', unmatched(master)	
	 
	  //land information    
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_c_19", clear
			mmerge y4_hhid gardenid plotid using "$original\Round 0\Agriculture\ag_mod_d_19"
				drop _m
		    merge m:1 y4_hhid gardenid using "$original\Round 0\Household\hh_mod_f1_19"	
				drop if _m==2
				drop _m
			mmerge y4_hhid using "$original\Round 0\Household\hh_mod_a_filt_19.dta", ukeep(region) unmatched(master)
		
	        //generating estimated conversions for self reported (even standard units)
		       gen conv = ag_c04c/ ag_c04a
		       egen med_conv_zn = median(conv), by(region ag_c04b)
		       gen SR_ha = (ag_c04a*med_conv_zn)/2.471
		         
			//plot area
		        gen plotsize = ag_c04c/2.471
		        replace plotsize = SR_ha if plotsize==.
				
		        //winsorize
			       winsor2 plotsize, cuts(1 99) by(region)
			
	        egen land_tot=sum(plotsize_w*(inlist(hh_f103,1,2,3,4,13))), by(y4_hhid)
		    note land_tot: Limited to agricultural land. 
		    gen land=(land_tot!=0)		 
		    note land: Limited to agricultural land.
		    egen land_cultivated = sum(plotsize_w*(ag_d14==1)), by(y4_hhid)
			gen crop=(land_cultivated!=0)
		    keep y4_hhid land* crop
		 	duplicates drop
		    isid y4_hhid
		    tempfile land 
			save `land', replace
		 restore
		 mmerge y4_hhid using `land', unmatched(master)
		 recode land crop (.=0)
		 recode land_tot (.=0) if land==0
		 recode land_cultivated (.=0) if crop==0
		 order land land_tot crop land_cultivated, after(nfe)
		 drop _merge
		 
		 	gen totcons=.
			gen foodcons=.
			gen nonfoodcons=.
			gen totcons_adj=.
			gen foodcons_adj=.
			gen nonfoodcons_adj=.
			gen cons_quint=.
/*
	  //food security information	
	     mmerge hhid using "$original\Round 0\NG_FIES_harvest_full.dta", umatch(HHID) ukeep(p_mod p_sev)
	     gen fies_mod_r0=(p_mod>=0.5 & p_mod!=.)
	     gen fies_sev_r0=(p_sev>=0.5 & p_sev!=.)
		 drop p_mod p_sev

	 
	  //consumption information
	     preserve
	        use "$original\Round 0\totcons_final.dta", clear
		    mmerge hhid using "$original\Round 0\Household\HH_MOD_A.dta", ukeep(panelweight_2019) unmatched(master)
			assert _m==3
			keep hhid totcons_adj_norm hh_wgt
	        xtile cons_quint=totcons_adj_norm [pw=panelweight_2019], nq(5)			
			keep hhid cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj
			tempfile cons
			save `cons', replace
         restore
		 mmerge hhid using `cons', unmatched(master)	
         
*/		
	  //agricultural information
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_g_19.dta", clear 
		    gen crop_number=1
			gen cash_crop=(inlist(crop_code,5,6,8,9,10,37,39))
			collapse (sum) crop_number (max) cash_crop, by(y4_hhid)
			tempfile crop_number
			save `crop_number', replace
		 restore
		 mmerge y4_hhid using `crop_number', unmatched(master)
		 note cash_crop: TOBACCO, COTTON AND SUGARCANE	
				replace crop_number=. if crop==0
				replace cash_crop=. if crop==0
				
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_d_19.dta", clear
			gen org_fert=(ag_d36==1)
			gen inorg_fert=(ag_d38==1)
			gen pest_fung_herb=(ag_d40==1)
			collapse (max) org_fert inorg_fert pest_fung_herb, by(y4_hhid)
			tempfile fertilizer
			save `fertilizer', replace
		 restore
		 mmerge y4_hhid using `fertilizer', unmatched(master)
			 replace org_fert=. if crop==0
			 replace inorg_fert=. if crop==0
			 replace pest_fung_herb=. if crop==0
		 
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_d_19.dta", clear
			gen hired_lab=(ag_d47a1>=1 & ag_d47a1!=.) |(ag_d47a2>=1 & ag_d47a2!=.)| (ag_d47a3>=1 & ag_d47a3!=.)
			gen ex_fr_lab=(ag_d47b1>=1 & ag_d47b1!=.) |(ag_d47b2>=1 & ag_d47b2!=.)| (ag_d47b3>=1 & ag_d47b3!=.)
			collapse (max) hired_lab ex_fr_lab, by(y4_hhid)
			tempfile ag_labor
			save `ag_labor', replace
		 restore
		 mmerge y4_hhid using `ag_labor', unmatched(master)
		 
		 //for those are missing, assume NO
		     recode hired_lab ex_fr_lab (.=0) if crop==1		
			 replace hired_lab=. if crop==0
			 replace ex_fr_lab=. if crop==0
		
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_d_19.dta", clear
            gen tractor=(inlist(ag_d63a,5,6) | ag_d63b==6)
			collapse (max) tractor, by(y4_hhid)
		    tempfile tractor
			save `tractor', replace
		 restore
		 mmerge y4_hhid using `tractor', unmatched(master)
		 replace tractor=. if crop==0			
		 preserve
		    use "$original\Round 0\Agriculture\ag_mod_d_19.dta", clear
			gen hired_lab_ph=(ag_d48a1>=1 & ag_d48a1!=.) |(ag_d48a2>=1 & ag_d48a2!=.)| (ag_d48a3>=1 & ag_d48a3!=.)
			gen ex_fr_lab_ph=(ag_d48b1>=1 & ag_d48b1!=.) |(ag_d48b2>=1 & ag_d48b2!=.)| (ag_d48b3>=1 & ag_d48b3!=.)
			collapse (max) hired_lab_ph ex_fr_lab_ph, by(y4_hhid)
			tempfile ag_labor_ph
			save `ag_labor_ph', replace
		 restore
		 mmerge y4_hhid using `ag_labor_ph', unmatched(master)
		 
		 //for those are missing, assume NO
             recode  hired_lab_ph ex_fr_lab_ph (.=0) if crop==1
			 replace hired_lab_ph=. if crop==0
			 replace ex_fr_lab_ph=. if crop==0
	
		 preserve
		    use "$original\Round 0\Agriculture\ag_mod_i_19.dta", clear //¿Can we assume shelled/unshelled like processed/unprocessed?
			gen sell_crop=(ag_i01==1)
			gen sell_unprocess=(ag_i01==1 & (ag_i02c==2 | ag_i02c==3))
			gen sell_process=(ag_i01==1 & ag_i02c==1)
			gen ph_loss=(ag_i36a>0 & ag_i36a!=.)
			collapse (max) sell_crop sell_unprocess sell_process ph_loss, by(y4_hhid)
			tempfile harvest
			save `harvest', replace
		 restore
		 mmerge y4_hhid using `harvest', unmatched(master) 
			replace sell_crop=. if crop==0
			replace sell_process=. if crop==0
			replace sell_unprocess=. if crop==0
			replace ph_loss=. if crop==0
		
		 //for those are missing, assume NO
            recode  sell_crop sell_unprocess sell_process ph_loss (.=0) if crop==1
			
	*	 order crop crop_number cash_crop org_fert inorg_fert pest_fung_herb tractor hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ph_loss sell_crop sell_unprocess sell_process, after(cons_quint)
	
	  //livestock information
	     preserve
		    use "$original\Round 0\Agriculture\ag_mod_r1_19.dta", clear
	        gen lruminant=(inlist(ag_r0a,301,302,303,304) & ag_r00==1 & ag_r01==1)
	        gen sruminant=(inlist(ag_r0a,307,308) & ag_r00==1 & ag_r01==1)
	        gen poultry=(inlist(ag_r0a,311,313,315,313,319,3310,314) & ag_r00==1 & ag_r01==1)
			recode poultry (0=1) if ag_r01_oth=="CHICKS" & ag_r00==1 & ag_r01==1
	        gen equines=(ag_r0a==3305 & ag_r00==1 & ag_r01==1)
	        gen camelids=.
			note camelids: Data not collected.
	        gen pig=(ag_r0a==309 & ag_r00==1 & ag_r01==1)
	        gen bee=.
			note bee: Data not collected.
	        gen livestock=(lruminant==1|sruminant==1|poultry==1|equines==1|camelids==1|pig==1)			
			collapse (max) lruminant-livestock, by(y4_hhid)
			tempfile livestock
			save `livestock', replace
		 restore
		 mmerge y4_hhid using `livestock', unmatched(master)
		 recode lruminant-pig livestock (.=0)
		 
	  //demographic information
	     preserve
		    use "$original\Round 0\Household\hh_mod_b_19", clear
			drop if hh_b06_2==3 | hh_b06_2==4
		    gen hhsize_r0=1
		    gen m0_14_r0  = 1 if (hh_b03==1 & inrange(hh_b05a,0,14)) 
		    gen m15_64_r0 = 1 if (hh_b03==1 & inrange(hh_b05a,15,64))
		    gen m65_r0    = 1 if (hh_b03==1 & hh_b05a>=65 & hh_b05a!=.) 
		    gen f0_14_r0  = 1 if (hh_b03==2 & inrange(hh_b05a,0,14)) 
		    gen f15_64_r0 = 1 if (hh_b03==2 & inrange(hh_b05a,15,64))
		    gen f65_r0    = 1 if (hh_b03==2 & hh_b05a>=65 & hh_b05a!=.) 
		    gen adulteq_r0=. 
            replace adulteq_r0 = 0.27 if (hh_b03==1 & hh_b05a==0) 
            replace adulteq_r0 = 0.45 if (hh_b03==1 & inrange(hh_b05a,1,3)) 
            replace adulteq_r0 = 0.61 if (hh_b03==1 & inrange(hh_b05a,4,6)) 
            replace adulteq_r0 = 0.73 if (hh_b03==1 & inrange(hh_b05a,7,9)) 
            replace adulteq_r0 = 0.86 if (hh_b03==1 & inrange(hh_b05a,10,12)) 
            replace adulteq_r0 = 0.96 if (hh_b03==1 & inrange(hh_b05a,13,15)) 
            replace adulteq_r0 = 1.02 if (hh_b03==1 & inrange(hh_b05a,16,19)) 
            replace adulteq_r0 = 1.00 if (hh_b03==1 & hh_b05a >=20) 
            replace adulteq_r0 = 0.27 if (hh_b03==2 & hh_b05a ==0) 
            replace adulteq_r0 = 0.45 if (hh_b03==2 & inrange(hh_b05a,1,3)) 
            replace adulteq_r0 = 0.61 if (hh_b03==2 & inrange(hh_b05a,4,6)) 
            replace adulteq_r0 = 0.73 if (hh_b03==2 & inrange(hh_b05a,7,9)) 
            replace adulteq_r0 = 0.78 if (hh_b03==2 & inrange(hh_b05a,10,12)) 
            replace adulteq_r0 = 0.83 if (hh_b03==2 & inrange(hh_b05a,13,15)) 
            replace adulteq_r0 = 0.77 if (hh_b03==2 & inrange(hh_b05a,16,19)) 
            replace adulteq_r0 = 0.73 if (hh_b03==2 & hh_b05a >=20)      
			collapse (sum) hhsize_r0-adulteq_r0, by(y4_hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize', unmatched(master)
		 drop _m

** KEEP ONLY HHS WITH COMPLETED INTERVIEW
 *     keep if interview_result==1
	  drop interview_result
	  
** SAVE INTERMEDIATE FILES

      save "$intermed\Round0_hh.dta", replace
	 
********************************************************************************
**                                 ROUND 1                                    **
********************************************************************************
** GENERATE VARIABLES	 
	  //interview results
         use "$original\Round 1\sect12_interview_result_r1", clear
		 gen phone_sample=1		 
		 gen contact_r1=(inrange(s12q5,1,3))		 
		 gen interview_r1=(inlist(s12q5,1,2)) if contact_r1==1
		 gen complete_r1=(s12q5==1) if interview_r1==1
	     keep HHID y4_hhid phone_sample contact_r1 interview_r1 complete_r1
		 
	  //weights
	     mmerge y4_hhid using "$original\Round 1\secta_cover_page_r1", ukeep(wt_baseline) urename(wt_baseline wt_r1)
		 keep if _m==3	
		 
	  //demographic information
	     preserve
		 use "$original\Round 1\sect2_household_roster_r1", clear
		    //fixing member status
			   recode s2q3 (.=2) if y4_hhid=="0251-001" & PID==4
			   recode s2q3 (.=2) if y4_hhid=="0880-001" & PID==2
			   
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r1==. & m15_64_r1==. & m65_r1==. & f0_14_r1==. & f15_64_r1==. & f65_r1==.)
			assert adulteq_r1!=.
	        collapse (sum) hhsize_r1-adulteq_r1, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'
		 foreach x in hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 {
		 	replace `x'=. if complete_r1!=1
		 }
		 keep HHID y4_hhid *_r1 phone_sample
		 
		 	  //fies
	     preserve
	        use "$original\Round 1\MW_FIES_round1", clear
			rename HHID y4_hhid
		    gen fies_mod_r1=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r1=(p_sev>=0.5 & p_sev!=.)
			keep y4_hhid *_r1
			tempfile fies_r1
			save `fies_r1', replace
		 restore
		 mmerge y4_hhid using `fies_r1', unmatched(master)
		 keep y4_hhid *_r1 phone_sample
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round1_hh.dta", replace
	  

********************************************************************************
**                                 ROUND 2                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 2\sect12_interview_result_r2", clear
		 gen contact_r2=(inrange(s12q5,1,3))		 
		 gen interview_r2=(inlist(s12q5,1,2)) if contact_r2==1
		 gen complete_r2=(s12q5==1) if interview_r2==1
	     keep HHID y4_hhid contact_r2 interview_r2 complete_r2
	
	  //weights
	     mmerge y4_hhid using "$original\Round 2\secta_cover_page_r2", ukeep(wt_round2) urename(wt_round2 wt_r2)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		 use "$original\Round 2\sect2_household_roster_r2", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
			
			//fixing age
			   recode s2q6 (226=26) //assume 26
			   
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
            replace adulteq_r2 = 1.00 if (s2q5==1 & s2q6>=20) 
            replace adulteq_r2 = 0.27 if (s2q5==2 & s2q6==0) 
            replace adulteq_r2 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r2 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r2 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r2 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r2 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r2 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r2 = 0.73 if (s2q5==2 & s2q6>=20)      
			assert !(m0_14_r2==. & m15_64_r2==. & m65_r2==. & f0_14_r2==. & f15_64_r2==. & f65_r2==.)
			assert adulteq_r2!=.			
	        collapse (sum) hhsize_r2-adulteq_r2, by(y4_hhid)	
			tempfile hhsize			
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	   
         loc x hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2
		 foreach X in `x' {
		 	replace `X'=. if complete_r2!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 2\MW_FIES_round2", clear
			rename HHID y4_hhid
		    gen fies_mod_r2=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r2=(p_sev>=0.5 & p_sev!=.)
			keep y4_hhid *_r2
			tempfile fies_r2
			save `fies_r2', replace
		 restore
		 mmerge y4_hhid using `fies_r2', unmatched(master)
		 keep y4_hhid *_r2

** SAVE INTERMEDIATE FILES
      save "$intermed\Round2_hh.dta", replace

********************************************************************************
**                                 ROUND 3                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 3\sect12_interview_result_r3", clear
		 gen contact_r3=(inrange(s12q5,1,3))		 
		 gen interview_r3=(inlist(s12q5,1,2)) if contact_r3==1
		 gen complete_r3=(s12q5==1) if interview_r3==1
	     keep y4_hhid HHID contact_r3 interview_r3 complete_r3
	
	  //weights
	     mmerge y4_hhid using "$original\Round 3\secta_cover_page_r3", ukeep(wt_round3) urename(wt_round3 wt_r3)
		 keep if _m==3

	  //demographic information
	     preserve
		 use "$original\Round 3\sect2_household_roster_r3", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r3==. & m15_64_r3==. & m65_r3==. & f0_14_r3==. & f15_64_r3==. & f65_r3==.)
			assert adulteq_r3!=.			
	        collapse (sum) hhsize_r3-adulteq_r3, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3
		 foreach X in `x' {
		 	replace `X'=. if complete_r3!=1
		 }		 
		 
	  //fies
	     preserve
	        use "$original\Round 3\MW_FIES_round3", clear
			rename HHID y4_hhid
		    gen fies_mod_r3=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r3=(p_sev>=0.5 & p_sev!=.)
			keep y4_hhid *_r3
			tempfile fies_r3
			save `fies_r3', replace
		 restore
		 mmerge y4_hhid using `fies_r3', unmatched(master)
		 keep y4_hhid *_r3

** SAVE INTERMEDIATE FILES
      save "$intermed\Round3_hh.dta", replace

********************************************************************************
**                                 ROUND 4                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 4\sect12_Interview_Result_r4", clear
		 gen contact_r4=(inrange(s12q5,1,3))		 
		 gen interview_r4=(inlist(s12q5,1,2)) if contact_r4==1
		 gen complete_r4=(s12q5==1) if interview_r4==1
	     keep y4_hhid HHID contact_r4 interview_r4 complete_r4 
		   
	  //weights
	     mmerge y4_hhid using "$original\Round 4\secta_Cover_Page_r4", ukeep(wt_round4) urename(wt_round4 wt_r4)
		 keep if _m==3
	  
	  //demographic information
	     preserve
		    use "$original\Round 4\sect2_Household_Roster_r4", clear
		    //fixing member status
			   recode s2q3 (.=2) if y4_hhid=="1202-001" & PID==10
			   recode s2q3 (.=2) if y4_hhid=="0457-001" & PID==1			
			   recode s2q3 (.=1) if y4_hhid=="1158-003" & PID==1
				
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r4==. & m15_64_r4==. & m65_r4==. & f0_14_r4==. & f15_64_r4==. & f65_r4==.)
			assert adulteq_r4!=.			
	        collapse (sum) hhsize_r4-adulteq_r4, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4
		 foreach X in `x' {
		 	replace `X'=. if complete_r4!=1
		 }		 
		 keep y4_hhid *_r4
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round4_hh.dta", replace
  
********************************************************************************
**                                 ROUND 5                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 5\sect12_interview_Result_r5", clear
		 gen contact_r5=(inrange(s12q5,1,3))		 
		 gen interview_r5=(inlist(s12q5,1,2)) if contact_r5==1
		 gen complete_r5=(s12q5==1) if interview_r5==1
	     keep HHID y4_hhid contact_r5 interview_r5 complete_r5

	  //weights
	     mmerge y4_hhid using "$original\Round 5\secta_cover_page_r5", ukeep(wt_round5) urename(wt_round5 wt_r5)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 5\sect2_household_roster_r5", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r5==. & m15_64_r5==. & m65_r5==. & f0_14_r5==. & f15_64_r5==. & f65_r5==.)
			assert adulteq_r5!=.			
	        collapse (sum) hhsize_r5-adulteq_r5, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5
		 foreach X in `x' {
		 	replace `X'=. if complete_r5!=1
		 }		 
		 
	  //fies
	     preserve
	        use "$original\Round 5\MW_FIES_round5", clear
			rename HHID y4_hhid
		    gen fies_mod_r5=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r5=(p_sev>=0.5 & p_sev!=.)
			keep y4_hhid *_r5
			tempfile fies_r5
			save `fies_r5', replace
		 restore
		 mmerge y4_hhid using `fies_r5', unmatched(master)		 
		 keep y4_hhid *_r5	
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round5_hh.dta", replace
	
********************************************************************************
**                                 ROUND 6                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 6\sect12_Interview_Result_r6", clear
		 gen contact_r6=(inrange(s12q5,1,3))		 
		 gen interview_r6=(inlist(s12q5,1,2)) if contact_r6==1
		 gen complete_r6=(s12q5==1) if interview_r6==1
	     keep y4_hhid HHID contact_r6 interview_r6 complete_r6

	  //weights
	     mmerge y4_hhid using "$original\Round 6\secta_Cover_Page_r6", ukeep(wt_round6) urename(wt_round6 wt_r6)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 6\sect2_Household_Roster_r6", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r6==. & m15_64_r6==. & m65_r6==. & f0_14_r6==. & f15_64_r6==. & f65_r6==.)
			assert adulteq_r6!=.			
	        collapse (sum) hhsize_r6-adulteq_r6, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6
		 foreach X in `x' {
		 	replace `X'=. if complete_r6!=1
		 }		 
		 
		 keep y4_hhid *_r6
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round6_hh.dta", replace

********************************************************************************
**                                 ROUND 7                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 7\sect12_Interview_Result_r7", clear
		 gen contact_r7=(inrange(s12q5,1,3))		 
		 gen interview_r7=(inlist(s12q5,1,2)) if contact_r7==1
		 gen complete_r7=(s12q5==1) if interview_r7==1
	     keep y4_hhid HHID contact_r7 interview_r7 complete_r7

	  //weights
	     mmerge y4_hhid using "$original\Round 7\secta_Cover_Page_r7", ukeep(wt_round7) urename(wt_round7 wt_r7)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 7\sect2_Household_Roster_r7", clear
			 //fixing member status
			    recode s2q3 (.=1) if y4_hhid=="0500-004"
				recode s2q3 (.=1) if y4_hhid=="2493-008"
			    recode s2q3 (.=2) if y4_hhid=="1095-003" & inrange(PID,1,7)				
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r7==. & m15_64_r7==. & m65_r7==. & f0_14_r7==. & f15_64_r7==. & f65_r7==.)
			assert adulteq_r7!=.			
	        collapse (sum) hhsize_r7-adulteq_r7, by(y4_hhid)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7
		 foreach X in `x' {
		 	replace `X'=. if complete_r7!=1
		 }		 
		 
		 keep y4_hhid *_r7
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round7_hh.dta", replace	
	  

********************************************************************************
**                                 ROUND 8                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 8\sect12_Interview_Result_r8", clear
		 gen contact_r8=(inrange(s12q5,1,3))		 
		 gen interview_r8=(inlist(s12q5,1,2)) if contact_r8==1
		 gen complete_r8=(s12q5==1) if interview_r8==1
	     keep y4_hhid HHID contact_r8 interview_r8 complete_r8

	  //weights
	     mmerge y4_hhid using "$original\Round 8\secta_Cover_Page_r8", ukeep(wt_round8) urename(wt_round8 wt_r8)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 8\sect2_Household_Roster_r8", clear
			 //fixing member status
			    recode s2q3 (.=1) if y4_hhid=="0500-004"
				recode s2q3 (.=1) if y4_hhid=="2493-008"			
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r8==. & m15_64_r8==. & m65_r8==. & f0_14_r8==. & f15_64_r8==. & f65_r8==.)
			assert adulteq_r8!=.			
	        collapse (sum) hhsize_r8-adulteq_r8, by(y4_hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8
		 foreach X in `x' {
		 	replace `X'=. if complete_r8!=1
		 }		 
		 
		 keep y4_hhid *_r8
		
 ** SAVE INTERMEDIATE FILES
      save "$intermed\Round8_hh.dta", replace	

********************************************************************************
**                                 ROUND 9                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 9\sect12_Interview_Result_r9", clear
		 gen contact_r9=(inrange(s12q5,1,3))		 
		 gen interview_r9=(inlist(s12q5,1,2)) if contact_r9==1
		 gen complete_r9=(s12q5==1) if interview_r9==1
	     keep y4_hhid HHID contact_r9 interview_r9 complete_r9

	  //weights
	     mmerge y4_hhid using "$original\Round 9\secta_Cover_Page_r9", ukeep(wt_round9) urename(wt_round9 wt_r9)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 9\sect2_Household_Roster_r9", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r9==. & m15_64_r9==. & m65_r9==. & f0_14_r9==. & f15_64_r9==. & f65_r9==.)
			assert adulteq_r9!=.			
	        collapse (sum) hhsize_r9-adulteq_r9, by(y4_hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9
		 foreach X in `x' {
		 	replace `X'=. if complete_r9!=1
		 }		 
		 
		 keep y4_hhid *_r9

** SAVE INTERMEDIATE FILES
      save "$intermed\Round9_hh.dta", replace	  

********************************************************************************
**                                ROUND 11                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 11\sect12_Interview_Result_r11", clear
		 gen contact_r11=(inrange(s12q5,1,3))		 
		 gen interview_r11=(inlist(s12q5,1,2)) if contact_r11==1
		 gen complete_r11=(s12q5==1) if interview_r11==1
	     keep y4_hhid HHID contact_r11 interview_r11 complete_r11

	  //weights
	     mmerge y4_hhid using "$original\Round 11\secta_Cover_Page_r11", ukeep(wt_round11) urename(wt_round11 wt_r11)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 11\sect2_Household_Roster_r11", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
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
			assert !(m0_14_r11==. & m15_64_r11==. & m65_r11==. & f0_14_r11==. & f15_64_r11==. & f65_r11==.)
			assert adulteq_r11!=.			
	        collapse (sum) hhsize_r11-adulteq_r11, by(y4_hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r11 m0_14_r11 m15_64_r11 m65_r11 f0_14_r11 f15_64_r11 f65_r11 adulteq_r11
		 foreach X in `x' {
		 	replace `X'=. if complete_r11!=1
		 }		 
		 
		 keep y4_hhid *_r11

** SAVE INTERMEDIATE FILES
      save "$intermed\Round11_hh.dta", replace	  	  

********************************************************************************
**                                ROUND 12                                    **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 12\sect12_Interview_Result_r12", clear
		 gen contact_r12=(inrange(s12q5,1,3))		 
		 gen interview_r12=(inlist(s12q5,1,2)) if contact_r12==1
		 gen complete_r12=(s12q5==1) if interview_r12==1
	     keep y4_hhid HHID contact_r12 interview_r12 complete_r12


	  //weights
	     mmerge y4_hhid using "$original\Round 12\secta_Cover_Page_r12", ukeep(wt_round12) urename(wt_round12 wt_r12)
		 keep if _m==3
		 
	  //demographic information
	     preserve
		    use "$original\Round 12\sect2_Household_Roster_r12", clear
	        keep if (s2q2==1|s2q3==1)  //assuming person whose member status is "REFUSED" is not a member
		    gen hhsize_r12=1
		    gen m0_14_r12  = 1 if (s2q5==1 & inrange(s2q6,0,14)) 
		    gen m15_64_r12 = 1 if (s2q5==1 & inrange(s2q6,15,64))|(s2q5==1 & s2q6==.)
		    gen m65_r12    = 1 if (s2q5==1 & s2q6>=65 & s2q6!=.) 
		    gen f0_14_r12  = 1 if (s2q5==2 & inrange(s2q6,0,14)) 
		    gen f15_64_r12 = 1 if (s2q5==2 & inrange(s2q6,15,64))|(s2q5==2 & s2q6==.)
		    gen f65_r12    = 1 if (s2q5==2 & s2q6>=65 & s2q6!=.) 
		    gen adulteq_r12=. 
            replace adulteq_r12 = 0.27 if (s2q5==1 & s2q6==0) 
            replace adulteq_r12 = 0.45 if (s2q5==1 & inrange(s2q6,1,3)) 
            replace adulteq_r12 = 0.61 if (s2q5==1 & inrange(s2q6,4,6)) 
            replace adulteq_r12 = 0.73 if (s2q5==1 & inrange(s2q6,7,9)) 
            replace adulteq_r12 = 0.86 if (s2q5==1 & inrange(s2q6,10,12)) 
            replace adulteq_r12 = 0.96 if (s2q5==1 & inrange(s2q6,13,15)) 
            replace adulteq_r12 = 1.02 if (s2q5==1 & inrange(s2q6,16,19)) 
            replace adulteq_r12 = 1.00 if (s2q5==1 & s2q6 >=20) 
            replace adulteq_r12 = 0.27 if (s2q5==2 & s2q6 ==0) 
            replace adulteq_r12 = 0.45 if (s2q5==2 & inrange(s2q6,1,3)) 
            replace adulteq_r12 = 0.61 if (s2q5==2 & inrange(s2q6,4,6)) 
            replace adulteq_r12 = 0.73 if (s2q5==2 & inrange(s2q6,7,9)) 
            replace adulteq_r12 = 0.78 if (s2q5==2 & inrange(s2q6,10,12)) 
            replace adulteq_r12 = 0.83 if (s2q5==2 & inrange(s2q6,13,15)) 
            replace adulteq_r12 = 0.77 if (s2q5==2 & inrange(s2q6,16,19)) 
            replace adulteq_r12 = 0.73 if (s2q5==2 & s2q6 >=20)   
			assert !(m0_14_r12==. & m15_64_r12==. & m65_r12==. & f0_14_r12==. & f15_64_r12==. & f65_r12==.)
			assert adulteq_r12!=.			
	        collapse (sum) hhsize_r12-adulteq_r12, by(y4_hhid)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge y4_hhid using `hhsize'	
         loc x hhsize_r12 m0_14_r12 m15_64_r12 m65_r12 f0_14_r12 f15_64_r12 f65_r12 adulteq_r12
		 foreach X in `x' {
		 	replace `X'=. if complete_r12!=1
		 }		 
		 
		 keep y4_hhid *_r12
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round12_hh.dta", replace
	  
	  	  
********************************************************************************
**                             HEAD CHANGE                                    **
********************************************************************************
** GENERATE HOUSEHOLD HEAD ID
      use "$original\Round 0\Household\hh_mod_b_19", clear
	  keep if hh_b04==1
	  rename id_code headid_r0
	  keep y4_hhid headid_r0
	  isid y4_hhid
	  preserve
         use "$original\Round 1\sect2_household_roster_r1", clear
			 //fixing relationship
			    recode s2q7 (3=1) if y4_hhid=="0077-002" & PID==1
				recode s2q7 (2=1) if y4_hhid=="0251-001" & PID==1
				recode s2q9 (12=1) if y4_hhid=="0099-007" & PID==5		 
		 drop if s2q3==2|s2q3==99
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r1
		 keep y4_hhid headid_r1
		 isid y4_hhid
		 tempfile headid_r1
		 save `headid_r1', replace
	  restore
	  mmerge y4_hhid using `headid_r1'
	  preserve
         use "$original\Round 2\sect2_household_roster_r2", clear
			 //fixing relationship
				recode s2q9 (2=1) if y4_hhid=="2168-001" & PID==2		 
		 drop if s2q3==2
		 drop if s2q6==226
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r2
		 keep y4_hhid headid_r2
		 isid y4_hhid
		 tempfile headid_r2
		 save `headid_r2', replace
	  restore
	  mmerge y4_hhid using `headid_r2'	  
	  preserve
         use "$original\Round 3\sect2_household_roster_r3", clear
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r3
		 keep y4_hhid headid_r3
		 duplicates drop y4_hhid, force
		 isid y4_hhid
		 tempfile headid_r3
		 save `headid_r3', replace
	  restore
	  mmerge y4_hhid using `headid_r3'
	  preserve
         use "$original\Round 4\sect2_household_Roster_r4", clear
		    //fixing relationship & member status
			    recode s2q3 (.=2) if y4_hhid=="0457-001" & PID==1
				recode s2q7 (2=1) if y4_hhid=="0457-001" & PID==2			
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r4
		 keep y4_hhid headid_r4
		 isid y4_hhid
		 tempfile headid_r4
		 save `headid_r4', replace
	  restore
	  mmerge y4_hhid using `headid_r4'	
	  preserve
         use "$original\Round 5\sect2_household_roster_r5", clear
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r5
		 keep y4_hhid headid_r5
		 isid y4_hhid
		 tempfile headid_r5
		 save `headid_r5', replace
	  restore	  
	  mmerge y4_hhid using `headid_r5'	  
	  preserve
         use "$original\Round 6\sect2_Household_Roster_r6", clear
		 //fixing relationship
		    recode s2q7 (1=2) if y4_hhid=="1309-002" & PID==1
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r6
		 keep y4_hhid headid_r6
		 isid y4_hhid
		 tempfile headid_r6
		 save `headid_r6', replace
	  restore	  
	  mmerge y4_hhid using `headid_r6'	  
	  preserve
         use "$original\Round 7\sect2_Household_Roster_r7", clear
			 //fixing relationship & member status
			    recode s2q3 (.=2) if y4_hhid=="1095-003" & inrange(PID,1,7)
				recode s2q7 (5=1) if y4_hhid=="1095-003" & PID==8		 
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r7
		 keep y4_hhid headid_r7
		 isid y4_hhid
		 tempfile headid_r7
		 save `headid_r7', replace
	  restore	
	  mmerge y4_hhid using `headid_r7'		  
	  preserve
         use "$original\Round 8\sect2_Household_Roster_r8", clear
			 //fixing relationship
				recode s2q7 (5=1) if y4_hhid=="1095-003" & PID==8
                recode s2q9 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4		 
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r8
		 keep y4_hhid headid_r8
		 isid y4_hhid
		 tempfile headid_r8
		 save `headid_r8', replace
	  restore		  	  	  	  
	  mmerge y4_hhid using `headid_r8'	 
	  preserve
         use "$original\Round 9\sect2_Household_Roster_r9", clear
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3
				recode s2q9 (2=1) if y4_hhid=="0270-009" & PID==2		 
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r9
		 keep y4_hhid headid_r9
		 isid y4_hhid
		 tempfile headid_r9
		 save `headid_r9', replace
	  restore	
	  mmerge y4_hhid using `headid_r9'	 	  
	  preserve
         use "$original\Round 11\sect2_Household_Roster_r11", clear
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3			 
				recode s2q7 (2=1) if y4_hhid=="0270-009" & PID==2
				recode s2q9 (2=1) if y4_hhid=="0014-001" & PID==4
				recode s2q9 (2=1) if y4_hhid=="1350-002" & PID==2		 
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r11
		 keep y4_hhid headid_r11
		 isid y4_hhid
		 tempfile headid_r11
		 save `headid_r11', replace
	  restore	
	  mmerge y4_hhid using `headid_r11'	 	  
	  preserve
         use "$original\Round 12\sect2_Household_Roster_r12", clear
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3			 
				recode s2q7 (2=1) if y4_hhid=="0270-009" & PID==2
				recode s2q7 (2=1) if y4_hhid=="1350-002" & PID==2		 
		 drop if s2q3==2
	     keep if s2q7==1|s2q9==1
		 rename PID headid_r12
		 keep y4_hhid headid_r12
		 isid y4_hhid
		 tempfile headid_r12
		 save `headid_r12', replace
	  restore		  	  	  	  
	  mmerge y4_hhid using `headid_r12'	
	  mmerge y4_hhid using "$intermed\Round1_hh.dta", ukeep(complete_r1)	  
	  mmerge y4_hhid using "$intermed\Round2_hh.dta", ukeep(complete_r2)
	  mmerge y4_hhid using "$intermed\Round3_hh.dta", ukeep(complete_r3)	
	  mmerge y4_hhid using "$intermed\Round4_hh.dta", ukeep(complete_r4)	
	  mmerge y4_hhid using "$intermed\Round5_hh.dta", ukeep(complete_r5)
	  mmerge y4_hhid using "$intermed\Round6_hh.dta", ukeep(complete_r6)
	  mmerge y4_hhid using "$intermed\Round7_hh.dta", ukeep(complete_r7)
	  mmerge y4_hhid using "$intermed\Round8_hh.dta", ukeep(complete_r8)	  
	  mmerge y4_hhid using "$intermed\Round9_hh.dta", ukeep(complete_r9)
	  mmerge y4_hhid using "$intermed\Round11_hh.dta", ukeep(complete_r11)
	  mmerge y4_hhid using "$intermed\Round12_hh.dta", ukeep(complete_r12)
	  
	  forvalues i=1/9 {
	     replace headid_r`i'=. if complete_r`i'!=1
	  }
	  
	  forvalues i=11/12 {
	     replace headid_r`i'=. if complete_r`i'!=1
	  }
	  
	  gen head_chg_r1=(headid_r0!=headid_r1) if complete_r1==1 
	  gen head_chg_r2=(headid_r1!=headid_r2) if complete_r2==1
      gen head_chg_r3=(headid_r2!=headid_r3) if complete_r3==1 & complete_r2==1
	  recode head_chg_r3 (.=0) if (headid_r1==headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r3 (.=1) if (headid_r1!=headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1==1
	  gen head_chg_r4=(headid_r3!=headid_r4) if complete_r4==1 & complete_r3==1	  
	  recode head_chg_r4 (.=0) if (headid_r2==headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2==1  
	  recode head_chg_r4 (.=1) if (headid_r2!=headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r4 (.=0) if (headid_r1==headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2!=1	& complete_r1==1		  
	  recode head_chg_r4 (.=1) if (headid_r1!=headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  gen head_chg_r5=(headid_r4!=headid_r5) if complete_r5==1 & complete_r4==1	 	  
	  recode head_chg_r5 (.=0) if (headid_r3==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r5 (.=1) if (headid_r3!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r5 (.=0) if (headid_r2==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1	& complete_r2==1
	  recode head_chg_r5 (.=1) if (headid_r2!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1	& complete_r2==1
	  recode head_chg_r5 (.=0) if (headid_r1==headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1	& complete_r2!=1 & complete_r1==1
	  recode head_chg_r5 (.=1) if (headid_r1!=headid_r5) & complete_r5==1 & complete_r4!=1 & complete_r3!=1	& complete_r2!=1 & complete_r1==1
	  gen head_chg_r6=(headid_r5!=headid_r6) if complete_r6==1 & complete_r5==1	 	  
	  recode head_chg_r6 (.=0) if (headid_r4==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=1) if (headid_r4!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=0) if (headid_r3==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3==1
	  recode head_chg_r6 (.=1) if (headid_r3!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3==1
	  recode head_chg_r6 (.=0) if (headid_r2==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2==1
	  recode head_chg_r6 (.=1) if (headid_r2!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2==1	  
	  recode head_chg_r6 (.=0) if (headid_r1==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r6 (.=1) if (headid_r1!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2!=1 & complete_r1==1     
	  gen head_chg_r7=(headid_r6!=headid_r7) if complete_r7==1 & complete_r6==1	 	  
	  recode head_chg_r7 (.=0) if (headid_r5==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r7 (.=1) if (headid_r5!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5==1
	  recode head_chg_r7 (.=0) if (headid_r4==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4==1
	  recode head_chg_r7 (.=1) if (headid_r4!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4==1
	  recode head_chg_r7 (.=0) if (headid_r3==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3==1
	  recode head_chg_r7 (.=1) if (headid_r3!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3==1	  
	  recode head_chg_r7 (.=0) if (headid_r2==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r7 (.=1) if (headid_r2!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3!=1 & complete_r2==1 	  
	  recode head_chg_r7 (.=0) if (headid_r1==headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r7 (.=1) if (headid_r1!=headid_r7) & complete_r7==1 & complete_r6!=1 & complete_r5!=1	& complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1 	  
	  gen head_chg_r8=(headid_r7!=headid_r8) if complete_r8==1 & complete_r7==1	 	  
	  recode head_chg_r8 (.=0) if (headid_r6==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r8 (.=1) if (headid_r6!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r8 (.=0) if (headid_r5==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5==1
	  recode head_chg_r8 (.=1) if (headid_r5!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5==1
	  recode head_chg_r8 (.=0) if (headid_r4==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4==1
	  recode head_chg_r8 (.=1) if (headid_r4!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4==1	  
	  recode head_chg_r8 (.=0) if (headid_r3==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r8 (.=1) if (headid_r3!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3==1 	  
	  recode head_chg_r8 (.=0) if (headid_r2==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r8 (.=1) if (headid_r2!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 	 
	  recode head_chg_r8 (.=0) if (headid_r1==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1
	  recode head_chg_r8 (.=1) if (headid_r1!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1 	  	  
	  gen head_chg_r9=(headid_r8!=headid_r9) if complete_r9==1 & complete_r8==1	 	  
	  recode head_chg_r9 (.=0) if (headid_r7==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=1) if (headid_r7!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=0) if (headid_r6==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r9 (.=1) if (headid_r6!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1
	  recode head_chg_r9 (.=0) if (headid_r5==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5==1
	  recode head_chg_r9 (.=1) if (headid_r5!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5==1
	  recode head_chg_r9 (.=0) if (headid_r4==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4==1
	  recode head_chg_r9 (.=1) if (headid_r4!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4==1	  
	  recode head_chg_r9 (.=0) if (headid_r3==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r9 (.=1) if (headid_r3!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3==1 	  
	  recode head_chg_r9 (.=0) if (headid_r2==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r9 (.=1) if (headid_r2!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 	 
	  recode head_chg_r9 (.=0) if (headid_r1==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1
	  recode head_chg_r9 (.=1) if (headid_r1!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1 
	  recode head_chg_r9 (.=0) if complete_r9==1 & head_chg_r9==.
	  gen head_chg_r11=(headid_r9!=headid_r11) if complete_r11==1 & complete_r9==1	 	  
	  recode head_chg_r11 (.=0) if (headid_r8==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r11 (.=1) if (headid_r8!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8==1 
	  recode head_chg_r11 (.=0) if (headid_r7==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r11 (.=1) if (headid_r7!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1 
	  recode head_chg_r11 (.=0) if (headid_r6==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1	
	  recode head_chg_r11 (.=1) if (headid_r6!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1	
	  recode head_chg_r11 (.=0) if (headid_r5==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1 
	  recode head_chg_r11 (.=1) if (headid_r5!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1   
	  recode head_chg_r11 (.=0) if (headid_r4==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r11 (.=1) if (headid_r4!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1 	  
	  recode head_chg_r11 (.=0) if (headid_r3==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 
	  recode head_chg_r11 (.=1) if (headid_r3!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 	 
	  recode head_chg_r11 (.=0) if (headid_r2==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r11 (.=1) if (headid_r2!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1  
	  recode head_chg_r11 (.=0) if (headid_r1==headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1
	  recode head_chg_r11 (.=1) if (headid_r1!=headid_r11) & complete_r11==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1 
	  gen head_chg_r12=(headid_r11!=headid_r12) if complete_r12==1 & complete_r11==1		  
	  recode head_chg_r12 (.=0) if (headid_r9==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9==1
	  recode head_chg_r12 (.=1) if (headid_r9!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9==1  
	  recode head_chg_r12 (.=0) if (headid_r8==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8==1
	  recode head_chg_r12 (.=1) if (headid_r8!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8==1 
	  recode head_chg_r12 (.=0) if (headid_r7==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r12 (.=1) if (headid_r7!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7==1 
	  recode head_chg_r12 (.=0) if (headid_r6==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1	
	  recode head_chg_r12 (.=1) if (headid_r6!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6==1	
	  recode head_chg_r12 (.=0) if (headid_r5==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1 
	  recode head_chg_r12 (.=1) if (headid_r5!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5==1   
	  recode head_chg_r12 (.=0) if (headid_r4==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r12 (.=1) if (headid_r4!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4==1 	  
	  recode head_chg_r12 (.=0) if (headid_r3==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 
	  recode head_chg_r12 (.=1) if (headid_r3!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 	 
	  recode head_chg_r12 (.=0) if (headid_r2==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r12 (.=1) if (headid_r2!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1  
	  recode head_chg_r12 (.=0) if (headid_r1==headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1
	  recode head_chg_r12 (.=1) if (headid_r1!=headid_r12) & complete_r12==1 & complete_r11!=1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1  & complete_r1==1 
	  recode head_chg_r12 (.=0) if complete_r12==1 & head_chg_r12==.
	  keep y4_hhid head_chg_r*
	  
	  
** SAVE INTERMEDIATE FILES
      save "$intermed\Head.dta", replace
	  
********************************************************************************
**                           RESPONDENT CHANGE                                **
********************************************************************************
** GENERATE RESPONDENT ID		 
      use "$original\Round 1\sect12_interview_result_r1", clear
      rename s12q9 respid_r1
      keep y4_hhid respid_r1
	  isid y4_hhid
	  tempfile respid_r1
	  save `respid_r1', replace
	  preserve
         use "$original\Round 2\sect12_interview_result_r2", clear
         rename s12q9 respid_r2
         keep y4_hhid respid_r2
		 isid y4_hhid
		 tempfile respid_r2
		 save `respid_r2', replace
	  restore
	  mmerge y4_hhid using `respid_r2'	  
	  preserve
         use "$original\Round 3\sect12_interview_result_r3", clear
         rename s12q9 respid_r3
         keep y4_hhid respid_r3
		 isid y4_hhid
		 tempfile respid_r3
		 save `respid_r3', replace
	  restore
	  mmerge y4_hhid using `respid_r3'  
	  preserve
         use "$original\Round 4\sect12_Interview_Result_r4", clear
         rename s12q9 respid_r4
         keep y4_hhid respid_r4
		 isid y4_hhid
		 tempfile respid_r4
		 save `respid_r4', replace
	  restore
	  mmerge y4_hhid using `respid_r4' 	
	  preserve
         use "$original\Round 5\sect12_interview_result_r5", clear
         rename s12q9 respid_r5
         keep y4_hhid respid_r5
		 isid y4_hhid
		 tempfile respid_r5
		 save `respid_r5', replace
	  restore
	  mmerge y4_hhid using `respid_r5'   	  
	  preserve
         use "$original\Round 6\sect12_Interview_Result_r6", clear
         rename s12q9 respid_r6
         keep y4_hhid respid_r6
		 isid y4_hhid
		 tempfile respid_r6
		 save `respid_r6', replace
	  restore
	  mmerge y4_hhid using `respid_r6'  
	  preserve
         use "$original\Round 7\sect12_Interview_Result_r7", clear
         rename s12q9 respid_r7
         keep y4_hhid respid_r7
		 isid y4_hhid
		 tempfile respid_r7
		 save `respid_r7', replace
	  restore
	  mmerge y4_hhid using `respid_r7'	  
	  preserve
         use "$original\Round 8\sect12_Interview_Result_r8", clear
         rename s12q9 respid_r8
         keep y4_hhid respid_r8
		 isid y4_hhid
		 tempfile respid_r8
		 save `respid_r8', replace
	  restore
	  mmerge y4_hhid using `respid_r8'	
  	  preserve
         use "$original\Round 9\sect12_Interview_Result_r9", clear
         rename s12q9 respid_r9
         keep y4_hhid respid_r9
		 isid y4_hhid
		 tempfile respid_r9
		 save `respid_r9', replace
	  restore
	  mmerge y4_hhid using `respid_r9'	                  
  	  preserve
         use "$original\Round 11\sect12_Interview_Result_r11", clear
         rename s12q9 respid_r11
         keep y4_hhid respid_r11
		 isid y4_hhid
		 tempfile respid_r11
		 save `respid_r11', replace
	  restore
	  mmerge y4_hhid using `respid_r11'	                  
  	  preserve
       use "$original\Round 12\sect12_Interview_Result_r12", clear
         rename s12q9 respid_r12
         keep y4_hhid respid_r12
		 isid y4_hhid
		 tempfile respid_r12
		 save `respid_r12', replace
	  restore
	  mmerge y4_hhid using `respid_r12'	                  
	
  
	  forvalues i=1/9 {
	  	 mmerge y4_hhid using "$intermed\Round`i'_hh.dta", ukeep(interview_r`i')
	     replace respid_r`i'=. if interview_r`i'!=1
	  }	
	  forvalues i=11/12 {
	  	 mmerge y4_hhid using "$intermed\Round`i'_hh.dta", ukeep(interview_r`i')
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
	  recode respond_chg_r8 (.=0) if (respid_r6==respid_r8) & respid_r6!=. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r6!=respid_r8) & respid_r6!=. & respid_r7==. & respid_r8!=.	  
	  recode respond_chg_r8 (.=0) if (respid_r5==respid_r8) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r5!=respid_r8) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8!=.	
	  recode respond_chg_r8 (.=0) if (respid_r4==respid_r8) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r4!=respid_r8) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=0) if (respid_r3==respid_r8) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r3!=respid_r8) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=0) if (respid_r2==respid_r8) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r2!=respid_r8) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.	
	  recode respond_chg_r8 (.=0) if (respid_r1==respid_r8) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.
	  recode respond_chg_r8 (.=1) if (respid_r1!=respid_r8) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8!=.	  	  
	  gen respond_chg_r9=(respid_r8!=respid_r9) if respid_r8!=. & respid_r9!=.	  
	  recode respond_chg_r9 (.=0) if (respid_r7==respid_r9) & respid_r7!=. & respid_r8==. & respid_r9!=. 
	  recode respond_chg_r9 (.=1) if (respid_r7!=respid_r9) & respid_r7!=. & respid_r8==. & respid_r9!=.  
	  recode respond_chg_r9 (.=0) if (respid_r6==respid_r9) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r6!=respid_r9) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9!=.	  
	  recode respond_chg_r9 (.=0) if (respid_r5==respid_r9) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r5!=respid_r9) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==.	 & respid_r9!=.
	  recode respond_chg_r9 (.=0) if (respid_r4==respid_r9) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r4!=respid_r9) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=0) if (respid_r3==respid_r9) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r3!=respid_r9) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=0) if (respid_r2==respid_r9) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r2!=respid_r9) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.	
	  recode respond_chg_r9 (.=0) if (respid_r1==respid_r9) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.
	  recode respond_chg_r9 (.=1) if (respid_r1!=respid_r9) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9!=.	  		 
	  gen respond_chg_r11=(respid_r9!=respid_r11) if respid_r9!=. & respid_r11!=.	
	  recode respond_chg_r11 (.=0) if (respid_r8==respid_r11) & respid_r8!=. & respid_r9==. & respid_r11!=. 
	  recode respond_chg_r11 (.=1) if (respid_r8!=respid_r11) & respid_r8!=. & respid_r9==. & respid_r11!=.  	  
	  recode respond_chg_r11 (.=0) if (respid_r7==respid_r11) & respid_r7!=. & respid_r8==. & respid_r9==. & respid_r11!=. 
	  recode respond_chg_r11 (.=1) if (respid_r7!=respid_r11) & respid_r7!=. & respid_r8==. & respid_r9==. & respid_r11!=.  
	  recode respond_chg_r11 (.=0) if (respid_r6==respid_r11) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r6!=respid_r11) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.	  
	  recode respond_chg_r11 (.=0) if (respid_r5==respid_r11) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r5!=respid_r11) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=0) if (respid_r4==respid_r11) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r4!=respid_r11) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=0) if (respid_r3==respid_r11) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r3!=respid_r11) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=0) if (respid_r2==respid_r11) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r2!=respid_r11) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.	
	  recode respond_chg_r11 (.=0) if (respid_r1==respid_r11) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.
	  recode respond_chg_r11 (.=1) if (respid_r1!=respid_r11) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11!=.	  		 
	  gen respond_chg_r12=(respid_r11!=respid_r12) if respid_r11!=. & respid_r12!=.	
	  recode respond_chg_r12 (.=0) if (respid_r8==respid_r12) & respid_r9!=. & respid_r11==. & respid_r12!=. 
	  recode respond_chg_r12 (.=1) if (respid_r8!=respid_r12) & respid_r9!=. & respid_r11==. & respid_r12!=.  	  	  
	  recode respond_chg_r12 (.=0) if (respid_r8==respid_r12) & respid_r8!=. & respid_r9==. & respid_r11==. & respid_r12!=. 
	  recode respond_chg_r12 (.=1) if (respid_r8!=respid_r12) & respid_r8!=. & respid_r9==. & respid_r11==. & respid_r12!=.  	  
	  recode respond_chg_r12 (.=0) if (respid_r7==respid_r12) & respid_r7!=. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=. 
	  recode respond_chg_r12 (.=1) if (respid_r7!=respid_r12) & respid_r7!=. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.  
	  recode respond_chg_r12 (.=0) if (respid_r6==respid_r12) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r6!=respid_r12) & respid_r6!=. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.	  
	  recode respond_chg_r12 (.=0) if (respid_r5==respid_r12) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r5!=respid_r12) & respid_r5!=. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=0) if (respid_r4==respid_r12) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r4!=respid_r12) & respid_r4!=. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=0) if (respid_r3==respid_r12) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r3!=respid_r12) & respid_r3!=. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=0) if (respid_r2==respid_r12) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r2!=respid_r12) & respid_r2!=. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.	
	  recode respond_chg_r12 (.=0) if (respid_r1==respid_r12) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.
	  recode respond_chg_r12 (.=1) if (respid_r1!=respid_r12) & respid_r1!=. & respid_r2==. & respid_r3==. & respid_r4==. & respid_r5==. & respid_r6==. & respid_r7==. & respid_r8==. & respid_r9==. & respid_r11==. & respid_r12!=.	  		 

	  keep y4_hhid respond_chg_r*

** SAVE INTERMEDIATE FILES
      save "$intermed\Respondent.dta", replace

** MERGING ALL THE FILES
      use "$intermed\Round0_hh.dta", clear
	  forvalues i=1/9 {
	     mmerge y4_hhid using "$intermed\Round`i'_hh.dta"		
	  }
	  forvalues i=11/12 {
	     mmerge y4_hhid using "$intermed\Round`i'_hh.dta"		
	  }
	  
	  mmerge y4_hhid using "$intermed\Head.dta"
	  mmerge y4_hhid using "$intermed\Respondent.dta"
	  drop _m
	  drop if wt_r0==.
	  
** UPDATE VARIABLE
      recode phone_sample (.=0)	  
	  recode contact_r* (.=0) if phone_sample==1
	  
** DROP UNNECESSARY VARIABLES & LABELS

** VALIDATE
      run "$dofiles\hh_validation.do"
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\hh_label.do"	  
	  
** CHECK FOR DUPLICATES
      bysort y4_hhid: assert _n==1
	  assert _N==$totalHH
	
** LABEL DATA 
      label data "Malawi COVID-19 - Harmonized Dataset (Household Level)"
      label var y4_hhid "Household ID"
		
** ORDER VARIABLES
      order y4_hhid  ea year rural ea_latitude ea_longitude dwelling roof floor walls toilet water rooms elect ///
            tv radio refrigerator bicycle mcycle car mphone computer internet generator land land_tot land_cultivated ///
			cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj rent remit assist finance ///
			any_work ag_work nfe_work ext_work nfe crop crop_number cash_crop org_fert inorg_fert pest_fung_herb hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ///
			tractor ph_loss sell_crop sell_process sell_unprocess livestock lruminant sruminant poultry equines camelids pig bee ///
			hhsize_r0 m0_14_r0 m15_64_r0 m65_r0 f0_14_r0 f15_64_r0 f65_r0 adulteq_r0 ///
			phone_sample contact_r1 interview_r1 complete_r1 hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 fies_mod_r1 fies_sev_r1 head_chg_r1 wt_r1 ///
            contact_r2 interview_r2 complete_r2 hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2 fies_mod_r2 fies_sev_r2 head_chg_r2 respond_chg_r2 wt_r2 ///
            contact_r3 interview_r3 complete_r3 hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3 fies_mod_r3 fies_sev_r3 head_chg_r3 respond_chg_r3 wt_r3  ///
			contact_r4 interview_r4 complete_r4 hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4  head_chg_r4 respond_chg_r4 wt_r4  ///
			contact_r5 interview_r5 complete_r5 hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5 fies_mod_r5 fies_sev_r5 head_chg_r5 respond_chg_r5 wt_r5  ///
            contact_r6 interview_r6 complete_r6 hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6 head_chg_r6 respond_chg_r6 wt_r6  ///
            contact_r7 interview_r7 complete_r7 hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7 head_chg_r7 respond_chg_r7 wt_r7  ///
			contact_r8 interview_r8 complete_r8 hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8 head_chg_r8 respond_chg_r8 wt_r8  ///
			contact_r9 interview_r9 complete_r9 hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9 head_chg_r9 respond_chg_r9 wt_r9 ///
			contact_r11 interview_r11 complete_r11 hhsize_r11 m0_14_r11 m15_64_r11 m65_r11 f0_14_r11 f15_64_r11 f65_r11 adulteq_r11 head_chg_r11 respond_chg_r11 wt_r11 ///
			contact_r12 interview_r12 complete_r12 hhsize_r12 m0_14_r12 m15_64_r12 m65_r12 f0_14_r12 f15_64_r12 f65_r12 adulteq_r12 head_chg_r12 respond_chg_r12 wt_r12 
			
** SAVE FILE 
      isid y4_hhid
	  sort y4_hhid
	  compress
      saveold "$harmonized\MWI_HH.dta", replace
 
********************************************************************************
**                          INDIVIDUAL LEVEL DATA                             **
********************************************************************************
********************************************************************************
**                                  ROUND 0                                   **
********************************************************************************

** OPEN DATA 
      use "$original\Round 0\Household\hh_mod_b_19", clear
	  	  
** GENERATE VARIABLES
	  //demographic information  
         gen sex=hh_b03
         gen age=hh_b05a
		 gen member_r0=1
	     gen head_r0=(hh_b04==1)
	     gen relation_r0=hh_b04
		 label copy hh_b04 relation_r0
		 label val relation_r0 relation_r0	
		 gen relation_os_r0=""
	     gen married=(inlist(hh_b24,1,2))
		 gen form_married=(inlist(hh_b24,3,4,5))
		 gen nev_married=(hh_b24==6)
	     gen religion=(hh_b23==3)
			replace religion=2 if hh_b23==4
			recode religion (0=3)
	     keep y4_hhid PID sex-religion hh_b06_2 id_code
		 
      //disability
	     mmerge y4_hhid PID using "$original\Round 0\Household\hh_mod_d_19", ukeep(hh_d24 hh_d25 hh_d26 hh_d27 hh_d28 hh_d29) unmatched(master)
		 gen vision=(inlist(hh_d24,3,4)) if hh_d24!=.
		 gen hearing=(inlist(hh_d25,3,4)) if hh_d25!=.
		 gen mobility=(inlist(hh_d26,3,4)) if hh_d26!=.
		 gen communication=(inlist(hh_d29,3,4)) if hh_d29!=.
		 gen selfcare=(inlist(hh_d28,3,4)) if hh_d28!=.
		 gen cognition=(inlist(hh_d27,3,4)) if hh_d27!=.
		 gen disability=(vision==1|hearing==1|mobility==1|communication==1|selfcare==1|cognition==1)
		 replace disability=. if vision==. & hearing==. & mobility==. & communication==. & selfcare==. & cognition==.
		 drop hh_d24-cognition
		 
	  //education		 
	     mmerge y4_hhid PID using "$original\Round 0\Household\hh_mod_c_19", ukeep(hh_c05_1 hh_c06 hh_c08) unmatched(master)
	     gen literacy=(hh_c05_1==1)
		 gen educ=. 
		 recode educ (.=0) if hh_c06==2|hh_c08==0|inrange(hh_c08,1,7)|inlist(hh_c08,1)
		 recode educ (.=1) if inrange(hh_c08,8,13)|hh_c08==12
	     recode educ (.=2) if hh_c08==14
		 recode educ (.=3) if inlist(hh_c08,15,16,17,18,19,20,21,22,23)
	     recode educ (.=0) if hh_c08==1 
		 
	  //work
	     mmerge y4_hhid PID using "$original\Round 0\Household\hh_mod_e_19", ukeep(hh_e06_1a hh_e06_1b hh_e06_1c hh_e06_2 hh_e06_3 hh_e06_4 hh_e06_5 hh_e06_6)
         gen work=(hh_e06_1a==1|hh_e06_1b==1|hh_e06_1c==1|hh_e06_2==1 | hh_e06_3==1 | hh_e06_4==1 | hh_e06_5==1 | hh_e06_6==1)
	  
** DROP HOUSEHOLDS WITH INCOMPLETE INTERVIEWS
	  

** KEEP ONLY MEMBERS
      drop if hh_b06_2==3 | hh_b06_2==4
	  drop hh_b06_2
	  drop PID 
	  rename id_code PID

** DROP UNNECESSARY VARIABLES
      drop hh_c05_1 hh_c06 hh_c08 hh_e06_3 hh_e06_1a hh_e06_2 hh_e06_5 _merge hh_e06_1b hh_e06_1c hh_e06_4 hh_e06_6

** CHECK HEAD
      preserve
	     collapse (max) head_r0, by(y4_hhid)
		  * assert head_r0==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r0, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r0) unmatched(master)
		 assert member_r0==hhsize_r0
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round0_ind.dta", replace
	  
********************************************************************************
**                               ROUND 1                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 1\sect2_household_roster_r1", clear 
	  mmerge y4_hhid using "$original\Round 1\sect12_interview_result_r1", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r1) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
		    //fixing member status
			   recode s2q3 (.=2) if y4_hhid=="0251-001" & PID==4
			   recode s2q3 (.=2) if y4_hhid=="0880-001" & PID==2	  
			   
			 //fixing relationship
			    recode s2q7 (3=1) if y4_hhid=="0077-002" & PID==1
				recode s2q7 (2=1) if y4_hhid=="0251-001" & PID==1
				recode s2q9 (12=1) if y4_hhid=="0099-007" & PID==5
				
	     gen member_r1=(s2q2==1|s2q3==1)
		 gen sex_r1=s2q5
		 gen age_r1=s2q6
	     gen head_r1=(s2q7==1|s2q9==1)
	     gen relation_r1=s2q7 
		 replace relation_r1=s2q9 if relation_r1==. & s2q9!=.
		 label copy s2q9 relation_r1
		 label val relation_r1 relation_r1
		 replace relation_r1=. if member_r1!=1
		 replace head_r1=0 if member_r1!=1		 
		 gen relation_os_r1=s2q7_os if relation_r1==16
		 replace relation_os_r1=s2q9_os if relation_os_r1=="" & relation_r1==16
		 		 
	  //respondent		 	     
	     gen respond_r1=(PID==s12q9) if s12q9!=.
		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r1 sex_r1 age_r1 head_r1 relation_r1 relation_os_r1 respond_r1
	  
** DROP HOUSEHOLDS NOT IN THE HOUSEHOLD-LEVEL  DATA 
      drop if inlist(y4_hhid,"0256-001","1229-001","2230-001")

** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r1) unmatched(master)
	     collapse (max) head_r1, by(y4_hhid)
		 assert head_r1==1
	  restore	 
	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r1, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r1 complete_r1) unmatched(master)
		 assert _m==3
		 assert member_r1==hhsize_r1 if complete_r1==1
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round1_ind.dta", replace		 

********************************************************************************
**                               ROUND 2                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 2\sect2_household_roster_r2", clear 
	  mmerge y4_hhid using "$original\Round 2\sect12_interview_result_r2", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r2) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q9 (2=1) if y4_hhid=="2168-001" & PID==2
				
	     gen member_r2=(s2q2==1|s2q3==1)
		 gen sex_r2=s2q5
		 gen age_r2=s2q6
	     gen head_r2=(s2q7==1|s2q9==1)
	     gen relation_r2=s2q7 
		 replace relation_r2=s2q9 if relation_r2==. & s2q9!=.
		 label copy s2q7 relation_r2
		 label val relation_r2 relation_r2	
		 replace relation_r2=. if member_r2!=1
		 replace head_r2=0 if member_r2!=1			 
		 gen relation_os_r2=s2q7_os  if relation_r2==16
		 replace relation_os_r2=s2q9_os if relation_os_r2=="" & relation_r2==16
		 
	  //respondent		 	     
	     gen respond_r2=(PID==s12q9) if s12q9!=.
	
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r2 sex_r2 age_r2 head_r2 relation_r2 relation_os_r2 respond_r2

** DROP HOUSEHOLDS NOT IN THE HOUSEHOLD-LEVEL  DATA 
      drop if inlist(y4_hhid,"0256-001","2230-001")
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r2) unmatched(master)
	     collapse (max) head_r2, by(y4_hhid)
		 assert head_r2==1
	  restore	 
	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r2, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r2 complete_r2) unmatched(master)
		 assert member_r2==hhsize_r2 if complete_r2==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round2_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 3                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 3\sect2_household_roster_r3", clear 
	  mmerge y4_hhid using "$original\Round 3\sect12_interview_result_r3", ukeep(s12q9) unmatched(master)
	  *mmerge hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r3) unmatched(master)
	  
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
		 replace relation_r3=. if member_r3!=1
		 replace head_r3=0 if member_r3!=1			 
		 gen relation_os_r3=s2q7_os if relation_r3==16
		 replace relation_os_r3=s2q9_os if relation_os_r3=="" & relation_r3==16
		 
	  //respondent		 	     
	     gen respond_r3=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r3 sex_r3 age_r3 head_r3 relation_r3 relation_os_r3 respond_r3

** DROP HOUSEHOLDS NOT IN THE HOUSEHOLD-LEVEL  DATA 
      drop if inlist(y4_hhid,"0256-001","2230-001")
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r3) unmatched(master)
	     collapse (max) head_r3, by(y4_hhid)
		 assert head_r3==1
	  restore	 
	 
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r3, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r3 complete_r3) unmatched(master)
		 assert member_r3==hhsize_r3 if complete_r3==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round3_ind.dta", replace
	  
	  
********************************************************************************
**                               ROUND 4                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 4\sect2_household_roster_r4", clear 
	  mmerge y4_hhid using "$original\Round 4\sect12_interview_result_r4", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q7 (2=1) if y4_hhid=="0457-001" & PID==2
				
			 //fixing member status				
				recode s2q3 (.=1) if y4_hhid=="1158-003" & PID==1
				
	     gen member_r4=(s2q2==1|s2q3==1)
		 gen sex_r4=s2q5
		 gen age_r4=s2q6
	     gen head_r4=(s2q7==1|s2q9==1)
	     gen relation_r4=s2q7
		 replace relation_r4=s2q9 if relation_r4==. & s2q9!=.
		 label copy s2q7 relation_r4
		 label val relation_r4 relation_r4	
		 replace relation_r4=. if member_r4!=1
		 replace head_r4=0 if member_r4!=1		 
		 gen relation_os_r4=s2q7_os if relation_r4==16
		 replace relation_os_r4=s2q9_os if relation_os_r4=="" & relation_r4==16
		 
	  //respondent		 	     
	     gen respond_r4=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r4 sex_r4 age_r4 head_r4 relation_r4 relation_os_r4 respond_r4

** DROP HOUSEHOLDS NOT IN THE HOUSEHOLD-LEVEL  DATA 
      drop if inlist(y4_hhid,"0256-001","2230-001")
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r4) unmatched(master)
	     collapse (max) head_r4, by(y4_hhid)
		 assert head_r4==1
	  restore	 
	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r4, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r4 complete_r4) unmatched(master)
		 assert member_r4==hhsize_r4 if complete_r4==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round4_ind.dta", replace	  
	
********************************************************************************
**                               ROUND 5                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 5\sect2_household_roster_r5", clear 
	  mmerge y4_hhid using "$original\Round 5\sect12_interview_result_r5", ukeep(s12q9) unmatched(master)	  
	  
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
		 replace relation_r5=. if member_r5!=1
		 replace head_r5=0 if member_r5!=1		 
		 gen relation_os_r5=s2q7_os if relation_r5==16
		 replace relation_os_r5=s2q9_os if relation_os_r5=="" & relation_r5==16
		 
	  //respondent		 	     
	     gen respond_r5=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r5 sex_r5 age_r5 head_r5 relation_r5 relation_os_r5 respond_r5

** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r5) unmatched(master)
	     collapse (max) head_r5, by(y4_hhid)
		 assert head_r5==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r5, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r5 complete_r5) unmatched(master)
		 assert member_r5==hhsize_r5 if complete_r5==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round5_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 6                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 6\sect2_household_roster_r6", clear 
	  mmerge y4_hhid using "$original\Round 6\sect12_interview_result_r6", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
	     //fixing relationship
		    recode s2q7 (1=2) if y4_hhid=="1309-002" & PID==1
	     gen member_r6=(s2q2==1|s2q3==1)
		 gen sex_r6=s2q5
		 gen age_r6=s2q6
	     gen head_r6=(s2q7==1|s2q9==1)
	     gen relation_r6=s2q7
		 replace relation_r6=s2q9 if relation_r6==. & s2q9!=.
		 label copy s2q7 relation_r6
		 label val relation_r6 relation_r6		
		 replace relation_r6=. if member_r6!=1
		 replace head_r6=0 if member_r6!=1			 
		 gen relation_os_r6=s2q7_os if relation_r6==16
		 replace relation_os_r6=s2q9_os if relation_os_r6=="" & relation_r6==16
		 
	  //respondent		 	     
	     gen respond_r6=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r6 sex_r6 age_r6 head_r6 relation_r6 relation_os_r6 respond_r6

** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r6) unmatched(master)
	     collapse (max) head_r6, by(y4_hhid)
		 assert head_r6==1
	  restore	 
	 
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r6, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r6 complete_r6) unmatched(master)
		 assert member_r6==hhsize_r6 if complete_r6==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round6_ind.dta", replace		  
	  
********************************************************************************
**                               ROUND 7                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 7\sect2_household_roster_r7", clear 
	  mmerge y4_hhid using "$original\Round 7\sect12_interview_result_r7", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing member status
			    recode s2q3 (.=1) if y4_hhid=="0500-004"
				recode s2q3 (.=1) if y4_hhid=="2493-008"
			 
			 //fixing relationship
				recode s2q7 (5=1) if y4_hhid=="1095-003" & PID==8
				
	     gen member_r7=(s2q2==1|s2q3==1)
		 gen sex_r7=s2q5
		 gen age_r7=s2q6
	     gen head_r7=(s2q7==1|s2q9==1)
	     gen relation_r7=s2q7
		 replace relation_r7=s2q9 if relation_r7==. & s2q9!=.
		 label copy s2q7 relation_r7
		 label val relation_r7 relation_r7		
		 replace relation_r7=. if member_r7!=1
		 replace head_r7=0 if member_r7!=1			 
		 gen relation_os_r7=s2q7_os if relation_r7==16
		 replace relation_os_r7=s2q9_os if relation_os_r7=="" & relation_r7==16
		 
	  //respondent		 	     
	     gen respond_r7=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r7 sex_r7 age_r7 head_r7 relation_r7 relation_os_r7 respond_r7

** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r7) unmatched(master)
	     collapse (max) head_r7, by(y4_hhid complete_r7)
		 assert head_r7==1 if complete_r7==1
	  restore	 
	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r7, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r7 complete_r7) unmatched(master)
		 assert member_r7==hhsize_r7 if complete_r7==1
		 assert _m==3
	  restore

** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID	  
      save "$intermed\Round7_ind.dta", replace	
	
********************************************************************************
**                               ROUND 8                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 8\sect2_household_roster_r8", clear 
	  mmerge y4_hhid using "$original\Round 8\sect12_interview_result_r8", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q7 (5=1) if y4_hhid=="1095-003" & PID==8
                recode s2q9 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				
			 //fixing member status
			    recode s2q3 (.=1) if y4_hhid=="0500-004"
				recode s2q3 (.=1) if y4_hhid=="2493-008"
				
	     gen member_r8=(s2q2==1|s2q3==1)
		 gen sex_r8=s2q5
		 gen age_r8=s2q6
	     gen head_r8=(s2q7==1|s2q9==1)
	     gen relation_r8=s2q7
		 replace relation_r8=s2q9 if relation_r8==. & s2q9!=.
		 label copy s2q7 relation_r8
		 label val relation_r8 relation_r8			 
		 replace relation_r8=. if member_r8!=1
		 replace head_r8=0 if member_r8!=1		 
		 gen relation_os_r8=s2q7_os if relation_r8==16
		 replace relation_os_r8=s2q9_os if relation_os_r8=="" & relation_r8==16
		 
	  //respondent		 	     
	     gen respond_r8=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r8 sex_r8 age_r8 head_r8 relation_r8 relation_os_r8 respond_r8
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r8) unmatched(master)
	     collapse (max) head_r8, by(y4_hhid complete_r8)
		 assert head_r8==1 if complete_r8==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r8, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r8 complete_r8) unmatched(master)
		 assert member_r8==hhsize_r8 if complete_r8==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round8_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 9                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 9\sect2_household_roster_r9", clear 
	  mmerge y4_hhid using "$original\Round 9\sect12_interview_result_r9", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3
				recode s2q9 (2=1) if y4_hhid=="0270-009" & PID==2
				
	     gen member_r9=(s2q2==1|s2q3==1)
		 gen sex_r9=s2q5
		 gen age_r9=s2q6
	     gen head_r9=(s2q7==1|s2q9==1)
	     gen relation_r9=s2q7
		 replace relation_r9=s2q9 if relation_r9==. & s2q9!=.
		 label copy s2q7 relation_r9
		 label val relation_r9 relation_r9		
		 replace relation_r9=. if member_r9!=1
		 replace head_r9=0 if member_r9!=1		 
		 gen relation_os_r9=s2q7_os if relation_r9==16
		 replace relation_os_r9=s2q9_os if relation_os_r9=="" & relation_r9==16
		 
	  //respondent		 	     
	     gen respond_r9=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r9 sex_r9 age_r9 head_r9 relation_r9 relation_os_r9 respond_r9
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r9) unmatched(master)
	     collapse (max) head_r9, by(y4_hhid complete_r9)
		 assert head_r9==1 if complete_r9==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r9, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r9 complete_r9) unmatched(master)
		 assert member_r9==hhsize_r9 if complete_r9==1
		 assert _m==3
	  restore
	  	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round9_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 11                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 11\sect2_household_roster_r11", clear 
	  mmerge y4_hhid using "$original\Round 11\sect12_interview_result_r11", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3			 
				recode s2q7 (2=1) if y4_hhid=="0270-009" & PID==2
				recode s2q9 (2=1) if y4_hhid=="0014-001" & PID==4
				recode s2q9 (2=1) if y4_hhid=="1350-002" & PID==2
				
	     gen member_r11=(s2q2==1|s2q3==1)
		 gen sex_r11=s2q5
		 gen age_r11=s2q6
	     gen head_r11=(s2q7==1|s2q9==1)
	     gen relation_r11=s2q7
		 replace relation_r11=s2q9 if relation_r11==. & s2q9!=.
		 label copy s2q7 relation_r11
		 label val relation_r11 relation_r11	
		 replace relation_r11=. if member_r11!=1
		 replace head_r11=0 if member_r11!=1		 
		 gen relation_os_r11=s2q7_os if relation_r11==16
		 replace relation_os_r11=s2q9_os if relation_os_r11=="" & relation_r11==16
		 
	  //respondent		 	     
	     gen respond_r11=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r11 sex_r11 age_r11 head_r11 relation_r11 relation_os_r11 respond_r11
	 
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r11) unmatched(master)
	     collapse (max) head_r11, by(y4_hhid complete_r11)
		 assert head_r11==1 if complete_r11==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r11, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r11 complete_r11) unmatched(master)
		 assert member_r11==hhsize_r11 if complete_r11==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round11_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 12                                     **
********************************************************************************
** OPEN DATA
      use "$original\Round 12\sect2_household_roster_r12", clear 
	  mmerge y4_hhid using "$original\Round 12\sect12_interview_result_r12", ukeep(s12q9) unmatched(master)	  
	  
** GENERATE VARIABLES
	  //demographic information
			 //fixing relationship
				recode s2q7 (98=1) if y4_hhid=="1551-002" & PID==4
				recode s2q7 (2=1) if y4_hhid=="0026-001" & PID==2
				recode s2q7 (2=1) if y4_hhid=="2295-001" & PID==3			 
				recode s2q7 (2=1) if y4_hhid=="0270-009" & PID==2
				recode s2q7 (2=1) if y4_hhid=="1350-002" & PID==2
				
	     gen member_r12=(s2q2==1|s2q3==1)
		 gen sex_r12=s2q5
		 gen age_r12=s2q6
	     gen head_r12=(s2q7==1|s2q9==1)
	     gen relation_r12=s2q7
		 replace relation_r12=s2q9 if relation_r12==. & s2q9!=.
		 label copy s2q7 relation_r12
		 label val relation_r12 relation_r12		 
		 gen relation_os_r12=s2q7_os if relation_r12==16
		 replace relation_os_r12=s2q9_os if relation_os_r12=="" & relation_r12==16
		 
	  //respondent		 	     
	     gen respond_r12=(PID==s12q9) if s12q9!=.
		 		 
** DROP UNNECESSARY VARIABLES		 
      keep y4_hhid PID member_r12 sex_r12 age_r12 head_r12 relation_r12 relation_os_r12 respond_r12
	  
** CHECK HEAD
      preserve
	     mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r12) unmatched(master)
	     collapse (max) head_r12, by(y4_hhid complete_r12)
		 assert head_r12==1 if complete_r12==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r12, by(y4_hhid)
		 mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(hhsize_r12 complete_r12) unmatched(master)
		 assert member_r12==hhsize_r12 if complete_r12==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid y4_hhid PID
      sort y4_hhid PID
      save "$intermed\Round12_ind.dta", replace	
	  
********************************************************************************	  
** MERGING THE FILES
      use "$intermed\Round0_ind.dta", clear  
	  forvalues i=1/9 {
	  	 mmerge y4_hhid PID using "$intermed\Round`i'_ind.dta"
	  }
	  forvalues i=11/12 {
	  	 mmerge y4_hhid PID using "$intermed\Round`i'_ind.dta"
	  }
	  
	  mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(complete_r*) unmatched(master)	  
	  forvalues i=1/9 {	  
		 replace member_r`i'=. if complete_r`i'!=1
	     replace head_r`i'=. if complete_r`i'!=1
		 replace relation_r`i'=. if complete_r`i'!=1
		 replace relation_os_r`i'="" if complete_r`i'!=1	  	
	  }
	  forvalues i=11/12 {	  
		 replace member_r`i'=. if complete_r`i'!=1
	     replace head_r`i'=. if complete_r`i'!=1
		 replace relation_r`i'=. if complete_r`i'!=1
		 replace relation_os_r`i'="" if complete_r`i'!=1	  	
	  }
	  
	  recode relation_r* (.a=.)

** MERGE WITH HOUSEHOLD LEVEL FILES
      mmerge y4_hhid using "$harmonized\MWI_HH.dta", ukeep(contact_r* interview_r* head_chg_r* respond_chg_r*)
		keep if _m==3
		
** UPDATE SEX AND AGE INFORMATION
      gen age_p=.
      forvalues i=1/9 {
	  	replace sex=sex_r`i' if sex==.
		replace age_p=age_r`i' if age_r`i'!=.
	  }
      forvalues i=11/12 {
	  	replace sex=sex_r`i' if sex==.
		replace age_p=age_r`i' if age_r`i'!=.
	  }
	  
 	  drop sex_r* age_r* _m
		recode age_p (.a=.) 

** UPDATE MEMBER AND HEAD VARIABLES 
      recode member_r0 (.=0)
      recode member_r1 (.=0) if complete_r1==1
	  forvalues i=2/9 {
	     recode member_r`i' (.=0) if complete_r`i'==1	
	  }
	  forvalues i=11/12 {
	     recode member_r`i' (.=0) if complete_r`i'==1	
	  }
	  
	  forvalues i=0/9 {
	  	 recode head_r`i' (.=0) if member_r`i'==0
	  }
	  forvalues i=11/12 {
	  	 recode head_r`i' (.=0) if member_r`i'==0
	  }

	  forvalues i=1/9 {
	     recode respond_r`i' (.=0) if interview_r`i'==1	
	  }	  
	  forvalues i=11/12 {
	     recode respond_r`i' (.=0) if interview_r`i'==1	
	  }	  
	  
** VALIDATE
      run "$dofiles\ind_validation.do"
	  foreach x in relation_r0 married form_married nev_married religion literacy educ work {
	     assert `x'==. if PID>=100	
	  }
	  /* not needed
	  assert member_r0==1 if indiv<100
	  assert member_r0==0 if indiv>=100
	  assert member_r1==0 if indiv>=200 & complete_r1==1
	  assert member_r2==0 if indiv>=300 & complete_r2==1
	  assert member_r3==0 if indiv>=400	& complete_r3==1 
	  assert member_r4==0 if indiv>=500	& complete_r4==1
	  assert member_r5==0 if indiv>=600	& complete_r5==1
	  assert member_r6==0 if indiv>=700	& complete_r6==1
	  assert member_r7==0 if indiv>=800	& complete_r7==1
	  assert member_r8==0 if indiv>=900	& complete_r8==1
	  assert member_r9==0 if indiv>=1000	& complete_r9==1
	  
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
	  */
	  
** DROP UNNECESSARY VARIABLES
      drop contact_r* interview_r* head_chg_r* respond_chg_r* complete_r*	
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\ind_label.do"
	  
** CHECK FOR DUPLICATES
      bysort y4_hhid PID: assert _n==1
	  preserve
	     collapse (count) PID, by(y4_hhid)
		 assert _N==$totalHH
	  restore
	  isid y4_hhid PID
	
** LABEL DATA 
      label data "Malawi COVID-19 - Harmonized Dataset (Individual Level)"
      label var y4_hhid "Household ID"
      label var PID "Individual ID"
	  	  
** ORDER VARIABLES
      order y4_hhid PID sex age age_p married form_married nev_married disability religion literacy educ work ///
            member_r0 head_r0 relation_r0  relation_os_r0 ///
            member_r1 head_r1 respond_r1 relation_r1 relation_os_r1 ///
            member_r2 head_r2 respond_r2 relation_r2 relation_os_r2 ///
            member_r3 head_r3 respond_r3 relation_r3 relation_os_r3 ///
			member_r4 head_r4 respond_r4 relation_r4 relation_os_r4 ///
            member_r5 head_r5 respond_r5 relation_r5 relation_os_r5 ///
			member_r6 head_r6 respond_r6 relation_r6 relation_os_r6 ///
			member_r7 head_r7 respond_r7 relation_r7 relation_os_r7 ///
			member_r8 head_r8 respond_r8 relation_r8 relation_os_r8 ///
			member_r9 head_r9 respond_r9 relation_r9 relation_os_r9 ///
			member_r11 head_r11 respond_r11 relation_r11 relation_os_r11 ///
			member_r12 head_r12 respond_r12 relation_r12 relation_os_r12
			
** CHECKING IND FILE WILL MERGE WITH HH FILE
      preserve
         mmerge y4_hhid using "$harmonized\MWI_HH.dta"	
		 assert _m==3		 
	  restore	 
	  
** SAVE FILE  
      isid y4_hhid PID
      sort y4_hhid PID
	  compress
      saveold "$harmonized\MWI_IND.dta", replace
	   