***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
**************************Multiple Imputation******************************
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

use "Complete_Case_Dataset", clear

mi set wide
mi register regular age sex ethnic allcause_new alzheimer_new vascular_new drug_statin_ni_bl dm_anydmrx_ni_sr_bl drug_any_bpdrug_ni_bl
mi register imputed PRS edu socio_strat smoke_score sleep_score lipid_score bloodsugar_score bp_score bmi_score diet_score PA_score pairs rt fluid e4_carrier
mi impute chained (regress) PRS pairs rt fluid (logit) e4_carrier (ologit) socio_strat bp_score bmi_score bloodsugar_score lipid_score PA_score diet_score edu sleep_score smoke_score = age sex ethnic allcause_new alzheimer_new vascular_new, add(10) rseed(54321) dots augment

save "Imputed_Dataset.dta", replace

