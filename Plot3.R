##Load libraries
library(dplyr)
library(ggplot2)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Correct data classes
NEI <- NEI[,c(-2, -3)]

##Subset out Baltimore data
Balt <- subset(NEI, NEI$fips == 24510)

##Create tables for each year
Balt1 <- subset(Balt, type == "NON-ROAD")
Balt2 <- subset(Balt, type == "NONPOINT")
Balt3 <- subset(Balt, type == "ON-ROAD")
Balt4 <- subset(Balt, type == "POINT")

##Calculate total pollution for each type for each year
Pollution <- tapply(Balt1$Emissions, Balt1$year, sum, na.rm = TRUE)
Year <- unique(Balt1$year)
Total.Pollution <- as.data.frame(cbind(Pollution, Year))
Total.Pollution <- mutate(Total.Pollution, Type = "NON-ROAD")

Pollution <- tapply(Balt2$Emissions, Balt2$year, sum, na.rm = TRUE)
Year <- unique(Balt2$year)
Total.Pollution1 <- as.data.frame(cbind(Pollution, Year))
Total.Pollution1 <- mutate(Total.Pollution1, Type = "NONPOINT")

Pollution <- tapply(Balt3$Emissions, Balt3$year, sum, na.rm = TRUE)
Year <- unique(Balt3$year)
Total.Pollution2 <- as.data.frame(cbind(Pollution, Year))
Total.Pollution2 <- mutate(Total.Pollution2, Type = "ON-ROAD")

Pollution <- tapply(Balt4$Emissions, Balt4$year, sum, na.rm = TRUE)
Year <- unique(Balt4$year)
Total.Pollution3 <- as.data.frame(cbind(Pollution, Year))
Total.Pollution3 <- mutate(Total.Pollution3, Type = "POINT")

##Merge together datasets
Total.Pollution <- rbind(Total.Pollution, Total.Pollution1, Total.Pollution2, Total.Pollution3)

##Set data types
Total.Pollution$Type <- as.factor(Total.Pollution$Type)

##Plot
png("plot3.png", width = 700, height = 480)
with(Total.Pollution, ggplot(Total.Pollution, aes(Year, Pollution)) + geom_point(aes(color = Type)) + 
       facet_grid(. ~ Type) + ggtitle("Pollution By Type In Baltimore") + geom_smooth(method = "lm"))
dev.off()