******************************************************************
**         COVID-19 Phone Survey Harmonized Data Project        **
**                                                              **
**                                                              **
**  Country: Uganda	YEAR:  2019/2021    			          	**
**                                                              **
**  Program Name:  UGA_COVID19_v01.do		    		    	**
**                                                              **
**  Version: v01 (Round 0-8)                                    **
**                                                              **
**  Description: Generates harmonized dataset				    **
**                                                              **
**  Number of HHs (UNPS 2019): 3,098                            **
**                                                              **
**  Household: hhid		    			  						**
**                                                              **
**  Program first written: June 07, 2021                    	**
**  Program last revised:                                    	**
**                                                              **
******************************************************************
set more off

** TOTAL NUMBER OF HOUSEHOLDS IN THE LAST FACE-TO-FACE SURVEY
      global totalHH 3098	
	  
** NUMBER OF PHONE SURVEY ROUNDS TO BE HARMONIZED
      global round 6

** PHONE SURVEY ROUNDS WITH FIES QUESTIONS	  
      global fies 1 2 3 4 5 6

********************************************************************************
**                       HOUSEHOLD LEVEL DATA                                 **
********************************************************************************

********************************************************************************
**                               ROUND 0                                      **
********************************************************************************

** OPEN DATA 
      use "$original\Round 0\HH\gsec1.dta", clear
	  recast str hhid
	  
** BRING EACODE
	merge 1:1 hhid using "$original\Round 0\HH shared\GSEC1.dta"
	  keep if _m==3
	  
** GENERATE VARIABLES
		 drop year
         gen year=2019
		 gen wt_r0=wgt
	     gen rural=urban
		 recode rural (0=1) (1=2) 
		 lab def rural 1 "Rural" 2 "Urban"
		 lab value rural rural
		 gen interview_result=response_status
		 gen ea_latitude=.
		 gen ea_longitude=.
		 
		 label variable region "Region Code"		 
		 encode district, gen(district2)
		 drop district
		 rename district2 district
		 label variable district "District Code"
		 rename  eacode ea
		 label variable ea "EA Code"
		 
		 encode s1aq02a, gen(county)
		 label variable county "County/Municipality Code"
		 
		 encode s1aq03a, gen(subcounty)
		 label variable subcounty "Sub-County/Division/Town Council Code"
		 

		* label variable ea "EA Code"
		 keep hhid region district interview_result ea county subcounty year wt_r0 rural ea_latitude ea_longitude
	
	  //dwelling information	 
	     mmerge hhid using "$original\Round 0\HH\gsec9.dta", ukeep(h9q02 h9q04 h9q06 h9q05 h9q22 h9q07 h9q03) unmatched(master) //20  obs only in master data 
	     gen dwelling=(h9q02==10 & h9q02!=.) 
	     gen roof=(inlist(h9q04,10,11,12,13,14) & h9q04!=.)
	     gen floor=(inlist(h9q06,10,11,12,13,15,16) & h9q06!=.)
	     gen walls=(inlist(h9q05,10,11,12,17) & h9q05!=.)
	     gen toilet=(inlist(h9q22,11,12,13,21,22,31) & h9q22!=.)
	     gen water=(inlist(h9q07,10,12,13,14,18,19,20,21,22) & h9q07!=.)
	     gen rooms=h9q03
		 replace rooms=. if h9q03>=1000000      
			///3 observations to missings
		 drop h9q02-_merge

	     mmerge hhid using "$original\Round 0\HH\gsec10_1.dta", ukeep(s10q01 s10q06) unmatched(master)
		 gen elect=1 if s10q01==1 | s10q06==1
		 replace  elect=0 if (s10q01!=. | s10q06!=.) & elect==.
		 
		 drop s10q01 s10q06
		 
	  //asset information
	     preserve
		    use "$original\Round 0\HH\gsec14.dta",clear
			gen tv=(h14q02==6 & inlist(h14q03,1,4,5))
			gen radio=(h14q02==26 & inlist(h14q03,1,4,5))
			gen refrigerator=(h14q02==24 & inlist(h14q03,1,4,5))
			gen bicycle=(h14q02==10 & inlist(h14q03,1,4,5))
			gen mcycle=(h14q02==11 & inlist(h14q03,1,4,5))
			gen car=(h14q02==12 & inlist(h14q03,1,4,5))
			gen mphone=(h14q02==16 & inlist(h14q03,1,4,5))		
			gen computer=(h14q02==17 & inlist(h14q03,1,4,5))		 
			gen generator=(h14q02==8 & inlist(h14q03,1,4,5))
	        gen internet=(h14q02==18 & inlist(h14q03,1,4,5))
			collapse (max) tv-generator internet, by(hhid)
			//assume NO for missing cases
			   recode tv-generator (.=0)
			tempfile asset
			save `asset', replace
		 restore		
         mmerge hhid using `asset', unmatched(master)
		 
		 
	  //finance and income information	
	     preserve
		    use "$original\Round 0\HH\gsec7_2", clear
	        gen rent=(inlist(IncomeSource,21,22,23) & s11q04==1)
	        gen remit=(inlist(IncomeSource,42,43) & s11q04==1)
			
			mmerge hhid using "$original\Round 0\HH\gsec2C"
	        gen assist=((inlist(IncomeSource,45,48) & s11q04==1) | s2cq2==1)
			collapse (max) rent remit assist, by(hhid)
			tempfile rent
			save `rent', replace
		 restore
		 mmerge hhid using `rent', unmatched(master)
	     preserve
		    use "$original\Round 0\HH\gsec7_1", clear
			gen finance=(CB06B==1|CB06C==1 | CB06D==1|CB06E==1 | CB06F==1|CB06G==1)
			collapse (max) finance, by(hhid)
			tempfile finance
			save `finance', replace
		 restore	
		 mmerge hhid using `finance', unmatched(master) 	     
		 
	  //labor information
	     preserve
		    use "$original\Round 0\HH\gsec8", clear
			mmerge hhid pid using "$original\Round 0\HH\gsec2", ukeep(h2q8) unmatched(master)
	        gen ag=(s8q12==1 & inrange(h2q8,15,64))
	        gen nfe=(s8q06==1 & inrange(h2q8,15,64))
	        gen ext=(s8q04==1 & inrange(h2q8,15,64))
	        gen any=(ag==1|nfe==1|ext==1|(s8q10==1 & inrange(h2q8,15,64)))    
			gen person=(inrange(h2q8,15,64))
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
		    use "$original\Round 0\HH\gsec12_1", clear
			recode NA1* (2=0)
			egen any=rowtotal(NA1*)
			gen nfe=(any>=1 & any!=.)
			keep hhid nfe
			tempfile nfe
			save `nfe', replace
		 restore
		 mmerge hhid using `nfe', unmatched(master)	

	  //land information    
	     preserve
		    use "$original\Round 0\Agric\Agsec2A", clear
		    mmerge hhid using "$original\Round 0\HH\gsec1", unmatched (master) ukeep(region)	 
				drop _m
	        //generating estimated conversions for self reported (even standard units)
		       gen conv = s2aq4/ s2aq5
		       egen med_conv_zn = median(conv), by(region)
		       gen SR_ha = (s2aq5*med_conv_zn)/2.471 //To convert acres in ha
		         
			//plot area
		        gen plotsize = s2aq4/2.471
		        replace plotsize = SR_ha if plotsize==.
				
		        //winsorize
			       winsor2 plotsize, cuts(1 99) by(region)
			
	        egen land_tot=sum(plotsize_w*(inlist(s2aq8,1,2,6,7))), by(hhid)
		    note land_tot: Limited to agricultural land. 
		    gen land=(land_tot!=0)		 
		    note land: Limited to agricultural land.
		    egen land_cultivated = sum(plotsize_w*(inlist(s2aq11a,1,2) | inlist(s2aq11b,1,2) )), by(hhid)
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
		 
