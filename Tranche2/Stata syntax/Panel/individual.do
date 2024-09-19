



d using "${tmp_hfps_bfa}/panel/cover.dta"
d using "${tmp_hfps_eth}/panel/cover.dta"
d using "${tmp_hfps_mwi}/panel/cover.dta"
d using "${tmp_hfps_nga}/panel/cover.dta"
d using "${tmp_hfps_tza}/panel/cover.dta"
d using "${tmp_hfps_uga}/panel/cover.dta"

d using "${tmp_hfps_bfa}/panel/demog.dta"
d using "${tmp_hfps_eth}/panel/demog.dta"
d using "${tmp_hfps_mwi}/panel/demog.dta"
d using "${tmp_hfps_nga}/panel/demog.dta"
d using "${tmp_hfps_tza}/panel/demog.dta"
d using "${tmp_hfps_uga}/panel/demog.dta"

d using "${tmp_hfps_bfa}/panel/ind.dta"
d using "${tmp_hfps_eth}/panel/ind.dta"
d using "${tmp_hfps_mwi}/panel/ind.dta"
d using "${tmp_hfps_nga}/panel/ind.dta"
d using "${tmp_hfps_tza}/panel/ind.dta"
d using "${tmp_hfps_uga}/panel/ind.dta"


*	relation codes are mostly 1-15, but not entirely harmonized. 
*	BFA is simplified to 10 codes, which we can align the others to fairly
	*	easily, mainly coding in-laws into the major groups
u "${tmp_hfps_bfa}/panel/ind.dta", clear
la li relation
g pnl_rltn=relation
la var pnl_rltn		"Relationship to household head"
la copy relation pnl_rltn
la val pnl_rltn pnl_rltn
mer m:1 hhid round using "${tmp_hfps_bfa}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid membres__id relation)(bfa_hhid bfa_indid bfa_rltn)
la copy relation bfa_rltn
la val bfa_rltn bfa_rltn 
g pnl_indid=bfa_indid
la var bfa_indid		"membres__id"
la var pnl_indid		"Individual ID"
tempfile bfa
sa		`bfa'

u "${tmp_hfps_eth}/panel/ind.dta", clear
la li relation
recode relation (-99 -98=.)(1=1)(2=2)(3 9=3)(5 10=4)(4=5)(12=6)(6 11=7)(7 8 13=8)(15=9)(14=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn
mer m:1 household_id round using "${tmp_hfps_eth}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (household_id individual_id relation)(eth_hhid eth_indid eth_rltn)
la copy relation eth_rltn
la val  eth_rltn eth_rltn 
g pnl_indid=eth_indid
la var eth_indid		"individual_id"
la var pnl_indid		"Individual ID"
tempfile eth
sa		`eth'



u "${tmp_hfps_mwi}/panel/ind.dta", clear
la li relation
recode relation (1=1)(2=2)(3 8=3)(6 11=4)(4=5)(10=6)(7 9=7)(5 12 98=8)(14 15 16=9)(13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m
mer m:1 y4_hhid round using "${tmp_hfps_mwi}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (y4_hhid pid relation)(mwi_hhid mwi_indid mwi_rltn)
la copy relation mwi_rltn
la val  mwi_rltn mwi_rltn 
g pnl_indid=mwi_indid
la var mwi_indid		"pid"
la var pnl_indid		"Individual ID"
tempfile mwi
sa		`mwi'



u "${tmp_hfps_nga}/panel/ind.dta", clear
la li relation	// no grandparent code
recode relation (1=1)(2=2)(3/5=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m
ta round if relation==16
ta round if relation==98
recode pnl_rltn (16=3)(98=8)
	*	round 8 is the first round with both codes present
	*	investigation implemented in ${do_hfps_nga}/demographics.do

mer m:1 hhid round using "${tmp_hfps_nga}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid indiv relation)(nga_hhid nga_indid nga_rltn)
la copy relation nga_rltn
la val  nga_rltn nga_rltn 
g pnl_indid=nga_indid
la var nga_indid		"indiv"
la var pnl_indid		"Individual ID"
tempfile nga
sa		`nga'



u "${tmp_hfps_tza}/panel/ind.dta", clear
la li relation	//	no grandparent code 
recode relation (1=1)(2=2)(3/5 16=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m

mer m:1 hhid round using "${tmp_hfps_tza}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid indiv relation)(tza_hhid tza_indid tza_rltn)
la copy relation tza_rltn
la val  tza_rltn tza_rltn 
g pnl_indid=tza_indid
la var tza_indid		"indiv"
la var pnl_indid		"Individual ID"
tempfile tza
sa		`tza'



u "${tmp_hfps_uga}/panel/ind.dta", clear
la li relation
recode relation (1=1)(2=2)(3/5=3)(10 11=4)(6=5)(7 9=7)(8 14=8)(15=9)(12 13=10), gen(pnl_rltn)
la var pnl_rltn		"Relationship to household head"
ta relation pnl_rltn, m

mer m:1 hhid round using "${tmp_hfps_uga}/panel/pnl_cover.dta", keepus(pnl_hhid) keep(3) nogen nolabel
ren (hhid hh_roster__id relation)(uga_hhid uga_indid uga_rltn)
la copy relation uga_rltn
la val  uga_rltn uga_rltn 
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

la var sex	"Sex"
la def sex 1 "Male" 2 "Female"
la val sex sex
la var age	"Age (years)"
recode age (0/14=1)(15/64=2)(65/max=3), gen(agecat)
la def agecat	1 "Aged 0-14" 2 "Aged 15-64" 3 "Aged 65 and above"
order agecat, a(age)
la var agecat	"Age category"

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



			
sa "${tmp_hfps_pnl}/individual.dta", replace

ex

u "${tmp_hfps_pnl}/individual.dta", clear
ta pnl_rltn head
bys cc round pnl_hhid (pnl_indid) : egen headcount = sum(pnl_rltn==1 & member==1)
bys cc round pnl_hhid (pnl_indid) : egen headcount2 = sum(head==1)
ta headcount
ta head member,m
ta headcount2

