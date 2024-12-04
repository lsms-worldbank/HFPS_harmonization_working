

cap : la var shock_cope_1	"Sale of assets (ag and no-ag) to cope with shock"
cap : la var shock_cope_6	"Engaged in additional income generating activities to cope with shock"
cap : la var shock_cope_7	"Received assistance from friends & family to cope with shock"
cap : la var shock_cope_8	"Borrowed from friends & family to cope with shock"
cap : la var shock_cope_9	"Took a loan from a financial institution to cope with shock"
cap : la var shock_cope_11	"Credited purchases to cope with shock"
cap : la var shock_cope_12	"Delayed payment obligations to cope with shock"
cap : la var shock_cope_13	"Sold harvest in advance to cope with shock"
cap : la var shock_cope_14	"Reduced food consumption to cope with shock"
cap : la var shock_cope_15	"Reduced non-food consumption to cope with shock"
cap : la var shock_cope_16	"Relied on savings to cope with shock"
cap : la var shock_cope_17	"Received assistance from ngo to cope with shock"
cap : la var shock_cope_18	"Took advanced payment from employer to cope with shock"
cap : la var shock_cope_19	"Received assistance from government to cope with shock"
cap : la var shock_cope_20	"Was covered by insurance policy to cope with shock"
cap : la var shock_cope_21	"Did nothing to cope with shock"
cap : la var shock_cope_96	"Other (specify) to cope with shock"

	*	Ethiopia
cap : la var shock_cope_22	"Spiritual efforts"
	
	*	Burkina Faso phase 2+
cap : la var shock_cope_10	"Borrowed from money lenders to cope with shock"
cap : la var shock_cope_31	"One or more family members migrated for work to cope with shock"
cap : la var shock_cope_32	"Took children out of school to cope with shock"
cap : la var shock_cope_33	"Sent children to live elsewhere to cope with shock"
	
	
	*	Nigeria round 22 - petrol price related
cap : la var shock_cope_41	"Reduced purchase quantity"
cap : la var shock_cope_42	"Reduced frequency of own vehicle/generator use"
cap : la var shock_cope_43	"Used more public transportation"
ds shock_cope_*, not(varl *)

	*	automated removal of label stub
ds, has(varl "*to cope with shock*")
loc drop_lbl_stub `r(varlist)'
foreach d of local drop_lbl_stub {
	loc lbl = subinstr("`: var lab `d''"," to cope with shock","",1)
	la var `d' "`lbl'"
}

cap : la var shock_cope_os	"Description of other coping mechanism"

*	re-order
cap : ds shock_cope_?, not(type string) alpha
loc single_digit `r(varlist)'
cap : ds shock_cope_??, not(type string) alpha
loc double_digit `r(varlist)'
cap : ds shock_cope_os, has(type string) alpha
loc os `r(varlist)'
loc all_ordered `single_digit' `double_digit' `os'
loc first : word 1 of `all_ordered'
loc remainder = subinstr("`all_ordered'","`first'","",1)
order `remainder', a(`first')


