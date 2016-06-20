##Load libraries
library(dplyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Find Codes related to cars
carCodes <- SCC[grep(("Veh"), SCC$Short.Name),]

##Select Coal related emissions
car <- subset(NEI, NEI$SCC %in% carCodes$SCC)

##Subset out Baltimore data
Balt <- subset(car, car$fips == "24510")

##Total emmissions for each year
Pollution <- tapply(Balt$Emissions, Balt$year, sum, na.rm = TRUE)
Year <- unique(Balt$year)
Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot5.png", width = 480, height = 480)
with(Total.Pollution, plot(Year, Pollution))
lines(Total.Pollution$Year, Total.Pollution$Pollution)
title(main = "Total Pollution From Motor Vehicles In Baltimore Over Time")
dev.off()