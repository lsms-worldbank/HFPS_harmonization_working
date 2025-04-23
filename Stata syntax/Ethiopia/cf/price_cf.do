
/*
d using "${et_hfps_out}/dta/r1/cover.dta"
u cs1_region cs4_sector using "${et_hfps_out}/dta/r1/cover.dta", clear
la li cs1_region cs4_sector 
// ta  cs1_region cs4_sector

dir "${raw_lsms_eth1}"
d using "${raw_lsms_eth1}/Food_CF_Wave4.dta"
	*	Addis not represented here... will have to sue national I suppose 
*/	
u "${raw_lsms_eth1}/Crop_CF_Wave4.dta", clear
	
u "${raw_lsms_eth1}/Food_CF_Wave4.dta", clear
/*
duplicates report item_cd unit_cd
duplicates report item_cd_cf item_cd unit_cd	//	identified
duplicates report item_cd_cf unit_cd	//	identified
ta item_cd_cf if mi(item_cd)	//	none of these are considered in the HFPS data
assert item_cd==item_cd_cf if !mi(item_cd)
*/
drop item_cd 
isid item_cd_cf unit_cd	
drop note

ren mean_cf_nat natl_cf
reshape long mean_cf, i(item_cd_cf unit_cd) j(cs1_region)
ren mean_cf rgnl_cf
su rgnl_cf natl_cf

	preserve
bys unit_cd : egen min = min(rgnl_cf)
bys unit_cd : egen max = max(rgnl_cf)
g unity = min if min==max
keep if !mi(unity)
keep unit_cd unity
ta unit_cd
duplicates drop
li, sep(0)
keep if inrange(unit_cd,1,5)
tempfile unity
sa `unity'
	restore
	
	ta unit_cd
reshape wide rgnl_cf natl_cf, i(item_cd_cf cs1_region) j(unit_cd)
reshape long
	ta unit_cd 
	ta unit_cd if mi(rgnl_cf)
mer m:1 unit_cd using `unity', assert(1 3) nogen
replace rgnl_cf = unity if mi(rgnl_cf)
replace natl_cf = unity if mi(natl_cf)
drop unity 


*	construct typical relationship between units S/M/L triplets and fill? 

	*	identify triplet sets
recode unit_cd (31/33=3)(41/43=4)(51/53=5)(61/63=6)(71/73=7)(81/83=8)(91/93=9)(101/103=10)(111/113=11)(121/123=12)(131/133=13)(141/143=14)(151/153=15)(161/163=16)(181/183=18)(191/193=19)(else=.), gen(triplets)
ta item_cd_cf unit_cd 
g s = inlist(unit_cd,31,41,51,61,71,81,91,101,111,121,131,141,151,161,181,191)
g m = inlist(unit_cd,32,42,52,62,72,82,92,102,112,122,132,142,152,162,182,192)
g l = inlist(unit_cd,33,43,53,63,73,83,93,103,113,123,133,143,153,163,183,193)

*	regional conversion factor adjustment 
*	generate the s/m/l values across each triplet 
bys item_cd_cf cs1_region triplets (unit_cd) : egen s_cf = max(rgnl_cf * cond(s==1,1,.))
by  item_cd_cf cs1_region triplets (unit_cd) : egen m_cf = max(rgnl_cf * cond(m==1,1,.))
by  item_cd_cf cs1_region triplets (unit_cd) : egen l_cf = max(rgnl_cf * cond(l==1,1,.))
su s_cf m_cf l_cf	//	m most common, s & l equally common. prefer m as the base where possible 
*	do cases exist where one of S/M/L are not defined? 
cou if mi(s_cf) & !mi(m_cf)	//	891
cou if mi(s_cf) & !mi(l_cf)	//	33
cou if mi(m_cf) & !mi(l_cf)	//	220

*	make the typical relationships between s/m/l for the triplets, accounting for regional difference
bys triplets cs1_region (unit_cd item_cd_cf) : egen l_s = median(l_cf / s_cf)
by  triplets cs1_region (unit_cd item_cd_cf) : egen l_m = median(l_cf / m_cf)
by  triplets cs1_region (unit_cd item_cd_cf) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace rgnl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(rgnl_cf)

*	make typical relationships ignoring regional differences 
drop l_s l_m m_s
bys triplets (cs1_region unit_cd item_cd_cf) : egen l_s = median(l_cf / s_cf)
by  triplets (cs1_region unit_cd item_cd_cf) : egen l_m = median(l_cf / m_cf)
by  triplets (cs1_region unit_cd item_cd_cf) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace rgnl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(rgnl_cf)
replace rgnl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(rgnl_cf)
replace rgnl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(rgnl_cf)
replace rgnl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(rgnl_cf)
	*	none of these add additional data 
