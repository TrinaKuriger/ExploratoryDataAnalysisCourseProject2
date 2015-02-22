# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q1.Have total emissions from PM2.5 decreased in the United States from 1999  
# to 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

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

#group the data by year and take the sum for each year
total_emmision_by_year <-aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum, 
                                   na.rm=TRUE)
colnames(total_emmision_by_year) <- c("year", "Emissions")

# divide totals by 10^6 to get values that display well on graph, add as new col
total_emmision_by_year <- mutate(total_emmision_by_year, Emission_by_MTon = 
                                   total_emmision_by_year$Emission / 10^6)

png("plot1.png")
plot(total_emmision_by_year$year, total_emmision_by_year$Emission_by_MTon, 
     xlab = "year", ylab = "total emissions (x million tons)", type="b",
     main = "PM2.5 Emissions from 1999 to 2008", xlim = c(1998, 2009))
dev.off()