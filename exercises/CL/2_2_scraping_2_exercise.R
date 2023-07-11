# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise

library(tidyverse)
library(rvest)

# 0. Get selector gadget: https://selectorgadget.com/
# 1. Scrape the title, author, date and body of one of the articles provided in the
#     URL file!
# 2. Build a loop to scrape all articles in the provided URL document!

# NOTE: The result should be a dataframe with five columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 
urls <- scan("../../sessions/day2_webdata/scraping_exercise/data/processed/practice_CNN_URLs.md", character(), quote = "")

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
# Title: #maincontent
# Authors: .byline__name
# Date: .timestamp
# Text: .paragraph

# scrape one article

website <- read_html(urls[[1]])

one_article <- tibble(
  title = website %>%
    html_node("#maincontent") %>%
    html_text(),
  
  authors = website %>%
    html_nodes(".byline__name") %>%
    html_text() %>%
    paste(collapse = ";"),
  
  timestamp = website %>%
    html_nodes(".timestamp") %>%
    html_text(),
  
  body = website %>%
    html_nodes(".paragraph") %>%
    html_text() %>%
    paste(collapse = ";"))



# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile



# Run loop over these URLs
# With lapply
all_articles <- lapply(urls, function(url) {
  
  Sys.sleep(runif(1)+1)
  
  message(url)
  
  website <- read_html(url)
  
  article <- tibble(
    title = website %>%
      html_node("#maincontent") %>%
      html_text(),
    
    authors = website %>%
      html_nodes(".byline__name") %>%
      html_text() %>%
      paste(collapse = ";"),
    
    timestamp = website %>%
      html_nodes(".timestamp") %>%
      html_text(),
    
    body = website %>%
      html_nodes(".paragraph") %>%
      html_text() %>%
      paste(collapse = ""),
    
    url = url
  )
  
  return(article)
})

all_articles <- data.table::rbindlist(all_articles, fill = TRUE) 

#setdiff(urls, all_articles$url)


