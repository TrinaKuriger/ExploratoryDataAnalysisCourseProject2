# jkuriger
# Exploratory Data Analysis 
# Course Project 2
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot. For each plot you 
# should construct the plot and save it to a PNG file. 
# Q6.Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time in motor 
# vehicle emissions?

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

#find SCC codes related to vehicles (convert to chr for compatability with NEI)
emissions_from_vehicle <- 
  as.character(SCC[grepl("highway veh", SCC$Short.Name, ignore.case = TRUE),1])

#use SCC codes to extract related values from NEI
NEI_vehicle <- NEI[(NEI$SCC %in% emissions_from_vehicle),]

#create two separate data frames for Baltimore and LA
Baltimore_vehicle <- NEI_vehicle[(NEI_vehicle$fips == "24510"),]
LA_vehicle <- NEI_vehicle[(NEI_vehicle$fips == "06037"),]

#get sum of Baltimore and LA data frames for each year
Baltimore_vehicle_by_year <-
  aggregate(Baltimore_vehicle$Emissions, by=list(Baltimore_vehicle$year), 
            FUN=sum, na.rm=TRUE)
colnames(Baltimore_vehicle_by_year) <- c("year", "Emissions")

LA_vehicle_by_year <-
  aggregate(LA_vehicle$Emissions, 
            by=list(LA_vehicle$year), FUN=sum, na.rm=TRUE)
colnames(LA_vehicle_by_year) <- c("year", "Emissions")

#create normalization constant so that the value of 1999 is equal to 1
Baltimore_normalize <- 
  Baltimore_vehicle_by_year[Baltimore_vehicle_by_year$year=="1999",2] 
LA_normalize <- LA_vehicle_by_year[LA_vehicle_by_year$year=="1999",2] 

#add a new normalized column to each _by_year data frame
Baltimore_vehicle_by_year <- 
  mutate(Baltimore_vehicle_by_year, Normalized_Emission = 
           Baltimore_vehicle_by_year$Emission / Baltimore_normalize)

LA_vehicle_by_year <- 
  mutate(LA_vehicle_by_year, Normalized_Emission = 
           LA_vehicle_by_year$Emission / LA_normalize)

#add a column to each _by_year dataframe that specifies city
LA_vehicle_by_year$city <- "LA"
Baltimore_vehicle_by_year$city <- "Baltimore"

#combine Baltimore and LA data into one data frame
combined_data <- rbind(Baltimore_vehicle_by_year, LA_vehicle_by_year)

png("plot6.png",  width = 600)
ggplot(data=combined_data, 
       aes(x=year, y=Normalized_Emission, group=city, colour=city)) + 
  geom_line() + geom_point(size=3) + 
  ylab("total emissions (normalized to 1999 value)") + 
  ggtitle("PM2.5 Vehicle Emissions from 1999 to 2008") 
dev.off()
