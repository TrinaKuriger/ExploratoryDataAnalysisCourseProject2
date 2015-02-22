# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q2.Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

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


Baltimore <- NEI[NEI$fips == "24510",]
Baltimore_total_emmision_by_year <-aggregate(Baltimore$Emissions, 
                                             by=list(Baltimore$year), FUN=sum, na.rm=TRUE)

colnames(Baltimore_total_emmision_by_year) <- c("year", "Emissions")

Baltimore_total_emmision_by_year <- mutate(Baltimore_total_emmision_by_year, 
                                           Emission_by_kTon = Baltimore_total_emmision_by_year$Emission / 10^3)

png("plot2.png")
plot(Baltimore_total_emmision_by_year$year, 
     Baltimore_total_emmision_by_year$Emission_by_kTon, 
     xlab = "year", ylab = "total emissions (x thousand tons)", type="b",
     main = "Baltimore City PM2.5 Emissions from 1999 to 2008", 
     xlim = c(1998, 2009))
dev.off()
