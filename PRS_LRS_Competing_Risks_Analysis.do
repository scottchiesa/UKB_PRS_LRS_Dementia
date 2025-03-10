***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
*******************PRS & LRS Competing Risks Analysis**********************
***************************************************************************

**Standard settings**

version 15
clear all
macro drop _all
set more off
set maxvar 10000

**Set directory**

cap cd "C:\Users\scott\OneDrive\Desktop\Debug\"
cap cd "/home/rmgpstc/Scratch/PRS_LRS"

use "Dataset_ready_for_imputation_analyses.dta", clear

** 	I couldn't get the competing risks analysis to run using the Stata stcrreg command as a) the computing and time requirements were huge 	///
	and b) it doesn't have an option to include sex as a stratified variable in the same way stcox does. I therefore used the below code 	///
	to loop through each imputation in turn, create weights for the competing risks analyses using stcrprep, then run the analyses and 		///
	export all ten iterations to a datafile so that they could be combined manually using Rubin's rules as documented at the following	 	///
	website -> https://bookdown.org/mwheymans/bookmi/rubins-rules.html **

capture mi convert flong, clear		

label define _mi_m 	0 "Incomplete data"1 "Imputation 1" 	///
						2 "Imputation2" 3 "Imputation 3" 	///
						4 "Imputation4" 5 "Imputation 5" 	///
						6 "Imputation6" 7 "Imputation 7" 	///
						8 "Imputation8" 9 "Imputation 9" 	///
						10 "Imputation10", modify
						
	label values _mi_m _mi_m
	
//bysort _mi_m: summ PRS
//histogram PRS, normal by(_mi_m, cols(2)) 

* Fit the analysis model in each of the imputed datasets and manually combine point 
	* estimates of cfex1 using Rubin's rules*/

	
///////////////////////////ALL-CAUSE DEMENTIA//////////////////////////////	
	
