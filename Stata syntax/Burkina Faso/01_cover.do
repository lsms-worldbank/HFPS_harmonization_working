
*	two separate directories for phase 1 & 2
dir "${raw_hfps_bfa}", w
dir "${raw_hfps_bfa}/r*_sec0_*.dta", w
dir "${raw_hfps_bfa}/r*_sec1a_*.dta", w

d using	"${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta"		
d using	"${raw_hfps_bfa}/r1_sec1b_info_entretien_numero.dta"		
u "${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta", clear
cou if s01aq03=="Oui":s01aq03
la li s01aq08
cou if s01aq08==1
duplicates report hhid if s01aq08==1	
ret li	//	there is the 1968 we expect

keep if s01aq08==1
duplicates tag hhid, gen(tag)	
ta tag
li if tag==2, sepby(hhid)
bys hhid (tentatives__id) : keep if _n==_N
cou
keep hhid s01aq02

d using	"${raw_hfps_bfa}/r1_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r2_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r3_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r4_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r5_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r6_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r7_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r8_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r9_sec0_cover.dta"		
d using	"${raw_hfps_bfa}/r10_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r11_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r12_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r13_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r14_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r15_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r16_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r17_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r18_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r19_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r20_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r21_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r22_sec0_cover.dta"	
d using	"${raw_hfps_bfa}/r23_sec0_cover.dta"	



