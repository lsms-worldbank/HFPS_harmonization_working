



d using "${tmp_hfps_bfa}/cover.dta"
d using "${tmp_hfps_eth}/cover.dta"
d using "${tmp_hfps_mwi}/cover.dta"
d using "${tmp_hfps_nga}/cover.dta"
d using "${tmp_hfps_tza}/cover.dta"
d using "${tmp_hfps_uga}/cover.dta"

d using "${tmp_hfps_bfa}/demog.dta"
d using "${tmp_hfps_eth}/demog.dta"
d using "${tmp_hfps_mwi}/demog.dta"
d using "${tmp_hfps_nga}/demog.dta"
d using "${tmp_hfps_tza}/demog.dta"
d using "${tmp_hfps_uga}/demog.dta"

u "${tmp_hfps_bfa}/demog.dta", clear
qui : d, varlist
loc hhid = subinstr("`r(sortlist)'","round","",1) 
ds `hhid', not(varl round)
mer 1:1 `hhid' round using "${tmp_hfps_bfa}/pnl_cover.dta", keepus(pnl_hhid) gen(_demog)
ren `hhid' bfa_hhid
ta round _demog

	*	one-off setup for troubleshooting
loc x nga
u "${tmp_hfps_`x'}/demog.dta", clear
qui : d, varlist
loc hhid = subinstr("`r(sortlist)'","round","",1) 
mer 1:1 `hhid' round using "${tmp_hfps_`x'}/pnl_cover.dta", /*keepus(pnl_hhid)*/ gen(_demog)
ta round _demog
ta s12q5 _demog



u "${tmp_hfps_bfa}/demog.dta", clear
u "${tmp_hfps_eth}/demog.dta", clear
u "${tmp_hfps_mwi}/demog.dta", clear
u "${tmp_hfps_nga}/demog.dta", clear
u "${tmp_hfps_tza}/demog.dta", clear
u "${tmp_hfps_uga}/demog.dta", clear


foreach x in bfa eth mwi nga tza uga {
u "${tmp_hfps_`x'}/demog.dta", clear
qui : d, varlist
loc hhid = subinstr("`r(sortlist)'","round","",1) 
mer 1:1 `hhid' round using "${tmp_hfps_`x'}/pnl_cover.dta", keepus(pnl_hhid) gen(_demog)
la var `hhid'	"`hhid' - `: var lab `hhid''"
ren `hhid' `x'_hhid
order pnl_hhid, a(round)
// order `x'_hhid, a(_demog)
tempfile `x'
sa		``x''
}
clear
append using `bfa' `eth' `mwi' `nga' `tza' `uga', gen(cc)
la drop _append
la def cc 1 "BFA" 2 "ETH" 3 "MWI" 4 "NGA" 5 "TZA" 6 "UGA"
la val cc cc 

ta cc _demog
keep if _demog==3
drop _demog

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


*	now simpler to drop the round-specific hhid variables here
drop bfa_hhid eth_hhid mwi_hhid nga_hhid tza_hhid uga_hhid

isid cc round pnl_hhid
sort cc round pnl_hhid
order cc round pnl_hhid
sa "${tmp_hfps_pnl}/demog.dta", replace
ex
