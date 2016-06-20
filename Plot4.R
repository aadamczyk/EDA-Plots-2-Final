##Load libraries
library(dplyr)
library(ggplot2)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Find Codes related to coal cumbustion
coalCodes <- SCC[grep(("Coal"), SCC$Short.Name),]

##Select Coal related emissions
coal <- subset(NEI, NEI$SCC %in% coalCodes$SCC)

##Total emmissions for each year
Pollution <- tapply(coal$Emissions, coal$year, sum, na.rm = TRUE)
Year <- unique(coal$year)
Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot4.png", width = 480, height = 480)
with(Total.Pollution, plot(Year, Pollution))
lines(Total.Pollution$Year, Total.Pollution$Pollution)
title(main = "Total National Pollution from Coal Over Time")
dev.off()