cap :	prog drop	dens_by_round
		prog define	dens_by_round
	syntax varlist(min=1)
foreach y of local varlist {
levelsof round, loc(rounds)
loc graphspec = ""
loc i=1
loc orderspec = ""
foreach r of local rounds {
	loc graphspec = "`graphspec'" + "(kdensity `y' if round==`r')"
	loc orderspec = `"`orderspec'  `i' "r`r'""'
	loc ++i
}
country_data_signature
twoway `graphspec', legend(pos(1) ring(0) symx(*0.3) order(`orderspec'))	///
	ti("`r(signature)' `y'", pos(11) ring(1) siz(*0.9))	///
	xti("`: var lab `y''") yti("Density") name("`r(stub)'_`y'", replace)
	}
end 
