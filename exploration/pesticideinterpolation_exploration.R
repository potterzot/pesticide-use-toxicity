# Interpolation of missing years
#
# Steps:
# 1. Set up settings and parameters
# 2. Import the data
# 3. Clean and prep data
# 4. Interpolate missing years
# 5. Save interpolated data 
#  
#
# GENERAL GOOD CODING PRACTICES
# 1. Have a section to update the settings
# 2. General analysis scripts follow this outline:
#   a. set settings
#   b. import data
#   c. clean/process data
#   d. analysis
#   e. output the results
# 3. Leave comments.
#   a. comments on their own line dilineate sections, describe in detail, etc...
#   b. comments on the same line as code are short explanations of what it does
# 4. Try to follow the DRY principal: Don't Repeat Yourself
#   a. If you need to do something multiple times, write a function to do it.
#   b. This makes it easier to change/fix something because you only have to do it in one place instead of 10.
#   c. However, place more emphasis on getting it working than on not repeating yourself. You can always rewrite later.
# 5. Start with a subsample of your data to make sure your code is working

#############
# 1. Settings
setwd("~/code/pesticide-use-toxicity") #set the working directory

#libraries
library(stringi) #for easier string processing


#############
# 2. Import data

# Before importing to R, The "Value" column (T) was converted in Excel from Generic to Numeric
use <- read.csv("data/cotton_corn_soybean_pesticide_use.csv", stringsAsFactors=FALSE)

## Data indexing. The first is the row, the second is the column. Omitting a number will print all rows or columns. For example:
head(use,5) #prints the first 5 lines
use[0,] # prints the column/variable names
use[,1] # prints all the data in the first row
use[2,2] # prints the value at the second row and second column

###################
# 3. Clean and Prep

test <- use[1:100,] # just a subset for exploration

## Create some new variables. The "Domain.Category" variable could be split into name and id number
# Of course, we don't know if htese will work across all data since we're just testing on a subset, so we'll have to check once we code the full 90k rows.
# Pesticide ID
test$pesticide.id <- sub(".* = (.*))", "\\1", test$Domain.Category) #get id number
for (x in 3:5) {
  test <- within(test, pesticide.id[stri_length(pesticide.id)==x] <- paste0(rep("0",6-x),pesticide.id[stri_length(pesticide.id)==x]))
}
test <- within(test, pesticide.id[stri_length(pesticide.id)>6] <- "000000") #replace totals to be 000000

# Pesticide Name
test$pesticide.name <- sub(".*: \\((.*) = .*" , "\\1", test$Domain.Category) #parse the name

# Pesticide Type
test$pesticide.type <- sub("CHEMICAL, (.*): .*" , "\\1", test$Domain.Category, perl=TRUE)

# Variable name
test$variable <- sub(".* - (.*), .*" , "\\1", test$Data.Item, perl=TRUE)

## Now create a real subset of the data variables
vars <- c("Commodity", "State", "Year", "pesticide.name", "pesticide.id", "pesticide.type", "variable", "Value") #define vector of variables to keep
mysub <- test[, vars] #create a sample of just 100 rows and the variables we want

## Convert the "Value column from factor to numeric
mysub$Value <- suppressWarnings(as.numeric(levels(use2$Value))[use2$Value])

## Remove any rows that do not have complete data
mysub <- mysub[complete.cases(mysub),]

## Test code that will be replaced by a loop through the factors
#mysub.1 <- mysub[mysub$State == "ALABAMA", ]
mysub.1 <- mysub[mysub$pesticide.name == "DIMETHOATE",]
mysub.1 <- mysub.1[mysub.1$Commodity == "CORN",]

## Interpolate the data
a <- approx(mysub.1$Year, mysub.1$Value, n=9)

## Test code to visualize the interpolation
plot(a$x, a$y)
