##Load libraries
library(dplyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Total emmissions for each year
Total.Pollution <- by(NEI$Emissions, NEI$year, sum)

##Original solution
#   Pollution <- tapply(NEI$Emissions, NEI$year, sum, na.rm = TRUE)
#   Year <- unique(NEI$year)
#   Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot1.png", width = 480, height = 480)
with(Total.Pollution, plot(Year, Pollution))
lines(Total.Pollution$Year, Total.Pollution$Pollution)
title(main = "Total National Pollution Over Time")
dev.off()
