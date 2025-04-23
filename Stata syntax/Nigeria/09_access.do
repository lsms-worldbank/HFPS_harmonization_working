
*	two separate directories for phase 1 & 2
dir "${raw_hfps_nga1}", w
dir "${raw_hfps_nga2}", w


d s5* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta"	//	yes
d s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta"	
d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r5_sect_a_2_5c_6_12.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r6_sect_5c.dta"	//	no
d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	not really
// d s5* using	"${raw_hfps_nga1}/r8_sect_a_2_6_12.dta"
d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	yes
d s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	not really
d s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
d s5* using	"${raw_hfps_nga1}/r12_sect_5e_9a.dta"				//	no

d s5* using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	yes
// d using	"${raw_hfps_nga2}/p2r2_sect_a_2_2a_2b_6_12.dta"	//	no
d using	"${raw_hfps_nga2}/p2r1_sect_5.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_5.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	//	no
d s5* using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	yes, food prices
d s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	yes
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5.dta"	//	yes, health 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
d s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices
d s5* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	fuel 
d s5* using	"${raw_hfps_nga2}/p2r10_sect_5.dta"	//	yes, general 
*	no p2r11 


*	this module shifts a lot over time. will have to implement round by round 
*	
run "${do_hfps_util}/label_access_item.do"
run "${do_hfps_util}/label_item_ltfull.do"

{	/*	round 1	*/
u hhid s5q1* using	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta", clear	//	yes
d s5q1a?
d s5q1c1__?
#d ;
ren (s5q1a? s5q1b? s5q1c?__1 s5q1c?__2 s5q1c?__3 s5q1c?__4 s5q1c?__5 s5q1c?__6)	
	(item_need? item_access? 
	 item_noaccess_cat1? item_noaccess_cat2? 
	 item_noaccess_cat3? item_noaccess_cat4?
	 item_noaccess_cat5? item_noaccess_cat6?); 
drop s5*; 
reshape long item_need item_access 
	item_noaccess_cat1 item_noaccess_cat2 
	item_noaccess_cat3 item_noaccess_cat4 
	item_noaccess_cat5 item_noaccess_cat6
	, i(hhid) j(item); 
#d cr 
ta item_need item_access,m
recode item_need item_access (2=0)
cap : la drop s5q1a8 s5q1b8	//	implemented with capture due to change in reshape command between stata versions 18 and 19 
la val item_need item_access . 

label_access_item
g round=  1
tempfile r1
sa		`r1'
}	/*	 r1 end	*/


{	/*	round 2	*/
d		s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta"	//	not really
u hhid	s5* using	"${raw_hfps_nga1}/r2_sect_a_2_5_6_8_12.dta", clear
drop s5q5* s5q6* s5q7*

ta s5q1e
g item_need_9=1	//	this is an implicit variable 
g item_fullbuy_9 = (s5q1e==2) if inlist(s5q1e,1,2)
ta s5q1f
la li s5q1f
ta s5q1f_os	//	there is a lot to dig into here, some of which requires a decision
g str = strtrim(stritrim(strlower(s5q1f_os)))
preserve
sort str
li str if length(str)>0 & s5q1f==96, sep(0)
restore

	*	the inclusion of codes 1/3 and 11 definitely muddy the interpretation of some of these 

*	no light=no electricity? 
*	"no rain","rain did not fall","unable to access sufficient drinking water because of lack of rain water (babu ruwan sama)" ->	if this truly was no different than normal, then we don't have a great code for it
*	our well is dried and no borehole in our community	->	also hard to do this one 

recode s5q1f (96=1) if inlist(str,"because there was no electricity to pump water"	/*
*/	,"because we did not have power supply for two days babu wutan nepa"	/*
*/	,"lack of light to pump the water","no electricity supply to pump water"	/*
*/	,"no electricity supply to pump water.","no electricity to pump water"	/*
*/	,"no light","no light to pumb water","no light to pump the borehole")
recode s5q1f (96=1) if inlist(str,"no light to pump water","no pipe borne water"	/*
*/	,"no source of water supply, borehole is spoiled and no rainfall"	/*
*/	,"no supply of electricity from phcn to pump water"	/*
*/	,"pipe got broken, and until it was fixed we were able to get drinking water"	/*
*/	,"power failure","stream was contaminated","the borehole got spoiled")
recode s5q1f (96=1) if inlist(str,"the borehole got spoiled. though it was fixed this week"	/*
*/	,"the people that supply water travel for sallah","the water engine got spoiled"	/*
*/	,"the water pump got spoiled","the well dried up"	/*
*/	,"their borehole got spoil and have not repair it yet","there is no borehole")
recode s5q1f (96=1) if inlist(str,"there is no light to pump water"	/*
*/	,"there was no power supply to pump water"	/*
*/	,"we have no well and no borehole","well dried up"	/*
*/	,"when there was no electricity light")
recode s5q1f (96=1) if inlist(str,"there's was no electricity to pump water"	/*
*/	,"there was no power supply to pump water"	/*
*/	,"water vendor could not supply my household with water because i travel"	/*
*/	,"water was not clean","we did not have electricity")
recode s5q1f (96=2) if inlist(str,"most times no electricity to pump water"	/*
*/	,"sometimes we will not have time to fetch water"	/*
*/	,"there was a day, the well had problem")
recode s5q1f (96=3) if inlist(str,"constant long queue, and insufficient source of water, only two boreholes in the entire community and is not serving the needs of our people"	/*
*/	,"because we don't have borehole and well","do not have borehole"	/*
*/	,"no borehole only one in the whole community and the stream we get our drinking water was damaged by rainfall"	/*
*/	,"plenty queue and the place to get the drinking water is overcrowded and it is difficult to get water during this dry season (mutane sun yi yawa kuma rani ne)"	/*
*/	,"the general tap provided by the government spoiled and they had to buy water"	/*
*/	,"the government did not provide us with source of drinking water, problem of distance of source of drinking water, the stream is far")
recode s5q1f (96=3) if inlist(str,"they usually drink from the stream and rain fell about 2 weeks ago and messed the water up. right now they don't have clean drinking water in their community"	/*
*/	,"too much rain prevented them from going to the river to fetch water.")
recode s5q1f (96=4) if inlist(str,"could not buy clean sachet water"	/*
*/	,"respondent buys water and was unable to find water vendors.")
recode s5q1f (96=5) if inlist(str,"local vendors for water not available"	/*
*/	,"it was too late to go out, shops were already closed"	/*
*/	,"the water truck vendor could not supply us with water (mai kawuwa bai samu ya kawo ba)")
recode s5q1f (96=6) if inlist(str,"distance is too far","distance too far"	/*
*/	,"distance to commercial borehole and poor power supply"	/*
*/	,"elderly and cant fetch water all the time"	/*
*/	,"problem of distance to get drinking water, our source of water is 2km away from my area"	/*
*/	,"the distance is very far","the water is far from them"	/*
*/	,"the water source too far from the household"	/*
*/	,"no body to help me with drinking water or help me fetch or find drinking water (babu wanda ya bani ba kuma ba ni da karfi neman ruwan sha)")
preserve
sort str
li str if length(str)>0 & s5q1f==96, sep(0)
restore
drop str

g item_ltfull_cat1_9 = (s5q1f==4)	if !mi(s5q1f)
g item_ltfull_cat2_9 = (s5q1f==5)	if !mi(s5q1f)
g item_ltfull_cat3_9 = (s5q1f==6)	if !mi(s5q1f)
g item_ltfull_cat4_9 = (s5q1f==7)	if !mi(s5q1f)
g item_ltfull_cat5_9 = (s5q1f==8)	if !mi(s5q1f)
g item_ltfull_cat6_9 = (s5q1f==10)	if !mi(s5q1f)

g item_ltfull_cat11_9 = (s5q1f==11)	if !mi(s5q1f)
g item_ltfull_cat91_9 = (s5q1f==1)	if !mi(s5q1f)
g item_ltfull_cat92_9 = (s5q1f==2)	if !mi(s5q1f)
g item_ltfull_cat93_9 = (s5q1f==3)	if !mi(s5q1f)


ta s5q1a,m
g item_fullbuy_2=(s5q1a==1) if inlist(s5q1a,1,2)
ta s5q1a1,m
la li s5q1a1
li s5q1a1_os if s5q1a1==96, sep(0)	//	just ignore these 


g item_ltfull_cat1_2 = (s5q1a1==1) if !mi(s5q1a1)
g item_ltfull_cat2_2 = (s5q1a1==2) if !mi(s5q1a1)
g item_ltfull_cat3_2 = (s5q1a1==3) if !mi(s5q1a1)
g item_ltfull_cat4_2 = (s5q1a1==4) if !mi(s5q1a1)
g item_ltfull_cat5_2 = (s5q1a1==5) if !mi(s5q1a1)
g item_ltfull_cat6_2 = (s5q1a1==7) if !mi(s5q1a1)
g item_ltfull_cat11_2 = (s5q1a1==8) if !mi(s5q1a1)


d s5q1b s5q1b1 s5q1b1_os
ta s5q1b,m
g item_fullbuy_10=(s5q1b==1) if inlist(s5q1b,1,2)
ta s5q1b1,m
la li s5q1b1	//	matches the water codes 

g item_ltfull_cat1_10 = (s5q1b1==4)	if !mi(s5q1b1)
g item_ltfull_cat2_10 = (s5q1b1==5)	if !mi(s5q1b1)
g item_ltfull_cat3_10 = (s5q1b1==6)	if !mi(s5q1b1)
g item_ltfull_cat4_10 = (s5q1b1==7)	if !mi(s5q1b1)
g item_ltfull_cat5_10 = (s5q1b1==8)	if !mi(s5q1b1)
g item_ltfull_cat6_10 = (s5q1b1==10)	if !mi(s5q1b1)

g item_ltfull_cat11_10 = (s5q1b1==11)	if !mi(s5q1b1)
g item_ltfull_cat91_10 = (s5q1b1==1)	if !mi(s5q1b1)
g item_ltfull_cat92_10 = (s5q1b1==2)	if !mi(s5q1b1)
g item_ltfull_cat93_10 = (s5q1b1==3)	if !mi(s5q1b1)


ta s5q2
g item_need_11=(s5q2==1) if inlist(s5q2,1,2)
ta s5q3
g item_access_11 = (s5q3==1) if inlist(s5q3,1,2)
ta s5q4
la li s5q4

g item_noaccess_cat1_11=(s5q4==3) if !mi(s5q4)	//	facility full -> out of stock
g item_noaccess_cat2_11=(s5q4==2) if !mi(s5q4)	//	no medical personnel -> market not operating
g item_noaccess_cat4_11=(s5q4==4) if !mi(s5q4)	
g item_noaccess_cat6_11=(s5q4==1) if !mi(s5q4)
keep hhid item*
#d ;
reshape long item_need_ item_access_ item_fullbuy_
	item_noaccess_cat1_	item_noaccess_cat2_ 
						item_noaccess_cat4_ 
						item_noaccess_cat6_
	item_ltfull_cat1_	item_ltfull_cat2_ 
	item_ltfull_cat3_	item_ltfull_cat4_ 
	item_ltfull_cat5_	item_ltfull_cat6_
	item_ltfull_cat11_	item_ltfull_cat91_
	item_ltfull_cat92_	item_ltfull_cat93_
	, i(hhid) j(item); 
#d cr 
ren *_ *
label_access_item
g round=  2
tempfile r2
sa		`r2'
}	/*	 r2 end	*/


