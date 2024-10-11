**Standard settings**

version 18
clear all
macro drop _all
set more off
set maxvar 10000

**Set directory**

cap cd "Y:\PRS LRS Brain Health\Documents for Resubmission\Resubmission Do Files\"
cap cd "/home/rmgpstc/Scratch/UKB_CAD_PRS"

**Create Analysis Log**

use "ApoE Codes\2023_06_APOE_hardcalldoses_recoded.dta", clear

drop e4_carrier

gen e1_e4 = 0
replace e1_e4 = 1 if rs429358_hardcalldose=="CC" & rs7412_hardcalldose=="TC"

gen e1_e2 = 0
replace e1_e2 = 1 if rs429358_hardcalldose=="CT" & rs7412_hardcalldose=="TT"

gen e2_e4=0
replace e2_e4 = 1 if rs429358_hardcalldose=="CT" & rs7412_hardcalldose=="TC" // NB: in rare cases some of these could be e1_e3 coding rather than e2_e4 -- would need directly measured haplotypes from paired end or long read sequencing to clarify chromosomes of origin for each allele

gen e2_e2=0
replace e2_e2 = 1 if rs429358_hardcalldose=="TT" & rs7412_hardcalldose=="TT" 

gen e2_e3=0
replace e2_e3 = 1 if rs429358_hardcalldose=="TT" & rs7412_hardcalldose=="TC" 

gen e3_e3=0
replace e3_e3 = 1 if rs429358_hardcalldose=="TT" & rs7412_hardcalldose=="CC"

gen e3_e4=0
replace e3_e4 = 1 if rs429358_hardcalldose=="CT" & rs7412_hardcalldose=="CC"

gen e4_e4=0
replace e4_e4 = 1 if rs429358_hardcalldose=="CC" & rs7412_hardcalldose=="CC"

foreach var in e1_e4 e1_e2 e2_e4 e2_e2 e3_e3 e3_e4 e4_e4 e2_e3 {
tab `var'
}

gen apoe_genotype = 1 if e1_e4==1
replace apoe_genotype = 2 if e1_e2==1
replace apoe_genotype = 3 if e2_e2==1
replace apoe_genotype = 4 if e2_e3==1
replace apoe_genotype = 5 if e2_e4==1
replace apoe_genotype = 6 if e3_e3==1
replace apoe_genotype = 7 if e3_e4==1
replace apoe_genotype = 8 if e4_e4==1

label define apoe 1 "e1_e4" 2 "e1_e2" 3 "e2_e2" 4 "e2_e3" 5 "e2_e4" 6 "e3_e3" 7 "e3_e4" 8 "e4_e4"
label values apoe_genotype  apoe

               * Removal of individuals carrying presumed e1 genotypes if appropriate
drop if apoe_genotype<3

*e4 carriage:
gen e4_carrier = 0
replace e4_carrier = 1 if e4_e4==1
replace e4_carrier = 1 if e3_e4==1
replace e4_carrier = 1 if e2_e4==1

save "derived apoe genotypes", replace
