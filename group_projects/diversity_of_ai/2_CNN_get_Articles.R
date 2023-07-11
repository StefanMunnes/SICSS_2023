library(tidyverse)
library(rvest)
library(RSelenium)
library(wdman)
library(netstat)

# What we want:
# Title: #maincontent
# Authors: .byline__name   (Achtung: can be multiple names!)
# Date: .timestamp
# Text: .paragraph

urls <- scan("CNN_URLs_save.txt", character(), quote = "")


# Testrun -----------------------------------------------------------------
website <- read_html(urls[10])
test <- tibble(
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
  
  #url = url
)


# Loop --------------------------------------------------------------------
# Split the task, otherwise memory overload
# Issue: no end condition, loop will run into NA and break

# split urls list into smaller chunks, otherwise memory will run full and R will crash
url_groups <- split(urls, ceiling(seq_along(urls) / 350))

# loop over each batch, save data set immediately and delete data from previous
# batch to prevent R from crashing
for (batch in seq_along(url_groups)) {
 
  articles <- data.frame()
  
  for (url in url_groups[[batch]]) {

    Sys.sleep(runif(1)+1)
    
    print(paste(batch, url))
    
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
    saveRDS(articles, file = paste0("CNN", batch, ".Rds"))
  }
}


# Append CNN articles
CNN <- data.frame()
for (i in seq_along(url_groups)) {
  tmp <- rbind(CNN, readRDS(paste0("CNN", i, ".Rds")))
  CNN <- tmp
}


# check if length is realistic
CNN <- CNN %>%
  mutate(article_length = str_length(body))

# remove duplicates
CNN <- CNN %>%
  distinct(.keep_all = TRUE)

# save as one file
saveRDS(CNN, file = "CNN_complete.Rds")
