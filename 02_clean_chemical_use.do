*******************
* 02_clean_chemical_use.do
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

* Set working directory (CHANGE THIS TO YOUR WORKING DIRECTORY)
cd "I:\nick\code\pesticide-use-toxicity\"

* set a file to log results and code to
log using "01_clean_chemical_use.log", replace

*load the data
insheet using "data/chemical_use_raw.csv"

*keep only the variables we want
keep year period geolevel state stateansi commodity dataitem domain domaincategory value

*fix state if missing
replace state = "United States" if missing(state)==1

*convert value to numbers
rename value value_raw
destring value_raw, gen(value) ignore(,) force

*set missing value codes
replace value = .d if value_raw==" (D)"
replace value = .n if value_raw==" (NA)"
replace value = .d if value_raw==" (Z)"

*create a full crop name to distinguish between cotton and cotton, upland
split dataitem, parse(-) gen(var)
rename var1 crop

*create a measure stripped of extra text
split var2, parse(,) gen(m)
rename m1 measure

*create a chemical_type variable
split domain, parse(, ) gen(t)
rename t1 chemical_type
replace chemical_type = t2 if chemical_type=="CHEMICAL"

*create a chemical_name
split domaincategory, parse(: ) gen(a)
split a2, parse( = ) gen(b)
replace b1 = trim(b1)
gen chemical_name = substr(b1,2,.) if chemical_type!="FERTILIZER"
replace chemical_name = substr(b1,2,length(b1)-1) if chemical_type=="FERTILIZER"
replace chemical_name = "TOTAL" if b1=="(TOTAL)"

*create a chemical id variable
replace b2 = trim(b2)
gen chemical_id = substr(b2,1,length(b2)-1)
replace chemical_id = substr(chemical_name,1,3) if chemical_type=="FERTILIZER" | chemical_name=="TOTAL"

*drop temporary variables
drop var2 m2 t2 a1 a2 b1 b2



*save the data as a csv file
outsheet using "data/chemical_use_clean.csv", comma nolabel replace

log close