/*	
	  //food security information	
	     mmerge hhid using "$original\Round 0\NG_FIES_harvest_full.dta", umatch(HHID) ukeep(p_mod p_sev)
	     gen fies_mod_r0=(p_mod>=0.5 & p_mod!=.)
	     gen fies_sev_r0=(p_sev>=0.5 & p_sev!=.)
		 drop p_mod p_sev

*/		 
	  //consumption information
	     preserve
	        use "$original\Round 0\HH\pov20.dta", clear
		    mmerge hhid using "$original\Round 0\HH\gsec1.dta", ukeep(wgt) unmatched(master)
			keep if _m==3
			keep hhid quints
			gen totcons=.
			gen foodcons=.
			gen nonfoodcons=.
			gen totcons_adj=.
			gen foodcons_adj=.
			gen nonfoodcons_adj=.
	        gen cons_quint=quints			
			keep hhid cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj
			tempfile cons
			save `cons', replace
         restore
		 mmerge hhid using `cons', unmatched(master)	
         
		
	  //agricultural information
	     preserve
		    use "$original\Round 0\Agric\agsec4a.dta", clear 
		    gen crop_number=1
			gen cash_crop=(inlist(cropID,810,811,812,820,830,520,530))
			collapse (sum) crop_number (max) cash_crop, by(hhid)
			tempfile crop_number
			save `crop_number', replace
		 restore
		 mmerge hhid using `crop_number', unmatched(master)
		 note cash_crop: COFFEE, COFFEE (arabica) COFFEE (robusta), COCOA, TEA, COTTON, TOBACCO
		 replace crop=1 if crop_number!=.
		 
	     preserve
		    use "$original\Round 0\Agric\agsec3a.dta", clear
			mmerge hhid parcelID pltid using "$original\Round 0\Agric\agsec3b.dta", unmatched (master)
			gen org_fert=(s3aq04==1)
			gen inorg_fert=(s3aq13==1)
			gen pest_fung_herb=(s3aq22==1|s3bq22==1)
			collapse (max) org_fert inorg_fert pest_fung_herb, by(hhid)
			tempfile fertilizer
			save `fertilizer', replace
		 restore
		 mmerge hhid using `fertilizer', unmatched(master)
		 replace org_fert=. if crop==0
		 replace inorg_fert=. if crop==0
		 replace pest_fung_herb=. if crop==0
		 
	     preserve
		    use "$original\Round 0\Agric\agsec3a.dta", clear
			gen hired_lab=(s3aq34==1)
			gen ex_fr_lab=(s3aq36<=0 & s3aq36!=.)
			collapse (max) hired_lab ex_fr_lab, by(hhid)
			tempfile ag_labor
			save `ag_labor', replace
		 restore
		 mmerge hhid using `ag_labor', unmatched(master)
		 replace hired_lab=. if crop==0
		 replace ex_fr_lab=. if crop==0
		 
		 //for those are missing, assume NO
		    recode hired_lab ex_fr_lab (.=0) if crop==1		
			
	     preserve
		    use "$original\Round 0\Agric\agsec10.dta", clear
            gen tractor=(A10itemcod_ID==6 | s10q04a==1)
			collapse (max) tractor, by(hhid)
		    tempfile tractor
			save `tractor', replace
		 restore
		 mmerge hhid using `tractor', unmatched(master)
		 replace tractor=. if crop==0			
		 preserve
		    use "$original\Round 0\Agric\agsec3b", clear
			gen hired_lab_ph=(s3bq34==1)
			gen ex_fr_lab_ph=(s3bq36<=0 & s3bq36!=.)
			collapse (max) hired_lab_ph ex_fr_lab_ph, by(hhid)
			tempfile ag_labor_ph
			save `ag_labor_ph', replace
		 restore
		 mmerge hhid using `ag_labor_ph', unmatched(master)
		 replace hired_lab_ph=. if crop==0
		 replace ex_fr_lab_ph=. if crop==0
		 
		 //for those that are missing, assume NO
            recode  hired_lab_ph ex_fr_lab_ph (.=0) if crop==1
	
		 preserve
		    use "$original\Round 0\Agric\agsec5b.dta", clear 
			gen sell_crop=((s5bq07a_1>0 & s5bq07a_1!=.)| (s5bq07a_2>0 & s5bq07a_2!=.))
			gen sell_process=(inrange(s5bq07b_1,31,45) | inrange(s5bq07b_2,31,45))			
			gen sell_unprocess=(inrange(s5bq07b_1,12,24)| s5bq07b_1==99 | inrange(s5bq07b_2,12,24)| s5bq07b_2==99)
			recode sell_unprocess (0=1) if hhid=="1eb0387601424300a1f0f9b1dc3b6c10" & inlist(parcelID,2,3) & pltid==1 & cropID==890
			note sell_unprocess: "Not applicable" and "missing" conditions are classified as unprocessed
			gen ph_loss=((s5bq16_1>0 & s5bq16_1!=.) | (s5bq16_2>0 & s5bq16_2!=.))
			collapse (max) sell_crop sell_unprocess sell_process ph_loss, by(hhid)
			tempfile harvest
			save `harvest', replace
		 restore
		 mmerge hhid using `harvest', unmatched(master) 
		 //for those are missing, assume NO
		 
		 replace sell_crop=. if crop==0
		 replace sell_unprocess=. if crop==0
		 replace sell_process=. if crop==0
		 replace ph_loss=. if crop==0
		 replace sell_unprocess=. if sell_crop==0
		 replace sell_process=. if sell_crop==0
			
		* order crop crop_number cash_crop org_fert inorg_fert pest_fung_herb tractor hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ph_loss sell_crop sell_unprocess sell_process, after(cons_quint)
	
	  //livestock information
	     preserve
		    use "$original\Round 0\Agric\agsec6a.dta", clear
			mmerge hhid using "$original\Round 0\Agric\agsec6b.dta"
				drop _m
			mmerge hhid using "$original\Round 0\Agric\agsec6c.dta"		
	        gen lruminant=(inrange(LiveStockID,1,10) & (s6aq03a>0 & s6aq03a!=.) & s6aq01==1)
	        gen sruminant=(inrange(ALiveStock_Small_ID,13,16) | inrange(ALiveStock_Small_ID,18,21) & (s6bq03a>0 & s6bq03a!=.) & s6bq01==1)
	        gen poultry=(inrange(APCode,23,26) & (s6cq03a>0 & s6cq03a!=.) & s6cq01==1)
	        gen equines=(inrange(LiveStockID,11,12) & (s6aq03a>0 & s6aq03a!=.) & s6aq01==1)
	        gen camelids=.
			note camelids: Data not collected.
	        gen pig=((ALiveStock_Small_ID==17 | ALiveStock_Small_ID==22) & (s6bq03a>0 & s6bq03a!=.) & s6bq01==1)
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
		    use "$original\Round 0\HH\gsec2", clear
			keep if inrange(h2q7,1,4)
		    gen hhsize_r0=1
		    gen m0_14_r0  = 1  if (h2q3==1 & inrange(h2q8,0,14)) 
		    gen m15_64_r0 = 1 if (h2q3==1 & inrange(h2q8,15,64))
		    gen m65_r0    = 1 if (h2q3==1 & h2q8>=65 & h2q8!=.) 
		    gen f0_14_r0  = 1 if (h2q3==2 & inrange(h2q8,0,14)) 
		    gen f15_64_r0 = 1 if (h2q3==2 & inrange(h2q8,15,64))
		    gen f65_r0    = 1 if (h2q3==2 & h2q8>=65 & h2q8!=.) 
		    gen adulteq_r0=. 
            replace adulteq_r0 = 0.27 if (h2q3==1 & h2q8==0) 
            replace adulteq_r0 = 0.45 if (h2q3==1 & inrange(h2q8,1,3)) 
            replace adulteq_r0 = 0.61 if (h2q3==1 & inrange(h2q8,4,6)) 
            replace adulteq_r0 = 0.73 if (h2q3==1 & inrange(h2q8,7,9)) 
            replace adulteq_r0 = 0.86 if (h2q3==1 & inrange(h2q8,10,12)) 
            replace adulteq_r0 = 0.96 if (h2q3==1 & inrange(h2q8,13,15)) 
            replace adulteq_r0 = 1.02 if (h2q3==1 & inrange(h2q8,16,19)) 
            replace adulteq_r0 = 1.00 if (h2q3==1 & h2q8 >=20) 
            replace adulteq_r0 = 0.27 if (h2q3==2 & h2q8 ==0) 
            replace adulteq_r0 = 0.45 if (h2q3==2 & inrange(h2q8,1,3)) 
            replace adulteq_r0 = 0.61 if (h2q3==2 & inrange(h2q8,4,6)) 
            replace adulteq_r0 = 0.73 if (h2q3==2 & inrange(h2q8,7,9)) 
            replace adulteq_r0 = 0.78 if (h2q3==2 & inrange(h2q8,10,12)) 
            replace adulteq_r0 = 0.83 if (h2q3==2 & inrange(h2q8,13,15)) 
            replace adulteq_r0 = 0.77 if (h2q3==2 & inrange(h2q8,16,19)) 
            replace adulteq_r0 = 0.73 if (h2q3==2 & h2q8 >=20)      
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
	 
