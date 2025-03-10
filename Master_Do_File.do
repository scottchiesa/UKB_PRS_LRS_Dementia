***************************************************************************
********************UKB CAD PRS LRS AND DEMENTIA***************************
************Authors: Sittichokkananon, Garfield, and Chiesa****************
*********************************2025**************************************
***************************************************************************

***************************************************************************
***************************Full Paper Analysis*****************************
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


///////////////////////////////////////////////////////////////////////////
///////////////////Run Do Files for Each Aspect of Analysis////////////////
///////////////////////////////////////////////////////////////////////////

**Data Cleaning**

do "Data_Cleaning_and_Preparation.do"

**Complete Case Analysis**

do "Complete_Case_Analysis.do"

**Imputing Data**

do "Imputing_Missing_Values.do"

**Creating Derived Variables in Imputed Dataset**

do "Deriving_Variables_in_Imputed_Dataset.do"

**Running Imputed PRS Analysis**

do "PRS_Competing_Risks_Analysis.do"

**Running Imputed LRS Analysis**

do "LRS_Competing_Risks_Analysis.do"

**Running Imputed PRS and LRS Combination Analysis**

do "PRS_LRS_Competing_Risks_Analysis.do"

**Neuroimaging Analysis**

do "Full_Neuroimaging_Analysis.do"
