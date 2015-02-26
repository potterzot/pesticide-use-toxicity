*******************
* 03_interpolate_chemical_use.do
* Cleans the raw chemical use data and saves to a csv file the new variables
*******************

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
log using "interpolation.log", replace

*load the data
insheet using "data/chemical_use_clean.csv"

*sort and generate groupid
sort crop state chemical_name measure year
egen groupid = group(crop state chemical_name chemical_type measure)

*duplicates by groupid?
duplicates report groupid year

*tsset the data
tsset groupid year
tsfill, full

*save tempfile
tempfile original
save "`original'", replace

*save tempfile of just values
keep groupid year value
tempfile valuedata
save "`valuedata'"

*save tempfile of just categorical data, one row for each groupid
use "`original'"
drop year value
bysort groupid: keep if _n==1
tempfile categorical
save "`categorical'", replace

* merge the year and value data to the categorical data
merge 1:m groupid using "`valuedata'"

*check merge
tab _merge
assert _merge==3 //all merged correctly
drop _merge

*interopolate missing years
bysort groupid: ipolate value year, gen(ivalue)

*save the interpolated use data
outsheet using "data/chemical_use_ipol.csv", comma nolabel replace


*close the log
log close
