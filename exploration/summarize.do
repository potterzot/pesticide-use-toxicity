********************
* Example Do file for loading data, generating summary statistics, etc...
*
* Steps:
* 1. Set Options
* 2. Load Data
* 3. Generate summary tables
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

**************
* 3. Summarize data












* close the log
log close







