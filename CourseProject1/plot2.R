## This script downloads raw energy consumption data, processes it,
## and creates a graph of Global Active Power vs. Time for the dates
## February 1 and 2, 2007. 

## Make sure that the data source file, "household_power_consumption.txt" is
## in the working directory. If it is not, download and unzip it from the internet.

if(!file.exists("household_power_consumption.txt")) {
      fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileUrl, destfile = "./power.zip", method = "curl")
      unzip("./power.zip")
      if(!file.exists("household_power_consumption.txt")) {
           message("source data can't be downloaded")
}


## Create a class vector that contains the column classes. 
## If we don't specify the column classes, R will read the first two
## columns as factors instead of characters, which takes more memory. 

classVector <- c(rep("character", 2), rep("numeric", 7))

## Read the .txt file into a data frame called bigPowerData.
## Note: NA values in the .txt file are represented by "?"
## Note: .txt file fields are separated by ";"

bigPowerData <- read.table("household_power_consumption.txt"
                           , header = TRUE
                           , sep = ";"
                           , na.strings = "?"
                           , colClasses = classVector)

## Convert the bigPowerData$Date column to R Date format
## to enable subsetting for required dates: 

bigPowerData$Date <- as.Date(bigPowerData$Date, "%d/%m/%Y")

## Select the rows for dates 2007-02-01 and 2007-02-02: 

trimPowerData <- bigPowerData[bigPowerData$Date > "2007-01-31" 
                              & bigPowerData$Date < "2007-02-03", ]

## Convert the Time column format to POSIXlt (for graphing).
## First paste the Date and Time columns to make sure strptime()
## takes in the correct year. 

pastedTime <- paste(trimPowerData$Date, trimPowerData$Time)
convertedTime <- strptime(pastedTime, format = "%Y-%m-%d %H:%M:%S")
trimPowerData$Time <- convertedTime

## To make the proportions of the graph look like the given example,
## adjust margins and font size: 

par(mar = c(3, 5, 2, 2))
par(ps = 12)

## Create Plot 2, a graph of Global_active_power vs. Time. 
## This is a line graph so type = "l" (as opposed to scatterplot).

plot(trimPowerData$Time, trimPowerData$Global_active_power
     , xlab = ""
     , ylab = "Global Active Power (kilowatts)"
     , type = "l")

## Copy plot to plot2.png file in local directory: 

dev.copy(png, file = "plot2.png")
dev.off()

## End of Plot 2. 

