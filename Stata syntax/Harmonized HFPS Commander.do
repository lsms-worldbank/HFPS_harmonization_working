


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
set varabbrev off, permanently
set scrollbufsize 500000
set linesize 180
gl version 18
version ${version}

*	analyst specific macros to locate raw data on analyst's system
if c(username)=="joshbrubaker" {
	run "/Users/`c(username)'/Dropbox/Consulting/stata_tools/startup.do"
// 	gl hfps "${dbox}/Consulting/WB/HFPS2"
	gl hfps	"${github}/HFPS_harmonization_working"
	

dir "${bf}/Raw Data"
gl raw_hfps_bfa		"${bf}/Raw Data/BFA_2020-2024_HFPS_v23_M_Stata"
gl raw_lsms_bfa 	"${bf}/Raw Data/BFA_2018_EHCVM_v03_M_Stata"

dir "${et}/LSMS"
gl raw_hfps_eth		"${et}/LSMS/ETH_2020-2024_HFPS_v15_M_Stata"
gl raw_lsms_eth1	"${et}/LSMS/ESS_LSMS_2018/ETH_2018_ESS_v02_M_Stata"
gl raw_lsms_eth2	"${et}/LSMS/ESS_LSMS_2021/ETH_2021_ESPS-W5_v01_M_Stata"

dir "${mw}/LSMS"
gl raw_hfps_mwi		"${mw}/LSMS/HFPS/MWI_2020-2024_HFPS_v20_M_Stata"
gl raw_lsms_mwi		"${mw}/LSMS/2022_Feb_07/MWI_2010-2019_IHPS_v05_M_Stata"

dir "${ng}/LSMS"
gl raw_hfps_nga1	"${ng}/LSMS/HFPS/NGA_2020_NLPS_v12_M_Stata"
gl raw_hfps_nga2	"${ng}/LSMS/HFPS/NGA_2021-2024_NLPS_v08_M_Stata"
gl raw_lsms_nga		"${ng}/LSMS/GHS Panel 2018-19 Wave 4/NGA_2018_GHSP-W4_v03_M_Stata12"

dir "${tz}/Raw Data"
gl raw_hfps_tza		"${tz}/Raw Data/HFPS/TZA_2021-2024_HFWMPS_v08_M_Stata12"	//	v05 not available in stata format
gl raw_nps_tza		"${tz}/Raw Data/NPS 2014-15/TZA_2014_NPS-R4_v03_M_STATA11"
gl raw_hbs_tza		"${tz}/Raw Data/HBS 2017-18/TZA_2017_HBS_v01_M_Stata11"

dir "${ug}/LSMS"
dir "${ug}/LSMS/non public"
gl raw_hfps_uga		"${ug}/LSMS/UGA_2020-2024_HFPS_v17_M_STATA14"	
gl raw_hfpsprivate_uga		"${ug}/LSMS/non public/OneDrive_1_11-30-2024/"	
gl raw_lsms_uga		"${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14"

	}
	
*	validation that the macros set above include the name for the public folder version this syntax uses
assert strpos("${raw_hfps_bfa}","BFA_2020-2024_HFPS_v23_M_Stata")>0
assert strpos("${raw_lsms_bfa}","BFA_2018_EHCVM_v03_M_Stata")>0
assert strpos("${raw_hfps_eth}","ETH_2020-2024_HFPS_v15_M_Stata")>0
assert strpos("${raw_lsms_eth1}","ETH_2018_ESS_v02_M_Stata")>0
assert strpos("${raw_lsms_eth2}","ETH_2021_ESPS-W5_v01_M_Stata")>0
assert strpos("${raw_hfps_mwi}","MWI_2020-2024_HFPS_v20_M_Stata")>0
assert strpos("${raw_lsms_mwi}","MWI_2010-2019_IHPS_v05_M_Stata")>0
assert strpos("${raw_hfps_nga1}","NGA_2020_NLPS_v12_M_Stata")>0
assert strpos("${raw_hfps_nga2}","NGA_2021-2024_NLPS_v08_M_Stata")>0
assert strpos("${raw_lsms_nga}","NGA_2018_GHSP-W4_v03_M_Stata12")>0
assert strpos("${raw_hfps_tza}","TZA_2021-2024_HFWMPS_v08_M_Stata12")>0
assert strpos("${raw_nps_tza}","TZA_2014_NPS-R4_v03_M_STATA11")>0
assert strpos("${raw_hbs_tza}","TZA_2017_HBS_v01_M_Stata11")>0
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

