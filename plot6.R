##Load libraries
library(plyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Find Codes related to cars
carCodes <- SCC[grep(("Veh"), SCC$Short.Name),]

##Select coal related emissions for Baltimore and LA
car.Balt <- subset(NEI, SCC %in% carCodes$SCC & fips == "24510" )
pollution.Balt <- ddply(car.Balt, .(year), function(x) data.frame(Emissions = sum(x$Emissions)))
pollution.Balt$City <- as.factor(rep("Baltimore", nrow(pollution.Balt)))

car.LA <- subset(NEI, SCC %in% carCodes$SCC & fips == "06037" )
pollution.LA <- ddply(car.LA, .(year), function(x) data.frame(Emissions = sum(x$Emissions)))
pollution.LA$City <- as.factor(rep("Los Angeles", nrow(pollution.LA)))

#   ##Total emmissions for each year in Baltimore
#   Pollution <- tapply(Balt$Emissions, Balt$year, sum, na.rm = TRUE)
#   Year <- unique(Balt$year)
#   Total.Pollution <- as.data.frame(cbind(Pollution, Year))
#   Total.Pollution <- mutate(Total.Pollution, city = "Baltimore")
#   
#   ##Total emmissions for each year in LA
#   Pollution <- tapply(LA$Emissions, LA$year, sum, na.rm = TRUE)
#   Year <- unique(LA$year)
#   Total.Pollution1 <- as.data.frame(cbind(Pollution, Year))
#   Total.Pollution1 <- mutate(Total.Pollution1, city = "Los Angeles")

Total.Pollution <- rbind(pollution.Balt, pollution.LA)

##Plot
png("plot6.png", width = 480, height = 480)
with(Total.Pollution, plot(year, Emissions, type = "n"))
with(subset(Total.Pollution, City == "Baltimore"), lines(year, Emissions, col = "red"))
with(subset(Total.Pollution, City == "Los Angeles"), lines(year, Emissions, col = "blue"))
legend(x = "right", lty = 1,legend = c("Los Angeles", "Baltimore"), col = c("red", "blue"))
title(main = "Total Pollution From Motor Vehicles Over Time")
dev.off()
