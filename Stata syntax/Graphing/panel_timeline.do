




#d ; 
u cc round phase using "${tmp_hfps_pnl}/cover.dta", clear;
duplicates drop; tempfile phase; sa `phase'; 
u "${tmp_hfps_pnl}/cover.dta", clear;
loc y pnl_intdate; 
collapse (min)	min=`y'	(max)	max=`y'	
		 (p2)	p02=`y'	(p98)	p98=`y'		
		 (p5)	p05=`y'	(p95)	p95=`y'		
		 (p50)	med=`y'	(mean)	avg=`y'		
		 , by(cc round); 
mer 1:1 cc round using `phase', assert(3) nogen; 
#d cr
egen mid_m = rowmean(min max) 
egen mid_2 = rowmean(p02 p98) 
egen mid_5 = rowmean(p05 p95) 


format min max p02 p98 p05 p95 mid_? %tdMon_CCYY

bys cc phase (round) : egen phasemin = min(min)
bys cc phase (round) : egen phasemax = max(max)

format phasemin phasemax %tdMon_CCYY

table cc phase, stat(min min) stat(max max) stat(mean phasemin phasemax) nototal

*	structure to arrange vertically to make labels more ledgible
expand 2, gen(lohi)
ta lohi
replace cc=cc-0.15 if lohi==0
replace cc=cc+0.15 if lohi==1

#d ;
loc p1_options "horizontal fc(none) barwidth(0) lc(gs6)  lw(thin) lp(longdash)"; 
loc p2_options "horizontal fc(none) barwidth(0) lc(gs9)  lw(thin) lp(shortdash)"; 
loc p3_options "horizontal fc(none) barwidth(0) lc(gs12) lw(thin) lp(solid)"; 
loc phasecall; 
/*forv c=1/6 {; 
	levelsof phase if cc==`c', loc(cphases); 
	foreach p of local cphases {; */
	foreach p of numlist 1(1)3 {;
loc phasecall `"`phasecall'
	(rbar phasemin phasemax cc if phase==`p', `p`p'_options')
	"'; 
	}; /*}; */
	dis "`phasecall'"; 

loc rbar_options "horizontal fc(white) lc(gs0) lw(medthin) barwidth(0.3)"; 
loc sctr_options "ms(none) mlabel(round) mlabpos(0) mlabcolor(gs0) mlabsiz(*0.9)"; 
levelsof round, loc(rounds); 
loc graphcall; 
foreach r of local rounds {; 
	loc graphcall `"`graphcall'
	(rbar min max cc if round==`r' & lohi==1, `rbar_options')
	(scatter cc mid_m if round==`r' & lohi==0, `sctr_options')
	"'; 
	}; 
	dis "`graphcall'"; 
	
gr twoway /*`phasecall'*/ `graphcall' 
	, 
	ylabel(1(1)6, valuelabel nogrid ) 
	ymtick(0.5(1)6.5, grid glcolor(gs14) noticks) 
	yscale(reverse)
	tlabel(	1Jan2020 1Jan2021 1Jan2022 1Jan2023 1Jan2024
		, grid glcolor(gs14) glpattern(solid) glwidth(medthin))
	
	tmtick(	1Apr2020 1Jul2020 1Oct2020	1Apr2021 1Jul2021 1Oct2021
			1Apr2022 1Jul2022 1Oct2022	1Apr2023 1Jul2023 1Oct2023
			1Apr2024 1Jul2024 1Oct2024
			, grid glcolor(gs15) glpattern(solid) glwidth(medthin))
	
	legend(off) name(HFPS_timeline, replace);
#d cr

gr export "${hfps}/Data visualization/HFPS_timeline.png", as(png) name(HFPS_timeline) replace
gr close	HFPS_timeline
ex


u "${tmp_hfps_pnl}/cover.dta", clear

table (start_yr start_mo)(round), nototal
ta round cc
ta start_yr cc
// recode round (1/12=1 "Phase 1")(13/max=2 "Phase 2"), gen(phase)
// recode phase (1=2) if cc=="TZA":cc & round>8
table (phase round) cc, nototal

keep if start_yr>2019
gr hbox pnl_intdate, over(cc)
_pctile pnl_intdate, percentiles( 2 5 95 98 )

cou if pnl_intdate==`r(r1)' | pnl_intdate==`r(r2)'




ex


reshape long minmax cut2 cut5, i(cc round) j(id)

#d ; 
gr twoway 
	(rbar )

cap : drop c?_r*
loc z cut2
levelsof cc, loc(countrycodes)
foreach c of local countrycodes {
	levelsof round if cc==`c', loc(cc_rounds)
	foreach r of local cc_rounds {
		qui : g c`c'_r`r' = `z' if cc==`c' & round==`r'
	}
}

ds c?_r*
graph t c?_r*, over(cc) nooutsides nofill
restore

#d ; 
loc bfaclr dkgreen; 
loc ethclr cranberry; 
loc mwiclr dkorange; 
loc ngaclr blue; 
loc tzaclr magenta; 
loc ugaclr chocolate; 
loc j=5; 
loc steps 1.0 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.25 0.2 0.1 0.05; 
forv i=1/`: word count `steps'' {; loc s`i' : word `i' of `steps'; }; 
loc options jitter(`j') msiz(*0.1) ms(p); 



gr twoway 
	(scatter cc pnl_intdate if cc==1 & round== 1, mc(`bfaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 1, mc(`ethclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 1, mc(`mwiclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 1, mc(`ngaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 1, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 1, mc(`ugaclr'*`s1' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 2, mc(`bfaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 2, mc(`ethclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 2, mc(`mwiclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 2, mc(`ngaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 2, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 2, mc(`ugaclr'*`s2' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 3, mc(`bfaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 3, mc(`ethclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 3, mc(`mwiclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 3, mc(`ngaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 3, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 3, mc(`ugaclr'*`s3' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 4, mc(`bfaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 4, mc(`ethclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 4, mc(`mwiclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 4, mc(`ngaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 4, mc(`tzaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 4, mc(`ugaclr'*`s4' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 5, mc(`bfaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 5, mc(`ethclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 5, mc(`mwiclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 5, mc(`ngaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 5, mc(`tzaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 5, mc(`ugaclr'*`s5' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 6, mc(`bfaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 6, mc(`ethclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 6, mc(`mwiclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 6, mc(`ngaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 6, mc(`tzaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 6, mc(`ugaclr'*`s6' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 7, mc(`bfaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 7, mc(`ethclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 7, mc(`mwiclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 7, mc(`ngaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 7, mc(`tzaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 7, mc(`ugaclr'*`s7' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 8, mc(`bfaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 8, mc(`ethclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 8, mc(`mwiclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 8, mc(`ngaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 8, mc(`tzaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 8, mc(`ugaclr'*`s8' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round== 9, mc(`bfaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==2 & round== 9, mc(`ethclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==3 & round== 9, mc(`mwiclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==4 & round== 9, mc(`ngaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==5 & round== 9, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round== 9, mc(`ugaclr'*`s9' ) `options')
 
	(scatter cc pnl_intdate if cc==1 & round==10, mc(`bfaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==2 & round==10, mc(`ethclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==3 & round==10, mc(`mwiclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==4 & round==10, mc(`ngaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==5 & round==10, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==10, mc(`ugaclr'*`s10') `options')

	(scatter cc pnl_intdate if cc==1 & round==11, mc(`bfaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==2 & round==11, mc(`ethclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==3 & round==11, mc(`mwiclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==4 & round==11, mc(`ngaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==5 & round==11, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==11, mc(`ugaclr'*`s12') `options')

	(scatter cc pnl_intdate if cc==1 & round==12, mc(`bfaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==2 & round==12, mc(`ethclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==3 & round==12, mc(`mwiclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==4 & round==12, mc(`ngaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==5 & round==12, mc(`tzaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==12, mc(`ugaclr'*`s12') `options')

	(scatter cc pnl_intdate if cc==1 & round==13, mc(`bfaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==13, mc(`ethclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==13, mc(`mwiclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==13, mc(`ngaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==13, mc(`tzaclr'*`s4' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==13, mc(`ugaclr'*`s1' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==14, mc(`bfaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==14, mc(`ethclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==14, mc(`mwiclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==14, mc(`ngaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==14, mc(`tzaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==14, mc(`ugaclr'*`s2' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==15, mc(`bfaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==15, mc(`ethclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==15, mc(`mwiclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==15, mc(`ngaclr'*`s3' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==15, mc(`tzaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==15, mc(`ugaclr'*`s3' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==16, mc(`bfaclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==2 & round==16, mc(`ethclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==3 & round==16, mc(`mwiclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==4 & round==16, mc(`ngaclr'*`s4') `options')
	(scatter cc pnl_intdate if cc==5 & round==16, mc(`tzaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==16, mc(`ugaclr'*`s4') `options')

	(scatter cc pnl_intdate if cc==1 & round==17, mc(`bfaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==17, mc(`ethclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==17, mc(`mwiclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==17, mc(`ngaclr'*`s5' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==17, mc(`tzaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==17, mc(`ugaclr'*`s5' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==18, mc(`bfaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==18, mc(`ethclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==18, mc(`mwiclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==18, mc(`ngaclr'*`s6' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==18, mc(`tzaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==18, mc(`ugaclr'*`s6' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==19, mc(`bfaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==19, mc(`ethclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==19, mc(`mwiclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==19, mc(`ngaclr'*`s7' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==19, mc(`tzaclr'*`s10' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==19, mc(`ugaclr'*`s7') `options')

	(scatter cc pnl_intdate if cc==1 & round==20, mc(`bfaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==20, mc(`ethclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==20, mc(`mwiclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==20, mc(`ngaclr'*`s8' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==20, mc(`tzaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==6 & round==20, mc(`ugaclr'*`s8' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==21, mc(`bfaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==2 & round==21, mc(`ethclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==3 & round==21, mc(`mwiclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==4 & round==21, mc(`ngaclr'*`s9' ) `options')
	(scatter cc pnl_intdate if cc==5 & round==21, mc(`tzaclr'*`s12') `options')
	(scatter cc pnl_intdate if cc==6 & round==21, mc(`ugaclr'*`s9' ) `options')

	(scatter cc pnl_intdate if cc==1 & round==22, mc(`bfaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==2 & round==22, mc(`ethclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==3 & round==22, mc(`mwiclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==4 & round==22, mc(`ngaclr'*`s10') `options')
	(scatter cc pnl_intdate if cc==5 & round==22, mc(`tzaclr'*`s1' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==22, mc(`ugaclr'*`s10') `options')

	(scatter cc pnl_intdate if cc==1 & round==23, mc(`bfaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==2 & round==23, mc(`ethclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==3 & round==23, mc(`mwiclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==4 & round==23, mc(`ngaclr'*`s11') `options')
	(scatter cc pnl_intdate if cc==5 & round==23, mc(`tzaclr'*`s2' ) `options')
	(scatter cc pnl_intdate if cc==6 & round==23, mc(`ugaclr'*`s11') `options')


	, ylabel(1(1)6, valuelabel nogrid) ymtick(0.5(1)6.5, grid glcolor(gs14) noticks) 
	legend(off);
#d cr 


