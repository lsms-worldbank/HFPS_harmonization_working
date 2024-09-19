



dir "${raw_hfps_tza}", w
dir "${raw_hfps_tza}/*_5*", w

*	section 5
d s5*	using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
d		using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
d s7*	using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s5 not access
d		using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s7
d s5*	using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	//	s5 not access
d		using	"${raw_hfps_tza}/r3_sect_a_2_3_4_5b_7_10.dta"	//	s7
d		using	"${raw_hfps_tza}/r5_sect_5f.dta"	//	yes, healthcare 
d s5*	using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	yes, also healthcare
d		using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"
d s5*	using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	this s5 is economic sentiment
d		using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	s7 has some fuel access questions
d s7*	using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	

d		using	"${raw_hfps_tza}/r6_sect_6.dta"	//	no access, price only
d		using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	no access, price only

d 		using	"${raw_hfps_tza}/r7_sect_a_2_3_4_11_12a_10.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r7_sect_5.dta"	//	yes, access
d s5*	using	"${raw_hfps_tza}/r7_sect_5.dta"	//	yes, access
d		using	"${raw_hfps_tza}/r7_sect_6.dta"	//	no, price only
d		using	"${raw_hfps_tza}/r7_sect_7.dta"	//	yes, fuel access 
d		using	"${raw_hfps_tza}/r7_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r8_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r8_sect_6.dta"	//	no, price only
d 		using	"${raw_hfps_tza}/r8_sect_7.dta"	//	yes, fuel access
d 		using	"${raw_hfps_tza}/r8_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r9_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r9_sect_6.dta"	//	availability, no access
d 		using	"${raw_hfps_tza}/r9_sect_7.dta"	//	yes, fuel acces
d 		using	"${raw_hfps_tza}/r9_sect_8.dta"	//	yes, transit access
d s5*	using	"${raw_hfps_tza}/r10_sect_5.dta"	//	yes, access
d 		using	"${raw_hfps_tza}/r10_sect_6.dta"	//	availability, no access
d 		using	"${raw_hfps_tza}/r10_sect_7.dta"	//	yes, fuel acces
d 		using	"${raw_hfps_tza}/r10_sect_8.dta"	//	yes, transit access


d s5*	using	"${raw_hfps_tza}/r9_sect_5.dta"	
	*	the r7-9 are a distinct structure, can treat them in a batch


run "${do_hfps_util}/label_access_item.do"
run "${do_hfps_util}/label_item_ltfull.do"
	
