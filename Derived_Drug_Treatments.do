***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
*************Derivation of Cardiometabolic Drug Treatments*****************
***************************************************************************

**The following are derived from "parent" medication variables from self-report nurse interview data n_20003_0_0 to n_20003_0_47**
**Codes used to define the different classes of medication are taken from the look-up table available on UKB website and can be found in S:\ICS\ICS_CMP\Biobank\Data\Coding lists\Medication codes.xlsx**
**NB this may not be an exhaustive list of all brand names and combos - those used were 1) those given in BNF and 2) those found opportunistically on looking through the UKB list (the latter not 100% reliable as drugs not listed in any logical order)**
**Also, many BP combination drugs are listed - e.g. one tablet for ACE + diuretic. These have been counted as being in the ACE and the diuretic category (but can be separated into mono/ dual therapy if needed)**

use "Y:\PRS LRS Brain Health\Documents for Resubmission\Resubmission Do Files\Drug Codes\Arisa_Selected_Variables_180924.dta", clear

***************************************************************************
**************************Anti-Hypertensives*******************************
***************************************************************************

set more off

**Current ACE inhibitor receipt**

gen drug_acei_ni_bl=.
forvalues i=0/47 {
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860750
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860752
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141150328
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141150560
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860758
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141181186
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860764
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141170544
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860882
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860892
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140888552
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860776
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860790
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860784
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140888556
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860878
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141164148
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141164154
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860696
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860714
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860706
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140864618
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140923712
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140923718
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140888560
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860802
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141180592
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141180598
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860728
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140881706
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860738
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860736
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860806
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141188408
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141165476
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141165470
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860904
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141153328
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860912
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1140860918
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141165470
replace drug_acei_ni_bl=1 if n_20003_0_`i'==1141180592
}

*
lab var drug_acei_ni_bl "Taking ACE inhibitor, baseline nurse interview"
recode drug_acei_ni_bl .=0
lab def drug_acei_ni_bllab 0"No ACE inhibitor" 1"On ACE inhibitor"
lab val drug_acei_ni_bl drug_acei_ni_bllab
tab drug_acei_ni_bl


**Current angiotensin receptor blocker (ARB) receipt**

gen drug_arb_ni_bl=.
forvalues i=0/47 {
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141156836
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141156846
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141171336
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141171344
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141152998
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141153006
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141172682
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141172686
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1140916356
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141179974
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141151016
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1140916362
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141151018
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141193282
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141193346
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141166006
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141172492
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141187788
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141187790
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141145660
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1140866758
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141145668
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141201038
replace drug_arb_ni_bl=1 if n_20003_0_`i'==1141201040
}

*
lab var drug_arb_ni_bl "Taking angiotensin-II receptor antagonist (ARB), baseline nurse interview"
recode drug_arb_ni_bl .=0
lab def drug_arb_ni_bllab 0"No ARB" 1"On ARB"
lab val drug_arb_ni_bl drug_arb_ni_bllab
tab drug_arb_ni_bl


**Current calcium channel blocker (CCB) receipt (NB/ this excludes verapamil and diltiazem)**

gen drug_ccb_ni_bl=.
forvalues i=0/47 {
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140879802
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861202
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141200400
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140888646
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141199858
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141188576
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141188152
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141188920
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141200782
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140868036
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141201814
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141190160
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140928212
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141165470
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861190
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861194
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861276
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861282
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141153032
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140879810
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861176
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861088
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140860426
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861090
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140881702
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140860356
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861110
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140923572
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861120
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861106
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141145870
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140861114
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141157140
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140927940
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141190548
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140872568
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140872472
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141165476
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1141165470
replace drug_ccb_ni_bl=1 if n_20003_0_`i'==1140860426
}

*
lab var drug_ccb_ni_bl "Taking calcium channel blocker (CCB), baseline nurse interview"
recode drug_ccb_ni_bl .=0
lab def drug_ccb_ni_bllab 0"No CCB" 1"On CCB"
lab val drug_ccb_ni_bl drug_ccb_ni_bllab
tab drug_ccb_ni_bl


**Current thiazide-related diuretic (thiazide) receipt**

gen drug_thiazide_ni_bl=.
forvalues i=0/47 {
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194794
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194800
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194804
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194808
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194810
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866128
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866136
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866446
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140909706
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141180778
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141180772
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866146
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140851364
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866156
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866422
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860334
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866158
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140851368
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866078
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141180592
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141146378
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866108
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140866110
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860790
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140864618
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141180592
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860738
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860736
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141172682
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141151016
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141187788
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141187790
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141201038
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141201040
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860418
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860394
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860396
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860422
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141146126
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194810
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860348
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860352
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141146128
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141180778
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141146124
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140864950
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860328
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860308
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860404
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860402
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860390
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860312
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860316
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194804
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194800
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860322
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860340
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1141194808
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860336
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860406
replace drug_thiazide_ni_bl=1 if n_20003_0_`i'==1140860342
}

*
lab var drug_thiazide_ni_bl "Taking thiazide diuretic, baseline nurse interview"
recode drug_thiazide_ni_bl .=0
lab def drug_thiazide_ni_bllab 0"No thiazide diuretic" 1"On thiazide diuretic"
lab val drug_thiazide_ni_bl drug_thiazide_ni_bllab
tab drug_thiazide_ni_bl


**Current alpha-blocker receipt**

gen drug_alpha_block_ni_bl=.
forvalues i=0/47 {
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140879778
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1141194372
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140860690
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140879782
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1141157490
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140860658
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140879794
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140860580
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140860590
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140879798
replace drug_alpha_block_ni_bl=1 if n_20003_0_`i'==1140860610
}

*
lab var drug_alpha_block_ni_bl "Taking alpha blocker, baseline nurse interview"
recode drug_alpha_block_ni_bl .=0
lab def drug_alpha_block_ni_bllab 0"No alpha blocker" 1"On alpha blocker"
lab val drug_alpha_block_ni_bl drug_alpha_block_ni_bllab
tab drug_alpha_block_ni_bl


**Current beta-blocker receipt (NB sotalol left out as used for arrhythmias only)**

gen drug_beta_block_ni_bl=.
forvalues i=0/47 {
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879842
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866804
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866800
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866784
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866798
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866778
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866766
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866764
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866704
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141172742
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140851556
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866802
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866782
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860418
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860394
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860396
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866724
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860422
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866726
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860314
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866738
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140866756
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860398
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860356
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141146126
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194810
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860348
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860352
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860426
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141146128
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141180778
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141146124
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860358
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860232
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879760
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140864950
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141171152
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860492
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860434
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140909368
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879762
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860498
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140923336
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860324
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860328
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860250
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879818
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860386
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860266
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860278
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860308
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860404
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860402
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860274
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860192
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860194
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860390
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860312
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860316
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194804
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194800
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141164276
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141164280
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879830
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860212
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860220
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860222
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860292
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860322
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860294
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860338
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140879866
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860340
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194808
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860336
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860406
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860342
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860380
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860382
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860410
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1140860426
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194804
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194808
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141194810
replace drug_beta_block_ni_bl=1 if n_20003_0_`i'==1141180778
}

*
lab var drug_beta_block_ni_bl "Taking beta blocker, baseline nurse interview"
recode drug_beta_block_ni_bl .=0
lab def drug_beta_block_ni_bllab 0"No beta blocker" 1"On beta blocker"
lab val drug_beta_block_ni_bl drug_beta_block_ni_bllab
tab drug_beta_block_ni_bl


**Any anti-hypertensive medication**

gen drug_any_bpdrug_ni_bl=0
replace drug_any_bpdrug_ni_bl=1 if drug_acei_ni_bl==1| drug_arb_ni_bl==1| drug_ccb_ni_bl==1| drug_thiazide_ni_bl==1| drug_alpha_block_ni_bl==1| drug_beta_block_ni_bl==1
tab drug_any_bpdrug_ni_bl
lab var drug_any_bpdrug_ni_bl "On any anti-hypertensive at baseline, nurse interview"
lab def drug_any_bpdrug_ni_bllab 0"No anti-hypertensive" 1"On 1+ anti-hypertensive"
lab val drug_any_bpdrug_ni_bl drug_any_bpdrug_ni_bllab



***************************************************************************
*******************************Statins*************************************
***************************************************************************

**NB this may not be an exhaustive list of all brand names and combos - used only those given in BNF**

///Simvastatin: 1140861958|1141188146|1140881748|1141200040
///Fluvastatin: 1140888594|1140864592
///Pravastatin:1140888648|1140861970
///Eptastatin: 1140910632
///Velastatin: 1140910654
///Atorvastatin: 1141146234|1141146138
///Rosuvastatin: 1141192410|1141192414
///Cerivastatin:1140910652


**Current statin receipt**

gen drug_statin_ni_bl=.
forvalues i=0/47 {
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140861958
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141188146
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140881748
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141200040
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140888594
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140864592
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140888648
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140861970
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140910632
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140910654
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141146234
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141146138
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141192410
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1141192414
replace drug_statin_ni_bl=1 if n_20003_0_`i'==1140910652
}

*
lab var drug_statin_ni_bl "Taking statin, baseline nurse interview"
recode drug_statin_ni_bl .=0
lab def drug_statin_ni_bllab 0"No statin" 1"On statin"
lab val drug_statin_ni_bl drug_statin_ni_bllab
tab drug_statin_ni_bl

***************************************************************************
**********************Hypoglycaemic Treatments*****************************
***************************************************************************


**Codes used to define the different classes of medication**

///Insulins (all, non-specified): 1140883066
///Metformin (generic name, trade name, combinations): 1140884600 | 1140874686 | 1141189090
///Sulfonylureas (generic names, trade names): 1140874718 | 1140874744 | 1140874746 | 1141152590 | 1141156984 | 1140874646 | 1141157284 | 1140874652 | 1140874674 | 1140874728
///Others (acarbose generic, acarbose trade, Glucotard trade): 1140868902 |1140868908 | 1140857508 
///Meglitinides (generic names, trade names):1141173882 | 1141173786 | 1141168660
///Glitazones (generic names, trade names): 1141171646 | 1141171652 | 1141153254 | 1141177600 | 1141177606
///Non-metformin OADs (including above 4 drug classes):
*1140874718 | 1140874744 | 1140874746 | 1141152590 | 1141156984 | 1140874646 | 1141157284 | 1140874652 | 1140874674 | 1140874728 |
*1140868902 |1140868908 | 1140857508 | 1141173882 | 1141173786 | 1141168660 | 1141171646 | 1141171652 | 1141153254 | 1141177600 | 1141177606


**Derivation of classes:**
///Insulins; dm_drug_ins_ni_bl
gen dm_drug_ins_ni_bl=.
forvalues i=0/47 {
replace dm_drug_ins_ni_bl=1 if n_20003_0_`i'==1140883066
}

*
lab var dm_drug_ins_ni_bl "Taking insulin, baseline nurse interview"
recode dm_drug_ins_ni_bl .=0
lab def dm_drug_ins_ni_bllab 0"No insulin" 1"On insulin"
lab val dm_drug_ins_ni_bl dm_drug_ins_ni_bllab
tab dm_drug_ins_ni_bl


///Metformin; dm_drug_metf_ni_bl
gen dm_drug_metf_ni_bl=.
forvalues i=0/47 {
replace dm_drug_metf_ni_bl=1 if n_20003_0_`i'==1140884600 
replace dm_drug_metf_ni_bl=1 if n_20003_0_`i'==1140874686
replace dm_drug_metf_ni_bl=1 if n_20003_0_`i'==1141189090
}

*
lab var dm_drug_metf_ni_bl "Taking metformin, baseline nurse interview"
recode dm_drug_metf_ni_bl .=0
lab def dm_drug_metf_ni_bllab 0"No metformin" 1"On metformin"
lab val dm_drug_metf_ni_bl dm_drug_metf_ni_bllab
tab dm_drug_metf_ni_bl


///Sulfonylureas; dm_drug_su_ni_bl 
gen dm_drug_su_ni_bl=.
forvalues i=0/47 {
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874718 
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874744
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874746
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1141152590 
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1141156984
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874646
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1141157284 
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874652
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874674
replace dm_drug_su_ni_bl=1 if n_20003_0_`i'==1140874728 
}

*
lab var dm_drug_su_ni_bl "Taking sulfonylurea, baseline nurse interview"
recode dm_drug_su_ni_bl  .=0
lab def dm_drug_su_ni_bllab 0"No sulfonylurea" 1"On sulfonylurea"
lab val dm_drug_su_ni_bl dm_drug_su_ni_bllab
tab dm_drug_su_ni_bl


///Other OAD; dm_drug_other_oad_ni_bl
gen dm_drug_other_oad_ni_bl=.
forvalues i=0/47 {
replace dm_drug_other_oad_ni_bl=1 if n_20003_0_`i'==1140868902 
replace dm_drug_other_oad_ni_bl=1 if n_20003_0_`i'==1140868908
replace dm_drug_other_oad_ni_bl=1 if n_20003_0_`i'==1140857508
}

*
lab var dm_drug_other_oad_ni_bl "Taking other oral anti-diabetic (acarbose, guar gum), baseline nurse interview"
recode dm_drug_other_oad_ni_bl .=0
lab def dm_drug_other_oad_ni_bllab 0"Not on other oral anti-diabetic" 1"On other oral anti-diabetic"
lab val dm_drug_other_oad_ni_bl dm_drug_other_oad_ni_bllab
tab dm_drug_other_oad_ni_bl


///Meglitinides; dm_drug_meglit_ni_bl 
gen dm_drug_meglit_ni_bl=.
forvalues i=0/47 {
replace dm_drug_meglit_ni_bl=1 if n_20003_0_`i'==1141173882 
replace dm_drug_meglit_ni_bl=1 if n_20003_0_`i'==1141173786
replace dm_drug_meglit_ni_bl=1 if n_20003_0_`i'==1141168660
}

*
lab var dm_drug_meglit_ni_bl "Taking meglitinide, baseline nurse interview"
recode dm_drug_meglit_ni_bl .=0
lab def dm_drug_meglit_ni_bllab 0"No meglitinide" 1"On meglitinide"
lab val dm_drug_meglit_ni_bl dm_drug_meglit_ni_bllab
tab dm_drug_meglit_ni_bl


///Glitazones; dm_drug_glitaz_ni_bl 
gen dm_drug_glitaz_ni_bl=.
forvalues i=0/47 {
replace dm_drug_glitaz_ni_bl=1 if n_20003_0_`i'==1141171646 
replace dm_drug_glitaz_ni_bl=1 if n_20003_0_`i'==1141171652
replace dm_drug_glitaz_ni_bl=1 if n_20003_0_`i'==1141153254
replace dm_drug_glitaz_ni_bl=1 if n_20003_0_`i'==1141177600
replace dm_drug_glitaz_ni_bl=1 if n_20003_0_`i'==1141177606
}

*
lab var dm_drug_glitaz_ni_bl "Taking glitazone, baseline nurse interview"
recode dm_drug_glitaz_ni_bl .=0
lab def dm_drug_glitaz_ni_bllab 0"No glitazone" 1"On glitazone"
lab val dm_drug_glitaz_ni_bl dm_drug_glitaz_ni_bllab
tab dm_drug_glitaz_ni_bl


///Non-metformin OADs (including   above 4 drug classes): dm_drug_nonmetf_oad_ni_bl
gen dm_drug_nonmetf_oad_ni_bl=.
replace dm_drug_nonmetf_oad_ni_bl=1 if dm_drug_su_ni_bl==1 | dm_drug_other_oad_ni_bl==1==1 | dm_drug_meglit_ni_bl==1 | dm_drug_glitaz_ni_bl==1
lab var dm_drug_nonmetf_oad_ni_bl "Taking non-metformin oral anti-diabetic drug, baseline nurse interview"
recode dm_drug_nonmetf_oad_ni_bl .=0
lab def dm_drug_nonmetf_oad_ni_bllab 0"No non-metformin oral anti-diabetic drug" 1"On non-metformin oral anti-diabetic drug"
lab val dm_drug_nonmetf_oad_ni_bl dm_drug_nonmetf_oad_ni_bllab
tab dm_drug_nonmetf_oad_ni_bl


///Any medication
gen dm_anydmrx_ni_sr_bl=0
replace dm_anydmrx_ni_sr_bl=1 if dm_drug_ins_ni_bl==1|dm_drug_metf_ni_bl==1|dm_drug_nonmetf_oad_ni_bl==1
lab var dm_anydmrx_ni_sr_bl "Any reported diabetes medication"
tab dm_anydmrx_ni_sr_bl

keep n_eid drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl


save "derived drug variables", replace
