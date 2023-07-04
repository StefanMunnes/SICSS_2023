# Nicole

# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
library(rvest)
library(httr)

# 0. Get selctor gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with five columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 

#https://www.cnn.com/2023/06/29/us/randy-cox-new-haven-police-officers-fired/index.html

setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()
urls <- scan("practice_CNN_URLs.md", character(), quote = "")

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
# Title: #maincontent
# Authors: .byline__name
# Date: .timestamp
# Text: .related-content--article:nth-child(19) .related-content__headline-text , .paragraph

# scrape one article
firsturl<-urls[[1]]

first_read <- read_html(firsturl)


# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile


