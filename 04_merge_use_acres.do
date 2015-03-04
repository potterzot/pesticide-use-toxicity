***********************
* 04_merge_use_acres.do
* Matches each row of use with the acres for that crop-state-year
***********************

* Clear everything
clear

* don't require tab/space to go to next lines
set more off

* set RAM to use. 1GB here. Default is small (256mb?)
set mem 1g

* set number of characters per line for log print outs
set linesize 255

* Set working directory (REPLACE THIS WITH YOUR DIRECTORY)
cd "I:\nick\code\pesticide-use-toxicity\"

* set a file to log results and code to
log using "interpolation.log", replace

* load the chemical use data and save to a tempfile
insheet using "data/chemical_use_ipol.csv"
keep state year crop ivalue measure chemical_name chemical_type chemical_id
*keep if measure=="APPLICATIONS"
*drop measure
rename ivalue appl_lbs
tempfile chemical_use
save "`chemical_use'", replace

* load the acres data
clear
insheet using "data/acres_clean.csv"
keep year crop state acres

* merge the year and value data to the categorical data
merge 1:m crop state year using "`chemical_use'"

*check merge
tab _merge
keep if _merge!=1
drop _merge

*generate lbs per acre
gen lbs_per_acre = appl_lbs / acres

*save the data
sort crop state year chemical_name
save "data/use_acres_merged.dta", replace

*close log
log close
