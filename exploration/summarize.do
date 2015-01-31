********************
* Example Do file for loading data, generating summary statistics, etc...
*
* Steps:
* 1. Set Options
* 2. Load Data
* 3. Interpolate Data (TODO)
* 4. Transform data
* 4. plots

**********************
* 1. Set Options

* Clear everything
clear

* don't require tab/space to go to next lines
set more off

* set RAM to use. 1GB here. Default is small (256mb?)
set mem 1g

* set number of characters per line for log print outs
set linesize 255

* Set working directory
cd "I:\nick\code\pesticide-use-toxicity\"

* set a file to log results and code to
log using "exploration\summarize.log", replace


***************
* 2. Load data

insheet using "data\cleaned_data.csv"
save "data\cleaned_data.dta", replace

* sort
sort commodity state pesticidename variable year

* Replace missing state with "United States"
replace state = "United States" if missing(state)==1

* Convert value to a numeric variable
destring value, gen(v) ignore(,) force

**************
* 3. Interpolate data

***first, we need to add years that weren't surveyed
* Generate a group id for the variables that comprise each group
egen groupid = group(commodity state pesticidename pesticidetype variable)

* tsset the data. This makes stata treat this as a group of time series values
tsset groupid year

* create new years
tsfill, full

* interpolate the values
ipolate v year, gen(ivalue)

* Collapse to create sums for each year by pesticide type
collapse (sum) v, by(commodity state pesticidetype year variable)








* close the log
log close







