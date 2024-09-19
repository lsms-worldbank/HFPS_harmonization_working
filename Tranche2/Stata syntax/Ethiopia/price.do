


*	price 
dir "${raw_hfps_eth}", w
dir "${raw_hfps_eth}/*price*", w

*	Phase 1
// d using	"${raw_hfps_eth}/r1_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r2_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r3_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r4_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r5_wb_lsms_hfpm_hh_survey_public_microdata_Non20.dta"	
// d using	"${raw_hfps_eth}/r6_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r7_wb_lsms_hfpm_hh_survey_public_microdata.dta"	//	lo* on locusts kind of interesting to include 		
// d using	"${raw_hfps_eth}/r8_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r9_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/r10_wb_lsms_hfpm_hh_survey_public_microdata.dta"		
// d using	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round11_clean_microdata.dta"	
// d using	"${raw_hfps_eth}/r12_wb_lsms_hfpm_hh_survey_public_microdata.dta"		

*	Phase 2
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"
d using "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta"

u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta", clear
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta", clear	
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta", clear
la li fp_00	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta", clear
la li item	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta", clear
la li item	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type
u "${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta", clear
la li item	
keep household_id fp_00 fp_01 fp1_available fp3_price fp2_unit fp2_quant fp2_type

*	will do reduced set from what is possible here, focusing on panel compatibility
*	not reorganizing the item code as it is stable across rounds
#d ; 
clear; append using
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round13_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round14_price_public.dta"	
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round15_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round16_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round17_price_public.dta"
	"${raw_hfps_eth}/wb_lsms_hfpm_hh_survey_round18_price_public.dta"
	"${raw_hfps_eth2}/WB_LSMS_HFPM_HH_Survey-Round19_Price_Public.dta"
	, gen(round); replace round=round+12;  la drop _append; la val round; 

la def fp_00 11	"Charcoal" 12 "Firewood" 13 "Kerosene", add; 
recode fp_00 (111/113=1)(2=2)(3=4)(4=5)(5=196)(6=195)(7=202)(8=14)(9=144)(10=22)
	(else=.), gen(item_cd_cf);

#d cr
isid household_id round fp_00
ta fp_00 round, m

ta fp_00 fp2_type	//	in round 13 where fp2_type is not available, looks pretty safe to say it's grain
	*	where household always uses the same type, use that type 
bys household_id fp_00 (round) : egen min=min(fp2_type)
bys household_id fp_00 (round) : egen max=max(fp2_type)
replace fp2_type = min if mi(fp2_type) & min==max & !mi(fp2_unit)
ta fp_00 fp2_type
recode fp2_type (.=1) if inlist(fp_00,2,3,4,111,112,113) & !mi(fp2_unit)


*	bring in conversion factor
mer m:1 household_id round using "${tmp_hfps_eth}/panel/cover.dta", assert(2 3) keep(3) nogen keepus(cs1_region)

la li fp2_unit
ta fp2_unit
	//	what are 196,197,900
	ta fp_00 round if inlist(fp2_unit,196,197,900)	//	primarily firewood units
	
g unit_cd = fp2_unit

mer m:1 item_cd_cf unit_cd cs1_region using "${tmp_hfps_eth}/cf/price_cf.dta", keep(1 3) 
	tab1 item_cd_cf unit_cd cs1_region if _m==1

	
	*	dominated by piece 
	ta fp_00 if inlist(unit_cd,141,142,143) & _m==1	//	injera, bread
	g lcu = fp3_price if fp3_price>0 
	la var	lcu	"Cost (LCU)"
	g q = fp2_quant if fp2_quant>0
	la var	q	"Quantity of [unit]"

	
g kg = q * rgnl_cf 
la var kg		"Quantity (standard units)"
ta kg if item_cd_cf==195	//	many are 1 kg 
ta kg if item_cd_cf==196	//	looks fairly reasonable to let a piece of bread = 1 kg 
ta unit_cd item if inlist(item,195,196) & q 
ta item if inlist(unit_cd,141,142,143) & mi(kg)	//	piece units 
	replace kg=. if inlist(item,195,196)

g etb_kg = lcu / kg if !mi(lcu)
g etb_pc = lcu / q if inlist(item,195,196) & inlist(unit,141,142,143) & !mi(lcu) & !mi(q)
tabstat etb_kg etb_pc, by(item) s(n min p50 max) format(%12.3gc) c(s)
	*	some outliers remain on the high side 
	li round item unit rgnl_cf fp2_quant kg fp3_price etb_kg if etb_kg>8000 & !mi(etb_kg)
	*	looks like 250 gm instead of 25, and 1 kg instead of 1 gm, but safer just to drop 
	li round item unit rgnl_cf fp2_quant kg fp3_price etb_kg if etb_kg<1 & !mi(etb_kg), sepby(round)
	ta fp2_unit fp_00 if !mi(kg)
	ta fp2_unit fp_00 if !mi(kg)
	g nmi = !mi(kg) if fp2_quant>0 & !mi(fp2_quant) & fp3_price>0 & !mi(fp3_price)
	g ymi=1-nmi
	table fp2_unit item, stat(sum nmi ymi) nototal
	

	
// g unitprice = cond(inlist(item,195,196),etb_pc,cond(inrange(etb_kg,1,8000),etb_kg,.))	//	this 8000 ETB threshold is currently about $150 US
// la var unitprice	"Unit Price (LCU/kg)"	//	this includes converted total quantities, noting that "kg" = piece for bread and injera
// drop item_cd_cf-_m
// drop etb_kg etb_pc
// tabstat unitprice, by(fp_00) s(n min p50 me max) format(%12.3gc) c(s)	

replace kg = q if inlist(item,195,196) & inlist(unit,141,142,143)	//	not truly a kg, but we are treating it as a standard unit 

g price = lcu / kg
la var	price		"Price (LCU/standard unit)"

g unitcost = lcu / q
la var unitcost		"Unit cost (LCU/unit)"


ta fp_00 fp2_type
la li fp_00
g item=fp_00
replace item=item+20 if fp2_type=="Flour":_type_
run "${do_hfps_eth}/label_item.do"
la val item item
inspect item
assert r(N_undoc)==0
ta fp_00 item 
la var item	"Item code"

decode item, gen(itemstr)
la var itemstr	"Item code"
decode fp2_unit, gen(unitstr)
la var unitstr		"Unit"

	
ta fp1_available, m	//	2% don't know, non-trivial... 
ta fp_00 fp1_available,m
la li Yes_No
g 		item_avail = (fp1_available==1) 	//	if inlist(fp1_available,1,0)	//	will presume these to be no since price is missing there anyway
la var	item_avail	"Item is available for sale"
ta fp_00 item_avail,m




keep  household_id round item itemstr item_avail q unitstr kg lcu price unitcost 
order household_id round item itemstr item_avail q unitstr kg lcu price unitcost 
isid  household_id round item
sort  household_id round item
sa "${tmp_hfps_eth}/panel/price.dta", replace 







