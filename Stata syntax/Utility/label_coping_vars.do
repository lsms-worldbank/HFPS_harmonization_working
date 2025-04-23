

cap : la var shock_cope_1	"Sale of assets (ag and no-ag)"
cap : la var shock_cope_6	"Engaged in additional income generating activities"
cap : la var shock_cope_7	"Received assistance from friends & family"
cap : la var shock_cope_8	"Borrowed from friends & family"
cap : la var shock_cope_9	"Took a loan from a financial institution"
cap : la var shock_cope_11	"Credited purchases"
cap : la var shock_cope_12	"Delayed payment obligations"
cap : la var shock_cope_13	"Sold harvest in advance"
cap : la var shock_cope_14	"Reduced food consumption"
cap : la var shock_cope_15	"Reduced non-food consumption"
cap : la var shock_cope_16	"Relied on savings"
cap : la var shock_cope_17	"Received assistance from NGO"
cap : la var shock_cope_18	"Took advanced payment from employer"
cap : la var shock_cope_19	"Received assistance from government"
cap : la var shock_cope_20	"Was covered by insurance policy"
cap : la var shock_cope_21	"Did nothing"
cap : la var shock_cope_96	"Other (specify)"

	*	Ethiopia
cap : la var shock_cope_22	"Spiritual efforts"
	
	*	Burkina Faso phase 2+
cap : la var shock_cope_10	"Borrowed from money lenders"
cap : la var shock_cope_31	"One or more family members migrated for work"
cap : la var shock_cope_32	"Took children out of school"
cap : la var shock_cope_33	"Sent children to live elsewhere"
	
	
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
loc remainder : list all_ordered - first
order `remainder', a(`first')

*	make null variable to contain overall label 
cap : g byte shock_cope_lbl=.
order shock_cope_lbl, b(`first')
la var shock_cope_lbl	"[...] to cope with shock"


