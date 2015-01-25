
# 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

NEI <- readRDS("summarySCC_PM25.rds")

library("dplyr")                                 # use dplyr library
NEI <- tbl_df(NEI)                               # convert to dplyr data frame

data <- group_by(NEI, year)                      # group the data by year
                                                 # sum the emissions values and divide
                                                 # by 1 million for easier visual
data <- summarize(data, emissions = sum(Emissions)/1000000)

png("plot1.png", width=480, height=480)          # set the PNG device for plotting

barplot(data$emissions,
        names.arg = data$year, 
        main = "Total PM2.5 Emissions in the United States", 
        xlab = "Year", 
        ylab = "Total Emissions (in million tons)",
        col = "lightskyblue"
)

dev.off()                                        # close the png device

# rm(list=ls())
