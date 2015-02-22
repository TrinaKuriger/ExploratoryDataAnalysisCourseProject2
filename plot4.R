# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q4.Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

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

#SCC names are factors, return as characters to match variables in NEI
emissions_from_coal <-  
    as.character(SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE),1])

#extract rows if NEI$SCC value  matches one of the valuess in emissions_from_coal
NEI_coal <- NEI[(NEI$SCC %in% emissions_from_coal),]

coal_emmision_by_year <- 
  aggregate(NEI_coal$Emissions, by=list(NEI_coal$year), FUN=sum, na.rm=TRUE)
colnames(coal_emmision_by_year) <- c("year", "Emissions")   

#add a column that shows thousands of tons to use in plot
coal_emmision_by_year <- mutate(coal_emmision_by_year, Emissions_kTon= 
                                coal_emmision_by_year$Emission / 10^3)

png("plot4.png")
plot(coal_emmision_by_year$year, coal_emmision_by_year$Emissions_kTon, 
     xlab = "year", ylab = "total emissions (x 1000 tons)", type="b",
     main = "Coal Related PM2.5 Emissions from 1999 to 2008", 
     xlim = c(1998, 2009))
dev.off()