drop ?_cf l_s l_m m_s


*	national conversion factor adjustment 
*	generate the s/m/l values across each triplet 
bys item_cd_cf triplets (unit_cd) : egen s_cf = max(natl_cf * cond(s==1,1,.))
by  item_cd_cf triplets (unit_cd) : egen m_cf = max(natl_cf * cond(m==1,1,.))
by  item_cd_cf triplets (unit_cd) : egen l_cf = max(natl_cf * cond(l==1,1,.))
su s_cf m_cf l_cf	//	m most common, s & l equally common. prefer m as the base where possible 
cou if mi(s_cf) & !mi(m_cf)	//	649
cou if mi(s_cf) & !mi(l_cf)	//	24
cou if mi(m_cf) & !mi(l_cf)	//	160

*	make typical relationships between s/m/l for the triplet 
bys triplets (unit_cd item_cd_cf) : egen l_s = median(l_cf / s_cf)
by  triplets (unit_cd item_cd_cf) : egen l_m = median(l_cf / m_cf)
by  triplets (unit_cd item_cd_cf) : egen m_s = median(m_cf / s_cf)

*	fill in missing cfs 
replace natl_cf = m_cf * l_m if mi(l_cf) & !mi(m_cf) & l==1 & mi(natl_cf)
replace natl_cf = s_cf * l_s if mi(l_cf) & !mi(s_cf) & l==1 & mi(natl_cf)
replace natl_cf = m_cf / m_s if mi(s_cf) & !mi(m_cf) & s==1 & mi(natl_cf)
replace natl_cf = l_cf / l_s if mi(s_cf) & !mi(l_cf) & s==1 & mi(natl_cf)
replace natl_cf = l_cf / l_m if mi(m_cf) & !mi(l_cf) & m==1 & mi(natl_cf)
replace natl_cf = s_cf * m_s if mi(m_cf) & !mi(s_cf) & m==1 & mi(natl_cf)
drop ?_cf l_s l_m m_s

drop s m l triplets


*	two doublets as well 
*	identify doublet sets 
recode unit_cd (21/22=2)(171/172=17)(else=.), gen(doublets)
g s = inlist(unit_cd,21,171)
g l = inlist(unit_cd,22,172)

*	regional conversion factor adjustment 
*	generate the s/l values across each doublet 
bys item_cd_cf cs1_region doublets (unit_cd) : egen s_cf = max(rgnl_cf * cond(s==1,1,.))
by  item_cd_cf cs1_region doublets (unit_cd) : egen l_cf = max(rgnl_cf * cond(l==1,1,.))
su s_cf l_cf	//	s & l equally common. prefer m as the base where possible 
cou if mi(s_cf) & !mi(l_cf)	//	nothing to fix 
cou if mi(l_cf) & !mi(s_cf)	//	nothing to fix 
drop s_cf l_cf

*	national conversion factor adjustment, simply verify that the tests above would also be valid for natl_cf 
assert !mi(natl_cf) if !mi(rgnl_cf)
assert !mi(rgnl_cf) if !mi(natl_cf)
drop doublets s l 





*	following fixes, restrict to cases where we have CFs
drop if mi(rgnl_cf) & mi(natl_cf)



expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=5) if mark==1		//	Somali
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=13) if mark==1	//	Harar
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=15) if mark==1	//	Dire Dawa
drop mark
expand 2 if cs1_region==99, gen(mark)
recode cs1_region (99=14) if mark==1	//	Addis
replace rgnl_cf = natl_cf if mark==1	//	special treatment for Addis 
drop mark
drop if cs1_region==99	

*	two new units in the price data
expand 2 if unit_cd==5, gen(mark)
recode unit_cd (5=194) if mark==1
replace rgnl_cf = rgnl_cf * 330 if mark==1
replace natl_cf = natl_cf * 330 if mark==1
drop mark
expand 2 if unit_cd==5, gen(mark)
recode unit_cd (5=195) if mark==1
replace rgnl_cf = rgnl_cf * 475 if mark==1
replace natl_cf = natl_cf * 475 if mark==1
drop mark




sa "${hfps}/Input datasets/Ethiopia/price_cf.dta", replace 

u  "${hfps}/Input datasets/Ethiopia/price_cf.dta", clear 
la li unit
la save unit using "${do_hfps_eth}/cf/label_unit.do", replace
la li item_cd
la save item_cd using "${do_hfps_eth}/cf/label_item_cd.do", replace

ta unit_cd if item_cd_cf==195	//	purchased injera - no piece 
ta unit_cd if item_cd_cf==196	//	purchased injera bread or biscuits 	->	no piece? 


