# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise Solution

library(tidyverse)
library(rvest)


urls <- scan("../data/processed/practice_CNN_URLs.md", character(), quote = "")

# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

url <- urls[[5]]

# Find css selectors with SelectorGadget
# Title: #maincontent
# Authors: .byline__name   (Achtung: can be multiple names!)
# Date: .timestamp
# Text: .paragraph

# scrape one article
### step by step
website <- read_html(urls[5])

title <- website %>%
  html_node("#maincontent") %>%
  html_text()

authors <- website %>%
  html_nodes(".byline__name") %>%
  html_text() %>%
  paste(collapse = ";")

timestamp <- website %>%
  html_nodes(".timestamp") %>%
  html_text()

body <- website %>%
  html_nodes(".paragraph") %>%
  html_text() %>%
  paste(collapse = "")

url = urls[[5]]

df <- tibble(title, authors, timestamp, body, url)

# in one step (into df right away)
website <- read_html(urls[5])

df <- tibble(
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
  
  url = urls[[5]]
)


# Task 2 -----------------------------------------------------------------
# Build a loop/function to scrape all of the URLs from step 2

# Load the previously saved URLs
urls <- scan("../data/processed/practice_CNN_URLs.md", character(), quote = "")

# Run loop over these URLs
# With lapply
articles <- lapply(urls, function(url) {

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

articles <- data.table::rbindlist(articles, fill = TRUE) 
saveRDS(articles, file = "../data/processed/CNN.Rds")

# Loop alternative
articles <- data.frame()
count <- 1
for (url in urls) {
  
  Sys.sleep(runif(1)+1)
  
  print(paste(count, url))
  
  website <- read_html(url)
  
  tmp <- tibble(
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
  
  articles <- rbind(articles, tmp)
  saveRDS(articles, file = "../data/processed/CNN.Rds")
  
  count <- count + 1
}

# Note: If you don't limit yourself to 200 articles, you need to split the URL list into 
# manageable chunks (~300-500), otherwise R will run out of memory and crash.

