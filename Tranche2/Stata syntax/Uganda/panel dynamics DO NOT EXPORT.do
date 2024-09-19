

	*	panel dynamics

	loc inventory=0
	if `inventory'==1	{	/*	data inventory	*/
	d using "${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14/HH/gsec1.dta"				
	d using "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta"				
	d using "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta"					
	d using "${ug}/LSMS/UGA_2013_UNPS_v01_M_STATA8/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2011_UNPS_v01_M_Stata/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2010_UNPS_v02_M_STATA12/GSEC1.dta"					
	d using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2009/2009_GSEC1.dta"	
	d using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2005/2005_GSEC1.dta"	

	
	u "${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14/HH/gsec1.dta"				, clear
	u "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta"				, clear
	u "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta"					, clear
	u "${ug}/LSMS/UGA_2013_UNPS_v01_M_STATA8/GSEC1.dta"					, clear
	u "${ug}/LSMS/UGA_2011_UNPS_v01_M_Stata/GSEC1.dta"					, clear
	u "${ug}/LSMS/UGA_2010_UNPS_v02_M_STATA12/GSEC1.dta"				, clear
	u "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2009/2009_GSEC1.dta"	, clear
	u "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2005/2005_GSEC1.dta"	, clear
		}
	
	u Hhid Ea using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2005/2005_GSEC1.dta"	, clear
	g _05=3
	ren Hhid HHID 
	mer 1:1 HHID using "${ug}/LSMS/UGA_2005_2009_UNPS_v02_M_STATA8/2009/2009_GSEC1.dta", gen(_09) keepus(HHID comm) update nolabel
	mer 1:1 HHID using "${ug}/LSMS/UGA_2010_UNPS_v02_M_STATA12/GSEC1.dta", gen(_10) keepus(HHID comm) update nolabel
	destring comm, replace
	mer 1:1 HHID using "${ug}/LSMS/UGA_2011_UNPS_v01_M_Stata/GSEC1.dta", gen(_11) keepus(HHID comm) update nolabel
	destring HHID, gen(HHID_old)
	ren HHID HHID05
	mer 1:m HHID_old using "${ug}/LSMS/UGA_2013_UNPS_v01_M_STATA8/GSEC1.dta", gen(_13) keepus(HHID HHID_old ea) update nolabel
// 	ta HHID
// 	replace HHID = substr(HHID,1,6)+substr(HHID,9,1)+substr(HHID,12,1)
// 	g xx = substr(HHID,8,2)	
// 	g yy = substr(HHID,11,2)
// 	ta xx 
// 	ta yy 
	ren HHID HHID13
	g HHID = substr(HHID13,1,6)+substr(HHID13,11,2)
	li HHID in 1/10
	mer m:1 HHID using "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta", gen(_15) keepus(HHID ea) update nolabel
	levelsof HHID if _15==1, clean
	levelsof HHID if _15==2, clean
	levelsof HHID if _15==3, clean
	ren HHID HHID15
	g t0_hhid = HHID15
	cou if mi(t0)	//	1904
	tab1 _* if mi(t0)	//	not present in 13 or 15, 
	preserve
	keep if mi(t0)
	tempfile bringback_pre15
	sa		`bringback_pre15'
	restore
	drop if mi(t0)
	mer 1:m t0_hhid using "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta", gen(_18) keepus(t0_hhid hhid ) update nolabel
	ren hhid hhidold
	duplicates report hhidold	//	519 missing 
	*	for some reason the public data string identifiers are in strL, which we must deal with before
	preserve
	u "${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14/HH/gsec1.dta"				, clear
	foreach x in hhid hhidold {
		tempvar a b 
		g `a' = length(`x')	//	precautions to verify that nothing is lost
		su `a', meanonly
		loc length=r(max)
		drop `a'
		g str`length' `b'=`x', a(`x')
		la var `b'	"`: var lab `x''"
		drop `x'
		ren `b' `x'
		}
	keep hhid hhidold
	duplicates report hhidold
	drop if mi(hhidold)
	tempfile r2019
	sa		`r2019'
	restore
	mer m:1 hhidold using `r2019', gen(_19) update nolabel
	append using `bringback_pre15'
	la val _?? .
	egen rounds = group(_??), label missing
	numlabel rounds, add
	ta rounds
	ta rounds, sort
		/*
	there are many categories here, but some interesting notes; 
	
	there are a few that exist in 2005, drop out in 09,  and reappear in subsequent rounds. 
			cou if inrange(rounds,2,11)
			
	
	
		*/
	
	compare Ea ea
	ta rounds if !mi(Ea)
	ta rounds if !mi(ea)
// 	g 
	
	
	u "${ug}/LSMS/UGA_2015_UNPS_v01_M_STATA8/gsec1.dta"					, clear
	ren HHID t0_hhid
	mer 1:m t0_hhid using "${ug}/LSMS/UGA_2018_UNPS_v02_M_STATA12/HH/GSEC1.dta", gen(_18) keepus(t0_hhid hhid ) update nolabel
	
	ta t0 if _18==1	//	prefix H
	ta t0 if _18==2	//	
















