
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?

NEI <- readRDS("summarySCC_PM25.rds")

library("dplyr")                                 # use dplyr library
NEI <- tbl_df(NEI)                               # convert to dplyr data frame

data <- filter(NEI, fips == "24510")             # get only Baltimore data
data <- group_by(data, year)                     # group the data by year
                                                 # sum the emissions values and divide
                                                 # by 1 thousand for easier visual
data <- summarize(data, emissions = sum(Emissions)/1000)

png("plot2.png", width=480, height=480)          # set the PNG device for plotting

barplot(data$emissions, 
        names.arg = data$year, 
        main = "Total PM2.5 Emissions in Baltimore City, Maryland", 
        xlab = "Year", 
        ylab = "Total Emissions (in thousand tons)",
        col = "lightskyblue"
)

dev.off()                                        # close the png device

rm(list=ls())
