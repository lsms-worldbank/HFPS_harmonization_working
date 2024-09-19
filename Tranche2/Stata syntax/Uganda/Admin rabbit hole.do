
*	reference relationships 
u  "${raw_lsms_uga}/HH/gsec1.dta", clear
keep region-urban
duplicates drop
ta region
sort district region urban s1aq02a s1aq03a s1aq04a
li, sepby(district)

u region subreg district dc_2018 using "${raw_lsms_uga}/HH/gsec1.dta", clear
g obs=1
collapse (sum) obs, by(region subreg district dc_2018)

	ren (district dc_2018)(DistrictName DistrictCode)
	*	different names within one code
	preserve
	collapse (sum) obs, by(DistrictName DistrictCode)
	bys DistrictCode (DistrictName) : g name=_n
	reshape wide obs DistrictName, i(DistrictCode) j(name)
	li, sep(0)
	recode DistrictCode (100/199=1)(200/299=2)(300/399=3)(400/499=4), gen(region)
	order region
	li if !mi(DistrictName2), sepby(region)
	levelsof DistrictCode if !mi(DistrictName2), loc(issues)
	restore
	*	are these temporal switches? -> no 
	loc sum=0
	foreach iss of local issues {
		su obs if DistrictCode==`iss', meanonly
		loc sum=`sum'+r(sum)
	}
	dis `sum'	//	648 households are in affected districts across all rounds
	su obs, meanonly
	dis `sum' / r(sum)	//	20% of the sample
	
	*	different codes within one name? 
	preserve
	collapse (sum) obs, by(DistrictName DistrictCode)
	bys DistrictName (DistrictCode) : g name=_n
	reshape wide obs DistrictCode, i(DistrictName) j(name)
	li, sep(0)
	li if !mi(DistrictCode2)
	levelsof DistrictName if !mi(DistrictCode2), loc(issues)
	restore
	loc sum=0
	foreach iss of local issues {
		su obs if DistrictName=="`iss'", meanonly
		loc sum=`sum'+r(sum)
	}
	dis `sum'	//	249
	su obs, meanonly
	dis `sum' / r(sum)	//	8% 
		
		*	the issues in the HFPS are reflected in the UNPS 
	
	
		
	





u "${tmp_hfps_uga}/panel/cover.dta", clear 

ta r0_region region	//	need to make region and subreg into coded variables to compare
	*-> actually, faster to make the r0 variables string
decode r0_region, gen(r0_regionstr)
cou if r0_regionstr!=region 

ta r0_subreg r0_region
ta r0_distname r0_subreg
decode r0_subreg, gen(r0_subregstr)
replace r0_regionstr = "Kampala" if r0_subregstr=="kampala"
replace r0_subregstr = "Kampala" if r0_subregstr=="kampala"	//	proper case in -subreg-
assert r0_subreg=="kampala":subreg if r0_distname=="KAMPALA"
assert r0_subreg!="kampala":subreg if r0_distname!="KAMPALA"
replace subreg = subinstr(subreg,"Nouth","North",1)

ta r0_subregstr subreg
cou if r0_regionstr!=region & _r0==3	//	205
ta r0_regionstr region if r0_regionstr!=region , m
ta round if r0_regionstr!=region, m
ta r0_regionstr region if r0_regionstr!=region , m

cou if r0_subregstr!=subreg & _r0==3
ta r0_subregstr subreg if r0_subregstr!=subreg & _r0==3

*	are these the same observations or different
g region_mismatch = (r0_regionstr!=region & _r0==3)
g subreg_mismatch = (r0_subregstr!=subreg & _r0==3)
ta region_mismatch subreg_mismatch	//	all region cases do not match subregion, but some additional subreg cases do not match 

sort hhid round 
export excel hhid round r0_regionstr r0_subregstr region subreg if subreg_mismatch==1 /*
*/	using "${tmp_hfps_uga}/do not export/Uganda Admin Conflicts.xlsx", /*
*/	sheet("region_subreg", replace) firstrow(variables)  


*	let's build out the full thing, not doing the fixes I have already identified? 
*	just flagging district cases where 
	preserve 
u region subreg district dc_2018 using "${raw_lsms_uga}/HH/gsec1.dta", clear
g obs=1
decode region, gen(refregion)
decode subreg, gen(refsubreg)
replace refregion = "Kampala" if refsubreg=="kampala"
replace refsubreg = subinstr(refsubreg,"kampala","Kampala",1)
collapse (sum) obs, by(refregion refsubreg district dc_2018)

	ren (district dc_2018)(DistrictName DistrictCode)
tempfile unps
sa		`unps'
	restore
mer m:1 DistrictName DistrictCode using `unps', keep(1 3) 
ta _r0 _merge
sort refregion refsubreg DistrictName DistrictCode
li refregion refsubreg region subreg DistrictName DistrictCode if refregion!=region & _r0==3
export excel hhid round refregion refsubreg region subreg DistrictName DistrictCode if refregion!=region & _r0==3 /*
*/	using "${tmp_hfps_uga}/do not export/Uganda Admin Conflicts.xlsx", /*
*/	sheet("disrict_region", replace) firstrow(variables)  




**	UPDATE : Giulia Ponzini has shared the preload files to reference to the final data and rule out pre-survey chnages as the source of change first 

ex



*	do changes we have identified already
	DistrictNameChanges	

cou if r0_distname!=DistrictName & _r0==3	//	949, post-fix
ta r0_distname DistrictName if r0_distname!=DistrictName & _r0==3


	*	region and subreg are supposed to be preloaded, and thus should be time invariant
	egen rgn = group(region), label
	bys hhid (round) : egen minrgn = min(rgn)
	bys hhid (round) : egen maxrgn = max(rgn)
	ta minrgn maxrgn
	ta round if rgn!=minrgn	//	423 
	ta round if rgn!=maxrgn	//	240 
	ta round if rgn==minrgn	//	25306
	dis `r(N)' / _N	//	99%
	la li lbregion
	la li rgn

	egen srg = group(subreg), label
	bys hhid (round) : egen minsrg = min(srg)
	bys hhid (round) : egen maxsrg = max(srg)
	ta minsrg maxsrg
	ta round if srg!=minsrg	//	610 
	ta round if srg!=maxsrg	//	912 
	ta round if minsrg==maxsrg	//	24223
	dis `r(N)' / _N	//	95%
	
	g xxx = (minsrg!=maxsrg)
	g xmin = srg!=minsrg
	g xmax = srg!=maxsrg
	bys hhid (round) : egen modesrg=mode(srg)
	li hhid round srg if mi(modesrg), sepby(hhid) 
	
	bys hhid (round) : egen sumxmax=sum(xmax)
	egen zzz = rowmin
	
	*	the updated data for district and below are only supposed to be changed for movers. Let's test the extent of movership 
	DistrictNameChanges	
	ta DistrictCode, m
	levelsof DistrictCode, loc(dcodes)
	foreach dc of local dcodes {
		levelsof DistrictName if DistrictCode==`dc'
	}
	*	different names within one code
	preserve
	g one=1
	collapse (sum) one, by(DistrictName DistrictCode)
	bys DistrictCode (DistrictName) : g name=_n
	reshape wide one DistrictName, i(DistrictCode) j(name)
	li, sep(0)
	recode DistrictCode (100/199=1)(200/299=2)(300/399=3)(400/499=4), gen(region)
	order region
	li if !mi(DistrictName2), sepby(region)
	levelsof DistrictCode if !mi(DistrictName2), loc(issues)
	restore
	*	are these temporal switches? -> no 
	loc sum=0
	foreach iss of local issues {
		ta round DistrictName if DistrictCode==`iss'
		loc sum=`sum'+r(N)
	}
	dis `sum'	//	5247 households are in affected districts across all rounds
	dis `sum' / _N	//	20% of the sample
	
	*	different codes within one name? 
	preserve
	g one=1
	collapse (sum) one, by(DistrictName DistrictCode)
	bys DistrictName (DistrictCode) : g name=_n
	reshape wide one DistrictCode, i(DistrictName) j(name)
	li, sep(0)
	li if !mi(DistrictCode2)
	levelsof DistrictName if !mi(DistrictCode2), loc(issues)
	restore
	loc sum=0
	foreach iss of local issues {
		ta round DistrictCode if DistrictName=="`iss'"
		loc sum=`sum'+r(N)
	}
	dis `sum'	//	2434
	dis `sum' / _N	//	9.5% 
		

	*	Assuming that the enumerator might have updated the name but not the code in some cases
	ta DistrictName
	dis r(r)	//	123
	ta DistrictCode
	dis r(r)	//	121
		*-> pretty close in total categories though 
	ta round if strtrim(stritrim(upper(DistrictName)))!= strtrim(stritrim(upper(r0_distname))) & !mi(DistrictName) & !mi(r0_distname)
		*	to what extent is this change static or dynamic? 
	g xxx = strtrim(stritrim(upper(DistrictName)))!= strtrim(stritrim(upper(r0_distname))) if !mi(DistrictName) & !mi(r0_distname)
	bys hhid (round) : g passin = (xxx==1 & xxx[_n-1]==0)
	bys hhid (round) : g passout = (xxx==0 & xxx[_n-1]==1)
	tab2 round xxx passin passout, first	//	more passin in rounds 7, 8, 12, but N is small. Only a little passout. 
	drop xxx passin passout
	

