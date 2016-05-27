library(dplyr)
library(lubridate)
library(foreign)

setwd("~/read.dbc")

# This sample dataset is based on the U.S. National Oceanic and Atmospheric Administration’s (NOAA) storm database.
if( !file.exists("file/StormData.csv.bz2") ) {
        download.file(url = "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",
                      destfile = "file/StormData.csv.bz2")
}

storm <- read.csv("files/StormData.csv.bz2")

# Subset the first 100 rows
s <- storm[1:100,]

# Create a date column
s <- cbind(s, BEGIN_DATE = sapply(strsplit(as.character(st3$BGN_DATE), split = " "), function(x) x[1]))

# Select and transform columns for the sample dataset
s2<- tbl_df(s) %>%
        select(BEGIN_DATE, COUNTYNAME, STATE, EVTYPE, INJURIES, FATALITIES) %>%
        mutate(BEGIN_DATE = mdy(BEGIN_DATE))

# Write as a .dbf file
write.dbf(as.data.frame(s2), "files/storm.dbf")

# Note: as of today, the compression to .dbc must be made with an external tool
# It's planned for the next release to implement the write.dbc and dbf2dbc function calls
