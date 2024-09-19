******************************************************************
**         COVID-19 Phone Survey Harmonized Data Project        **
**                                                              **
**                                                              **
**  Country: Ethiopia	YEAR:  2018/2019   			          	**
**                                                              **
**  Program Name:  ETH_COVID19_v01.do		    		    	**
**                                                              **
**  Version: v01 (Round 0-10)                                    **
**                                                              **
**  Description: Generates harmonized dataset				    **
**                                                              **
**  Number of HHs (ESS WAVE 4): 6,770                           **
**                                                              **
**  Household: household_id		    			  				**
**                                                              **
**  Program first written: January 6, 2021                   	**
**  Program last revised:                                    	**
**                                                              **
******************************************************************
set more off

** TOTAL NUMBER OF HOUSEHOLDS IN THE LAST FACE-TO-FACE SURVEY
      global totalHH 6770 	
	  
** NUMBER OF PHONE SURVEY ROUNDS TO BE HARMONIZED
      global round 10

** PHONE SURVEY ROUNDS WITH FIES QUESTIONS	  
      global fies 2 3 4 5 6

****************************************************
**              HOUSEHOLD LEVEL DATA              **
****************************************************

***************************************
**            ROUND 0                **
***************************************

** OPEN DATA 
      use "$original\Round 0\HH\sect_cover_hh_w4.dta", clear
	  
