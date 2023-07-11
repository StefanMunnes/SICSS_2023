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
# Text: .paragraph

# scrape one article

first_read <- read_html(urls[[1]])

url_data <- tibble(
  title = first_read %>%
    html_node("#maincontent") %>%
    html_text(), #extract text (instead of a table or something else)
  
  authors = first_read %>%
    html_nodes(".byline__name") %>%
    html_text() %>%
    paste(collapse = ";"), # separate each author with a semi-colon if there are several authors  
  
  timestamp = first_read %>%
    html_nodes(".timestamp") %>%
    html_text(),
  
  body = first_read %>%
    html_nodes(".paragraph") %>%
    html_text() %>%
    paste(collapse = ""), # no line breaks and paragraphs
  
  url = urls[[1]]
  )


# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile


articles <- lapply(urls, function(url) {
  
  Sys.sleep(runif(1)+1)
  
  message(url) # prints current url
  
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

articles <- data.table::rbindlist(articles, fill = TRUE) # combines the lists into a single tibble
saveRDS(articles, file = "CNN.Rds")

# check which URLs are not (we only extract 189 and not 200)
# 
urls_new <- articles$url

non_duplicates <- urls[!urls %in% urls_new]
print(non_duplicates)
