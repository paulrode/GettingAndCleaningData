# Getting and Cleaning Data

# Week 1, question 1
# Downloading Files 
# File to retreve from the internet: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# Load my standard package set
library("tidyverse")
library("lubridate")
library("knitr")
library("kableExtra")
library("fpp2")
library("openxlsx")
library("XML")
library("data.table")


# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()

# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")
}

# Download data using a URL into th data directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/AmericanConsumer")
dateDownloaded <- date()
dateDownloaded
list.files("./data")

# Put data into a data frame or data table if very large, then look at the data 
survey <- data.frame(read.csv("./data/AmericanConsumer", header = TRUE))
str(survey)
glimpse(survey)
head(survey)
tail(survey)


# Question 1 
# Subset or filter data frame for getting anssers
nrow(survey[,37 > 1])
nrow(subset(survey, VAL == 24))
nrow(survey[which(survey$VAL == 24),])
nrow(filter(survey, VAL == 24))


# Question 2
# Identify if feacher is tidy
# Per data dictonary FES is: Family type and employment status. 
# Answer is there being 2 observations concatenate in this feacher. 
survey$FES


# Question 3
# Read excel file https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx into a variable names dat
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./data/gov_NGAP.xlsx")
dateDownloaded <- date()

# Put data into a data frame or data table if very large, then look at the data 
rowIndex <- 18:23
colIndex <- 7:15
dat <- read.xlsx("C:/Users/paulr/Documents/R/GettingAndCleaningData/data/gov_NGAP.xlsx", 
                 sheet = 1, cols = colIndex, rows = rowIndex)
sum(dat$Zip*dat$Ext,na.rm=T)


#Question 4
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()

# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")
}

# Get file 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(fileUrl, destfile = "./data/Frestaurants.xml")
dateDownloaded <- date()
doc <- xmlTreeParse("./data/Frestaurants.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)
codes <- (xpathSApply(rootNode, "//zipcode", xmlValue))
names <- (xpathSApply(rootNode, "//name", xmlValue))
answer <- data.frame("names" = names, "zipcode" = codes)
glimpse(answer)
nrow(answer[codes == 21231,])


# Question 5
# download https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv store in DT
# get average of $pwgtp15
# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()

# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/Fss06pid.csv")
dateDownloaded <- date()
DT <- fread("./data/Fss06pid.csv")
start <- Sys.time()
rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
finish <- Sys.time()
finish - start 

start <- Sys.time()
mean(DT$pwgtp15, by=DT$SEX)
finish <- Sys.time()
finish - start 

start <- Sys.time()
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
finish <- Sys.time()
finish - start 

start <- Sys.time()
sapply(split(DT$pwgtp15, DT$SEX), mean)
finish <- Sys.time()
finish - start 

start <- Sys.time()
tapply(DT$pwgtp15, DT$SEX, mean)
finish <- Sys.time()
finish - start 

start <- Sys.time()
DT[,mean(pwgtp15), by=SEX]
finish <- Sys.time()
finish - start 



# Week 2
# https://github.com/paulrode/httr/blob/master/demo/oauth2-github.r location of demo which i forked into my Git Repo listing for API access and question 1