***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
**********************PRS Competing Risks Analysis*************************
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
	
**PRS**	
	
	timer on 1
	
	local sum_SHR_PRS = 0
	forvalues i = 1/10	{
			preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset allcause_date, failure(allcause_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(allcause_new) ///
		keep(PRS age sex) trans(1)
		gen allcause_event = failcode == allcause_new
		stset tstop [pw=weight_c], failure(allcause_event==1) enter(tstart)
		stcox PRS age, strata(sex)
		
		quietly matrix mat`i' = r(table)
		quietly matrix list mat`i'
		local shr`i' = mat`i'[1,1]
		local se`i' = mat`i'[2,1]
		local ll`i' = mat`i'[5,1]
		local ul`i' = mat`i'[6,1]
		local pval`i' = mat`i'[4,1]
		display as text "SHR for PRS = " `shr`i''
		display as text "SE for PRS = " `se`i''
		display as text "LCI for PRS = " `ll`i''
		display as text "UCI for PRS = " `ul`i''
		display as text "P for PRS = " `pval`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_allcause.csv", replace text name(table)

noisily di "SHR",%3.2f `shr1', %3.2f `shr2',  %3.2f `shr3',  %3.2f `shr4',  %3.2f `shr5',  %3.2f `shr6',  %3.2f `shr7',  %3.2f `shr8',  %3.2f `shr9',  %3.2f `shr10'
noisily di "SE",%3.2f `se1', %3.2f `se2',  %3.2f `se3',  %3.2f `se4',  %3.2f `se5',  %3.2f `se6',  %3.2f `se7',  %3.2f `se8',  %3.2f `se9',  %3.2f `se10'
noisily di "LL",%3.2f `ll1', %3.2f `ll2',  %3.2f `ll3',  %3.2f `ll4',  %3.2f `ll5',  %3.2f `ll6',  %3.2f `ll7',  %3.2f `ll8',  %3.2f `ll9',  %3.2f `ll10'
noisily di "UL",%3.2f `ul1', %3.2f `ul2',  %3.2f `ul3',  %3.2f `ul4',  %3.2f `ul5',  %3.2f `ul6',  %3.2f `ul7',  %3.2f `ul8',  %3.2f `ul9',  %3.2f `ul10'
noisily di "P",%4.3f `pval1', %4.3f `pval2',  %4.3f `pval3',  %4.3f `pval4',  %4.3f `pval5',  %4.3f `pval6',  %4.3f `pval7',  %4.3f `pval8',  %4.3f `pval9',  %4.3f `pval10'

log close table
}

import delimited "PRS_allcause.csv", delimiter(space) clear 
egen PRS_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_allcause_results, replace
		restore
	}
	
	timer off 1
		
**PRS Tertiles**

	timer on 2

	local sum_SHR_PRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset allcause_date, failure(allcause_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(allcause_new) ///
		keep(PRS_tertile_imputed age sex) trans(1)
		gen allcause_event = failcode == allcause_new
		stset tstop [pw=weight_c], failure(allcause_event==1) enter(tstart)
		stcox i.PRS_tertile_imputed age, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		display as text "SHR for PRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_tertile_3 = " `pval3_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_allcause_tertiles.csv", replace text name(table)

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

log close table
						}

import delimited "PRS_allcause_tertiles.csv", delimiter(space) clear 
egen PRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_allcause_tertiles_results, replace
		restore
				}
	
	timer off 2
	

///////////////////////////ALZHEIMER'S DISEASE//////////////////////////////	
	
