* Analysis of data

* set working directory
cd "E:\Documents\Internship Stuff\Pesticide and Residue Project\pesticide-use-toxicity"

* start log
log using weighted_tolerance_analysis.log, replace

* import data
use "data/use_toxicity_merged.dta"
drop _merge

* fix mrl variable and destring
replace mrl =".05" if mrl == "0.05(N)"
replace mrl =".2" if mrl == "0.2(N)"
destring mrl, replace

* weighted toxicity variable creation (using our lbs/acre variable)
gen use_tox_weighted =  lbs_per_acre *  mrl

* compare to exististing lbs/acre/year variable
gen use_tox_weighted2 =   lbs_per_acre_yr *  mrl

* analysis
collapse (sum) use_tox_weighted, by(year state crop chemical_type)
* graphs
twoway (line use_tox_weighted year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "SOYBEANS", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Soybeans) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line use_tox_weighted year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "CORN", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Corn) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line use_tox_weighted year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "COTTON", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Cotton) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))

* compare with existing use per acre variable
clear
use "data/use_toxicity_merged.dta"
drop _merge
replace mrl =".05" if mrl == "0.05(N)"
replace mrl =".2" if mrl == "0.2(N)"
destring mrl, replace
gen use_tox_weighted2 =   lbs_per_acre_yr *  mrl
collapse (sum) use_tox_weighted2, by(year state crop chemical_type)

twoway (line use_tox_weighted2 year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "SOYBEANS", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Soybeans) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line use_tox_weighted2 year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "CORN", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Corn) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))
twoway (line use_tox_weighted2 year if chemical_type == " HERBICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " INSECTICIDE", lwidth(medthick)) (line use_tox_weighted2 year if chemical_type == " FUNGICIDE", lwidth(medthick)) if state == "UNITED STATES" & crop == "COTTON", ytitle(Lbs Applied Per Acre x MRL) xtitle(Year) title(US Pesticide Use Per Acre Weighted by Toxicity) subtitle(Cotton) legend(order(1 "Herbicide" 2 "Insecticide" 3 "Fungicide"))

close log

