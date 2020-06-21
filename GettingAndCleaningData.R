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
library("readxl")


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
download.file(fileUrl, destfile = "./data/dat.xlsx")
dateDownloaded <- date()
dateDownloaded
list.files("./data")


# Put data into a data frame or data table if very large, then look at the data 
read_excel("C:/Users/paulr/Documents/R/GettingAndCleaningData/data/dat.xlsx", sheet = 1, col_names = TRUE, col_types = NULL, na = "", skip = 0)


survey <- data.frame(read.csv("./data/dat", header = TRUE))
str(survey)
glimpse(survey)
head(survey)
tail(survey)