{	/*	round 1	*/	
d s5* using	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta"
u	"${raw_hfps_tza}/r1_sect_a_3_4_5_6_7_8_10.dta", clear
ta s5q00,m

*	staple-> 15
*	rice-> 4
*	maize flour-> 16
*	medicine-> 1
*	health services-> 11


*	staple-> 15
gl i=15
ta s5q01,m
g item_need_${i} = (inlist(s5q01,1,2)) if !mi(s5q01)
g item_access_${i} = (s5q01==1) if item_need_${i}==1

ta s5q02,m	//	large chunk of o/s and large 'refused' chunk 
la li s5q02

g item_noaccess_cat1_${i}	= (s5q02==1)	if item_access_${i}==0
g item_noaccess_cat2_${i}	= (s5q02==2)	if item_access_${i}==0
g item_noaccess_cat3_${i}	= (s5q02==3)	if item_access_${i}==0
g item_noaccess_cat5_${i}	= (s5q02==5)	if item_access_${i}==0
g item_noaccess_cat6_${i}	= (s5q02==7)	if item_access_${i}==0
g item_noaccess_cat31_${i}	= (s5q02==6)	if item_access_${i}==0

*	rice-> 4
gl i=4
ta s5q03,m
g item_need_${i} = (inlist(s5q03,1,2)) if !mi(s5q03)
g item_access_${i} = (s5q03==1) if item_need_${i}==1

ta s5q04,m	//	large chunk of o/s and large 'refused' chunk 
la li s5q04
g item_noaccess_cat1_${i}	= (s5q04==1)	if item_access_${i}==0
g item_noaccess_cat2_${i}	= (s5q04==2)	if item_access_${i}==0
g item_noaccess_cat3_${i}	= (s5q04==3)	if item_access_${i}==0
g item_noaccess_cat5_${i}	= (s5q04==5)	if item_access_${i}==0
g item_noaccess_cat6_${i}	= (s5q04==7)	if item_access_${i}==0
g item_noaccess_cat31_${i}	= (s5q04==6)	if item_access_${i}==0

*	maize flour-> 16
gl i=16
ta s5q05,m
g item_need_${i} = (inlist(s5q05,1,2)) if !mi(s5q05)
g item_access_${i} = (s5q05==1) if item_need_${i}==1

ta s5q06,m	//	large chunk of o/s and large 'refused' chunk 
la li s5q06
g item_noaccess_cat1_${i}	= (s5q06==1)	if item_access_${i}==0
g item_noaccess_cat2_${i}	= (s5q06==2)	if item_access_${i}==0
g item_noaccess_cat3_${i}	= (s5q06==3)	if item_access_${i}==0
g item_noaccess_cat5_${i}	= (s5q06==5)	if item_access_${i}==0
g item_noaccess_cat6_${i}	= (s5q06==7)	if item_access_${i}==0
g item_noaccess_cat31_${i}	= (s5q06==6)	if item_access_${i}==0

*	medicine-> 1
*	health services-> 11
ta s5q07 s5q09,m	//	
ta s5q10 s5q09,m	//	reason not captured
ta s5q07 s5q08,m	//	medicine acces not captured if need health services!=1 
gl i=11
g item_need_${i} = (s5q07==1) if !mi(s5q07)
ta s5q09 
g item_access_${i} = (s5q09==2) if item_need_${i}==1

ta s5q10,m	
la li s5q10
g item_noaccess_cat1_${i}	= (s5q10==8)	if item_access_${i}==0	//	equating this code to a stock issue
g item_noaccess_cat2_${i}	= (inlist(s5q10,2,4))	if item_access_${i}==0
g item_noaccess_cat3_${i}	= (s5q10==6)	if item_access_${i}==0
g item_noaccess_cat6_${i}	= (s5q10==1)	if item_access_${i}==0
g item_noaccess_cat8_${i}	= (s5q10==5)	if item_access_${i}==0
g item_noaccess_cat9_${i}	= (s5q09==3)	if item_access_${i}==0	//	different variable, not a typo-> need is established directly so not trying is a choice which we should document

gl i=1
g item_access_${i} = (s5q08==2) if item_need_11==1	//	not a typo, 1 is dependent on 11 here

keep hhid item*
#d ;
reshape long item_need_ item_access_ 
	item_noaccess_cat1_		item_noaccess_cat2_		item_noaccess_cat3_	
							item_noaccess_cat5_		item_noaccess_cat6_	
							item_noaccess_cat8_		item_noaccess_cat9_	
	item_noaccess_cat31_	
	, i(hhid) j(item); 
#d cr 
ren *_ *

label_access_item
g round=  1
tempfile r1
sa		`r1'
}	/*	 r1 end	*/
	
	
{	/*	round 2	*/	
d s7*	using	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta"	//	s5 not access
u	"${raw_hfps_tza}/r2_sect_a_2_3_4_5_7_8_10.dta", clear

*	pre-natal/post-natal-> 53
*	adult health check-up/preventative care-> 55
*	medicine-> 1
*	health services-> 11


*	pre-natal/post-natal-> 53
gl i=53
ta s7q01 s7q02,m
g item_need_${i} = (s7q01==1) if !mi(s7q01)
g item_access_${i} = (s7q02==1) if item_need_${i}==1

tabstat s7q03__*,s(n sum) c(s)	//	few o/s
ta s7q03_os
recode s7q03__8 (0 .=1) if s7q03_os=="WATAALAMU HAWAKUWA TAYARI KUTOA HUDUMA"	//	->	THE SPECIALISTS WERE NOT READY TO PROVIDE SERVICES
recode s7q03__5 (0 .=1) if s7q03_os=="hakuna huduma za afya hususa madawa"	//	->	There are no specific health services, medicines

g item_noaccess_cat41_${i}	= (s7q03__1==1)	if item_access_${i}==0
g item_noaccess_cat42_${i}	= (s7q03__2==1)	if item_access_${i}==0
g item_noaccess_cat43_${i}	= (s7q03__3==1)	if item_access_${i}==0
g item_noaccess_cat44_${i}	= (s7q03__4==1)	if item_access_${i}==0
g item_noaccess_cat50_${i}	= (s7q03__5==1)	if item_access_${i}==0
g item_noaccess_cat49_${i}	= (s7q03__6==1)	if item_access_${i}==0
g item_noaccess_cat11_${i}	= (s7q03__7==1)	if item_access_${i}==0
g item_noaccess_cat45_${i}	= (s7q03__8==1)	if item_access_${i}==0

*	adult health check-up/preventative care-> 55
gl i=55
ta s7q05 s7q04,m
la li s7q05
g item_need_${i} = (s7q04==1 | inlist(s7q05,1,2)) if !mi(s7q04)
g item_access_${i} = (s7q04==1) if item_need_${i}==1

tabstat s7q06__*,s(n sum) c(s)
ta s7q06_os
recode s7q06__5 (0 .=1) if s7q06_os=="kutumia dawa"	//	->	use drugs
g item_noaccess_cat41_${i}	= (s7q06__1==1)	if item_access_${i}==0
g item_noaccess_cat42_${i}	= (s7q06__2==1)	if item_access_${i}==0
g item_noaccess_cat43_${i}	= (s7q06__3==1)	if item_access_${i}==0
g item_noaccess_cat44_${i}	= (s7q06__4==1)	if item_access_${i}==0
g item_noaccess_cat50_${i}	= (s7q06__5==1)	if item_access_${i}==0
g item_noaccess_cat49_${i}	= (s7q06__6==1)	if item_access_${i}==0
g item_noaccess_cat11_${i}	= (s7q06__7==1)	if item_access_${i}==0
g item_noaccess_cat45_${i}	= (s7q06__8==1)	if item_access_${i}==0

*	medicine-> 1
*	health services-> 11
ta s7q07 s7q09,m	//	
ta s7q10 s7q09,m	//	
ta s7q07 s7q08,m	//	medicine acces not captured if need health services!=1 
gl i=11
g item_need_${i} = (s7q07==1) if !mi(s7q07)
ta s7q09 
g item_access_${i} = (s7q09==2) if item_need_${i}==1

ta s7q10,m	
la li s7q10
g str = strtrim(stritrim(strlower(s7q10_os)))
li str if !mi(str), sep(0)	//	google translate results in comments 
recode s7q10 (9=8) if str=="ukosefu wa dawa"	//	lack of medicine
recode s7q10 (9=8) if str=="dawa zilizokuwa hamna"	//	medicines that were not available
recode s7q10 (9=8) if str=="analarge na dawa"	//	analarge of medicint -> assuming this is a typo and was meant to indicate lack of medicine
recode s7q10 (9=1) if str=="matibabu ya kupatiwa huduma za afya ipo juu"	//	the treatment provided for health services is high
recode s7q10 (9=1) if str=="hawana bima"	//	they don't have insurance
recode s7q10 (9=1) if str=="ukosefu wa bima"	//	lack of insurance
recode s7q10 (9=5) if str=="mara nyingi huwa hakuna dawa, na tulijua kuwa ana malaria tukanunua dawa"	//	often there is no medicine, and we knew he had malaria so we bought medicine
drop str
ta s7q10
g item_noaccess_cat41_${i}	= (s7q10==1)	if item_access_${i}==0
g item_noaccess_cat42_${i}	= (s7q10==2)	if item_access_${i}==0
g item_noaccess_cat44_${i}	= (s7q10==4)	if item_access_${i}==0
g item_noaccess_cat50_${i}	= (s7q10==5)	if item_access_${i}==0
g item_noaccess_cat49_${i}	= (s7q10==6)	if item_access_${i}==0
g item_noaccess_cat45_${i}	= (s7q10==8)	if item_access_${i}==0

gl i=1
g item_access_${i} = (s7q08==2) if item_need_11==1	//	not a typo, 1 is dependent on 11 here

keep hhid item*
#d ;
reshape long item_need_ item_access_ 
	item_noaccess_cat11_													
	item_noaccess_cat41_	item_noaccess_cat42_	item_noaccess_cat43_	
	item_noaccess_cat44_	item_noaccess_cat45_							
													item_noaccess_cat49_	
	item_noaccess_cat50_													

	, i(hhid) j(item); 
#d cr 
ren *_ *

label_access_item
g round=  2
tempfile r2
sa		`r2'
}	/*	 r2 end	*/
	

	

{	/*	round 5	*/	
d		using	"${raw_hfps_tza}/r5_sect_5f.dta"	//	yes, healthcare 
d s5*	using	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta"	//	yes, also healthcare
u	"${raw_hfps_tza}/r5_sect_a_2_3_4_5f_9a_10.dta", clear

*	pre-natal/post-natal-> 53
*	adult health check-up/preventative care-> 55
*	medicine-> 1
*	health services-> 11

ta s5fq3
keep hhid s5fq4*
reshape long s5fq4__ s5fq4a__ s5fq4b__, i(hhid) j(item)
compare s5fq4__ s5fq4a__
compare s5fq4__ s5fq4b__
ta s5fq4a__ s5fq4b__
egen zz = rowfirst(s5fq4a__ s5fq4b__)
compare s5fq4__ zz	//	not clear why retained? 
ren (s5fq4__ s5fq4a__ s5fq4b__ s5fq4_os s5fq4a_os s5fq4b_os)(s5fq41 s5fq42 s5fq43 s5fq4_os1 s5fq4_os2 s5fq4_os3)
reshape long s5fq4 s5fq4_os, i(hhid item) j(rank)
duplicates report hhid item if !mi(s5fq4)
ta item s5fq4
ta item s5fq4 if rank==1
u	"${raw_hfps_tza}/r5_sect_5f.dta", clear
ta service_cd s5fq4 
	*	this comparison demonstrates that the information in the hh level module is identical to the info in the service_cd identified data
isid hhid service_cd
la li service_cd
recode service_cd (1=58)(2=51)(3=52)(4=53)(5=54)(6=55)(7=56)(8=57)(else=.), gen(item)
ta s5fq4_os service_cd
recode item (.=55) if service_cd==96 & !mi(s5fq4_os)
drop if mi(item)

g item_need = (s5fq4==1)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6b_2
ta s5fq6_os	//	non-english, but google translate results indicate there is little to do with any of these 
foreach i of numlist 1/9 {
g item_noaccess_cat4`i' = s5fq6==`i'
}

*	deal with duplicates created by recode of service_cd
#d ;
collapse (max) item_need (min) item_access (max) item_noaccess_cat*
	, by(hhid item); 
#d cr 

label_access_item
g round=  5
tempfile r5
sa		`r5'
}	/*	 r5 end	*/
	
	
*	return to round 5, it's a split module situation 


{	/*	round 6	*/
d		using	"${raw_hfps_tza}/r6_sect_6.dta"	//	no access, price only
u	"${raw_hfps_tza}/r6_sect_6.dta", clear
la li item_cd
#d ; 
recode item_cd 
           (10=16)	/*10. Maize flour	*/
           (11=6)	/*11. Cassava flour		*/
           (13=4)	/*13. Rice			*/
           (16=69)	/*16. Wheat flour	*/
           (17=87)	/*17. Sugar		*/
           (18=68)	/*18. Cooking oil		*/

	, gen(item); 
#d cr 
label_access_item
isid hhid item
drop item_cd
ta s6q1

g item_avail = (s6q1==1) 	//	saying that missing=no
isid hhid item


keep hhid item*
tempfile general
sa		`general'


/*	fuel	*/	
d	s7*	using	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta"	//	no access, price only
u	"${raw_hfps_tza}/r6_sect_a_2_3_5_7_10.dta", clear
g item=91	//	binning all as petrol 
label_access_item

ta s7q1
g item_access = (inlist(s7q1,1,2)) if inlist(s7q1,1,2,3)

keep hhid item*
isid hhid item
tempfile fuel
sa		`fuel'

clear
append using `general' `fuel'
isid hhid item

g round=  6
tempfile r6
sa		`r6'
}	/*	 r6 end	*/


u	"${raw_hfps_tza}/r6_sect_6.dta", clear 
la li item_cd
// la li labels3
u	"${raw_hfps_tza}/r7_sect_6.dta", clear 
la li item_cd
// la li labels3
u	"${raw_hfps_tza}/r7_sect_7.dta", clear 
la li fuel_cd
// la li labels3
u	"${raw_hfps_tza}/r7_sect_8.dta", clear 
la li destination_cd
// la li labels3
u	"${raw_hfps_tza}/r8_sect_6.dta", clear 
la li item_cd 
// la li labels3
u	"${raw_hfps_tza}/r8_sect_7.dta", clear 
la li fuel_cd
// la li labels3
u	"${raw_hfps_tza}/r8_sect_8.dta", clear 
la li destination_cd
// la li labels3
u	"${raw_hfps_tza}/r9_sect_6.dta", clear 
la li item_cd 
// la li labels3
u	"${raw_hfps_tza}/r9_sect_7.dta", clear 
la li fuel_cd
// la li labels3
u	"${raw_hfps_tza}/r9_sect_8.dta", clear 
la li destination_cd
// la li labels3



{	/*	rounds 7-9 */
qui {
forv r=7/10 {
u	"${raw_hfps_tza}/r`r'_sect_5.dta", clear
la dir
uselabel `r(names)', clear
tempfile r`r'
sa		`r`r''
}
u `r7', clear
forv r=8/10 {
mer 1:1 lname value label using `r`r'', gen(_`r')
}
}
li if !inlist(lname,"t0_district","t0_region","urban_rural"), nol sepby(lname)	//	identical in all