**PRS**	
	
	timer on 3
	
	local sum_SHR_PRS = 0
	forvalues i = 1/10	{
			preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset alzheimer_date, failure(alzheimer_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(alzheimer_new) ///
		keep(PRS age sex) trans(1)
		gen alzheimer_event = failcode == alzheimer_new
		stset tstop [pw=weight_c], failure(alzheimer_event==1) enter(tstart)
		stcox PRS age, strata(sex)
		
		quietly matrix mat`i' = r(table)
		quietly matrix list mat`i'
		local shr`i' = mat`i'[1,1]
		local se`i' = mat`i'[2,1]
		local ll`i' = mat`i'[5,1]
		local ul`i' = mat`i'[6,1]
		local pval`i' = mat`i'[4,1]
		display as text "SHR for PRS = " `shr`i''
		display as text "SE for PRS = " `se`i''
		display as text "LCI for PRS = " `ll`i''
		display as text "UCI for PRS = " `ul`i''
		display as text "P for PRS = " `pval`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_alzheimers.csv", replace text name(table)

noisily di "SHR",%3.2f `shr1', %3.2f `shr2',  %3.2f `shr3',  %3.2f `shr4',  %3.2f `shr5',  %3.2f `shr6',  %3.2f `shr7',  %3.2f `shr8',  %3.2f `shr9',  %3.2f `shr10'
noisily di "SE",%3.2f `se1', %3.2f `se2',  %3.2f `se3',  %3.2f `se4',  %3.2f `se5',  %3.2f `se6',  %3.2f `se7',  %3.2f `se8',  %3.2f `se9',  %3.2f `se10'
noisily di "LL",%3.2f `ll1', %3.2f `ll2',  %3.2f `ll3',  %3.2f `ll4',  %3.2f `ll5',  %3.2f `ll6',  %3.2f `ll7',  %3.2f `ll8',  %3.2f `ll9',  %3.2f `ll10'
noisily di "UL",%3.2f `ul1', %3.2f `ul2',  %3.2f `ul3',  %3.2f `ul4',  %3.2f `ul5',  %3.2f `ul6',  %3.2f `ul7',  %3.2f `ul8',  %3.2f `ul9',  %3.2f `ul10'
noisily di "P",%4.3f `pval1', %4.3f `pval2',  %4.3f `pval3',  %4.3f `pval4',  %4.3f `pval5',  %4.3f `pval6',  %4.3f `pval7',  %4.3f `pval8',  %4.3f `pval9',  %4.3f `pval10'

log close table
}

import delimited "PRS_alzheimers.csv", delimiter(space) clear 
egen PRS_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_alzheimers_results, replace
		restore
	}
	
	timer off 3
		
**PRS Tertiles**

	timer on 4

	local sum_SHR_PRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset alzheimer_date, failure(alzheimer_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(alzheimer_new) ///
		keep(PRS_tertile_imputed age sex) trans(1)
		gen alzheimer_event = failcode == alzheimer_new
		stset tstop [pw=weight_c], failure(alzheimer_event==1) enter(tstart)
		stcox i.PRS_tertile_imputed age, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		display as text "SHR for PRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_tertile_3 = " `pval3_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_alzheimers_tertiles.csv", replace text name(table)

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

log close table
						}

import delimited "PRS_alzheimers_tertiles.csv", delimiter(space) clear 
egen PRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_alzheimers_tertiles_results, replace
		restore
				}
	
	timer off 4
	
	
//////////////////////////VASCULAR DEMENTIA//////////////////////////////	
	