********************************************************************************
**                                ROUND 1                                     **
********************************************************************************
** GENERATE VARIABLES	 
	  //interview results
         use "$original\Round 1\interview_result", clear
		 gen phone_sample=1		 
		 gen contact_r1=(inrange(Rq05,1,3))		 
		 gen interview_r1=(inlist(Rq05,1,2)) if contact_r1==1
		 gen complete_r1=(Rq05==1) if interview_r1==1
	     keep HHID phone_sample contact_r1 interview_r1 complete_r1

		    //these households are missing roster
			   recode complete_r1 (1=0) if inlist(HHID,224105051102,409101040401)
			   
	  //weights
	     mmerge HHID using "$original\Round 1\Cover.dta", ukeep(wfinal baseline_hhid) urename(wfinal wt_r1)
		 assert _m==3	
		 
	  //demographic information
	     preserve
		 use "$original\Round 1\SEC1.dta", clear
		 drop if pid_ubos==.
		    //fixing demographic
			   recode s1q05 (.=1) if HHID==427202012301 & pid_ubos==11
			   recode s1q03 (.=1) if HHID==117106050606 & pid_ubos==4
	        keep if (s1q02==1|s1q03==1)
		    gen hhsize_r1=1
		    gen m0_14_r1  = 1 if (s1q05==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r1 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r1    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r1  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r1 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r1    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r1=. 
            replace adulteq_r1 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r1 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r1 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r1 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r1 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r1 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r1 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r1 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r1 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r1 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r1 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r1 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r1 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r1 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r1 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r1 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r1-adulteq_r1, by(HHID)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'
		 foreach x in hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 {
		 	replace `x'=. if complete_r1!=1
		 }
		 
		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r1 phone_sample
		 
	  //fies
	     preserve
	        use "$original\Round 1\UG_FIES_round1", clear
		    destring HHID, replace
			gen fies_mod_r1=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r1=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r1
			tempfile fies_r1
			save `fies_r1', replace
		 restore
		 mmerge HHID using `fies_r1', unmatched(master)
		 
		 
		 keep hhid HHID *_r1 phone_sample
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round1_hh.dta", replace
 
********************************************************************************
**                             ROUND 2                                        **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 2\interview_result", clear
		 gen contact_r2=(inrange(Rq05,1,3))		 
		 gen interview_r2=(inlist(Rq05,1,2)) if contact_r2==1
		 gen complete_r2=(Rq05==1) if interview_r2==1
	     keep HHID contact_r2 interview_r2 complete_r2

		    //these households are missing roster
			   recode complete_r2 (1=0) if inlist(HHID,104104032002,124101051204)
			   
	  //weights
	     mmerge HHID using "$original\Round 2\Cover", ukeep(wfinal baseline_hhid) urename(wfinal wt_r2)
		 assert _m==3
		 
	  //demographic information
	     preserve
		 use "$original\Round 2\SEC1", clear
		 rename hhid HHID	 
		    //fixing demographic information
			   recode s1q05 (.=1) if HHID==102102080602 & pid_ubos==5   //from Round 4
		       recode s1q05 (.=2) if HHID==102103037601 & pid_ubos==2   //from Round 0
			   recode s1q05 (.=1) if HHID==113502011801 & pid_ubos==4   //from Round 0
			   recode s1q05 (.=2) if HHID==113604011001 & pid_ubos==5   //from Round 4
			   recode s1q05 (.=2) if HHID==117201050102 & pid_ubos==3    //from Round 0			   
			   recode s1q05 (.=2) if HHID==203107062301 & pid_ubos==3    //from Round 4
			   recode s1q05 (.=1) if HHID==203107062301 & pid_ubos==10   //from Round 4
			   recode s1q05 (.=1) if HHID==208201020101 & pid_ubos==5   //from Round 0
			   recode s1q05 (.=2) if HHID==208202080204 & pid_ubos==8   //from Round 4
			   recode s1q05 (.=2) if HHID==214102021103 & pid_ubos==11  //from Round 4
			   recode s1q05 (.=2) if HHID==215120020401 & pid_ubos==5  //from Round 4
			   recode s1q05 (.=1) if HHID==219103120404 & pid_ubos==6  //from Round 4
			   recode s1q05 (.=1) if HHID==222111020201 & pid_ubos==1  //from Round 4
			   recode s1q05 (.=2) if HHID==223108100601 & pid_ubos==4  //from Round 4
			   recode s1q05 (.=2) if HHID==226105050502 & pid_ubos==14 //from Round 4
			   recode s1q05 (.=2) if HHID==230105010403 & pid_ubos==8 //from Round 4
			   recode s1q05 (.=2) if HHID==230105010409 & pid_ubos==15  //from Round 4
			   recode s1q05 (.=2) if HHID==230105040607 & pid_ubos==7   //from Round 4
			   recode s1q05 (.=1) if HHID==232202031201 & pid_ubos==13 //from Round 4
			   recode s1q05 (.=2) if HHID==232203040203 & pid_ubos==2  //from Round 0
			   recode s1q05 (.=2) if HHID==304102010704 & pid_ubos==3 //from Round 0
			   recode s1q05 (.=2) if HHID==307105040802 & pid_ubos==6  //from Round 4
			   recode s1q05 (.=2) if HHID==311103010502 & pid_ubos==4  //from Round 4
			   recode s1q05 (.=2) if HHID==317101030301 & pid_ubos==2  //from Round 4
			   recode s1q05 (.=2) if HHID==317107051003 & pid_ubos==8  //from Round 0
			   recode s1q05 (.=1) if HHID==319203030904 & pid_ubos==6  //from Round 4
			   recode s1q05 (.=2) if HHID==320108070301 & pid_ubos==5 //from Round 4
			   recode s1q05 (.=2) if HHID==321107061305 & pid_ubos==7 //from Round 4
			   recode s1q05 (.=2) if HHID==325101021501 & pid_ubos==5 //from Round 0
			   recode s1q05 (.=1) if HHID==325101021501 & pid_ubos==6 //from Round 0
			   recode s1q05 (.=2) if HHID==325101021501 & pid_ubos==7 //from Round 0
			   recode s1q05 (.=2) if HHID==403102011401 & pid_ubos==3 //from Round 4
			   recode s1q05 (.=2) if HHID==404102030502 & pid_ubos==10  //from Round 4
			   recode s1q05 (.=2) if HHID==406108040201 & pid_ubos==3   //from Round 4
			   recode s1q05 (.=2) if HHID==406108040203 & pid_ubos==3  //from Round 4
			   recode s1q05 (.=1) if HHID==407106020603 & pid_ubos==10 //from Round 4
			   recode s1q05 (.=2) if HHID==408112022101 & pid_ubos==3 //from Round 4
			   recode s1q05 (.=1) if HHID==410105020502 & pid_ubos==1 //from Round 4
			   recode s1q05 (.=1) if HHID==418202010302 & pid_ubos==3  //from Round 4
			   recode s1q05 (.=1) if HHID==427202012301 & pid_ubos==11  //from Round 4	
			   
		    keep if (s1q02==1|s1q03==1)		
			drop if s1q02a==2
		    gen hhsize_r2=1
		    gen m0_14_r2  = 1 if (s1q05==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r2 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r2    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r2  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r2 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r2    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r2=. 
            replace adulteq_r2 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r2 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r2 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r2 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r2 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r2 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r2 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r2 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r2 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r2 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r2 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r2 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r2 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r2 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r2 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r2 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r2-adulteq_r2, by(HHID)				
			tempfile hhsize			
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'	   
         loc x hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2
		 foreach X in `x' {
		 	replace `X'=. if complete_r2!=1
		 }
		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r2

	  //fies
	     preserve
	        use "$original\Round 2\UG_FIES_round2", clear
			destring HHID, replace
		    gen fies_mod_r2=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r2=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r2
			tempfile fies_r2
			save `fies_r2', replace
		 restore
		 mmerge HHID using `fies_r2', unmatched(master)
		 keep hhid HHID *_r2

** SAVE INTERMEDIATE FILES
      save "$intermed\Round2_hh.dta", replace
	  
********************************************************************************
**                                ROUND 3                                     **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results
         use "$original\Round 3\interview_result", clear
		 gen contact_r3=(inrange(Rq05,1,3))		 
		 gen interview_r3=(inlist(Rq05,1,2)) if contact_r3==1
		 gen complete_r3=(Rq05==1) if interview_r3==1
	     keep HHID contact_r3 interview_r3 complete_r3

		    //these households are missing roster
			   recode complete_r3 (1=0) if inlist(HHID,108106050601,112101010701)
			   	
	  //weights
	     mmerge HHID using "$original\Round 3\Cover", ukeep(wfinal baseline_hhid) urename(wfinal wt_r3)
		 assert _m==3

	  //demographic information
	     preserve
		 use "$original\Round 3\SEC1", clear
	        keep if (s1q02==1|s1q03==1)
			drop if s1q02a==2
		    gen hhsize_r3=1
		    gen m0_14_r3  = 1 if (s1q05==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r3 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r3    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r3  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r3 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r3    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r3=. 
            replace adulteq_r3 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r3 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r3 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r3 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r3 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r3 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r3 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r3 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r3 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r3 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r3 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r3 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r3 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r3 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r3 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r3 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r3-adulteq_r3, by(HHID)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'	
         loc x hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3
		 foreach X in `x' {
		 	replace `X'=. if complete_r3!=1
		 }		 
		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r3
		 
	  //fies
	     preserve
	        use "$original\Round 3\UG_FIES_round3", clear
			destring HHID, replace
		    gen fies_mod_r3=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r3=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r3
			tempfile fies_r3
			save `fies_r3', replace
		 restore
		 mmerge HHID using `fies_r3', unmatched(master)
		 keep hhid HHID *_r3
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round3_hh.dta", replace
	  
********************************************************************************
**                                ROUND 4                                     **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 4\interview_result", clear
		 gen contact_r4=(inrange(Rq05,1,3))		 
		 gen interview_r4=(inlist(Rq05,1,2)) if contact_r4==1
		 gen complete_r4=(Rq05==1) if interview_r4==1
	     keep HHID contact_r4 interview_r4 complete_r4

		    //these households are missing roster
			   recode complete_r4 (1=0) if inlist(HHID,107402030301,203202040301,230104010401,327103031001,409101040401)

	  //weights
	     mmerge HHID using "$original\Round 4\Cover.dta", ukeep(wfinal baseline_hhid) urename(wfinal wt_r4)
		 assert _m==3	
		 
	  //demographic information
	     preserve
		    use "$original\Round 4\SEC1", clear
	        keep if (s1q02==1|s1q03==1)
			drop if s1q02a==2
		    gen hhsize_r4=1
		    gen m0_14_r4  = 1 if (s1q05==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r4 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r4    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r4  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r4 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r4    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r4=. 
            replace adulteq_r4 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r4 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r4 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r4 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r4 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r4 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r4 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r4 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r4 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r4 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r4 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r4 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r4 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r4 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r4 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r4 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r4-adulteq_r4, by(HHID)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'	
         loc x hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4
		 foreach X in `x' {
		 	replace `X'=. if complete_r4!=1
		 }		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r4
		 
		 
	  //fies
	     preserve
	        use "$original\Round 4\UG_FIES_round4", clear
			destring HHID, replace
		    gen fies_mod_r4=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r4=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r4
			tempfile fies_r4
			save `fies_r4', replace
		 restore
		 mmerge HHID using `fies_r4', unmatched(master)		 
		 keep hhid HHID *_r4
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round4_hh.dta", replace
	  
********************************************************************************
**                                ROUND 5                                     **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 5\interview_result", clear
		 gen contact_r5=(inrange(Rq05,1,3))		 
		 gen interview_r5=(inlist(Rq05,1,2)) if contact_r5==1
		 gen complete_r5=(Rq05==1) if interview_r5==1
	     keep HHID contact_r5 interview_r5 complete_r5

		    //these households are missing roster
			   recode complete_r5 (1=0) if HHID==115203060407
		 
	  //weights
	     mmerge HHID using "$original\Round 5\Cover.dta", ukeep(wfinal baseline_hhid) urename(wfinal wt_r5)
		 assert _m==3	
		 
	  //demographic information
	     preserve
		    use "$original\Round 5\SEC1", clear
			//fixing demographic information
			   recode s1q05 (.a=2) if HHID==115203060401 & pid_ubos==11
			   recode s1q05 (.a=2) if HHID==115206030202 & pid_ubos==10
			   recode s1q05 (.a=2) if HHID==323108031103 & pid_ubos==2
			   recode s1q05 (.a=1) if HHID==404403030402 & pid_ubos==6
			   recode s1q05 (.a=2) if HHID==408113040501 & pid_ubos==6
	        keep if (s1q02==1|s1q03==1)
			drop if s1q02a==2
		    gen hhsize_r5=1
		    gen m0_14_r5  = 1 if (s1q05==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r5 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r5    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r5  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r5 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r5    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r5=. 
            replace adulteq_r5 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r5 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r5 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r5 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r5 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r5 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r5 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r5 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r5 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r5 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r5 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r5 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r5 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r5 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r5 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r5 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r5-adulteq_r5, by(HHID)	
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'	
         loc x hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5
		 foreach X in `x' {
		 	replace `X'=. if complete_r5!=1
		 }		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r5
		 
	  //fies
	     preserve
	        use "$original\Round 5\UG_FIES_round5", clear
			destring HHID, replace
		    gen fies_mod_r5=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r5=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r5
			tempfile fies_r5
			save `fies_r5', replace
		 restore
		 mmerge HHID using `fies_r5', unmatched(master)
		 keep hhid HHID *_r5
		 
** SAVE INTERMEDIATE FILES
      save "$intermed\Round5_hh.dta", replace
	
********************************************************************************
**                                ROUND 6                                     **
********************************************************************************
** GENERATE VARIABLES		  
	  //interview results and weights
         use "$original\Round 6\interview_result", clear
		 gen contact_r6=(inrange(Rq05,1,3))		 
		 gen interview_r6=(inlist(Rq05,1,2)) if contact_r6==1
		 gen complete_r6=(Rq05==1) if interview_r6==1
	     keep HHID contact_r6 interview_r6 complete_r6

	  //weights
	     mmerge HHID using "$original\Round 6\Cover.dta", ukeep(wfinal baseline_hhid) urename(wfinal wt_r6)
		 assert _m==3	
		 
	  //demographic information
	     preserve
		    use "$original\Round 6\SEC1", clear
			//fixing demographic information
			   recode s1q05 (.a=1) if HHID==211107030806 & pid_ubos==1
			   recode s1q05 (.a=2) if HHID==216202030407 & pid_ubos==12
			   recode s1q06 (.a=23) if HHID==216202030407 & pid_ubos==12
			   recode s1q07 (.a=15) if HHID==216202030407 & pid_ubos==12
			   recode s1q05 (.a=1) if HHID==222111020101 & pid_ubos==10			   
	        keep if (s1q02==1|s1q03==1)
			drop if s1q02a==2
		    gen hhsize_r6=1
		    gen m0_14_r6  = 1 if (s1q05 ==1 & inrange(s1q06,0,14)) 
		    gen m15_64_r6 = 1 if (s1q05==1 & inrange(s1q06,15,64))|(s1q05==1 & s1q06==.)
		    gen m65_r6    = 1 if (s1q05==1 & s1q06>=65 & s1q06!=.) 
		    gen f0_14_r6  = 1 if (s1q05==2 & inrange(s1q06,0,14)) 
		    gen f15_64_r6 = 1 if (s1q05==2 & inrange(s1q06,15,64))|(s1q05==2 & s1q06==.)
		    gen f65_r6    = 1 if (s1q05==2 & s1q06>=65 & s1q06!=.) 
		    gen adulteq_r6=. 
            replace adulteq_r6 = 0.27 if (s1q05==1 & s1q06==0) 
            replace adulteq_r6 = 0.45 if (s1q05==1 & inrange(s1q06,1,3)) 
            replace adulteq_r6 = 0.61 if (s1q05==1 & inrange(s1q06,4,6)) 
            replace adulteq_r6 = 0.73 if (s1q05==1 & inrange(s1q06,7,9)) 
            replace adulteq_r6 = 0.86 if (s1q05==1 & inrange(s1q06,10,12)) 
            replace adulteq_r6 = 0.96 if (s1q05==1 & inrange(s1q06,13,15)) 
            replace adulteq_r6 = 1.02 if (s1q05==1 & inrange(s1q06,16,19)) 
            replace adulteq_r6 = 1.00 if (s1q05==1 & s1q06 >=20) 
            replace adulteq_r6 = 0.27 if (s1q05==2 & s1q06 ==0) 
            replace adulteq_r6 = 0.45 if (s1q05==2 & inrange(s1q06,1,3)) 
            replace adulteq_r6 = 0.61 if (s1q05==2 & inrange(s1q06,4,6)) 
            replace adulteq_r6 = 0.73 if (s1q05==2 & inrange(s1q06,7,9)) 
            replace adulteq_r6 = 0.78 if (s1q05==2 & inrange(s1q06,10,12)) 
            replace adulteq_r6 = 0.83 if (s1q05==2 & inrange(s1q06,13,15)) 
            replace adulteq_r6 = 0.77 if (s1q05==2 & inrange(s1q06,16,19)) 
            replace adulteq_r6 = 0.73 if (s1q05==2 & s1q06 >=20)      
	        collapse (sum) hhsize_r6-adulteq_r6, by(HHID)
			tempfile hhsize
			save `hhsize', replace
		 restore
		 mmerge HHID using `hhsize'	
         loc x hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6
		 foreach X in `x' {
		 	replace `X'=. if complete_r6!=1
		 }		 
		 
		 rename baseline_hhid hhid
		 keep hhid HHID *_r6
		 
		 
	  //fies
	     preserve
	        use "$original\Round 6\UG_FIES_round6", clear
			destring HHID, replace
		    gen fies_mod_r6=(p_mod>=0.5 & p_mod!=.)
	        gen fies_sev_r6=(p_sev>=0.5 & p_sev!=.)
			keep HHID *_r6
			tempfile fies_r6
			save `fies_r6', replace
		 restore
		 mmerge HHID using `fies_r6', unmatched(master)
		 keep hhid HHID *_r6
		 
** SAVE INTERMEDIATE FILES
		 drop if hhid==""

      save "$intermed\Round6_hh.dta", replace
	  
	
********************************************************************************
**                              HEAD CHANGE                                   **
********************************************************************************


** GENERATE HOUSEHOLD HEAD ID
      use "$original\Round 0\HH\gsec2", clear
	  keep if h2q4==1
	  rename pid headid_r0
	  keep hhid headid_r0
	  isid hhid
	  preserve
         use "$original\Round 1\SEC1", clear
			merge m:1 HHID using "$intermed\Round1_hh.dta"
			keep if _m==3
			//fixing demographic information
		 	recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==204102041403 & pid_ubos==1
			recode s1q07 (2=1) if HHID==107302030302 & pid_ubos==2
			recode s1q07 (2=1) if HHID==415105020407 & pid_ubos==1
			recode s1q07 (3=1) if HHID==405302030501 & pid_ubos==1
			recode s1q07 (3=1) if HHID==116102020201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==204301031201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==302204050806 & pid_ubos==6
			recode s1q07 (2=1) if HHID==222111020201 & pid_ubos==2
			recode s1q07 (3=1) if HHID==319105030201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==329106020901 & pid_ubos==1
			recode s1q07 (2=1) if HHID==321107061303 & pid_ubos==1
			recode s1q07 (3=1) if HHID==225103040601 & pid_ubos==1
			recode s1q07 (3=1) if HHID==124103020804 & pid_ubos==4
			recode s1q07 (3=1) if HHID==223120021008 & pid_ubos==1
			recode s1q07 (2=1) if HHID==406212010703 & pid_ubos==1
			recode s1q07 (2=1) if HHID==117302062702 & pid_ubos==2
			recode s1q07 (3=1) if HHID==312105021606 & pid_ubos==1
			recode s1q07 (3=1) if HHID==208107130107 & pid_ubos==2
			recode s1q07 (3=1) if HHID==402210031401 & pid_ubos==1
			recode s1q07 (3=1) if HHID==408102011203 & pid_ubos==2
			recode s1q07 (2=1) if HHID==215109021807 & pid_ubos==2
			recode s1q07 (3=1) if HHID==415106081307 & pid_ubos==1
			recode s1q07 (3=1) if HHID==221109050503 & pid_ubos==1
			recode s1q07 (3=1) if HHID==204102041404 & pid_ubos==11
			recode s1q07 (7=1) if HHID==104208040101 & pid_ubos==1
			recode s1q07 (2=1) if HHID==402208010401 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (3=1) if HHID==204101031305 & pid_ubos==5
			recode s1q07 (3=1) if HHID==402201040901 & pid_ubos==1	
	     keep if s1q07==1
		 rename pid_ubos headid_r1
		 keep hhid headid_r1
		 isid hhid
		 tempfile headid_r1
		 save `headid_r1', replace
	  restore
	  mmerge hhid using `headid_r1'
	  preserve
         use "$original\Round 2\SEC1", clear
			rename hhid HHID
			merge m:1 HHID using "$intermed\Round2_hh.dta"
			keep if _m==3
			recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==321107061303 & pid_ubos==1
			recode s1q07 (2=1) if HHID==309103040301 & pid_ubos==2		 
	     keep if s1q07==1
		 rename pid_ubos headid_r2
		 keep hhid headid_r2
		 isid hhid
		 tempfile headid_r2
		 save `headid_r2', replace
	  restore
	  mmerge hhid using `headid_r2'	  
	  preserve
         use "$original\Round 3\SEC1", clear
			merge m:1 HHID using "$intermed\Round3_hh.dta"
			keep if _m==3
		 	recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2		 
	     keep if s1q07==1
		 rename pid_ubos headid_r3
		 keep hhid headid_r3
		 isid hhid
		 tempfile headid_r3
		 save `headid_r3', replace
	  restore
	  mmerge hhid using `headid_r3'
	  
  
	  preserve
      use "$original\Round 2\SEC1", clear
	  rename hhid HHID
	  keep HHID pid_ubos hh_roster__id t0_ubos_pid
	
		 tempfile r2
		 save `r2', replace

      use "$original\Round 1\SEC1", clear
	  keep HHID pid_ubos hh_roster__id t0_ubos_pid
	  sort HHID pid_ubos
		 tempfile r1
		 save `r1', replace
     
         use "$original\Round 4\SEC1", clear
			merge m:1 HHID using "$intermed\Round4_hh.dta"
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2		 
			recode s1q07 (2=1) if HHID==310306040201 & pid_ubos==2				
			keep if _m==3
			keep if s1q07==1	 
			mmerge HHID pid_ubos using "$original\Round 3\SEC1", ukeep(t0_ubos_pid)
			drop if _m==2
			mmerge HHID pid_ubos using `r2', ukeep(t0_ubos_pid)
			drop if _m==2			
			mmerge HHID pid_ubos using `r1', ukeep(t0_ubos_pid) 
			drop if _m==2
	
		 		 
	     keep if s1q07==1
		 rename pid_ubos headid_r4
		 keep hhid headid_r4
		 isid hhid
		 tempfile headid_r4
		 save `headid_r4', replace
	  restore
	  mmerge hhid using `headid_r4'	
	  preserve
         use "$original\Round 5\SEC1", clear
			merge m:1 HHID using "$intermed\Round5_hh.dta"
			keep if _m==3
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2		
			recode s1q07 (2=1) if HHID==226102051006 & pid_ubos==2	 	 
	     keep if s1q07==1
		 rename pid_ubos headid_r5
		 keep hhid headid_r5
		 isid hhid
		 tempfile headid_r5
		 save `headid_r5', replace
	  restore	  
	  mmerge hhid using `headid_r5'	  
	  preserve
         use "$original\Round 6\SEC1", clear
			merge m:1 HHID using "$intermed\Round6_hh.dta"
			keep if _m==3
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2	
		 keep if s1q07==1
		 rename pid_ubos headid_r6
		 keep hhid headid_r6
		 sort hhid 
		 drop if hhid==""
		 isid hhid
		 tempfile headid_r6
		 save `headid_r6', replace
		 
	  restore	  
	  mmerge hhid using `headid_r6'	  
	  mmerge hhid using "$intermed\Round1_hh.dta", ukeep(complete_r1)	  
	  mmerge hhid using "$intermed\Round2_hh.dta", ukeep(complete_r2)
	  mmerge hhid using "$intermed\Round3_hh.dta", ukeep(complete_r3)	
	  mmerge hhid using "$intermed\Round4_hh.dta", ukeep(complete_r4)	
	  mmerge hhid using "$intermed\Round5_hh.dta", ukeep(complete_r5)
	  mmerge hhid using "$intermed\Round6_hh.dta", ukeep(complete_r6)
	  drop _m
	  merge 1:1 hhid using "$intermed\Round0_hh.dta"
	  drop if _m==1
	  keep hhid headid* complete*
	  
	  forvalues i=1/$round {
	     replace headid_r`i'=. if complete_r`i'!=1
	  }
	  gen head_chg_r1=(headid_r0!=headid_r1) if complete_r1==1 
	  gen head_chg_r2=(headid_r1!=headid_r2) if complete_r2==1
      gen head_chg_r3=(headid_r2!=headid_r3) if complete_r3==1 & complete_r2==1
	  recode head_chg_r3 (.=0) if (headid_r1==headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r3 (.=1) if (headid_r1!=headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r3 (.=0) if (headid_r0==headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1!=1
	  recode head_chg_r3 (.=1) if (headid_r0!=headid_r3) & complete_r3==1 & complete_r2!=1 & complete_r1!=1	  
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
	  recode head_chg_r5 (.=1) if  head_chg_r5==. & complete_r5==1 & headid_r4==.
	  gen head_chg_r6=(headid_r5!=headid_r6) if complete_r6==1 & complete_r5==1	 	  
	  recode head_chg_r6 (.=0) if (headid_r4==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=1) if (headid_r4!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4==1
	  recode head_chg_r6 (.=0) if (headid_r3==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3==1
	  recode head_chg_r6 (.=1) if (headid_r3!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3==1
	  recode head_chg_r6 (.=0) if (headid_r2==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2==1
	  recode head_chg_r6 (.=1) if (headid_r2!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2==1	  
	  recode head_chg_r6 (.=0) if (headid_r1==headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2!=1 & complete_r1==1
	  recode head_chg_r6 (.=1) if (headid_r1!=headid_r6) & complete_r6==1 & complete_r5!=1 & complete_r4!=1	& complete_r3!=1 & complete_r2!=1 & complete_r1==1     
	  recode head_chg_r6 (.=1) if  head_chg_r6==. & complete_r6==1 & headid_r4==.  
	  keep hhid head_chg_r*
	  
	  
** SAVE INTERMEDIATE FILES
      save "$intermed\Head.dta", replace
	  
********************************************************************************
**                         RESPONDENT CHANGE                                  **
********************************************************************************
** GENERATE RESPONDENT ID		 
      use "$original\Round 1\interview_result", clear
			merge m:1 HHID using "$intermed\Round1_hh.dta"
			keep if _m==3
	  
      rename Rq09 respid_r1
      keep hhid respid_r1
	  isid hhid
	  tempfile respid_r1
	  save `respid_r1', replace
	  preserve
         use "$original\Round 2\interview_result", clear
			merge m:1 HHID using "$intermed\Round2_hh.dta"
			keep if _m==3
		 
         rename Rq09 respid_r2
         keep hhid respid_r2
		 isid hhid
		 tempfile respid_r2
		 save `respid_r2', replace
	  restore
	  mmerge hhid using `respid_r2'	  
	  preserve
         use "$original\Round 3\interview_result", clear
			merge m:1 HHID using "$intermed\Round3_hh.dta"
			keep if _m==3
		 
         rename Rq09 respid_r3
         keep hhid respid_r3
		 isid hhid
		 tempfile respid_r3
		 save `respid_r3', replace
	  restore
	  mmerge hhid using `respid_r3'  
	  preserve
         use "$original\Round 4\interview_result", clear
			merge m:1 HHID using "$intermed\Round4_hh.dta"
			keep if _m==3
		 
         rename Rq09 respid_r4
         keep hhid respid_r4
		 isid hhid
		 tempfile respid_r4
		 save `respid_r4', replace
	  restore
	  mmerge hhid using `respid_r4' 	
	  preserve
         use "$original\Round 5\interview_result", clear
			merge m:1 HHID using "$intermed\Round5_hh.dta"
			keep if _m==3
		 
         rename Rq09 respid_r5
         keep hhid respid_r5
		 isid hhid
		 tempfile respid_r5
		 save `respid_r5', replace
	  restore
	  mmerge hhid using `respid_r5'   	  
	  preserve
         use "$original\Round 6\interview_result", clear
			merge m:1 HHID using "$intermed\Round6_hh.dta"
			keep if _m==3
		 
         rename Rq09 respid_r6
         keep hhid respid_r6
		 isid hhid
		 tempfile respid_r6
		 save `respid_r6', replace
	  restore
	  mmerge hhid using `respid_r6'  
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
      keep hhid respond_chg_r*

** SAVE INTERMEDIATE FILES
      save "$intermed\Respondent.dta", replace

** MERGING ALL THE FILES
      use "$intermed\Round0_hh.dta", clear
	  forvalues i=1/$round {
	     mmerge hhid using "$intermed\Round`i'_hh.dta"		
	  }
		drop _m
	  mmerge hhid using "$intermed\Head.dta"
	  mmerge hhid using "$intermed\Respondent.dta"
	  drop _m
		merge 1:1 hhid using "$intermed\Round0_hh.dta"
		keep if _m==3
	  
	  drop _m
	  
** UPDATE VARIABLE
      recode phone_sample (.=0)	  
	  recode contact_r* (.=0) if phone_sample==1
	  forvalues i=1/$round {
	     replace phone_sample=1 if contact_r`i'==1 & phone_sample==0		
	  }
	  
** DROP UNNECESSARY VARIABLES & LABELS
      drop HHID

** GEN MISSING VARIABLES
	  gen wt_panel_r3=.
	  gen wt_panel_r4=.
	  gen wt_panel_r5=.
	  gen wt_panel_r6=.
	  
** VALIDATE
      run "$dofiles\hh_validation.do"
	  
	** Failed to validate this condition:
		// 	  assert inlist(sell_crop,0,.) if inlist(sell_process,0,.) & inlist(sell_unprocess,0,.)
		// Reason, while it has been recorded that 3,187 crops (hhid parcel crop) were sold, s5bq07a_1
		// only information about the condition (processed or not) for 2,705
		
	
	** There are some missing values in age, then hhsize is not equal to the summ of age cohorts
        // assert hhsize_r`i'==m0_14_r`i'+m15_64_r`i'+m65_r`i'+f0_14_r`i'+f15_64_r`i'+f65_r`i'
		//

** LABEL VARIABLES & VALUES
label drop rural

      run "$dofiles\hh_label.do"	  
	 
** CHECK FOR DUPLICATES
      bysort hhid: assert _n==1
	  assert _N==$totalHH
	
** LABEL DATA 
      label data "Uganda COVID-19 - Harmonized Dataset (Household Level)"
      label var hhid "Household ID"
		
** ORDER VARIABLES
      order hhid hhid region district county subcounty ea year rural ea_latitude ea_longitude dwelling roof floor walls toilet water rooms elect ///
            tv radio refrigerator bicycle mcycle car mphone computer internet generator land land_tot land_cultivated ///
			cons_quint totcons foodcons nonfoodcons totcons_adj foodcons_adj nonfoodcons_adj rent remit assist finance ///
			any_work ag_work nfe_work ext_work nfe crop crop_number cash_crop org_fert inorg_fert pest_fung_herb hired_lab ex_fr_lab hired_lab_ph ex_fr_lab_ph ///
			tractor ph_loss sell_crop sell_process sell_unprocess livestock lruminant sruminant poultry equines camelids pig bee ///
			hhsize_r0 m0_14_r0 m15_64_r0 m65_r0 f0_14_r0 f15_64_r0 f65_r0 adulteq_r0  wt_r0 ///
			phone_sample contact_r1 interview_r1 complete_r1 hhsize_r1 m0_14_r1 m15_64_r1 m65_r1 f0_14_r1 f15_64_r1 f65_r1 adulteq_r1 fies_mod_r1 fies_sev_r1 head_chg_r1 wt_r1 ///
            contact_r2 interview_r2 complete_r2 hhsize_r2 m0_14_r2 m15_64_r2 m65_r2 f0_14_r2 f15_64_r2 f65_r2 adulteq_r2 fies_mod_r2 fies_sev_r2 head_chg_r2 respond_chg_r2 wt_r2 ///
            contact_r3 interview_r3 complete_r3 hhsize_r3 m0_14_r3 m15_64_r3 m65_r3 f0_14_r3 f15_64_r3 f65_r3 adulteq_r3 fies_mod_r3 fies_sev_r3 head_chg_r3 respond_chg_r3 wt_r3 wt_panel_r3 ///
			contact_r4 interview_r4 complete_r4 hhsize_r4 m0_14_r4 m15_64_r4 m65_r4 f0_14_r4 f15_64_r4 f65_r4 adulteq_r4 fies_mod_r4 fies_sev_r4 head_chg_r4 respond_chg_r4 wt_r4 wt_panel_r4 ///
			contact_r5 interview_r5 complete_r5 hhsize_r5 m0_14_r5 m15_64_r5 m65_r5 f0_14_r5 f15_64_r5 f65_r5 adulteq_r5 head_chg_r5 fies_mod_r5 fies_sev_r5 respond_chg_r5 wt_r5 wt_panel_r5 ///
            contact_r6 interview_r6 complete_r6 hhsize_r6 m0_14_r6 m15_64_r6 m65_r6 f0_14_r6 f15_64_r6 f65_r6 adulteq_r6 head_chg_r6 fies_mod_r6 fies_sev_r6 respond_chg_r6 wt_r6 wt_panel_r6
			
** SAVE FILE 
      isid hhid
	  sort hhid
	  compress
      saveold "$harmonized\UGA_HH.dta", replace
  
********************************************************************************
**                        INDIVIDUAL LEVEL DATA                               **
********************************************************************************
********************************************************************************
**                               ROUND 0                                      **
********************************************************************************

** OPEN DATA 
      use "$original\Round 0\HH\gsec2", clear
	  	  
** GENERATE VARIABLES
	  //demographic information  
         gen sex=h2q3
         gen age=h2q8
		 gen member_r0=1
	     gen head_r0=(h2q4==1)
	     gen relation_r0=h2q4
		 label copy h2q04 relation_r0
		 label val relation_r0 relation_r0		 
		 gen relation_os_r0=.
		 note relation_os_r0: Data not collected.
	     gen married=(inlist(h2q10,1,2))
		 gen form_married=(inlist(h2q10,3,4))
		 gen nev_married=(h2q10==5)
	     gen religion=.
		 note religion: Data not collected.
	     keep hhid pid sex-religion h2q7
/*		 
      //disability
	     mmerge hhid indiv using "$original\Round 0\HH\sect4a_harvestw4", ukeep(s4aq23 s4aq25 s4aq27 s4aq29 s4aq31 s4aq33) unmatched(master)
		 gen vision=(inlist(s4aq23,3,4)) if s4aq23!=.
		 gen hearing=(inlist(s4aq25,3,4)) if s4aq25!=.
		 gen mobility=(inlist(s4aq27,3,4)) if inrange(s4aq27,1,4)
		 gen communication=(inlist(s4aq29,3,4)) if inrange(s4aq29,1,4)
		 gen selfcare=(inlist(s4aq31,3,4)) if inrange(s4aq31,1,4)
		 gen cognition=(inlist(s4aq33,3,4)) if inrange(s4aq33,1,4)
		 gen disability=(vision==1|hearing==1|mobility==1|communication==1|selfcare==1|cognition==1)
		 replace disability=. if vision==. & hearing==. & mobility==. & communication==. & selfcare==. & cognition==.
		 drop s4aq23-cognition
*/		 
	  //education (For all household members 3 years and above)	 
	     mmerge hhid pid using "$original\Round 0\HH\gsec4", ukeep(s4q04 s4q05 s4q07) unmatched(master)
	     gen literacy=(s4q04==4) 
		 gen educ=. 
		 recode educ (.=0) if s4q05==1 | inrange(s4q07,10,15) | s4q07==98
		 recode educ (.=1) if inrange(s4q07,16,23)
	     recode educ (.=2) if inrange(s4q07,31,36)
		 recode educ (.=3) if inrange(s4q07,41,61)
	     recode educ (.=0)
		 
	  //work (For all household members 10 years and above)
	     mmerge hhid pid using "$original\Round 0\HH\gsec8", ukeep(s8q04 s8q12 s8q06 s8q08 s8q10)
         gen work=(s8q04==1|s8q12==1|s8q06==1|s8q08==1 |s8q10==1)
	  
		rename pid indiv
** DROP HOUSEHOLDS WITH INCOMPLETE INTERVIEWS
    *  drop if inlist(hhid,99002,159067,249203,270008)	  

** KEEP ONLY MEMBERS
      drop if inrange(h2q7,3,5)
	  drop h2q7
	  
** DROP UNNECESSARY VARIABLES
      keep hhid-religion literacy educ work
	  

** SAVE INTERMEDIATE FILE 
      isid hhid indiv
      sort hhid indiv
      save "$intermed\Round0_ind.dta", replace
	  
********************************************************************************
**                               ROUND 1                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 1\SEC1", clear 
	  mmerge HHID using "$intermed\Round1_hh.dta", ukeep(hhid)
		keep if _m==3
	  mmerge HHID using "$original\Round 1\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r1) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information	  
		 //fixing demographic
			recode s1q05 (.=1) if HHID==427202012301 & pid_ubos==11	  
			recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==204102041403 & pid_ubos==1
			recode s1q07 (2=1) if HHID==107302030302 & pid_ubos==2
			recode s1q07 (2=1) if HHID==415105020407 & pid_ubos==1
			recode s1q07 (3=1) if HHID==405302030501 & pid_ubos==1
			recode s1q07 (3=1) if HHID==116102020201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==204301031201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==302204050806 & pid_ubos==6
			recode s1q07 (2=1) if HHID==222111020201 & pid_ubos==2
			recode s1q07 (3=1) if HHID==319105030201 & pid_ubos==1
			recode s1q07 (3=1) if HHID==329106020901 & pid_ubos==1
			recode s1q07 (2=1) if HHID==321107061303 & pid_ubos==1
			recode s1q07 (3=1) if HHID==225103040601 & pid_ubos==1
			recode s1q07 (3=1) if HHID==124103020804 & pid_ubos==4
			recode s1q07 (3=1) if HHID==223120021008 & pid_ubos==1
			recode s1q07 (2=1) if HHID==406212010703 & pid_ubos==1
			recode s1q07 (2=1) if HHID==117302062702 & pid_ubos==2
			recode s1q07 (3=1) if HHID==312105021606 & pid_ubos==1
			recode s1q07 (3=1) if HHID==208107130107 & pid_ubos==2
			recode s1q07 (3=1) if HHID==402210031401 & pid_ubos==1
			recode s1q07 (3=1) if HHID==408102011203 & pid_ubos==2
			recode s1q07 (2=1) if HHID==215109021807 & pid_ubos==2
			recode s1q07 (3=1) if HHID==415106081307 & pid_ubos==1
			recode s1q07 (3=1) if HHID==221109050503 & pid_ubos==1
			recode s1q07 (3=1) if HHID==204102041404 & pid_ubos==11
			recode s1q07 (7=1) if HHID==104208040101 & pid_ubos==1
			recode s1q07 (2=1) if HHID==402208010401 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (3=1) if HHID==204101031305 & pid_ubos==5
			recode s1q07 (3=1) if HHID==402201040901 & pid_ubos==1		
			recode s1q03 (.=1) if HHID==117106050606 & pid_ubos==4
	     gen member_r1=(s1q02==1|s1q03==1)
		 gen sex_r1=s1q02
		 gen age_r1=s1q06
	     gen head_r1=(s1q07==1)
	     gen relation_r1=s1q07 
		 label copy s1q07 relation_r1
		 label val relation_r1 relation_r1
		 		 
	  //respondent		 	     
	     gen respond_r1=(pid_ubos==Rq09) if Rq09!=.
		 
		 rename pid_ubos indiv
		 
** DROP UNNECESSARY VARIABLES		 
      keep hhid indiv member_r1 sex_r1 age_r1 head_r1 relation_r1 respond_r1
	  drop if indiv==.
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r1) unmatched(master)
	     collapse (max) head_r1, by(hhid complete_r1)
		 assert head_r1==1 if complete_r1==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r1, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r1 complete_r1) unmatched(master)
		 assert member_r1==hhsize_r1 if complete_r1==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv
      sort hhid indiv
	  
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid) 
	  keep if _m==3
      save "$intermed\Round1_ind.dta", replace	
	  

********************************************************************************
**                               ROUND 2                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 2\SEC1", clear 
	  rename hhid HHID
	  mmerge HHID using "$intermed\Round2_hh.dta", ukeep(hhid)
		keep if _m==3
	  
	  mmerge HHID using "$original\Round 2\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r2) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
         //fixing demographic information
			recode s1q05 (.=1) if HHID==102102080602 & pid_ubos==5   //from Round 4
		    recode s1q05 (.=2) if HHID==102103037601 & pid_ubos==2   //from Round 0
			recode s1q05 (.=1) if HHID==113502011801 & pid_ubos==4   //from Round 0
			recode s1q05 (.=2) if HHID==113604011001 & pid_ubos==5   //from Round 4
			recode s1q05 (.=2) if HHID==117201050102 & pid_ubos==3    //from Round 0			   
			recode s1q05 (.=2) if HHID==203107062301 & pid_ubos==3    //from Round 4
			recode s1q05 (.=1) if HHID==203107062301 & pid_ubos==10   //from Round 4
			recode s1q05 (.=1) if HHID==208201020101 & pid_ubos==5   //from Round 0
			recode s1q05 (.=2) if HHID==208202080204 & pid_ubos==8   //from Round 4
			recode s1q05 (.=2) if HHID==214102021103 & pid_ubos==11  //from Round 4
			recode s1q05 (.=2) if HHID==215120020401 & pid_ubos==5  //from Round 4
			recode s1q05 (.=1) if HHID==219103120404 & pid_ubos==6  //from Round 4
			recode s1q05 (.=1) if HHID==222111020201 & pid_ubos==1  //from Round 4
			recode s1q05 (.=2) if HHID==223108100601 & pid_ubos==4  //from Round 4
			recode s1q05 (.=2) if HHID==226105050502 & pid_ubos==14 //from Round 4
			recode s1q05 (.=2) if HHID==230105010403 & pid_ubos==8 //from Round 4
			recode s1q05 (.=2) if HHID==230105010409 & pid_ubos==15  //from Round 4
			recode s1q05 (.=2) if HHID==230105040607 & pid_ubos==7   //from Round 4
			recode s1q05 (.=1) if HHID==232202031201 & pid_ubos==13 //from Round 4
			recode s1q05 (.=2) if HHID==232203040203 & pid_ubos==2  //from Round 0
			recode s1q05 (.=2) if HHID==304102010704 & pid_ubos==3 //from Round 0
			recode s1q05 (.=2) if HHID==307105040802 & pid_ubos==6  //from Round 4
			recode s1q05 (.=2) if HHID==311103010502 & pid_ubos==4  //from Round 4
			recode s1q05 (.=2) if HHID==317101030301 & pid_ubos==2  //from Round 4
			recode s1q05 (.=2) if HHID==317107051003 & pid_ubos==8  //from Round 0
			recode s1q05 (.=1) if HHID==319203030904 & pid_ubos==6  //from Round 4
			recode s1q05 (.=2) if HHID==320108070301 & pid_ubos==5 //from Round 4
			recode s1q05 (.=2) if HHID==321107061305 & pid_ubos==7 //from Round 4
			recode s1q05 (.=2) if HHID==325101021501 & pid_ubos==5 //from Round 0
			recode s1q05 (.=1) if HHID==325101021501 & pid_ubos==6 //from Round 0
			recode s1q05 (.=2) if HHID==325101021501 & pid_ubos==7 //from Round 0
			recode s1q05 (.=2) if HHID==403102011401 & pid_ubos==3 //from Round 4
			recode s1q05 (.=2) if HHID==404102030502 & pid_ubos==10  //from Round 4
			recode s1q05 (.=2) if HHID==406108040201 & pid_ubos==3   //from Round 4
			recode s1q05 (.=2) if HHID==406108040203 & pid_ubos==3  //from Round 4
			recode s1q05 (.=1) if HHID==407106020603 & pid_ubos==10 //from Round 4
			recode s1q05 (.=2) if HHID==408112022101 & pid_ubos==3 //from Round 4
			recode s1q05 (.=1) if HHID==410105020502 & pid_ubos==1 //from Round 4
			recode s1q05 (.=1) if HHID==418202010302 & pid_ubos==3  //from Round 4
			recode s1q05 (.=1) if HHID==427202012301 & pid_ubos==11  //from Round 4	
			recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==321107061303 & pid_ubos==1
			recode s1q07 (2=1) if HHID==309103040301 & pid_ubos==2
	     gen member_r2=(s1q02==1|s1q03==1)
		 gen sex_r2=s1q05
		 gen age_r2=s1q06
	     gen head_r2=(s1q07==1)
	     gen relation_r2=s1q07 
		 label copy S1Q07 relation_r2
		 label val relation_r2 relation_r2		 
		 
	  //respondent		 	     
	     gen respond_r2=(pid_ubos==Rq09) if Rq09!=.

		 rename pid_ubos indiv
		 
** DROP UNNECESSARY VARIABLES		 
      keep hhid indiv member_r2 sex_r2 age_r2 head_r2 relation_r2 respond_r2
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r2) unmatched(master)
	     collapse (max) head_r2, by(hhid complete_r2)
		 assert head_r2==1 if complete_r2==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r2, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r2 complete_r2) unmatched(master)
		 assert member_r2==hhsize_r2 if complete_r2==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv
	  sort hhid indiv
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid)
	  keep if _m==3
	  
      save "$intermed\Round2_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 3                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 3\SEC1", clear 
	  mmerge HHID using "$intermed\Round3_hh.dta", ukeep(hhid)
		keep if _m==3
  
	  
	  mmerge HHID using "$original\Round 3\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r3) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     //fixing demographic information
		 	recode s1q07 (2=1) if HHID==113502045601 & pid_ubos==1
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2
		 recode s1q02 s1q03 (1=2) if s1q02a==2
	     gen member_r3=(s1q02==1|s1q03==1)
		 gen sex_r3=s1q05
		 gen age_r3=s1q06
	     gen head_r3=(s1q07==1)
	     gen relation_r3=s1q07
		 label copy s1q07 relation_r3
		 label val relation_r3 relation_r3			 
		 
	  //respondent		 	     
	     gen respond_r3=(pid_ubos==Rq09) if Rq09!=.
		 	
		 rename pid_ubos indiv
			
** DROP UNNECESSARY VARIABLES		 
      keep hhid indiv member_r3 sex_r3 age_r3 head_r3 relation_r3 respond_r3
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r3) unmatched(master)
	     collapse (max) head_r3, by(hhid complete_r3)
		 assert head_r3==1 if complete_r3==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r3, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r3 complete_r3) unmatched(master)
		 assert member_r3==hhsize_r3 if complete_r3==1
		 * assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv
      sort hhid indiv
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid)
	  keep if _m==3
	  
      save "$intermed\Round3_ind.dta", replace
	  
	  
********************************************************************************
**                               ROUND 4                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 4\SEC1", clear 
	  mmerge HHID using "$intermed\Round4_hh.dta", ukeep(hhid)
		keep if _m==3
	  
	  mmerge HHID using "$original\Round 4\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r4) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
	     //fixing demographic information
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2		 
			recode s1q07 (2=1) if HHID==310306040201 & pid_ubos==2
	     recode s1q02 s1q03 (1=2) if s1q02a==2
	     gen member_r4=(s1q02==1|s1q03==1)
		 gen sex_r4=s1q05
		 gen age_r4=s1q06
	     gen head_r4=(s1q07==1)
	     gen relation_r4=s1q07
		 label copy s1q07 relation_r4
		 label val relation_r4 relation_r4			 
		 
	  //respondent		 	     
	     gen respond_r4=(pid_ubos==Rq09) if Rq09!=.

		 rename pid_ubos indiv
		 
** DROP UNNECESSARY VARIABLES		 
      keep hhid indiv member_r4 sex_r4 age_r4 head_r4 relation_r4 respond_r4
	  
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r4) unmatched(master)
	     collapse (max) head_r4, by(hhid complete_r4)
		 assert head_r4==1 if complete_r4==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r4, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r4 complete_r4) unmatched(master)
		 assert member_r4==hhsize_r4 if complete_r4==1
		 * assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      isid hhid indiv

      sort hhid indiv
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid)
	  keep if _m==3
	  
      save "$intermed\Round4_ind.dta", replace	  
	
********************************************************************************
**                               ROUND 5                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 5\SEC1", clear 
	  mmerge HHID using "$intermed\Round5_hh.dta", ukeep(hhid)
		keep if _m==3
	  
	  
	  mmerge HHID using "$original\Round 5\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r5) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
		//fixing demographic information
		    recode s1q02 s1q03 (1=2) if s1q02a==2
			recode s1q05 (.a=2) if HHID==115203060401 & pid_ubos==11
			recode s1q05 (.a=2) if HHID==115206030202 & pid_ubos==10
			recode s1q05 (.a=2) if HHID==323108031103 & pid_ubos==2
			recode s1q05 (.a=1) if HHID==404403030402 & pid_ubos==6
			recode s1q05 (.a=2) if HHID==408113040501 & pid_ubos==6	  
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2		
			recode s1q07 (2=1) if HHID==226102051006 & pid_ubos==2
	     gen member_r5=(s1q02==1|s1q03==1)
		 gen sex_r5=s1q05
		 gen age_r5=s1q06
	     gen head_r5=(s1q07==1)
	     gen relation_r5=s1q07
		 label copy s1q07 relation_r5
		 label val relation_r5 relation_r5			 
		 
	  //respondent		 	     
	     gen respond_r5=(pid_ubos==Rq09) if Rq09!=.
	
		 rename pid_ubos indiv
	