{	/*	round 3	*/
u hhid s5q* using	"${raw_hfps_nga1}/r3_sect_a_2_5_5a_6_12.dta", clear
d
#d ; 
ren (s5q1a? s5q1b? 
	s5q1c?__1	s5q1c?__2	
	s5q1c?__3	s5q1c?__4	
	s5q1c?__5	s5q1c?__6	
	)
	(item_need? item_access? 
	item_noaccess_cat1?	item_noaccess_cat2?	
	item_noaccess_cat3?	item_noaccess_cat4?	
	item_noaccess_cat5?	item_noaccess_cat6?	
	);
#d cr 
ta s5q3a s5q3b,m
tabstat s5q3c__*, c(s)	//	24% O/S, 3rd most common response
g str = strtrim(stritrim(strlower(s5q3c_os)))
preserve
sort str
li str if length(str)>0 & s5q3c__96==1, sep(0)
restore
recode s5q3c__2 (0=1) if inlist(str,"free offers health workers did not come to our area"	/*
*/	,"health workers are absent","health workers that come to our environment did not come"	/*
*/	,"health workers that go around to give immunization to children have not been coming around"	/*
*/	,"health workers that go around to give immunization to children have not been coming around."	/*
*/	,"health workers that usually come around didnt come around to give the children immunization"	/*
*/	,"health workers that usually come around to give them have not been coming."	/*
*/	,"health workers that usually give them didn't come around to give them"	/*
*/	,"lack of health worker's visit to our community")
recode s5q3c__2 (0=1) if inlist(str,"the health workers did not come to immunised the childred as usual"	/*
*/	,"the health workers that use to come to our area did not come"	/*
*/	,"the immunization did not come","the immunization team did not visit us"	/*
*/	,"they have refused to come and give since match"	/*
*/	,"they use to bring it to school but now they don't anymore")
recode s5q3c__3 (0=1) if inlist(str,"hospital didnt have vaccination"	/*
*/	,"no vaccine available","the health workers did not come to immunised the childred as usual")
recode s5q3c__4 (0=1) if inlist(str,"problem of bad road and long distance of hospital from where we are. we live in a remote village"	/*
*/	)
drop str	//	not building out full check back for brevity sake - the above were copy-pasted 
#d ; 
loc s=12; 
ren (s5q3a s5q3b
	s5q3c__1 s5q3c__2 s5q3c__3 s5q3c__4 s5q3c__5 s5q3c__6
	)
	(item_need`s' item_access`s'
	item_noaccess_cat6`s'	item_noaccess_cat2`s'	
	item_noaccess_cat1`s'	item_noaccess_cat5`s'	
	item_noaccess_cat12`s'	item_noaccess_cat13`s'	
	); 
#d cr 
ta s5q11 s5q12,m
tabstat s5q13__*, c(s)	//	30% O/S
ta s5q13_os
g str = strtrim(stritrim(strlower(s5q13_os)))
preserve
sort str
li str if length(str)>0 & s5q13__96==1, sep(0)
restore	//	fair bit of no money, which was not coded 
g item_noaccess_cat613=strpos(str,"money")>0 if !mi(s5q13__96)
recode s5q13__1 (0=1) if inlist(str,"none availability of means of transport, also they have ban motorcycle and keke"	/*
*/	,"not avaliable","dueto nature of estate keke hardly come there."	/*
*/	,"long distance from where u can access the transportation.ie not motorable")
recode s5q13__2 (0=1) if inlist(str,"time factor/curfeiw")
drop str
*	less than full access
ta s5q13a
g item_fullbuy13 = (s5q13a==2) if !mi(s5q13a)


tabstat s5q13b__*, c(s)	//	15% O/S, but N=452
g str = strtrim(stritrim(strlower(s5q13b_os)))
preserve
sort str
li str if length(str)>0 & s5q13b__96==1, sep(0)
restore	//	fair bit of bad road -> taking this as plausibly indicating controlled/shut down roads rather than indicating that the surface quality is poor. 
recode s5q13b__3 (0=1) if inlist(str,"fuel is too expensive"	/*
*/	,"i spent money to fuel the motor circle i hire"	/*
*/	,"only few passengers on boarding, leading to high transport fare"	/*
*/	,"the okada rider told me to pay before service to enable him buy fuel"	/*
*/	,"they have reduced the number of passengers and double the transport fare")
recode s5q13b__96 (1=0) if inlist(str,"fuel is too expensive"	/*
*/	,"i spent money to fuel the motor circle i hire"	/*
*/	,"only few passengers on boarding, leading to high transport fare"	/*
*/	,"the okada rider told me to pay before service to enable him buy fuel"	/*
*/	,"they have reduced the number of passengers and double the transport fare")
g item_ltfull_cat613 = inlist(str,"limited amount of money."	/*
*/	,"money to pay the fare is problem","no enough money","no money") if !mi(s5q13b__96)
recode s5q13b__96 (1=0) if inlist(str,"limited amount of money."	/*
*/	,"money to pay the fare is problem","no enough money","no money")
/*	there is differentiation between concern that others are not following mask 
	policy vs being required to follow mask policy, which NG affords codes to
	differentiate. Cannot rule out the possibility that this is more capturing  
	the enumerator's framing than the respondent's.	*/ 
g item_ltfull_cat1113 = inlist(str,"carrying more than required,not following govt rules abt covid 19"	/*
*/	,"most drivers don't use face mask"	/*
*/	,"most of the keke riders are not maintaining social distance when carrying passengers"	/*
*/	,"most of the passengers donot wear there face mask"	/*
*/	,"problem of been careful to observe good hygiene of not touching the iron on the keke so as not to be infected with corona virus"	/*
*/	,"social distancing not obeyed"	/*
*/	,"the number of people in the car is too much"	/*
*/	,"worried about people not doing social distancing in the bus"	/*
*/	,"the okada riders are afraid to carry passengers because of fear of corona virus, fear of insecurity so that they won't be killed and their motor circle will be stollen from them") if !mi(s5q13b__96)
recode s5q13b__96 (1=0) if inlist(str,"carrying more than required,not following govt rules abt covid 19"	/*
*/	,"most drivers don't use face mask"	/*
*/	,"most of the keke riders are not maintaining social distance when carrying passengers"	/*
*/	,"most of the passengers donot wear there face mask"	/*
*/	,"problem of been careful to observe good hygiene of not touching the iron on the keke so as not to be infected with corona virus"	/*
*/	,"social distancing not obeyed"	/*
*/	,"the number of people in the car is too much"	/*
*/	,"worried about people not doing social distancing in the bus"	/*
*/	,"the okada riders are afraid to carry passengers because of fear of corona virus, fear of insecurity so that they won't be killed and their motor circle will be stollen from them")
g item_ltfull_cat413 = inlist(str,"bad road","bad road network"	/*
*/	,"due to corona most transporters(okada riders) are afraid to enter town, hence i found it difficult before i got one"	/*
*/	,"due to problem of bad road it is difficult to get public transport"	/*
*/	,"no road network","okada are not allowed so they had to hide from the police"	/*
*/	,"passangers are more than vechicle because of avoiding overloeading due to social distancing"	/*
*/	,"passenger are more than transport services due to time factor and rain."	/*
*/	) if !mi(s5q13b__96)
recode item_ltfull_cat413 (0=1) if inlist(str,"problem of bad road"	/*
*/	,"refused entry because he didnt wear a mask"	/*
*/	,"soldiers forbid motor circles in our area, they seize any and take it to another locality, it has also affected us and our children too"	/*
*/	,"that they face seriously holdup in the road."	/*
*/	,"the keke are allowed to carry only two passengers behind which is a great challenge"	/*
*/	,"the respondent said when he is not with his mask,he finds it difficult accessing public transport."	/*
*/	,"the road is bad","the road is bad so okada are very few")
recode item_ltfull_cat413 (0=1) if inlist(str,"no good road"	/*
*/	,"unmotorable roads,")
recode item_ltfull_cat413 (0=1) if inlist(str,"they dont carry passengers who do not comply with the face mask directive."	/*
*/	,"they have reduced movement time from 6am to 7pm"	/*
*/	,"they have reduced number of passengers and increase transport fare, they don't also reach our destination to drop us"	/*
*/	,"traffic due to bad road","unmotorable roads"	/*
*/	,"ur is not motorable and very rural"	/*
*/	,"use of face mask"	/*
*/	,"we faced challenge from dss, we were screened for corona virus and also faced delay"	/*
*/	,"we were arrested for not wearing our mask, and the motor cycle developed a mechanical problem")
recode s5q13b__96 (1=0) if inlist(str,"bad road","bad road network"	/*
*/	,"due to corona most transporters(okada riders) are afraid to enter town, hence i found it difficult before i got one"	/*
*/	,"due to problem of bad road it is difficult to get public transport"	/*
*/	,"no road network","okada are not allowed so they had to hide from the police"	/*
*/	,"passangers are more than vechicle because of avoiding overloeading due to social distancing"	/*
*/	,"passenger are more than transport services due to time factor and rain."	/*
*/	) 
recode s5q13b__96 (1=0) if inlist(str,"problem of bad road"	/*
*/	,"refused entry because he didnt wear a mask"	/*
*/	,"soldiers forbid motor circles in our area, they seize any and take it to another locality, it has also affected us and our children too"	/*
*/	,"that they face seriously holdup in the road."	/*
*/	,"the keke are allowed to carry only two passengers behind which is a great challenge"	/*
*/	,"the respondent said when he is not with his mask,he finds it difficult accessing public transport."	/*
*/	,"the road is bad","the road is bad so okada are very few")
recode s5q13b__96 (1=0) if inlist(str,"no good road"	/*
*/	,"unmotorable roads,")
recode s5q13b__96 (1=0) if inlist(str,"they dont carry passengers who do not comply with the face mask directive."	/*
*/	,"they have reduced movement time from 6am to 7pm"	/*
*/	,"they have reduced number of passengers and increase transport fare, they don't also reach our destination to drop us"	/*
*/	,"traffic due to bad road","unmotorable roads"	/*
*/	,"ur is not motorable and very rural"	/*
*/	,"use of face mask"	/*
*/	,"we faced challenge from dss, we were screened for corona virus and also faced delay"	/*
*/	,"we were arrested for not wearing our mask, and the motor cycle developed a mechanical problem")

*	more generalized concerns not clearly linked to one of the other options
g item_ltfull_cat313 = inlist(str,"delay that it brings"	/*
*/	,"not readily available in villages"	/*
*/	,"staying longer inside vehicle"	/*
*/	,"they wait for longer than usual"	/*
*/	,"too much traffic","traffic"	/*
*/	) if !mi(s5q13b__96)	//	doing code 3 here with the o/s that idd not specify a frequency vs capacity issue 
recode s5q13b__96 (1=0) if inlist(str,"delay that it brings"	/*
*/	,"not readily available in villages"	/*
*/	,"staying longer inside vehicle"	/*
*/	,"they wait for longer than usual"	/*
*/	,"too much traffic","traffic"	/*
*/	) 
g item_ltfull_cat2113 = inlist(str,"attack by thieves, insecurity"	/*
*/	,"sustain violence from agberos and drivers when public transport"	/*
*/	,"problem of bribe in check_points, i spent almost #5,000 before reaching abuja") if !mi(s5q13b__96)
recode s5q13b__96 (1=0) if inlist(str,"attack by thieves, insecurity"	/*
*/	,"sustain violence from agberos and drivers when public transport"	/*
*/	,"problem of bribe in check_points, i spent almost #5,000 before reaching abuja")

recode s5q13b__1 (0=1) if inlist(str,"bikes are scarce in their area")
recode s5q13b__96 (1=0) if inlist(str,"bikes are scarce in their area")

recode s5q13b__2 (0=1) if inlist(str,"they have reduced the number of passengers and double the transport fare"	/*
*/	,"they have reduced the number of passengers on board"	/*
*/	,"reduced number of passenger in keke and increase in transport fare")
recode s5q13b__96 (1=0) if inlist(str,"they have reduced the number of passengers and double the transport fare"	/*
*/	,"they have reduced the number of passengers on board"	/*
*/	,"reduced number of passenger in keke and increase in transport fare")

preserve
sort str
li str if length(str)>0 & s5q13b__96==1, sep(0)
restore
drop str 

#d ; 
loc s=13; //	stub
ren (s5q11 s5q12
	s5q13__1 s5q13__2 s5q13__3 s5q13__4 
	s5q13b__1 s5q13b__2 s5q13b__3
	)
	(item_need`s' item_access`s'
	item_noaccess_cat2`s'	item_noaccess_cat4`s'	
	item_noaccess_cat11`s'	item_noaccess_cat5`s'	
	item_ltfull_cat2`s'		item_ltfull_cat1`s'		
	item_ltfull_cat5`s'
	
	); 
#d cr 

keep hhid item*
#d ; 
reshape long item_need item_access
	item_noaccess_cat1	item_noaccess_cat2	
	item_noaccess_cat3	item_noaccess_cat4	
	item_noaccess_cat5	item_noaccess_cat6	
	item_noaccess_cat11	item_noaccess_cat12	
	item_noaccess_cat13	item_noaccess_cat21	
	
	item_fullbuy 
	item_ltfull_cat1	item_ltfull_cat2	
	item_ltfull_cat3	item_ltfull_cat4	
	item_ltfull_cat5	item_ltfull_cat6	
	item_ltfull_cat11	item_ltfull_cat21	
	
	, i(hhid) j(item); 
#d cr

tab2 item item_need item_access, first m
cap : la drop s5q11 s5q12	//	implemented with capture due to change in reshape syntax between stata versions 18 and 19 
la val item_need item_access .
recode item_need item_access (1=1)(2 0=0)(else=.)

tabstat item_*, s(min max) c(s)	//	good
label_access_item
ta item

g round=  3
tempfile r3
sa		`r3'
}	/*	 r3 end	*/


{	/*	round 4	*/
d s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta"	//	not really
u hhid s5* using	"${raw_hfps_nga1}/r4_sect_a_2_5_5b_6_8_9_12.dta", clear
g item=11	//	only one item, no need for a reshape here 
g item_need		= (s5q2==1)	if inlist(s5q2,1,2)
g item_access	= (s5q3==1)	if inlist(s5q3,1,2)
ta s5q4	//	no cases of codes 3 or 4
la li s5q4
ta s5q4_os
recode s5q4 96=1 if s5q4_os=="No transport fare"
g item_noaccess_cat6	= (s5q4==1) if !mi(s5q4)
g item_noaccess_cat2	= (s5q4==2) if !mi(s5q4)
// g item_noaccess_cat1	= (s5q4==1) if !mi(s5q4)
// g item_noaccess_cat4	= (s5q4==1) if !mi(s5q4)
g item_noaccess_cat12	= (s5q4==5) if !mi(s5q4)
g item_noaccess_cat13	= (s5q4==6) if !mi(s5q4)

keep hhid item*
g round=  4
tempfile r4
sa		`r4'
}	/*	 r4 end	*/


{	/*	round 7	*/
d s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta"	//	not really
u hhid s5* using	"${raw_hfps_nga1}/r7_sect_a_5_6_8_9_12.dta", clear

la li s5q1h s5q1k s5q1m
g str = strtrim(stritrim(strlower(s5q1h_os)))
preserve
sort str
li str if length(str)>0 & s5q1h==96, sep(0)
restore
recode s5q1h (96=1) if strpos(str,"electric")>0 | strpos(str,"light")>0 | strpos(str,"power")>0 | strpos(str,"spoiled")>0 
recode s5q1h (96=1)	if inlist(str,"flood destroyed water pumpp"	/*
*/	,"generator used in pumping water was faulty","nepa"	/*
*/	,"solar energy used in pumping water was faulty"	/*
*/	,"the borehole was faulty","the borehole was under repairs"	/*
*/	,"the tap was bad")
recode s5q1h (96=3)	if inlist(str,"no drawer to draw the water and there has been too much que at the borehole"	/*
*/	,"no one to help fetch water","sometime the crowd is too much."	/*
*/	,"the population is much","the population is too much"	/*
*/	,"the population is too much for one well"	/*
*/	,"water was polluted")
recode s5q1h (96=6)	if inlist(str,"distance is to far","distance is too far"	/*
*/	,"far from home","place of water too far","problem of long distance"	/*
*/	,"that is very difficult for them to get, were they usually fesh the water is to far."	/*
*/	,"the river is far from us","the water source is too far")
recode s5q1h (96=10)	if inlist(str,"lack of money"	/*
*/	)
li str if length(str)>0 & s5q1h==96, sep(0)
drop str

g str = strtrim(stritrim(strlower(s5q1k_os)))
li str if length(str)>0 & s5q1k==96, sep(0)
drop str
g str = strtrim(stritrim(strlower(s5q1m_os)))
li str if length(str)>0 & s5q1m==96, sep(0)
recode s5q1m (96=1) if inlist(str,"no electricity to pump water"	/*
*/	,"no light to pump water")
recode s5q1m (96=3) if inlist(str,"water was polluted"	/*
*/	,"the river is somtimes dry","no much water flowing in the river now"	/*
*/	,"polluted by aminals")
recode s5q1m (96=6) if inlist(str,"far from home","distance too far"	/*
*/	,"the source of water is too far")
li str if length(str)>0 & s5q1m==96, sep(0)
drop str


*	drinking water
g item_need_9=1	//	this is an implicit variable 
g item_fullbuy_9 = (s5q1g==2) if inlist(s5q1e,1,2)

g item_ltfull_cat1_9		= (s5q1h==4)	if !mi(s5q1h)
g item_ltfull_cat2_9		= (s5q1h==5)	if !mi(s5q1h)
g item_ltfull_cat3_9		= (s5q1h==6)	if !mi(s5q1h)
g item_ltfull_cat4_9		= (s5q1h==7)	if !mi(s5q1h)
g item_ltfull_cat5_9		= (s5q1h==8)	if !mi(s5q1h)
g item_ltfull_cat6_9		= (s5q1h==10)	if !mi(s5q1h)

g item_ltfull_cat11_9	= (s5q1h==11)	if !mi(s5q1h)
g item_ltfull_cat91_9	= (s5q1h==1)	if !mi(s5q1h)
g item_ltfull_cat92_9	= (s5q1h==2)	if !mi(s5q1h)
g item_ltfull_cat93_9	= (s5q1h==3)	if !mi(s5q1h)

*	soap to wash hands 
g item_fullbuy_2=(s5q1j==1) if inlist(s5q1j,1,2)
ta s5q1k,m

g item_ltfull_cat1_2		= (s5q1k==1) if !mi(s5q1k)
g item_ltfull_cat2_2		= (s5q1k==2) if !mi(s5q1k)
g item_ltfull_cat3_2		= (s5q1k==3) if !mi(s5q1k)
g item_ltfull_cat4_2		= (s5q1k==4) if !mi(s5q1k)
g item_ltfull_cat5_2		= (s5q1k==5) if !mi(s5q1k)
g item_ltfull_cat6_2		= (s5q1k==7) if !mi(s5q1k)
g item_ltfull_cat11_2	= (s5q1k==8) if !mi(s5q1k)

*	hand washing water
g item_fullbuy_10=(s5q1l==1) if inlist(s5q1l,1,2)
ta s5q1m,m

g item_ltfull_cat1_10 = (s5q1m==4)	if !mi(s5q1m)
g item_ltfull_cat2_10 = (s5q1m==5)	if !mi(s5q1m)
g item_ltfull_cat3_10 = (s5q1m==6)	if !mi(s5q1m)
g item_ltfull_cat4_10 = (s5q1m==7)	if !mi(s5q1m)
g item_ltfull_cat5_10 = (s5q1m==8)	if !mi(s5q1m)
g item_ltfull_cat6_10 = (s5q1m==10)	if !mi(s5q1m)

g item_ltfull_cat11_10 = (s5q1m==11)	if !mi(s5q1m)
g item_ltfull_cat91_10 = (s5q1m==1)	if !mi(s5q1m)
g item_ltfull_cat92_10 = (s5q1m==2)	if !mi(s5q1m)
g item_ltfull_cat93_10 = (s5q1m==3)	if !mi(s5q1m)

keep hhid item*

keep hhid item*
#d ;
reshape long item_need_ item_access_ item_fullbuy_
	item_noaccess_cat1_	item_noaccess_cat2_ 
						item_noaccess_cat4_ 
						item_noaccess_cat6_
	item_ltfull_cat1_	item_ltfull_cat2_ 
	item_ltfull_cat3_	item_ltfull_cat4_ 
	item_ltfull_cat5_	item_ltfull_cat6_
	item_ltfull_cat11_	item_ltfull_cat91_
	item_ltfull_cat92_	item_ltfull_cat93_
	, i(hhid) j(item); 
#d cr 
ren *_ *
label_access_item
g round=  7
tempfile r7
sa		`r7'
}	/*	 r7 end	*/


{	/*	round 9	*/
d s5* using	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta"		//	yes
u hhid s5* using 	"${raw_hfps_nga1}/r9_sect_a_2_5_5c_5d_6_12.dta", clear

#d ; 
ren (s5q1a? s5q1b? 
	s5q1c?__1	s5q1c?__2	
	s5q1c?__3	s5q1c?__4	
	s5q1c?__5	s5q1c?__6	
	)
	(item_need? item_access? 
	item_noaccess_cat1?	item_noaccess_cat2?	
	item_noaccess_cat3?	item_noaccess_cat4?	
	item_noaccess_cat5?	item_noaccess_cat6?	
	);
#d cr 
ren item*9 item*14	//	match onion code to that set in the program tracking codes across all rounds 

la val item_need* item_access* .
recode item_need* item_access* (1=1)(0 2=0)(else=.)

*	health items 
la li s5q1f
g item_need11 = (s5q1f==1) if inlist(s5q1f,1,2)
// ren (s5q1g__? s5q1h__?)(item_need5? item_access5?)

*	ignoring the O/S here, too much detail for this task 
la li s5q1i_1 s5q1i_2 s5q1i_3 s5q1i_4 s5q1i_5 s5q1i_6 s5q1i_7 s5q1i_96	//	identical
	*	this is the start of phase 2 coding
forv i=1/7 {
	g item_need5`i' = (s5q1g__`i'==1)
	g item_access5`i' = (s5q1h__`i'==1) if item_need5`i'==1
	forv j=1/8 {
		loc z=`j'+40
	g item_noaccess_cat`z'5`i' = (s5q1i_`i'==`j') if item_access5`i'==2
	}
}

keep hhid item*
*	rename to ensure reliability of the reshape 
ren item_noaccess_cat4??? item_noaccess_cat4?_??
ren item_noaccess_cat?14 item_noaccess_cat?_14
ren item_noaccess_cat?? item_noaccess_cat?_?
#d ; 
reshape long	item_need item_access
	item_noaccess_cat1_	item_noaccess_cat2_	item_noaccess_cat3_	
	item_noaccess_cat4_	item_noaccess_cat5_	item_noaccess_cat6_	
	item_noaccess_cat41_	item_noaccess_cat42_	item_noaccess_cat43_	
	item_noaccess_cat44_	item_noaccess_cat45_	item_noaccess_cat46_	
	item_noaccess_cat47_	item_noaccess_cat48_	
	, i(hhid) j(item);
#d cr 
ren item_noaccess_cat*_ item_noaccess_cat*
	la val item_need item_access .
	recode  item_need item_access (2 0=0)(1=1)(else=.)
	ta item_need item_access,m
label_access_item
g round=  9
tempfile r9
sa		`r9'
}	/*	 r9 end	*/


{	/*	round 10	*/
d		s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta"		//	not really
u hhid	s5* using	"${raw_hfps_nga1}/r10_sect_a_2_5_6_9_9a_12.dta", clear		//	not really

la li s5q1f
g item_need11 = (s5q1f==1) if inlist(s5q1f,1,2)
// ren (s5q1g__? s5q1h__?)(item_need5? item_access5?)
*	ignoring the O/S here, too much detail for this task 
la li s5q1i_1 s5q1i_2 s5q1i_3 s5q1i_4 s5q1i_5 s5q1i_6 s5q1i_7 s5q1i_96	//	identical
	*	some additional detail was added in this round, we will ignore it for maximum compatibility
forv i=1/7 {
	g item_need5`i' = (s5q1g__`i'==1)
	g item_access5`i' = (s5q1h__`i'==1) if item_need5`i'==1
	forv j=1/8 {
		loc z=`j'+40
	g item_noaccess_cat`z'5`i' = (s5q1i_`i'==`j') if item_access5`i'==2
	}
}

keep hhid item*
#d ; 
reshape long	item_need item_access
	item_noaccess_cat41	item_noaccess_cat42	item_noaccess_cat43	
	item_noaccess_cat44	item_noaccess_cat45	item_noaccess_cat46	
	item_noaccess_cat47	item_noaccess_cat48	
	, i(hhid) j(item);
#d cr 
	la val item_need item_access .
	recode  item_need item_access (2 0=0)(1=1)(else=.)
	ta item_need item_access,m
	ta item item_need,m
label_access_item
g round=  10
tempfile r10
sa		`r10'
}	/*	 r10 end	*/


{	/*	round 11	*/
d		s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
u hhid	s5* using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta", clear
	
la li s5q1f
g item_need11 = (s5q1f==1) if inlist(s5q1f,1,2)
// ren (s5q1g__? s5q1h__?)(item_need5? item_access5?)
*	ignoring the O/S here, too much detail for this task 
la li s5q1i_1 s5q1i_2 s5q1i_3 s5q1i_4 s5q1i_5 s5q1i_6 s5q1i_7 s5q1i_96	//	identical
	*	some additional detail was added in this round, we will ignore it for maximum compatibility
forv i=1/7 {
	g item_need5`i' = (s5q1g__`i'==1)
	g item_access5`i' = (s5q1h__`i'==1) if item_need5`i'==1
	forv j=1/8 {
		loc z=`j'+40
	g item_noaccess_cat`z'5`i' = (s5q1i_`i'==`j') if item_access5`i'==0
	}
	}

keep hhid item*
#d ; 
reshape long	item_need item_access
	item_noaccess_cat41	item_noaccess_cat42	item_noaccess_cat43	
	item_noaccess_cat44	item_noaccess_cat45	item_noaccess_cat46	
	item_noaccess_cat47	item_noaccess_cat48	
	, i(hhid) j(item);
#d cr 
	la val item_need item_access .
	recode  item_need item_access (2 0=0)(1=1)(else=.)
	ta item_need item_access,m
	ta item item_need,m
label_access_item
g round=  11
tempfile r11
sa		`r11'
}	/*	 r11 end	*/


{	/*	round 13	*/
d					using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
d		s5*			using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
d		s5fq4__?	using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta"	//	no
d		s5q1g__?	using	"${raw_hfps_nga1}/r11_sect_a_2_5_5b_6_12b_12.dta"	//	not really
u hhid	s5*			using	"${raw_hfps_nga2}/p2r1_sect_a_2_5_6_9a_12.dta", clear

la li s5fq3
ta s5fq3
g item_need = (s5fq3==1)
g item=11
keep hhid item*
tempfile item11
sa		`item11'

d		s5* using	"${raw_hfps_nga2}/p2r1_sect_5.dta"	//	no
u					"${raw_hfps_nga2}/p2r1_sect_5.dta", clear
ta service_cd random_read,m
ta service_cd s5fq4,m
ta random_read s5fq4	//	yes, reading led to higher rate it appears

la li service_cd
g item = service_cd-1 if service_cd!=96
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6b_2	//	standard 9-item set 

	foreach i of numlist 1/9 {
	g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}

	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
mer 1:1 hhid using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items'

isid hhid item
sort hhid item
label_access_item

g round=  13
tempfile r13
sa		`r13'
}	/*	 r13 end	*/


{	/*	round 15	*/
d		s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta"	//	no
u hhid	s5* using	"${raw_hfps_nga2}/p2r3_sect_a_2_5_6_6c_9a_12.dta", clear
ta s5fq3
g item_need = (s5fq3==1)
g item=11
keep hhid item*
tempfile item11
sa		`item11'

d		s5* using	"${raw_hfps_nga2}/p2r3_sect_5.dta"	//	no
u					"${raw_hfps_nga2}/p2r3_sect_5.dta", clear
ta service_cd random_read,m
ta service_cd s5fq4,m
ta random_read s5fq4	//	yes, reading led to higher rate it appears

la li service_cd
g item = service_cd-1 if service_cd!=96
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6_2

	foreach i of numlist 1/9 {
	g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}

	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
mer 1:1 hhid using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items'

isid hhid item
sort hhid item
label_access_item

g round=  15
tempfile r15
sa		`r15'
}	/*	 r15 end	*/


{	/*	round 16	*/
d			using	"${raw_hfps_nga2}/p2r4_sect_5.dta"	//	no
d		s5* using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta"	//	no
u hhid	s5*	using	"${raw_hfps_nga2}/p2r4_sect_a_2_5_5g_6_11a_11b_12.dta", clear

ta s5fq3,m
g item_need11 = (s5fq3==1) if inlist(s5fq3,1,2)
ta s5gq1 s5gq0,m	//	fuel
g item_access21 = (s5gq1==1) if inlist(s5gq1,1,2,3)

keep hhid item*
reshape long item_need item_access, i(hhid) j(item)
assert mi(item_need) if item==21
assert mi(item_access) if item==11
ta item_need item
tempfile item11
sa		`item11'

d		s5* using	"${raw_hfps_nga2}/p2r4_sect_5.dta"	//	no
u					"${raw_hfps_nga2}/p2r4_sect_5.dta", clear

ta service_cd s5fq4,m

la li service_cd
g item = service_cd-1 if service_cd!=96	//	exclude "other"
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6

	foreach i of numlist 1/9 {
	g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}

	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
g item=11
mer 1:1 hhid item using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items'

isid hhid item
sort hhid item
label_access_item


g round=  16
tempfile r16
sa		`r16'
}	/*	 r16 end	*/


{	/*	round 17	*/
d		s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta"
u hhid	s5* using	"${raw_hfps_nga2}/p2r5_sect_a_2_5_6_9a_11b_13_12.dta", clear
ta s5fq3
g item_need = (s5fq3==1)
g item=11
keep hhid item*
tempfile item11
sa		`item11'

d s5* using	"${raw_hfps_nga2}/p2r5_sect_5.dta"	//	no
u			"${raw_hfps_nga2}/p2r5_sect_5.dta", clear

ta service_cd
la li service_cd
g item = service_cd-1 if service_cd!=96	//	exclude "other"
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4 s5fq5,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6

	foreach i of numlist 1/9 {
		g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}
	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
mer 1:1 hhid using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items'
isid hhid item
label_access_item


g round=  17
tempfile r17
sa		`r17'
}	/*	 r17 end	*/


{	/*	round 18	*/
// d			using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices 
u			"${raw_hfps_nga2}/p2r8_sect_5h.dta", clear

la li food_code
recode food_code (10=8)(13=4)(30=6)(31=7)(42=5)(72=14), gen(item)
label_access_item

g item_avail=(s5hq1==1)
keep hhid item*
isid hhid item
tempfile food
sa		`food'


d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
u			"${raw_hfps_nga2}/p2r8_sect_5i.dta", clear

ta s5iq2
la li s5iq2
ta s5iq2_os
recode s5iq2 (96=8) if s5iq2_os=="BOAT"
g item = s5iq2 + 30 if s5iq2<=8
recode item (.=39) if s5iq2_os=="PICK UP"
drop if mi(item)

g item_access = s5iq1==1
ta item item_access,m

collapse (max) item_access, by(hhid item)
ta item item_access,m
reshape wide item_access, i(hhid) j(item)
reshape long
recode item_access (.=0)
tempfile transit
sa		`transit'

d		s5*	using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta"	
u hhid	s5*	using	"${raw_hfps_nga2}/p2r6_sect_a_2_5_6_8_11b_12.dta", clear
ta s5fq3
g item_need = (s5fq3==1)
g item=11
keep hhid item*
tempfile item11
sa		`item11'

d s5* using	"${raw_hfps_nga2}/p2r6_sect_5.dta"
u			"${raw_hfps_nga2}/p2r6_sect_5.dta", clear
ta service_cd
la li service_cd
g item = service_cd-1 if service_cd!=96
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4 s5fq5,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6

	foreach i of numlist 1/9 {
		g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}
	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
mer 1:1 hhid using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items' `food' `transit'
isid hhid item
label_access_item

g round=  18
tempfile r18
sa		`r18'
}	/*	 r18 end	*/


