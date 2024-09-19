*************************************************************************
**                COVID-19 Phone Survey Harmonized Data Project        **
**                                                                     **
**  Program Name:  hh_label.do				    		               **
**                                                                     **
**  Input Data Sets:                                                   **
**		None					    							       **
**                                                                     **
**  Output Data Set:                                                   **
**		None								        			       **
**                                                                     **
**  Description: Labels variables and values in household level files  **
**                                                                     **
**  Program first written: September 10, 2020                          **
**                                                                     **
*************************************************************************


** LABEL VARIABLES 
      label var year "Survey year (Round 0)"
      label var rural "Rural/Urban"
      label var ea_latitude "EA Latitude (Modified)"
      label var ea_longitude "EA Longitude (Modified)"
	  label var phone_sample "Phone sample"
      label var dwelling "Ownership of dwelling"
      label var roof "Modern roof"
      label var floor "Modern floor"
      label var walls "Modern exterior walls"
      label var toilet "Access to improved toilet"
      label var water "Access to improved water source"
      label var rooms "Number of rooms"
      label var elect "Connection to electricity"
      label var tv "Ownership of television"
      label var radio "Ownership of radio"
      label var refrigerator "Ownership of refrigerator"
      label var bicycle "Ownership of bicycle"
      label var mcycle "Ownership of motorcycle"
      label var car "Ownership of car or other vehicle"
      label var mphone "Ownership of mobile phone"
      label var computer "Ownership of computer"
      label var internet "Access to Internet"
      label var generator "Ownership of generator"
      label var land "Ownership of land"
      label var land_tot "Total land size owned (ha)"
	  label var land_cultivated	"Total land size cultivated (ha)"
      label var cons_quint "Consumption quintile"
      label var totcons "Total annual per capita consumption"
      label var foodcons "Total annual per capita food consumption"
      label var nonfoodcons "Total annual per capita non-food consumption"
      label var totcons_adj "Total per capita consumption, spatially and temporally adjusted"
      label var foodcons_adj "Total annual per capita food consumption, spatially and temporally adjusted"
      label var nonfoodcons_adj "Total annual per capita non-food consumption, spatially and temporally adjusted"
      label var rent "Rental income"
      label var remit "Received remittance"
      label var assist "Received assistance"
      label var finance "Account from financial institutions"
      label var any_work "% of working adults working"
      label var ag_work "% of working adults working in agriculture"
      label var nfe_work "% of working adults working in non-farm family enterprise"
      label var ext_work "% of working adults working in wage work"
      label var nfe "Ownership of non-farm family enterprise"
      label var crop "Crop cultivation"
      label var crop_number "Number of crops cultivated"
      label var cash_crop "Cash crop cultivation"
      label var org_fert "Use of organic fertilizer"
      label var inorg_fert "Use of inorganic fertilizer"
      label var pest_fung_herb "Use of pesticides, fungicides or herbicides"
      label var hired_lab "Use of hired labor"
      label var ex_fr_lab "Use of exchange and/or free labor"	  
      label var hired_lab_ph "Use of hired labor for post-harvest activities"
      label var ex_fr_lab_ph "Use of exchange and/or free labor for post-harvest activities"
      label var tractor	"Use of tractor"
      label var sell_crop "Sale of crop"
	  label var sell_process "Sale of processed crop"
	  label var sell_unprocess "Sale of unprocessed crop"
      label var ph_loss "Postharvest crop loss"	  
      label var livestock "Ownership of livestock"
      label var lruminant "Ownership of large ruminant"
      label var sruminant "Ownership of small ruminant"
      label var poultry "Ownership of poultry"
      label var equines "Ownership of equine"
      label var camelids "Ownership of camelid"
      label var pig "Ownership of pig"
      label var bee "Ownership of bee colonies"
	  
	  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	 
            label var hhsize_r`i' "Household size (Round `i')"	  	
            label var m0_14_r`i' "Number of males aged 0 to 14 (Round `i')"
            label var m15_64_r`i' "Number of males aged 15 to 64 (Round `i')"
            label var m65_r`i' "Number of males aged 65 and above (Round `i')"
            label var f0_14_r`i' "Number of females aged 0 to 14 (Round `i')"
            label var f15_64_r`i' "Number of females aged 15 to 64 (Round `i')"
            label var f65_r`i' "Number of females aged 65 and above (Round `i')"	     	
            label var adulteq_r`i' "Adult equivalence (Round `i')"		
            label var wt_r`i' "Cross section household weight (Round `i')"		 
	     }		 	
	  }	
			
			
      if inlist("$country","Nigeria","Uganda","Ethiopia") {				
	     forvalues i=0/$round {
            label var hhsize_r`i' "Household size (Round `i')"	  	
            label var m0_14_r`i' "Number of males aged 0 to 14 (Round `i')"
            label var m15_64_r`i' "Number of males aged 15 to 64 (Round `i')"
            label var m65_r`i' "Number of males aged 65 and above (Round `i')"
            label var f0_14_r`i' "Number of females aged 0 to 14 (Round `i')"
            label var f15_64_r`i' "Number of females aged 15 to 64 (Round `i')"
            label var f65_r`i' "Number of females aged 65 and above (Round `i')"	     	
            label var adulteq_r`i' "Adult equivalence (Round `i')"		
            label var wt_r`i' "Cross section household weight (Round `i')"		 
	     }		 	
	  }	

      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	
		    label var contact_r`i'	"Successfully contacted (Round `i')"  	
            label var interview_r`i' "Interviewed (Round `i')"
		    label var complete_r`i'  "Interview completed (Round `i')"
            label var head_chg_r`i' "Household head changed (Round `i')"
         }
	  }
	  
      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
	     forvalues i=1/$round {
		    label var contact_r`i'	"Successfully contacted (Round `i')"  	
            label var interview_r`i' "Interviewed (Round `i')"
		    label var complete_r`i'  "Interview completed (Round `i')"
            label var head_chg_r`i' "Household head changed (Round `i')"
         }
	  }

      if "$country" =="Malawi" {
	     foreach i in 2 3 4 5 6 7 8 9 11 12 {	
		    label var respond_chg_r`i' "Respondent changed (Round `i')"	
		 }
	  }	 

      if inlist("$country","Nigeria","Uganda","Ethiopia") {	  
	     forvalues i=2/$round {	  
            label var respond_chg_r`i' "Respondent changed (Round `i')"
	     }  
	  }

      if "$country" =="Malawi" {
	     foreach i in 3 4 5 6 7 8 9 11 12 {	
            * label var wt_panel_r`i' "Panel household weight (Round `i')"
	     }  		 	
	  }	
	
      if inlist("$country","Nigeria","Uganda","Ethiopia") {	  	
	     forvalues i=3/$round {	  
            label var wt_panel_r`i' "Panel household weight (Round `i')"
	     }  
	  }
	  
	  foreach i in $fies {
	     label var fies_mod_r`i' "Probability of being moderately/severely food insecure >= 50% (Round `i')"
         label var fies_sev_r`i' "Probability of being severely food insecure >= 50% (Round `i')"	      
	  }
	  
** LABEL VALUES 
      //Rural/Urban 
	     label define rural 1 "RURAL" 2 "URBAN"
		 label val rural rural
	  
	  //Consumption quintile
	     label define cons_quint 1 "POOREST" 2 "POORER" 3 "MIDDLE" 4 "RICHER" 5 "RICHEST"
		 label val cons_quint cons_quint

      //YES/NO
	     label define YN 0 "NO" 1 "YES"
		 label val phone_sample dwelling roof floor walls toilet water elect tv radio refrigerator bicycle mcycle car mphone computer internet generator land ///
		       rent remit assist finance nfe crop cash_crop org_fert inorg_fer pest_fung_herb hired_lab ex_fr_lab tractor ///
			   sell_crop sell_process sell_unprocess ph_loss hired_lab_ph ex_fr_lab_ph fies_mod* fies_sev* ///
			   livestock lruminant sruminant poultry equines camelids pig bee contact* interview* complete* head_chg* respond_chg* YN
		 
	  //NUMLABELS
	     numlabel, add