qui {
forv r=7/10 {
u	"${raw_hfps_tza}/r`r'_sect_6.dta", clear
la dir
uselabel `r(names)', clear
tempfile r`r'
sa		`r`r''
}
u `r7', clear
forv r=8/10 {
mer 1:1 lname value label using `r`r'', gen(_`r')
}
}
li if !inlist(lname,"t0_district","t0_region","urban_rural"), nol sepby(lname)	//	identical in all

qui {
forv r=7/10 {
u	"${raw_hfps_tza}/r`r'_sect_7.dta", clear
la dir
uselabel `r(names)', clear
tempfile r`r'
sa		`r`r''
}
u `r7', clear
forv r=8/10 {
mer 1:1 lname value label using `r`r'', gen(_`r')
}
}
li if !inlist(lname,"t0_district","t0_region","urban_rural"), nol sepby(lname)	//	identical in all

qui {
forv r=7/10 {
u	"${raw_hfps_tza}/r`r'_sect_8.dta", clear
la dir
uselabel `r(names)', clear
tempfile r`r'
sa		`r`r''
}
u `r7', clear
forv r=8/10 {
mer 1:1 lname value label using `r`r'', gen(_`r')
}
}
li if !inlist(lname,"t0_district","t0_region","urban_rural"), nol sepby(lname)	//	identical in all




	/*	food/general	*/ 