{	/*	round 19	*/
d s5* using	"${raw_hfps_nga2}/p2r7_sect_5i.dta"	//	transit
u			"${raw_hfps_nga2}/p2r7_sect_5i.dta", clear
 
ta s5iq2
la li s5iq2
ta s5iq2_os
recode s5iq2 (96=8) if s5iq2_os=="BOAT"
g item = s5iq2 + 30 if s5iq2<=8
recode item (.=39) if s5iq2_os=="PICK UP"
drop if mi(item)

g item_access = s5iq1==1
ta item item_access,m

collapse (max) item_access, by(hhid item)
ta item item_access,m
reshape wide item_access, i(hhid) j(item)
reshape long
recode item_access (.=0)
tempfile transit
sa		`transit'

d s5* using	"${raw_hfps_nga2}/p2r7_sect_5h.dta"	//	bringing in _avail here 
u			"${raw_hfps_nga2}/p2r7_sect_5h.dta", clear	
ta food_code s5hq1,m
g item_avail=(s5hq1==1)	//	no condition here, this is a simple yes/no and we will take don't know and missing as functionally equivalent to no
recode food_code (13=4)(42=5)(30=6)(31=7)(10=8)(72=14), gen(item)
keep hhid item*
isid hhid item
tempfile addfood
sa		`addfood'

d		s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta"	//	petrol
u hhid	s5* using	"${raw_hfps_nga2}/p2r7_sect_a_2_5g_11b_13a_12.dta", clear
ta s5gq1 s5gq0,m
g item=21
g item_access = (s5gq1==1) if inlist(s5gq1,1,2,3)

// 	g item_noaccess_cat1	= s5gq2__1==1 | s5gq2__5==1	if item_access==1
// 	g item_noaccess_cat2	= s5gq2__2==1				if item_access==1
// 	g item_noaccess_cat5	= s5gq2__3==1 | s5gq2__4==1	if item_access==1

keep hhid item*
append using `addfood' `transit'
isid hhid item
label_access_item

g round=  19
tempfile r19
sa		`r19'
}	/*	 r19 end	*/


{	/*	round 20	*/
dir "${raw_hfps_nga2}/p2r8_*.dta"
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5.dta"	//	yes, health
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5h.dta"	//	yes, food prices. We could argue that knowing the price is tantamount to needing the good,
d s5* using	"${raw_hfps_nga2}/p2r8_sect_5i.dta"	//	yes, transit prices
d s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta"	//	fuel prices

u			"${raw_hfps_nga2}/p2r8_sect_5h.dta", clear	
ta food_code s5hq1,m
g item_avail=(s5hq1==1)	//	no condition here, this is a simple yes/no and we will take don't know and missing as functionally equivalent to no
recode food_code (13=4)(42=5)(30=6)(31=7)(10=8)(72=14), gen(item)
keep hhid item*
isid hhid item
tempfile food
sa		`food'

u			"${raw_hfps_nga2}/p2r8_sect_5i.dta", clear	
ta destination_code
la li destination_code
// recode destination_code (10=31)(12=32), gen(item)	//	should the "item" be the destination or the mode of transit
	*->	in this module, it seems like the more important distinction is probably the 
	*	mode of transit rather than the destination
ta s5iq1
g item_access=(s5iq1==1)
ta s5iq2
la li s5iq2
ta s5iq2_os
recode s5iq2 96=8 if s5iq2_os=="BOAT"
g item= s5iq2+30 if inrange(s5iq2,1,8)
recode item (.=39) if s5iq2==96 & s5iq2_os=="PICK UP"
ta item item_access, m
keep if !mi(item)
collapse (max) item_access, by(hhid item)	//	duplicates are possible here due to multiple destinations

ta item item_access,m
reshape wide item_access, i(hhid) j(item)
reshape long
recode item_access (.=0)
ta item item_access,m

tempfile transit 
sa		`transit'

u hhid	s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta", clear
ta s5gq1 s5gq0,m
g item=21
g item_access = (s5gq1==1) if inlist(s5gq1,1,2,3)
	*	codes match round 19
// 	g item_noaccess_cat1	= s5gq2__1==1 | s5gq2__5==1	if item_access==1
// 	g item_noaccess_cat2	= s5gq2__2==1				if item_access==1
// 	g item_noaccess_cat5	= s5gq2__3==1 | s5gq2__4==1	if item_access==1

keep hhid item*
tempfile fuel
sa		`fuel'

u hhid	s5* using	"${raw_hfps_nga2}/p2r8_sect_a_2_5_5g_6_11c_14_12.dta", clear
ta s5fq3
g item_need = (s5fq3==1)
g item=11
keep hhid item*
tempfile item11
sa		`item11'

d s5* using	"${raw_hfps_nga2}/p2r8_sect_5.dta"
u			"${raw_hfps_nga2}/p2r8_sect_5.dta", clear
ta service_cd
la li service_cd
g item = service_cd-1 if service_cd!=96
recode item (0=8)
replace item=item+50
keep if !mi(item)

ta s5fq4 s5fq5,m
g item_need = (s5fq4==1) if inlist(s5fq4,1,2)
g item_access = (s5fq5==1) if item_need==1
ta s5fq6
la li s5fq6

ta s5fq6_os

	foreach i of numlist 1/9 {
		g item_noaccess_cat4`i'	= (s5fq6==`i')	if item_access==0
	}
	
