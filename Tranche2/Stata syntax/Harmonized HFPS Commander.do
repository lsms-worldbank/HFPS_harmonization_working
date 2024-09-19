


********************************************************************************
********************************************************************************

******************   **    **  ********  *******    ******    ******************
******************   **    **  ********  ********  ********   ******************
******************   **    **  **        **    **  **    **   ******************
******************   **    **  **        **    **  **         ******************
******************   ********  *****     ********  ********   ******************
******************   ********  *****     *******    *******   ******************
******************   **    **  **        **              **   ******************
******************   **    **  **        **        **    **   ******************
******************   **    **  **        **        ********   ******************
******************   **    **  **        **         ******    ******************

********************************************************************************
********************************************************************************

*	This do-file sets the context for the creation of a harmonized dataset 
*	across all rounds of the HFPS in the following countries.  

*	Burkina Faso
*	Ethiopia
*	Malawi
*	Nigeria
*	Tanzania
*	Uganda


clear all 
matrix drop _all 
macro drop _all
set more off, permanently 
set type double, permanently
set scrollbufsize 500000

*	analyst specific macros to locate raw data on analyst's system
if c(username)=="joshbrubaker" {
	run "/Users/joshbrubaker/Dropbox/Consulting/stata_tools/startup.do"
	gl hfps "${dbox}/Consulting/WB/HFPS2"

	gl hfps_github	"${github}/HFPS_harmonization_working"
	

*	Data are downloaded as of 4 Jan 2023 from microdata.worldbank.org
*	raw data macros will necessarily be user-specific (not contained within the HFPS folder)

*	Update, data are downloaded as of 14 Mar 2023, excl Tanzania which is not currently available in Stata format

dir "${bf}/Raw Data"
// gl raw_hfps_bfa		"${bf}/Raw Data/BFA_2020-2023_HFPS_v20_M_Stata"
gl raw_hfps_bfa		"${bf}/Raw Data/BFA_2020-2024_HFPS_v21_M_Stata"
gl raw_lsms_bfa 	"${bf}/Raw Data/BFA_2018_EHCVM_v03_M_Stata"

dir "${et}/LSMS"
gl raw_hfps_eth		"${et}/LSMS/ETH_2020-2024_HFPS_v14_M_Stata"
// gl raw_hfps_eth2	"${et}/LSMS/Round 19 or P2 R7 ET HFPS Data for  Microdata Library"
gl raw_lsms_eth1	"${et}/LSMS/ESS_LSMS_2018/ETH_2018_ESS_v02_M_Stata"
gl raw_lsms_eth2	"${et}/LSMS/ESS_LSMS_2021/ETH_2021_ESPS-W5_v01_M_Stata"

dir "${mw}/LSMS"
gl raw_hfps_mwi		"${mw}/LSMS/HFPS/MWI_2020-2024_HFPS_v19_M_Stata"
gl raw_lsms_mwi		"${mw}/LSMS/2022_Feb_07/MWI_2010-2019_IHPS_v05_M_Stata"

dir "${ng}/LSMS"
gl raw_hfps_nga1	"${ng}/LSMS/HFPS/NGA_2020_NLPS_v12_M_Stata"
gl raw_hfps_nga2	"${ng}/LSMS/HFPS/NGA_2021-2023_NLPS_v07_M_Stata"
gl raw_lsms_nga		"${ng}/LSMS/GHS Panel 2018-19 Wave 4/NGA_2018_GHSP-W4_v03_M_Stata12"

dir "${tz}/Raw Data"
gl raw_hfps_tza		"${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v07_M_Stata12"	//	v05 not available in stata format
gl raw_lsms_tza		"${tz}/Raw Data/LSMS 2018:19/TZA_2019_NPD-SDD_v04_M_STATA12"

dir "${ug}/LSMS"
gl raw_hfps_uga		"${ug}/LSMS/UGA_2020-2024_HFPS_v17_M_STATA14"	
gl raw_lsms_uga		"${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14"


	}
	
