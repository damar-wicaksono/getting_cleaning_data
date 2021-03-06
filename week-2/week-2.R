#
# Getting and Cleaning Data
# Week - 2
# Lectures
#
# set working directory
setwd(paste(getwd(), "./week-2", sep=""))

#
# MySQL
#
library(RMySQL)
m<-dbDriver("MySQL");
con <- dbConnect(MySQL(), user='genome', 
                 host='genome-mysql.cse.ucsc.edu');

#
# HDF5 Format
# Hierarchical Data Format, optimize reading/writing from disk in R
#

# Installed through bioconductor
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

# Load the library and create an example file
library(rhdf5)
created <- h5createFile("./example.h5")
created

# Create groups
created <- h5createGroup("example.h5", "foo")
created <- h5createGroup("example.h5", "baa")
created <- h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5") # List the groups within the file

# Write into the groups (add 2 more groups)
A <- matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
B <- array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

# Write a data set
df <- data.frame(1L:5L, seq(0, 1, length=5), c("ab", "cde", "fghi", "a", "s"),
                 stringsAsFactors=FALSE)
h5write(df, "example.h5", "df")
h5ls("example.h5")

# Reading data
readA <- h5read("example.h5", "foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readC <- h5read("example.h5", "df")
readA; readB; readC

# Writing and reading chunks
set.seed(1412)
a <- sample(seq(1:100), 3)
h5read("example.h5", "foo/A")
h5write(a, "example.h5", "foo/A", index=list(1:3, 1))
h5read("example.h5", "foo/A")

#
# Reading data from the web
# APIs and Authentication
# Webscrapping: Programatically extracting data from the HTML code of websites
#

# Getting data, open connection
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
html_code <- readLines(con)
close(con)
html_code # A long vector of characters

# Parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue) # the title of the webpage
xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue) # the number of citations

# Get data from httr package
library(httr)
html2 <- GET(url)
content2 <- content(html2, as="text")
parsed_html <- htmlParse(html2, asText=T) # required a response class not string
xpathSApply(parsed_html, "//title", xmlValue)

# Accessing websites with passwords
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
           authenticate("user", "passwd")
           )
pg2
names(pg2)

# Using handles
google <- handle("http://google.com")
pg1 <- GET(handle=google, path="/")
pg1
pg2 <- GET(handle=google, path="search")
pg2

#
# Reading data from APIs (Application Programming Interfaces)
#

#
# Reading from Other Sources (There is an R package for that!)
#
