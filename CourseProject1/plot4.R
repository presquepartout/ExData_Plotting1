## This script downloads raw energy consumption data, processes it,
## and creates a 2x2 array of four graphs about power consumption on
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

## Convert the bigPowerData$Date column to R Date format: 

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

## To make the plots appear in a 2x2 array, and 
## adjust margins and font size: 

par(mfrow= c(2,2), mar = c(4, 4, 3, 2), oma = c(2,0,2,0), ps = 12)

## Create Plot 4, a set of four graphs: 

with(trimPowerData, {
    plot(Time, Global_active_power, xlab="", ylab = "Global Active Power", type = "l")
    plot(Time, Voltage, xlab = "datetime", ylab = "Voltage", type = "l")
    {plot(Time, Sub_metering_1, xlab ="", ylab = "Energy sub metering", type = "l")
        lines(trimPowerData$Time, trimPowerData$Sub_metering_2
             , col = "red")
        lines(trimPowerData$Time, trimPowerData$Sub_metering_3
             , col = "blue")
        legend(x = "topright", legend = c("Sub_metering_1 "
                            , "Sub_metering_2 "
                            , "Sub_metering_3 ")
                            , y.intersp = 0.6
                            , inset = c(0.05, 0)
                            , cex = 0.8
                            , bty = "n"
                            , lty = c(1, 1, 1)
                            , col = c("black", "red", "blue"))
       }
    plot(Time, Global_reactive_power, xlab = "datetime", type = "l")
   })

## Copy plot to plot4.png file in local directory: 

dev.copy(png, file = "plot4.png", pointsize = 12)
dev.off()

## End of Plot 4. 



