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

*save tempfile of all variables
tempfile original
save "`original'", replace

*tsset the data
tsset groupid year
tsfill, full

*save tempfile of just year and groupid
keep groupid year 
tempfile idyear
save "`idyear'"

*save tempfile of just categorical data, one row for each groupid
use "`original'"
drop year value
bysort groupid: keep if _n==1
tempfile categorical
save "`categorical'", replace

* merge the year and value data to the categorical data
merge 1:m groupid using "`idyear'"

*check merge
tab _merge
assert _merge==3 //all merged correctly
drop _merge

*now add the values
merge 1:1 groupid year using "`original'"

*check merge
tab _merge
drop _merge

*interopolate missing years
bysort groupid: ipolate value year, gen(ivalue)

* EXTRAPOLATION CODE GOES HERE
* for now, just a flat value
* by groupid: replace ivalue = (ivalue[_n-1]) if missing(ivalue)==1

* linear trend based on last 5 year difference
* use the difference, and the last known difference becomes that for all years

* first generate an average of the past 5 years going forward and replace missing values
by groupid: gen avg_last_5_years = (ivalue[_n] - ivalue[_n-5])/5
by groupid: replace avg_last_5_years = avg_last_5_years[_n-1] if missing(avg_last_5_years)==1
by groupid: replace ivalue = (ivalue[_n-1] + avg_last_5_years[_n-1]) if missing(ivalue)==1

* then do the same for earlier years. This is done by sorting descending on year and 
* repeating the process
gsort +groupid -year
by groupid: replace avg_last_5_years = avg_last_5_years[_n-1] if missing(avg_last_5_years)==1
by groupid: replace ivalue = (ivalue[_n-1] - avg_last_5_years[_n-5]) if missing(ivalue)==1
by groupid: replace ivalue = (ivalue[_n-1]) if missing(ivalue)==1 | ivalue<0

*after that, if there are still missing values, just set them equal to the first and last known value
*this will make cases for which we have only one measure be the same for all years
gsort +groupid +year
by groupid: replace ivalue = ivalue[_n-1] if missing(ivalue)==1
gsort +groupid -year
by groupid: replace ivalue = ivalue[_n-1] if missing(ivalue)==1

*reshape the data from long to wide, so that each measure has it's own variable
drop period dataitem domain domaincategory value_raw measure value groupid avg_last_5_years
reshape wide ivalue, i(crop state chemical_type chemical_id year) j(measurefac)
rename ivalue1 lbs_applied
rename ivalue2 lbs_per_acre_app
rename ivalue3 lbs_per_acre_yr
rename ivalue4 num_apps
rename ivalue5 pct_area_treated


*save the interpolated and reshaped use data
sort crop state chemical_id year
outsheet using "data/chemical_use_ipol.csv", comma nolabel replace

*close the log
log close
