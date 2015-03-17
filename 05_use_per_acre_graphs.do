*set working directory

*set log file
log using "use_graphs.log", replace

* Set working directory (REPLACE THIS WITH YOUR DIRECTORY)
cd "I:\nick\code\pesticide-use-toxicity\"

*import data
use "data/use_acres_merged.dta"

*fix spaces
replace chemical_type=trim(chemical_type)
replace  crop=trim(crop)

*collapse by chemical type
collapse (sum) lbs_per_acre, by(year state crop chemical_type)

*graphs:

*US Fertilizer by crop
twoway (line lbs_per_acre year if chemical_type == "FERTILIZER" & crop == "SOYBEANS", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FERTILIZER" & crop == "CORN", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FERTILIZER" & crop == "COTTON", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FERTILIZER" & crop == "COTTON, UPLAND", lwidth(medthick)) if state == "UNITED STATES", ytitle(Lbs Applied Per Acre) xtitle(Year) title(Fertilizer Use Per Acre) subtitle(United States) legend(order(1 "Soybeans" 2 "Corn" 3 "Cotton" 4 "Upland Cotton"))
*US Pesticides by crop
twoway (line lbs_per_acre year if chemical_type == "HERBICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "INSECTICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "SOYBEANS", ytitle(Lbs Applied Per Acre) xtitle(Year) title(US Pesticide Use Per Acre) subtitle(Soybeans) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line lbs_per_acre year if chemical_type == "HERBICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "INSECTICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "CORN", ytitle(Lbs Applied Per Acre) xtitle(Year) title(US Pesticide Use Per Acre) subtitle(Corn) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line lbs_per_acre year if chemical_type == "HERBICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "INSECTICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "COTTON", ytitle(Lbs Applied Per Acre) xtitle(Year) title(US Pesticide Use Per Acre) subtitle(Cotton) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line lbs_per_acre year if chemical_type == "HERBICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "INSECTICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "COTTON, UPLAND", ytitle(Lbs Applied Per Acre) xtitle(Year) title(US Pesticide Use Per Acre) subtitle(Upland Cotton) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))

*Re-collapse for totals
collapse (sum) lbs_per_acre, by(year state chemical_type)

*US Fertilizer Total
twoway (line lbs_per_acre year if chemical_type == "FERTILIZER", lwidth(medthick)) if state == "UNITED STATES", ytitle(Lbs Applied Per Acre) xtitle(Year) title(Fertilizer Use Per Acre) subtitle(United States)

*US Pesticides Total
twoway (line lbs_per_acre year if chemical_type == "HERBICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "FUNGICIDE", lwidth(medthick)) (line lbs_per_acre year if chemical_type == "INSECTICIDE", lwidth(medthick)) if state == "UNITED STATES", ytitle(Lbs Applied Per Acre) xtitle(Year) title(Pesticide Use Per Acre) subtitle(United States) legend(order(1 "Herbicides" 2 "Fungicides" 3 "Insecticides"))

log close
