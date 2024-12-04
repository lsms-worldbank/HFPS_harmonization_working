

dir "${raw_hfps_uga}", w
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

d using	"${raw_hfps_uga}/round1/SEC4.dta"
d using	"${raw_hfps_uga}/round2/SEC4.dta"
d using	"${raw_hfps_uga}/round3/SEC4.dta"
d using	"${raw_hfps_uga}/round4/SEC4.dta"
d using	"${raw_hfps_uga}/round5/SEC4.dta"
d using	"${raw_hfps_uga}/round6/SEC4A.dta"	//	some asset ownership but a few yes/no purchase questions as well
d using	"${raw_hfps_uga}/round6/SEC4_1.dta"	//	a basic price module, and some food access 
d using	"${raw_hfps_uga}/round7/SEC4_2.dta"	
d using	"${raw_hfps_uga}/round8/SEC4.dta"	//	new version, identified at hhid goods_access__id level
d using	"${raw_hfps_uga}/round9/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round10/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round11/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round12/SEC4.dta"	//	as in r8
d using	"${raw_hfps_uga}/round13/SEC4.dta"	//	as in r8
// d using	"${raw_hfps_uga}/round14/SEC4.dta"	//	no access module in round 14 







cap : mkdir "${dtop}/tmp"
loc todrop : dir "${dtop}/tmp" files "*.dta"
foreach file of local todrop {
	erase "${dtop}/tmp/`file'"
}


cap :	prog drop	labelround 
		prog def	labelround
*	1	variable label 
*	2	string file name enclosed in quotes 
*	3	directory to save temporary dataset created by the program

u "`2'", clear
uselabel `1', clear
sa		"`3'"
end 
labelround goods_access__id "${raw_hfps_uga}/round8/SEC4.dta" "${dtop}/tmp/r8.dta"

cap :	prog drop	iteration
		prog def	iteration

cap : mkdir "${dtop}/tmp"
loc todrop : dir "${dtop}/tmp" files "*.dta"
foreach file of local todrop {
	erase "${dtop}/tmp/`file'"
}

		preserve

labelround	goods_access__id "${raw_hfps_uga}/round8/SEC4.dta"	"${dtop}/tmp/r8.dta"
labelround	goods_access__id "${raw_hfps_uga}/round9/SEC4.dta"	"${dtop}/tmp/r9.dta"
labelround	goods_access__id "${raw_hfps_uga}/round10/SEC4.dta"	"${dtop}/tmp/r10.dta"
labelround	goods_access__id "${raw_hfps_uga}/round11/SEC4.dta"	"${dtop}/tmp/r11.dta"
labelround	goods_access__id "${raw_hfps_uga}/round12/SEC4.dta"	"${dtop}/tmp/r12.dta"
labelround	goods_access__id "${raw_hfps_uga}/round13/SEC4.dta"	"${dtop}/tmp/r13.dta"

loc touse : dir "${dtop}/tmp" files "*.dta"
dis `: word count `touse''

u "${dtop}/tmp/`: word 1 of `touse''", clear
foreach r of numlist 2(1)`: word count `touse'' {
	mer 1:1 value label using  "${dtop}/tmp/`: word `r' of `touse''", gen(_`r')
}
li value label _*, nol

loc todrop : dir "${dtop}/tmp" files "*.dta"
foreach file of local todrop {
	erase "${dtop}/tmp/`file'"
}
rmdir "${dtop}/tmp"
		restore
end


iteration


program drop iteration
prog drop labelround
