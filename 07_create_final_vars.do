* Creation of final analysis variables

* set working directory

* start log
log using weighted_tolerance.log, replace

* import data
use use "data/use_toxicity_merged.dta"
drop _merge

* fix mrl variable and destring
replace mrl =".05" if mrl == "0.05(N)"
replace mrl =".2" if mrl == "0.2(N)"
destring mrl, replace

* weighted toxicity variable creation (using our lbs/acre variable)
gen use_tox_weighted =  lbs_per_acre *  mrl

* compare to exististing lbs/acre/year variable
gen use_tox_weighted2 =   lbs_per_acre_yr *  mrl