*	validation that the macros set above include the name for the public folder version this syntax uses
assert strpos("${raw_hfps_bfa}","BFA_2020-2024_HFPS_v21_M_Stata")>0
assert strpos("${raw_lsms_bfa}","BFA_2018_EHCVM_v03_M_Stata")>0
assert strpos("${raw_hfps_eth}","ETH_2020-2024_HFPS_v14_M_Stata")>0
assert strpos("${raw_lsms_eth1}","ETH_2018_ESS_v02_M_Stata")>0
assert strpos("${raw_lsms_eth2}","ETH_2021_ESPS-W5_v01_M_Stata")>0
assert strpos("${raw_hfps_mwi}","MWI_2020-2024_HFPS_v19_M_Stata")>0
assert strpos("${raw_lsms_mwi}","MWI_2010-2019_IHPS_v05_M_Stata")>0
assert strpos("${raw_hfps_nga1}","NGA_2020_NLPS_v12_M_Stata")>0
assert strpos("${raw_hfps_nga2}","NGA_2021-2023_NLPS_v07_M_Stata")>0
assert strpos("${raw_lsms_nga}","NGA_2018_GHSP-W4_v03_M_Stata12")>0
assert strpos("${raw_hfps_tza}","TAZ_2021-2024_HFWMPS_v07_M_Stata12")>0
assert strpos("${raw_lsms_tza}","TZA_2019_NPD-SDD_v04_M_STATA12")>0
assert strpos("${raw_hfps_uga}","UGA_2020-2024_HFPS_v17_M_STATA14")>0
assert strpos("${raw_lsms_uga}","UGA_2019_UNPS_v03_M_STATA14")>0

	

	

cd  "${hfps}"
dir "${hfps}"

gl do_hfps_bfa		"${hfps}/Stata syntax/Burkina Faso"
gl do_hfps_eth		"${hfps}/Stata syntax/Ethiopia"
gl do_hfps_mwi		"${hfps}/Stata syntax/Malawi"
gl do_hfps_nga		"${hfps}/Stata syntax/Nigeria"
gl do_hfps_tza		"${hfps}/Stata syntax/Tanzania"
gl do_hfps_uga		"${hfps}/Stata syntax/Uganda"
gl do_hfps_pnl		"${hfps}/Stata syntax/Panel"
gl do_hfps_util		"${hfps}/Stata syntax/Utility"	//	this will be the ado repository 
adopath + "${do_hfps_util}"
dir "${do_hfps_util}"

gl tmp_hfps_bfa		"${hfps}/Temporary datasets/Burkina Faso"
gl tmp_hfps_eth		"${hfps}/Temporary datasets/Ethiopia"
gl tmp_hfps_mwi		"${hfps}/Temporary datasets/Malawi"
gl tmp_hfps_nga		"${hfps}/Temporary datasets/Nigeria"
gl tmp_hfps_tza		"${hfps}/Temporary datasets/Tanzania"
gl tmp_hfps_uga		"${hfps}/Temporary datasets/Uganda"
gl tmp_hfps_pnl		"${hfps}/Temporary datasets/Panel"

gl final_hfps_bfa	"${hfps}/Final datasets/Burkina Faso"
gl final_hfps_eth	"${hfps}/Final datasets/Ethiopia"
gl final_hfps_mwi	"${hfps}/Final datasets/Malawi"
gl final_hfps_nga	"${hfps}/Final datasets/Nigeria"
gl final_hfps_tza	"${hfps}/Final datasets/Tanzania"
gl final_hfps_uga	"${hfps}/Final datasets/Uganda"
gl final_hfps_pnl	"${hfps}/Final datasets/Panel"

gl excel_hfps_bfa	"${hfps}/Excel documentation/Burkina Faso"	
gl excel_hfps_eth	"${hfps}/Excel documentation/Ethiopia"		
gl excel_hfps_mwi	"${hfps}/Excel documentation/Malawi"		
gl excel_hfps_nga	"${hfps}/Excel documentation/Nigeria"		
gl excel_hfps_tza	"${hfps}/Excel documentation/Tanzania"		
gl excel_hfps_uga	"${hfps}/Excel documentation/Uganda"		
gl excel_hfps_pnl	"${hfps}/Excel documentation/Panel"			

*	extract previous work for inclusion here 
loc fies 	"${wb}/LSMS-ISA High-Frequency Phone Surveys on COVID-19/Syntax Files and Processed Data/FIES Estimation"
gl fies_hfps_bfa 	"`fies'/Phone Surveys/Burkina Faso"	
gl fies_hfps_eth 	"`fies'/Phone Surveys/Ethiopia"		
gl fies_hfps_mwi 	"`fies'/Phone Surveys/Malawi"		
gl fies_hfps_nga 	"`fies'/Phone Surveys/Nigeria"		
gl fies_hfps_tza 	"`fies'/Phone Surveys/Tanzania"		
gl fies_hfps_uga 	"`fies'/Phone Surveys/Uganda"		
dir "${fies_hfps_bfa}"
cls
*	context reset for harmonized HFPS
ex