**PRS**	
	
	timer on 5
	
	local sum_SHR_PRS = 0
	forvalues i = 1/10	{
			preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset vascular_date, failure(vascular_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(vascular_new) ///
		keep(PRS age sex) trans(1)
		gen vascular_event = failcode == vascular_new
		stset tstop [pw=weight_c], failure(vascular_event==1) enter(tstart)
		stcox PRS age, strata(sex)
		
		quietly matrix mat`i' = r(table)
		quietly matrix list mat`i'
		local shr`i' = mat`i'[1,1]
		local se`i' = mat`i'[2,1]
		local ll`i' = mat`i'[5,1]
		local ul`i' = mat`i'[6,1]
		local pval`i' = mat`i'[4,1]
		display as text "SHR for PRS = " `shr`i''
		display as text "SE for PRS = " `se`i''
		display as text "LCI for PRS = " `ll`i''
		display as text "UCI for PRS = " `ul`i''
		display as text "P for PRS = " `pval`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_vascular.csv", replace text name(table)

noisily di "SHR",%3.2f `shr1', %3.2f `shr2',  %3.2f `shr3',  %3.2f `shr4',  %3.2f `shr5',  %3.2f `shr6',  %3.2f `shr7',  %3.2f `shr8',  %3.2f `shr9',  %3.2f `shr10'
noisily di "SE",%3.2f `se1', %3.2f `se2',  %3.2f `se3',  %3.2f `se4',  %3.2f `se5',  %3.2f `se6',  %3.2f `se7',  %3.2f `se8',  %3.2f `se9',  %3.2f `se10'
noisily di "LL",%3.2f `ll1', %3.2f `ll2',  %3.2f `ll3',  %3.2f `ll4',  %3.2f `ll5',  %3.2f `ll6',  %3.2f `ll7',  %3.2f `ll8',  %3.2f `ll9',  %3.2f `ll10'
noisily di "UL",%3.2f `ul1', %3.2f `ul2',  %3.2f `ul3',  %3.2f `ul4',  %3.2f `ul5',  %3.2f `ul6',  %3.2f `ul7',  %3.2f `ul8',  %3.2f `ul9',  %3.2f `ul10'
noisily di "P",%4.3f `pval1', %4.3f `pval2',  %4.3f `pval3',  %4.3f `pval4',  %4.3f `pval5',  %4.3f `pval6',  %4.3f `pval7',  %4.3f `pval8',  %4.3f `pval9',  %4.3f `pval10'

log close table
}

import delimited "PRS_vascular.csv", delimiter(space) clear 
egen PRS_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_vascular_results, replace
		restore
	}
	
	timer off 5
		
**PRS Tertiles**

	timer on 6

	local sum_SHR_PRS_tertiles = 0
	forvalues i = 1/10	{
		preserve
		display "Imputation `i'"
		mi extract `i', clear
		stset vascular_date, failure(vascular_new=1,2) id(n_eid) scale(365.25)
		stcrprep, events(vascular_new) ///
		keep(PRS_tertile_imputed age sex) trans(1)
		gen vascular_event = failcode == vascular_new
		stset tstop [pw=weight_c], failure(vascular_event==1) enter(tstart)
		stcox i.PRS_tertile_imputed age, strata(sex)
		matrix mat`i' = r(table)
		matrix list mat`i'
		
		local shr2_`i' = mat`i'[1,2]
		local shr3_`i' = mat`i'[1,3]
		local se2_`i' = mat`i'[2,2]
		local se3_`i' = mat`i'[2,3]
		local ll2_`i' = mat`i'[5,2]
		local ll3_`i' = mat`i'[5,3]
		local ul2_`i' = mat`i'[6,2]
		local ul3_`i' = mat`i'[6,3]
		local pval2_`i' = mat`i'[4,2]
		local pval3_`i' = mat`i'[4,3]
		display as text "SHR for PRS_tertile_2 = " `shr2_`i''
		display as text "SE for PRS_tertile_2 = " `se2_`i''
		display as text "LCI for PRS_tertile_2 = " `ll2_`i''
		display as text "UCI for PRS_tertile_2 = " `ul2_`i''
		display as text "P for PRS_tertile_2 = " `pval2_`i''
		display as text "SHR for PRS_tertile_3 = " `shr3_`i''
		display as text "SE for PRS_tertile_3 = " `se3_`i''
		display as text "LCI for PRS_tertile_3 = " `ll3_`i''
		display as text "UCI for PRS_tertile_3 = " `ul3_`i''
		display as text "P for PRS_tertile_3 = " `pval3_`i''
		display as text "Number of observations = " as result e(N)
		
		quietly {
			capture log close table
			log using "PRS_vascular_tertiles.csv", replace text name(table)

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

log close table
				}

import delimited "PRS_vascular_tertiles.csv", delimiter(space) clear 
egen PRS_tertiles_Results = rowmean(v2 v3 v4 v5 v6 v7 v8 v9 v10 v11) 
save PRS_vascular_tertiles_results, replace
		restore
		}
	
	timer off 6
	timer list
	timer clear	
	


