*set working directory
* cd "E:\Documents\Internship Stuff\Pesticide and Residue Project\pesticide-use-toxicity"
cd "I:\nick\code\pesticide-use-toxicity\"

* don't require tab/space to go to next lines
set more off

* set RAM to use. 1GB here. Default is small (256mb?)
set mem 1g

* set number of characters per line for log print outs
set linesize 255

* clear data
clear all

*set log
log using toxicity_use_merge.log, replace

*import data
insheet using "data\tolerances.csv"

*manipulate data
rename v1 crop_orig
rename v2 chemical_name
rename v3 mrl
drop if crop_orig == "crop"
gen match_crop = ""
replace match_crop = "SOYBEANS" if crop_orig== "soybean"
replace match_crop = "SOYBEANS" if crop_orig== "Soybean"
replace match_crop = "SOYBEANS" if crop_orig== "Soybeans"
replace match_crop = "SOYBEANS" if crop_orig== "Soybean, seed"
replace match_crop = "SOYBEANS" if crop_orig== "Soybean, dry"
replace match_crop = "SOYBEANS" if crop_orig== "Soybean, (dry or succulent)"
replace match_crop = "SOYBEANS" if crop_orig== "Soybean, (dry and succulent)"
replace match_crop = "COTTON" if crop_orig== "Cotton"
replace match_crop = "CORN" if crop_orig== "Corn"
replace match_crop = "CORN" if crop_orig== "Corn, grain"
drop if  match_crop == ""
sort crop_orig chemical_name
replace chemical_name = upper(chemical_name)
replace match_crop = upper(match_crop)
rename match_crop crop

*remove duplicates
egen groupid = group(crop chemical_name)
sort groupid
drop in 118
drop in 94
drop in 87
drop in 84
drop in 78
tempfile toxicity
save "`toxicity'", replace

*import use data
clear
use "data/use_acres_merged.dta"

* replace cotton name
replace crop="COTTON" if crop=="COTTON, UPLAND"

*merge
merge m:1 crop chemical_name using "`toxicity'"

*keep the matches
keep if _merge==3

* save the data
save "data/use_toxicity_merged.dta", replace

log close

