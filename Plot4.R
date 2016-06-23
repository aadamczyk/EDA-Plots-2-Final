##Load libraries
library(dplyr)
library(ggplot2)
library(plyr)

## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Find Codes related to coal cumbustion
coalCodes <- SCC[grep(("Coal"), SCC$Short.Name),]

##Select Coal related emissions
coal <- subset(NEI, NEI$SCC %in% coalCodes$SCC)

##Total emmissions for each year
Total.Pollution <- ddply(coal, .(year), function(x) data.frame(Emissions = sum(x$Emissions)))

#   Pollution <- tapply(coal$Emissions, coal$year, sum, na.rm = TRUE)
#   Year <- unique(coal$year)
#   Total.Pollution <- as.data.frame(cbind(Pollution, Year))

##Plot
png("plot4.png", width = 480, height = 480)

qplot(year, Emissions, data = Total.Pollution, geom = "line")  + 
  ggtitle("Coal Combustion PM2.5 emission by Year") + 
  ylab("PM2.5 emission (tons)") + 
  xlab("Year")

#   with(Total.Pollution, plot(year, Emissions), type = "l")
#   lines(Total.Pollution$year, Total.Pollution$Emissions)
#   title(main = "Total National Pollution from Coal Over Time")

dev.off()