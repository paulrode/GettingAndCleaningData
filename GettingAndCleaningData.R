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
setwd("./GettingAndCleaningData")
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

# Look at the data 
AmericanConsumer <- data.frame("./data/AmericanConsumer")
glimpse("./data/AmericanConsumer")



setwd("./data")
getwd()
list.files()
glimpse("AmericanConsumer")
class("AmericanConsumer")