#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_5.dta"
	"${raw_hfps_tza}/r8_sect_5.dta"
	"${raw_hfps_tza}/r9_sect_5.dta"
	"${raw_hfps_tza}/r10_sect_5.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode item_cd 
           (1=16)	/*1. Maize grain	*/
           (2=6)	/*2. Cassava		*/
           (3=4)	/*3. Rice			*/
           (4=16)	/*4. Maize flour	*/
           (5=1)	/*5. Medicines		*/
           (6=2)	/*6. Soap			*/
           (7=21)	/*7. Fuel/Gasoline	*/
           (8=40)	/*8. Fertilizer		*/

	, gen(item); 
#d cr 
label_access_item


ta s5q1a s5q1b,m
g item_avail = (s5q1a==1) 	//	saying that missing=no
*	no item_need possible 
g item_access = (s5q1b==1)	if item_avail==1	
d s5q1c__*	using "${raw_hfps_tza}/r7_sect_5.dta"	
d s5q1c__*	using "${raw_hfps_tza}/r8_sect_5.dta"	
d s5q1c__*	using "${raw_hfps_tza}/r9_sect_5.dta"	
d s5q1c__*	using "${raw_hfps_tza}/r10_sect_5.dta"	
tabstat s5q1c__*, s(n sum) c(s)

g item_noaccess_cat1 =(s5q1c__1==1 | s5q1c__3==1 | s5q1c__5==1) if item_access==0
g item_noaccess_cat3 =(s5q1c__4==1) if item_access==0
g item_noaccess_cat5 =(s5q1c__2==1) if item_access==0
g item_noaccess_cat6 =(s5q1c__7==1) if item_access==0
g item_noaccess_cat21=(s5q1c__6==1) if item_access==0	//	security

ta s5q2a s5q1b,m
g item_fullbuy = (s5q2a==1) if item_access==1
d s5q2b__*	using "${raw_hfps_tza}/r7_sect_5.dta"	
d s5q2b__*	using "${raw_hfps_tza}/r8_sect_5.dta"	
d s5q2b__*	using "${raw_hfps_tza}/r9_sect_5.dta"	
d s5q2b__*	using "${raw_hfps_tza}/r10_sect_5.dta"	
tabstat s5q2b__*, s(n sum) c(s)	

g item_ltfull_cat1 =(s5q2b__1==1 | s5q2b__3==1 | s5q2b__5==1) if item_fullbuy==0
g item_ltfull_cat3 =(s5q2b__4==1) if item_fullbuy==0
g item_ltfull_cat5 =(s5q2b__2==1) if item_fullbuy==0
g item_ltfull_cat6 =(s5q2b__7==1) if item_fullbuy==0
g item_ltfull_cat21=(s5q2b__6==1) if item_fullbuy==0	//	security (though not documented in qx)


*	need to collapse to deal with maize grain vs maize flour issue
#d ; 
collapse (max) item_avail (min) item_access
		 (max) item_noaccess_cat*
		 (min) item_fullbuy
		 (max) item_ltfull_cat*
		 , by(round hhid item); 
#d cr

isid round hhid item


keep round hhid item*
tempfile general
sa		`general'


/*	fuel	*/	
#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_7.dta"
	"${raw_hfps_tza}/r8_sect_7.dta"
	"${raw_hfps_tza}/r9_sect_7.dta"
	"${raw_hfps_tza}/r10_sect_7.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
recode fuel_cd 
 (1=91)	/*     1. Petrol	*/
 (2=92)	/*     2. Diesel	*/
 (3=94)	/*        3. LPG	*/
 (5=93)	/*   5. Kerosene	*/
 	, gen(item); 
#d cr 
label_access_item

ta s7q2
g item_access = (inlist(s7q2,1,2,3)) if inlist(s7q2,1,2,3,4)

keep round hhid item*
isid round hhid item
tempfile fuel
sa		`fuel'


/*	transit	*/
#d ; 
clear; append using
	"${raw_hfps_tza}/r7_sect_8.dta"
	"${raw_hfps_tza}/r8_sect_8.dta"
	"${raw_hfps_tza}/r9_sect_8.dta"
	"${raw_hfps_tza}/r10_sect_8.dta"
	, gen(round); replace round=round+6; la drop _append; la val round; 
#d cr
ta s8q2 round
la li s8q2
#d ; 
recode s8q2 
          ( 1=31) 	/*1. SCHOOL BUS				*/
          ( 2=31) 	/*2. PUBLIC BUS				*/
          ( 3=35) 	/*3. PRIVATE CAR/VEHICLE	*/
          ( 4=35) 	/*4. PUBLIC CAR/MINIBUS		*/
          ( 5=32) 	/*5. TRAIN					*/
          ( 6=33) 	/*6. BICYCLE				*/
          ( 7=34) 	/*7. MOTORCYCLE				*/
          ( 8=37) 	/*8. TRICYCLE/TUKTUK		*/
          ( 9=36) 	/*9. TAXI					*/
          (10=38) 	/*10. BOAT/CANOE			*/
          (11=.) 	/*11. OTHER (SPECIFY)		*/
 	, gen(item); 
#d cr 
label_access_item
drop if mi(item)
ta s8q1,m
g item_access=(s8q1==1)


collapse (max) item_access, by(hhid round item)
reshape wide item_access, i(hhid round) j(item)
reshape long
recode item_access (.=0)

keep round hhid item*
isid round hhid item
tempfile transit
sa		`transit'

clear
append using `general' `fuel' `transit', nolabel
isid round hhid item
sort round hhid item

label_access_item

tempfile r7_10
sa		`r7_10'
}	/*	 r7_10 end	*/



#d ; 
clear; append using
	`r1' `r2' `r5' `r6' `r7_10'; 
#d cr
// replace round=round+2 if round>2
ta round
	
isid	hhid round item
order	hhid round item
sort	hhid round item

ta item
label_access_item
ta item round

*	need to harmonize item once other versions are available 
order item_avail item_need item_access item_noaccess_cat? item_noaccess_cat??	/*
*/	item_fullbuy item_ltfull_cat? item_ltfull_cat?? , a(item)

*	label contents here, but these are subject to reorganization in the panel construction
la var item_avail		"Item is available for sale"
la var item_need		"HH needed item in last 7 days"
la var item_access		"HH accessed item in last 7 days"

label_item_ltfull noaccess

la var item_fullbuy		"HH accessed full amount of item needed in last 7 days"

label_item_ltfull ltfull

sa "${tmp_hfps_tza}/panel/access.dta", replace 

cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex



