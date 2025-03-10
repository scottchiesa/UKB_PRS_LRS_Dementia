***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
********************Data Preparation and Set-Up****************************
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

**Create Analysis Log**

use "Arisa_Selected_Variables_270324.dta", clear

**Merging in values for Baseline Drug Tx created in file Derived Drug Treatments.do**

merge 1:1 n_eid using "derived_drug_variables"
drop _merge

**Merging in values for ApoE carriage created in file Derived ApoE Carriage.do**

merge 1:1 n_eid using "derived_apoe_genotypes"
drop _merge


///////////////////////////////////////////////////////////////////////////
///////////////////////PREPARING DEMENTIA OUTCOMES/////////////////////////
///////////////////////////////////////////////////////////////////////////


rename ts_53_0_0 date_assess_bl
rename ts_40000_0_0 date_death

rename ts_42018_0_0 allcause_date
rename n_42019_0_0 allcause_source
rename ts_42020_0_0 alzheimer_date
rename n_42021_0_0 alzheimer_source
rename ts_42022_0_0 vascular_date
rename n_42023_0_0 vascular_source

tab allcause_source
tab alzheimer_source
tab vascular_source

format date_assess_bl %td
format date_death %td

**Remove anyone diagnosed with dementia before baseline assessment so left with incident cases**

count if allcause_date < date_assess_bl 
drop if allcause_date < date_assess_bl 

**Set up dementia outcomes for competing risk models**
*Original data coding: 0-self-reported only; 1-hospital admission; 2-death only; 11-hospital primary; 12-death primary; 21-hospital secondary; 22-death contributory*
*New coding: 0-no dementia; 1-dementia; 2-competing risk of death (not by dementia)*

gen allcause_new=.
replace allcause_new=0 if allcause_source==. 
replace allcause_new=1 if allcause_source==0
replace allcause_new=1 if allcause_source==1
replace allcause_new=1 if allcause_source==2
replace allcause_new=1 if allcause_source==11
replace allcause_new=1 if allcause_source==12
replace allcause_new=1 if allcause_source==21
replace allcause_new=1 if allcause_source==22
replace allcause_new=2 if date_death < allcause_date & allcause_new == 0		//For competing risk of death not classified as occurring due to dementia//

gen alzheimer_new=.
replace alzheimer_new=0 if alzheimer_source==.
replace alzheimer_new=1 if alzheimer_source==0
replace alzheimer_new=1 if alzheimer_source==1
replace alzheimer_new=1 if alzheimer_source==2
replace alzheimer_new=1 if alzheimer_source==11
replace alzheimer_new=1 if alzheimer_source==12
replace alzheimer_new=1 if alzheimer_source==21
replace alzheimer_new=1 if alzheimer_source==22
replace alzheimer_new=2 if date_death < alzheimer_date & alzheimer_new == 0

gen vascular_new=.
replace vascular_new=0 if vascular_source==.
replace vascular_new=1 if vascular_source==0
replace vascular_new=1 if vascular_source==1
replace vascular_new=1 if vascular_source==2
replace vascular_new=1 if vascular_source==11
replace vascular_new=1 if vascular_source==12
replace vascular_new=1 if vascular_source==21
replace vascular_new=1 if vascular_source==22
replace vascular_new=2 if date_death < vascular_date & vascular_new == 0

tab allcause_new
tab alzheimer_new
tab vascular_new

**Ensure correct dates for event, censoring, and death set up for all outcomes**

format allcause_date %td
replace allcause_date=date("19/12/2022", "DMY") if allcause_date==.
clonevar allcause_date_nodeath = allcause_date
replace allcause_date = date_death if allcause_date != date_death & allcause_date !=date("19/12/2022", "DMY") & date_death != .

format alzheimer_date %td
replace alzheimer_date=date("19/12/2022", "DMY") if alzheimer_date==.
clonevar alzheimer_date_nodeath = alzheimer_date
replace alzheimer_date = date_death if alzheimer_date != date_death & alzheimer_date !=date("19/12/2022", "DMY") & date_death != .

format vascular_date %td
replace vascular_date=date("19/12/2022", "DMY") if vascular_date==.
clonevar vascular_date_nodeath = vascular_date
replace vascular_date = date_death if vascular_date != date_death & vascular_date !=date("19/12/2022", "DMY") & date_death != .

**Calculate years to diagnosis and drop if < 5 years post-assessment**

rename n_21022_0_0 age			//note: ages' max and min values w/n mean +-4SD range//
drop if age < 50				//Drop anyone below 50 years old as they can't have LOAD given length of follow-up//
gen followup = allcause_date - date_assess_bl
gen diag_time = (allcause_date - date_assess_bl)/365  if allcause_new == 1
gen diag_age = age + followup/365.25 if allcause_new == 1
drop if diag_time < 5


///////////////////////////////////////////////////////////////////////////
/////////////////////////PREPARING COVARIATES//////////////////////////////
///////////////////////////////////////////////////////////////////////////

**Sex**

rename n_31_0_0 sex
label define sex 0 "female" 1 "male"
label values sex sex

**Socioeconomic Status**

rename n_22189_0_0 socioeco		//note: socioeco' max value (11) is slightly out of range (-1.44 + 4(2.9) = 10.15)//
xtile socio_strat = socioeco, n(3)

**Ethnicity**

rename n_21000_0_0 ethnic
keep if ethnic >1000 & ethnic <1004			//Keep only if white to avoid issues with ancestry//

**Education**

rename n_6138_0_0 edu
replace edu = . if edu == -3
recode edu (-7 = 7)
label define edu 1 "uni" 2 "Alevel" 3 "Olevel" 4 "CSE" 5 "NVQ" 6 "otherprof" 7 "none"
label values edu edu

gen edu_strat = .
replace edu_strat = 1 if edu == 1
replace edu_strat = 2 if edu == 2
replace edu_strat = 2 if edu == 3
replace edu_strat = 2 if edu == 4
replace edu_strat = 2 if edu == 5
replace edu_strat = 2 if edu == 6
replace edu_strat = 3 if edu == 7
label define edu_strat 1 "Higher Education" 2 "Secondary or Other Education" 3 "No Education"
label values edu_strat edu_strat

**Childhood Body Size**		//including this for brain volume measures due to recent paper at doi.org/10.1093/brain/awae198//

rename n_1687_0_0 child_bmi
replace child_bmi = . if child_bmi < 0


//////////////////////////////////////////////////////////////////////////
///////////////////PREPARING POLYGENIC RISK SCORE/////////////////////////
//////////////////////////////////////////////////////////////////////////

rename n_26227_0_0 PRS

//////////////////////////////////////////////////////////////////////////
///////////////////////PREPARING BRAIN OUTCOMES///////////////////////////
//////////////////////////////////////////////////////////////////////////

**Neuroimaging Outcomes**

rename n_25010_2_0 tv
rename n_25006_2_0 gm
rename n_25008_2_0 wm
rename n_25781_2_0 wmh
gen thalamus = (n_25011_2_0 + n_25012_2_0)/2
gen hippocampus = (n_25019_2_0 + n_25020_2_0)/2
gen amygdala = (n_25021_2_0 + n_25022_2_0)/2
gen logwmh = log(wmh)
gen loggm = log(gm)
gen loghippocampus = log(hippocampus)
gen area = (n_26721_2_0 + n_26822_2_0)
gen thick = (n_26755_2_0 + n_26856_2_0)/2
rename n_26521_2_0 icv

zscore tv gm loggm area thick wm logwmh amygdala hippocampus loghippocampus thalamus icv

**Cognitive Outcomes**		//to use as auxiliary variable in MI as predicts missingness//

rename n_399_0_1 pairs
rename n_20023_0_0 rt
rename n_20016_0_0 fluid
rename n_4282_0_0 nmem

foreach var of varlist (pairs rt fluid nmem) {
	replace `var' = . if `var' < 0
}

zscore pairs rt fluid nmem 

pca pairs rt fluid nmem 
//scree
predict cog, score


///////////////////////////////////////////////////////////////////////////
//////////////////////PREPARING LIFESTYLE RISK SCORE///////////////////////
///////////////////////////////////////////////////////////////////////////

**Smoking**

rename n_20116_0_0 smoke
replace smoke = . if smoke <0
gen smoke_score = .
replace smoke_score = 0 if smoke == 0
replace smoke_score = 1 if smoke == 1
replace smoke_score = 2 if smoke == 2	//New coding: 0 = never, 1 = previous, 2 = current//

**Sleep**

rename n_1160_0_0 sleep
replace sleep = . if sleep <2
replace sleep = . if sleep >11
gen sleep_score = .
replace sleep_score = 0 if sleep >= 7 & sleep <9
replace sleep_score = 1 if sleep >= 9 & sleep <.
replace sleep_score = 2 if sleep <7

**LDL**

rename n_30780_0_0 lipid
replace lipid = . if lipid <0.09
replace lipid = . if lipid >7.05
//note: mean = 3.57; SD = .87//
gen lipid_score = .
replace lipid_score = 0 if lipid <2.6
replace lipid_score = 1 if lipid >=2.6 & lipid <=4
replace lipid_score = 2 if lipid >=4 & lipid <.

**HbA1c**

rename n_30750_0_0 bloodsugar
replace bloodsugar = . if bloodsugar <9.89
replace bloodsugar = . if bloodsugar >62.05
//note: mean = 35.97; SD = 6.52//
gen bloodsugar_score = .
replace bloodsugar_score = 0 if bloodsugar >=35 & bloodsugar <42
replace bloodsugar_score = 1 if bloodsugar >=42 & bloodsugar <48
replace bloodsugar_score = 1 if bloodsugar <35
replace bloodsugar_score = 2 if bloodsugar >=48 & bloodsugar <.

**Blood Pressure**

rename n_4080_0_0 sbp
rename n_4079_0_0 dbp
replace sbp = . if sbp <61.18
replace sbp = . if sbp >218.62
//note: mean = 139.9; SD = 19.68//
replace dbp = . if dbp <39.45
replace dbp = . if dbp >124.89
//note: mean = 82.17; SD = 10.68//
gen bp_score = .
replace bp_score = 0 if sbp <120 & dbp <80
replace bp_score = 1 if sbp >=120 & sbp <130
replace bp_score = 1 if dbp >=80 & dbp <90
replace bp_score = 2 if sbp >=130 & dbp <.
replace bp_score = 2 if dbp >=90 & sbp <.

**BMI**

rename n_21001_0_0 bmi
replace bmi = . if bmi <8.29
replace bmi = . if bmi >46.53
//note: mean = 27.41; SD = 4.78//
gen bmi_score = .
replace bmi_score = 0 if bmi <25
replace bmi_score = 1 if bmi >=25 & bmi <30
replace bmi_score = 2 if bmi >=30 & bmi <.

**Diet**
*Note that lifestyle_score is the lower the better; but fruit_score & co is the higher the better*

*Fruit*
rename n_1309_0_0 fruitfresh
replace fruitfresh = . if fruitfresh ==-3
replace fruitfresh = . if fruitfresh ==-1
replace fruitfresh = 0 if fruitfresh ==-10
/////-10 is less than one serving per day//
replace fruitfresh = . if fruitfresh >9
//note: mean = 2.2; SD = 1.59//

rename n_1319_0_0 fruitdried
replace fruitdried = . if fruitdried ==-3
replace fruitdried = . if fruitdried ==-1
replace fruitdried = 0 if fruitdried ==-10
replace fruitdried = . if fruitdried >8
//note: mean = .79; SD = 1.69// 

gen fruit = fruitdried+fruitfresh
gen fruit_score = .
replace fruit_score = 0 if fruit <3
replace fruit_score = 1 if fruit >=3 & fruit <.
replace fruit_score = 1 if fruitdried >=3 & fruitdried <.
replace fruit_score = 1 if fruitfresh >=3 & fruitfresh<.

*Veg*
rename n_1289_0_0 vegcooked
replace vegcooked = . if vegcooked ==-3
replace vegcooked = . if vegcooked ==-1
replace vegcooked = 0 if vegcooked ==-10
replace vegcooked = . if vegcooked >10
//note: mean = 2.69; SD = 1.84//

rename n_1299_0_0 vegraw
replace vegraw = . if vegraw ==-3
replace vegraw = . if vegraw ==-1
replace vegraw = 0 if vegraw ==-10
replace vegraw = . if vegraw >11
//note: mean = 2.13; SD = 2.10//

gen veg = vegcooked+vegraw
gen veg_score = .
replace veg_score = 0 if veg <3
replace veg_score = 1 if veg >=3 & veg <.
replace veg_score = 1 if vegcooked >=3 & vegcooked <.
replace veg_score = 1 if vegraw >=3 & vegraw<.