** DROP UNNECESSARY VARIABLES		 
      keep hhid indiv member_r5 sex_r5 age_r5 head_r5 relation_r5 respond_r5
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r5) unmatched(master)
	     collapse (max) head_r5, by(hhid complete_r5)
		 assert head_r5==1 if complete_r5==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r5, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r5 complete_r5) unmatched(master)
		 assert member_r5==hhsize_r5 if complete_r5==1
		 assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
      ** four duplicates
		**2f3a098e58ac41a8b58f0fea74822b1d
			replace indiv=8 if indiv==7 & age_r5==7 & hhid=="2f3a098e58ac41a8b58f0fea74822b1d"
		**d7fef0ab4776477eb5ca1995863949aa
			replace indiv=12 if indiv==4 & age_r5==4 & hhid=="d7fef0ab4776477eb5ca1995863949aa"
			
			
	  isid hhid indiv
		
      sort hhid indiv
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid)
	  keep if _m==3
	  
      save "$intermed\Round5_ind.dta", replace	
	  
********************************************************************************
**                               ROUND 6                                      **
********************************************************************************
** OPEN DATA
      use "$original\Round 6\SEC1", clear 
	  mmerge HHID using "$intermed\Round6_hh.dta", ukeep(hhid)
		keep if _m==3

	  mmerge HHID using "$original\Round 6\interview_result", ukeep(Rq05 Rq09) unmatched(master)
	  *mmerge hhid using "$harmonized\UG_HH.dta", ukeep(complete_r6) unmatched(master)
	  
