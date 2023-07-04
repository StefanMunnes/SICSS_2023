# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
library(rvest)

# 0. Get selctor gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with four columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 

urls <- scan("../data/processed/practice_CNN_URLs.md", character(), quote = "")

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
# Title: 
# Authors: 
# Date: 
# Text: 

# scrape one article



# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile






