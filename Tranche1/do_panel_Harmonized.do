




********************************************************************************
********************************************************************************

*************   *******      **     **    **  ********  **         *************
*************   ********    ****    **    **  ********  **         *************
*************   **    **   **  **   **    **  **        **         *************
*************   **    **  **    **  ***   **  **        **         *************
*************   ********  ********  ****  **  *****     **         *************
*************   *******   ********  ** ** **  *****     **         *************
*************   **        **    **  **  ****  **        **         *************
*************   **        **    **  **   ***  **        **         *************
*************   **        **    **  **    **  ********  ********   *************
*************   **        **    **  **    **  ********  ********   *************

********************************************************************************
********************************************************************************


********************************************************************************
{	/*	Cover	*/ 
********************************************************************************

gl subject cover
cap : noi : d using "${local_storage}/tmp_BFA_pnl_${subject}.dta", s
cap : noi : d using "${local_storage}/tmp_ETH_pnl_${subject}.dta", s
cap : noi : d using "${local_storage}/tmp_MWI_pnl_${subject}.dta", s
cap : noi : d using "${local_storage}/tmp_NGA_pnl_${subject}.dta", s
cap : noi : d using "${local_storage}/tmp_TZA_pnl_${subject}.dta", s
cap : noi : d using "${local_storage}/tmp_UGA_pnl_${subject}.dta", s

cap : noi : u "${local_storage}/tmp_BFA_pnl_${subject}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_pnl_${subject}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_pnl_${subject}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_pnl_${subject}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_pnl_${subject}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_pnl_${subject}.dta", clear


foreach x in bfa eth mwi nga tza uga {
	loc X = upper("`x'")
u "${local_storage}/tmp_`X'_pnl_${subject}.dta", clear
d, varlist
loc hhid : word 1 of `r(sortlist)'
g `x'_hhid = `hhid'
la var `x'_hhid	"`hhid' = `X' HH identifier"
keep phase round `x'_hhid pnl_* start_*
tempfile `x'
sa		``x''
}
clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var pnl_intclock		"Time and date of survey"
la var pnl_intdate		"Date of survey"
la var start_yr			"Year of survey"
la var start_mo			"Month of survey"
la var start_dy			"Day of survey"

la var pnl_hhid		"Household ID Code"
la var pnl_admin1	"Admin unit 1"
la var pnl_admin2	"Admin unit 2"
la var pnl_admin3	"Admin unit 3"
la var pnl_urban	"Urban=1"
la var pnl_wgt		"Sample weight"


order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subject}.dta", replace


********************************************************************************
}	/*	end Cover	*/ 
********************************************************************************


