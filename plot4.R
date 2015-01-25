
# 4. Across the United States, how have emissions from coal combustion-related sources
#    changed from 1999-2008?

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
library(dplyr)                                   # use dplyr library
NEI <- tbl_df(NEI)                               # convert to dplyr data frame
SCC <- tbl_df(SCC)
                                                 # get all SCC types that are "Coal"
scc <- filter(SCC, grepl("coal", SCC$EI.Sector, ignore.case=TRUE))
scc <- scc$SCC                                   # remove all other columns in the df
scc <- as.character(scc)                         # convert to a character vector

                                                 # filter based on the character vector
                                                 # warning: this will take a while
data <- filter(NEI, grepl(paste(scc, collapse="|"), NEI$SCC))

data <- group_by(data, year)                     # group the data by year
                                                 # sum the emissions values and divide
                                                 # by 1 thousand for easier visual
data <- summarize(data, emissions = sum(Emissions)/1000)
data$year <- as.character(data$year)             # convert year values to characters

png("plot4.png", width=480, height=480)          # set the PNG device for plotting

g <- ggplot(data, aes(year, emissions, group = 1)) +
        geom_bar(stat = "identity", fill = "lightskyblue", color="darkgray") +
        geom_smooth(method = "lm", alpha = 0) +
        labs(x = "Year", y = "Total Emissions (in thousand tons)") + 
        labs(title = "Total PM2.5 Coal Emissions in the United States") +
        coord_cartesian(ylim = c(0, 700))

print(g)

dev.off()                                        # close the png device

# rm(list=ls())
