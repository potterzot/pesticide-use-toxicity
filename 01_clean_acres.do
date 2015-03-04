*******************
* 01_clean_acres.do
* Cleans the raw acres data and saves to a csv file the new variables
*******************

* Clear everything
clear

* don't require tab/space to go to next lines
set more off

* set RAM to use. 1GB here. Default is small (256mb?)
set mem 1g

* set number of characters per line for log print outs
set linesize 255

* Set working directory (CHANGE THIS TO YOUR WORKING DIRECTORY)
cd "I:\nick\code\pesticide-use-toxicity\"

* set a file to log results and code to
log using "01_clean_acres.log", replace

*load the data
insheet using "data/acres_raw.csv"

*keep only the variables we want
keep year period geolevel state stateansi commodity dataitem domain domaincategory value

*keep only full year observations
keep if period == "YEAR"

*state ansi is a 2 digit code
replace state="UNITED STATES" if state=="US TOTAL"
replace stateansi=0 if state=="UNITED STATES"
tostring(stateansi), replace
gen ansi = "0"+stateansi
drop stateansi
rename ansi stateansi

*create a full crop name to distinguish between cotton and cotton, upland
*also create a full measure name
split dataitem, parse(-) gen(var)
rename var1 crop
rename var2 measure

*convert the value to a number
rename value value_raw
destring value_raw, gen(acres) ignore(,) force


*save the data as a csv file
outsheet using "data/acres_clean.csv", comma nolabel replace

log close

