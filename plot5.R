##Load libraries
library(plyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Find Codes related to cars
carCodes <- SCC[grep(("Veh"), SCC$Short.Name),]

##Select Coal related emissions in Baltimore
car.Balt <- subset(NEI, SCC %in% carCodes$SCC & fips == "24510")

##Total emmissions for each year
Total.Pollution <- ddply(car.Balt, .(year), function(x) data.frame(Emissions = sum(x$Emissions)))

#   Pollution <- tapply(Balt$Emissions, Balt$year, sum, na.rm = TRUE)
#   Year <- unique(Balt$year)
#   Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot5.png", width = 480, height = 480)
with(Total.Pollution, plot(year, Emissions))
lines(Total.Pollution$year, Total.Pollution$Emissions)
title(main = "Total Pollution From Motor Vehicles In Baltimore Over Time")
dev.off()