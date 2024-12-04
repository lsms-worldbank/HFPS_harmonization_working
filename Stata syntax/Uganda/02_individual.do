


loc investigate=0
if `investigate'==1 {

dir "${raw_hfps_uga}", w
dir "${raw_hfps_uga}/round1", w
dir "${raw_hfps_uga}/round2", w
dir "${raw_hfps_uga}/round3", w
dir "${raw_hfps_uga}/round4", w
dir "${raw_hfps_uga}/round5", w
dir "${raw_hfps_uga}/round6", w
dir "${raw_hfps_uga}/round7", w
dir "${raw_hfps_uga}/round8", w
dir "${raw_hfps_uga}/round9", w
dir "${raw_hfps_uga}/round10", w
dir "${raw_hfps_uga}/round11", w
dir "${raw_hfps_uga}/round12", w
dir "${raw_hfps_uga}/round13", w
dir "${raw_hfps_uga}/round14", w
dir "${raw_hfps_uga}/round15", w
dir "${raw_hfps_uga}/round16", w
dir "${raw_hfps_uga}/round17", w
dir "${raw_hfps_uga}/round18", w


d *id* using	"${raw_hfps_uga}/round1/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round2/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round3/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round4/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round5/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round6/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round7/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round8/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round9/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round10/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round11/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round12/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round13/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round14/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round15/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round16/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round17/SEC1.dta"
d *id* using	"${raw_hfps_uga}/round18/SEC1.dta"

d using	"${raw_hfps_uga}/round1/SEC1.dta"
d using	"${raw_hfps_uga}/round2/SEC1.dta"
d using	"${raw_hfps_uga}/round3/SEC1.dta"
d using	"${raw_hfps_uga}/round4/SEC1.dta"
d using	"${raw_hfps_uga}/round5/SEC1.dta"
d using	"${raw_hfps_uga}/round6/SEC1.dta"
d using	"${raw_hfps_uga}/round7/SEC1.dta"
d using	"${raw_hfps_uga}/round8/SEC1.dta"
d using	"${raw_hfps_uga}/round9/SEC1.dta"
d using	"${raw_hfps_uga}/round10/SEC1.dta"
d using	"${raw_hfps_uga}/round11/SEC1.dta"
d using	"${raw_hfps_uga}/round12/SEC1.dta"
d using	"${raw_hfps_uga}/round13/SEC1.dta"
d using	"${raw_hfps_uga}/round14/SEC1.dta"
d using	"${raw_hfps_uga}/round15/SEC1.dta"	//	is this the key to link the round 13 & 14
d using	"${raw_hfps_uga}/round16/SEC1.dta"
d using	"${raw_hfps_uga}/round17/SEC1.dta"
d using	"${raw_hfps_uga}/round18/SEC1.dta"



*	using a simple append gives a dataset that is identifie at the hh x individual x round level
*	but the data show that the individual id is not fixed to a single person across time


/*UPDATE: pid_ubos has been updated in a private version, which are expected to 
	be reflected in subsequent public versions as well. Bringing them in as an 
	input dataset for now.	*/


{	/*old pid_ubos investigations*/
// u	"${raw_hfps_uga}/round15/SEC1.dta", clear
// d *id*
// nmissing *id*
// ta Round13_hh_roster_id
// ta Round12_hh_roster_id	//	could use these to link to the phase 1 I suppose 
// duplicates report hhid Round13_hh_roster_id	
// duplicates report hhid Round13_pid_ubos
//
// destring Round13_hh_roster_id, ignore(#N/A) gen(zzz)
// compare Round13_pid_ubos zzz	//	lots of missing Round13... 
// su zzz Round13_pid_ubos
//
// u	"${raw_hfps_uga}/round15/COVER.dta", clear
//
// // log using "${hfps}/Log files/Uganda/Round 15 Sec 1 pid_ubos linkage.txt", replace text name(r15pid)
// u	"${raw_hfps_uga}/round15/SEC1.dta", clear
// mer m:1 hhid using "${raw_hfps_uga}/round15/COVER.dta", keepus(sample_type) assert(3) nogen
// destring Round*_hh_roster_id, ignore(#N/A) replace
// tabstat Round*_hh_roster_id, s(n sum)
// tabstat Round*_pid_ubos, s(n sum)
//
// *	this is functionally identical to just taking Round14_pid_ubos
// egen pid_ubos=rowfirst(Round14_pid_ubos Round13_pid_ubos Round12_pid_ubos Round11_pid_ubos Round10_pid_ubos Round9_pid_ubos Round8_pid_ubos)
// assert pid_ubos==Round14_pid
//
// ta sample_type,m
// ta sample_type if mi(pid_ubos),m	//	not identified by the sample_type variable 
// cou if mi(pid_ubos)	//	714
//
//
// *	try to update pid_ubos based on prior rounds 
// ren (hh_roster__id Round12_hh_roster)(Round15_hh_roster_id hh_roster__id)
// mer m:1 hhid hh_roster__id using "${raw_hfps_uga}/round12/SEC1.dta", keepus(pid_ubos) update keep(1 3 4) gen(_12) nolabel
// forv z=11(-1)8 {
// 	loc a=`z'+1
// ren (hh_roster__id Round`z'_hh_roster)(Round`a'_hh_roster_id hh_roster__id)
// mer m:1 hhid hh_roster__id using "${raw_hfps_uga}/round`z'/SEC1.dta", keepus(pid_ubos) update keep(1 3 4) gen(_`z') nolabel
// }
// ren (hh_roster__id Round15_hh_roster)(Round8_hh_roster_id hh_roster__id)
// cou if mi(pid_ubos)	//	we have gained one 
//
// *	can we identify any drivers of this missingness? 
// g flag = mi(pid_ubos)
// tab2 flag sample_type s1q02 s1q03,m first
// 	*	I cannot see the right way to improve this link  
//
// // cap : log close r15pid
//
//
//
// u	"${raw_hfps_uga}/round13/SEC1.dta", clear
// tostring hh_roster__id, gen(Round13_hh_roster__id)
// // mer 1:m hh
//
//
// u	"${raw_hfps_uga}/round1/SEC1.dta", clear
// mer 1:1 hhid hh_roster__id using "${raw_hfps_uga}/round2/SEC1.dta"
// u	"${raw_hfps_uga}/round2/SEC1.dta", clear
// d hh_roster__id Round1_hh_roster_id
// destring Round1_hh_roster_id, replace ignore(#N/A)
// compare hh_roster__id Round1_hh_roster_id	//	
// ren (hh_roster__id Round1_hh_roster_id)(s2_ind hh_roster__id)
// duplicates list hhid hh_roster__id, sepby()
// mer m:1 hhid hh_roster__id using "${raw_hfps_uga}/round1/SEC1.dta"
//
//
// *	so should we work backwards to establish an individual link across time?  
// u	"${raw_hfps_uga}/round1/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round2/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round3/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round4/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round5/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round6/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round7/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round8/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round9/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round10/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round11/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round12/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round13/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round14/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round15/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round16/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round17/SEC1.dta", clear
// nmissing *id*
// u	"${raw_hfps_uga}/round18/SEC1.dta", clear
// duplicates report hhid hh_roster__id
// nmissing *id*
// duplicates report hhid Round16_hh_roster_id
//
// // u hhid hh_roster__id Round16_pid_ubos Roun
//
// u	"${raw_hfps_uga}/round1/SEC1.dta", clear
// mer 1:1 hhid hh_roster__id using "${raw_hfps_uga}/round13/SEC1.dta"
// u	"${raw_hfps_uga}/round1/SEC1.dta", clear
// mer 1:1 hhid hh_roster__id using "${raw_hfps_uga}/round9/SEC1.dta"
//  
}	/*end old pid_ubos invstigations*/



