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

##Subset LA data
LA <- subset(car, car$fips == "06037")

##Total emmissions for each year in Baltimore
Pollution <- tapply(Balt$Emissions, Balt$year, sum, na.rm = TRUE)
Year <- unique(Balt$year)
Total.Pollution <- as.data.frame(cbind(Pollution, Year))
Total.Pollution <- mutate(Total.Pollution, city = "Baltimore")

##Total emmissions for each year in LA
Pollution <- tapply(LA$Emissions, LA$year, sum, na.rm = TRUE)
Year <- unique(LA$year)
Total.Pollution1 <- as.data.frame(cbind(Pollution, Year))
Total.Pollution1 <- mutate(Total.Pollution1, city = "Los Angeles")
Total.Pollution <- rbind(Total.Pollution, Total.Pollution1)

##Plot
png("plot6.png", width = 480, height = 480)
with(Total.Pollution, plot(Year, Pollution, type = "n"))
with(subset(Total.Pollution, city == "Baltimore"), lines(Year, Pollution, col = "red"))
with(subset(Total.Pollution, city == "Los Angeles"), lines(Year, Pollution, col = "blue"))
legend(x = "topright", lty = 1,legend = c("Baltimore", "Los Angeles"), col = c("red", "blue""))
title(main = "Total Pollution From Motor Vehicles Over Time")
dev.off()