u "${raw_hfps_bfa}/r1_sec0_cover.dta" , clear
d, replace clear
// ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1)
// tempfile base
// sa      `base'
foreach r of numlist 1(1)23 {
	u "${raw_hfps_bfa}/r`r'_sec0_cover.dta" , clear
	d, replace clear
// 	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r')
	tempfile r`r'
	sa      `r`r''
}

u `r1', clear
foreach r of numlist 1(1)23 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (2 3=`r')(. 1=.)
	la drop _merge
	la val _`r' .
}
ds _*
egen matches = rownonmiss(`r(varlist)')
ds _*
egen rounds = group(`r(varlist)'), label missing
ta rounds


li name matches, sep(0)






*	household level detail from actual completed interview (incl. weights)

#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r2_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r3_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r4_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r5_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r6_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r7_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r8_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r9_sec1a_info_entretien_tentative.dta"		
	"${raw_hfps_bfa}/r10_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r11_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r12_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r13_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r14_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r15_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r16_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r17_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r18_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r19_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r20_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r21_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r22_sec1a_info_entretien_tentative.dta"	
	"${raw_hfps_bfa}/r23_sec1a_info_entretien_tentative.dta"	

, gen(round) nolabel;
#d cr
isid hhid round tentatives__id
convert_date_time s01aq02
bys hhid round (tentatives__id) : egen hastime = sum(!mi(s01aq02))
assert hastime>0 & !mi(hastime)
bys hhid round (tentatives__id) : egen keeper = max(tentatives * cond(!mi(s01aq02),1,.))
keep if tentatives__id==keeper
// bys hhid round (tentatives__id) : keep if _n==_N
assert !mi(s01aq02)
keep hhid round s01aq02
tempfile time
sa		`time'
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r2_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r3_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r4_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r5_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r6_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r7_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r8_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r9_sec12_bilan_entretien.dta"		
	"${raw_hfps_bfa}/r10_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r11_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r12_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r13_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r14_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r15_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r16_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r17_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r18_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r19_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r20_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r21_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r22_sec12_bilan_entretien.dta"	
	"${raw_hfps_bfa}/r23_sec12_bilan_entretien.dta"	

, gen(round);
#d cr
isid hhid round
keep hhid round s12q05 s12q09 s12q14
tempfile respondent
sa		`respondent'
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec0_cover.dta"		
	"${raw_hfps_bfa}/r2_sec0_cover.dta"		
	"${raw_hfps_bfa}/r3_sec0_cover.dta"		
	"${raw_hfps_bfa}/r4_sec0_cover.dta"		
	"${raw_hfps_bfa}/r5_sec0_cover.dta"		
	"${raw_hfps_bfa}/r6_sec0_cover.dta"		
	"${raw_hfps_bfa}/r7_sec0_cover.dta"		
	"${raw_hfps_bfa}/r8_sec0_cover.dta"		
	"${raw_hfps_bfa}/r9_sec0_cover.dta"		
	"${raw_hfps_bfa}/r10_sec0_cover.dta"	
	"${raw_hfps_bfa}/r11_sec0_cover.dta"	
	"${raw_hfps_bfa}/r12_sec0_cover.dta"	
	"${raw_hfps_bfa}/r13_sec0_cover.dta"	
	"${raw_hfps_bfa}/r14_sec0_cover.dta"	
	"${raw_hfps_bfa}/r15_sec0_cover.dta"	
	"${raw_hfps_bfa}/r16_sec0_cover.dta"	
	"${raw_hfps_bfa}/r17_sec0_cover.dta"	
	"${raw_hfps_bfa}/r18_sec0_cover.dta"	
	"${raw_hfps_bfa}/r19_sec0_cover.dta"	
	"${raw_hfps_bfa}/r20_sec0_cover.dta"	
	"${raw_hfps_bfa}/r21_sec0_cover.dta"	
	"${raw_hfps_bfa}/r22_sec0_cover.dta"	
	"${raw_hfps_bfa}/r23_sec0_cover.dta"	

, gen(round);
#d cr
	mer 1:1 hhid round using `time',
	ta round _m,m
	ta _m resultat, m
	cou if !mi(s01aq02) & _m==3 & mi(resultat)	//	round 1 
	keep if _m==3
	drop _m resultat
	la drop _append
	la val round 
	ta round 	
	g phase=cond(round<=12,1,2), b(round)
	la var round	"Survey round"
	la var phase	"Survey phase"
	isid hhid round
	sort hhid round
	
	mer 1:1 hhid round using `respondent'
	ta s12q05 _m,m	//	imperfect now
	ta s12q05 round if _m==3
	keep if s12q05==1
	drop _merge
	
	ta round
	

	d hhw*cs, f
	d hhw*pnl, f
	tabstat hhw*pnl, by(round) s(sum) format(%12.3gc)
	tabstat hhw*cs, by(round) s(sum) format(%12.3gc)
	egen wgt = rowfirst(hhwcovid_r1 hhwcovid_r2_s1 hhw*cs)
	tabstat hhw*pnl, by(round) s(n) format(%12.3gc)
	egen wgt_panel = rowfirst(hhwcovid_r1 hhwcovid_r2_s1s2 hhw*pnl)
	drop hhwcovid_r1 hhwcovid_r2_s1 hhw*cs hhwcovid_r2_s1s2 hhw*pnl

	la var wgt			"Cross section weight"
	la var wgt_panel	"Panel sampling weight"

	tab1 round strate milieu region province commune echantillon, m 


*	dates 
li s01aq02 in 1/10
convert_date_time s01aq02
	bys round : egen medianday1 = median(dofc(s01aq02))
	g keep1 = s01aq02		if inrange(dofc(s01aq02)  ,medianday1-30,medianday1+30)

g pnl_intclock=keep1
	ta round if mi(pnl_intclock)
	replace pnl_intclock = cofd(medianday1) if mi(pnl_intclock)
	format pnl_intclock %tc
	g double pnl_intdate = dofc(pnl_intclock)
	format pnl_intdate %td

	drop s01aq02 medianday1 keep1 
	
	duplicates report round pnl_intclock
	isid hhid pnl_intclock
	isid hhid pnl_intdate
		

g long start_yr= Clockpart(pnl_intclock, "year")
g long start_mo= Clockpart(pnl_intclock, "month")
g long start_dy= Clockpart(pnl_intclock, "day")

table (start_yr start_mo) round, nototal	//	formerly a few oddities in round 18, now clean 

	isid hhid round
	sort hhid round

sa "${tmp_hfps_bfa}/cover.dta", replace 


*	modifications for construction of grand panel 
u "${tmp_hfps_bfa}/cover.dta", clear


egen pnl_hhid = group(hhid)
li strate milieu region grappe province commune echantillon in 1/10
li strate milieu region grappe province commune echantillon in 1/10, nol

egen pnl_admin1 = group(region)
egen pnl_admin2 = group(region province)
egen pnl_admin3 = group(region province commune)

ta strate, m
la li strate
egen pnl_urban = anymatch(strate), v(1 2)
g pnl_strata = strate
g pnl_cluster = grappe
g pnl_wgt = wgt 
isid pnl_hhid round


sa "${tmp_hfps_bfa}/pnl_cover.dta", replace 

svyset pnl_cluster [pw=pnl_wgt], strata(pnl_strata)
svy : ta pnl_strata




