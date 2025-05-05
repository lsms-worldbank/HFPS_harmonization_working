




*	baseline surveys





dir "${final_hfps_pnl}/*.dta"
d using "${final_hfps_pnl}/price.dta"
u  "${final_hfps_pnl}/price.dta", clear
// ta round cc
// ta round cc if item_avail==1
// ta round cc if !inlist(price,0,.)
// su q kg lcu price unitcost
// ta round cc if mi(price) & item_avail==1
// cou if mi(price) & item_avail==1
// ta itemstr

keep cc round itemstr
duplicates drop
g _2=0
recode _2 (0=1) if (inlist(itemstr,"Firewood","LPG","charcoal","diesel","fuel for car","fuel for motorcycle","kerosene"))
recode _2 (0=1) if (inlist(itemstr,"paraffin","paraffin or kerosene","petrol","transport to nearest market"))

g _3=0
recode _3 (0=1) if inlist(itemstr,"soya seed","maize seed","chemical fertilizer")


egen _1 = rowmax(_?)
ta _1
replace _1=1-_1
order _?, a(round) seq

egen zzz = group(_?), label
ta zzz
tab2 itemstr _?, first

collapse (max) _?, by(cc round)

reshape long _, i(cc round) j(module)
reshape wide _, i(round module) j(cc)

replace module=module+40	//	manual update required 
tempfile price
sa		`price'


d using "${final_hfps_pnl}/access.dta"
u round cc item using "${final_hfps_pnl}/access.dta", clear
duplicates drop	//	we will use the merge result as the value to incorporate

ta item	//	let's get a little more detailed here
numlabel item, add
ta item

#d ; 
recode item 
	(1 11 12 51/57 59				=	1	"health")
	(26	58							=	2	"mask")
	(2 3 71							=	3	"soap")
	(9 10							=	4	"water")
	(4/8 14/20 22 48 49 60/69 81/90	=	5	"food")
	(13	31/39						=	6	"transit")
	(21 91/96						=	7	"fuel")
	(72								=	8	"internet")
	(40/47							=	9	"agricultural inputs")
	(25								=	10	"services")
	, gen(type); 
#d cr
inspect type
assert r(N_undoc)==0
ta item type,m

table (cc round) type, nototal
ta type, gen(_)

collapse (max) _*, by(cc round) 

reshape long _, i(cc round) j(module)
reshape wide _, i(round module) j(cc)

replace module=module+20	//	manual update required 
tempfile access
sa		`access'

*	primary dataset
u "${final_hfps_pnl}/analysis_dataset.dta", clear
ds _*
loc vars `r(varlist)'
recode `vars' (1=0)(3=1)(else=.)
for varlist `vars' : assert inlist(X,1,0)

collapse (max) `vars', by(cc round)

table round cc, stat(mean `vars') nototal	//	need this as a matrix 

*	let's actually just do as a dataset
ren _* _#, renumber
d _?

reshape long _, i(cc round) j(module)
reshape wide _, i(round module) j(cc)
append using `access' `price'
ta round module
reshape long _, i(round module) j(cc)
reshape wide _, i(cc round) j(module)
recode _* (.=0)
reshape long 
reshape wide _, i(round module) j(cc)
ta round module
la drop _all

#d ; 
la def module 1 "Cover" 2 "Demographics" 3 "Employment" 4 "FIES" 5 "Dietary Diversity"	
	6 "Shocks" 7 "Subjective welfare" 8 "Economic sentiment" 9 "Agriculture"	
	21 "Access - Health" 22 "Access - COVID Specific" 23 "Access - Soap" 
	24 "Access - Water" 25 "Access - Food" 26 "Access - Transit"
	27 "Access - Fuel" 28 "Access - Internet" 29 "Access - Ag inputs"
	30 "Access - Services"
	41 "Price - Food" 42 "Price - Fuel" 43 "Price - Ag inputs"
; 
#d cr
la val module module
inspect module
assert r(N_undoc)==0

la var round	"Survey round"
la var module	"Module"
la var _1	"Burkina Faso"
la var _2	"Ethiopia"
la var _3	"Malawi"
la var _4	"Nigeria"
la var _5	"Tanzania"
la var _6	"Uganda"
ta module

cap : drop modstr
cap : drop submod
decode module, gen(modstr)
decode module, gen(submod)
order modstr submod, a(module)
replace modstr="Access" if substr(modstr,1,6)=="Access"
replace modstr="Price" if substr(modstr,1,5)=="Price"
replace submod = substr(submod,10,length(submod)-9) if substr(modstr,1,6)=="Access"
replace submod = substr(submod,9,length(submod)-8) if substr(modstr,1,5)=="Price"
la var modstr	"Module"
la var submod	"Sub-module"

export excel round modstr submod _* using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx"	/*
*/	, sheet("modules_mk1", replace) cell(A3) firstrow(varlabels)



preserve
collapse (sum) _*, by(module modstr submod)
la var _1	"Burkina Faso"
la var _2	"Ethiopia"
la var _3	"Malawi"
la var _4	"Nigeria"
la var _5	"Tanzania"
la var _6	"Uganda"

d
sort module
li, sep(0)

export excel modstr submod _* using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx"	/*
*/	, sheet("modules_mk2", replace) cell(B3) firstrow(varlabels)
restore






*	extract text notes that have been manually entered in excel 
import excel using "/Users/joshbrubaker/Dropbox/Consulting/WB/HFPS2/Excel documentation/Harmonized Panel Dictionary.xlsx", describe
import excel using "/Users/joshbrubaker/Dropbox/Consulting/WB/HFPS2/Excel documentation/Harmonized Panel Dictionary.xlsx",  	/*
*/	sheet("analysis_dataset_working") firstrow case(lower) cellrange(A3) clear
isid variablename
ren ( variablename variablelabel)( name varlab)
tempfile bringnotes
sa		`bringnotes'

*	export basic decription of contents 
dir "${final_hfps_pnl}"
u	"${final_hfps_pnl}/analysis_dataset.dta", clear

d, replace clear
// g notes = "" 
mer 1:1 name using `bringnotes', keepus(notes)
replace notes = "Dropped" if _merge==2
replace notes = "NEW NEW NEW" if _merge==1
la var notes "Notes"
drop if _merge==2

g module = varlab if substr(name,1,1)=="_", b(name)
la var module	"Module"
li module name position, sepby(module)
su position, meanonly
g invpos = `r(max)'-position
sort invpos
replace module = module[_n-1] if mi(module)
bys module (position) : replace module = "" if _n>1
sort position
li module name position, sepby(module)	//	leave like this for now

keep module name varlab notes
li, sepby(module) string(32)

export excel using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("analysis_dataset", replace) first(varlabel) cell(A3)

*	has the _* results already to provide natural breaks there 





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


