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
# Title: #maincontent
# Authors: .byline__names
# Date: .timestamp
# Text: .inline-placeholder

# scrape one article



# Task 2 -----------------------------------------------------------------
# Build a loop to scrape all of the URLs provided in the textfile

getwd()
setwd("C:/Users/giebel/Summer School/SICSS_2023/exercises/SG")
urls <- scan("practice_CNN_URLs.md", character(), quote = "")
firsturl <- urls[[1]]

website <- read_html(firsturl) #this reads the url
website 
firsturl #testing just the first url

article <- tibble(
  title = website %>%
    html_node("#maincontent") %>% #selectorgadget helped id maincontent
    html_text(), #this extracts the text from title
  
  authors = website %>%
    html_nodes(".byline__name") %>%
    html_text() %>%
    paste(collapse = ";"), #collapses small bits into one line
  
  timestamp = website %>%
    html_nodes(".timestamp") %>%
    html_text(),
  
  body = website %>%
    html_nodes(".paragraph") %>%
    html_text() %>%
    paste(collapse = ""), #small bits into one line
  
  firsturl = firsturl #column name
)
article

#working on urls with lapply

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
getwd ()
saveRDS(articles, file = "CNN.Rds")

library(tidyverse)
urlscheck <- articles$url

non_duplicates <- urls[!urls %in% urlscheck]
print(non_duplicates)