** GENERATE VARIABLES
      //basic household information
	     mmerge household_id using "$original\Round 0\HH\ETH_HouseholdGeovariables_Y4.dta", ukeep(lat_mod lon_mod) unmatched(master)
         gen year=2018
		 gen wt_r0=pw_w4
	     gen rural=saq14
		 gen ea_latitude=lat_mod 
		 gen ea_longitude=lon_mod
		 
		 keep household_id ea_id saq01-saq06 year-ea_longitude
	
	  //dwelling information	 
	     mmerge household_id using "$original\Round 0\HH\sect10a_hh_w4.dta", ukeep(s10aq02 s10aq06 s10aq07 s10aq08 s10aq09 s10aq12 s10aq21 s10aq26 s10aq27 s10aq34 s10aq38) unmatched(master)
	     gen dwelling=(s10aq02==1 & s10aq02!=.) 
	     gen roof=(inlist(s10aq08,1,2,7,8) & s10aq08!=.)
	     gen floor=(inlist(s10aq09,4,5,6,7,8,9) & s10aq09!=.)
	     gen walls=(inlist(s10aq07,6,7,8,9,11,15,16) & s10aq07!=.)
	     gen toilet=(inlist(s10aq12,1,2,3,5,6,9,11,13) & s10aq12!=.)
	     gen water=(inlist(s10aq27,1,2,3,4,5,6,8,10,11,12,13,14,15) & s10aq27!=.)
		 recode water (0=1) if (inlist(s10aq21,1,2,3,4,5,6,8,10,11,12,13,14,15) & s10aq21!=. & s10aq27==. & s10aq26==1)
	     gen rooms=s10aq06
	     gen elect=(inlist(s10aq34,1,2,3,4) & s10aq34!=.)
		 recode elect (. 0=1) if (s10aq38==9 & s10aq38!=.)
		 note elect: Based on source of light and source of cooking fuel
		 drop s10aq02-_merge

	  //asset information
	    //Mobile Phone of individual disaagregate 
		   preserve
	          use "$original\Round 0\HH\sect11b1_hh_w4.dta", clear 
		      recode s11b_ind_01 (2=0)(97=.)
		      collapse (sum) s11b_ind_01,by(household_id)
		      recode s11b_ind_01 (0=0) (1/max=1), gen (mphone)	 
		      tempfile mphone
			  save `mphone', replace
		   restore			   
	     preserve
		    use "$original\Round 0\HH\sect11_hh_w4.dta",clear
			gen tv=(asset_cd==9 & s11q00==1)
			gen radio=(asset_cd==8 & s11q00==1)
			gen refrigerator=(asset_cd==21 & s11q00==1)
			gen bicycle=(asset_cd==13 & s11q00==1)
			gen mcycle=(asset_cd==14 & s11q00==1)
			gen car=(asset_cd==22 & s11q00==1)
			collapse (max) tv-car, by(household_id)
			mmerge household_id using `mphone', ukeep(mphone) unmatched(master)
			drop  _merge			
			//assume NO for missing cases
			   recode tv-mphone (.=0)
			   
			   gen computer=.	
			   note computer: Data not collected.
			   gen generator=.
			   note generator: Data not collected.
			   gen internet=.
			   note internet: Data not collected.
			   
			tempfile asset
			save `asset', replace
		 restore		
         mmerge household_id using `asset', unmatched(master)
		 
	  //finance and income information	
	     preserve
			use "$original\Round 0\HH\sect13_hh_w4_v2.dta", clear
		    keep if inlist(source_cd,106,107,108,109)
		    gen rent=(s13q01==1)
			collapse (max) rent, by(household_id)
			note rent: Rental income from Shop/Store/House/Car/Truck/Other Vehicle Rental/Land/Agricultural tools/Transport Animals
			tempfile rent
			save `rent', replace
		 restore
		 mmerge household_id using `rent', unmatched(master)
	     preserve
		    use "$original\Round 0\HH\sect13_hh_w4_v2.dta", clear
		    keep if inlist(source_cd,101,102,103)
		    gen remit=(s13q01==1)
		    collapse (max) remit, by(household_id)
			tempfile remittance
			save `remittance', replace
		 restore	
		 mmerge household_id using `remittance', unmatched(master)
	     preserve
		    use "$original\Round 0\HH\sect14_hh_w4.dta", clear
	        gen assist=(s14q01==1)
			collapse (max) assist, by(household_id)
			tempfile assistance
			save `assistance', replace		 
		 restore	
		 mmerge household_id using `assistance', unmatched(master) 
	     preserve
		    //Account Ownership (Financial Assets)
               use "$original\Round 0\HH\sect5b1_hh_w4.dta", clear 
	           keep if inlist(asset_type,1,2,3)
			   keep household_id individual_id asset_type s5bq01
			   reshape wide s5bq01 , i(household_id individual_id) j(asset_type)
	           tempfile account
	           save `account', replace

		    //Account Ownership (Credit)
			   //first owner
		          use "$original\Round 0\HH\sect15b_hh_w4.dta", clear
			      keep if inlist(s15q02b,7,8,10) //Bank, Microfinance institutions and SACCOS
				  keep household_id s15q03_1 s15q03_2 s15q02b loan_id
				  reshape wide loan_id, i(household_id s15q03_1 s15q03_2) j(s15q02b)
				  ren (loan_id7 loan_id8 loan_id10)(microfinance bank sacco)
				  drop s15q03_2
	              tempfile credit
	              save `credit', replace
	
			   //second owner
		          use "$original\Round 0\HH\sect15b_hh_w4.dta", clear
			      keep if inlist(s15q02b,7,8,10) //Bank, Microfinance institutions and SACCOS
				  keep household_id s15q03_1 s15q03_2 s15q02b loan_id
				  reshape wide loan_id, i(household_id s15q03_1 s15q03_2) j(s15q02b)
				  ren (loan_id7 loan_id8 loan_id10)(microfinance bank sacco)
				  drop s15q03_1		
			      
				append using `credit'
				drop if s15q03_1==. & s15q03_2==.
				egen individual_id = rowtotal(s15q03_1 s15q03_2)
				drop s15q03_1 s15q03_2
                mmerge household_id individual_id using `account'
				drop _m
	
		    //Account Ownership (Savings)
		       mmerge household_id individual_id using "$original\Round 0\HH\sect5a_hh_w4.dta" 
			   keep if s5aq00 ==1 //age 18 and above 
			   drop _m	
			   
		       //update 1. If the respondent has a loan from the formal sector but s5aq05 is No
                  recode s5aq05 (2 .=1) if microfinance==1| bank ==1 | sacco==1
			
		       //update 2. Some respondents didn't metnion account ownership in s5aq05 however metnioned saving in Banks in s5aq11. 
		 	      recode s5aq05 (2 .=1) if s5aq11__1 ==1 & s5aq05==2  /*Private Commercial Banks*/
		 	      recode s5aq05 (2 .=1) if s5aq11__2 ==1 & s5aq05==2   /*Public Commerical Banks*/
		 	      recode s5aq05 (2 .=1) if s5aq11__3 ==1 & s5aq05==2   /*Microfinance*/
		 	      recode s5aq05 (2 .=1) if s5aq11__4 ==1 & s5aq05==2   /*SACCOS*/
			
		       //upddate 3. If the respondent said Yes to a financial asset ownership but s5aq05 is No 
			      recode s5aq05 (2 .=1)  if s5bq011==1|  s5bq012==1|  s5bq013==1  

             gen finance=(s5aq05==1)			  
	         collapse (max) finance, by(household_id)
			tempfile finance
			save `finance', replace
		 restore	
		 mmerge household_id using `finance', unmatched(master) 	     
		 
	  //labor information
	     preserve
		    use "$original\Round 0\HH\sect4_hh_w4.dta", clear
			mmerge household_id individual_id using "$original\Round 0\HH\sect1_hh_w4.dta", ukeep(s1q03a s1q05) unmatched(master)
			drop if s1q05==2
	        gen ag=(s4q05==1 & inrange(s1q03a,15,64))
	        gen nfe=(s4q08==1 & inrange(s1q03a,15,64))
	        gen ext=((s4q10==1 | s4q12==1) & inrange(s1q03a,15,64))
	        gen any=(ag==1|nfe==1|ext==1)    
			gen person=(inrange(s1q03a,15,64))
			collapse (sum) ag-person, by(household_id)
			gen ag_work=ag/person*100
			gen nfe_work=nfe/person*100
			gen ext_work=ext/person*100
			note ext_work: Includes casual and permanent work
			gen any_work=any/person*100
			keep household_id ag_work-any_work
			tempfile work
			save `work', replace
         restore
		 mmerge household_id using `work', unmatched(master)
	     preserve
		    use "$original\Round 0\HH\sect12a_hh_w4.dta", clear	
			egen nfe = anymatch(s12aq01__1 - s12aq01__8), v(1)
			keep household_id nfe
			tempfile nfe
			save `nfe', replace
         restore
		 mmerge household_id using `nfe', unmatched(master)	

	  //land information    
	     preserve
		    use "$original\Round 0\PP\sect3_pp_w4.dta", clear	 
			
	        //generating estimated conversions for self reported
			   recode s3q02b (1=10000) (2=0.0001) (3=0.125) (4=0.01) (5=0.1) (6=0.229)(7=0.0145)(nonm=.), gen(conv)
			   recode conv (.=0.125) if s3q2b_os=="KADA " | s3q2b_os=="KEDEMA " 			   
			   gen SR_ha = conv*s3q02a
			   gen diff = 100 * (SR_ha - s3q08/10000) / (SR_ha + s3q08/10000)
			   
			//plot area
		        gen plotsize = s3q08/10000
		        replace plotsize = SR_ha if plotsize==. & SR_ha!=0
				replace plotsize = SR_ha if plotsize > 3 & abs(diff) > 20
				
	        egen land_tot=sum(plotsize), by(household_id)	 
		    egen land_cultivated = sum(plotsize*(s3q03==1)), by(household_id)
		    keep household_id land*
		 	duplicates drop
		    isid household_id
		    tempfile landarea 
			save `landarea', replace
		 restore
		 mmerge household_id using `landarea', unmatched(master)
		 preserve
		    use "$original\Round 0\PP\sect2_pp_w4.dta", clear
		    gen land=(inlist(s2q05,1,2,5,7))
			collapse (max) land, by(household_id)
		    isid household_id
		    tempfile land 
			save `land', replace
		 restore			
		 mmerge household_id using `land', unmatched(master)	
		 preserve
		    use "$original\Round 0\HH\sect10b_hh_w4.dta", clear	
		    gen crop=(s10bq07==1)
		    collapse (max) crop, by(household_id)
		    tempfile crop
			save `crop', replace		 
		 restore
		 mmerge household_id using `crop', unmatched(master)		 
		 recode land crop (.=0)
		 replace land_tot=0 if land==0
		 recode crop (0=1) if land_cultivated!=. & land_cultivated>0		 
		 recode land_cultivated (.=0) if crop==0
		 order land land_tot crop land_cultivated, after(nfe)
		 drop _merge

	  //food security information	
	     gen fies_mod_r0=.
		 note fies_mod_r0: Data not collected.
	     gen fies_sev_r0=.
         note fies_sev_r0: Data not collected.
		 
	  //consumption information
	     preserve
	        use "$original\Round 0\HH\cons_agg_w4.dta", clear
	        egen foodcons=rowtotal(food_cons_ann fafh_cons_ann)
	        egen nonfoodcons=rowtotal(nonfood_cons_ann educ_cons_ann utilities_cons_ann)
	        gen double totcons=foodcons+nonfoodcons	
	        gen foodcons_adj=.
		    note foodcons_adj: Data not available.			
	        gen nonfoodcons_adj=.
			note nonfoodcons_adj: Data not available.
			gen totcons_adj=spat_totcons_aeq*adulteq
			note totcons_adj: Spatially adjusted (food prices only)
			drop cons_quint
	        xtile cons_quint=totcons_adj [pw=pw_w4], nq(5)			
			note cons_quint: Quintile based on totcons_adj
			keep household_id cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj
			tempfile cons
			save `cons', replace
         restore
		 mmerge household_id using `cons', unmatched(master)	

	  //agricultural information
	     preserve
		    use "$original\Round 0\PP\sect4_pp_w4.dta", clear 
		    gen crop_number=1
			gen cash_crop=inlist(s4q01b,71,72,77,78)
			collapse (sum) crop_number (max) cash_crop, by(household_id)
			tempfile crop_number
			save `crop_number', replace
		 restore
		 mmerge household_id using `crop_number', unmatched(master)
		 note cash_crop: CHAT, COFFEE, TEA, TOBACCO		
		 replace crop_number=. if crop!=1
		 replace cash_crop=. if crop!=1
	     preserve
		    use "$original\Round 0\PP\sect3_pp_w4.dta", clear
			gen org_fert=(s3q25==1 | s3q26==1 | s3q27==1)
			gen inorg_fert=(s3q21==1 | s3q22==1 | s3q23==1 | s3q24==1)
			collapse (max) org_fert inorg_fert, by(household_id)
			tempfile fertilizer
			save `fertilizer', replace
		 restore
		 mmerge household_id using `fertilizer', unmatched(master)		
		 replace org_fert=. if crop!=1
		 replace inorg_fert=. if crop!=1
	     preserve
		    use "$original\Round 0\PP\sect4_pp_w4.dta", clear
			gen pest_fung_herb=(s4q05==1 | s4q06==1 | s4q07==1)
			collapse (max) pest_fung_herb, by(household_id)
			tempfile pesticide
			save `pesticide', replace
		 restore
		 mmerge household_id using `pesticide', unmatched(master)	
		 replace pest_fung_herb=. if crop!=1
	     preserve
		    use "$original\Round 0\PP\sect3_pp_w4.dta", clear
			egen hired=rowtotal(s3q30a s3q30d s3q30g)
			egen ex_fr=rowtotal(s3q31a s3q31c s3q31e)
			collapse (sum) hired ex_fr, by(household_id)
			tempfile ag_labor
			save `ag_labor', replace
		 restore
	     preserve		 
			use "$original\Round 0\PH\sect10_ph_w4.dta", clear
			egen hired_h=rowtotal(s10q01a s10q01d s10q01g)
			egen ex_fr_h=rowtotal(s10q03a s10q03c s10q03e)
			collapse (sum) hired_h ex_fr_h, by(household_id)
			mmerge household_id using `ag_labor'
			egen hired_lab=rowtotal(hired hired_h)
			egen ex_fr_lab=rowtotal(ex_fr ex_fr_h)	
			replace hired_lab=1 if hired_lab>0 & hired_lab!=.
			replace ex_fr_lab=1 if ex_fr_lab>0 & ex_fr_lab!=.
            isid household_id
			save `ag_labor', replace
		 restore
		 mmerge household_id using `ag_labor', unmatched(master)		 
		 drop hired_h ex_fr_h hired ex_fr _m		 
		 //for those are missing, assume NO
		    recode hired_lab ex_fr_lab (.=0) if crop==1		
         replace hired_lab=. if crop!=1
		 replace ex_fr_lab=. if crop!=1
		 
		 preserve
		    use  "$original\Round 0\PP\sect7_pp_w4.dta", clear
			gen plough=(inlist(s7q15,4,5,6))
			collapse (max) plough, by(household_id)
			tempfile plough
			save `plough', replace
		 restore
	     preserve
		    use "$original\Round 0\PP\sect3_pp_w4.dta", clear
		    gen tractor=(inlist(s3q35,1,2))
		    collapse (max) tractor, by(household_id)
			mmerge household_id using `plough', unmatched(master)
			replace tractor=1 if plough==1
		    tempfile tractor
			save `tractor', replace
		 restore
		 mmerge household_id using `tractor', unmatched(master)
         drop _m plough
		 replace tractor=. if crop!=1
         
		 gen hired_lab_ph=.
		 note hired_lab_ph: Data not collected.
		 gen ex_fr_lab_ph=. 
		 note ex_fr_lab_ph: Data not collected.			

		 preserve
		    use "$original\Round 0\PH\sect11_ph_w4.dta", clear
			gen sell_crop=(s11q07==1)
			gen ph_loss=((s11q21a1>0 & s11q21a1!=.)|(s11q21a3>0 & s11q21a3!=.))
			collapse (max) sell_crop ph_loss, by(household_id)
			tempfile harvest
			save `harvest', replace
		 restore
		 mmerge household_id using `harvest', unmatched(master) 
		 //for those are missing, assume NO
            recode sell_crop ph_loss (.=0) if crop==1
		 replace sell_crop=. if crop!=1
		 replace ph_loss=. if crop!=1
		 
		 gen sell_unprocess=.
		 note sell_unprocess: Data not collected.		 
		 gen sell_process=.	
		 note sell_process: Data not collected.
		 
		 order crop crop_number cash_crop org_fert inorg_fert pest_fung_herb tractor hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ph_loss sell_crop sell_unprocess sell_process, after(cons_quint)

	  //livestock information
	     preserve
		    use "$original\Round 0\LS\sect8_1_ls_w4.dta", clear
		    keep if ls_code==16
		    replace ls_s8_1q02=0 if ls_s8_1q02==. & ls_s8_1q01==0
		    gen bee=((ls_s8_1q01-ls_s8_1q02)>0 & ls_s8_1q01!=.)
		    collapse (max) bee, by(household_id)
			tempfile bee
			save `bee', replace
		 restore
	     preserve
		    use "$original\Round 0\HH\sect10d1_hh_w4.dta", clear
	        gen lruminant=(inlist(livestock_cd,501,502,503,504,505,506) & s10dq01==1)
	        gen sruminant=(inlist(livestock_cd,507,508) & s10dq01==1)
	        gen poultry=(livestock_cd==513 & s10dq01==1)
	        gen equines=(inlist(livestock_cd,510,5511,512) & s10dq01==1)
	        gen camelids=(livestock_cd==509 & s10dq01==1)
			mmerge household_id using `bee'
	        gen livestock=(lruminant==1|sruminant==1|poultry==1|equines==1|camelids==1|bee==1)			
			collapse (max) lruminant-livestock, by(household_id)
			tempfile livestock
			save `livestock', replace
		 restore
		 mmerge household_id using `livestock', unmatched(master)
		 recode lruminant-bee livestock (.=0)
	     gen pig=.
	     note pig: Data not collected.		 
 		 
	  //demographic information
	     preserve
		    use "$original\Round 0\HH\sect1_hh_w4.dta", clear
			drop if s1q05==2
		    gen hhsize_r0=1
		    gen m0_14_r0  = 1  if (s1q02==1 & inrange(s1q03a,0,14)) 
		    gen m15_64_r0 = 1 if (s1q02==1 & inrange(s1q03a,15,64))
		    gen m65_r0    = 1 if (s1q02==1 & s1q03a>=65 & s1q03a!=.) 
		    gen f0_14_r0  = 1 if (s1q02==2 & inrange(s1q03a,0,14)) 
		    gen f15_64_r0 = 1 if (s1q02==2 & inrange(s1q03a,15,64))
		    gen f65_r0    = 1 if (s1q02==2 & s1q03a>=65 & s1q03a!=.) 
		    gen adulteq_r0=. 
            replace adulteq_r0 = 0.27 if (s1q02==1 & s1q03a==0) 
            replace adulteq_r0 = 0.45 if (s1q02==1 & inrange(s1q03a,1,3)) 
            replace adulteq_r0 = 0.61 if (s1q02==1 & inrange(s1q03a,4,6)) 
            replace adulteq_r0 = 0.73 if (s1q02==1 & inrange(s1q03a,7,9)) 
            replace adulteq_r0 = 0.86 if (s1q02==1 & inrange(s1q03a,10,12)) 
            replace adulteq_r0 = 0.96 if (s1q02==1 & inrange(s1q03a,13,15)) 
            replace adulteq_r0 = 1.02 if (s1q02==1 & inrange(s1q03a,16,19)) 
            replace adulteq_r0 = 1.00 if (s1q02==1 & s1q03a >=20) 
            replace adulteq_r0 = 0.27 if (s1q02==2 & s1q03a ==0) 
            replace adulteq_r0 = 0.45 if (s1q02==2 & inrange(s1q03a,1,3)) 
            replace adulteq_r0 = 0.61 if (s1q02==2 & inrange(s1q03a,4,6)) 
            replace adulteq_r0 = 0.73 if (s1q02==2 & inrange(s1q03a,7,9)) 
            replace adulteq_r0 = 0.78 if (s1q02==2 & inrange(s1q03a,10,12)) 
            replace adulteq_r0 = 0.83 if (s1q02==2 & inrange(s1q03a,13,15)) 
            replace adulteq_r0 = 0.77 if (s1q02==2 & inrange(s1q03a,16,19)) 
            replace adulteq_r0 = 0.73 if (s1q02==2 & s1q03a >=20)      
			collapse (sum) hhsize_r0-adulteq_r0, by(household_id)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize', unmatched(master)
		 drop _m
	  
** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round0_hh.dta", replace
		 
***************************************
**            ROUND 1                **
***************************************	
** GENERATE VARIABLES	 
	  //interview results & weights
         use "$original\Round 1\200619_WB_LSMS_HFPM_HH_Survey_Refused_Incomplete-Round1_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=.
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile interview
		 save `interview', replace 
		 
         use "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r1=1
		 gen contact_r1=1
		 append using `interview'
		 gen phone_sample=1		 
		 recode contact_r1 (.=1) if reached==1  
		 recode contact_r1 (.=0) if reached==0 
		 gen interview_r1=1 if contact_r1==1 & refused!=1
		 recode interview_r1 (.=0) if contact_r1==1 & refused==1
		 gen wt_r1=phw1
		 keep household_id phone_sample contact_r1 interview_r1 complete_r1 wt_r1
		 
	  //demographic information
	     preserve
	        use "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_roster", clear
			
			//fixing observations 
			   //using data from other rounds
			      recode bi5_hhm_age (-98=37) if household_id=="140107010100712011" & individual_id==7
			      recode bi5_hhm_age (-98=78) if household_id=="140307010300706110" & individual_id==1
			      recode bi5_hhm_age (-98=22) if household_id=="150101010100370124" & individual_id==4
				  recode bi5_hhm_age (-98=37) if household_id=="150101010100607012"  & individual_id==5
				  
			   //assuming other missings are aged 15 to 64 years			
			      recode bi5_hhm_age (-98=25) if household_id=="140909010900935044"  & individual_id==2
				  recode bi5_hhm_age (-98=25) if household_id=="150101010100330017"   & individual_id==8
   
	        drop if bi3_hhm_stillm==0
		    gen hhsize_r1=1
		    gen m0_14_r1  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r1 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r1    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r1  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r1 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r1    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r1=. 
            replace adulteq_r1 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r1 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r1 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r1 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r1 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r1 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r1 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r1 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r1 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r1 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r1 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r1 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r1 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r1 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r1 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r1 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)  
	        collapse (sum) hhsize_r1-adulteq_r1, by(household_id)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'		 
	
		 foreach x in hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 {
		 	replace `x'=. if complete_r1!=1
		 }
		 
		 keep household_id *_r1 phone_sample
		 
** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round1_hh.dta", replace
	  
***************************************
**            ROUND 2                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results & weights
         use "$original\Round 2\200620_WB_LSMS_HFPM_HH_Survey_Refused-Round2_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=.
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r2_interview
		 save `r2_interview', replace 
		 
         use "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear 
		 gen complete_r2=1
		 gen contact_r2=1
		 append using `r2_interview'	 
		 recode contact_r2 (.=1) if reached==1  
		 recode contact_r2 (.=0) if reached==0 
		 gen interview_r2=1 if contact_r2==1 & refused!=1
		 recode interview_r2 (.=0) if contact_r2==1 & refused==1
		 gen wt_r2=phw2
		 keep household_id contact_r2 interview_r2 complete_r2 wt_r2
		 
	  //demographic information
	     preserve
		    use "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //using data from other rounds
			      recode bi5_hhm_age (-98=37) if household_id=="140107010100712011" & individual_id==7
			      recode bi5_hhm_age (-98=78) if household_id=="140307010300706110" & individual_id==1
				  
			   //assuming other missings are aged 15 to 64 years			
			      recode bi5_hhm_age (-98=25) if household_id=="140909010900935044"  & individual_id==2		
				  
	        drop if bi3_hhm_stillm==0
			gen hhsize_r2=1
		    gen m0_14_r2  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r2 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r2    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r2  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r2 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r2    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r2=. 
            replace adulteq_r2 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r2 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r2 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r2 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r2 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r2 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r2 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r2 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r2 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r2 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r2 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r2 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r2 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r2 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r2 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r2 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r2-adulteq_r2, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2
		 foreach X in `x' {
		 	replace `X'=. if complete_r2!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 2\ET_FIES_round2", clear
			gen household_id=HHID
		    gen fies_mod_r2=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r2=(p_sev>=0.5 & p_sev!=.)
			keep household_id *_r2
			tempfile fies_r2
			save `fies_r2', replace
		 restore
		 mmerge household_id using `fies_r2', unmatched(master)
		 keep household_id *_r2

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round2_hh.dta", replace
	  
***************************************
**            ROUND 3                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results & weights
         use "$original\Round 3\200729_WB_LSMS_HFPM_HH_Survey_Refused-Round3_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=.
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r3_interview
		 save `r3_interview', replace 
		 
         use "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear 
		 gen complete_r3=1
		 gen contact_r3=1
		 append using `r3_interview'	 
		 recode contact_r3 (.=1) if reached==1  
		 recode contact_r3 (.=0) if reached==0 
		 gen interview_r3=1 if contact_r3==1 & refused!=1
		 recode interview_r3 (.=0) if contact_r3==1 & refused==1
		 gen wt_r3=phw3
		 gen wt_panel_r3=.
		 keep household_id contact_r3 interview_r3 complete_r3 wt_r3 wt_panel_r3
		 		 
	  //demographic information
	     preserve
		    use "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 				  
			   //assuming other missings are aged 15 to 64 years			
			      recode bi5_hhm_age (-98=25) if household_id=="140909010900935044" & individual_id==2		
				 
			   //dropping a new member without age or sex information - this person is not listed in the subsequent rounds. 				 
			      drop if household_id=="010101088800910082" & individual_id==6
				  			   	  
	        drop if bi3_hhm_stillm==0
			gen hhsize_r3=1
		    gen m0_14_r3  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r3 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r3    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r3  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r3 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r3    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r3=. 
            replace adulteq_r3 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r3 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r3 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r3 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r3 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r3 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r3 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r3 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r3 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r3 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r3 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r3 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r3 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r3 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r3 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r3 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r3-adulteq_r3, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3
		 foreach X in `x' {
		 	replace `X'=. if complete_r3!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 3\ET_FIES_round3", clear
			gen household_id=HHID
		    gen fies_mod_r3=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r3=(p_sev>=0.5 & p_sev!=.)
			keep household_id *_r3
			tempfile fies_r3
			save `fies_r3', replace
		 restore
		 mmerge household_id using `fies_r3', unmatched(master)
		 keep household_id *_r3

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round3_hh.dta", replace
	  
***************************************
**            ROUND 4                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results & weights
         use "$original\Round 4\200826_WB_LSMS_HFPM_HH_Survey_Refused-Round4_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=.
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r4_interview
		 save `r4_interview', replace 
		 
         use "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r4=1
		 gen contact_r4=1
		 append using `r4_interview'	 
		 recode contact_r4 (.=1) if reached==1
		 recode contact_r4 (.=0) if reached==0 
		 gen interview_r4=1 if contact_r4==1 & refused!=1
		 recode interview_r4 (.=0) if contact_r4==1 & refused==1
		 gen wt_r4=phw4
		 gen wt_panel_r4=.
		 keep household_id contact_r4 interview_r4 complete_r4 wt_r4 wt_panel_r4
		 
	  //demographic information
	     preserve
		    use "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years			
			      recode bi5_hhm_age (-98=25) if household_id=="140909010900935044" & individual_id==2	
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  
	        drop if bi3_hhm_stillm==0
			gen hhsize_r4=1
		    gen m0_14_r4  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r4 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r4    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r4  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r4 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r4    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r4=. 
            replace adulteq_r4 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r4 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r4 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r4 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r4 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r4 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r4 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r4 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r4 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r4 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r4 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r4 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r4 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r4 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r4 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r4 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r4-adulteq_r4, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4
		 foreach X in `x' {
		 	replace `X'=. if complete_r4!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 4\ET_FIES_round4", clear
			gen household_id=HHID
		    gen fies_mod_r4=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r4=(p_sev>=0.5 & p_sev!=.)
			keep household_id *_r4
			tempfile fies_r4
			save `fies_r4', replace
		 restore
		 mmerge household_id using `fies_r4', unmatched(master)
		 keep household_id *_r4

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round4_hh.dta", replace
	  
***************************************
**            Round 5                **
***************************************	
** GENERATE VARIABLES		   	  
	  //interview results & weights
         use "$original\Round 5\200929_WB_LSMS_HFPM_HH_Survey_Refused-Round5_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=.
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r5_interview
		 save `r5_interview', replace 
		 
         use "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta", clear 
		 gen complete_r5=1
		 gen contact_r5=1
		 append using `r5_interview'	 
		 recode contact_r5 (.=1) if reached==1 
		 recode contact_r5 (.=0) if reached==0
		 recode contact_r5 (.=0)
		 gen interview_r5=1 if contact_r5==1 & refused!=1
		 recode interview_r5 (.=0) if contact_r5==1 & refused==1
		 gen wt_r5=phw5
		 gen wt_panel_r5=.		 
		 keep household_id contact_r5 interview_r5 complete_r5 wt_r5 wt_panel_r5
		 
	  //demographic information
	     preserve
		    use "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  
	        drop if bi3_hhm_stillm==0
			gen hhsize_r5=1
		    gen m0_14_r5  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r5 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r5    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r5  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r5 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r5    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r5=. 
            replace adulteq_r5 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r5 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r5 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r5 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r5 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r5 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r5 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r5 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r5 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r5 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r5 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r5 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r5 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r5 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r5 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r5 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r5-adulteq_r5, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5
		 foreach X in `x' {
		 	replace `X'=. if complete_r5!=1
		 }
		 
	  //fies
	     preserve
	        use "$original\Round 5\ET_FIES_round5", clear
			gen household_id=HHID
		    gen fies_mod_r5=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r5=(p_sev>=0.5 & p_sev!=.)
			keep household_id *_r5
			tempfile fies_r5
			save `fies_r5', replace
		 restore
		 mmerge household_id using `fies_r5', unmatched(master)
		 keep household_id *_r5

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round5_hh.dta", replace
	
***************************************
**            Round 6                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results & weights
         use "$original\Round 6\201022_WB_LSMS_HFPM_HH_Survey_Refused-Round6_Clean.dta", clear
		 gen reached=0 if ii_resp_noreach!=""
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 drop if household_id=="140711010701116012"
		 tempfile r6_interview
		 save `r6_interview', replace 
		 
         use "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r6=1
		 gen contact_r6=1
		 append using `r6_interview'	 
		 recode contact_r6 (.=1) if reached==1
		 recode contact_r6 (.=0) if reached==0
		 recode contact_r6 (.=0)
		 gen interview_r6=1 if contact_r6==1 & refused!=1
		 recode interview_r6 (.=0) if contact_r6==1 & refused==1
		 gen wt_r6=phw6
		 gen wt_panel_r6=.		
		 
		    //this household is missing roster
			   recode complete_r6 (1=0) if household_id =="050213088801502044"
			   
		 keep household_id contact_r6 interview_r6 complete_r6 wt_r6 wt_panel_r6
		 
	  //demographic information
	     preserve
		    use "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  recode bi5_hhm_age (-98=25) if household_id=="050212010100806006" & individual_id==8
				  
			   //assuming this person is a female
			      recode bi4_hhm_gender (-99=2) if household_id=="050212010100806006" & individual_id==8
			   
	        drop if bi3_hhm_stillm==0
			gen hhsize_r6=1
		    gen m0_14_r6  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r6 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r6    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r6  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r6 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r6    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r6=. 
            replace adulteq_r6 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r6 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r6 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r6 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r6 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r6 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r6 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r6 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r6 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r6 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r6 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r6 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r6 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r6 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r6 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r6 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r6-adulteq_r6, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	
		 drop if _m==1
         loc x hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6
		 foreach X in `x' {
		 	replace `X'=. if complete_r6!=1
		 }
	
	  //fies
	     preserve
	        use "$original\Round 6\ET_FIES_round6", clear
			gen household_id=HHID
		    gen fies_mod_r6=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r6=(p_sev>=0.5 & p_sev!=.)
			keep household_id *_r6
			tempfile fies_r6
			save `fies_r6', replace
		 restore
		 mmerge household_id using `fies_r6', unmatched(master)
		 keep household_id *_r6

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round6_hh.dta", replace
	  
***************************************
**            Round 7                **
***************************************	
** GENERATE VARIABLES		  
	  //interview results & weights
         use "$original\Round 7\201116_WB_LSMS_HFPM_HH_Survey_Refused-Round7_Clean.dta", clear 		 
		 gen reached=0 if ii_resp_noreach!=""
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 drop if household_id=="150101010110317176"
		 tempfile r7_interview
		 save `r7_interview', replace 
		 
         use "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r7=1
		 gen contact_r7=1
		 append using `r7_interview'	 
		 recode contact_r7 (.=1) if reached==1
		 recode contact_r7 (.=0) if reached==0
		 recode contact_r7 (.=0) 
		 gen interview_r7=1 if contact_r7==1 & refused!=1
		 recode interview_r7 (.=0) if contact_r7==1 & refused==1
		 gen wt_r7=phw7
		 gen wt_panel_r7=.		
 		 
		    //this household is missing roster
			   recode complete_r7 (1=0) if household_id =="130104010100219145"
			   
		 keep household_id contact_r7 interview_r7 complete_r7 wt_r7 wt_panel_r7
		 
	  //demographic information
	     preserve
		    use "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //obtaining information from other rounds
			      recode bi3_hhm_stillm (.=1) if household_id=="070409010100108017" & individual_id==3
			      recode bi4_hhm_gender (.=1) if household_id=="070409010100108017" & individual_id==3
			      recode bi5_hhm_age (.=4) if household_id=="070409010100108017" & individual_id==3
				  
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  recode bi5_hhm_age (-98=25) if household_id=="050212010100806006" & individual_id==8
				  recode bi5_hhm_age (-98=25) if household_id=="070205030100103029" & individual_id==3
				  recode bi5_hhm_age (-98=25) if household_id=="070205030100103029" & individual_id==7
				  
			   //assuming this person is a female
			      recode bi4_hhm_gender (-99=2) if household_id=="050212010100806006" & individual_id==8
			   			
	        drop if bi3_hhm_stillm==0
			gen hhsize_r7=1
		    gen m0_14_r7  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r7 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r7    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r7  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r7 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r7    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r7=. 
            replace adulteq_r7 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r7 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r7 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r7 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r7 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r7 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r7 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r7 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r7 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r7 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r7 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r7 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r7 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r7 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r7 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r7 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r7-adulteq_r7, by(household_id)
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7
		 foreach X in `x' {
		 	replace `X'=. if complete_r7!=1
		 }
		 
		 keep household_id *_r7

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round7_hh.dta", replace
	  
***************************************
**            Round 8                **
***************************************	
** GENERATE VARIABLES
	  //interview results & weights
         use "$original\Round 8\201229_WB_LSMS_HFPM_HH_Survey_Refused-Round8_Clean.dta", clear 		 
		 gen reached=0 if ii_resp_noreach!=""
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 drop if household_id=="020305010100601005"
		 tempfile r8_interview
		 save `r8_interview', replace 
		 
         use "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r8=1
		 gen contact_r8=1
		 append using `r8_interview'	 
		 recode contact_r8 (.=1) if reached==1
		 recode contact_r8 (.=0) if reached==0
		 recode contact_r8 (.=0)
		 gen interview_r8=1 if contact_r8==1 & refused!=1
		 recode interview_r8 (.=0) if contact_r8==1 & refused==1
		 gen wt_r8=phw8
		 gen wt_panel_r8=.		 
		 keep household_id contact_r8 interview_r8 complete_r8 wt_r8 wt_panel_r8
		 
	  //demographic information
	     preserve
		    use "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  			
	        drop if bi3_hhm_stillm==0
			gen hhsize_r8=1
		    gen m0_14_r8  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r8 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r8    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r8  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r8 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r8    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r8=. 
            replace adulteq_r8 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r8 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r8 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r8 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r8 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r8 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r8 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r8 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r8 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r8 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r8 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r8 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r8 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r8 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r8 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r8 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r8-adulteq_r8, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8
		 foreach X in `x' {
		 	replace `X'=. if complete_r8!=1
		 }
		 
		 keep household_id *_r8

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round8_hh.dta", replace
	  
***************************************
**            Round 9                **
***************************************	
** GENERATE VARIABLES
	  //interview results & weights
         use "$original\Round 9\200125_WB_LSMS_HFPM_HH_Survey_Refused-Round9_Clean.dta", clear 		 
		 gen reached=0 if ii_resp_noreach!=""
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r9_interview
		 save `r9_interview', replace 
		 
         use "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r9=1
		 gen contact_r9=1
		 append using `r9_interview'	 
		 recode contact_r9 (.=1) if reached==1
		 recode contact_r9 (.=0) if reached==0
		 recode contact_r9 (.=0)
		 gen interview_r9=1 if contact_r9==1 & refused!=1
		 recode interview_r9 (.=0) if contact_r9==1 & refused==1
		 gen wt_r9=phw9
		 gen wt_panel_r9=.	 
		 keep household_id contact_r9 interview_r9 complete_r9 wt_r9 wt_panel_r9
		 
	  //demographic information
	     preserve
		    use "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  			
	        drop if bi3_hhm_stillm==0
			gen hhsize_r9=1
		    gen m0_14_r9  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r9 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r9    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r9  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r9 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r9    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r9=. 
            replace adulteq_r9 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r9 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r9 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r9 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r9 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r9 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r9 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r9 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r9 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r9 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r9 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r9 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r9 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r9 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r9 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r9 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r9-adulteq_r9, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9
		 foreach X in `x' {
		 	replace `X'=. if complete_r9!=1
		 }
		 
		 keep household_id *_r9

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round9_hh.dta", replace
	  
***************************************
**            Round 10               **
***************************************	
** GENERATE VARIABLES
	  //interview results & weights
         use "$original\Round 10\210222_WB_LSMS_HFPM_HH_Survey_Refused-Round10_Clean.dta", clear 		 
		 gen reached=0 if ii_resp_noreach!=""
		 recode reached (.=1) if ii7_refreason!=.
		 gen refused=1 if ii7_refreason!=.
		 keep household_id refused reached
		 tempfile r10_interview
		 save `r10_interview', replace 
		 
         use "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 gen complete_r10=1
		 gen contact_r10=1
		 append using `r10_interview'	 
		 recode contact_r10 (.=1) if reached==1
		 recode contact_r10 (.=0) if reached==0
		 recode contact_r10 (.=0) 
		 gen interview_r10=1 if contact_r10==1 & refused!=1
		 recode interview_r10 (.=0) if contact_r10==1 & refused==1
		 gen wt_r10=phw10
		 gen wt_panel_r10=.	
		 
		    //these households are missing roster
			   recode complete_r10 (1=0) if inlist(household_id,"041013088801410025","130108010100203100")
			   
		 keep household_id contact_r10 interview_r10 complete_r10 wt_r10 wt_panel_r10
		 
	  //demographic information
	     preserve
		    use "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_roster.dta", clear
			
			//fixing observations 
			   //assuming other missings are aged 15 to 64 years				
				  recode bi5_hhm_age (-98=25) if household_id=="120106010100504229" & individual_id==6
				  recode bi5_hhm_age (98=25) if household_id=="050212010100806006" & individual_id==8
				  
			   //assuming this person is a female
			      recode bi4_hhm_gender (-99=2) if household_id=="050212010100806006" & individual_id==8
			   									
	        drop if bi3_hhm_stillm==0
			gen hhsize_r10=1
		    gen m0_14_r10  = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,0,14)) 
		    gen m15_64_r10 = 1 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==1 & bi5_hhm_age==.)
		    gen m65_r10    = 1 if (bi4_hhm_gender==1 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen f0_14_r10  = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,0,14)) 
		    gen f15_64_r10 = 1 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,15,64))|(bi4_hhm_gender==2 & bi5_hhm_age==.)
		    gen f65_r10    = 1 if (bi4_hhm_gender==2 & bi5_hhm_age>=65 & bi5_hhm_age!=.) 
		    gen adulteq_r10=. 
            replace adulteq_r10 = 0.27 if (bi4_hhm_gender==1 & bi5_hhm_age==0) 
            replace adulteq_r10 = 0.45 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r10 = 0.61 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r10 = 0.73 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r10 = 0.86 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r10 = 0.96 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r10 = 1.02 if (bi4_hhm_gender==1 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r10 = 1.00 if (bi4_hhm_gender==1 & bi5_hhm_age >=20) 
            replace adulteq_r10 = 0.27 if (bi4_hhm_gender==2 & bi5_hhm_age ==0) 
            replace adulteq_r10 = 0.45 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,1,3)) 
            replace adulteq_r10 = 0.61 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,4,6)) 
            replace adulteq_r10 = 0.73 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,7,9)) 
            replace adulteq_r10 = 0.78 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,10,12)) 
            replace adulteq_r10 = 0.83 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,13,15)) 
            replace adulteq_r10 = 0.77 if (bi4_hhm_gender==2 & inrange(bi5_hhm_age,16,19)) 
            replace adulteq_r10 = 0.73 if (bi4_hhm_gender==2 & bi5_hhm_age >=20)   
	        collapse (sum) hhsize_r10-adulteq_r10, by(household_id)	
			save `hhsize', replace
		 restore
		 mmerge household_id using `hhsize'	   
         loc x hhsize_r10 m0_14_r10 m15_64_r10 m65_r10 f0_14_r10 f15_64_r10 f65_r10 adulteq_r10
		 foreach X in `x' {
		 	replace `X'=. if complete_r10!=1
		 }
		 
		 keep household_id *_r10

** SAVE INTERMEDIATE FILES
      isid household_id
      save "$intermed\Round10_hh.dta", replace
	  
	  
***************************************
**          HEAD CHANGE              **
***************************************
** GENERATE HOUSEHOLD HEAD ID
      use "$original\Round 0\HH\sect1_hh_w4.dta", clear
	  keep if s1q01==1
	  rename individual_id headid_r0
	  keep household_id headid_r0
	  isid household_id
	  preserve
         use "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r1
		 keep household_id headid_r1
		 isid household_id
		 tempfile headid_r1
		 save `headid_r1', replace
	  restore
	  mmerge household_id using `headid_r1'
	  preserve
         use "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r2
		 keep household_id headid_r2
		 isid household_id
		 tempfile headid_r2
		 save `headid_r2', replace
	  restore
	  mmerge household_id using `headid_r2'	  
	  preserve
         use "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r3
		 keep household_id headid_r3
		 isid household_id
		 tempfile headid_r3
		 save `headid_r3', replace
	  restore
	  mmerge household_id using `headid_r3'
	  preserve
         use "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r4
		 keep household_id headid_r4
		 isid household_id
		 tempfile headid_r4
		 save `headid_r4', replace
	  restore
	  mmerge household_id using `headid_r4'	
	  preserve
         use "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r5
		 keep household_id headid_r5
		 isid household_id
		 tempfile headid_r5
		 save `headid_r5', replace
	  restore	  
	  mmerge household_id using `headid_r5'	  
	  preserve
         use "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r6
		 keep household_id headid_r6
		 isid household_id
		 tempfile headid_r6
		 save `headid_r6', replace
	  restore	  
	  mmerge household_id using `headid_r6'	  
	  preserve
         use "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r7
		 keep household_id headid_r7
		 isid household_id
		 tempfile headid_r7
		 save `headid_r7', replace
	  restore	  
	  mmerge household_id using `headid_r7'	
	  preserve
         use "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r8
		 keep household_id headid_r8
		 isid household_id
		 tempfile headid_r8
		 save `headid_r8', replace
	  restore	  
	  mmerge household_id using `headid_r8'	
	  preserve
         use "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r9
		 keep household_id headid_r9
		 isid household_id
		 tempfile headid_r9
		 save `headid_r9', replace
	  restore	  
	  mmerge household_id using `headid_r9'	
	  preserve
         use "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_roster", clear
		 drop if bi3_hhm_stillm==0
		 //fixing observation
		    recode bi6_hhm_relhhh (1=3) if household_id=="140107010100712048" & individual_id==1
	     keep if bi6_hhm_relhhh==1
		 rename indiv headid_r10
		 keep household_id headid_r10
		 isid household_id
		 tempfile headid_r10
		 save `headid_r10', replace
	  restore	  
	  mmerge household_id using `headid_r10' 	  
	  mmerge household_id using "$intermed\Round1_hh.dta", ukeep(complete_r1)	  
	  mmerge household_id using "$intermed\Round2_hh.dta", ukeep(complete_r2)
	  mmerge household_id using "$intermed\Round3_hh.dta", ukeep(complete_r3)	
	  mmerge household_id using "$intermed\Round4_hh.dta", ukeep(complete_r4)	
	  mmerge household_id using "$intermed\Round5_hh.dta", ukeep(complete_r5)
	  mmerge household_id using "$intermed\Round6_hh.dta", ukeep(complete_r6)
	  mmerge household_id using "$intermed\Round7_hh.dta", ukeep(complete_r7)
	  mmerge household_id using "$intermed\Round8_hh.dta", ukeep(complete_r8)	  
	  mmerge household_id using "$intermed\Round9_hh.dta", ukeep(complete_r9)	
	  mmerge household_id using "$intermed\Round10_hh.dta", ukeep(complete_r10)
	  forvalues i=1/$round {
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
	  recode head_chg_r4 (.=0) if (headid_r1==headid_r4) & complete_r4==1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1			  
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
	  recode head_chg_r8 (.=0) if (headid_r1==headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1 
	  recode head_chg_r8 (.=1) if (headid_r1!=headid_r8) & complete_r8==1 & complete_r7!=1 & complete_r6!=1	& complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1	& complete_r1==1   
	  gen head_chg_r9=(headid_r8!=headid_r9) if complete_r9==1 & complete_r8==1	 	  
	  recode head_chg_r9 (.=0) if (headid_r7==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=1) if (headid_r7!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7==1
	  recode head_chg_r9 (.=0) if (headid_r6==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6==1
	  recode head_chg_r9 (.=1) if (headid_r6!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6==1
	  recode head_chg_r9 (.=0) if (headid_r5==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5==1
	  recode head_chg_r9 (.=1) if (headid_r5!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5==1	  
	  recode head_chg_r9 (.=0) if (headid_r4==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r9 (.=1) if (headid_r4!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4==1 	  
	  recode head_chg_r9 (.=0) if (headid_r3==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1
	  recode head_chg_r9 (.=1) if (headid_r3!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 		  
	  recode head_chg_r9 (.=0) if (headid_r2==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1 
	  recode head_chg_r9 (.=1) if (headid_r2!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1	& complete_r2==1  	  
	  recode head_chg_r9 (.=0) if (headid_r1==headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r9 (.=1) if (headid_r1!=headid_r9) & complete_r9==1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1	& complete_r2!=1 & complete_r1==1	  
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
	  recode head_chg_r10 (.=0) if (headid_r3==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1 
	  recode head_chg_r10 (.=1) if (headid_r3!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1 & complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3==1  
	  recode head_chg_r10 (.=0) if (headid_r2==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2==1
	  recode head_chg_r10 (.=1) if (headid_r2!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1	& complete_r2==1	  
	  recode head_chg_r10 (.=0) if (headid_r1==headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r10 (.=1) if (headid_r1!=headid_r10) & complete_r10==1 & complete_r9!=1 & complete_r8!=1 & complete_r7!=1	& complete_r6!=1 & complete_r5!=1 & complete_r4!=1 & complete_r3!=1	& complete_r2!=1 & complete_r1==1		  
	  keep household_id head_chg_r*
	  

** SAVE INTERMEDIATE FILES
      save "$intermed\Head.dta", replace
	  
***************************************
**       RESPONDENT CHANGE           **
***************************************	
** GENERATE RESPONDENT ID		 
      use "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
      rename ii4_resp_id respid_r1
      keep household_id respid_r1
	  isid household_id
	  tempfile respid_r1
	  save `respid_r1', replace
	  preserve
         use "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r2
         keep household_id respid_r2
		 isid household_id
		 tempfile respid_r2
		 save `respid_r2', replace
	  restore
	  mmerge household_id using `respid_r2'	  
	  preserve
         use "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
		 replace ii4_resp_id=. if household_id=="010101088800910082"
         rename ii4_resp_id respid_r3
         keep household_id respid_r3
		 isid household_id
		 tempfile respid_r3
		 save `respid_r3', replace
	  restore
	  mmerge household_id using `respid_r3'  
	  preserve
         use "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r4
         keep household_id respid_r4
		 isid household_id
		 tempfile respid_r4
		 save `respid_r4', replace
	  restore
	  mmerge household_id using `respid_r4' 	
	  preserve
         use "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta", clear
         rename ii4_resp_id respid_r5
         keep household_id respid_r5
		 isid household_id
		 tempfile respid_r5
		 save `respid_r5', replace
	  restore
	  mmerge household_id using `respid_r5'   	  
	  preserve
         use "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r6
         keep household_id respid_r6
		 isid household_id
		 tempfile respid_r6
		 save `respid_r6', replace
	  restore
	  mmerge household_id using `respid_r6'  
	  preserve
         use "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r7
         keep household_id respid_r7
		 isid household_id
		 tempfile respid_r7
		 save `respid_r7', replace
	  restore
	  mmerge household_id using `respid_r7'	  
	  preserve
         use "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r8
         keep household_id respid_r8
		 isid household_id
		 tempfile respid_r8
		 save `respid_r8', replace
	  restore
	  mmerge household_id using `respid_r8'	
	  preserve
         use "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r9
         keep household_id respid_r9
		 isid household_id
		 tempfile respid_r9
		 save `respid_r9', replace
	  restore
	  mmerge household_id using `respid_r9'		  
	  preserve
         use "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_microdata.dta", clear
         rename ii4_resp_id respid_r10
         keep household_id respid_r10
		 isid household_id
		 tempfile respid_r10
		 save `respid_r10', replace
	  restore
	  mmerge household_id using `respid_r10'		  
	  forvalues i=1/$round {
	  	 mmerge household_id using "$intermed\Round`i'_hh.dta", ukeep(interview_r`i')
	     replace respid_r`i'=. if interview_r`i'!=1
	  }	  	  
	  gen respond_chg_r2=(respid_r1!=respid_r2) if respid_r2!=. & respid_r1!=.
      gen respond_chg_r3=(respid_r2!=respid_r3) if respid_r3!=. & respid_r2!=. 
	  recode respond_chg_r3 (.=0) if (respid_r1==respid_r3) & respid_r3!=. & respid_r2==. & respid_r1!=. 
	  recode respond_chg_r3 (.=1) if (respid_r1!=respid_r3) & respid_r3!=. & respid_r2==. & respid_r1!=. 
	  gen respond_chg_r4=(respid_r3!=respid_r4) if respid_r3!=. & respid_r4!=.	  
	  recode respond_chg_r4 (.=0) if (respid_r2==respid_r4) & respid_r4!=. & respid_r3==. & respid_r2!=.  
	  recode respond_chg_r4 (.=1) if (respid_r2!=respid_r4) & respid_r4!=. & respid_r3==. & respid_r2!=. 	  
	  recode respond_chg_r4 (.=0) if (respid_r1==respid_r4) & respid_r4!=. & respid_r3==. & respid_r2==. & respid_r1!=.
	  recode respond_chg_r4 (.=1) if (respid_r1!=respid_r4) & respid_r4!=. & respid_r3==. & respid_r2==. & respid_r1!=.	
	  gen respond_chg_r5=(respid_r4!=respid_r5) if respid_r4!=. & respid_r5!=.	  
	  recode respond_chg_r5 (.=0) if (respid_r3==respid_r5) & respid_r5!=. & respid_r4==. & respid_r3!=. 
	  recode respond_chg_r5 (.=1) if (respid_r3!=respid_r5) & respid_r5!=. & respid_r4==. & respid_r3!=. 	  
	  recode respond_chg_r5 (.=0) if (respid_r2==respid_r5) & respid_r5!=. & respid_r4==. & respid_r3==. & respid_r2!=. 
	  recode respond_chg_r5 (.=1) if (respid_r2!=respid_r5) & respid_r5!=. & respid_r4==. & respid_r3==. & respid_r2!=.
	  recode respond_chg_r5 (.=0) if (respid_r1==respid_r5) & respid_r5!=. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=. 
	  recode respond_chg_r5 (.=1) if (respid_r1!=respid_r5) & respid_r5!=. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=. 
	  gen respond_chg_r6=(respid_r5!=respid_r6) if respid_r5!=. & respid_r6!=.	  
	  recode respond_chg_r6 (.=0) if (respid_r4==respid_r6) & respid_r6!=. & respid_r5==. & respid_r4!=. 
	  recode respond_chg_r6 (.=1) if (respid_r4!=respid_r6) & respid_r6!=. & respid_r5==. & respid_r4!=. 	  
	  recode respond_chg_r6 (.=0) if (respid_r3==respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3!=.
	  recode respond_chg_r6 (.=1) if (respid_r3!=respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3!=.	
	  recode respond_chg_r6 (.=0) if (respid_r2==respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.
	  recode respond_chg_r6 (.=1) if (respid_r2!=respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.
	  recode respond_chg_r6 (.=0) if (respid_r1==respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.
	  recode respond_chg_r6 (.=1) if (respid_r1!=respid_r6) & respid_r6!=. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=.	
	  gen respond_chg_r7=(respid_r6!=respid_r7) if respid_r6!=. & respid_r7!=.	  
	  recode respond_chg_r7 (.=0) if (respid_r5==respid_r7) & respid_r7!=. & respid_r6==. & respid_r5!=.  
	  recode respond_chg_r7 (.=1) if (respid_r5!=respid_r7) & respid_r7!=. & respid_r6==. & respid_r5!=.  	  
	  recode respond_chg_r7 (.=0) if (respid_r4==respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4!=.
	  recode respond_chg_r7 (.=1) if (respid_r4!=respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4!=.	
	  recode respond_chg_r7 (.=0) if (respid_r3==respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.
	  recode respond_chg_r7 (.=1) if (respid_r3!=respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3!=.
	  recode respond_chg_r7 (.=0) if (respid_r2==respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=. 
	  recode respond_chg_r7 (.=1) if (respid_r2!=respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2!=.
	  recode respond_chg_r7 (.=0) if (respid_r1==respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=. 
	  recode respond_chg_r7 (.=1) if (respid_r1!=respid_r7) & respid_r7!=. & respid_r6==. & respid_r5==. & respid_r4==. & respid_r3==. & respid_r2==. & respid_r1!=. 
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
      keep household_id respond_chg_r*

** SAVE INTERMEDIATE FILES
      save "$intermed\Respondent.dta", replace

** MERGING ALL THE FILES
      use "$intermed\Round0_hh.dta", clear
	  forvalues i=1/$round {
	     mmerge household_id using "$intermed\Round`i'_hh.dta"		
	  }
	  mmerge household_id using "$intermed\Head.dta"
	  mmerge household_id using "$intermed\Respondent.dta"
	  drop _m

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")	
	  
** UPDATE VARIABLE
      recode phone_sample (.=0)	  
	  recode contact_r* (.=0) if complete_r1==1
      forvalues i=2/$round {
		 	recode interview_r`i' (.=0) if contact_r`i'==1
			recode complete_r`i' (.=0) if interview_r`i'==1
		 } 
	  
** DROP UNNECESSARY VARIABLES & LABELS

** VALIDATE
      run "$dofiles\hh_validation.do"
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\hh_label.do"	  
	  
** CHECK FOR DUPLICATES
      bysort household_id: assert _n==1
	  assert _N==$totalHH
	
** LABEL DATA 
      label data "Ethiopia COVID-19 - Harmonized Dataset (Household Level)"
      label var household_id "Household ID"
	
** DROP UNUSED VALUE LABELS 	  
      labelbook, problems
      label drop `r(notused)'	  	
	  
	  
** ORDER VARIABLES
      order household_id ea_id saq01 saq02 saq03 saq04 saq05 saq06 year rural ea_latitude ea_longitude dwelling roof floor walls toilet water rooms elect ///
            tv radio refrigerator bicycle mcycle car mphone computer internet generator land land_tot land_cultivated ///
			cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj rent remit assist finance ///
			any_work ag_work nfe_work ext_work nfe crop crop_number cash_crop org_fert inorg_fert pest_fung_herb hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ///
			tractor ph_loss sell_crop sell_process sell_unprocess livestock lruminant sruminant poultry equines camelids pig bee ///
			hhsize_r0 m0_14_r0 m15_64_r0 m65_r0 f0_14_r0 f15_64_r0 f65_r0 adulteq_r0 fies_mod_r0 fies_sev_r0 wt_r0 ///
			phone_sample contact_r1 interview_r1 complete_r1 hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 head_chg_r1 wt_r1 ///
            contact_r2 interview_r2 complete_r2 hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2 fies_mod_r2 fies_sev_r2 head_chg_r2 respond_chg_r2 wt_r2 ///
            contact_r3 interview_r3 complete_r3 hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3 fies_mod_r3 fies_sev_r3 head_chg_r3 respond_chg_r3 wt_r3 wt_panel_r3 ///
			contact_r4 interview_r4 complete_r4 hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4 fies_mod_r4 fies_sev_r4 head_chg_r4 respond_chg_r4 wt_r4 wt_panel_r4 ///
			contact_r5 interview_r5 complete_r5 hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5 fies_mod_r5 fies_sev_r5 head_chg_r5 respond_chg_r5 wt_r5 wt_panel_r5 ///
            contact_r6 interview_r6 complete_r6 hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6 fies_mod_r6 fies_sev_r6 head_chg_r6 respond_chg_r6 wt_r6 wt_panel_r6 ///
            contact_r7 interview_r7 complete_r7 hhsize_r7 m0_14_r7 m15_64_r7 m65_r7 f0_14_r7 f15_64_r7 f65_r7 adulteq_r7 head_chg_r7 respond_chg_r7 wt_r7 wt_panel_r7 ///
			contact_r8 interview_r8 complete_r8 hhsize_r8 m0_14_r8 m15_64_r8 m65_r8 f0_14_r8 f15_64_r8 f65_r8 adulteq_r8 head_chg_r8 respond_chg_r8 wt_r8 wt_panel_r8 ///
            contact_r9 interview_r9 complete_r9 hhsize_r9 m0_14_r9 m15_64_r9 m65_r9 f0_14_r9 f15_64_r9 f65_r9 adulteq_r9 head_chg_r9 respond_chg_r9 wt_r9 wt_panel_r9 ///
            contact_r10 interview_r10 complete_r10 hhsize_r10 m0_14_r10 m15_64_r10 m65_r10 f0_14_r10 f15_64_r10 f65_r10 adulteq_r10 head_chg_r10 respond_chg_r10 wt_r10 wt_panel_r10 
			
** SAVE FILE 
      isid household_id
	  sort household_id
	  compress
      saveold "$harmonized\ETH_HH.dta", replace
	
****************************************************
**             INDIVIDUAL LEVEL DATA              **
****************************************************
***************************************
**            ROUND 0                **
***************************************

** OPEN DATA 
      use "$original\Round 0\HH\sect1_hh_w4", clear
	  	  
** GENERATE VARIABLES
	  //demographic information  
         gen sex=s1q02
         gen age=s1q03a
		 gen member_r0=1
	     gen head_r0=(s1q01==1)
	     gen relation_r0=s1q01
		 recode relation_r0 (-99 -98=.)
		 label copy s1q01 relation_r0
		 label val relation_r0 relation_r0	
		 gen relation_os_r0=""
	     gen married=(inlist(s1q09,2,3,7))
		 gen form_married=(inlist(s1q09,4,5,6))
		 gen nev_married=(s1q09==1)
	     recode s1q08 (1 2 3=1)(4=2)(5 6 7 8=3), gen(religion)
	     keep household_id individual_id sex-religion s1q04 s1q05
		 
      //disability
	     mmerge household_id individual_id using "$original\Round 0\HH\sect3_hh_w4", ukeep(s3q21-s3q26) unmatched(master)
		 gen vision=(inlist(s3q21,3,4)) if s3q21!=.
		 gen hearing=(inlist(s3q22,3,4)) if s3q22!=.
		 gen mobility=(inlist(s3q23,3,4)) if inrange(s3q23,1,4)
		 gen communication=(inlist(s3q26,3,4)) if inrange(s3q26,1,4)
		 gen selfcare=(inlist(s3q25,3,4)) if inrange(s3q25,1,4)
		 gen cognition=(inlist(s3q24,3,4)) if inrange(s3q24,1,4)
		 gen disability=(vision==1|hearing==1|mobility==1|communication==1|selfcare==1|cognition==1)
		 replace disability=. if vision==. & hearing==. & mobility==. & communication==. & selfcare==. & cognition==.
		 drop s3q21-cognition
		 
	  //education		 
	     mmerge household_id individual_id using "$original\Round 0\HH\sect2_hh_w4", ukeep(s2q00 s2q03 s2q04 s2q06) unmatched(master)
	     gen literacy=(s2q03==1) if s2q00==1 
		 gen educ=. 
		 recode educ (.=0) if s2q04==2|s2q06==0|inrange(s2q06,95,99)
		 recode educ (.=1) if inrange(s2q06,1,8)|inlist(s2q06,93,94)
	     recode educ (.=2) if inrange(s2q06,9,12)|inrange(s2q06,21,24)
		 recode educ (.=3) if inrange(s2q06,13,20)|inrange(s2q06,25,35)
	     recode educ (.=0) if s2q00==1 
		 
	  //work
	     mmerge household_id individual_id using "$original\Round 0\HH\sect4_hh_w4", ukeep(s4q00 s4q05 s4q08 s4q10 s4q12)
         gen work=(s4q05==1|s4q08==1|s4q10==1|s4q12==1) if s4q00==1
	  
** DROP HOUSEHOLDS WITH INCOMPLETE INTERVIEWS
  

** KEEP ONLY MEMBERS
      drop if !(s1q04==1|s1q05==1)
	  drop s1q04 s1q05
	  
** DROP UNNECESSARY VARIABLES
      drop s2q00 s2q03 s2q04 s2q06 s4q00 s4q05 s4q08 s4q10 s4q12 _merge
	  
** CHECK HEAD
      preserve
	     collapse (max) head_r0, by(household_id)
		 assert head_r0==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r0, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r0) unmatched(master)
		 assert member_r0==hhsize_r0
		 assert _m==3
	  restore	  
	  
** SAVE INTERMEDIATE FILE 
      isid household_id individual_id
      sort household_id individual_id
      save "$intermed\Round0_ind.dta", replace
	  
***************************************
**            ROUND 1                **
***************************************	 
** OPEN DATA
      use "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 1\r1_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r1=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r1=bi4_hhm_gender
		 gen age_r1=bi5_hhm_age
		 recode age_r1 (-98=.)
	     gen head_r1=(bi6_hhm_relhhh==1)
	     gen relation_r1=bi6_hhm_relhhh 
		 label copy bi6_hhm_relhhh  relation
		 label val relation_r1 relation
		 recode relation_r1 (-99 -98=.)
		 replace relation_r1=. if member_r1!=1
		 replace head_r1=0 if member_r1!=1
		 gen relation_os_r1=bi6_hhm_relhhh_other if inlist(relation_r1,13,15)
		 		 
	  //respondent		 	     
	     gen respond_r1=(individual_id==ii4_resp_id)
		 
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge	
	 
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r1)
	     collapse (max) head_r1, by(household_id complete_r1)
		 assert head_r1==1 if complete_r1==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r1, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r1 complete_r1) unmatched(master)
		 assert member_r1==hhsize_r1 if complete_r1==1
		 assert _m==3
	  restore	 
	  
** SAVE INTERMEDIATE FILE 
      isid household_id individual_id
      sort household_id individual_id
      save "$intermed\Round1_ind.dta", replace		 

***************************************
**            ROUND 2                **
***************************************	 
** OPEN DATA
      use "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 2\r2_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r2=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r2=bi4_hhm_gender
		 gen age_r2=bi5_hhm_age
		 recode age_r2 (-98=.)
	     gen head_r2=(bi6_hhm_relhhh==1)
	     gen relation_r2=bi6_hhm_relhhh 
		 recode relation_r2 (-99 -98=.)
		 replace relation_r2=. if member_r2!=1
		 replace head_r2=0 if member_r2!=1
		 gen relation_os_r2=bi6_hhm_relhhh_other if inlist(relation_r2,13,15)
		 
	  //respondent		 	     
	     gen respond_r2=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge
	
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r2)
	     collapse (max) head_r2, by(household_id complete_r2)
		 assert head_r2==1 if complete_r2==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r2, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r2 complete_r2) unmatched(master)
		 assert member_r2==hhsize_r2 if complete_r2==1
		 assert _m==3
	  restore	
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round2_ind.dta", replace	
	  
***************************************
**            ROUND 3                **
***************************************	 
** OPEN DATA
      use "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 3\r3_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     //dropping a new member without age or sex information - this person is not listed in the subsequent rounds. 				 
		    drop if household_id=="010101088800910082" & individual_id==6
	     gen member_r3=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r3=bi4_hhm_gender
		 gen age_r3=bi5_hhm_age
		 recode age_r3 (-98=.)
	     gen head_r3=(bi6_hhm_relhhh==1)
	     gen relation_r3=bi6_hhm_relhhh 
		 recode relation_r3 (-99 -98=.)
		 replace relation_r3=. if member_r3!=1
		 replace head_r3=0 if member_r3!=1
		 gen relation_os_r3=bi6_hhm_relhhh_other if inlist(relation_r3,13,15)
		 
	  //respondent		 	     
	     gen respond_r3=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge
	 
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r3)
	     collapse (max) head_r3, by(household_id complete_r3)
		 assert head_r3==1 if complete_r3==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r3, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r3 complete_r3) unmatched(master)
		 assert member_r3==hhsize_r3 if complete_r3==1
		 assert _m==3
	  restore	
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round3_ind.dta", replace
	  
	  
***************************************
**            ROUND 4                **
***************************************	 
** OPEN DATA
      use "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 4\r4_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r4=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r4=bi4_hhm_gender
		 gen age_r4=bi5_hhm_age
		 recode age_r4 (-98=.)
	     gen head_r4=(bi6_hhm_relhhh==1)
	     gen relation_r4=bi6_hhm_relhhh 
		 recode relation_r4 (-99 -98=.)
		 replace relation_r4=. if member_r4!=1
		 replace head_r4=0 if member_r4!=1
		 gen relation_os_r4=bi6_hhm_relhhh_other if inlist(relation_r4,13,15)
		 
	  //respondent		 	     
	     gen respond_r4=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r4)
	     collapse (max) head_r4, by(household_id complete_r4)
		 assert head_r4==1 if complete_r4==1
	  restore	
	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r4, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r4 complete_r4) unmatched(master)
		 assert member_r4==hhsize_r4 if complete_r4==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round4_ind.dta", replace	  
	
***************************************
**            ROUND 5                **
***************************************	 
** OPEN DATA
      use "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 5\r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20", ukeep(ii4_resp_id)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r5=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r5=bi4_hhm_gender
		 gen age_r5=bi5_hhm_age
		 recode age_r5 (-98=.)
	     gen head_r5=(bi6_hhm_relhhh==1)
	     gen relation_r5=bi6_hhm_relhhh 
		 recode relation_r5 (-99 -98=.)
		 replace relation_r5=. if member_r5!=1
		 replace head_r5=0 if member_r5!=1
		 gen relation_os_r5=bi6_hhm_relhhh_other if inlist(relation_r5,13,15)
		 
	  //respondent		 	     
	     gen respond_r5=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge
	
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r5)
	     collapse (max) head_r5, by(household_id complete_r5)
		 assert head_r5==1 if complete_r5==1
	  restore	

** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r5, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r5 complete_r5) unmatched(master)
		 assert member_r5==hhsize_r5 if complete_r5==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round5_ind.dta", replace	
	  
***************************************
**            ROUND 6                **
***************************************	 
** OPEN DATA
      use "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 6\r6_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  drop if inlist(_m,1,2)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r6=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r6=bi4_hhm_gender
		 recode sex_r6 (-99=.)
		 gen age_r6=bi5_hhm_age
		 recode age_r6 (-98=.)
	     gen head_r6=(bi6_hhm_relhhh==1)
	     gen relation_r6=bi6_hhm_relhhh 
		 recode relation_r6 (-99 -98=.)
		 replace relation_r6=. if member_r6!=1
		 replace head_r6=0 if member_r6!=1
		 gen relation_os_r6=bi6_hhm_relhhh_other if inlist(relation_r6,13,15)
		 
	  //respondent		 	     
	     gen respond_r6=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge
	  
** DROP DUPLICATES
      drop if household_id=="120302088800703022" & individual_id==4 & relation_r6==.	  
	
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r6) 
	     collapse (max) head_r6, by(household_id complete_r6)
		 assert head_r6==1 if complete_r6==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r6, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r6 complete_r6) unmatched(master)
		 assert member_r6==hhsize_r6 if complete_r6==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round6_ind.dta", replace		  
	  
***************************************
**            ROUND 7                **
***************************************	 
** OPEN DATA
      use "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 7\r7_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  drop if inlist(_m,1,2)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	    //fixing member status
	        recode bi3_hhm_stillm (.=1) if household_id=="070409010100108017" & individual_id==3
	     gen member_r7=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r7=bi4_hhm_gender
		 recode sex_r7 (-99=.)
		 gen age_r7=bi5_hhm_age
		 recode age_r7 (-98=.)
	     gen head_r7=(bi6_hhm_relhhh==1)
	     gen relation_r7=bi6_hhm_relhhh 
		 recode relation_r7 (-99 -98=.)
		 replace relation_r7=. if member_r7!=1
		 replace head_r7=0 if member_r7!=1
		 gen relation_os_r7=bi6_hhm_relhhh_other if inlist(relation_r7,13,15)
		 
	  //respondent		 	     
	     gen respond_r7=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r7)
	     collapse (max) head_r7, by(household_id complete_r7)
		 assert head_r7==1 if complete_r7==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r7, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r7 complete_r7) unmatched(master)
		 assert member_r7==hhsize_r7 if complete_r7==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round7_ind.dta", replace	
	  
***************************************
**            ROUND 8                **
***************************************	 
** OPEN DATA
      use "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 8\r8_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  drop if inlist(_m,1,2)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r8=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r8=bi4_hhm_gender
		 recode sex_r8 (-99 -98=.)
		 gen age_r8=bi5_hhm_age
		 recode age_r8 (-98=.)
	     gen head_r8=(bi6_hhm_relhhh==1)
	     gen relation_r8=bi6_hhm_relhhh 
		 recode relation_r8 (-99 -98=.)
		 replace relation_r8=. if member_r8!=1
		 replace head_r8=0 if member_r8!=1
		 gen relation_os_r8=bi6_hhm_relhhh_other if inlist(relation_r8,13,15)
		 
	  //respondent		 	     
	     gen respond_r8=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r8)
	     collapse (max) head_r8, by(household_id complete_r8)
		 assert head_r8==1 if complete_r8==1
	  restore
	  	
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r8, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r8 complete_r8) unmatched(master)
		 assert member_r8==hhsize_r8 if complete_r8==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round8_ind.dta", replace	
	  
***************************************
**            ROUND 9                **
***************************************	 
** OPEN DATA
      use "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 9\r9_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  drop if inlist(_m,1,2)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r9=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r9=bi4_hhm_gender
		 recode sex_r9 (-99 -98=.)
		 gen age_r9=bi5_hhm_age
		 recode age_r9 (-98=.)
	     gen head_r9=(bi6_hhm_relhhh==1)
	     gen relation_r9=bi6_hhm_relhhh 
		 recode relation_r9 (-99 -98=.)
		 replace relation_r9=. if member_r9!=1
		 replace head_r9=0 if member_r9!=1
		 gen relation_os_r9=bi6_hhm_relhhh_other if inlist(relation_r9,13,15)
		 
	  //respondent		 	     
	     gen respond_r9=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r9)
	     collapse (max) head_r9, by(household_id complete_r9)
		 assert head_r9==1 if complete_r9==1
	  restore
	 
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r9, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r9 complete_r9) unmatched(master)
		 assert member_r9==hhsize_r9 if complete_r9==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round9_ind.dta", replace	  
	
***************************************
**            ROUND 10               **
***************************************	 
** OPEN DATA
      use "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_roster", clear 
	  mmerge household_id using "$original\Round 10\r10_wb_lsms_hfpm_hh_survey_public_microdata", ukeep(ii4_resp_id)
	  drop if inlist(_m,1,2)
	  assert _m==3
	  
** GENERATE VARIABLES
	  //demographic information
	     gen member_r10=(bi2_hhm_new==1|bi3_hhm_stillm==1)
		 gen sex_r10=bi4_hhm_gender
		 recode sex_r10 (-99 -98=.)
		 gen age_r10=bi5_hhm_age
		 recode age_r10 (-98=.)
	     gen head_r10=(bi6_hhm_relhhh==1)
	     gen relation_r10=bi6_hhm_relhhh 
		 recode relation_r10 (-99 -98=.)
		 replace relation_r10=. if member_r10!=1
		 replace head_r10=0 if member_r10!=1
		 gen relation_os_r10=bi6_hhm_relhhh_other if inlist(relation_r10,13,15)
		 
	  //respondent		 	     
	     gen respond_r10=(individual_id==ii4_resp_id) 
	
** DROP UNNECESSARY VARIABLES		 
      drop bi2_hhm_new-_merge
	  
** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")
	  
** CHECK HEAD
      preserve
	     mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r10)
	     collapse (max) head_r10, by(household_id complete_r10)
		 assert head_r10==1 if complete_r10==1
	  restore
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r10, by(household_id)
		 mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(hhsize_r10 complete_r10) unmatched(master)
		 assert member_r10==hhsize_r10 if complete_r10==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      sort household_id individual_id
      save "$intermed\Round10_ind.dta", replace
	  
** MERGING THE FILES
      use "$intermed\Round0_ind.dta", clear  
	  forvalues i=1/$round {
	  	 mmerge household_id indiv using "$intermed\Round`i'_ind.dta"
	  }
	  mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(complete_r*) unmatched(master)	  
	  forvalues i=1/$round {	  
		 replace member_r`i'=. if complete_r`i'!=1
	     replace head_r`i'=. if complete_r`i'!=1
		 replace relation_r`i'=. if complete_r`i'!=1
		 replace relation_os_r`i'="" if complete_r`i'!=1	  	
	  }

** DROPPING HOUSEHOLDS THAT WERE NOT IN ROUND 0
      drop if inlist(household_id,"020202088800202029","140307010300706110")	
	
** DROP MEMBERS WHO SEEM TO BE MISTAKENLY ADDED
      drop if household_id=="010101088800910082" & individual_id==6	  
	  
	  
** MERGE WITH HOUSEHOLD LEVEL FILES
      mmerge household_id using "$harmonized\ETH_HH.dta", ukeep(contact_r* interview_r* head_chg_r* respond_chg_r*) 
	  assert inlist(_m,2,3)
	  drop if _m==2
	  drop _m 	  

** UPDATE SEX AND AGE INFORMATION
      gen age_p=.
      forvalues i=1/$round {
	  	replace sex=sex_r`i' if sex==. & !inlist(sex_r`i',-99,-98)
		replace age_p=age_r`i' if age_r`i'!=. & age_r`i'!=-98
	  }
 	  drop sex_r* age_r*
	  
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
	  
** DROP UNNECESSARY VARIABLES
      drop contact_r* interview_r* head_chg_r* respond_chg_r* complete_r*	
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\ind_label.do"
	  
** CHECK FOR DUPLICATES
      duplicates drop
      bysort household_id individual_id: assert _n==1
	  isid household_id individual_id
	
** LABEL DATA 
      label data "Ethiopia COVID-19 - Harmonized Dataset (Individual Level)"
      label var household_id "Household ID"
      label var individual_id "Individual ID"
	  label val relation_r* relation
	 
** DROP UNUSED VALUE LABELS 	  
      labelbook, problems
      label drop `r(notused)'	  	
	  
** ORDER VARIABLES
      order household_id individual_id sex age age_p married form_married nev_married disability religion literacy educ work ///
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
            member_r10 head_r10 respond_r10 relation_r10 relation_os_r10
			
** CHECKING IND FILE WILL MERGE WITH HH FILE
      preserve
         mmerge household_id using "$harmonized\ETH_HH.dta"	
		 assert inlist(_m,2,3)
		 assert (phone_sample==0|contact_r1==0|interview_r1==0) if _m==2
	  restore	 
	  
	  
** SAVE FILE  
      isid household_id individual_id
      sort household_id individual_id
	  compress
      saveold "$harmonized\ETH_IND.dta", replace
	   