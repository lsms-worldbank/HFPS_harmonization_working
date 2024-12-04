

cap : program drop wordsearch 
      program def  wordsearch
	 
syntax anything(name=searchterms), DIRectories(string asis) [retain]

qui {
tempfile outfile 

foreach d of local directories {
	dis `"`d'"'
	local files : dir `"`d'"' files "*.dta"
	dis `"`files'"'
	foreach f of local files {
		loc filename = `"`d'"' + "/`f'"
preserve
		u `"`filename'"', clear
		ds, has(varl "`searchterms'")
		loc vars `r(varlist)'
		if length("`vars'")>0 {
			u `vars' using `"`filename'"', clear
			d, replace clear
			g dir = `"`d'"'
			g file = "`f'"
			tempfile result
			sa		`result', replace
			clear
			cap : u `outfile'
			append using `result'
			sa `outfile', replace 
		}
restore
	}
}

}

if length("`retain'")==0  preserve
u `outfile', clear
if _N==0 dis as error "`searchterms' not found"
else	{
	sort dir file position
	li name format vallab varlab file, sepby(file)
	}
if length("`retain'")==0  restore

end



ex

wordsearch "*ocket* *OCKET*", dir("${raw_hfps_eth}" )
wordsearch "*ocket* *OCKET*", dir("${raw_hfps_nga1}" "${raw_hfps_nga2}" )
wordsearch "*ocket* *OCKET*", dir("${raw_hfps_uga}/round1" "${raw_hfps_uga}/round2") retain


u	"${raw_hfps_nga1}/r1_sect_a_3_4_5_6_8_9_12.dta", clear
ds, has(varl *pocket* *POCKET*)
ds, has(varl *Zone*)
d `r(varlist)', replace clear






