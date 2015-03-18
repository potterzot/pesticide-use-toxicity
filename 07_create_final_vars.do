* Creation of final analysis variables

*set working directory
cd "E:\Documents\Internship Stuff\Pesticide and Residue Project\pesticide-use-toxicity"

*start log
log using weighted_tolerance.log, replace

*import data
use "data/use_toxicity_merged.dta"
drop _merge

*fix mrl variable and destring
replace mrl =".05" if mrl == "0.05(N)"
replace mrl =".2" if mrl == "0.2(N)"
destring mrl, replace

*weighted toxicity variable creation (using our lbs/acre variable)
gen use_tox_weighted =  lbs_per_acre *  mrl

*compare to exististing lbs/acre/year variable
gen use_tox_weighted2 =   lbs_per_acre_yr *  mrl

*lbs per treated acre vaiable
gen lbs_per_treated_acre = lbs_applied/ (acres *  (pct_area_treated/100))

*lbs per treated acre weighted by mrl
gen treated_tox_weight =  lbs_per_treated_acre *  mrl
