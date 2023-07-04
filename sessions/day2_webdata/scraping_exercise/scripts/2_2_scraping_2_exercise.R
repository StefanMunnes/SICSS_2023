# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
library(rvest)
library(httr)

# 0. Get selctor gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with four columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 

urls <- scan("/Users/maialodato/Desktop/Summer School 2023 /D1/SICSS_2023/sessions/day2_webdata/scraping_exercise/data/processed/practice_CNN_URLs.md", character(), quote = "")
urls

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget

web <- read_html("https://edition.cnn.com/2023/06/29/us/randy-cox-new-haven-police-officers-fired/index.html")    

# Title: 
title <- web %>% 
  html_node("#maincontent") %>% 
  html_text() 

# Authors: 
author <- web %>% 
  html_node(".byline__name") %>% 
  html_text()
author

# Date: 
date <- web %>% 
  html_node(".timestamp") %>% 
  html_text()
date

# Text: 
text <- web %>% 
  html_node(".paragraph") %>% 
  html_text()
text


# scrape one article


# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile






