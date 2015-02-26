
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
insheet using "data/all_corn_soybean_cotton_pest_use.csv"

*fixes
replace state = "United States" if missing(state)==1
destring value, gen(v) ignore(,) force

*sort and generate groupid
sort commodity state chemical variable year
egen groupid = group(commodity state chemical chemicaltype restricted variable)

*duplicates by groupid?
duplicates report groupid year

*tsset the data
tsset groupid year
tsfill, full

*save tempfile
tempfile original
save "`original'", replace

*save tempfile of just values
keep groupid year value v
tempfile valuedata
save "`valuedata'"

*save tempfile of just categorical data, one row for each groupid
use "`original'"
drop year value v
bysort groupid: keep if _n==1
tempfile categorical
save "`categorical'", replace

* merge the year and value data to the categorical data
merge 1:m groupid using "`valuedata'"


*check merge
tab _merge
assert _merge==3 //all merged correctly

*interopolate missing years
*by variable: ipolate value year, gen(ivalue2)















log close