{	/*	automated variable label inventory - sec1 	*/

preserve
qui {
foreach r of numlist 1/18 {
	u "${raw_hfps_uga}/round`r'/SEC1.dta" , clear
	d, replace clear
	tempfile r`r'
	sa      `r`r''
	}
	u `r1', clear
foreach r of numlist 1/18 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	}

	
egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
// li name varlab rounds,  sep(0)
// li name varlab rounds if matches>3, sep(0)
li name varlab type rounds if strpos(name,"id")>0,  sep(0)

log using "${hfps}/Log files/Uganda/Uganda individual ID inventory.txt", name(id_inventory) text replace
li name varlab type rounds if strpos(name,"id")>0,  sep(0)
log close id_inventory
restore
}


{	/*	automated value label inventory - sec1 	*/

preserve
qui {
foreach r of numlist 1/18 {
	u "${raw_hfps_uga}/round`r'/SEC1.dta" , clear
	la dir
	uselabel `r(labels)', replace clear
	tempfile r`r'
	sa      `r`r''
	}
	u `r1', clear
foreach r of numlist 1/18 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (1 .=.)(2 3=`r')
	la val _`r' .
	}

	
egen matches = rowtotal(_? _??)
ta matches
egen rounds = group(_? _??), label missing
}
li lname value label rounds,  sepby(lname)
li lname value label rounds if matches>3, sepby(lname)
restore
}




{
/*
*	test merge prior to any subsequent work
u	"${raw_hfps_uga}/round3/SEC1.dta", clear
mer m:1 hhid using	"${raw_hfps_uga}/round3/COVER.dta"
su wfinal if _m==2	//	only 2 obs anyway? what is going on? 
u	"${raw_hfps_uga}/round3/SEC1.dta", clear
mer m:1 hhid using	"${raw_hfps_uga}/round3/interview_result.dta"
ta Rq05 _m
keep if _m==2
keep hhid
duplicates drop
mer 1:1 hhid using "${raw_hfps_uga}/round2/COVER.dta"
ta _m	//	not present in round 2
keep if _m==1
keep hhid 
mer 1:1 hhid using "${raw_hfps_uga}/round1/COVER.dta"	//	no _m==3 here either 



u "${raw_hfps_uga}/round3/COVER.dta", clear
mer 1:1 hhid using	"${raw_hfps_uga}/round3/interview_result.dta", assert(3) nogen
ta Rq05,m

u "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", clear
ren hhid baseline_hhid
mer 1:1 baseline_hhid using	"${raw_hfps_uga}/round3/COVER.dta"




*	automated look for this information
local files : dir "${raw_hfps_uga}/round10" files "*.dta"
dir "${raw_hfps_uga}/round10", w

foreach f in Cover SEC1 SEC2A_1 SEC2A_2 SEC4 SEC5 SEC5A SEC6 SEC7 SEC8 SEC10 SEC10_1 SEC12 SEC13 SEC15 SEC16 {
	u "${raw_hfps_uga}/round10/`f'.dta", clear
	d , replace clear
	tempfile f`f'
	sa `f`f''
}
clear
append using  `fCover' `fSEC1' `fSEC2A_1' `fSEC2A_2' `fSEC4' `fSEC5' `fSEC5A' `fSEC6' `fSEC7' `fSEC8' `fSEC10' `fSEC10_1' `fSEC12' `fSEC13' `fSEC15' `fSEC16', gen(file)
ta file if strpos(name,"Rq")>0
	//	not present... 
	
	

#d ;
u "${raw_hfps_uga}/round1/SEC1.dta" , clear;
d, replace clear;
ren (position type isnumeric format vallab varlab)(pos1 type1 isnum1 fmt1 val1 var1);
tempfile base;
sa      `base';
foreach r of numlist 2(1)17 {;
	u "${raw_hfps_uga}/round`r'/SEC1.dta" , clear;
	d, replace clear;
	ren (position type isnumeric format vallab varlab)(pos`r' type`r' isnum`r' fmt`r' val`r' var`r');
	tempfile r`r';
	sa      `r`r'';
	u `base', clear;
	mer 1:1 name using `r`r'', gen(_`r');
	sa `base', replace ;
};
u `base', clear;
#d cr 
egen matches = anycount(_*), v(3)
ta matches
ta name matches if matches>=10
ta name matches if matches<10

li name var1 if matches>=10, sep(0)
li name _* if matches<10, sep(0) nol


u	"${raw_hfps_uga}/round8/SEC1.dta", clear

bro hhid hh_roster__id pid_ubos Round7_pid_ubos Round7_hh_roster_id
destring Round7_hh_roster_id, replace
compare Round7_hh_roster_id hh_roster__id

*/

}


********************************************************************************
}	/*	end investigate bracket	*/
********************************************************************************


*	hh_roster__ididual data, using force to ignore one mismatch in Round7_hh_roster_id
#d ; 
clear; append using
	"${raw_hfps_uga}/round1/SEC1.dta"
	"${raw_hfps_uga}/round2/SEC1.dta"
	"${raw_hfps_uga}/round3/SEC1.dta"
	"${raw_hfps_uga}/round4/SEC1.dta"
	"${raw_hfps_uga}/round5/SEC1.dta"
	"${raw_hfps_uga}/round6/SEC1.dta"
	"${raw_hfps_uga}/round7/SEC1.dta"
	"${raw_hfps_uga}/round8/SEC1.dta"
	"${raw_hfps_uga}/round9/SEC1.dta"
	"${raw_hfps_uga}/round10/SEC1.dta"
	"${raw_hfps_uga}/round11/SEC1.dta"
	"${raw_hfps_uga}/round12/SEC1.dta"
	"${raw_hfps_uga}/round13/SEC1.dta"
	"${raw_hfps_uga}/round14/SEC1.dta"
	"${raw_hfps_uga}/round15/SEC1.dta"
	"${raw_hfps_uga}/round16/SEC1.dta"
	"${raw_hfps_uga}/round17/SEC1.dta"
	"${raw_hfps_uga}/round18/SEC1.dta"

	, gen(round) force;
#d cr


	la drop _append
	la val round 
	ta round 	
// 	g phase=cond(round<=12,1,2), b(round)	//	there was a replenishment of the sample in round 13 to 
	format hhid %20.0g

	destring Round7_hh_roster_id, replace
	destring Round1_hh_roster_id Round2_hh_roster_id, replace ignore(#N/A)
	tabstat hh_roster__id t0_ubos_pid pid_ubos Round1_hh_roster_id Round2_pid_ubos Round2_hh_roster_id Round7_pid_ubos Round7_hh_roster_id, by(round) s(n) format(%9.3gc)
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round

	/*
	compare pid_ubos t0_ubos_pid

	tab2 round Round*_pid_ubos,m first
	ds Round*pid_ubos, detail alpha
	tabstat Round*_pid_ubos, by(round) s(n)
	tabstat Round*_pid_ubos, s(n) c(s) longstub
	
	log using "${hfps}/Log files/Uganda/missing_pid_ubos.txt", replace text name(missing_pid_ubos)
	compare Round15_pid_ubos Round16_pid_ubos
	g mi_pid = (mi(pid_ubos))
	ta round mi_pid
	egen preload_pid = rowfirst(Round16_pid_ubos Round14_pid_ubos)
	replace pid_ubos = preload_pid if mi(pid_ubos) 
	replace mi_pid = (mi(pid_ubos))
	ta round mi_pid
	log close missing_pid_ubos
	*/
	
	ta round s1q02a, m
	ta s1q02a s1q02,m
	
	g member = (s1q02==1 | s1q03==1) & s1q02a!=2
	g sex=s1q05
	li hhid hh_roster__id pid_ubos if sex==.a & round==5
	g age=s1q06
	g head=(s1q07==1)
	g relation=s1q07
	label copy s1q07 relation
	label val relation relation			 
		 	
	*	respondent
	d using "${tmp_hfps_uga}/cover.dta"
	g Rq09 = hh_roster__id
	mer 1:m hhid Rq09 round using "${tmp_hfps_uga}/cover.dta"
	ta round _m
	g respond = (_m==3) if round!=10
	g carbon=respond
	drop if _m==2
	
		bys hhid round (hh_roster__id) : egen testresp = sum(respond)
		ta round testresp,m	//	notably rounds 9, 10 is all blank by construction
		ta respond member,m
		
		*	step 1 assume prior round respondent was interviewed again if available 
		bys hhid hh_roster__id (round) : replace respond = respond[_n-1] if testresp!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 

		bys hhid round (hh_roster__id) : egen testresp2 = sum(respond)
		ta round testresp2,m	//	round 1 most pronounced
		li hhid round hh_roster__id member respond carbon if testresp2==2 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond carbon if hhid==102102041501 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==102102041501 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==124103021802 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==124103021802 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==313109010501 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==313109010501 & round==9 & hh_roster__id==2
		li hhid round hh_roster__id member respond carbon if hhid==407202041401 & inrange(round,8,11), sepby(round)
		recode respond (1=0) if hhid==407202041401 & round==9 & hh_roster__id==1
		li hhid round hh_roster__id member respond carbon if hhid==408112022601 & inrange(round,5,9), sepby(round)
		recode respond (1=0) if hhid==408112022601 & round==7 & hh_roster__id==1
		
		
		li hhid round hh_roster__id member respond if testresp2==0 & round!=10, sepby(hhid)
		by hhid : egen flagresp = min(testresp2)
		li hhid round hh_roster__id member respond age sex testresp2 if flagresp==0 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond if flagresp==0 & (respond==1 | testresp2==0) & round!=10, sepby(hhid)

	*	step 2 use respondent from subsequent round 
		su round, meanonly
		g backwards = -1 * (round-r(max)-r(min)) if round!=10
		bys hhid hh_roster__id (backwards) : replace respond = respond[_n-1] if testresp2!=1 & member==1 & !mi(respond[_n-1]) & round!=10	//	presume that the respondent id is stable if that person is still available 
		*	also code=1 if any singletons exist 
		bys hhid round (hh_roster__id) : replace respond =1 if testresp2!=1 & _N==1 & round!=10 //	2
			
		
		bys hhid round (hh_roster__id) : egen testresp3 = sum(respond)
		ta round testresp3
		by hhid : egen flagresp2 = min(cond(round==10,1,testresp3))
		li hhid round hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & round!=10, sepby(hhid)
		li hhid round hh_roster__id member respond age sex relation testresp3 if flagresp2==0 & (respond==1 | testresp3==0) & round!=10, sepby(hhid)
	  
	*	step 3 manual decision-making
		*	cases where we will take the respondent from prior rounds, respecting member values 
		recode respond (0=1) if hhid==204203011402 & hh_roster__id==2 & round==9 
		recode respond (0=1) if hhid==205107031305 & hh_roster__id==1 & round==8 
		recode respond (0=1) if hhid==405302010301 & hh_roster__id==3 & round==13 
		bys hhid round (hh_roster__id) : egen testresp4 = sum(respond)
		ta round testresp4
		*	can't really resolve the remainder 
	  drop testresp-testresp4
	
			 	  
	*	new approach, document extent of problem first 		
	 	  
			  	/*	document these cases and email to Giulia Ponzini
	preserve
	*	simpler version, but this is what we need to make sense 
	bys hhid hh_roster__id (round) : egen byte y1 = min(sex)
	by  hhid hh_roster__id (round) : egen byte y2 = max(sex)
	ta round if y1!=y2
	duplicates report hhid hh_roster__id if y1!=y2	
	dis r(unique_value)	//	11093 cases 
	qui : duplicates report hhid hh_roster__id
	dis r(unique_value)	//	19627 total individuals
	g byte xxx = (y1!=y2)
	by  hhid hh_roster__id (round) : egen byte yyy = max(xxx)
	by  hhid (hh_roster__id round) : egen byte zzz = max(yyy)
	

	keep if zzz==1
	la var xxx	"Gender switch case"
	la var yyy	"Individual gender switch flag"
	la var zzz	"HH gender switch flag"
	note: Dataset containing all households where a gender switch occurs for an individual in the public data
	compress
	sa "${tmp_hfps_uga}/uga_gender_switch_cases.dta", replace
    restore
	*	this is massive. this has to be an individual link issue
	preserve
	bys hhid hh_roster__id (round) : egen y1 = min(sex)
	by  hhid hh_roster__id (round) : egen y2 = max(sex)
	g flag = y1!=y2
	g delta = sex!=sex[_n-1] if !mi(sex) & !mi(sex[_n-1])
	ta round flag
	duplicates report hhid hh_roster__id if flag==1	
	ta round delta
	duplicates report hhid hh_roster__id if delta==1	
	restore
	
    	
	
		*	fill in with prior round information where possible
	su
	cou
	ta round if mi(age)
	ta round if mi(sex)
	ta round if mi(relation)
	ta round if mi(age) & member==1
	ta round if mi(sex) & member==1
	ta round if mi(relation) & member==1
	foreach x in age sex relation {
		tempvar maxmiss maxnmiss minnmiss modenmiss fillmiss 
	bys hhid hh_roster__id (round) : egen `maxmiss'= max(mi(`x'))
	by  hhid hh_roster__id (round) : egen `maxnmiss'= max(`x')
	by  hhid hh_roster__id (round) : egen `minnmiss'= min(`x')
	by  hhid hh_roster__id (round), rc0 : egen `modenmiss'= mode(`x')
	
	g `fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
	replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
	su `x' if `maxmiss'==1
	replace `x' = `fillmiss' if mi(`x') & !mi(`fillmiss')
	su `x' if `maxmiss'==1
	
	drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
		}
	
	 */
	*	a fix is in the works on this question
	 
// 	ren pid_ubos public_pid_ubos
// 	mer 1:1 hhid hh_roster__id round using "${hfps}/Input datasets/Uganda/private_pid_ubos.dta"
// 	ta round _m
	 
	*	drop unnecessary variables 
	compare t0_ubos_pid pid_ubos
	ta round if mi(pid_ubos)
	keep /*phase*/ round hhid hh_roster__id pid_ubos member sex age head relation respond 
	
	isid hhid hh_roster__id round
	sort hhid hh_roster__id round
	sa "${tmp_hfps_uga}/ind.dta", replace
	
	*	for Uganda, we need to replace this dataset with the private version where any differences exist 
	*	the private version is 
	log using "${hfps}/Log files/Uganda/private_vs_public_ind.txt", name(private_vs_public_ind) replace text
u "${hfps}/Input datasets/Uganda/private_ind.dta", clear
ren pid_ubos prvt_pid_ubos
mer 1:1 hhid hh_roster__id round using "${tmp_hfps_uga}/ind.dta"
ta _m
tab2 _m round respond sex head member, first m
log close private_vs_public_ind

*	use hh_roster__id panel to make demographics 
u "${hfps}/Input datasets/Uganda/private_ind.dta", clear
	sa "${tmp_hfps_uga}/ind.dta", replace

	
	
	
	