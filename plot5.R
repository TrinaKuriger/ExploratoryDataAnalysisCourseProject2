# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q5.How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?

# To run the code for these plots, please have the following packages installed:
#   dplyr
# ggplot2
# 
# And put these files in the working directory:
#   Source_Classification_Code.rds
# summarySCC_PM25.rds
# 
# These files can be downloaded from 
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

#Read in data if it has not already been read to the environment
if (!exists("SCC"))  SCC <- readRDS("Source_Classification_Code.rds")
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")

emissions_from_vehicle <- 
  as.character(SCC[grepl("highway veh", SCC$Short.Name, ignore.case = TRUE),1])

NEI_vehicle <- NEI[(NEI$SCC %in% emissions_from_vehicle),]

Baltimore_vehicle <- NEI_vehicle[NEI_vehicle$fips == "24510",]

Baltimore_vehicle_by_year <-  
  aggregate(Baltimore_vehicle$Emissions, by=list(Baltimore_vehicle$year), 
            FUN=sum, na.rm=TRUE)

colnames(Baltimore_vehicle_by_year) <- c("year", "Emissions")   

png("plot5.png")
plot(Baltimore_vehicle_by_year$year, Baltimore_vehicle_by_year$Emissions, 
     xlab = "year", ylab = "total emissions (tons)", type="b",
     main ="Vehicle Related PM2.5 Emissions in Baltimore City  1999 - 2008", 
     xlim = c(1998, 2009))
dev.off()