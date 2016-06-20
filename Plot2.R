##Load libraries
library(dplyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Subset out Baltimore data
Balt <- subset(NEI, NEI$fips == 24510)

##Total emmissions for each year
Pollution <- tapply(Balt$Emissions, Balt$year, sum, na.rm = TRUE)
Year <- unique(Balt$year)
Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot2.png", width = 480, height = 480)
with(Total.Pollution, plot(Year, Pollution))
lines(Total.Pollution$Year, Total.Pollution$Pollution)
title(main = "Total Pollution In Baltimore Over Time")
dev.off()