timer on 1

	local sum_SHR_PRS_LRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset allcause_date, failure(allcause_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(allcause_new) ///
		keep(PRS_LRS_tertile_imputed age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
		gen allcause_event = failcode == allcause_new
		stset tstop [pw=weight_c], failure(allcause_event==1) enter(tstart)
		stcox i.PRS_LRS_tertile_imputed age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local shr4_`i' = mat`i'[1,4]
		local shr5_`i' = mat`i'[1,5]
		local shr6_`i' = mat`i'[1,6]
		local shr7_`i' = mat`i'[1,7]
		local shr8_`i' = mat`i'[1,8]
		local shr9_`i' = mat`i'[1,9]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local se4_`i' = mat`i'[2,4]
		local se5_`i' = mat`i'[2,5]
		local se6_`i' = mat`i'[2,6]
		local se7_`i' = mat`i'[2,7]
		local se8_`i' = mat`i'[2,8]
		local se9_`i' = mat`i'[2,9]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ll4_`i' = mat`i'[5,4]
		local ll5_`i' = mat`i'[5,5]
		local ll6_`i' = mat`i'[5,6]
		local ll7_`i' = mat`i'[5,7]
		local ll8_`i' = mat`i'[5,8]
		local ll9_`i' = mat`i'[5,9]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local ul4_`i' = mat`i'[6,4]
		local ul5_`i' = mat`i'[6,5]
		local ul6_`i' = mat`i'[6,6]
		local ul7_`i' = mat`i'[6,7]
		local ul8_`i' = mat`i'[6,8]
		local ul9_`i' = mat`i'[6,9]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		local pval4_`i' = mat`i'[4,4]
		local pval5_`i' = mat`i'[4,5]
		local pval6_`i' = mat`i'[4,6]
		local pval7_`i' = mat`i'[4,7]
		local pval8_`i' = mat`i'[4,8]
		local pval9_`i' = mat`i'[4,9]
		display as text "SHR for PRS_LRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_LRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_LRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_LRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_LRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_LRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_LRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_LRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_LRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_LRS_tertile_3 = " `pval3_`i''
		display as text "SHR for PRS_LRS_tertile_4 = " `shr4_`i''
		display as text "SE for PRS_LRS_tertile_4 = " `se4_`i''
		display as text "LCI for PRS_LRS_tertile_4 = " `ll4_`i''
		display as text "UCI for PRS_LRS_tertile_4 = " `ul4_`i''
		display as text "P for PRS_LRS_tertile_4 = " `pval4_`i''
		display as text "SHR for PRS_LRS_tertile_5 = " `shr5_`i''
		display as text "SE for PRS_LRS_tertile_5 = " `se5_`i''
		display as text "LCI for PRS_LRS_tertile_5 = " `ll5_`i''
		display as text "UCI for PRS_LRS_tertile_5 = " `ul5_`i''
		display as text "P for PRS_LRS_tertile_5 = " `pval5_`i''
		display as text "SHR for PRS_LRS_tertile_6 = " `shr6_`i''
		display as text "SE for PRS_LRS_tertile_6 = " `se6_`i''
		display as text "LCI for PRS_LRS_tertile_6 = " `ll6_`i''
		display as text "UCI for PRS_LRS_tertile_6 = " `ul6_`i''
		display as text "P for PRS_LRS_tertile_6 = " `pval6_`i''
		display as text "SHR for PRS_LRS_tertile_7 = " `shr7_`i''
		display as text "SE for PRS_LRS_tertile_7 = " `se7_`i''
		display as text "LCI for PRS_LRS_tertile_7 = " `ll7_`i''
		display as text "UCI for PRS_LRS_tertile_7 = " `ul7_`i''
		display as text "P for PRS_LRS_tertile_7 = " `pval7_`i''
		display as text "SHR for PRS_LRS_tertile_8 = " `shr8_`i''
		display as text "SE for PRS_LRS_tertile_8 = " `se8_`i''
		display as text "LCI for PRS_LRS_tertile_8 = " `ll8_`i''
		display as text "UCI for PRS_LRS_tertile_8 = " `ul8_`i''
		display as text "P for PRS_LRS_tertile_8 = " `pval8_`i''
		display as text "SHR for PRS_LRS_tertile_9 = " `shr9_`i''
		display as text "SE for PRS_LRS_tertile_9 = " `se9_`i''
		display as text "LCI for PRS_LRS_tertile_9 = " `ll9_`i''
		display as text "UCI for PRS_LRS_tertile_9 = " `ul9_`i''
		display as text "P for PRS_LRS_tertile_9 = " `pval9_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_LRS_allcause_tertiles.csv", replace text name(table)

noisily di "SHR2",%3.2f `shr2_1', %3.2f `shr2_2',  %3.2f `shr2_3',  %3.2f `shr2_4',  %3.2f `shr2_5',  %3.2f `shr2_6',  %3.2f `shr2_7',  %3.2f `shr2_8',  %3.2f `shr2_9',  %3.2f `shr2_10'
noisily di "SE2",%3.2f `se2_1', %3.2f `se2_2',  %3.2f `se2_3',  %3.2f `se2_4',  %3.2f `se2_5',  %3.2f `se2_6',  %3.2f `se2_7',  %3.2f `se2_8',  %3.2f `se2_9',  %3.2f `se2_10'
noisily di "LL2",%3.2f `ll2_1', %3.2f `ll2_2',  %3.2f `ll2_3',  %3.2f `ll2_4',  %3.2f `ll2_5',  %3.2f `ll2_6',  %3.2f `ll2_7',  %3.2f `ll2_8',  %3.2f `ll2_9',  %3.2f `ll2_10'
noisily di "UL2",%3.2f `ul2_1', %3.2f `ul2_2',  %3.2f `ul2_3',  %3.2f `ul2_4',  %3.2f `ul2_5',  %3.2f `ul2_6',  %3.2f `ul2_7',  %3.2f `ul2_8',  %3.2f `ul2_9',  %3.2f `ul2_10'
noisily di "P2",%4.3f `pval2_1', %4.3f `pval2_2',  %4.3f `pval2_3',  %4.3f `pval2_4',  %4.3f `pval2_5',  %4.3f `pval2_6',  %4.3f `pval2_7',  %4.3f `pval2_8',  %4.3f `pval2_9',  %4.3f `pval2_10'

noisily di "SHR3",%3.2f `shr3_1', %3.2f `shr3_2',  %3.2f `shr3_3',  %3.2f `shr3_4',  %3.2f `shr3_5',  %3.2f `shr3_6',  %3.2f `shr3_7',  %3.2f `shr3_8',  %3.2f `shr3_9',  %3.2f `shr3_10'
noisily di "SE3",%3.2f `se3_1', %3.2f `se3_2',  %3.2f `se3_3',  %3.2f `se3_4',  %3.2f `se3_5',  %3.2f `se3_6',  %3.2f `se3_7',  %3.2f `se3_8',  %3.2f `se3_9',  %3.2f `se3_10'
noisily di "LL3",%3.2f `ll3_1', %3.2f `ll3_2',  %3.2f `ll3_3',  %3.2f `ll3_4',  %3.2f `ll3_5',  %3.2f `ll3_6',  %3.2f `ll3_7',  %3.2f `ll3_8',  %3.2f `ll3_9',  %3.2f `ll3_10'
noisily di "UL3",%3.2f `ul3_1', %3.2f `ul3_2',  %3.2f `ul3_3',  %3.2f `ul3_4',  %3.2f `ul3_5',  %3.2f `ul3_6',  %3.2f `ul3_7',  %3.2f `ul3_8',  %3.2f `ul3_9',  %3.2f `ul3_10'
noisily di "P3",%4.3f `pval3_1', %4.3f `pval3_2',  %4.3f `pval3_3',  %4.3f `pval3_4',  %4.3f `pval3_5',  %4.3f `pval3_6',  %4.3f `pval3_7',  %4.3f `pval3_8',  %4.3f `pval3_9',  %4.3f `pval3_10'

noisily di "SHR4",%3.2f `shr4_1', %3.2f `shr4_2',  %3.2f `shr4_3',  %3.2f `shr4_4',  %3.2f `shr4_5',  %3.2f `shr4_6',  %3.2f `shr4_7',  %3.2f `shr4_8',  %3.2f `shr4_9',  %3.2f `shr4_10'
noisily di "SE4",%3.2f `se4_1', %3.2f `se4_2',  %3.2f `se4_3',  %3.2f `se4_4',  %3.2f `se4_5',  %3.2f `se4_6',  %3.2f `se4_7',  %3.2f `se4_8',  %3.2f `se4_9',  %3.2f `se4_10'
noisily di "LL4",%3.2f `ll4_1', %3.2f `ll4_2',  %3.2f `ll4_3',  %3.2f `ll4_4',  %3.2f `ll4_5',  %3.2f `ll4_6',  %3.2f `ll4_7',  %3.2f `ll4_8',  %3.2f `ll4_9',  %3.2f `ll4_10'
noisily di "UL4",%3.2f `ul4_1', %3.2f `ul4_2',  %3.2f `ul4_3',  %3.2f `ul4_4',  %3.2f `ul4_5',  %3.2f `ul4_6',  %3.2f `ul4_7',  %3.2f `ul4_8',  %3.2f `ul4_9',  %3.2f `ul4_10'
noisily di "P4",%4.3f `pval4_1', %4.3f `pval4_2',  %4.3f `pval4_3',  %4.3f `pval4_4',  %4.3f `pval4_5',  %4.3f `pval4_6',  %4.3f `pval4_7',  %4.3f `pval4_8',  %4.3f `pval4_9',  %4.3f `pval4_10'

noisily di "SHR5",%3.2f `shr5_1', %3.2f `shr5_2',  %3.2f `shr5_3',  %3.2f `shr5_4',  %3.2f `shr5_5',  %3.2f `shr5_6',  %3.2f `shr5_7',  %3.2f `shr5_8',  %3.2f `shr5_9',  %3.2f `shr5_10'
noisily di "SE5",%3.2f `se5_1', %3.2f `se5_2',  %3.2f `se5_3',  %3.2f `se5_4',  %3.2f `se5_5',  %3.2f `se5_6',  %3.2f `se5_7',  %3.2f `se5_8',  %3.2f `se5_9',  %3.2f `se5_10'
noisily di "LL5",%3.2f `ll5_1', %3.2f `ll5_2',  %3.2f `ll5_3',  %3.2f `ll5_4',  %3.2f `ll5_5',  %3.2f `ll5_6',  %3.2f `ll5_7',  %3.2f `ll5_8',  %3.2f `ll5_9',  %3.2f `ll5_10'
noisily di "UL5",%3.2f `ul5_1', %3.2f `ul5_2',  %3.2f `ul5_3',  %3.2f `ul5_4',  %3.2f `ul5_5',  %3.2f `ul5_6',  %3.2f `ul5_7',  %3.2f `ul5_8',  %3.2f `ul5_9',  %3.2f `ul5_10'
noisily di "P5",%4.3f `pval5_1', %4.3f `pval5_2',  %4.3f `pval5_3',  %4.3f `pval5_4',  %4.3f `pval5_5',  %4.3f `pval5_6',  %4.3f `pval5_7',  %4.3f `pval5_8',  %4.3f `pval5_9',  %4.3f `pval5_10'

noisily di "SHR6",%3.2f `shr6_1', %3.2f `shr6_2',  %3.2f `shr6_3',  %3.2f `shr6_4',  %3.2f `shr6_5',  %3.2f `shr6_6',  %3.2f `shr6_7',  %3.2f `shr6_8',  %3.2f `shr6_9',  %3.2f `shr6_10'
noisily di "SE6",%3.2f `se6_1', %3.2f `se6_2',  %3.2f `se6_3',  %3.2f `se6_4',  %3.2f `se6_5',  %3.2f `se6_6',  %3.2f `se6_7',  %3.2f `se6_8',  %3.2f `se6_9',  %3.2f `se6_10'
noisily di "LL6",%3.2f `ll6_1', %3.2f `ll6_2',  %3.2f `ll6_3',  %3.2f `ll6_4',  %3.2f `ll6_5',  %3.2f `ll6_6',  %3.2f `ll6_7',  %3.2f `ll6_8',  %3.2f `ll6_9',  %3.2f `ll6_10'
noisily di "UL6",%3.2f `ul6_1', %3.2f `ul6_2',  %3.2f `ul6_3',  %3.2f `ul6_4',  %3.2f `ul6_5',  %3.2f `ul6_6',  %3.2f `ul6_7',  %3.2f `ul6_8',  %3.2f `ul6_9',  %3.2f `ul6_10'
noisily di "P6",%4.3f `pval6_1', %4.3f `pval6_2',  %4.3f `pval6_3',  %4.3f `pval6_4',  %4.3f `pval6_5',  %4.3f `pval6_6',  %4.3f `pval6_7',  %4.3f `pval6_8',  %4.3f `pval6_9',  %4.3f `pval6_10'

noisily di "SHR7",%3.2f `shr7_1', %3.2f `shr7_2',  %3.2f `shr7_3',  %3.2f `shr7_4',  %3.2f `shr7_5',  %3.2f `shr7_6',  %3.2f `shr7_7',  %3.2f `shr7_8',  %3.2f `shr7_9',  %3.2f `shr7_10'
noisily di "SE7",%3.2f `se7_1', %3.2f `se7_2',  %3.2f `se7_3',  %3.2f `se7_4',  %3.2f `se7_5',  %3.2f `se7_6',  %3.2f `se7_7',  %3.2f `se7_8',  %3.2f `se7_9',  %3.2f `se7_10'
noisily di "LL7",%3.2f `ll7_1', %3.2f `ll7_2',  %3.2f `ll7_3',  %3.2f `ll7_4',  %3.2f `ll7_5',  %3.2f `ll7_6',  %3.2f `ll7_7',  %3.2f `ll7_8',  %3.2f `ll7_9',  %3.2f `ll7_10'
noisily di "UL7",%3.2f `ul7_1', %3.2f `ul7_2',  %3.2f `ul7_3',  %3.2f `ul7_4',  %3.2f `ul7_5',  %3.2f `ul7_6',  %3.2f `ul7_7',  %3.2f `ul7_8',  %3.2f `ul7_9',  %3.2f `ul7_10'
noisily di "P7",%4.3f `pval7_1', %4.3f `pval7_2',  %4.3f `pval7_3',  %4.3f `pval7_4',  %4.3f `pval7_5',  %4.3f `pval7_6',  %4.3f `pval7_7',  %4.3f `pval7_8',  %4.3f `pval7_9',  %4.3f `pval7_10'

noisily di "SHR8",%3.2f `shr8_1', %3.2f `shr8_2',  %3.2f `shr8_3',  %3.2f `shr8_4',  %3.2f `shr8_5',  %3.2f `shr8_6',  %3.2f `shr8_7',  %3.2f `shr8_8',  %3.2f `shr8_9',  %3.2f `shr8_10'
noisily di "SE8",%3.2f `se8_1', %3.2f `se8_2',  %3.2f `se8_3',  %3.2f `se8_4',  %3.2f `se8_5',  %3.2f `se8_6',  %3.2f `se8_7',  %3.2f `se8_8',  %3.2f `se8_9',  %3.2f `se8_10'
noisily di "LL8",%3.2f `ll8_1', %3.2f `ll8_2',  %3.2f `ll8_3',  %3.2f `ll8_4',  %3.2f `ll8_5',  %3.2f `ll8_6',  %3.2f `ll8_7',  %3.2f `ll8_8',  %3.2f `ll8_9',  %3.2f `ll8_10'
noisily di "UL8",%3.2f `ul8_1', %3.2f `ul8_2',  %3.2f `ul8_3',  %3.2f `ul8_4',  %3.2f `ul8_5',  %3.2f `ul8_6',  %3.2f `ul8_7',  %3.2f `ul8_8',  %3.2f `ul8_9',  %3.2f `ul8_10'
noisily di "P8",%4.3f `pval8_1', %4.3f `pval8_2',  %4.3f `pval8_3',  %4.3f `pval8_4',  %4.3f `pval8_5',  %4.3f `pval8_6',  %4.3f `pval8_7',  %4.3f `pval8_8',  %4.3f `pval8_9',  %4.3f `pval8_10'

noisily di "SHR9",%3.2f `shr9_1', %3.2f `shr9_2',  %3.2f `shr9_3',  %3.2f `shr9_4',  %3.2f `shr9_5',  %3.2f `shr9_6',  %3.2f `shr9_7',  %3.2f `shr9_8',  %3.2f `shr9_9',  %3.2f `shr9_10'
noisily di "SE9",%3.2f `se9_1', %3.2f `se9_2',  %3.2f `se9_3',  %3.2f `se9_4',  %3.2f `se9_5',  %3.2f `se9_6',  %3.2f `se9_7',  %3.2f `se9_8',  %3.2f `se9_9',  %3.2f `se9_10'
noisily di "LL9",%3.2f `ll9_1', %3.2f `ll9_2',  %3.2f `ll9_3',  %3.2f `ll9_4',  %3.2f `ll9_5',  %3.2f `ll9_6',  %3.2f `ll9_7',  %3.2f `ll9_8',  %3.2f `ll9_9',  %3.2f `ll9_10'
noisily di "UL9",%3.2f `ul9_1', %3.2f `ul9_2',  %3.2f `ul9_3',  %3.2f `ul9_4',  %3.2f `ul9_5',  %3.2f `ul9_6',  %3.2f `ul9_7',  %3.2f `ul9_8',  %3.2f `ul9_9',  %3.2f `ul9_10'
noisily di "P9",%4.3f `pval9_1', %4.3f `pval9_2',  %4.3f `pval9_3',  %4.3f `pval9_4',  %4.3f `pval9_5',  %4.3f `pval9_6',  %4.3f `pval9_7',  %4.3f `pval9_8',  %4.3f `pval9_9',  %4.3f `pval9_10'

log close table
						}

import delimited "PRS_LRS_allcause_tertiles.csv", delimiter(space) clear 
egen PRS_LRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_LRS_allcause_tertiles_results, replace
		restore
				}
	
	timer off 1
	

///////////////////////////ALZHEIMER'S DISEASE//////////////////////////////	
	
timer on 2

	local sum_SHR_PRS_LRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset alzheimer_date, failure(alzheimer_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(alzheimer_new) ///
		keep(PRS_LRS_tertile_imputed age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
		gen alzheimer_event = failcode == alzheimer_new
		stset tstop [pw=weight_c], failure(alzheimer_event==1) enter(tstart)
		stcox i.PRS_LRS_tertile_imputed age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local shr4_`i' = mat`i'[1,4]
		local shr5_`i' = mat`i'[1,5]
		local shr6_`i' = mat`i'[1,6]
		local shr7_`i' = mat`i'[1,7]
		local shr8_`i' = mat`i'[1,8]
		local shr9_`i' = mat`i'[1,9]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local se4_`i' = mat`i'[2,4]
		local se5_`i' = mat`i'[2,5]
		local se6_`i' = mat`i'[2,6]
		local se7_`i' = mat`i'[2,7]
		local se8_`i' = mat`i'[2,8]
		local se9_`i' = mat`i'[2,9]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ll4_`i' = mat`i'[5,4]
		local ll5_`i' = mat`i'[5,5]
		local ll6_`i' = mat`i'[5,6]
		local ll7_`i' = mat`i'[5,7]
		local ll8_`i' = mat`i'[5,8]
		local ll9_`i' = mat`i'[5,9]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local ul4_`i' = mat`i'[6,4]
		local ul5_`i' = mat`i'[6,5]
		local ul6_`i' = mat`i'[6,6]
		local ul7_`i' = mat`i'[6,7]
		local ul8_`i' = mat`i'[6,8]
		local ul9_`i' = mat`i'[6,9]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		local pval4_`i' = mat`i'[4,4]
		local pval5_`i' = mat`i'[4,5]
		local pval6_`i' = mat`i'[4,6]
		local pval7_`i' = mat`i'[4,7]
		local pval8_`i' = mat`i'[4,8]
		local pval9_`i' = mat`i'[4,9]
		display as text "SHR for PRS_LRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_LRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_LRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_LRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_LRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_LRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_LRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_LRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_LRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_LRS_tertile_3 = " `pval3_`i''
		display as text "SHR for PRS_LRS_tertile_4 = " `shr4_`i''
		display as text "SE for PRS_LRS_tertile_4 = " `se4_`i''
		display as text "LCI for PRS_LRS_tertile_4 = " `ll4_`i''
		display as text "UCI for PRS_LRS_tertile_4 = " `ul4_`i''
		display as text "P for PRS_LRS_tertile_4 = " `pval4_`i''
		display as text "SHR for PRS_LRS_tertile_5 = " `shr5_`i''
		display as text "SE for PRS_LRS_tertile_5 = " `se5_`i''
		display as text "LCI for PRS_LRS_tertile_5 = " `ll5_`i''
		display as text "UCI for PRS_LRS_tertile_5 = " `ul5_`i''
		display as text "P for PRS_LRS_tertile_5 = " `pval5_`i''
		display as text "SHR for PRS_LRS_tertile_6 = " `shr6_`i''
		display as text "SE for PRS_LRS_tertile_6 = " `se6_`i''
		display as text "LCI for PRS_LRS_tertile_6 = " `ll6_`i''
		display as text "UCI for PRS_LRS_tertile_6 = " `ul6_`i''
		display as text "P for PRS_LRS_tertile_6 = " `pval6_`i''
		display as text "SHR for PRS_LRS_tertile_7 = " `shr7_`i''
		display as text "SE for PRS_LRS_tertile_7 = " `se7_`i''
		display as text "LCI for PRS_LRS_tertile_7 = " `ll7_`i''
		display as text "UCI for PRS_LRS_tertile_7 = " `ul7_`i''
		display as text "P for PRS_LRS_tertile_7 = " `pval7_`i''
		display as text "SHR for PRS_LRS_tertile_8 = " `shr8_`i''
		display as text "SE for PRS_LRS_tertile_8 = " `se8_`i''
		display as text "LCI for PRS_LRS_tertile_8 = " `ll8_`i''
		display as text "UCI for PRS_LRS_tertile_8 = " `ul8_`i''
		display as text "P for PRS_LRS_tertile_8 = " `pval8_`i''
		display as text "SHR for PRS_LRS_tertile_9 = " `shr9_`i''
		display as text "SE for PRS_LRS_tertile_9 = " `se9_`i''
		display as text "LCI for PRS_LRS_tertile_9 = " `ll9_`i''
		display as text "UCI for PRS_LRS_tertile_9 = " `ul9_`i''
		display as text "P for PRS_LRS_tertile_9 = " `pval9_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_LRS_alzheimer_tertiles.csv", replace text name(table)

noisily di "SHR2",%3.2f `shr2_1', %3.2f `shr2_2',  %3.2f `shr2_3',  %3.2f `shr2_4',  %3.2f `shr2_5',  %3.2f `shr2_6',  %3.2f `shr2_7',  %3.2f `shr2_8',  %3.2f `shr2_9',  %3.2f `shr2_10'
noisily di "SE2",%3.2f `se2_1', %3.2f `se2_2',  %3.2f `se2_3',  %3.2f `se2_4',  %3.2f `se2_5',  %3.2f `se2_6',  %3.2f `se2_7',  %3.2f `se2_8',  %3.2f `se2_9',  %3.2f `se2_10'
noisily di "LL2",%3.2f `ll2_1', %3.2f `ll2_2',  %3.2f `ll2_3',  %3.2f `ll2_4',  %3.2f `ll2_5',  %3.2f `ll2_6',  %3.2f `ll2_7',  %3.2f `ll2_8',  %3.2f `ll2_9',  %3.2f `ll2_10'
noisily di "UL2",%3.2f `ul2_1', %3.2f `ul2_2',  %3.2f `ul2_3',  %3.2f `ul2_4',  %3.2f `ul2_5',  %3.2f `ul2_6',  %3.2f `ul2_7',  %3.2f `ul2_8',  %3.2f `ul2_9',  %3.2f `ul2_10'
noisily di "P2",%4.3f `pval2_1', %4.3f `pval2_2',  %4.3f `pval2_3',  %4.3f `pval2_4',  %4.3f `pval2_5',  %4.3f `pval2_6',  %4.3f `pval2_7',  %4.3f `pval2_8',  %4.3f `pval2_9',  %4.3f `pval2_10'

noisily di "SHR3",%3.2f `shr3_1', %3.2f `shr3_2',  %3.2f `shr3_3',  %3.2f `shr3_4',  %3.2f `shr3_5',  %3.2f `shr3_6',  %3.2f `shr3_7',  %3.2f `shr3_8',  %3.2f `shr3_9',  %3.2f `shr3_10'
noisily di "SE3",%3.2f `se3_1', %3.2f `se3_2',  %3.2f `se3_3',  %3.2f `se3_4',  %3.2f `se3_5',  %3.2f `se3_6',  %3.2f `se3_7',  %3.2f `se3_8',  %3.2f `se3_9',  %3.2f `se3_10'
noisily di "LL3",%3.2f `ll3_1', %3.2f `ll3_2',  %3.2f `ll3_3',  %3.2f `ll3_4',  %3.2f `ll3_5',  %3.2f `ll3_6',  %3.2f `ll3_7',  %3.2f `ll3_8',  %3.2f `ll3_9',  %3.2f `ll3_10'
noisily di "UL3",%3.2f `ul3_1', %3.2f `ul3_2',  %3.2f `ul3_3',  %3.2f `ul3_4',  %3.2f `ul3_5',  %3.2f `ul3_6',  %3.2f `ul3_7',  %3.2f `ul3_8',  %3.2f `ul3_9',  %3.2f `ul3_10'
noisily di "P3",%4.3f `pval3_1', %4.3f `pval3_2',  %4.3f `pval3_3',  %4.3f `pval3_4',  %4.3f `pval3_5',  %4.3f `pval3_6',  %4.3f `pval3_7',  %4.3f `pval3_8',  %4.3f `pval3_9',  %4.3f `pval3_10'

noisily di "SHR4",%3.2f `shr4_1', %3.2f `shr4_2',  %3.2f `shr4_3',  %3.2f `shr4_4',  %3.2f `shr4_5',  %3.2f `shr4_6',  %3.2f `shr4_7',  %3.2f `shr4_8',  %3.2f `shr4_9',  %3.2f `shr4_10'
noisily di "SE4",%3.2f `se4_1', %3.2f `se4_2',  %3.2f `se4_3',  %3.2f `se4_4',  %3.2f `se4_5',  %3.2f `se4_6',  %3.2f `se4_7',  %3.2f `se4_8',  %3.2f `se4_9',  %3.2f `se4_10'
noisily di "LL4",%3.2f `ll4_1', %3.2f `ll4_2',  %3.2f `ll4_3',  %3.2f `ll4_4',  %3.2f `ll4_5',  %3.2f `ll4_6',  %3.2f `ll4_7',  %3.2f `ll4_8',  %3.2f `ll4_9',  %3.2f `ll4_10'
noisily di "UL4",%3.2f `ul4_1', %3.2f `ul4_2',  %3.2f `ul4_3',  %3.2f `ul4_4',  %3.2f `ul4_5',  %3.2f `ul4_6',  %3.2f `ul4_7',  %3.2f `ul4_8',  %3.2f `ul4_9',  %3.2f `ul4_10'
noisily di "P4",%4.3f `pval4_1', %4.3f `pval4_2',  %4.3f `pval4_3',  %4.3f `pval4_4',  %4.3f `pval4_5',  %4.3f `pval4_6',  %4.3f `pval4_7',  %4.3f `pval4_8',  %4.3f `pval4_9',  %4.3f `pval4_10'

noisily di "SHR5",%3.2f `shr5_1', %3.2f `shr5_2',  %3.2f `shr5_3',  %3.2f `shr5_4',  %3.2f `shr5_5',  %3.2f `shr5_6',  %3.2f `shr5_7',  %3.2f `shr5_8',  %3.2f `shr5_9',  %3.2f `shr5_10'
noisily di "SE5",%3.2f `se5_1', %3.2f `se5_2',  %3.2f `se5_3',  %3.2f `se5_4',  %3.2f `se5_5',  %3.2f `se5_6',  %3.2f `se5_7',  %3.2f `se5_8',  %3.2f `se5_9',  %3.2f `se5_10'
noisily di "LL5",%3.2f `ll5_1', %3.2f `ll5_2',  %3.2f `ll5_3',  %3.2f `ll5_4',  %3.2f `ll5_5',  %3.2f `ll5_6',  %3.2f `ll5_7',  %3.2f `ll5_8',  %3.2f `ll5_9',  %3.2f `ll5_10'
noisily di "UL5",%3.2f `ul5_1', %3.2f `ul5_2',  %3.2f `ul5_3',  %3.2f `ul5_4',  %3.2f `ul5_5',  %3.2f `ul5_6',  %3.2f `ul5_7',  %3.2f `ul5_8',  %3.2f `ul5_9',  %3.2f `ul5_10'
noisily di "P5",%4.3f `pval5_1', %4.3f `pval5_2',  %4.3f `pval5_3',  %4.3f `pval5_4',  %4.3f `pval5_5',  %4.3f `pval5_6',  %4.3f `pval5_7',  %4.3f `pval5_8',  %4.3f `pval5_9',  %4.3f `pval5_10'

noisily di "SHR6",%3.2f `shr6_1', %3.2f `shr6_2',  %3.2f `shr6_3',  %3.2f `shr6_4',  %3.2f `shr6_5',  %3.2f `shr6_6',  %3.2f `shr6_7',  %3.2f `shr6_8',  %3.2f `shr6_9',  %3.2f `shr6_10'
noisily di "SE6",%3.2f `se6_1', %3.2f `se6_2',  %3.2f `se6_3',  %3.2f `se6_4',  %3.2f `se6_5',  %3.2f `se6_6',  %3.2f `se6_7',  %3.2f `se6_8',  %3.2f `se6_9',  %3.2f `se6_10'
noisily di "LL6",%3.2f `ll6_1', %3.2f `ll6_2',  %3.2f `ll6_3',  %3.2f `ll6_4',  %3.2f `ll6_5',  %3.2f `ll6_6',  %3.2f `ll6_7',  %3.2f `ll6_8',  %3.2f `ll6_9',  %3.2f `ll6_10'
noisily di "UL6",%3.2f `ul6_1', %3.2f `ul6_2',  %3.2f `ul6_3',  %3.2f `ul6_4',  %3.2f `ul6_5',  %3.2f `ul6_6',  %3.2f `ul6_7',  %3.2f `ul6_8',  %3.2f `ul6_9',  %3.2f `ul6_10'
noisily di "P6",%4.3f `pval6_1', %4.3f `pval6_2',  %4.3f `pval6_3',  %4.3f `pval6_4',  %4.3f `pval6_5',  %4.3f `pval6_6',  %4.3f `pval6_7',  %4.3f `pval6_8',  %4.3f `pval6_9',  %4.3f `pval6_10'

noisily di "SHR7",%3.2f `shr7_1', %3.2f `shr7_2',  %3.2f `shr7_3',  %3.2f `shr7_4',  %3.2f `shr7_5',  %3.2f `shr7_6',  %3.2f `shr7_7',  %3.2f `shr7_8',  %3.2f `shr7_9',  %3.2f `shr7_10'
noisily di "SE7",%3.2f `se7_1', %3.2f `se7_2',  %3.2f `se7_3',  %3.2f `se7_4',  %3.2f `se7_5',  %3.2f `se7_6',  %3.2f `se7_7',  %3.2f `se7_8',  %3.2f `se7_9',  %3.2f `se7_10'
noisily di "LL7",%3.2f `ll7_1', %3.2f `ll7_2',  %3.2f `ll7_3',  %3.2f `ll7_4',  %3.2f `ll7_5',  %3.2f `ll7_6',  %3.2f `ll7_7',  %3.2f `ll7_8',  %3.2f `ll7_9',  %3.2f `ll7_10'
noisily di "UL7",%3.2f `ul7_1', %3.2f `ul7_2',  %3.2f `ul7_3',  %3.2f `ul7_4',  %3.2f `ul7_5',  %3.2f `ul7_6',  %3.2f `ul7_7',  %3.2f `ul7_8',  %3.2f `ul7_9',  %3.2f `ul7_10'
noisily di "P7",%4.3f `pval7_1', %4.3f `pval7_2',  %4.3f `pval7_3',  %4.3f `pval7_4',  %4.3f `pval7_5',  %4.3f `pval7_6',  %4.3f `pval7_7',  %4.3f `pval7_8',  %4.3f `pval7_9',  %4.3f `pval7_10'

noisily di "SHR8",%3.2f `shr8_1', %3.2f `shr8_2',  %3.2f `shr8_3',  %3.2f `shr8_4',  %3.2f `shr8_5',  %3.2f `shr8_6',  %3.2f `shr8_7',  %3.2f `shr8_8',  %3.2f `shr8_9',  %3.2f `shr8_10'
noisily di "SE8",%3.2f `se8_1', %3.2f `se8_2',  %3.2f `se8_3',  %3.2f `se8_4',  %3.2f `se8_5',  %3.2f `se8_6',  %3.2f `se8_7',  %3.2f `se8_8',  %3.2f `se8_9',  %3.2f `se8_10'
noisily di "LL8",%3.2f `ll8_1', %3.2f `ll8_2',  %3.2f `ll8_3',  %3.2f `ll8_4',  %3.2f `ll8_5',  %3.2f `ll8_6',  %3.2f `ll8_7',  %3.2f `ll8_8',  %3.2f `ll8_9',  %3.2f `ll8_10'
noisily di "UL8",%3.2f `ul8_1', %3.2f `ul8_2',  %3.2f `ul8_3',  %3.2f `ul8_4',  %3.2f `ul8_5',  %3.2f `ul8_6',  %3.2f `ul8_7',  %3.2f `ul8_8',  %3.2f `ul8_9',  %3.2f `ul8_10'
noisily di "P8",%4.3f `pval8_1', %4.3f `pval8_2',  %4.3f `pval8_3',  %4.3f `pval8_4',  %4.3f `pval8_5',  %4.3f `pval8_6',  %4.3f `pval8_7',  %4.3f `pval8_8',  %4.3f `pval8_9',  %4.3f `pval8_10'

noisily di "SHR9",%3.2f `shr9_1', %3.2f `shr9_2',  %3.2f `shr9_3',  %3.2f `shr9_4',  %3.2f `shr9_5',  %3.2f `shr9_6',  %3.2f `shr9_7',  %3.2f `shr9_8',  %3.2f `shr9_9',  %3.2f `shr9_10'
noisily di "SE9",%3.2f `se9_1', %3.2f `se9_2',  %3.2f `se9_3',  %3.2f `se9_4',  %3.2f `se9_5',  %3.2f `se9_6',  %3.2f `se9_7',  %3.2f `se9_8',  %3.2f `se9_9',  %3.2f `se9_10'
noisily di "LL9",%3.2f `ll9_1', %3.2f `ll9_2',  %3.2f `ll9_3',  %3.2f `ll9_4',  %3.2f `ll9_5',  %3.2f `ll9_6',  %3.2f `ll9_7',  %3.2f `ll9_8',  %3.2f `ll9_9',  %3.2f `ll9_10'
noisily di "UL9",%3.2f `ul9_1', %3.2f `ul9_2',  %3.2f `ul9_3',  %3.2f `ul9_4',  %3.2f `ul9_5',  %3.2f `ul9_6',  %3.2f `ul9_7',  %3.2f `ul9_8',  %3.2f `ul9_9',  %3.2f `ul9_10'
noisily di "P9",%4.3f `pval9_1', %4.3f `pval9_2',  %4.3f `pval9_3',  %4.3f `pval9_4',  %4.3f `pval9_5',  %4.3f `pval9_6',  %4.3f `pval9_7',  %4.3f `pval9_8',  %4.3f `pval9_9',  %4.3f `pval9_10'

log close table
						}

import delimited "PRS_LRS_alzheimer_tertiles.csv", delimiter(space) clear 
egen PRS_LRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_LRS_alzheimer_tertiles_results, replace
		restore
				}
	
	timer off 2
	
	
//////////////////////////VASCULAR DEMENTIA//////////////////////////////	
	
timer on 3

	local sum_SHR_PRS_LRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset vascular_date, failure(vascular_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(vascular_new) ///
		keep(PRS_LRS_tertile_imputed age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
		gen vascular_event = failcode == vascular_new
		stset tstop [pw=weight_c], failure(vascular_event==1) enter(tstart)
		stcox i.PRS_LRS_tertile_imputed age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local shr4_`i' = mat`i'[1,4]
		local shr5_`i' = mat`i'[1,5]
		local shr6_`i' = mat`i'[1,6]
		local shr7_`i' = mat`i'[1,7]
		local shr8_`i' = mat`i'[1,8]
		local shr9_`i' = mat`i'[1,9]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local se4_`i' = mat`i'[2,4]
		local se5_`i' = mat`i'[2,5]
		local se6_`i' = mat`i'[2,6]
		local se7_`i' = mat`i'[2,7]
		local se8_`i' = mat`i'[2,8]
		local se9_`i' = mat`i'[2,9]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ll4_`i' = mat`i'[5,4]
		local ll5_`i' = mat`i'[5,5]
		local ll6_`i' = mat`i'[5,6]
		local ll7_`i' = mat`i'[5,7]
		local ll8_`i' = mat`i'[5,8]
		local ll9_`i' = mat`i'[5,9]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local ul4_`i' = mat`i'[6,4]
		local ul5_`i' = mat`i'[6,5]
		local ul6_`i' = mat`i'[6,6]
		local ul7_`i' = mat`i'[6,7]
		local ul8_`i' = mat`i'[6,8]
		local ul9_`i' = mat`i'[6,9]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		local pval4_`i' = mat`i'[4,4]
		local pval5_`i' = mat`i'[4,5]
		local pval6_`i' = mat`i'[4,6]
		local pval7_`i' = mat`i'[4,7]
		local pval8_`i' = mat`i'[4,8]
		local pval9_`i' = mat`i'[4,9]
		display as text "SHR for PRS_LRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_LRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_LRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_LRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_LRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_LRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_LRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_LRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_LRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_LRS_tertile_3 = " `pval3_`i''
		display as text "SHR for PRS_LRS_tertile_4 = " `shr4_`i''
		display as text "SE for PRS_LRS_tertile_4 = " `se4_`i''
		display as text "LCI for PRS_LRS_tertile_4 = " `ll4_`i''
		display as text "UCI for PRS_LRS_tertile_4 = " `ul4_`i''
		display as text "P for PRS_LRS_tertile_4 = " `pval4_`i''
		display as text "SHR for PRS_LRS_tertile_5 = " `shr5_`i''
		display as text "SE for PRS_LRS_tertile_5 = " `se5_`i''
		display as text "LCI for PRS_LRS_tertile_5 = " `ll5_`i''
		display as text "UCI for PRS_LRS_tertile_5 = " `ul5_`i''
		display as text "P for PRS_LRS_tertile_5 = " `pval5_`i''
		display as text "SHR for PRS_LRS_tertile_6 = " `shr6_`i''
		display as text "SE for PRS_LRS_tertile_6 = " `se6_`i''
		display as text "LCI for PRS_LRS_tertile_6 = " `ll6_`i''
		display as text "UCI for PRS_LRS_tertile_6 = " `ul6_`i''
		display as text "P for PRS_LRS_tertile_6 = " `pval6_`i''
		display as text "SHR for PRS_LRS_tertile_7 = " `shr7_`i''
		display as text "SE for PRS_LRS_tertile_7 = " `se7_`i''
		display as text "LCI for PRS_LRS_tertile_7 = " `ll7_`i''
		display as text "UCI for PRS_LRS_tertile_7 = " `ul7_`i''
		display as text "P for PRS_LRS_tertile_7 = " `pval7_`i''
		display as text "SHR for PRS_LRS_tertile_8 = " `shr8_`i''
		display as text "SE for PRS_LRS_tertile_8 = " `se8_`i''
		display as text "LCI for PRS_LRS_tertile_8 = " `ll8_`i''
		display as text "UCI for PRS_LRS_tertile_8 = " `ul8_`i''
		display as text "P for PRS_LRS_tertile_8 = " `pval8_`i''
		display as text "SHR for PRS_LRS_tertile_9 = " `shr9_`i''
		display as text "SE for PRS_LRS_tertile_9 = " `se9_`i''
		display as text "LCI for PRS_LRS_tertile_9 = " `ll9_`i''
		display as text "UCI for PRS_LRS_tertile_9 = " `ul9_`i''
		display as text "P for PRS_LRS_tertile_9 = " `pval9_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_LRS_vascular_tertiles.csv", replace text name(table)

noisily di "SHR2",%3.2f `shr2_1', %3.2f `shr2_2',  %3.2f `shr2_3',  %3.2f `shr2_4',  %3.2f `shr2_5',  %3.2f `shr2_6',  %3.2f `shr2_7',  %3.2f `shr2_8',  %3.2f `shr2_9',  %3.2f `shr2_10'
noisily di "SE2",%3.2f `se2_1', %3.2f `se2_2',  %3.2f `se2_3',  %3.2f `se2_4',  %3.2f `se2_5',  %3.2f `se2_6',  %3.2f `se2_7',  %3.2f `se2_8',  %3.2f `se2_9',  %3.2f `se2_10'
noisily di "LL2",%3.2f `ll2_1', %3.2f `ll2_2',  %3.2f `ll2_3',  %3.2f `ll2_4',  %3.2f `ll2_5',  %3.2f `ll2_6',  %3.2f `ll2_7',  %3.2f `ll2_8',  %3.2f `ll2_9',  %3.2f `ll2_10'
noisily di "UL2",%3.2f `ul2_1', %3.2f `ul2_2',  %3.2f `ul2_3',  %3.2f `ul2_4',  %3.2f `ul2_5',  %3.2f `ul2_6',  %3.2f `ul2_7',  %3.2f `ul2_8',  %3.2f `ul2_9',  %3.2f `ul2_10'
noisily di "P2",%4.3f `pval2_1', %4.3f `pval2_2',  %4.3f `pval2_3',  %4.3f `pval2_4',  %4.3f `pval2_5',  %4.3f `pval2_6',  %4.3f `pval2_7',  %4.3f `pval2_8',  %4.3f `pval2_9',  %4.3f `pval2_10'

noisily di "SHR3",%3.2f `shr3_1', %3.2f `shr3_2',  %3.2f `shr3_3',  %3.2f `shr3_4',  %3.2f `shr3_5',  %3.2f `shr3_6',  %3.2f `shr3_7',  %3.2f `shr3_8',  %3.2f `shr3_9',  %3.2f `shr3_10'
noisily di "SE3",%3.2f `se3_1', %3.2f `se3_2',  %3.2f `se3_3',  %3.2f `se3_4',  %3.2f `se3_5',  %3.2f `se3_6',  %3.2f `se3_7',  %3.2f `se3_8',  %3.2f `se3_9',  %3.2f `se3_10'
noisily di "LL3",%3.2f `ll3_1', %3.2f `ll3_2',  %3.2f `ll3_3',  %3.2f `ll3_4',  %3.2f `ll3_5',  %3.2f `ll3_6',  %3.2f `ll3_7',  %3.2f `ll3_8',  %3.2f `ll3_9',  %3.2f `ll3_10'
noisily di "UL3",%3.2f `ul3_1', %3.2f `ul3_2',  %3.2f `ul3_3',  %3.2f `ul3_4',  %3.2f `ul3_5',  %3.2f `ul3_6',  %3.2f `ul3_7',  %3.2f `ul3_8',  %3.2f `ul3_9',  %3.2f `ul3_10'
noisily di "P3",%4.3f `pval3_1', %4.3f `pval3_2',  %4.3f `pval3_3',  %4.3f `pval3_4',  %4.3f `pval3_5',  %4.3f `pval3_6',  %4.3f `pval3_7',  %4.3f `pval3_8',  %4.3f `pval3_9',  %4.3f `pval3_10'

noisily di "SHR4",%3.2f `shr4_1', %3.2f `shr4_2',  %3.2f `shr4_3',  %3.2f `shr4_4',  %3.2f `shr4_5',  %3.2f `shr4_6',  %3.2f `shr4_7',  %3.2f `shr4_8',  %3.2f `shr4_9',  %3.2f `shr4_10'
noisily di "SE4",%3.2f `se4_1', %3.2f `se4_2',  %3.2f `se4_3',  %3.2f `se4_4',  %3.2f `se4_5',  %3.2f `se4_6',  %3.2f `se4_7',  %3.2f `se4_8',  %3.2f `se4_9',  %3.2f `se4_10'
noisily di "LL4",%3.2f `ll4_1', %3.2f `ll4_2',  %3.2f `ll4_3',  %3.2f `ll4_4',  %3.2f `ll4_5',  %3.2f `ll4_6',  %3.2f `ll4_7',  %3.2f `ll4_8',  %3.2f `ll4_9',  %3.2f `ll4_10'
noisily di "UL4",%3.2f `ul4_1', %3.2f `ul4_2',  %3.2f `ul4_3',  %3.2f `ul4_4',  %3.2f `ul4_5',  %3.2f `ul4_6',  %3.2f `ul4_7',  %3.2f `ul4_8',  %3.2f `ul4_9',  %3.2f `ul4_10'
noisily di "P4",%4.3f `pval4_1', %4.3f `pval4_2',  %4.3f `pval4_3',  %4.3f `pval4_4',  %4.3f `pval4_5',  %4.3f `pval4_6',  %4.3f `pval4_7',  %4.3f `pval4_8',  %4.3f `pval4_9',  %4.3f `pval4_10'

noisily di "SHR5",%3.2f `shr5_1', %3.2f `shr5_2',  %3.2f `shr5_3',  %3.2f `shr5_4',  %3.2f `shr5_5',  %3.2f `shr5_6',  %3.2f `shr5_7',  %3.2f `shr5_8',  %3.2f `shr5_9',  %3.2f `shr5_10'
noisily di "SE5",%3.2f `se5_1', %3.2f `se5_2',  %3.2f `se5_3',  %3.2f `se5_4',  %3.2f `se5_5',  %3.2f `se5_6',  %3.2f `se5_7',  %3.2f `se5_8',  %3.2f `se5_9',  %3.2f `se5_10'
noisily di "LL5",%3.2f `ll5_1', %3.2f `ll5_2',  %3.2f `ll5_3',  %3.2f `ll5_4',  %3.2f `ll5_5',  %3.2f `ll5_6',  %3.2f `ll5_7',  %3.2f `ll5_8',  %3.2f `ll5_9',  %3.2f `ll5_10'
noisily di "UL5",%3.2f `ul5_1', %3.2f `ul5_2',  %3.2f `ul5_3',  %3.2f `ul5_4',  %3.2f `ul5_5',  %3.2f `ul5_6',  %3.2f `ul5_7',  %3.2f `ul5_8',  %3.2f `ul5_9',  %3.2f `ul5_10'
noisily di "P5",%4.3f `pval5_1', %4.3f `pval5_2',  %4.3f `pval5_3',  %4.3f `pval5_4',  %4.3f `pval5_5',  %4.3f `pval5_6',  %4.3f `pval5_7',  %4.3f `pval5_8',  %4.3f `pval5_9',  %4.3f `pval5_10'

noisily di "SHR6",%3.2f `shr6_1', %3.2f `shr6_2',  %3.2f `shr6_3',  %3.2f `shr6_4',  %3.2f `shr6_5',  %3.2f `shr6_6',  %3.2f `shr6_7',  %3.2f `shr6_8',  %3.2f `shr6_9',  %3.2f `shr6_10'
noisily di "SE6",%3.2f `se6_1', %3.2f `se6_2',  %3.2f `se6_3',  %3.2f `se6_4',  %3.2f `se6_5',  %3.2f `se6_6',  %3.2f `se6_7',  %3.2f `se6_8',  %3.2f `se6_9',  %3.2f `se6_10'
noisily di "LL6",%3.2f `ll6_1', %3.2f `ll6_2',  %3.2f `ll6_3',  %3.2f `ll6_4',  %3.2f `ll6_5',  %3.2f `ll6_6',  %3.2f `ll6_7',  %3.2f `ll6_8',  %3.2f `ll6_9',  %3.2f `ll6_10'
noisily di "UL6",%3.2f `ul6_1', %3.2f `ul6_2',  %3.2f `ul6_3',  %3.2f `ul6_4',  %3.2f `ul6_5',  %3.2f `ul6_6',  %3.2f `ul6_7',  %3.2f `ul6_8',  %3.2f `ul6_9',  %3.2f `ul6_10'
noisily di "P6",%4.3f `pval6_1', %4.3f `pval6_2',  %4.3f `pval6_3',  %4.3f `pval6_4',  %4.3f `pval6_5',  %4.3f `pval6_6',  %4.3f `pval6_7',  %4.3f `pval6_8',  %4.3f `pval6_9',  %4.3f `pval6_10'

noisily di "SHR7",%3.2f `shr7_1', %3.2f `shr7_2',  %3.2f `shr7_3',  %3.2f `shr7_4',  %3.2f `shr7_5',  %3.2f `shr7_6',  %3.2f `shr7_7',  %3.2f `shr7_8',  %3.2f `shr7_9',  %3.2f `shr7_10'
noisily di "SE7",%3.2f `se7_1', %3.2f `se7_2',  %3.2f `se7_3',  %3.2f `se7_4',  %3.2f `se7_5',  %3.2f `se7_6',  %3.2f `se7_7',  %3.2f `se7_8',  %3.2f `se7_9',  %3.2f `se7_10'
noisily di "LL7",%3.2f `ll7_1', %3.2f `ll7_2',  %3.2f `ll7_3',  %3.2f `ll7_4',  %3.2f `ll7_5',  %3.2f `ll7_6',  %3.2f `ll7_7',  %3.2f `ll7_8',  %3.2f `ll7_9',  %3.2f `ll7_10'
noisily di "UL7",%3.2f `ul7_1', %3.2f `ul7_2',  %3.2f `ul7_3',  %3.2f `ul7_4',  %3.2f `ul7_5',  %3.2f `ul7_6',  %3.2f `ul7_7',  %3.2f `ul7_8',  %3.2f `ul7_9',  %3.2f `ul7_10'
noisily di "P7",%4.3f `pval7_1', %4.3f `pval7_2',  %4.3f `pval7_3',  %4.3f `pval7_4',  %4.3f `pval7_5',  %4.3f `pval7_6',  %4.3f `pval7_7',  %4.3f `pval7_8',  %4.3f `pval7_9',  %4.3f `pval7_10'

noisily di "SHR8",%3.2f `shr8_1', %3.2f `shr8_2',  %3.2f `shr8_3',  %3.2f `shr8_4',  %3.2f `shr8_5',  %3.2f `shr8_6',  %3.2f `shr8_7',  %3.2f `shr8_8',  %3.2f `shr8_9',  %3.2f `shr8_10'
noisily di "SE8",%3.2f `se8_1', %3.2f `se8_2',  %3.2f `se8_3',  %3.2f `se8_4',  %3.2f `se8_5',  %3.2f `se8_6',  %3.2f `se8_7',  %3.2f `se8_8',  %3.2f `se8_9',  %3.2f `se8_10'
noisily di "LL8",%3.2f `ll8_1', %3.2f `ll8_2',  %3.2f `ll8_3',  %3.2f `ll8_4',  %3.2f `ll8_5',  %3.2f `ll8_6',  %3.2f `ll8_7',  %3.2f `ll8_8',  %3.2f `ll8_9',  %3.2f `ll8_10'
noisily di "UL8",%3.2f `ul8_1', %3.2f `ul8_2',  %3.2f `ul8_3',  %3.2f `ul8_4',  %3.2f `ul8_5',  %3.2f `ul8_6',  %3.2f `ul8_7',  %3.2f `ul8_8',  %3.2f `ul8_9',  %3.2f `ul8_10'
noisily di "P8",%4.3f `pval8_1', %4.3f `pval8_2',  %4.3f `pval8_3',  %4.3f `pval8_4',  %4.3f `pval8_5',  %4.3f `pval8_6',  %4.3f `pval8_7',  %4.3f `pval8_8',  %4.3f `pval8_9',  %4.3f `pval8_10'

noisily di "SHR9",%3.2f `shr9_1', %3.2f `shr9_2',  %3.2f `shr9_3',  %3.2f `shr9_4',  %3.2f `shr9_5',  %3.2f `shr9_6',  %3.2f `shr9_7',  %3.2f `shr9_8',  %3.2f `shr9_9',  %3.2f `shr9_10'
noisily di "SE9",%3.2f `se9_1', %3.2f `se9_2',  %3.2f `se9_3',  %3.2f `se9_4',  %3.2f `se9_5',  %3.2f `se9_6',  %3.2f `se9_7',  %3.2f `se9_8',  %3.2f `se9_9',  %3.2f `se9_10'
noisily di "LL9",%3.2f `ll9_1', %3.2f `ll9_2',  %3.2f `ll9_3',  %3.2f `ll9_4',  %3.2f `ll9_5',  %3.2f `ll9_6',  %3.2f `ll9_7',  %3.2f `ll9_8',  %3.2f `ll9_9',  %3.2f `ll9_10'
noisily di "UL9",%3.2f `ul9_1', %3.2f `ul9_2',  %3.2f `ul9_3',  %3.2f `ul9_4',  %3.2f `ul9_5',  %3.2f `ul9_6',  %3.2f `ul9_7',  %3.2f `ul9_8',  %3.2f `ul9_9',  %3.2f `ul9_10'
noisily di "P9",%4.3f `pval9_1', %4.3f `pval9_2',  %4.3f `pval9_3',  %4.3f `pval9_4',  %4.3f `pval9_5',  %4.3f `pval9_6',  %4.3f `pval9_7',  %4.3f `pval9_8',  %4.3f `pval9_9',  %4.3f `pval9_10'

log close table
						}

import delimited "PRS_LRS_vascular_tertiles.csv", delimiter(space) clear 
egen PRS_LRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_LRS_vascular_tertiles_results, replace
		restore
				}
	
	timer off 3
	timer list
	timer clear	
	


