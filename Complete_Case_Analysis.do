***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
************************Complete Case Analysis*****************************
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

use "clean_data.dta", clear

**Change the way some data stored to make file smaller and try to speed up analysis a bit**

recast byte sex
recast byte age
recast float PRS, force
recast float z_LRS
recast byte allcause_new
recast byte alzheimer_new
recast byte vascular_new
recast byte PRS_tertile
recast byte LRS_tertile
recast byte PRS_LRS_tertile
recast byte drug_any_bpdrug_ni_bl
recast byte drug_statin_ni_bl
recast byte dm_anydmrx_ni_sr_bl

//////////////////////////////////////////////////////////////////////////
///////////////////////////////BRAIN OUTCOMES/////////////////////////////
//////////////////////////////////////////////////////////////////////////


**PRS**

regress loggm PRS age i.sex tv, eform("exp")
regress loghippocampus PRS age i.sex tv, eform("exp")
regress logwmh PRS age i.sex, eform("exp")

**LRS**

regress loggm z_LRS age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv, eform("exp")
regress loghippocampus z_LRS age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv, eform("exp")
regress logwmh z_LRS age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi, eform("exp")

**TERTILE GROUPINGS**

regress loggm i.PRS_LRS_tertile age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv, eform("exp")
regress loghippocampus i.PRS_LRS_tertile age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi tv, eform("exp")
regress logwmh i.PRS_LRS_tertile age i.sex i.edu socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl child_bmi, eform("exp")



//////////////////////////////////////////////////////////////////////////
///////////DEMENTIA OUTCOMES RUN USING COMPETING RISK MODELS//////////////
//////////////////////////////////////////////////////////////////////////

///////////////////////////ALL-CAUSE DEMENTIA//////////////////////////////

**Use stcrprep to prepare weights**

preserve 		//do this as we drop all variables except those used to save time so need to bring back later//

stset allcause_date, failure(allcause_new=1,2) id(n_eid) scale(365.25)
stcrprep, events(allcause_new) keep(PRS PRS_tertile z_LRS LRS_tertile PRS_LRS_tertile age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
gen allcause_event = failcode == allcause_new
stset tstop [pw=weight_c], failure(allcause_event==1) enter(tstart)

**Run models**

stcox PRS age, strata(sex)
est tab, p(%12.10g)
//estat phtest, plot(PRS) yline(0 `=_b[PRS]')
//estat phtest, detail

stcox z_LRS age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_tertile age, strata(sex)
est tab, p(%12.10g)

stcox i.LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

restore

//////////////////////////ALZHEIMER'S DISEASE/////////////////////////////	

preserve
	
**Use stcrprep to prepare weights**

stset alzheimer_date, failure(alzheimer_new=1,2) id(n_eid) scale(365.25)
stcrprep, events(alzheimer_new) keep(PRS PRS_tertile z_LRS LRS_tertile PRS_LRS_tertile age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
gen alzheimer_event = failcode == alzheimer_new
stset tstop [pw=weight_c], failure(alzheimer_event==1) enter(tstart)

**Run models**

stcox PRS age, strata(sex)
est tab, p(%12.10g)
//estat phtest, plot(PRS) yline(0 `=_b[PRS]')
//estat phtest, detail

stcox z_LRS age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_tertile age, strata(sex)
est tab, p(%12.10g)

stcox i.LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

restore

///////////////////////////VASCULAR DEMENTIA//////////////////////////////

preserve
	
**Use stcrprep to prepare weights**

stset vascular_date, failure(vascular_new=1,2) id(n_eid) scale(365.25)
stcrprep, events(vascular_new) keep(PRS PRS_tertile z_LRS LRS_tertile PRS_LRS_tertile age sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier) trans(1)
gen vascular_event = failcode == vascular_new
stset tstop [pw=weight_c], failure(vascular_event==1) enter(tstart)

**Run models**

stcox PRS age, strata(sex)
est tab, p(%12.10g)
//estat phtest, plot(PRS) yline(0 `=_b[PRS]')
//estat phtest, detail

stcox z_LRS age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_tertile age, strata(sex)
est tab, p(%12.10g)

stcox i.LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

stcox i.PRS_LRS_tertile age i.edu i.socio_strat i.drug_any_bpdrug_ni_bl i.drug_statin_ni_bl i.dm_anydmrx_ni_sr_bl, strata(sex)
est tab, p(%12.10g)

restore

save "Complete_Case_Dataset", replace
