# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q3.Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen decreases 
# in emissions from 1999–2008 for Baltimore City? Which have seen increases 
# in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

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
Baltimore_by_year_type <-
  aggregate(Baltimore$Emissions, by=list(Baltimore$year, Baltimore$type), 
            FUN=sum, na.rm=TRUE)

colnames(Baltimore_by_year_type) <- c("year", "type", "Emissions")

png("plot3.png", width=600)
ggplot(data=Baltimore_by_year_type, 
  aes(x=year, y=Emissions, group=type, colour=type)) + geom_line() + 
  geom_point(size=3) + ylab("total emissions (tons)") + 
  ggtitle("Baltimore City PM2.5 Emissions by Source Type") 
dev.off()
