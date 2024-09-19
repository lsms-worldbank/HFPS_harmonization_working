

loc investigation=0
if `investigation'==1	{	/*	shutoff bracket to skip investigation work if we just desire to reset the data	*/

{	/*	data inventory	*/

dir "${raw_hfps_bfa}", w	//we need section 6 
dir "${raw_hfps_bfa}/r*_sec6a*.dta", w	//we need section 6, but it splits in sections after the first  
dir "${raw_hfps_bfa}/r*_sec6c*.dta", w	//we need section 6, but it splits in sections after the first  


d using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d using	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		
d using	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"	
// d using	"${raw_hfps_bfa}/r14_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"	
// d using	"${raw_hfps_bfa}/r16_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r20_sec6a_emplrev_general.dta"	
d using	"${raw_hfps_bfa}/r21_sec6a_emplrev_general.dta"	

*	NFE modules
d using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		
}	/*	end data inventory	*/


{	/*	investigate subsamples	*/
u					"${raw_hfps_bfa}/r21_sec6a_emplrev_general.dta"		, clear
mer 1:1 hhid using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"
	//	unclear why this mismatch exists, but we will simply ignore for now
ds *, not(type string)
loc nstrings `r(varlist)'
tabstat `nstrings', by(subsample) s(n) save
mat z = (r(Stat1)', r(Stat2)', r(StatTotal)')
mat coln z = "`r(name1)'" "`r(name2)'" Total
mat li z
mat r21=z

u					"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"		, clear
mer 1:1 hhid using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"
	//	unclear why this mismatch exists, but we will simply ignore for now
