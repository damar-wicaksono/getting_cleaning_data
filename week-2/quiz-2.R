#
# Getting and Cleaning Data
# Week - 2
# Quiz
#

#
# Question 1
# Register an application with Github API
# Access the API to get information
# Use the data to find the time that datasharing repo was created
#

# Load Library
library(httr)
library(jsonlite)

# 1. Find OAuth settings for Github
oauth_endpoints("github")

# 2. Register an application
my_app <- oauth_app("github", key="a8403d65b4d8456666fd", 
                    secret="1c8067956985d47624fd70b495936c803937e643")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), my_app)


# 4. Use the API
gtoken <- config(token=github_token) # Get token
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
a <- content(req)
b <- jsonlite::fromJSON(toJSON(a)) # convert to JSON object

# Datasharing repo is element number 5 on the list
b$url[[5]]
created_at <- b$created_at[[5]]

#
# Question 2
# The `sqldf` packagae allows for execution of SQL commands on R dataframe.
# Download the American Community Survey data and load into an R object
# Select only the data for the probability weights `pwgtp1` with ages less than 
# 50

# Download data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
filename <- "acs.csv"
download.file(url=url, destfile=filename)
date_download <- Sys.Date()

# Open Data
acs <- read.csv("acs.csv")

# Load sqldf package
library("sqldf")
head(warpbreaks)
sqldf("select pwgtp1 from acs where AGEP < 50")

#
# Question 3
# Using the same dataframe you created in the previous problem, what is the 
# equivalent function to unique(acs$AGEP)?
#

q3_a <- unique(acs$AGEP)
q3_b <- sqldf("select distinct AGEP from acs")

# sqldf returns a dataframe
identical(q3_a, q3_b[,1]) # They are identical

#
# Question 4
# How Many characters are in the 10th, 20th, 30th, and 100th lines of HTML 
# from this page:
# http://biostat.jhsph.edu/~jleek/contact.html
#

# Load the data
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
html <- readLines(con)
close(con)

nchar(html[10])  # 45
nchar(html[20])  # 31
nchar(html[30])  # 7
nchar(html[100]) # 25

#
# Question 5
# Read this data set into R and report the sum of the numbers in the fourth of 
# the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# The data is fixed width format
#

# Download the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
filename <- "noaa.for"
download.file(url, filename)
date_download_noaa <- Sys.Date()

# Load the data
noaa <- read.fwf(filename, width=c(15, 4, 9, 4, 9, 4, 9, 4, 9), skip = 4)
head(noaa)

# Sum of the numbers in the fourth of 9 columns
sum(noaa[,4])