*	investigate the panel data that were harmonized for phase 1 
dir "${hfps}/Phase 1 Harmonized/data"
d using "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", si
d using "${hfps}/Phase 1 Harmonized/data/MWI_2020_HFPS_v01_M_v01_A_COVID_Stata/mwi_hh.dta", si
d using "${hfps}/Phase 1 Harmonized/data/NGA_2020_NLPS_v01_M_v02_A_COVID_Stata/nga_hh.dta", si
d using "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", si

*	Structure is wide. We anticipate a long form output
*	focused on the phase 0 data as covariates. Tracks demographic shifts after that, and FIES, but little else 
	*	what is the N strategy? 
d using "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", s	//	6770
d using "${hfps}/Phase 1 Harmonized/data/MWI_2020_HFPS_v01_M_v01_A_COVID_Stata/mwi_hh.dta", s	//	3178
d using "${hfps}/Phase 1 Harmonized/data/NGA_2020_NLPS_v01_M_v02_A_COVID_Stata/nga_hh.dta", s	//	4976
d using "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", s	//	3098

u "${hfps}/Phase 1 Harmonized/data/ETH_2020_HFPS_v01_M_v01_A_COVID_Stata/eth_hh.dta", clear
tabstat complete_*, s(sum)	
u "${hfps}/Phase 1 Harmonized/data/MWI_2020_HFPS_v01_M_v01_A_COVID_Stata/mwi_hh.dta", clear
tabstat complete_*, s(sum)
u "${hfps}/Phase 1 Harmonized/data/NGA_2020_NLPS_v01_M_v02_A_COVID_Stata/nga_hh.dta", clear
tabstat complete_*, s(sum)
u "${hfps}/Phase 1 Harmonized/data/UGA_2020_HFPS_v01_M_v01_A_COVID_Stata/uga_hh.dta", clear
tabstat complete_*, s(sum)
	*	N Strategy is to leave the complete phase 0 N, and then include the data for each subsequent round. 

	
	
*	Burkina Faso
dir "${raw_hfps_bfa}", w
*	structure is consistently module oriented. When does phase 2 start? 
	*	can't try a grand append from the start, it's too much to solve. Better to just do round specific work 

*	Ethiopia
dir "${raw_hfps_eth}", w

*	structure changes to be more module-centric in phase 2
*	less uniform file organization here


*	Malawi
dir "${raw_hfps_mwi}", w
*	structure is consistently module oriented. When does phase 2 start? 
u "${raw_hfps_mwi}/sect8_food_security_r20.dta", clear
su
cap : assert s8q1==.
if _rc==0 {
	copy "${mw}/LSMS/HFPS/one off/sect8_food_security_r20.dta" "${mw}/LSMS/HFPS/MWI_2020-2024_HFPS_v19_M_Stata/sect8_food_security_r20.dta", replace 
}
u "${raw_hfps_mwi}/sect8_food_security_r20.dta", clear
ta s8q1,m
assert r(r)>=2	//	must have at least two categories (could develop this furhter but no real reason)

*	Nigeria
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w
*	structure again consistently module oriented 


*	Tanzania
dir "${raw_hfps_tza}", w
*	follows on Nigeria approach 
/*	one-off for Tanzania SPSS format data
dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS", w
loc r9sav : dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS" files "r9*.sav"
loc allsav : dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS" files "*.sav"
foreach x of local allsav {
	import spss "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS/`x'", clear
	loc dta=subinstr("`x'",".sav",".dta",1)
	sa "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_Stata_manual/`dta'"
}
*/

/*	dealing with the corrupted file for r9_sect_a_2_3_4_11_12a_14_15_10.dta in the public release v07
cap : u "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
if _rc!=0 {
import delim "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v07_M_CSV/r9_sect_a_2_3_4_11_12a_14_15_10.csv"	/*
*/	, clear varn(1)
sa "${dtop}/temporary.dta", replace 
d using "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta"
forv i=1/`r(N)' {
	cap : u in `i' using "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
	if _rc!=0 {
	dis as error	"issue in `i'"
	}
}
 u in 1/82 using "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
ds, has(vallabel)	//	this correctly identifies many obs with a value label
la dir	//	no value labels actually in the dataset
d, replace clear
sa "${dtop}/description.dta", replace
u  "${dtop}/description.dta", clear
u  "${dtop}/temporary.dta", clear
d, replace clear
mer 1:1 position name using "${dtop}/description.dta"
li if _m!=3	//	fine enough
u  "${dtop}/temporary.dta", clear
d, s
ren * x(###)_=, renumber
d, s
forv i=1/280 {
	preserve
u "${dtop}/description.dta", clear
loc name = name[`i']
loc fmt  = format[`i']
loc vall = vallab[`i']
loc varl = varlab[`i']
	restore
if `i'<10 loc j "00`i'"
else if `i'<100 loc j "0`i'"
else loc j "`i'"

ren x`j'_ `name'
cap : format `name' `fmt'	//	this should force non-string vars in the csv to be string but just ignoring for now 
if length("`vall'")>0 {
	la val `name' `vall'
}
la var `name' "`varl'"
}

sa "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", replace 
}
u "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
assert _rc==0
*/

*	Uganda
dir "${raw_hfps_uga}", w
*	organized in folders
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



*	cover basic information
do "${do_hfps_bfa}/cover.do"
do "${do_hfps_eth}/cover.do"
do "${do_hfps_mwi}/cover.do"
do "${do_hfps_nga}/cover.do"
do "${do_hfps_tza}/cover.do"
do "${do_hfps_uga}/cover.do"
do "${do_hfps_pnl}/cover.do"

*	initial individual dataset and essential demographics
do "${do_hfps_bfa}/demographics.do"
do "${do_hfps_eth}/demographics.do"
do "${do_hfps_mwi}/demographics.do"
do "${do_hfps_nga}/demographics.do"
do "${do_hfps_tza}/demographics.do"
do "${do_hfps_uga}/demographics.do"
do "${do_hfps_pnl}/demographics.do"
do "${do_hfps_pnl}/individual.do"

*	employment * NFE
do "${do_hfps_bfa}/employment.do"
do "${do_hfps_eth}/employment.do"
do "${do_hfps_mwi}/employment.do"
do "${do_hfps_nga}/employment.do"
do "${do_hfps_tza}/employment.do"
do "${do_hfps_uga}/employment.do"
do "${do_hfps_pnl}/employment.do"

*	FIES
do "${do_hfps_bfa}/fies.do"
do "${do_hfps_eth}/fies.do"
do "${do_hfps_mwi}/fies.do"
do "${do_hfps_nga}/fies.do"
do "${do_hfps_tza}/fies.do"
do "${do_hfps_uga}/fies.do"
do "${do_hfps_pnl}/fies.do"

*	Dietary Diversity
do "${do_hfps_bfa}/dietary diversity.do"
// do "${do_hfps_eth}/panel/dietary diversity.do"	//	never asked
do "${do_hfps_mwi}/dietary diversity.do"
do "${do_hfps_nga}/dietary diversity.do"
do "${do_hfps_tza}/dietary diversity.do"
do "${do_hfps_uga}/dietary diversity.do"
do "${do_hfps_pnl}/dietary diversity.do"

*	shocks/coping
do "${do_hfps_bfa}/shocks.do"
do "${do_hfps_eth}/shocks.do"
do "${do_hfps_mwi}/shocks.do"
do "${do_hfps_nga}/shocks.do"
do "${do_hfps_tza}/shocks.do"
do "${do_hfps_uga}/shocks.do"
do "${do_hfps_pnl}/shocks.do"

*	price
dir "${hfps}/Input datasets"
do "${do_hfps_bfa}/price.do"
do "${do_hfps_eth}/price.do"
do "${do_hfps_mwi}/price.do"
do "${do_hfps_nga}/price.do"
do "${do_hfps_tza}/shocks.do"
do "${do_hfps_uga}/price.do"
do "${do_hfps_pnl}/price.do"

*	economic sentiment 
do "${do_hfps_bfa}/economic_sentiment.do"
do "${do_hfps_eth}/economic_sentiment.do"
do "${do_hfps_mwi}/economic_sentiment.do"
do "${do_hfps_nga}/economic_sentiment.do"
do "${do_hfps_tza}/economic_sentiment.do"
do "${do_hfps_uga}/economic_sentiment.do"
do "${do_hfps_pnl}/economic_sentiment.do"

*	subjective welfare
do "${do_hfps_bfa}/panel/subjective_welfare.do"
do "${do_hfps_eth}/panel/subjective_welfare.do"
do "${do_hfps_mwi}/panel/subjective_welfare.do"
do "${do_hfps_nga}/panel/subjective_welfare.do"
do "${do_hfps_tza}/panel/subjective_welfare.do"
do "${do_hfps_uga}/panel/subjective_welfare.do"
do "${do_hfps_pnl}/subjective_welfare.do"

*	agriculture
do "${do_hfps_bfa}/agriculture.do"
do "${do_hfps_eth}/agriculture.do"
do "${do_hfps_mwi}/agriculture.do"
do "${do_hfps_nga}/agriculture.do"
do "${do_hfps_tza}/agriculture.do"
do "${do_hfps_uga}/agriculture.do"
do "${do_hfps_pnl}/agriculture.do"

*	access
do "${do_hfps_bfa}/access.do"
do "${do_hfps_eth}/access.do"
do "${do_hfps_mwi}/access.do"
do "${do_hfps_nga}/access.do"
do "${do_hfps_tza}/access.do"
do "${do_hfps_uga}/access.do"
do "${do_hfps_pnl}/access.do"
	*	not merged at household level as it is identified at hh x item level. 

*	gff
do "${do_hfps_bfa}/gff.do"
do "${do_hfps_eth}/gff.do"
do "${do_hfps_mwi}/gff.do"
do "${do_hfps_nga}/gff.do"
do "${do_hfps_tza}/gff.do"
do "${do_hfps_uga}/gff.do"
do "${do_hfps_pnl}/gff.do"
	*	also identified at hh x item level. 




*	grand panel
u "${tmp_hfps_pnl}/cover.dta", clear
g xx = (mi(pnl_wgt))
table round (cc xx), nototal
drop if mi(pnl_wgt)
drop xx 



mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/demog.dta", gen(_demog) keep(1 3)
ta round cc if _demog!=3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/employment.dta", gen(_employment) keep(1 3)
ta round cc if _employment!=3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/fies.dta", gen(_fies) keep(1 3)
ta round cc if _fies!=3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/dietary_diversity.dta", gen(_diet_div) keep(1 3)
ta round cc if _diet_div==3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/hh_shocks.dta", gen(_shocks) keep(1 3)
ta round cc if _shocks==3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/subjective_welfare.dta", gen(_subj_welfare) keep(1 3)
ta round cc if _subj_welfare==3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/economic_sentiment.dta", gen(_econ_sentiment) keep(1 3)
ta round cc if _econ_sentiment==3
mer 1:1 cc pnl_hhid round using "${tmp_hfps_pnl}/agriculture.dta", gen(_agriculture) keep(1 3)
ta round cc if _agriculture==3



compress	//	implement one time to increase speed on other operations 

sa	"${final_hfps_pnl}/analysis_dataset.dta", replace
u	"${final_hfps_pnl}/analysis_dataset.dta", clear
export delimited using "${final_hfps_pnl}/analysis_dataset.csv", delim(tab) replace


ex

u	"${final_hfps_pnl}/analysis_dataset.dta", clear
svy : mean hhsize, over(cc round)
svy, subpop(if cc==2) : mean hhsize
xtsum hhsize


u	"${final_hfps_pnl}/analysis_dataset.dta", clear
tab1 _*
tab2 cc _*, first

ta round cc if _demog==3
ta round cc if _employment==3
ta round cc if _fies==3
ta round cc if _diet_div==3
ta round cc if _shocks==3
ta round cc if _subj_welfare==3
ta round cc if _econ_sentiment==3
ta round cc if _agriculture==3

tab1 _* if mi(pnl_wgt)

la val _* 
recode _* (1=0)(3=1)

egen modules = group(_*), label



*	there are also significant datasets that are not identified at household level,
*	which will be up to the analyst to ultimately combine as they see fit 
	*	price.dta
	*	individual.dta
	



*	export basic decription of contents 
u	"${final_hfps_pnl}/analysis_dataset.dta", clear
ta round cc,m

*	what about a temporal element here 
g yearmo = mofd(pnl_intdate)
format yearmo %tm
table yearmo cc, nototal	//	nice, but murkier about the source of content, and some issues in TZ 

ta round cc,m


u "${tmp_hfps_pnl}/cover.dta", clear
d, clear replace
keep name varlab
export excel using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("cover", replace) first(var) cell(A3)
u "${tmp_hfps_pnl}/cover.dta", clear
tabstat phase-pnl_wgt, by(cc) s(n)


foreach x in demog employment fies dietary_diversity hh_shocks subjective_welfare price economic_sentiment agriculture {
u "${tmp_hfps_pnl}/`x'.dta", clear
ds cc round pnl_hhid, not
d `r(varlist)', clear replace
keep name varlab
export excel using "${hfps}/Excel documentation/Harmonized Panel Dictionary.xlsx", 	/*
*/	sheet("`x'", replace) first(var) cell(A3)

}


