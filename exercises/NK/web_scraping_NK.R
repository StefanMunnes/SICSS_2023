# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
library(rvest)

# 0. Get selctor gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with five columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 

urls <- scan(file ="~/Library/CloudStorage/OneDrive-HertieSchool/SICSS_2023_WZB/SICSS_2023/sessions/day2_webdata/scraping_exercise/data/processed/practice_CNN_URLs.md",
             character(),
             quote = "")

urls[1]

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
# Title: #maincontent
# Authors: .byline__name
# Date: .timestamp
# Text: .article__content

# scrape one article
url <- read_html(urls[1])

title <- url %>% 
  html_element("h1") %>% 
  html_text()

author <- url %>% 
  html_element(".byline__name")%>% 
  html_text()

date <- url %>% 
  html_element(".timestamp")%>% 
  html_text()

text <- url %>% 
  html_element(".paragraph")%>% 
  html_text()

library(tibble)
data <- tibble() 

new_row <- tibble(title = title,
                      author = author,
                      date = date,
                      text = text,
                      stringsAsFactors = FALSE)
# Print the dataframe
print(new_row)


# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile

library(rvest)
library(dplyr)

# Create an empty dataframe
data <- tibble(title = character(),
                   author = character(),
                   date = character(),
                   text = character(),
                   stringsAsFactors = FALSE)

# Loop through the URLs and scrape information
for (i in 1:length(urls)) {
  url <- read_html(urls[i])
  
  title <- url %>% 
    html_element("h1") %>% 
    html_text()
  
  author <- url %>% 
    html_element(".byline__name") %>% 
    html_text()
  
  date <- url %>% 
    html_element(".timestamp") %>% 
    html_text()
  
  text <- url %>% 
    html_element(".paragraph") %>% 
    html_text()
  
  # Create a new row with the scraped information
  new_row <- tibble(title = title,
                        author = author,
                        date = date,
                        text = text,
                        stringsAsFactors = FALSE)
  
  # Add the new row to the dataframe
  data <- rbind(data, new_row)
}

# Print the resulting dataframe
print(data)

