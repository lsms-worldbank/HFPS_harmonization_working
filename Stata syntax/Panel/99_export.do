
/*	erase contents of final datasets prior to merge if desired */
loc pre_purge=0
if `pre_purge'==1 {
	loc dtafiles : dir "${final_hfps_pnl}" files "*.dta"
	loc csvfiles : dir "${final_hfps_pnl}" files "*.csv"

	foreach f in `dtafiles' `csvfiles' {
		erase "{final_hfps_pnl}/`f'"
		}
	}




/*	grand panel	*/

d *_hhid using "${tmp_hfps_pnl}/demog.dta"
d *_hhid using "${tmp_hfps_pnl}/employment.dta"
d *_hhid using "${tmp_hfps_pnl}/fies.dta"
d *_hhid using "${tmp_hfps_pnl}/dietary_diversity.dta"
d *_hhid using "${tmp_hfps_pnl}/hh_shocks.dta"
d *_hhid using "${tmp_hfps_pnl}/subjective_welfare.dta"
d *_hhid using "${tmp_hfps_pnl}/economic_sentiment.dta"
d *_hhid using "${tmp_hfps_pnl}/agriculture.dta"

u "${tmp_hfps_pnl}/cover.dta", clear
g xx = (mi(pnl_wgt))
table round (cc xx), nototal
drop if mi(pnl_wgt)
drop xx 

xtset 
svyset

g byte _cover=3, a(uga_hhid)
la var _cover	"Identifying information"

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

// la val _* . 
la var _demog			"Household demographics"
la var _employment		"Employent and NFE"
la var _fies			"Food Security"
la var _diet_div		"Dietary Diversity"
la var _shocks			"Shocks"
la var _subj_welfare	"Subjective Welfare"
la var _econ_sentiment	"Economic Sentiment"
la var _agriculture		"Agriculture"


compress	//	implement one time to increase speed on other operations 

isid cc pnl_hhid round
sort cc pnl_hhid round
sa	"${final_hfps_pnl}/analysis_dataset.dta", replace
u	"${final_hfps_pnl}/analysis_dataset.dta", clear



/*	non-household level datasets for final export	*/
u "${tmp_hfps_pnl}/price.dta", clear
compress
isid cc  round  pnl_hhid  itemstr
sort cc  round  pnl_hhid  itemstr
sa	"${final_hfps_pnl}/price.dta", replace

u "${tmp_hfps_pnl}/individual.dta", clear
compress
isid cc  round  pnl_hhid  pnl_indid
sa	"${final_hfps_pnl}/individual.dta", replace


u "${tmp_hfps_pnl}/access.dta", clear
compress
isid cc round pnl_hhid item
sort cc round pnl_hhid item
sa	"${final_hfps_pnl}/access.dta", replace

u "${tmp_hfps_pnl}/health_services.dta", clear
compress
isid cc round pnl_hhid item
sort cc round pnl_hhid item
sa	"${final_hfps_pnl}/health_services.dta", replace


/*	verification step to validate that cover links correctly to all these 
	non-household level datasets for final export	*/
foreach mm in price individual access health_services {
	u "${final_hfps_pnl}/`mm'.dta", clear
	mer m:1 cc pnl_hhid round using "${tmp_hfps_pnl}/cover.dta", assert(2 3) keep(3) nogen
	}

	
/*	additional step to automatically exclude interviews for which no weights 
	were constructed	*/	
foreach mm in price individual access health_services {
	u "${final_hfps_pnl}/`mm'.dta", clear
	mer m:1 cc pnl_hhid round using "${final_hfps_pnl}/analysis_dataset.dta", keep(3) nogen keepus(cc pnl_hhid round)
	sa "${final_hfps_pnl}/`mm'.dta", replace 
	}
	


/*	automated export of csv files for all of these datasets	*/
loc dtafiles : dir "${final_hfps_pnl}" files "*.dta"
foreach f of local dtafiles {
	dis "`f'"
	loc c=subinstr("`f'",".dta",".csv",1)
	u	"${final_hfps_pnl}/`f'", clear
	export delimited using "${final_hfps_pnl}/`c'", delim(tab) replace
	}

/*	zip these up for an export	*/
cd "${final_hfps_pnl}" 
zipfile analysis_dataset.dta analysis_dataset.csv, saving("${final_hfps_pnl}/HH_`c(current_date)'.zip", replace)

#d ; 
	zipfile individual.dta individual.csv
	, saving("${final_hfps_pnl}/Ind_`c(current_date)'.zip", replace); 
#d cr
#d ; 
	zipfile 
		price.dta price.csv
		access.dta access.csv
		health_services.dta health_services.csv
	, saving("${final_hfps_pnl}/Oth_`c(current_date)'.zip", replace); 
#d cr


/*	erase contents of final datasets post-merge if desired */
loc post_purge=0
if `post_purge'==1 {
	loc dtafiles : dir "${final_hfps_pnl}" files "*.dta"
	loc csvfiles : dir "${final_hfps_pnl}" files "*.csv"

	foreach f in `dtafiles' `csvfiles' {
		erase "${final_hfps_pnl}/`f'"
		}
	}