ds *, not(type string)
loc nstrings `r(varlist)'
tabstat `nstrings', by(subsample) s(n) save
mat z = (r(Stat1)', r(Stat2)', r(StatTotal)')
mat coln z = "`r(name1)'" "`r(name2)'" Total
mat li z
mat r19=z


u					"${raw_hfps_bfa}/r20_sec6a_emplrev_general.dta"		, clear
ds *, not(type string)
loc nstrings `r(varlist)'
tabstat `nstrings', by(subsample) s(n) save
mat z = (r(Stat1)', r(Stat2)', r(StatTotal)')
mat coln z = "`r(name1)'" "`r(name2)'" Total
mat li z
mat r20=z

u					"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		, clear
ds *, not(type string)
loc nstrings `r(varlist)'
tabstat `nstrings', by(subsample) s(n) save
mat z = (r(Stat1)', r(Stat2)', r(StatTotal)')
mat coln z = "`r(name1)'" "`r(name2)'" Total
mat li z
mat r18=z

}	/*	end subsample investigations	*/


{	/*	employment sector codes	*/
u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear
uselabel s06q04a, clear
tempfile r1
sa		`r1' 
u	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r2
sa		`r2' 
u	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r3
sa		`r3' 
u	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r4
sa		`r4' 
u	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r5
sa		`r5' 
u	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r6
sa		`r6' 
u	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r7
sa		`r7' 
u	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r8
sa		`r8' 
u	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r9
sa		`r9' 
u	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r10
sa		`r10' 
u	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r11
sa		`r11' 
u	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r12
sa		`r12' 
u	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r13
sa		`r13' 
u	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r15
sa		`r15' 
u	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear
tempfile r17
sa		`r17' 
// u	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		, clear
// uselabel s06q04a, clear	//	not labeled in this dataset
// tempfile r18
// sa		`r18' 
// u	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"		, clear
// uselabel s06q04a, clear	//	not labeled in this dataset
// tempfile r19
// sa		`r19' 
u	"${raw_hfps_bfa}/r20_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear	//	not labeled in this dataset
tempfile r20
sa		`r20' 
u	"${raw_hfps_bfa}/r21_sec6a_emplrev_general.dta"		, clear
uselabel s06q04a, clear	//	not labeled in this dataset
tempfile r21
sa		`r21' 

u `r1', clear
foreach i of numlist 2/13 15 17 20 21 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
u	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		, clear
la li s06q04a	//	this contains all codes 
/*
	1 Agriculture											
	2 Extraction minière									
	3 Branche manufacturière								
	4 Activités techniques et scientifiques					
	5 Electricité/eau/gaz/déchets							
	6 Construction											
	7 Transports											
	8 Commerce												
	9 Banques, assurances, immobilier						
	10 Services personnels									
	11 Education											
	12 Sante												
	13 Administration publique								
	14 Tourisme												
	15 Autre, spécifier										
	16 Fabrication/transformation de produits alimentaires	

 1 Agriculture
 2 Mining
 3 Manufacturing branch
 4 Technical and scientific activities
 5 Electricity/water/gas/waste
 6 Building
 7 Transportation
 8 Trade
 9 Banks, insurance, real estate
10 Personal services
11 Education
12 Health
13 Public administration
14 Tourism
15 Other, specify
16 Manufacturing/processing of food products
*/
}	/*	end sector codes	*/


{	/*	nfe sector codes	*/
u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear
uselabel s06q11, clear
tempfile r1
sa		`r1' 
u	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r2
sa		`r2' 
u	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r3
sa		`r3' 
u	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r4
sa		`r4' 
u	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r6
sa		`r6' 
u	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r8
sa		`r8' 
u	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q11, clear
tempfile r9
sa		`r9' 
u	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear
tempfile r12
sa		`r12' 
u	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12a, clear
tempfile r17
sa		`r17' 
u	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear	//	not labeled in this dataset
tempfile r19
sa		`r19' 

u	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear	//	not labeled in this dataset
tempfile r19
sa		`r19' 

u	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		, clear
uselabel s06q12, clear	//	not labeled in this dataset
tempfile r21
sa		`r21' 

u `r1', clear
foreach i of numlist 2/4 6 8 9 12 17 19 21 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
	*	simple changes, these are 

u	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		, clear
la li s06q11	//	this contains all codes 
u	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		, clear
la li s06q11	//	this r12_sec6c_emplrev_nonagr all codes 
u	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		, clear
la li s06q12	//	this is re-used in r19 
u	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		, clear
la li s06q12a
/*
 1 Agriculture, chasse, pêche
 2 Exploitation miniére, fabrication
 3 Électricité, gaz, alimentation en eau
 4 Construction
 5 Achat et vente de biens, réparation de biens, hôtels et restaurants
 6 Trasport, conduite, poste, voyage agence
 7 Activités professionnelles, finance, juridique, analyse, ordinateur, immobilier
 8 Administration publique
 9 Services personnels, éducation, santé culture, sport, travail domestique, autres


 1 Agriculture
 2 Mining
 3 Manufacturing branch
 4 Technical and scientific activities
 5 Electricity/water/gas/waste
 6 Building
 7 Transportation
 8 Trade
 9 Banks, insurance, real estate
10 Personal services
11 Education
12 Health
13 Public administration
14 Tourism
15 Other, specify
16 Manufacturing/processing of food products
*/
}	/*	end nfe sector codes	*/


{	/*	employment type codes	*/
u	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		, clear
uselabel s06q04b, clear
tempfile r1
sa		`r1' 
u	"${raw_hfps_bfa}/r2_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r2
sa		`r2' 
u	"${raw_hfps_bfa}/r3_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r3
sa		`r3' 
u	"${raw_hfps_bfa}/r4_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r4
sa		`r4' 
u	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r5
sa		`r5' 
u	"${raw_hfps_bfa}/r6_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r6
sa		`r6' 
u	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r7
sa		`r7' 
u	"${raw_hfps_bfa}/r8_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r8
sa		`r8' 
u	"${raw_hfps_bfa}/r9_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r9
sa		`r9' 
u	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r10
sa		`r10' 
u	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r11
sa		`r11' 
u	"${raw_hfps_bfa}/r12_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r12
sa		`r12' 
u	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r13
sa		`r13' 
u	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r15
sa		`r15' 
u	"${raw_hfps_bfa}/r17_sec6a_emplrev_general.dta"		, clear
uselabel s06q04b, clear
tempfile r17
sa		`r17' 
u	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		, clear
la li s06q04b1 s06q04b2
uselabel s06q04b1, clear	//	not labeled in this dataset
tempfile r18
sa		`r18' 
u	"${raw_hfps_bfa}/r19_sec6a_emplrev_general.dta"		, clear
la li s06q04b1 s06q04b2
uselabel s06q04b1, clear	//	not labeled in this dataset
tempfile r19
sa		`r19' 
u	"${raw_hfps_bfa}/r20_sec6a_emplrev_general.dta"		, clear
uselabel q4b, clear	//	not labeled in this dataset
tempfile r20
sa		`r20' 
u	"${raw_hfps_bfa}/r21_sec6a_emplrev_general.dta"		, clear
uselabel q4b, clear	//	not labeled in this dataset
tempfile r21
sa		`r21' 

u `r1', clear
foreach i of numlist 2/13 15 17/21 {
mer 1:1 lname value label using `r`i'', gen(_`i')
}
egen matches = anycount(_? _??), v(3)
ta matches

sort value label lname
li lname value label matches, sepby(value)
li lname value label _*, sepby(value) nol
li value label, sep(0) noobs clean noheader
/*
        1                                               Dans mon propre entreprise NON-AGRICOLE  
        1                                                          Dans votre propre entreprise  
        1                                             Dans votre propre entreprise NON-AGRICOLE  
        1                                             Dans votre propre entreprise NON-AGRICOLE  
        1                                        Pour votre propre compte ou en tant que patron  
        2   Dans une entreprise NON-AGRICOLE exploitée par un membre du ménage ou de la famille  
        2   Dans une entreprise NON-AGRICOLE exploitée par un membre du ménage ou de la famille  
        2   Dans une entreprise NON-AGRICOLE exploitée par un membre du ménage ou de la famille  
        2                Dans une entreprise exploitée par un membre du ménage ou de la famille  
        2           Dans une entreprise familiale NON-AGRICOLE ou gérée par un membre du ménage  
        2           Dans une entreprise familiale non agricole ou gérée par un membre du ménage  
        3                            Dans une exploitation agricole familiale ou dans l'élevage  
        3           Dans une exploitation agricole familiale ou dans l'élevage ou dans la peche  
        3           Dans une exploitation agricole familiale ou dans l'élevage ou dans la pêche  
        3           Dans une exploitation agricole familiale ou dans l'élevage ou dans la pêche  
        3           Dans une exploitation agricole familiale ou dans l'élevage ou dans la pêche  
        3                          Dans une ferme familiale, élever une famille bétail ou pêche  
        4                                             En tant qu'employé pour quelqu'un d'autre  
        4                                     En tant qu'employé/salarié pour quelqu'un d'autre  
        4                                     En tant qu'employé/salarié pour quelqu'un d'autre  
        4                                     En tant qu'employé/salarié pour quelqu'un d'autre  
        4                                                                   En tant que salarié  
        5                                                        En tant qu'apprenti, stagiaire  
        5                                                        En tant qu'apprenti, stagiaire  
        5                                                        En tant qu'apprenti, stagiaire  
        5                                            En tant qu'apprenti, stagiaire (remuneres)  
        5                                             En tant qu'apprenti, stagiaire, stagiaire  
        5                                                   En tant qu'employé  du gouvernement  
        6                                             En tant qu'apprenti, stagiaire, stagiaire  
*->	google translate	*->
 1 In my own NON-AGRICULTURAL business
 1 In your own business
 1 In your own NON-AGRICULTURAL business
 1 In your own NON-AGRICULTURAL business
 1 For your own account or as a boss
 2 In a NON-AGRICULTURAL business operated by a member of the household or family
 2 In a NON-AGRICULTURAL business operated by a member of the household or family
 2 In a NON-AGRICULTURAL business operated by a member of the household or family
 2 In a business operated by a member of the household or family
 2 In a NON-AGRICULTURAL family business or managed by a member of the household
 2 In a non-agricultural family business or managed by a member of the household
 3 On a family farm or in livestock breeding
 3 In a family farm or in livestock breeding or fishing
 3 In a family farm or in livestock breeding or fishing
 3 In a family farm or in livestock breeding or fishing
 3 In a family farm or in livestock breeding or fishing
 3 On a family farm, raising a livestock or fishing family
 4 As an employee for someone else
 4 As an employee/employee for someone else
 4 As an employee/employee for someone else
 4 As an employee/employee for someone else
 4 As an employee
 5 As an apprentice, trainee
 5 As an apprentice, trainee
 5 As an apprentice, trainee
 5 As an apprentice, trainee (paid)
 5 As an apprentice, trainee, intern
 5 As a Government Employee
 6 As an apprentice, trainee, intern
*/
}	/*	end employment type codes	*/




{	/*	variable label inventory	*/
{	/*	employment modules	*/
qui {
preserve
*	r1 must be handled separately for simple method to deal with file naming conventions
u "${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta" , clear
d, replace clear
	replace varlab = strtrim(strlower(varlab))
	tempfile r1
	sa      `r1'

foreach r of numlist 2/13 15 17/21 {
	u "${raw_hfps_bfa}/r`r'_sec6a_emplrev_general.dta" , clear
	d, replace clear
	replace varlab = strtrim(strlower(varlab))
	tempfile r`r'
	sa      `r`r''
}
	u `r1', clear
foreach r of numlist 1/13 15 17/21 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (. 1=.)(2 3=`r')
	la val _`r' .
	la drop _merge
	}

egen matches = rowtotal(_? _??)
ta matches
// ta name matches if matches>=10
// ta name matches if matches<10

// levelsof name if matches>=10, clean
// li name varlab if matches>=10, sep(0)
egen rounds = group(_? _??), label missing
ta rounds
la li rounds
drop if _1==1 & matches==1
}
li name varlab rounds, sep(0)
restore

}

{	/*	NFE modules	*/
qui {
d using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		

preserve
u "${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta" , clear
d, replace clear
	replace varlab = strtrim(strlower(varlab))
	tempfile r1
	sa      `r1'
foreach r of numlist 2/4 6 8 9 12 17 19 21 {
	u "${raw_hfps_bfa}/r`r'_sec6c_emplrev_nonagr.dta" , clear
	d, replace clear
	replace varlab = strtrim(strlower(varlab))
	tempfile r`r'
	sa      `r`r''
}

	u `r1', clear
	
foreach r of numlist 1/4 6 8 9 12 17 19 21 {
	mer 1:1 name varlab using `r`r'', gen(_`r')
	recode _`r' (. 1=.)(2 3=`r')
	la val _`r' .
	la drop _merge
	}

egen matches = rowtotal(_? _??)
ta matches
// ta name matches if matches>=10
// ta name matches if matches<10

// levelsof name if matches>=10, clean
// li name varlab if matches>=10, sep(0)
egen rounds = group(_? _??), label missing
ta rounds
la li rounds
drop if _1==1 & matches==1
}
li name varlab rounds, sep(0)
restore
}

}	/*	end variable label inventory	*/


{	/*	value label inventory	*/
{	/*	employment modules	*/
qui {
preserve
*	r1 must be handled separately for simple method to deal with file naming conventions
	u "${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta" , clear
	la dir
	uselabel `r(labels)', clear
	replace label = strtrim(strlower(label))
	tempfile r1
	sa      `r1'

foreach r of numlist 2/13 15 17/21 {
	u "${raw_hfps_bfa}/r`r'_sec6a_emplrev_general.dta" , clear
	la dir
	uselabel `r(labels)', clear
	replace label = strtrim(strlower(label))
	tempfile r`r'
	sa      `r`r''
}
	u `r1', clear
foreach r of numlist 1/13 15 17/21 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (. 1=.)(2 3=`r')
	la val _`r' .
	la drop _merge
	}

egen matches = rowtotal(_? _??)
ta matches
// ta name matches if matches>=10
// ta name matches if matches<10

// levelsof name if matches>=10, clean
// li name varlab if matches>=10, sep(0)
egen rounds = group(_? _??), label missing
ta rounds
la li rounds
drop if _1==1 & matches==1
}
li lname value label rounds, sepby(lname)
restore

}

{	/*	NFE modules	*/
qui {
d using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		

u 	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta", clear

preserve
	u "${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta" , clear
	la dir
	uselabel `r(labels)', clear
	replace label = strtrim(strlower(label))
	tempfile r1
	sa    	`r1'
foreach r of numlist 2/4 6 8 9 12 17 19 21 {
	u "${raw_hfps_bfa}/r`r'_sec6c_emplrev_nonagr.dta" , clear
	la dir
	uselabel `r(labels)', clear
	replace label = strtrim(strlower(label))
	tempfile r`r'
	sa      `r`r''
}

	u `r1', clear
	
foreach r of numlist 1/4 6 8 9 12 17 19 21 {
	mer 1:1 lname value label using `r`r'', gen(_`r')
	recode _`r' (. 1=.)(2 3=`r')
	la val _`r' .
	la drop _merge
	}

egen matches = rowtotal(_? _??)
ta matches
// ta name matches if matches>=10
// ta name matches if matches<10

// levelsof name if matches>=10, clean
// li name varlab if matches>=10, sep(0)
egen rounds = group(_? _??), label missing
ta rounds
la li rounds
drop if _1==1 & matches==1
}
li lname value label rounds, sepby(lname)
li value label if lname=="s06q10b", clean noobs
li value label if lname=="s06q11b", clean noobs
restore
}

}	/*	end variable label inventory	*/


}	/*	End investigation, begin construction	*/


*	need to mirror NGA and MWI approach and combine the NFE mods into one dataset
#d ; 
foreach r of numlist 2 3 4 6 8 9 12 17 19 21 {;
	u							"${raw_hfps_bfa}/r`r'_sec6a_emplrev_general.dta", clear;
cap : noi : mer 1:1 hhid using	"${raw_hfps_bfa}/r`r'_sec6c_emplrev_nonagr.dta", assert(3) nogen; 
	if _rc==0 {; tempfile r`r'; sa `r`r''; };
	else {; 
	u					"${raw_hfps_bfa}/r`r'_sec6a_emplrev_general.dta", clear;
	mer 1:1 hhid using	"${raw_hfps_bfa}/r`r'_sec6c_emplrev_nonagr.dta", assert(1 3) gen(_`r'); 
	tempfile r`r'; sa `r`r''; };
};
clear; append using

	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
					`r2'
					`r3'		
					`r4'		
	"${raw_hfps_bfa}/r5_sec6a_emplrev_general.dta"		
					`r6'
	"${raw_hfps_bfa}/r7_sec6a_emplrev_general.dta"		
					`r8'
					`r9'		
	"${raw_hfps_bfa}/r10_sec6a_emplrev_general.dta"		
	"${raw_hfps_bfa}/r11_sec6a_emplrev_general.dta"		
					`r12'
	"${raw_hfps_bfa}/r13_sec6a_emplrev_general.dta"		
	
	"${raw_hfps_bfa}/r15_sec6a_emplrev_general.dta"		
	
					`r17'
	"${raw_hfps_bfa}/r18_sec6a_emplrev_general.dta"		
					`r19'
	"${raw_hfps_bfa}/r20_sec6a_emplrev_general.dta"		
					`r21'


, gen(round);
#d cr

	drop _21	//	 don't know the reason these cases exist 
	la drop _append
	la val round 
	ta round 	
replace round=round+1 if round>13
replace round=round+1 if round>15
	ta round
	isid hhid round
	ta subsample round	//	rounds 18-21
	
*	wage employment
tab2 round s06q01 s06q01a, first m
tab2 round s06q04b s06q04b1, first
la li s06q04b s06q04b1
ta s06q04b s06q01, m
	
g work_cur = (s06q01==1) if inlist(s06q01,1,2)
replace work_cur = (s06q01a==1) if inlist(s06q01a,1,2) & round>11
g nwork_cur=1-work_cur
g wage_cur = (work_cur==1 & (inlist(s06q04b,4,5) | inlist(s06q04b1,4,5))) if !mi(work_cur)
g biz_cur  = (work_cur==1 & (inlist(s06q04b,1,2) | inlist(s06q04b1,1,2))) if !mi(work_cur)
g farm_cur = (work_cur==1 & (inlist(s06q04b,3)   | inlist(s06q04b1,3)  )) if !mi(work_cur)
la var  work_cur		"Respondent currently employed"
la var nwork_cur		"Respondent currently unemployed"
la var  wage_cur		"Respondent mainly employed for wages"
la var   biz_cur		"Respondent mainly employed in household enterprise"
la var  farm_cur		"Respondent mainly employed on family farm"
ta round work_cur,m

*	sector
tab2 round s06q04a, m first
la li s06q04a	//	code 16 added in round 13
recode s06q04a (1 16=1)(2 3=2)(4 9=7)(5=3)(6=4)(7=6)(8 14=5)(10/12 15=9)(13=8), gen(sector_cur)
la var sector_cur		"Sector of respondent current employment"
ta sector_cur work_cur,m

qui	{	/*	deal with missingness in sector	*/
bys hhid (round) : replace sector_cur = sector_cur[_n-1] if mi(sector_cur) & work_cur==1
bys hhid (round) : egen aaa = mode(sector_cur)
replace sector_cur = aaa if mi(sector_cur) & work_cur==1
bys hhid (round) : egen bbb = mode(sector_cur), minmode
replace sector_cur = bbb if mi(sector_cur) & work_cur==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
}	/*	end dealing with missingness	*/
	ta sector_cur work_cur,m
	
tabstat *_cur, by(round) s(n sum) longstub

*	no hours in BFA
*	respondent where available 
ta round if !mi(sec6_rep)
ta round if  mi(sec6_rep)
d using  "${tmp_hfps_bfa}/panel/ind.dta"
g membres__id = sec6_rep
mer m:1 hhid membres__id round using "${tmp_hfps_bfa}/panel/ind.dta", keep(1 3)
ta round _m, nol
ta respond if _m==3,m	//	99% same person 
g emp_resp_main = respond
foreach x in sex age head relation {
g emp_resp_`x' = `x' 
}
drop membres__id-_merge
order emp_resp_*, a(sec6_rep)
la var emp_resp_main		"Employment respondent = primary respondent"
la var emp_resp_sex			"Sex of employment respondent"
la var emp_resp_age			"Age of employment respondent"
la var emp_resp_head		"Employment respondent is head"
la var emp_resp_relation	"Employment respondent relationship to household head"

{	/*	contains obsolete code in its original position	*/
// keep hhid round *_cur emp_resp* 
// 	tempfile emp
// 	sa		`emp'
	
	
/*	implement NFE separately
d s06q13a__* using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d s06q13__* using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d s06q15__* using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d s06q15__* using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
d s06q15__* using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		
		*	the variable labels suggest that the codes were not implemented in the same order as written up in the qx 
d using	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
d using	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
d using	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		
		*	the variable labels suggest that the codes were not implemented in the same order as written up in the qx 
#d ; 
clear; append using
	"${raw_hfps_bfa}/r1_sec6_emploi_revenue.dta"		
	"${raw_hfps_bfa}/r2_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r3_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r4_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r6_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r8_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r9_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r12_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r17_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r19_sec6c_emplrev_nonagr.dta"		
	"${raw_hfps_bfa}/r21_sec6c_emplrev_nonagr.dta"		
, gen(round); 
#d cr
	la drop _append
	la val round .
	ta round 	
replace round=round+1 if round>4
replace round=round+1 if round>6
replace round=round+2 if round>9
replace round=round+4 if round>12
replace round=round+1 if round>17
replace round=round+1 if round>19
	ta round
	isid hhid round
*/
}

	g nfe_round = (inlist(round,1,2,3,4,6,8,9,12,17,19,21))
	tab2 round s06q04b s06q04b1 s06q04b2 s06q10 s06q11 if nfe_round==1, first m
	tabstat s06q04b, by(round) s(n min max mean)
	*	don't see documentaiton int he survey for why 4 is split in q19
		*->	simply combining for now
// 	egen cond1 = anymatch(s06q04b s06q04b1 s06q04b2) if nfe_round==1, v(1 2)
	g    cond1 = biz_cur if nfe_round==1	//	allows missingness for the subsample variable 
	g	 cond2 = (s06q10==1) if round!=12 & !mi(s06q10) & nfe_round==1
	g	 cond3 = (s06q11==1) if round==12 & !mi(s06q11) & nfe_round==1
	egen zzz = rowmax(cond?)
	tabstat zzz cond? if nfe_round==1, by(round) s(sum)
	g	refperiod_nfe = zzz if nfe_round==1
	la var	refperiod_nfe	"Household operated a non-farm enterprise (NFE) since previous contact"
	drop zzz cond?
	ta round refperiod_nfe if nfe_round==1,m
	table (round subsample) s06q10 if inlist(round,19,21), nototal missing

tab2 round s06q10a_? s06q10a? s06q11a if nfe_round==1,m first
egen	status_nfe = rowfirst(s06q10a_? s06q10a? s06q11a) if nfe_round==1 //	round!=12
ta s06q13 s06q12 if round==1,m	//	hard to see what the way forward is. 
ta round status_nfe if nfe_round==1,m
run "${do_hfps_util}/label_status_nfe.do" 
la val status_nfe status_nfe
table (round status_nfe) refperiod_nfe
ta s06q11a subsample if inlist(round,19,21),m
recode refperiod_nfe (. 0=1) if inlist(round,19,21) & !mi(status_nfe)
recode status_nfe (.=1) if biz_cur==1 & nfe_round==1
ta refperiod status_nfe if nfe_round==1,m
ta round if mi(refperiod_nfe) & nfe_round==1

g open_nfe = status_nfe==1 if !mi(status_nfe)
ta round status_nfe if nfe_round==1,m
la var	status_nfe		"Operational status of NFE"
la var	open_nfe		"NFE is currently open"

ta round status_nfe,m	//	missing in r12-> can't see how to construct it 
ta refperiod_nfe status_nfe,m
ta round if mi(status_nfe) & refperiod_nfe==1

table round refperiod_nfe, m stat(freq) stat(sum open_nfe)
	
*	sector 
	*	these codes are consistent with the 9-value codes
tab2 round s06q11 s06q12a s06q12, first m	//	ignore the round 1 three code split 
	g		sector_nfe = s06q11 if inrange(round,2,4)
	replace	sector_nfe = s06q11+1 if inrange(round,6,9)
	recode	sector_nfe (8=9) if inrange(round,6,9)
	replace	sector_nfe = s06q12 if inlist(round,12,19)
	replace	sector_nfe = s06q12a if round==17
	ta round sector_nfe
	replace sector_nfe = s06q11 if round==1
	recode	sector_nfe 3=5		if round==1	//	services-> 5
	replace	sector_nfe = sector_cur if biz_cur==1 & mi(sector_nfe) & refperiod_nfe==1
la var	sector_nfe		"Sector of NFE"	//	
ta sector_nfe open_nfe,m
ta sector_nfe refperiod_nfe if nfe_round==1,m

qui {	/*	deal with missingness in sector	*/

*	missingness can occur if the respondent is in the same employment as previous round
	*	put in the previous round's sector if it was non-missing 
	bys hhid (nfe_round round) : replace sector_nfe = sector_nfe[_n-1] if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

	
	*	take mode following this first round and fill in
	bys hhid (round) : egen aaa = mode(sector_nfe)
	replace sector_nfe = aaa if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1
	*	fill in with the solve ties moving away from sector 9 if there are alternatives
	bys hhid (round) : egen bbb = mode(sector_nfe), minmode
	replace sector_nfe = bbb if mi(sector_nfe) & refperiod_nfe==1 & nfe_round==1

ds ???	//	verify that the above are the only three character varnames
assert `: word count `r(varlist)''==2
drop ???
	
	}	/*	end missingness in sector	*/

ta sector_nfe refperiod_nfe if nfe_round==1,m
g sector_biz = sector_cur if biz_cur==1
bys hhid (round) : egen xyz = mode(sector_biz)
replace sector_nfe=xyz if mi(sector_nfe) & refperiod==1
drop sector_biz xyz 

*	reason closed
tab2 round s06q10b s06q11b , first
recode s06q10b (11=96), copyrest gen(r1_r9)
recode s06q11b (1=3)(2 3=13)(5 6=17)(7=6) , copyrest gen(r17)
egen closed_why_nfe = rowfirst(r1_r9 r17)
run "${do_hfps_util}/label_closed_why_nfe.do"


*	challenges 
tabstat s06q13a__*, by(round)
tabstat s06q13__*, by(round)	//	we want s06q13 in round 12, not 15. 
tabstat s06q15__*, by(round)


egen challenge1_nfe	= rowfirst(s06q13a__1	s06q13__1	s06q15__1) if round!=12
egen challenge2_nfe	= rowfirst(s06q13a__2	s06q13__2	s06q15__2) if round!=12
egen challenge3_nfe	= rowfirst(s06q13a__3	s06q13__3	s06q15__3) if round!=12
egen challenge4_nfe	= rowfirst(				s06q13__4	s06q15__4) if round!=12
egen challenge5_nfe	= rowfirst(s06q13a__4	s06q13__5	s06q15__5) if round!=12
egen challenge6_nfe	= rowfirst(s06q13a__5	s06q13__6	s06q15__6) if round!=12
replace challenge1_nfe = max(s06q15__1,s06q15__7) if round==17	//	bin energy inputs with other inputs 

replace challenge1_nfe	= s06q13__1 if round==12
replace challenge2_nfe	= s06q13__2 if round==12
replace challenge3_nfe	= s06q13__3 if round==12
replace challenge4_nfe	= s06q13__4 if round==12
replace challenge5_nfe	= s06q13__5 if round==12
replace challenge6_nfe	= s06q13__6 if round==12

la var challenge1_nfe	"Buying and receiving supplies and inputs"
la var challenge2_nfe	"Raising money for the business"
la var challenge3_nfe	"Repaying loans or other debt obligations"
la var challenge4_nfe	"Paying rent for business location"
la var challenge5_nfe	"Paying workers"
la var challenge6_nfe	"Selling goods or services to customers"

ta round open_nfe,m
tabstat challenge?_nfe ,by(round) s(n sum)
tabstat challenge?_nfe ,by(open_nfe) s(sum)
table round open_nfe, stat(sum challenge?_nfe)

	
keep hhid round *_cur emp_resp* *_nfe
// tempfile nfe
// sa		`nfe'
//	
// u `emp', clear
// mer 1:1 hhid round using `nfe', assert(1 3) nogen


run "${do_hfps_util}/label_emp_sector.do"
la val sector_cur sector_nfe emp_sector

isid hhid round
sort hhid round

sa	"${tmp_hfps_bfa}/panel/employment.dta", replace
u	"${tmp_hfps_bfa}/panel/employment.dta", clear
ta sector_nfe refperiod_nfe,m
ta round if mi(sector_nfe) & refperiod_nfe==1	// widely distributed
ta round 






















































