



*	export basic decription of contents 
u	"${final_hfps_pnl}/analysis_dataset.dta", clear
ta round cc,m

*	what about a temporal element here 
g yearmo = mofd(pnl_intdate)
format yearmo %tm
table yearmo cc, nototal	//	nice, but murkier about the source of content, and some issues in TZ 

ta round cc,m


u cc round using "${tmp_hfps_pnl}/cover.dta", clear
duplicates drop
la li cc
la def country 1 "Burkina Faso" 2 "Ethiopia" 3 "Malawi" 4 "Nigeria" 5 "Tanzania" 6 "Uganda"
la val cc country
decode cc, gen(country)

sa "${tmp_hfps_pnl}/cc_round.dta", replace 




u "${tmp_hfps_pnl}/cover.dta", clear
ds cc round pnl_hhid, not
gl vars `r(varlist)'
d ${vars}, replace clear
keep name varlab
export excel using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("cover", replace) first(var) cell(A3)

u "${tmp_hfps_pnl}/cover.dta", clear
foreach s of global vars {
	g ___zzz = (!mi(`s')), a(`s')
	la var ___zzz "`: var lab `s''"
	drop `s'
	ren ___zzz `s'
}
collapse (max) ${vars}, by(cc round)
mer 1:1 cc round using "${tmp_hfps_pnl}/cc_round.dta", nogen
sort cc round
mkmat ${vars}, mat(long) roweq(country) rown(round) rowprefix("R")
mat wide = long'
putexcel set "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("cover") modify 
putexcel c2=mat(wide), colnames
putexcel c2:y2 z2:ar2 as2:bm2 bn2:cj2 ck2:cu2 cv2:dm2, merge




dir "${tmp_hfps_pnl}"
foreach x in demog employment fies dietary_diversity hh_shocks subjective_welfare price economic_sentiment agriculture access gff {
u "${tmp_hfps_pnl}/`x'.dta", clear
ds cc round pnl_hhid, not
gl vars `r(varlist)'
d ${vars}, replace clear
keep name varlab
export excel using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("`x'", replace) first(var) cell(A3)

u "${tmp_hfps_pnl}/`x'.dta", clear
foreach s of global vars {
	g ___zzz = (!mi(`s')), a(`s')
	la var ___zzz "`: var lab `s''"
	drop `s'
	ren ___zzz `s'
}
collapse (max) ${vars}, by(cc round)
mer 1:1 cc round using "${tmp_hfps_pnl}/cc_round.dta", nogen
sort cc round
mkmat ${vars}, mat(long) roweq(country) rown(round) rowprefix("R")
mat wide = long'
putexcel set "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("`x'") modify 
putexcel c2=mat(wide), colnames
putexcel c2:y2 z2:ar2 as2:bm2 bn2:cj2 ck2:cu2 cv2:dm2, merge

}


