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

urls <- c(scan("FOX_URLs_save1.txt", character(), quote = ""), scan("FOX_URLs_save2.txt", character(), quote = ""))
urls <- unique(urls)

# Testrun -----------------------------------------------------------------
website <- read_html(urls[857])
test <- tibble(
  title = website %>%
    html_node(".headline") %>%
    html_text(),
  
  authors = website %>%
    html_nodes(".author-byline a") %>%
    html_text()  %>%
    paste(collapse = ";"),
  
  timestamp = website %>%
    html_nodes("time") %>%
    html_text(),
  
  body = website %>%
    html_nodes(".article-body p") %>%
    html_text() %>%
    paste(collapse = ""),
  
  #url = url
)


# Loop --------------------------------------------------------------------
# Split the task, otherwise memory overload
urls1 <- urls[1:500]
urls2 <- urls[501:1000]
urls3 <- urls[1001:1324]

for (batch in 1:3) {
  
  articles <- data.frame()
  
  for (url in eval(parse(text = paste0("urls", batch)))) {
    
    Sys.sleep(runif(1)+sample(1:2, 1))
    
    print(paste(batch, url))
    
    website <- read_html(url)
    
    tmp <- tibble(
      title = website %>%
        html_node(".headline") %>%
        html_text(),
      
      authors = website %>%
        html_nodes(".author-byline a") %>%
        html_text()  %>%
        paste(collapse = ";"),
      
      timestamp = website %>%
        html_nodes("time") %>%
        html_text(),
      
      body = website %>%
        html_nodes(".article-body p") %>%
        html_text() %>%
        paste(collapse = ""),
      
      url = url
    )
    
    articles <- rbind(articles, tmp)
  }
  saveRDS(articles, file = paste0("FOX", batch, ".Rds"))
}

# Append FOX articles
FOX <- rbind(
  readRDS("FOX1.Rds"),
  readRDS("FOX2.Rds"),
  readRDS("FOX3.Rds"))

# check if length is realistic
FOX <- FOX %>%
  mutate(article_length = str_length(body))

# remove duplicates
FOX <- FOX %>%
  distinct(.keep_all = TRUE)

# save as one file
saveRDS(FOX, file = "FOX_complete.Rds")


