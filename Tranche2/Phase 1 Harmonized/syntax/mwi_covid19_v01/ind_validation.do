******************************************************************
**               COVID-19 Harmonized Data Project               **
**                                                              **
**  Program Name:  ind_validation.do				            **
**                                                              **
**  Input Data Sets:                                            **
**		None					    							**
**                                                              **
**  Output Data Set:                                            **
**		None								        			**
**                                                              **
**  Description: Validates variables in individual level files  **
**                                                              **
**  Program first written: September 10, 2020                   **
**                                                              **
******************************************************************

** VALIDATING 
      assert inlist(sex,1,2,.)
	  assert age!=.a
	  assert age_p!=.a
      assert inlist(married,1,0,.)
	  assert inlist(form_married,1,0,.)
	  assert inlist(nev_married,1,0,.)
	  assert inlist(disability,1,0,.)
	  assert inlist(literacy,1,0,.)
	  assert inlist(religion,1,2,3,.)
	  assert inlist(educ,0,1,2,3,.)
	  assert inlist(work,1,0,.)
	  
      if "$country" =="Malawi" {
	     foreach i in 0 1 2 3 4 5 6 7 8 9 11 12 {	
	        assert inlist(member_r`i',1,0,.)	
		    assert inlist(head_r`i',1,0,.)	
		    assert relation_r`i'!=.a 
		 }
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
         forvalues i=0/$round {
	        assert inlist(member_r`i',1,0,.)	
		    assert inlist(head_r`i',1,0,.)	
		    assert relation_r`i'!=.a 
		 }
	  }
	  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 11 12 {	
	        assert inlist(respond_r`i',1,0,.)	
		    assert inlist(respond_r`i',1,0) if interview_r`i'==1
		    assert inlist(member_r`i',1,0)	if complete_r`i'==1
		    assert inlist(head_r`i',1,0) if complete_r`i'==1
		    * assert relation_r`i'!=. if complete_r`i'==1 & member_r`i'==1
		    assert head_r`i'==1 if relation_r`i'==1
		    assert head_r`i'!=1 if relation_r`i'!=1
		    assert respond_r`i'==. if interview_r`i'==0		 
		    assert member_r`i'==. & head_r`i'==. & relation_r`i'==. if complete_r`i'==0
		 }
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
         forvalues i=1/$round {
	        assert inlist(respond_r`i',1,0,.)	
		    assert inlist(respond_r`i',1,0) if interview_r`i'==1
		    assert inlist(member_r`i',1,0)	if complete_r`i'==1
		    assert inlist(head_r`i',1,0) if complete_r`i'==1
		    * assert relation_r`i'!=. if complete_r`i'==1 & member_r`i'==1
		    assert head_r`i'==1 if relation_r`i'==1
		    assert head_r`i'!=1 if relation_r`i'!=1
		    assert respond_r`i'==. if interview_r`i'==0		 
		    assert member_r`i'==. & head_r`i'==. & relation_r`i'==. if complete_r`i'==0
		 }
	  }
	  
      if "$country" =="Malawi" {
	     foreach i in 1 2 3 4 5 6 7 8 9 12 {	
	  	    loc ii=`i'-1
            assert head_r`i'==0 if head_chg_r`i'==1 & head_r`ii'==1
         }
            assert head_r11==0 if head_chg_r11==1 & head_r9==1		 
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
	     forvalues i=1/$round {
	  	    loc ii=`i'-1
            assert head_r`i'==0 if head_chg_r`i'==1 & head_r`ii'==1
         }
	  }
	  
      if "$country" =="Malawi" {
	     foreach i in 2 3 4 5 6 7 8 9 12 {	
	  	    loc ii=`i'-1
            assert respond_r`i'==0 if respond_chg_r`i'==1 & respond_r`ii'==1
         }	
		 assert respond_r11==0 if respond_chg_r11==1 & respond_r9==1
	  }

      if inlist("$country","Nigeria","Uganda","Ethiopia") {		  
	     forvalues i=2/$round {
	  	    loc ii=`i'-1
            assert respond_r`i'==0 if respond_chg_r`i'==1 & respond_r`ii'==1
         }	  
	  }
	  
	  assert age==. if member_r0==0
	  