
cap : la drop pnl_rltn

label define pnl_rltn 1 `"Head"', modify
label define pnl_rltn 2 `"Spouse"', modify
label define pnl_rltn 3 `"Child"', modify
label define pnl_rltn 4 `"Parent"', modify
label define pnl_rltn 5 `"Grandchild"', modify
// label define pnl_rltn 6 `"Grandparent"', modify	//->these are recategorized into 8
label define pnl_rltn 7 `"Sibling"', modify
label define pnl_rltn 8 `"Other relative"', modify
label define pnl_rltn 9 `"Other non-relative"', modify
label define pnl_rltn 10 `"Servant or relative of servant"', modify


la val pnl_rltn pnl_rltn
inspect pnl_rltn
assert r(N_undoc)==0


