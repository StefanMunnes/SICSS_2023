# SICSS Berlin - Day 2 - July 4, 2023
# Webscrape - Exercise - FW

library(tidyverse)
library(rvest)
library(stringr)
library(dplyr)

setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/SICSS_2023/exercises/FW")
urls <- str_split(readLines("practice_CNN_URLs.txt"), pattern = " ")

html <- read_html("https://edition.cnn.com/2023/06/29/us/randy-cox-new-haven-police-officers-fired/index.html")

title <- html %>% 
  html_element("h1") %>% 
  html_text() 

date <- html %>% 
  html_node(".timestamp") %>% 
  html_text() 

### LOOP

df <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(df) <- c("Title", "Author", "Date", "Text", "Webpage")

for (i in 1:length(urls)){
  url <- urls[[i]]  
  webpage <- read_html(url)

  title <- html_node(webpage, "#maincontent") %>% 
    html_text()
  
  author <- html_nodes(webpage, ".byline__name") %>% 
    html_text() %>% 
    paste(collapse = ";")
  
  date <- html_node(webpage, ".timestamp") %>% 
    html_text()
  
  text <- html_nodes(webpage, ".paragraph") %>% 
    html_text() %>% 
    paste(collapse = "")
  
  temp_df <- data.frame(Title = title, Author = author, Date = date, Text = text, Webpage = url)
  df <- rbind(df, temp_df)
}