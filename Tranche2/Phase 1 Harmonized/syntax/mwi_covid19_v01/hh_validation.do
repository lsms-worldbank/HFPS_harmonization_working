******************************************************************
**               COVID-19 Harmonized Data Project               **
**                                                              **
**  Program Name:  hh_validation.do					            **
**                                                              **
**  Input Data Sets:                                            **
**		None					    							**
**                                                              **
**  Output Data Set:                                            **
**		None								        			**
**                                                              **
**  Description: Validates variables in household level files   **
**                                                              **
**  Program first written: September 10, 2020                   **
**                                                              **
******************************************************************

** VALIDATING 
      assert inlist(dwelling,1,0,.)
      assert inlist(roof,1,0,.)
      assert inlist(floor,1,0,.)
      assert inlist(walls,1,0,.)
      assert inlist(toilet,1,0,.)
      assert inlist(water,1,0,.)
      assert inlist(elect,1,0,.)
      assert inlist(tv,1,0,.)
      assert inlist(radio,1,0,.)
      assert inlist(refrigerator,1,0,.)
      assert inlist(bicycle,1,0,.)
      assert inlist(mcycle,1,0,.)
      assert inlist(car,1,0,.)
      assert inlist(mphone,1,0,.)
      assert inlist(computer,1,0,.)
      assert inlist(internet,1,0,.)
      assert inlist(generator,1,0,.)
      assert inlist(land,1,0,.)	  
	  assert land_tot!=.a 
      assert inlist(crop,1,0,.)	  
	  assert land_cultivated!=.a 
	  assert crop_number!=.a 
	  assert crop_number==. if inlist(crop,0,.)
	  assert inlist(cash_crop,1,0,.) 
	  assert cash_crop==. if inlist(crop,0,.)
	  assert inlist(org_fert,1,0,.) 
	  assert org_fert==. if inlist(crop,0,.)
	  assert inlist(inorg_fert,1,0,.) 
	  assert inorg_fert==. if inlist(crop,0,.)
	  assert inlist(pest_fung_herb,1,0,.) 
	  assert pest_fung_herb==. if inlist(crop,0,.)
	  assert inlist(hired_lab,1,0,.) 
	  assert hired_lab==. if inlist(crop,0,.)
	  assert inlist(ex_fr_lab,1,0,.) 
	  assert ex_fr_lab==. if inlist(crop,0,.)
	  assert inlist(hired_lab_ph,1,0,.) 
	  assert hired_lab_ph==. if inlist(crop,0,.)
	  assert inlist(ex_fr_lab_ph,1,0,.) 
	  assert ex_fr_lab_ph==. if inlist(crop,0,.)	  
	  assert inlist(tractor,1,0,.) 
	  assert tractor==. if inlist(crop,0,.)   
	  assert inlist(sell_crop,1,0,.) 
	  assert sell_crop==. if inlist(crop,0,.)
	  assert inlist(sell_process,1,0,.) 
	  assert sell_process==. if inlist(crop,0,.)	  
	  assert inlist(sell_unprocess,1,0,.) 
	  assert sell_unprocess==. if inlist(crop,0,.)	
	  assert inlist(sell_crop,0,.) if sell_process==0 & sell_unprocess==0
	  assert inlist(ph_loss,1,0,.) 
      assert ph_loss==. if inlist(crop,0,.)	  
	  assert land_tot==0 if land==0
	  assert land_cultivated==0 if crop==0		  
      assert inlist(rent,1,0,.)
      assert inlist(remit,1,0,.)
      assert inlist(assist,1,0,.)
      assert inlist(finance,1,0,.)
      assert inlist(nfe,1,0,.)
      assert inlist(livestock,1,0,.)
      assert inlist(lruminant,1,0,.)
      assert inlist(sruminant,1,0,.)
      assert inlist(poultry,1,0,.)
      assert inlist(equines,1,0,.)
      assert inlist(camelids,1,0,.)
      assert inlist(pig,1,0,.)
      assert inlist(bee,1,0,.)
      assert inlist(rural,1,2,.)
	  assert inlist(cons_quint,1,2,3,4,5,.) 
	  assert inlist(phone_sample,1,0)
  
  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	  
	  	    assert inlist(contact_r`i',1,0,.)
	  	    assert inlist(interview_r`i',1,0,.)
		    assert inlist(complete_r`i',1,0,.)
            assert inlist(head_chg_r`i',1,0,.)
		    assert head_chg_r`i'!=. if complete_r`i'==1
		    assert head_chg_r`i'==. if complete_r`i'==0
		    assert contact_r`i'==. if phone_sample==0
		    assert interview_r`i'==. if phone_sample==0
		    assert interview_r`i'==. if contact_r`i'!=1
		    assert complete_r`i'==. if interview_r`i'!=1
		    assert contact_r`i'==1 if inlist(interview_r`i',1,0)
		    assert interview_r`i'==1 if inlist(complete_r`i',1,0)
	     } 	  			
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {	  
	     forvalues i=1/$round {	  
	  	    assert inlist(contact_r`i',1,0,.)
	  	    assert inlist(interview_r`i',1,0,.)
		    assert inlist(complete_r`i',1,0,.)
            assert inlist(head_chg_r`i',1,0,.)
		    assert head_chg_r`i'!=. if complete_r`i'==1
		    assert head_chg_r`i'==. if complete_r`i'==0
		    assert contact_r`i'==. if phone_sample==0
		    assert interview_r`i'==. if phone_sample==0
		    assert interview_r`i'==. if contact_r`i'!=1
		    assert complete_r`i'==. if interview_r`i'!=1
		    assert contact_r`i'==1 if inlist(interview_r`i',1,0)
		    assert interview_r`i'==1 if inlist(complete_r`i',1,0)
	     } 
	  } 
	  
	  foreach i in $fies {
	     assert inlist(fies_mod_r`i',0,1,.)
         assert inlist(fies_sev_r`i',0,1,.)	      
	  }	  	  
	  
	  
      if "$country" =="Malawi" {
	     foreach i in 2 3 4 5 6 7 8 9 11 12 {
            assert inlist(respond_chg_r`i',1,0,.) 
		    assert respond_chg_r`i'==. if contact_r`i'==0
		    assert respond_chg_r`i'==. if interview_r`i'==0
	     } 	 
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
 	     forvalues i=2/$round {	  
            assert inlist(respond_chg_r`i',1,0,.) 
		    assert respond_chg_r`i'==. if contact_r`i'==0
		    assert respond_chg_r`i'==. if interview_r`i'==0
		 }	
	  } 	 	  
	  
      assert livestock==1 if lruminant==1|sruminant==1|poultry==1|equines==1|camelids==1|pig==1|bee==1
      assert livestock==0 if !(lruminant==1|sruminant==1|poultry==1|equines==1|camelids==1|pig==1|bee==1)
	  assert totcons==foodcons+nonfoodcons
	  assert totcons_adj==foodcons_adj+nonfoodcons_adj if foodcons_adj!=. & nonfoodcons_adj!=.
	  
	  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	  
            assert hhsize_r`i'==m0_14_r`i'+m15_64_r`i'+m65_r`i'+f0_14_r`i'+f15_64_r`i'+f65_r`i'
            assert wt_r0!=.
	     }	 	
	  }  	  

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
	     forvalues i=0/$round {	  
            assert hhsize_r`i'==m0_14_r`i'+m15_64_r`i'+m65_r`i'+f0_14_r`i'+f15_64_r`i'+f65_r`i'
            assert wt_r0!=.
		 }	
	  }  
	  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	  
		    assert wt_r`i'!=. if complete_r`i'==1	     
		    assert hhsize_r`i'!=. if complete_r`i'==1
		    assert m0_14_r`i'!=. if complete_r`i'==1
		    assert m15_64_r`i'!=. if complete_r`i'==1
		    assert m65_r`i'!=. if complete_r`i'==1
		    assert f0_14_r`i'!=. if complete_r`i'==1
		    assert f15_64_r`i'!=. if complete_r`i'==1
		    assert f65_r`i'!=. if complete_r`i'==1
		    assert adulteq_r`i'!=. if complete_r`i'==1
		    assert wt_r`i'==. if complete_r`i'==0		 
		    assert hhsize_r`i'==. if complete_r`i'==0
		    assert m0_14_r`i'==. if complete_r`i'==0
		    assert m15_64_r`i'==. if complete_r`i'==0
		    assert m65_r`i'==. if complete_r`i'==0
		    assert f0_14_r`i'==. if complete_r`i'==0
		    assert f15_64_r`i'==. if complete_r`i'==0
		    assert f65_r`i'==. if complete_r`i'==0
		    assert adulteq_r`i'==. if complete_r`i'==0	
	     }		
	  }		 	
			
      if inlist("$country","Nigeria","Uganda","Ethiopia") {					
	     forvalues i=1/$round {
		    assert wt_r`i'!=. if complete_r`i'==1	     
		    assert hhsize_r`i'!=. if complete_r`i'==1
		    assert m0_14_r`i'!=. if complete_r`i'==1
		    assert m15_64_r`i'!=. if complete_r`i'==1
		    assert m65_r`i'!=. if complete_r`i'==1
		    assert f0_14_r`i'!=. if complete_r`i'==1
		    assert f15_64_r`i'!=. if complete_r`i'==1
		    assert f65_r`i'!=. if complete_r`i'==1
		    assert adulteq_r`i'!=. if complete_r`i'==1
		    * assert wt_r`i'==. if complete_r`i'==0		 
		    assert hhsize_r`i'==. if complete_r`i'==0
		    assert m0_14_r`i'==. if complete_r`i'==0
		    assert m15_64_r`i'==. if complete_r`i'==0
		    assert m65_r`i'==. if complete_r`i'==0
		    assert f0_14_r`i'==. if complete_r`i'==0
		    assert f15_64_r`i'==. if complete_r`i'==0
		    assert f65_r`i'==. if complete_r`i'==0
		    assert adulteq_r`i'==. if complete_r`i'==0	
	     }		
	  }		