** GENERATE VARIABLES
	  //demographic information
		 //fixing demographic information
		    recode s1q02 s1q03 (1=2) if s1q02a==2
			recode s1q05 (.a=1) if HHID==211107030806 & pid_ubos==1
			recode s1q05 (.a=2) if HHID==216202030407 & pid_ubos==12
			recode s1q06 (.a=23) if HHID==216202030407 & pid_ubos==12
			recode s1q07 (.a=15) if HHID==216202030407 & pid_ubos==12
			recode s1q05 (.a=1) if HHID==222111020101 & pid_ubos==10		
			recode s1q07 (2=1) if HHID==304204030101 & pid_ubos==2
			recode s1q07 (2=1) if HHID==304102010703 & pid_ubos==2				
	     gen member_r6=(s1q02==1|s1q03==1)
		 gen sex_r6=s1q05
		 gen age_r6=s1q06
	     gen head_r6=(s1q07==1)
	     gen relation_r6=s1q07
		 label copy s1q05 relation_r6
		 label val relation_r6 relation_r6			 
		 
	  //respondent		 	     
	     gen respond_r6=(pid_ubos==Rq09) if Rq09!=.
		 	
		 rename pid_ubos indiv
			
** DROP UNNECESSARY VARIABLES		 
      keep hhid HHID indiv member_r6 sex_r6 age_r6 head_r6 relation_r6 respond_r6
	 