keep hhid item*
tempfile items
sa		`items'

collapse (min) item_access (max) item_noaccess_cat*, by(hhid)
mer 1:1 hhid using `item11'
assert item_need==1 if _merge==3
assert item_need==0 if _merge==1
drop _merge

append using `items' `food' `transit' `fuel'
isid hhid item
label_access_item


g round=  20
tempfile r20
sa		`r20'
}	/*	 r20 end	*/


{	/*	round 21	*/
dir "${raw_hfps_nga2}/p2r9_*.dta"
d		s5* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta"	//	fuel & fertilizer prices

u hhid	s5j* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta", clear
d
ta s5jq1 s5jq0,m

g item_access = (s5jq1==1) if inlist(s5jq1,1,2,3)

ta s5jq2	//	mislabeled, this is actually types of fertilizer
g item = s5jq2+40 if inrange(s5jq2,1,3)
ta s5jq2_os	//	it's a hodgepodge, just bin it into 44 
recode item (.=44) if s5jq2==96
ta item item_access,m	//	two versions here 
keep hhid item*

preserve
keep if !mi(item_access)
replace item=40
tempfile anyfert
sa		`anyfert'
restore

keep if !mi(item)
tempfile specfert
sa		`specfert'


u hhid	s5g* using	"${raw_hfps_nga2}/p2r9_sect_a_2_5g_5j_6_6e_8_8a_11c_11c2_12.dta", clear
ta s5gq1 s5gq0,m
g item=21
g item_access = (s5gq1==1) if inlist(s5gq1,1,2,3)
	*	codes match round 19
// 	g item_noaccess_cat1	= s5gq2__1==1 | s5gq2__5==1	if item_access==1
// 	g item_noaccess_cat2	= s5gq2__2==1				if item_access==1
// 	g item_noaccess_cat5	= s5gq2__3==1 | s5gq2__4==1	if item_access==1

keep hhid item*

append using `anyfert' `specfert'
isid hhid item
label_access_item
g round=  21
tempfile r21
sa		`r21'
}	/*	 r21 end	*/



{	/*	round 22	*/

d s5* using	"${raw_hfps_nga2}/p2r10_sect_5.dta"	//	yes, general 
u			"${raw_hfps_nga2}/p2r10_sect_5.dta", clear
ta sect5_access__id
la li sect5_access__id
recode sect5_access__id (1=1)(2=2)(3=40)(10=8)(13=4)(30=6)(31=7)(42=5)(72=14)(else=.), gen(item) 
keep if !mi(item)

ta s5q1a s5q1b,m
g item_need = (s5q1a==1) if inlist(s5q1a,1,2)
g item_access = (s5q1b==1) if item_need==1
g item_fullbuy = (s5q2a==1) if item_access==1

		g item_noaccess_cat1	= (s5q1c__1==1 | s5q1c__3==1 | s5q1c__5==1)	if item_access==0
		g item_noaccess_cat5	= (s5q1c__2==1)	if item_access==0
		g item_noaccess_cat3	= (s5q1c__4==1 | s5q1c__6==1)	if item_access==0
		g item_noaccess_cat6	= (s5q1c__7==1)	if item_access==0
	
	cleanstr s5q1c_os
	ta str
	drop str

		g item_ltfull_cat1	= (s5q2b__1==1 | s5q2b__3==1 | s5q2b__5==1)	if item_fullbuy==0
		g item_ltfull_cat5	= (s5q2b__2==1)	if item_fullbuy==0
		g item_ltfull_cat3	= (s5q2b__4==1 | s5q2b__6==1)	if item_fullbuy==0
		g item_ltfull_cat6	= (s5q2b__7==1)	if item_fullbuy==0

	cleanstr s5q2b_os
	ta str
	drop str

keep hhid item*
isid hhid item
label_access_item

g round=  22
tempfile r22
sa		`r22'
}	/*	 r22 end	*/



/*	append all rounds	*/
clear
append using `r1' `r2' `r3' `r4' `r7' `r9' `r10' `r11' `r13' `r15' `r16' `r17' `r18' `r19' `r20' `r21' `r22', nolabel
isid	hhid round item
order	hhid round item
sort	hhid round item

ta item
label_access_item
ta item round

*	need to harmonize item once other versions are available 
order item_avail item_need item_access item_noaccess_cat? item_noaccess_cat??	/*
*/	item_fullbuy item_ltfull_cat? item_ltfull_cat1? item_ltfull_cat2? item_ltfull_cat9?, a(item)

*	label contents here, but these are subject to reorganization in the panel construction
la var item_avail		"Item is available for sale"
la var item_need		"HH needed item in last 7 days"
la var item_access		"HH accessed item in last 7 days"
label_item_ltfull noaccess
la var item_fullbuy		"HH accessed full amount of item needed in last 7 days"
g item_ltfull_lbl=., b(item_ltfull_cat1)

label_item_ltfull ltfull

sa "${tmp_hfps_nga}/access.dta", replace 
u  "${tmp_hfps_nga}/access.dta", clear 
ta item round
cap : 	prog drop	label_access_item
cap : 	prog drop	label_item_ltfull

ex