//	this macro is used for local storage in some data management tasks. In my machine, this is the Desktop. 
assert length("${dtop}")>0
dir "${dtop}"

gl tmp_hfps_bfa		"${dtop}/Temporary datasets/Burkina Faso"
gl tmp_hfps_eth		"${dtop}/Temporary datasets/Ethiopia"
gl tmp_hfps_mwi		"${dtop}/Temporary datasets/Malawi"
gl tmp_hfps_nga		"${dtop}/Temporary datasets/Nigeria"
gl tmp_hfps_tza		"${dtop}/Temporary datasets/Tanzania"
gl tmp_hfps_uga		"${dtop}/Temporary datasets/Uganda"
gl tmp_hfps_pnl		"${dtop}/Temporary datasets/Panel"

*	construct these folders on the analyst's machine if not already present
cap : mkdir "${dtop}/Temporary datasets"
foreach x in bfa eth mwi nga tza uga pnl {
	cap : mkdir "${tmp_hfps_`x'}"
	cap : mkdir "${tmp_hfps_`x'}/fies"
}

dir "${tmp_hfps_bfa}"

gl final_hfps_pnl	"${hfps}/Final datasets"

cls
*	context reset for harmonized HFPS
ex

********************************************************************************
********************************************************************************
loc investigate=0	//	shutoff bracket to disable this work for general applications
if `investigate'==1	{
	
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

/*	dealing with the corrupted file for r9_sect_a_2_3_4_11_12a_14_15_10.dta in the public release v07 and v08	*/
loc oneoff=0	
if `oneoff'==1 {

cap : u "${raw_hfps_tza}/r9_sect_a_2_3_4_11_12a_14_15_10.dta", clear
if _rc!=0 {
import delim "${tz}/Raw Data/HFPS/TZA_2021-2024_HFWMPS_v08_M_CSV/r9_sect_a_2_3_4_11_12a_14_15_10.csv"	/*
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
}

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
dir "${raw_hfps_uga}/round18", w

*	one-off that constructs private demographics file, currently only works on author's computer but still provided here for reference sake 
loc oneoff=0	
if `oneoff'==1 {
do "${do_hfps_uga}/0_private_individual.do"
}

}
********************************************************************************
********************************************************************************


********************************************************************************
*	begin construction of output datasets
********************************************************************************

*	cover basic information
do "${do_hfps_bfa}/01_cover.do"
do "${do_hfps_eth}/01_cover.do"
do "${do_hfps_mwi}/01_cover.do"
do "${do_hfps_nga}/01_cover.do"
do "${do_hfps_tza}/01_cover.do"
do "${do_hfps_uga}/01_cover.do"
do "${do_hfps_pnl}/01_cover.do"

*	initial individual dataset 
do "${do_hfps_bfa}/02_individual.do"
do "${do_hfps_eth}/02_individual.do"
do "${do_hfps_mwi}/02_individual.do"
do "${do_hfps_nga}/02_individual.do"
do "${do_hfps_tza}/02_individual.do"
do "${do_hfps_uga}/0_private_individual.do"	//	provided to document process used with private copy of individual data
do "${do_hfps_uga}/02_individual.do"	//	replaces public with private individual dataset
do "${do_hfps_pnl}/02_individual.do"

*	essential demographics
do "${do_hfps_bfa}/03_demographics.do"
do "${do_hfps_eth}/03_demographics.do"
do "${do_hfps_mwi}/03_demographics.do"
do "${do_hfps_nga}/03_demographics.do"
do "${do_hfps_tza}/03_demographics.do"
do "${do_hfps_uga}/03_demographics.do"
do "${do_hfps_pnl}/03_demographics.do"

*	employment * NFE
do "${do_hfps_bfa}/04_employment.do"
do "${do_hfps_eth}/04_employment.do"
do "${do_hfps_mwi}/04_employment.do"
do "${do_hfps_nga}/04_employment.do"
do "${do_hfps_tza}/04_employment.do"
do "${do_hfps_uga}/04_employment.do"
do "${do_hfps_pnl}/04_employment.do"

*	FIES
do "${do_hfps_bfa}/05_fies.do"
do "${do_hfps_eth}/05_fies.do"
do "${do_hfps_mwi}/05_fies.do"
do "${do_hfps_nga}/05_fies.do"
do "${do_hfps_tza}/05_fies.do"
do "${do_hfps_uga}/05_fies.do"
do "${do_hfps_pnl}/05_fies.do"

*	Dietary Diversity
do "${do_hfps_bfa}/06_dietary_diversity.do"
// do "${do_hfps_eth}/panel/06_dietary_diversity.do"	//	never asked
do "${do_hfps_mwi}/06_dietary_diversity.do"
do "${do_hfps_nga}/06_dietary_diversity.do"
do "${do_hfps_tza}/06_dietary_diversity.do"
do "${do_hfps_uga}/06_dietary_diversity.do"
do "${do_hfps_pnl}/06_dietary_diversity.do"

*	shocks/coping
do "${do_hfps_bfa}/07_shocks.do"
do "${do_hfps_eth}/07_shocks.do"
do "${do_hfps_mwi}/07_shocks.do"
do "${do_hfps_nga}/07_shocks.do"	
do "${do_hfps_tza}/07_shocks.do"
do "${do_hfps_uga}/07_shocks.do"
do "${do_hfps_pnl}/07_shocks.do"

*	price
dir "${hfps}/Input datasets"	//	some countries/rounds use conversion factors stored here
do "${do_hfps_bfa}/08_price.do"
cap : d using "${hfps}/Input datasets/Ethiopia/price_cf.dta"
if _rc!=0 {
run "${do_hfps_eth}/cf/price_cf.do"
	}
do "${do_hfps_eth}/08_price.do"
do "${do_hfps_mwi}/08_price.do"	
do "${do_hfps_nga}/08_price.do"
do "${do_hfps_tza}/08_price.do"
do "${do_hfps_uga}/08_price.do"	
do "${do_hfps_pnl}/08_price.do"	//	could update further, see notes at bottom

*	access
do "${do_hfps_bfa}/09_access.do"
do "${do_hfps_eth}/09_access.do"
do "${do_hfps_mwi}/09_access.do"
do "${do_hfps_nga}/09_access.do"
do "${do_hfps_tza}/09_access.do"
do "${do_hfps_uga}/09_access.do"
do "${do_hfps_pnl}/09_access.do"
	*	not merged at household level as it is identified at hh x item level. 

*	health services	
do "${do_hfps_bfa}/10_health_services.do"
do "${do_hfps_eth}/10_health_services.do"
do "${do_hfps_mwi}/10_health_services.do"
do "${do_hfps_nga}/10_health_services.do"
do "${do_hfps_tza}/10_health_services.do"
do "${do_hfps_uga}/10_health_services.do"
do "${do_hfps_pnl}/10_health_services.do"
	*	also identified at hh x item level.
		*	the item codes in gff and access are mergable 

*	economic sentiment 
do "${do_hfps_bfa}/11_economic_sentiment.do"
do "${do_hfps_eth}/11_economic_sentiment.do"
do "${do_hfps_mwi}/11_economic_sentiment.do"
do "${do_hfps_nga}/11_economic_sentiment.do"
do "${do_hfps_tza}/11_economic_sentiment.do"
do "${do_hfps_uga}/11_economic_sentiment.do"
do "${do_hfps_pnl}/11_economic_sentiment.do"

*	subjective welfare
do "${do_hfps_bfa}/12_subjective_welfare.do"
do "${do_hfps_eth}/12_subjective_welfare.do"
do "${do_hfps_mwi}/12_subjective_welfare.do"
do "${do_hfps_nga}/12_subjective_welfare.do"
do "${do_hfps_tza}/12_subjective_welfare.do"
do "${do_hfps_uga}/12_subjective_welfare.do"
do "${do_hfps_pnl}/12_subjective_welfare.do"

*	agriculture	//	tabled for update 
do "${do_hfps_bfa}/13_agriculture.do"
do "${do_hfps_eth}/13_agriculture.do"
do "${do_hfps_mwi}/13_agriculture.do"
do "${do_hfps_nga}/13_agriculture.do"
do "${do_hfps_tza}/13_agriculture.do"
do "${do_hfps_uga}/13_agriculture.do"
do "${do_hfps_pnl}/13_agriculture.do"




*	grand export file that populates final_hfps_pnl
dir "${final_hfps_pnl}"
do "${do_hfps_pnl}/99_export.do"
dir "${final_hfps_pnl}"

*	describe contents
do "${hfps}/Stata syntax/Analysis/101_describe_contents.do"



	


