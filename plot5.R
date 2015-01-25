
# 5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)                                   # use dplyr library
NEI <- tbl_df(NEI)                               # convert to dplyr data frame
SCC <- tbl_df(SCC)
                                                 # get all SCC types that are Motor Vehicles (both Onroad and Nonroad)
scc <- filter(SCC, grepl("Onroad|Nonroad", SCC$Data.Category, ignore.case=TRUE))
scc <- scc$SCC                                   # remove all other columns in the df
scc <- as.character(scc)                         # convert to a character vector

data <- filter(NEI, fips == "24510")             # use only Baltimore data
                                                 # filter based on the character vector
data <- filter(data, grepl(paste(scc, collapse="|"), data$SCC))

data <- group_by(data, year)                     # group the data by year

data <- summarize(data, emissions = sum(Emissions)) # sum the emissions values
data$year <- as.character(data$year)                # convert year values to characters

png("plot5.png", width=480, height=480)          # set the PNG device for plotting

g <- ggplot(data, aes(year, emissions, group = 1)) +
        geom_bar(stat = "identity", fill = "lightskyblue", color = "darkgray") +
        geom_smooth(method = "lm", alpha = 0) +
        labs(x = "Year", y = "Total Emissions (tons)") + 
        labs(title = "Total PM2.5 Motor Vehicle Emissions in Baltimore City, MD") +
        coord_cartesian(ylim = c(0, 430))

print(g)

dev.off()                                        # close the png device

# rm(list=ls())
