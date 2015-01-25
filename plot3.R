
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 
# for Baltimore City? Which have seen increases in emissions from 1999-2008?

NEI <- readRDS("summarySCC_PM25.rds")

library(ggplot2)
library(dplyr)                                   # use dplyr library
NEI <- tbl_df(NEI)                               # convert to dplyr data frame

data <- filter(NEI, fips == "24510")             # get only Baltimore data
data <- group_by(data, year, type)               # group the data by year and type

data <- summarize(data, Emissions = sum(Emissions)) # sum the emissions values
data$year <- as.character(data$year)                # convert year values to characters

png("plot3.png", width=640, height=480)          # set the PNG device for plotting

g <- ggplot(data, aes(year, Emissions, group = 1)) +
        geom_bar(stat = "identity", fill = "lightskyblue", color="darkgray") +
        geom_smooth(method = "lm", alpha = 0) +
        facet_grid(~ type) +
        labs(x = "Year", y = "Total Emissions (tons)") + 
        labs(title = "Total PM2.5 Emissions in Baltimore City, Maryland") +
        coord_cartesian(ylim = c(0, 2250))

print(g)

dev.off()                                        # close the png device

#rm(list=ls())