********************************************************************************
{	/*	Individual	*/ 
********************************************************************************

gl subject ind 
d using "${local_storage}/tmp_BFA_${subject}.dta"
d using "${local_storage}/tmp_ETH_${subject}.dta"
d using "${local_storage}/tmp_MWI_${subject}.dta"
d using "${local_storage}/tmp_NGA_${subject}.dta"
d using "${local_storage}/tmp_TZA_${subject}.dta"
d using "${local_storage}/tmp_UGA_${subject}.dta"


*	relation codes are mostly 1-15, but not entirely harmonized. 
*	BFA is simplified to 10 codes, which we can align the others to fairly
	*	easily, mainly coding in-laws into the major groups
u "${local_storage}/tmp_BFA_${subject}.dta", clear
la li relation
g pnl_rltn=relation
la var pnl_rltn		"Relationship to household head"
la copy relation pnl_rltn
la val pnl_rltn pnl_rltn
mer m:1 hhid round using "${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid membres__id relation)(bfa_hhid bfa_indid bfa_rltn)
la copy relation bfa_rltn
la val	bfa_rltn bfa_rltn 
la var  bfa_rltn	"Relationship to household head"
g pnl_indid=bfa_indid
la var bfa_indid		"membres__id"
la var pnl_indid		"Individual ID"
tempfile bfa
sa		`bfa'

u "${local_storage}/tmp_ETH_${subject}.dta", clear
la li relation
recode relation (-99 -98=.)(1=1)(2=2)(3 9=3)(5 10=4)(4=5)(12=6)(6 11=7)(7 8 13=8)(15=9)(14=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn
mer m:1 household_id round using "${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (household_id individual_id relation)(eth_hhid eth_indid eth_rltn)
la copy relation eth_rltn
la val  eth_rltn eth_rltn 
la var  eth_rltn	"Relationship to household head"
g pnl_indid=eth_indid
la var eth_indid		"individual_id"
la var pnl_indid		"Individual ID"
tempfile eth
sa		`eth'



u "${local_storage}/tmp_MWI_${subject}.dta", clear
la li relation
recode relation (1=1)(2=2)(3 8=3)(6 11=4)(4=5)(10=6)(7 9=7)(5 12 98=8)(14 15 16=9)(13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m
mer m:1 y4_hhid round using "${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (y4_hhid pid relation)(mwi_hhid mwi_indid mwi_rltn)
la copy relation mwi_rltn
la val  mwi_rltn mwi_rltn 
la var  mwi_rltn	"Relationship to household head"
g pnl_indid=mwi_indid
la var mwi_indid		"pid"
la var pnl_indid		"Individual ID"
tempfile mwi
sa		`mwi'



u "${local_storage}/tmp_NGA_${subject}.dta", clear
la li relation	// no grandparent code
recode relation (1=1)(2=2)(3/5=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m
ta round if relation==16
ta round if relation==98
recode pnl_rltn (16=3)(98=8)
	*	round 8 is the first round with both codes present
	*	investigation implemented in ${do_hfps_nga}/demographics.do

mer m:1 hhid round using "${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid indiv relation)(nga_hhid nga_indid nga_rltn)
la copy relation nga_rltn
la val  nga_rltn nga_rltn 
la var  nga_rltn	"Relationship to household head"
g pnl_indid=nga_indid
la var nga_indid		"indiv"
la var pnl_indid		"Individual ID"
tempfile nga
sa		`nga'



u "${local_storage}/tmp_TZA_${subject}.dta", clear
la li relation	//	no grandparent code 
recode relation (1=1)(2=2)(3/5 16=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m

mer m:1 hhid round using "${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid indiv relation)(tza_hhid tza_indid tza_rltn)
la copy relation tza_rltn
la val  tza_rltn tza_rltn 
la var  tza_rltn	"Relationship to household head"
g pnl_indid=tza_indid
la var tza_indid		"indiv"
la var pnl_indid		"Individual ID"
tempfile tza
sa		`tza'



u "${local_storage}/tmp_UGA_${subject}.dta", clear
la li relation
recode relation (1=1)(2=2)(3/5=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m

mer m:1 hhid round using "${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid hh_roster__id relation)(uga_hhid uga_indid uga_rltn)
la copy relation uga_rltn
la val  uga_rltn uga_rltn 
la var  uga_rltn	"Relationship to household head"
g pnl_indid=uga_indid
la var uga_indid		"hh_roster__id"
la var pnl_indid		"Individual ID"
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 

isid  cc round pnl_hhid pnl_indid
order cc round pnl_hhid pnl_indid
sort  cc round pnl_hhid pnl_indid

drop ind_id_EHCVM pid_ubos

la var member	"Individual is currently a member of the household"
la var sex	"Sex"
la def sex 1 "Male" 2 "Female"
la val sex sex
la var age	"Age (years)"
recode age (0/14=1)(15/64=2)(65/max=3), gen(agecat)
la def agecat	1 "Aged 0-14" 2 "Aged 15-64" 3 "Aged 65 and above"
order agecat, a(age)
la var agecat	"Age category"
la var head		"Head of household=1"
la var respond	"Main respondent"

ta pnl_rltn cc, m
recode pnl_rltn (6=8)(.a=.)	//	code grandparent in with "other relative"

table round cc, stat(sum respond)
by  cc round pnl_hhid (pnl_indid) : egen respcount = sum(respond==1)
assert respcount<=1
ta respcount
ta round cc if respcount!=1	//	dominated by UGA round 10
drop respcount
ta respond member,m	//	ignore this inconsistency for now
ta round cc if respond==1 & member!=1	//	primarily MWI round 10, secondarily NGA round 13

by cc round pnl_hhid (pnl_indid) : egen resp_sex		= max(sex		* cond(respond==1,1,.))
by cc round pnl_hhid (pnl_indid) : egen resp_mal		= max((sex==1)	* cond(respond==1,1,.))
by cc round pnl_hhid (pnl_indid) : egen resp_fem		= max((sex==2)	* cond(respond==1,1,.))
by cc round pnl_hhid (pnl_indid) : egen resp_age		= max(age		* cond(respond==1,1,.))
by cc round pnl_hhid (pnl_indid) : egen resp_agecat		= max(agecat	* cond(respond==1,1,.))
by cc round pnl_hhid (pnl_indid) : egen resp_head		= max(head		* cond(respond==1,1,.))

			la var resp_sex			"Sex of respondent"
			la var resp_mal			"Male respondent"
			la var resp_fem			"Female respondent"
			la var resp_age			"Age of respondent"
			la var resp_agecat		"Age category of respondent"
			la var resp_head		"Respondent is HH Head"

			
order bfa_* eth_* mwi_* nga_* tza_* uga_*, a(resp_head)



			
sa "${local_storage}/tmp_panel_individual.dta", replace


********************************************************************************
}	/*	Individual end	*/ 
********************************************************************************


********************************************************************************
{	/*	Demographics	*/ 
********************************************************************************


gl subj demog

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


            la var hhsize	"Household size"	  	
            la var m0_14	"Number of males aged 0 to 14"
            la var m15_64	"Number of males aged 15 to 64"
            la var m65		"Number of males aged 65 and above"
            la var f0_14	"Number of females aged 0 to 14"
            la var f15_64	"Number of females aged 15 to 64"
            la var f65		"Number of females aged 65 and above"	     	
            la var adulteq	"Adult equivalents"		
			
			la var resp_sex			"Sex of respondent"
			la var resp_age			"Age of respondent"
			la var resp_head		"Respondent is HH Head"
			la var resp_relation	"Respondent relationshiop to HH Head"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace





********************************************************************************
}	/*	Demographics end	*/ 
********************************************************************************


********************************************************************************
{	/*	Employment	*/ 
********************************************************************************


gl subj employment

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace




********************************************************************************
}	/*	Employment end	*/ 
********************************************************************************


********************************************************************************
{	/*	FIES	*/ 
********************************************************************************


gl subj fies

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace



********************************************************************************
}	/*	FIES end	*/ 
********************************************************************************


********************************************************************************
{	/*	Dietary Diversity	*/ 
********************************************************************************



gl subj dietary_diversity

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel with < 6 countries 

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'

/*
u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'
*/ 

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' /*`eth' `mwi' `nga'*/ `tza' `uga', gen(cc)
la drop _append
replace cc = cc+3 if cc>1	//	account for missing countries 
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace





********************************************************************************
}	/*	Dietary Diversity end	*/ 
********************************************************************************


********************************************************************************
{	/*	Shocks / Coping	*/ 
********************************************************************************

	

gl subj hh_shocks

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen

isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace



********************************************************************************
}	/*	Shocks / Coping end	*/ 
********************************************************************************


********************************************************************************
{	/*	Price	*/ 
********************************************************************************


gl subj price

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer m:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr 
sort pnl_hhid round itemstr 
drop hhid item
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer m:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round itemstr 
sort pnl_hhid round itemstr 
drop household_id item
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer m:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
sort pnl_hhid round itemstr
drop y4_hhid item
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer m:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
sort pnl_hhid round itemstr
drop hhid item
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer m:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr 
sort pnl_hhid round itemstr
drop hhid item
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer m:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round itemstr
sort pnl_hhid round itemstr
drop hhid item
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta itemstr cc
la var itemstr		"Item code (string)"
la var unitstr		"Unit code (string)"

order cc round pnl_hhid itemstr
isid  cc round pnl_hhid itemstr
sort  cc round pnl_hhid itemstr
sa "${local_storage}/tmp_panel_${subj}.dta", replace



********************************************************************************
}	/*	Price end	*/ 
********************************************************************************


********************************************************************************
{	/*	Economic Sentiment	*/ 
********************************************************************************



gl subj economic_sentiment

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace



********************************************************************************
}	/*	Economic Sentiment end	*/ 
********************************************************************************


********************************************************************************
{	/*	Subjective Welfare	*/ 
********************************************************************************



gl subj subjective_welfare

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'

/*
u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'
*/

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' /*`mwi'*/ `nga' `tza' `uga', gen(cc)
la drop _append
replace cc=cc+1 if cc>2
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace



********************************************************************************
}	/*	Subjective Welfare end	*/ 
********************************************************************************


********************************************************************************
{	/*	Agriculture	*/ 
********************************************************************************



gl subj agriculture

cap : noi : d using "${local_storage}/tmp_BFA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_ETH_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_MWI_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_NGA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_TZA_${subj}.dta"
cap : noi : d using "${local_storage}/tmp_UGA_${subj}.dta"

cap : noi : u "${local_storage}/tmp_BFA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_ETH_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_NGA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_TZA_${subj}.dta", clear
cap : noi : u "${local_storage}/tmp_UGA_${subj}.dta", clear





cap : noi : u "${local_storage}/tmp_MWI_${subj}.dta", clear
d, varlist
ds `r(sortlist)', not
d `r(varlist)', replace clear
tempfile varlabs
sa		`varlabs'



*	make standard hh level panel

u							"${local_storage}/tmp_BFA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_BFA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid
tempfile bfa
sa		`bfa'


u									"${local_storage}/tmp_ETH_${subj}.dta", clear
mer 1:1 household_id round using	"${local_storage}/tmp_ETH_pnl_cover.dta", keepus(pnl_hhid) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop household_id 
tempfile eth
sa		`eth'


u 							"${local_storage}/tmp_MWI_${subj}.dta", clear
mer 1:1 y4_hhid round using	"${local_storage}/tmp_MWI_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop y4_hhid 
tempfile mwi
sa		`mwi'

u							"${local_storage}/tmp_NGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_NGA_pnl_cover.dta", keepus(pnl_hhid round) assert(2 3) keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile nga
sa		`nga'

u							"${local_storage}/tmp_TZA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_TZA_pnl_cover.dta", keepus(pnl_hhid round) /*assert(2 3)*/ keep(3) nogen
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile tza
sa		`tza'

u							"${local_storage}/tmp_UGA_${subj}.dta", clear
mer 1:1 hhid round using	"${local_storage}/tmp_UGA_pnl_cover.dta", keepus(pnl_hhid round) //	assert(2 3) keep(3) nogen
keep if _m==3
drop _m
isid pnl_hhid round 
sort pnl_hhid round 
drop hhid 
tempfile uga
sa		`uga'



clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 
la var cc	"Country Code"
la var round "Survey Round"
la var pnl_hhid		"Household ID Code"


ta round cc

mer 1:1 _n using `varlabs', keepus(name varlab) nogen
cou if !mi(name)
forv r=1/`=r(N)' {
	la var `=name[`r']' "`=varlab[`r']'"
}
drop name varlab

order cc round pnl_hhid
isid  cc round pnl_hhid
sort  cc round pnl_hhid
sa "${local_storage}/tmp_panel_${subj}.dta", replace


********************************************************************************
}	/*	Agriculture end	*/ 
********************************************************************************

ex

********************************************************************************
{	/*		*/ 
********************************************************************************

********************************************************************************
}	/*	end	*/ 
********************************************************************************


