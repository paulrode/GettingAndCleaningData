# Getting and Cleaning Data

# Week 1, question 1
# Downloading Files 
# File to retreve from the internet: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# Package for tidyverse 
library("tidyverse")
library("lubridate")
# Package for building tables in markdown and notebook 
library("knitr")
library("kableExtra")
# Package for forecasting
library("fpp2")
# Packages for reading excel and html files and XML
library("openxlsx")
library("XML")
# Parkage for using data tables for very large data operations
library("data.table")
#Package for reading fixed width tables
library("utils")
# Packages for reading data through API's 
library("httr")
library("jsonlite")
# Package for performing inquires with SQL databases 
library("sqldf")


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
# Question 1 
# https://github.com/paulrode/httr/blob/master/demo/oauth2-github.r location of demo 
# which i forked into my Git Repo listing for API access and question 1
# https://github.com/settings/applications/1323008 my registered API app
# Client ID:  e61cdf7b1bfa1692a861
# Client Secret: 51d4844467e47d72dc8e3dc3dea3a05ded011618

#Set up the app
myapp = oauth_app("github", 
                  key="e61cdf7b1bfa1692a861", secret= "51d4844467e47d72dc8e3dc3dea3a05ded011618")
sig = sign_oauth1.0(myapp)
reg <- GET("https://api.github.com/users/jtleek/repos", sig)

#Use the app to get a json page from which to bring into a data frame 
json1 = content(reg)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[ , c(3 == "datasharing",47)]
json2 %>% filter(name == "datasharing") %>% select(name, created_at)


# Question 2
# The sqldf package allows for execution of SQL commands on R data 
# frames. We will use the sqldf package to practice the queries we 
# might send with the dbSendQuery command in RMySQL.
# Download Download the American Community Survey data and load it 
# into an R object called acs. https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()
# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")}
# Get file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/Fss06pid.csv")
dateDownloaded <- date()
acs <- read.csv("./data/Fss06pid.csv")
glimpse(acs)
str(sqldf("select pwgtp1 from acs where AGEP<50"))

# Question 3
# Which of the following commands will select only the data for the probability weights pwgtp1 with 
# ages less than 50?
unique(acs$AGEP)
glimpse(unique(acs$AGEP))
sqldf("select AGEP where unique from acs") #no
sqldf("select unique AGEP from ACS") #no
sqldf("select distinct AGEP from acs") # answer
sqldf("select distinct pwgtp1 from acs") #no


# Question 4 Webscraping 
# Which of the following commands will select only the data for 
# the probability weights pwgtp1 with ages less than 50?
# http://biostat.jhsph.edu/~jleek/contact.html

# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()
# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")}
# Get Page
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
htmlCode
nchar(htmlCode[c(10, 20, 30, 100)])


#Question 5 
# Read this data set into R and report the sum of the numbers in 
# the fourth of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# (Hint this is a fixed width file format)

# Set proper working Dir
if (!getwd() == "C:/Users/paulr/Documents/R/GettingAndCleaningData") {setwd("./GettingAndCleaningData")}
getwd()
# Check for data directory and if one is not present then make it
if (!file.exists("data")) {
  dir.create("data")}
# Get Page
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(fileUrl, destfile = "./data/Fwksst8110.for")
dateDownloaded <- date()
#Use the read.table() funciton
# con <- read.table("./data/Fwksst8110.for", skip = 4, header = TRUE)
con <- read.fwf("./data/Fwksst8110.for", widths = c(-1, 9, -5, 4,-1,3, -5, 4,-1,3, -5, 4,-1,3, -5, 4,-1,3), col.names = c("week", "col1", "col2", "col3", "col4", "col5", "col6", "col7","col8"), strip.white = TRUE, skip = 4)
con
sum(as.numeric(con$col3))