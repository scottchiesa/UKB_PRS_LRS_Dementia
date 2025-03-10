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

drop if tv == .

mi set flong
mi register regular loggm tv age sex ethnic drug_statin_ni_bl dm_anydmrx_ni_sr_bl drug_any_bpdrug_ni_bl
mi register imputed loghippocampus logwmh PRS edu socio_strat smoke_score sleep_score lipid_score bloodsugar_score bp_score bmi_score diet_score PA_score pairs rt fluid child_bmi
mi impute chained (regress) loghippocampus logwmh PRS pairs rt fluid (ologit) socio_strat bp_score bmi_score bloodsugar_score lipid_score PA_score diet_score edu sleep_score smoke_score child_bmi = loggm tv age sex ethnic drug_statin_ni_bl dm_anydmrx_ni_sr_bl drug_any_bpdrug_ni_bl, add(10) rseed(54321) noisily dots augment

save "Imputed_Dataset_for_Neuroimaging.dta", replace

//Generate Imputed LRS Variables//

mi passive: gen LRS_imputed = (bp_score + bmi_score + bloodsugar_score + lipid_score + PA_score + diet_score + sleep_score + smoke_score)
mi passive: gen LRS_bio_imputed = lipid_score + bloodsugar_score + bp_score + bmi_score
mi passive: gen LRS_beh_imputed = smoke_score + sleep_score + diet_score + PA_score

//Generate Imputed LRS z-scores using mi xeq to loop through each individual imputed dataset in turn//

gen z_LRS_imputed = .
mi xeq: sum LRS_imputed; return list; replace z_LRS_imputed = (LRS_imputed - r(mean)) / r(sd)

//Generate PRS Tertiles Using Imputed Data//

mi passive: egen PRS_tertile_imputed = cut(PRS), group(3)

//Generate LRS Tertiles Using Imputed Data//

mi passive : gen LRS_tertile_imputed = ///
    cond(LRS_imputed >= 0 & LRS_imputed <6, 1,        ///
    cond(LRS_imputed >= 6 & LRS_imputed <8, 2,        ///
    cond(LRS_imputed >= 8 & LRS_imputed <., 3,        ///
         LRS_imputed)))
label define LRS_tertile_imputed 1 "low" 2 "med" 3 "high"
label values LRS_tertile_imputed LRS_tertile_imputed

//Generate PRS_LRS Tertiles Using Imputed Data//

mi passive : gen PRS_LRS_tertile_imputed = ///
    cond(PRS_tertile_imputed==0 & LRS_tertile_imputed==1, 1,        ///
    cond(PRS_tertile_imputed==0 & LRS_tertile_imputed==2, 2,        ///
    cond(PRS_tertile_imputed==0 & LRS_tertile_imputed==3, 3,        ///
	cond(PRS_tertile_imputed==1 & LRS_tertile_imputed==1, 4,        ///
    cond(PRS_tertile_imputed==1 & LRS_tertile_imputed==2, 5,        ///
    cond(PRS_tertile_imputed==1 & LRS_tertile_imputed==3, 6,        ///
	cond(PRS_tertile_imputed==2 & LRS_tertile_imputed==1, 7,        ///
    cond(PRS_tertile_imputed==2 & LRS_tertile_imputed==2, 8,        ///
    cond(PRS_tertile_imputed==2 & LRS_tertile_imputed==3, 9,        ///
         .)))))))))
label define PRS_LRS_tertile_imputed 1 "low/low" 2 "low/mid" 3 "low/high" 4 "mid/low" 5 "mid/mid" 6 "mid/high" 7 "high/low" 8 "high/mid" 9 "high/high"
label values PRS_LRS_tertile_imputed PRS_LRS_tertile_imputed

save "Dataset_ready_for_neuroimaging_imputation_analyses.dta", replace

///////////////////////////////ALL/////////////////////////////

use "Dataset_ready_for_neuroimaging_imputation_analyses.dta", clear

**PRS**

mi estimate: regress loggm PRS age i.sex tv if e4_carrier !=., eform("exp")
mi estimate: regress loghippocampus PRS age i.sex tv if e4_carrier !=., eform("exp")
mi estimate: regress logwmh PRS age i.sex if e4_carrier !=., eform("exp")
//mi estimate: regress logwmh PRS age i.sex tv if e4_carrier !=., eform("exp")

**LRS**

mi estimate: regress loggm z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")
mi estimate: regress loghippocampus z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")
mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier !=., eform("exp")
//mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")

**TERTILE GROUPINGS**

mi estimate: regress loggm i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")
mi estimate: regress loghippocampus i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")
mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier !=., eform("exp")
//mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier !=., eform("exp")

///////////////////////////////NO E4/////////////////////////////

**PRS**

mi estimate: regress loggm PRS age i.sex tv if e4_carrier == 0, eform("exp")
mi estimate: regress loghippocampus PRS age i.sex tv if e4_carrier == 0, eform("exp")
mi estimate: regress logwmh PRS age i.sex if e4_carrier == 0, eform("exp")
//mi estimate: regress logwmh PRS age i.sex tv if e4_carrier == 0, eform("exp")

**LRS**

mi estimate: regress loggm z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")
mi estimate: regress loghippocampus z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")
mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier == 0, eform("exp")
//mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")

**TERTILE GROUPINGS**

mi estimate: regress loggm i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")
mi estimate: regress loghippocampus i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")
mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier == 0, eform("exp")
//mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 0, eform("exp")

///////////////////////////////E4/////////////////////////////

**PRS**

mi estimate: regress loggm PRS age i.sex tv if e4_carrier == 1, eform("exp")
mi estimate: regress loghippocampus PRS age i.sex tv if e4_carrier == 1, eform("exp")
mi estimate: regress logwmh PRS age i.sex if e4_carrier == 1, eform("exp")
//mi estimate: regress logwmh PRS age i.sex tv if e4_carrier == 1, eform("exp")

**LRS**

mi estimate: regress loggm z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")
mi estimate: regress loghippocampus z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")
mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier == 1, eform("exp")
//mi estimate: regress logwmh z_LRS_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")

**TERTILE GROUPINGS**

mi estimate: regress loggm i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")
mi estimate: regress loghippocampus i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")
mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi if e4_carrier == 1, eform("exp")
//mi estimate: regress logwmh i.PRS_LRS_tertile_imputed age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv if e4_carrier == 1, eform("exp")
