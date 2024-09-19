*************************************************************************
**                COVID-19 Phone Survey Harmonized Data Project        **
**                                                                     **
**  Program Name:  ind_label.do				    		               **
**                                                                     **
**  Input Data Sets:                                                   **
**		None					    							       **
**                                                                     **
**  Output Data Set:                                                   **
**		None								        			       **
**                                                                     **
**  Description: Labels variables and values in individual level files **
**                                                                     **
**  Program first written: September 10, 2020                          **
**                                                                     **
*************************************************************************

** LABEL VARIABLES 
      label var sex "Sex"
      label var age "Age (Round 0)"
	  label var age_p "Age (Round 1+)"
      label var married "Currently married"
	  label var form_married "Formerly married"
	  label var nev_married "Never married"
	  label var disability "With disability"
      label var literacy "Literacy"
      label var religion "Religion"
      label var educ "Highest level of education completed"
      label var work "Working status"

	  
      if "$country" =="Malawi" {
	     foreach i in 0 1 2 3 4 5 6 7 8 9 11 12 {	
            label var member_r`i' "Member of household (Round `i')"	 	  	
            label var head_r`i' "Head of household (Round `i')"
            label var relation_r`i' "Relationship to head of household (Round `i')"
            label var relation_os_r`i' "Other relationship to head of household (Round `i')"		 
	     }	  
	  }
	  
      if inlist("$country","Nigeria","Uganda","Ethiopia") {					
	     forvalues i=0/$round {
            label var member_r`i' "Member of household (Round `i')"	 	  	
            label var head_r`i' "Head of household (Round `i')"
            label var relation_r`i' "Relationship to head of household (Round `i')"
            label var relation_os_r`i' "Other relationship to head of household (Round `i')"		 
	     }	  
	  }

      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {
            label var respond_r`i' "Respondent (Round `i')"	  	
	     }	  	  
	  }
	  
      if inlist("$country","Nigeria","Uganda","Ethiopia") {
	     forvalues i=1/$round {	
            label var respond_r`i' "Respondent (Round `i')"	  	
	     }	  	  
	  }
	  
** LABEL VALUES 	  
      //YES/NO
		 label val literacy married form_married nev_married disability work member* head* respond* YN

      //Sex
	     label define sex 1 "MALE" 2 "FEMALE"
		 label val sex sex 
		 
      //Religion
	     label define religion 1 "CHRISTIANITY" 2 "ISLAM" 3 "OTHER"
		 label val religion religion
		 
      //Highest level of education
	     label define educ 0 "NONE" 1 "PRIMARY" 2 "SECONDARY" 3 "TERTIARY"
		 label val educ educ
		 		 
	  //NUMLABELS
	     numlabel, add				 