*Fish*
rename n_1329_0_0 fishoily
replace fishoily = . if fishoily <0
replace fishoily = 0 if fishoily == 1
replace fishoily = 1 if fishoily == 2
replace fishoily = 2 if fishoily >=3 & fishoily <.
//originally, 1 is less than one serving; 2 = 1 serving; 3 = 2-4 times a week//

rename n_1339_0_0 fishnon
replace fishnon = . if fishnon <0
replace fishnon = 0 if fishnon == 1
replace fishnon = 1 if fishnon == 2
replace fishnon = 2 if fishnon >=3 & fishnon <.

gen fish = fishoily+fishnon
gen fish_score = .
replace fish_score = 0 if fish <2
replace fish_score = 1 if fish >=2 & fish <.
replace fish_score = 1 if fishoily >=2 & fishoily <.
replace fish_score = 1 if fishnon >=2 & fishnon <.

*Processed meat*
rename n_1349_0_0 meatprocess
replace meatprocess = . if meatprocess <0

gen meatprocess_score = .
replace meatprocess_score = 0 if meatprocess >1 & meatprocess <.
replace meatprocess_score = 1 if meatprocess <=1
//////// 0 = never, 1 = less than once a week, 2 = once a week//

*Unprocessed red meat*
rename n_1369_0_0 beef
replace beef = . if beef < 0
replace beef = 0 if beef == 1
replace beef = 1 if beef ==2
replace beef = 2 if beef >=3 & beef <.

rename n_1379_0_0 lamb
replace lamb = . if lamb < 0
replace lamb = 0 if lamb == 1
replace lamb = 1 if lamb ==2
replace lamb = 2 if lamb >=3 & lamb <.

rename n_1389_0_0 pork
replace pork = . if pork < 0
replace pork = 0 if pork == 1
replace pork = 1 if pork ==2
replace pork = 2 if pork >=3 & pork <.

gen meatunprocess = beef+lamb+pork
gen meatunprocess_score = .
replace  meatunprocess_score = 0 if meatunprocess >1.5 & meatunprocess <.
replace  meatunprocess_score = 1 if meatunprocess <=1.5
replace meatunprocess_score = 0 if beef >=2 & beef <.
replace meatunprocess_score = 0 if lamb >=2 & lamb <.
replace meatunprocess_score = 0 if pork >=2 & pork <.

*Carb*
rename n_1438_0_0 breadintake
replace breadintake = . if breadintake ==-1
replace breadintake = . if breadintake ==-3
replace breadintake = 0 if breadintake ==-10
replace breadintake = . if breadintake >47
//note: mean = 12.43; SD = 8.63//

rename n_1448_0_0 breadtype
replace breadtype = . if breadtype <0
//1 = white, 2 = brown, 3 = wholemeal, 4 = other//

rename n_1458_0_0 cerealintake
replace cerealintake = . if cerealintake ==-1
replace cerealintake = . if cerealintake ==-3
replace cerealintake = 0 if cerealintake ==-10
replace cerealintake = . if cerealintake >16
//note: mean = 4.55; SD = 2.81//

rename n_1468_0_0 cerealtype
replace cerealtype = . if cerealtype <0
//1 = bran, 2 = biscuit, 3 = oat, 4 = muesli, 5 = other//

*Carb per day*
gen wholebread = 0
replace wholebread = (breadintake/7) if breadtype==2
replace wholebread = (breadintake/7) if breadtype==3

gen whitebread = 0
replace whitebread = (breadintake/7) if breadtype==1
replace whitebread = (breadintake/7) if breadtype==4

gen wholecereal = 0
replace wholecereal = (cerealintake/7) if cerealtype >= 1 & cerealtype <=4

gen whitecereal = 0
replace whitecereal = (cerealintake/7) if cerealtype==5

gen wholegrain = wholebread+wholecereal
gen whitegrain = whitebread+whitecereal

gen wholegrain_score = .
replace wholegrain_score = 0 if wholegrain <3
replace wholegrain_score = 1 if wholegrain >=3 & wholegrain <.

gen whitegrain_score = .
replace whitegrain_score = 0 if whitegrain >1.5 & whitegrain <.
replace whitegrain_score = 1 if whitegrain <=1.5

*Diet score*

gen food_group_number = fruit_score + veg_score + fish_score + meatprocess_score + meatunprocess_score + wholegrain_score + whitegrain_score
//food_group_number is how many food groups they ate//

gen diet_score = .
replace diet_score = 0 if food_group_number >=5 & food_group_number <.
replace diet_score = 1 if food_group_number >=3 & food_group_number <=4
replace diet_score = 2 if food_group_number <=2

**Physical Activity**

rename n_884_0_0 PA_freq_mod
replace PA_freq_mod = . if PA_freq_mod <0
rename n_894_0_0 PA_duration_mod
replace PA_duration_mod = . if PA_duration_mod <0
replace PA_duration_mod = . if PA_duration_mod >376
//note: mean = 66.77; SD = 77.41//
rename n_904_0_0 PA_freq_vig
replace PA_freq_vig = . if PA_freq_vig <0
rename n_914_0_0 PA_duration_vig
replace PA_duration_vig = . if PA_duration_vig <0
replace PA_duration_vig = . if PA_duration_vig >236
//note: mean = 44.84; SD = 47.80//

gen PA_score = .
replace PA_score = 2 if PA_freq_mod == 0
replace PA_score = 1 if PA_freq_vig*PA_duration_vig >0 & PA_freq_vig*PA_duration_vig < 75
replace PA_score = 1 if PA_freq_mod*PA_duration_mod >0 & PA_freq_mod*PA_duration_mod <150
replace PA_score = 1 if PA_freq_mod >0 & PA_freq_mod <5
replace PA_score = 0 if PA_freq_vig*PA_duration_vig >= 75 & PA_freq_vig*PA_duration_vig <.
replace PA_score = 0 if PA_freq_mod*PA_duration_mod >= 150 & PA_freq_mod*PA_duration_mod <.
replace PA_score = 0 if PA_freq_vig >=1 & PA_freq_vig <.
replace PA_score = 0 if PA_freq_mod >=5 & PA_freq_mod <.

**Create Lifestyle Risk Score as continous variable and as tertiles**

gen LRS = smoke_score + sleep_score + lipid_score + bloodsugar_score + bp_score + bmi_score + diet_score + PA_score	

xtile PRS_tertile = PRS, nq(3)
label define PRS_tertile 1 "low" 2 "med" 3 "high"
label values PRS_tertile PRS_tertile

gen LRS_tertile = .
replace LRS_tertile = 1 if LRS >= 0 & LRS <6
replace LRS_tertile = 2 if LRS >= 6 & LRS <8
replace LRS_tertile = 3 if LRS >= 8 & LRS <.
label define LRS_tertile 1 "low" 2 "med" 3 "high"
label values LRS_tertile LRS_tertile

**Standardise LRS to allow comparison with PRS**

zscore LRS

**Create joint PRS-LRS tertiles**

gen PRS_LRS_tertile = .
replace PRS_LRS_tertile = 1 if PRS_tertile==1 & LRS_tertile==1
replace PRS_LRS_tertile = 2 if PRS_tertile==1 & LRS_tertile==2
replace PRS_LRS_tertile = 3 if PRS_tertile==1 & LRS_tertile==3
replace PRS_LRS_tertile = 4 if PRS_tertile==2 & LRS_tertile==1
replace PRS_LRS_tertile = 5 if PRS_tertile==2 & LRS_tertile==2
replace PRS_LRS_tertile = 6 if PRS_tertile==2 & LRS_tertile==3
replace PRS_LRS_tertile = 7 if PRS_tertile==3 & LRS_tertile==1
replace PRS_LRS_tertile = 8 if PRS_tertile==3 & LRS_tertile==2
replace PRS_LRS_tertile = 9 if PRS_tertile==3 & LRS_tertile==3


//////////////////////////////////////////////////////////////////////////
///////////////////////////////DESCRIPTIVES///////////////////////////////
//////////////////////////////////////////////////////////////////////////

sum PRS LRS age socioeco tv gm hippocampus logwmh child_bmi 
tab1 sex edu socio_strat drug_any_bpdrug_ni_bl drug_statin_ni_bl dm_anydmrx_ni_sr_bl e4_carrier

save "clean_data.dta", replace