** CHECK HEAD
      preserve
	     mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r6) unmatched(master)
	     collapse (max) head_r6, by(hhid complete_r6 HHID)
		 assert head_r6==1 if complete_r6==1
	  restore	 
	  
** CHECK HOUSEHOLD SIZE
      preserve
	     collapse (sum) member_r6, by(hhid)
		 mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhsize_r6 complete_r6) unmatched(master)
		 assert member_r6==hhsize_r6 if complete_r6==1
		 * assert _m==3
	  restore
	  
** SAVE INTERMEDIATE FILE 
	  
	  **10de89a4467f4695b9cbc4ff047645ad
			replace indiv=6 if indiv==5 & age_r6==19 & hhid=="10de89a4467f4695b9cbc4ff047645ad"
	  
	  **4d77a6468adb430faa1279387ee1a0d8
			replace indiv=9 if indiv==8 & age_r6==3 & hhid=="4d77a6468adb430faa1279387ee1a0d8"
	  
	  **61e47488f7044749b1bb8b9bab6c6cfa
			** perfect duplicate
			duplicates drop if hhid=="61e47488f7044749b1bb8b9bab6c6cfa" & indiv==11
	  
	  **d85364f667764e2b8cb3582793802ba6
			replace indiv=18 if indiv==12 & age_r6==6 & hhid=="d85364f667764e2b8cb3582793802ba6"
			replace indiv=19 if indiv==12 & age_r6==28 & hhid=="d85364f667764e2b8cb3582793802ba6"	  
			
	  isid hhid indiv

      sort hhid indiv
	  
	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid)
	  keep if _m==3
	  
      save "$intermed\Round6_ind.dta", replace		  
	  
