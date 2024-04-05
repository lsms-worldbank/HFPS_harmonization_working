


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
	
	*	primary directory where this do-file and all other syntax and final data will be stored 
	gl hfps_github	"${github}/HFPS_harmonization_working"
	adopath + "${hfps_github}"
	gl local_storage	"${dtop}/HFPS_harmonization_temporary"	//	local storage for temporary datasets 
	
	

*	Data are downloaded as of 4 Jan 2023 from microdata.worldbank.org
*	raw data macros will necessarily be user-specific (not contained within the HFPS folder)

*	Update, data are downloaded as of 14 Mar 2023, excl Tanzania which is not currently available in Stata format

gl raw_hfps_bfa		"${bf}/Raw Data/BFA_2020-2023_HFPS_v18_M_Stata"
gl raw_lsms_bfa 	"${bf}/Raw Data/BFA_2018_EHCVM_v03_M_Stata"

gl raw_hfps_eth		"${et}/LSMS/ETH_2020-2023_HFPS_v13_M_Stata"
gl raw_hfps_eth2	"${et}/LSMS/Round 19 or P2 R7 ET HFPS Data for  Microdata Library"
gl raw_lsms_eth1	"${et}/LSMS/ESS_LSMS_2018/ETH_2018_ESS_v02_M_Stata"
gl raw_lsms_eth2	"${et}/LSMS/ESS_LSMS_2021/ETH_2021_ESPS-W5_v01_M_Stata"

gl raw_hfps_mwi		"${mw}/LSMS/HFPS/MWI_2020-2024_HFPS_v18_M_Stata"
gl raw_lsms_mwi		"${mw}/LSMS/2022_Feb_07/MWI_2010-2019_IHPS_v05_M_Stata"

gl raw_hfps_nga1	"${ng}/LSMS/HFPS/NGA_2020_NLPS_v12_M_Stata"
gl raw_hfps_nga2	"${ng}/LSMS/HFPS/NGA_2021-2023_NLPS_v07_M_Stata"
gl raw_lsms_nga		"${ng}/LSMS/GHS Panel 2018-19 Wave 4/NGA_2018_GHSP-W4_v03_M_Stata12"

// gl raw_hfps_tza		"${tz}/Raw Data/HFPS/TZA_2021-2023_HFWMPS_v04_M_Stata12"	//	v05 not available in stata format
gl raw_hfps_tza		"${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_Stata_manual"	//	v05 not available in stata format
gl raw_lsms_tza		"${tz}/Raw Data/LSMS 2018:19/TZA_2019_NPD-SDD_v04_M_STATA12"

gl raw_hfps_uga		"${ug}/LSMS/UGA_2020-2023_HFPS_v15_M_STATA14"	
gl raw_lsms_uga		"${ug}/LSMS/UGA_2019_UNPS_v03_M_STATA14"


	}


	
*	validation that the macros set above include the name for the public folder version this syntax uses
assert strpos("${raw_hfps_bfa}","BFA_2020-2023_HFPS_v18_M_Stata")>0
assert strpos("${raw_lsms_bfa}","BFA_2018_EHCVM_v03_M_Stata")>0
assert strpos("${raw_hfps_eth}","ETH_2020-2023_HFPS_v13_M_Stata")>0
assert strpos("${raw_lsms_eth1}","ETH_2018_ESS_v02_M_Stata")>0
assert strpos("${raw_lsms_eth2}","ETH_2021_ESPS-W5_v01_M_Stata")>0
assert strpos("${raw_hfps_mwi}","MWI_2020-2024_HFPS_v18_M_Stata")>0
assert strpos("${raw_lsms_mwi}","MWI_2010-2019_IHPS_v05_M_Stata")>0
assert strpos("${raw_hfps_nga1}","NGA_2020_NLPS_v12_M_Stata")>0
assert strpos("${raw_hfps_nga2}","NGA_2021-2023_NLPS_v07_M_Stata")>0
assert strpos("${raw_lsms_nga}","NGA_2018_GHSP-W4_v03_M_Stata12")>0
assert strpos("${raw_hfps_tza}","TAZ_2021-2024_HFWMPS_v05_M_Stata_manual")>0
assert strpos("${raw_lsms_tza}","TZA_2019_NPD-SDD_v04_M_STATA12")>0
assert strpos("${raw_hfps_uga}","UGA_2020-2023_HFPS_v15_M_STATA14")>0
assert strpos("${raw_lsms_uga}","UGA_2019_UNPS_v03_M_STATA14")>0


dir "${hfps_github}"	
dir "${local_storage}"	

cls	
dis as result	"Context reset for harmonized HFPS construction on GitHub"
ex
	
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


*	Nigeria
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w
*	structure again consistently module oriented 


*	Tanzania
dir "${raw_hfps_tza}", w
*	follows on Nigeria approach 
*	one-off for Tanzania SPSS format data
dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS", w
loc r9sav : dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS" files "r9*.sav"
loc allsav : dir "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS" files "*.sav"
foreach x of local allsav {
	import spss "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_SPSS/`x'", clear
	loc dta=subinstr("`x'",".sav",".dta",1)
	sa "${tz}/Raw Data/HFPS/TAZ_2021-2024_HFWMPS_v05_M_Stata_manual/`dta'"
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



*	execute country-specific dataset creation
do "${hfps_github}/do_BFA_Harmonized.do"
do "${hfps_github}/do_ETH_Harmonized.do"
do "${hfps_github}/do_MWI_Harmonized.do"
do "${hfps_github}/do_NGA_Harmonized.do"
do "${hfps_github}/do_TZA_Harmonized.do"
do "${hfps_github}/do_UGA_Harmonized.do"
do "${hfps_github}/do_panel_Harmonized.do"




*	grand panel
dir "${local_storage}/tmp_panel_*.dta"
u "${local_storage}/tmp_panel_cover.dta", clear
g xx = (mi(pnl_wgt))
table round (cc xx), nototal
drop if mi(pnl_wgt)
drop x 

mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_demog.dta", gen(_demog) keep(1 3)
ta round cc if _demog!=3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_employment.dta", gen(_employment) keep(1 3)
ta round cc if _employment!=3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_fies.dta", gen(_fies) keep(1 3)
ta round cc if _fies!=3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_dietary_diversity.dta", gen(_diet_div) keep(1 3)
ta round cc if _diet_div==3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_hh_shocks.dta", gen(_shocks) keep(1 3)
ta round cc if _shocks==3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_subjective_welfare.dta", gen(_subj_welfare) keep(1 3)
ta round cc if _subj_welfare==3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_economic_sentiment.dta", gen(_econ_sentiment) keep(1 3)
ta round cc if _econ_sentiment==3
mer 1:1 cc pnl_hhid round using "${local_storage}/tmp_panel_agriculture.dta", gen(_agriculture) keep(1 3)
ta round cc if _agriculture==3



sa	"${hfps_github}/analysis_dataset.dta", replace



*	other significant panel datasets, not identified at hh level 
copy "${local_storage}/tmp_panel_price.dta" "${hfps_github}/analysis_price.dta", replace
copy "${local_storage}/tmp_panel_individual.dta" "${hfps_github}/analysis_individual.dta", replace


*	clean up 






















