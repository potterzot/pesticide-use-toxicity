# Interpolation of missing years
#
# Steps:
# 1. Set up settings and parameters
# 2. Import the data
# 3. Clean and prep data
# 4. Interpolate missing years
# 5. Save interpolated data 
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

#Libraries
library(stringi) #for easier string processing

#############
# 2. Import data

# Before importing to R, The "Value" column (T) was converted in Excel from Generic to Numeric
use <- read.csv("data/cotton_corn_soybean_pesticide_use.csv", stringsAsFactors=FALSE)


###################
# 3. Clean and Prep

## Define a function to parse text and create some new variables
clean <- function(data) {
  # Pesticide ID
  data$pesticide.id <- sub(".* = (.*))", "\\1", data$Domain.Category) #get id number
  for (x in 3:5) {
    data <- within(data, pesticide.id[stri_length(pesticide.id)==x] <- paste0(rep("0",6-x),pesticide.id[stri_length(pesticide.id)==x]))
  }
  data <- within(data, pesticide.id[stri_length(pesticide.id)>6] <- "000000") #replace totals to be 000000
  
  # Pesticide Name
  data$pesticide.name <- sub(".*: \\((.*) = .*" , "\\1", data$Domain.Category) #parse the name
  
  # Pesticide Type
  data$pesticide.type <- sub("CHEMICAL, (.*): .*" , "\\1", data$Domain.Category, perl=TRUE)
  
  # Variable name
  data$variable <- sub(".* - (.*), .*" , "\\1", data$Data.Item, perl=TRUE)
    
  # Convert the "Value column from factor to numeric
  data$Value2 <- as.numeric(data$Value)
  
  return(data)
}

data.cleaned <- clean(use)

## Now save just the variables we want to the data set
vars <- c("Commodity", "State", "Year", "pesticide.name", "pesticide.id", "pesticide.type", "variable", "Value", "Value2") #define vector of variables to keep

data.draft <- data.cleaned[, vars] #processed data with just the rows that we want
#data.final <- data.draft[complete.cases(data.draft),] #only valid cases
data.final <- data.draft #for now, include missing in the cleaned data.

## Save out the final data before interpolation to csv
write.csv(data.final, file="data/cleaned_data.csv")

##############################
# 4. Interpolate Missing Years





###################################
# 5. Save out interpolated data set






