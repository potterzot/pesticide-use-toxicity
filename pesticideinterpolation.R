## Before importing to R, The "Value" column (T) was converted in Excel from Generic to Numeric
mydata <- read.csv("cotton_corn_soybean_pesticide_use.csv")

## Create a dataframe that contains Year, State, Commodity, Variable, Pesticide, and Value
mysub <- mydata[, c(2, 6, 16, 17, 19, 20)]

## Convert the "Value column from factor to numeric
mysub$Value <- suppressWarnings(as.numeric(levels(mysub$Value))[mysub$Value])

## Remove any rows that do not have complete data
mysub <- mysub[complete.cases(mysub),]

## Test code that will be replaced by a loop through the factors
mysub.1 <- mysub[mysub$State == "ALABAMA", ]
mysub.1 <- mysub.1[mysub.1$Domain.Category == "CHEMICAL, HERBICIDE: (GLYPHOSATE = 417300)",]
mysub.1 <- mysub.1[mysub.1$Data.Item == "COTTON, UPLAND - APPLICATIONS, MEASURED IN LB",]

## Interpolate the data
a <- approx(mysub.1$Year, mysub.1$Value, n=9)

## Test code to visualize the interpolation
plot(a$x, a$y)
