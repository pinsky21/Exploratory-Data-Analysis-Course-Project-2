
# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from 
#    motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city 
#    has seen greater changes over time in motor vehicle emissions?

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)                                    # use dplyr library
NEI <- tbl_df(NEI)                                # convert to dplyr data frame
SCC <- tbl_df(SCC)
                                                  # get all SCC types that are Motor Vehicles (both Onroad and Nonroad)
scc <- filter(SCC, grepl("Onroad|Nonroad", SCC$Data.Category, ignore.case=TRUE))
scc <- scc$SCC 
scc <- as.character(scc)

bc <- filter(NEI, fips == "24510")                # get Baltimore City data
bc <- filter(bc, grepl(paste(scc, collapse="|"), bc$SCC)) 
bc <- group_by(bc, year)
bc <- summarize(bc, emissions = sum(Emissions))
bc$year <- as.character(bc$year)

lac <- filter(NEI, fips == "06037")               # get Los Angeles County data
lac <- filter(lac, grepl(paste(scc, collapse="|"), lac$SCC))
lac <- group_by(lac, year)
lac <- summarize(lac, emissions = sum(Emissions))
lac$year <- as.character(lac$year)

bc <- cbind(bc, city = "Baltimore City")          # add city variable
lac <- cbind(lac, city = "Los Angeles County")
data <- rbind(bc, lac)                            # combine data from both cities

png("plot6.png", width=640, height=480)

g <- ggplot(data, aes(year, emissions, group = 1)) +
        geom_bar(stat = "identity", fill = "lightskyblue", color = "darkgray") +
        facet_grid(~ city) +
        geom_smooth(method = "lm", alpha = 0) +
        labs(x = "Year", y = "Total Emissions (tons)") + 
        labs(title = "Compare Total PM2.5 Motor Vehicle Emissions by County") +
        coord_cartesian(ylim = c(0, 9900))

print(g)

dev.off()

# rm(list=ls())