********************************************************************************	  
** MERGING THE FILES 
      use "$intermed\Round0_ind.dta", clear  
	  forvalues i=1/$round {
	  	 mmerge hhid indiv using "$intermed\Round`i'_ind.dta"
	  }
	  
	        bysort hhid indiv: assert _n==1

	  mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(complete_r*) unmatched(master)	  
	  forvalues i=1/$round {	  
		 replace member_r`i'=. if complete_r`i'!=1
	     replace head_r`i'=. if complete_r`i'!=1
		 replace relation_r`i'=. if complete_r`i'!=1
		 *replace relation_os_r`i'="" if complete_r`i'!=1	  	
	  }

** MERGE WITH HOUSEHOLD LEVEL FILES
      mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(contact_r* interview_r* head_chg_r* respond_chg_r*)
		keep if _m==3
** UPDATE SEX AND AGE INFORMATION
      gen age_p=.
      forvalues i=1/$round {
	  	replace sex=sex_r`i' if sex==.
		replace age_p=age_r`i' if age_r`i'!=.
	  }
 	  drop sex_r* age_r* _m
	  
	  recode sex age_p relation_r*(.a=.)
	  
** MISSING VARIABLES
	gen disability=.
	gen relation_os_r1=""
	gen relation_os_r2=""
	gen relation_os_r3=""
	gen relation_os_r4=""
	gen relation_os_r5=""
	gen relation_os_r6=""
	
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
	
	** NEED TO TAKE A DECISION REGARDING THE IDS, WE HAVE TWO OPTIONS
		*A) use t0_ubos_pid (from UNPS 2019) in this scenario we will not have information about new HH members
		*B) use pid_ubos (from phone survey) we cannot merge it to UNPS 2019
		
	/*	
	  assert member_r0==1 if indiv<100
	  assert member_r0==0 if indiv>=100
	  assert member_r1==0 if indiv>=200 & complete_r1==1
	  assert member_r2==0 if indiv>=300 & complete_r2==1
	  assert member_r3==0 if indiv>=400	& complete_r3==1 
	  assert member_r4==0 if indiv>=500	& complete_r4==1
	  assert member_r5==0 if indiv>=600	& complete_r5==1
	  assert member_r6==0 if indiv>=700	& complete_r6==1
	  
	  assert indiv>=100 if member_r0==0
	  assert inrange(indiv,100,200) if member_r1==1 & member_r0==0
	  assert indiv>=200 if member_r1==0 & member_r0==0 
	  assert indiv>=300 if member_r2==0 & member_r1==0 & member_r0==0
	  assert indiv>=400 if member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0	
	  assert indiv>=500 if member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
      assert indiv>=600 if member_r5==0 & member_r4==0 & member_r3==0 & member_r2==0 & member_r1==0 & member_r0==0
	
	*/
** DROP UNNECESSARY VARIABLES
      drop contact_r* interview_r* head_chg_r* respond_chg_r* complete_r* HHID
	  
** LABEL VARIABLES & VALUES
      run "$dofiles\ind_label.do"
	  
** CHECK FOR DUPLICATES
      bysort hhid indiv: assert _n==1
	 /* There are 20 HHs without individual information in UNPS 2019
	 preserve
	     collapse (count) indiv, by(hhid)
		 assert _N==$totalHH
	  restore
	  */
	  isid hhid indiv
	
** LABEL DATA 
      label data "Uganda COVID-19 - Harmonized Dataset (Individual Level)"
      label var hhid "Household ID"
	  rename indiv pid
      label var pid "Individual ID"
	  	  
** ORDER VARIABLES
      order hhid pid sex age age_p married form_married nev_married disability religion literacy educ work ///
            member_r0 head_r0 relation_r0 relation_os_r0 ///
            member_r1 head_r1 respond_r1 relation_r1  relation_os_r1 ///
            member_r2 head_r2 respond_r2 relation_r2  relation_os_r2  ///
            member_r3 head_r3 respond_r3 relation_r3  relation_os_r3  ///
			member_r4 head_r4 respond_r4 relation_r4  relation_os_r4  ///
            member_r5 head_r5 respond_r5 relation_r5  relation_os_r5  ///
			member_r6 head_r6 respond_r6 relation_r6  relation_os_r6 
			
** CHECKING IND FILE WILL MERGE WITH HH FILE
 	 /*There are 20 HHs without individual information in UNPS 2019
   
	 preserve
         mmerge hhid using "$harmonized\UGA_HH.dta", ukeep(hhid phone_sample)
		 assert _m==3
	  restore	 
	  */
  
** SAVE FILE  
      isid hhid pid
      sort hhid pid
	  compress
      saveold "$harmonized\UGA_IND.dta", replace
	   