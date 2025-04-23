
/*
algorithm for gender 

1	if you switch for <2 rounds, we enforce the mode
2	if the switch persists for 2+ rounds, then retain the data 


algorithm for age 

1	disallow getting younger -> replace with previous
2	increasing by >1 year is not allowed, replace with previous
3	not required: allow increasing by 1 between rounds - create a sum of 
	changes and check its extent
	-> actually enforce a jump in cases where age is continuous? 

algorithm for relation
1	don't generate additional heads - better to leave missing than generate new issues 


leave aside the relation changes - this will be for the data users to decide. 
*/

	
cap : program drop		demographic_shifts
      program define	demographic_shifts

	version 18 
	
	syntax, [tofix(varlist min=1 max=4 numeric)] HHid(name) INDid(name) [relationcode(integer 101)]
	
// 	loc hhid	y4_hhid 
// 	loc indid	pid
// 	loc tofix	relation
//	

	cap : ds pnl_intdate	//	this is the date at which the interview occurred, which will be used in cases where we adjust age 
	if _rc!=0 {
		dis as text "please bring variable pnl_intdate through in the merge from the cover page dataset"
		error 111
	}
	
	*	this structure must exist for the following to make sense
	isid `hhid' `indid' round
	sort `hhid' `indid' round
	
	*	verify presence of other necessary variables 
	if length("`tofix'")>0 {
	ds `tofix'
	}
	else {
	ds age sex relation
	}
	loc to_fix `r(varlist)'
	
	foreach x of local to_fix {
		cap : drop a_`x'
		g a_`x'=`x'
	bys `hhid' `indid' (round) : replace a_`x'=a_`x'[_n-1] if mi(a_`x') & !mi(a_`x'[_n-1])
		cap : drop z_`x'
		tempvar firstpass maxmiss maxnmiss minnmiss modenmiss fillmiss 
	loc tgt a_`x'
	
	bys `hhid' `indid' (round) : egen `maxmiss'= max(mi(`tgt'))
	by  `hhid' `indid' (round) : egen `maxnmiss'= max(`tgt')
	by  `hhid' `indid' (round) : egen `minnmiss'= min(`tgt')
	by  `hhid' `indid' (round), rc0 : egen `modenmiss'= mode(`tgt')
	
	*	identify the last non-missing observation and take that as the final fix 
	tempvar nmi  nmi_obs max_nmi val_at_max fill_last
	                                g `nmi'		= 1 if !mi(`tgt')
	by  `hhid' `indid' (round) :    g `nmi_obs'	= _n * `nmi'
	by  `hhid' `indid' (round) : egen `max_nmi'	= max(`nmi_obs')
	g `val_at_max' = `tgt' if `nmi_obs'==`max_nmi'
	by  `hhid' `indid' (round) : egen `fill_last' = max(`val_at_max')
	
	
	
	g 		`fillmiss' = `maxnmiss' if `maxmiss'==1 & `maxnmiss'==`minnmiss'
	replace `fillmiss' = `modenmiss' if mi(`fillmiss') & `maxnmiss'==1
	replace `fillmiss' = `fill_last' if mi(`fillmiss') 
	
// 	su `x' if `maxmiss'==1
	g z_`x' = cond(!mi(`tgt'),`tgt',`fillmiss')
	su `x' a_`x' z_`x' if `maxmiss'==1
	
	*	verify that all individuals with any missing have all missing 
	tempvar flag
	by  `hhid' `indid' (round) : egen `flag'	= max(mi(z_`x'))
	assert mi(z_`x') if `flag'==1
	drop `flag'

	
	assert z_`x'==`x' if !mi(`x')
	
	drop `maxmiss' `maxnmiss' `minnmiss' `modenmiss' `fillmiss' 
	drop `nmi'  `nmi_obs' `max_nmi' `val_at_max' `fill_last'
	
		}

	*	now implement the algorithms
	
	if strpos("`to_fix'","sex")>0	{	/*	sex	*/
	tempvar decision min max inddum midum case cases summin summax lastrank maxrank tgt_at_max lastfill 
	
	loc tgt z_sex 
	bys `hhid' `indid' (round) : egen `min' = min(`tgt')
	by  `hhid' `indid' (round) : egen `max' = max(`tgt')
	by  `hhid' `indid' (round) : egen `inddum' = max(`min'!=`max')
	by  `hhid' `indid' (round) : egen `midum' = max(mi(`tgt'))
	recode `inddum' (0=1) if `midum'==1

	
	g `case'=`tgt'!=`tgt'[_n-1] if !mi(`tgt') & !mi(`tgt'[_n-1]) & `inddum'==1
	by  `hhid' `indid' (round) : egen `cases'  = sum(`case') if `inddum'==1
	ta `cases'
	
	by  `hhid' `indid' (round) : egen `summin' = sum(`tgt'==`min') if `inddum'==1
	by  `hhid' `indid' (round) : egen `summax' = sum(`tgt'==`max') if `inddum'==1
	
	by  `hhid' `indid' (round) : g `lastrank' = _n if !mi(`tgt') & `inddum'==1
	by  `hhid' `indid' (round) : egen `maxrank' = max(`lastrank')
	g `tgt_at_max'=`tgt' if `lastrank'==`maxrank' & `inddum'==1
	by  `hhid' `indid' (round) : egen `lastfill' = max(`tgt_at_max')
	
	*	if there is a distinct switch with at least two 
	g `decision'=(`cases'==1 & `summin'>=2 & `summax'>=2) if `inddum'==1
	recode `decision' (0=2) if `summin'<`summax'
	recode `decision' (0=3) if `summin'>`summax'
	recode `decision' (0=4) if `summin'==`summax'
	assert `decision'!=0
	ta `decision'
	
	
	cap : drop x_sex
	g x_sex = `tgt' if `inddum'==0
	replace x_sex = `tgt' if `inddum'==1 & `decision'==1
	
	*	where there is more than one switch, or < 2 periods
	replace x_sex = `min' if `decision'==2
	replace x_sex = `max' if `decision'==3
	replace x_sex = `lastfill' if `decision'==4
	
	*	tiebreaker will be most recent obs. downside is that this means the data
	*	are less stable in cases where a new round brings a change in
	compare x_sex `tgt'
	tabstat sex ?_sex, s(n me)
	
	drop `decision' `min' `max' `inddum' `case' `cases' `summin' `summax' `lastrank' `maxrank' `tgt_at_max' `lastfill' 

	compare sex x_sex
	replace sex=x_sex
	drop ?_sex
	}	/*	sex	*/

	if strpos("`to_fix'","age")>0	{	/*	age	*/

	tempvar min max inddum indtime indtmin indtmax indband delta allowed problem indprob sumprob lastrank maxrank tgt_at_max lastfill
	
	loc tgt z_age 
	bys `hhid' `indid' (round) : egen `min' = min(`tgt')
	by  `hhid' `indid' (round) : egen `max' = max(`tgt')
	by  `hhid' `indid' (round) : egen `inddum' = max(`min'!=`max' | mi(`tgt'))
	ta `inddum'
	g `delta' = `tgt'-`tgt'[_n-1]	if !mi(`tgt') & !mi(`tgt'[_n-1]) & `inddum'==1
	su `delta',d
	
	*	in a linear conception of time, which we assume for the purposes of this 
	*	variable, shifts >1 year forward in a single round 
	by  `hhid' `indid' (round) : g `indtime' = pnl_intdate - pnl_intdate[_n-1]
	recode `indtime' (.=0) if !mi(pnl_intdate)

	by  `hhid' `indid' (round) : egen `indtmin' = min(pnl_intdate)
	by  `hhid' `indid' (round) : egen `indtmax' = max(pnl_intdate)
	by  `hhid' `indid' (round) : g `indband' = floor((`indtmax'-`indtmin')/365)
	ta `indband'
	replace `indband'=`indband'+1	//	allow for +1 in the year 
	
	*	we will allow +2 shifts because of the possile jumps within the range of 
	*	the full HFPS timeline if a member dropped in and out of the roster
	
	*	currently, we do not correct for the possibility of having too many +1 shifts 
	
	g `allowed' =  inrange(`delta',0,`indband')	if `inddum'==1
	g `problem' = !inrange(`delta',0,`indband')	if `inddum'==1	
	by  `hhid' `indid' (round) : egen `indprob' = max(`problem')
	ta `allowed' `problem'
	ta `indprob'
	by  `hhid' `indid' (round) : egen `sumprob' = sum(`problem') if `indprob'==1
	ta `sumprob'	//	
	
	*	due to the need for a simple solution, we will take the most recent value to be correct if die
	by  `hhid' `indid' (round) : g `lastrank' = _n if !mi(`tgt') & `inddum'==1
	by  `hhid' `indid' (round) : egen `maxrank' = max(`lastrank')
	g `tgt_at_max'=`tgt' if `lastrank'==`maxrank' & `inddum'==1
	by  `hhid' `indid' (round) : egen `lastfill' = max(`tgt_at_max')
	
	*	need to account for the passage of time then in cases where we take lastfill
	tempvar date_at_max filldate days_delta years_delta finalfill
	g `date_at_max' = pnl_intdate if `lastrank'==`maxrank' & `inddum'==1
	by  `hhid' `indid' (round) : egen `filldate' = max(`date_at_max')
	g `days_delta' = `filldate' - pnl_intdate if `inddum'==1
	g `years_delta' = floor(`days_delta' / 365)
	
	ta `years_delta' `inddum',m
	g `finalfill' = `lastfill' + `years_delta'
	dis as text "age * time inputs for problem cases"
	su `tgt' `lastfill' `filldate' `days_delta' `years_delta' `finalfill' if `indprob'==1, sep(0)
	
	
// 	ta `tgt' `inddum'
	tabstat `tgt', by(`inddum') s(n mean min p25 p50 p75 max) format(%9.0fc) nototal
	g x_age = `tgt' if `inddum'==0
	replace x_age = `tgt' if `indprob'==0
	replace x_age = `finalfill' if mi(x_age)

	compare x_age `tgt'
	tabstat age ?_age, s(n me)
	
	drop `min' `max' `inddum' `indtime' `indband' `delta' `allowed' `problem' `indprob' `sumprob' `lastrank' `maxrank' `tgt_at_max' `lastfill' 
	drop `date_at_max' `days_delta' `years_delta' `finalfill'

	compare age x_age
	replace age=x_age
	drop ?_age
	}	/*	age	*/

	if strpos("`to_fix'","relation")>0	{	/*	relation	*/
	
	if length("`headcode'")==0 loc headcode 1 
	if length("`relationcode'")==0 loc relationcode 101 
	tempvar headtestraw headtesta headtestz
	bys `hhid' round (`indid') : egen `headtestraw' = sum(relation==1)
	cap : ds member
	if _rc==0 recode ?_relation (1=`relationcode') if member!=1 & relation!=1 
	by  `hhid' round (`indid') : egen `headtesta' = sum(a_relation==1)
	by  `hhid' round (`indid') : egen `headtestz' = sum(z_relation==1)
	
	tab1 `headtestraw' `headtesta' `headtestz'
	
	ta relation z_relation,m
	g x_relation = z_relation
	recode x_relation (1=.) if `headtestz'>1 & relation!=1
	drop ?_relation
	drop `headtestraw' `headtesta' `headtestz'
	
	cap : ds head member
	if _rc==0 replace head = (relation==1) if member==1

	}


	
end












