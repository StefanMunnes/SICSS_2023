library(purrr)
library(tidyverse)
library(jsonlite)
library(rjson)
library(glue)

# install.packages("rjson")
# path <- "/Users/yunchaewon/sicss-berlin/ai_hype/nyt/nyt_0/artificial_intelligence_00.json"

path <- "/Users/yunchaewon/sicss-berlin/ai_hype/nyt/nyt_0"
files <- dir(path, pattern = "*.json")

data <- files %>%
  map_df(~fromJSON(file.path(path, .), flatten = TRUE))
#data$docs

filenames <- list.files(path, pattern="*.json", full.names=TRUE) # this should give you a character vector, with each file name represented by an entry
myJSON <- lapply(filenames, function(x) fromJSON(file=x)) # a list in which each element is one of your original JSON files

urls = list()
for(jsonf in myJSON){
  for(article in jsonf$response$docs){
    url <- article$web_url
    urls <- c(urls, url)
  }
}


urls = list()
for(idx in 0:2){
  path <- glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt/nyt_{idx}")
  
  print(path)
  
  filenames <- list.files(path, pattern="*.json", full.names=TRUE) # this should give you a character vector, with each file name represented by an entry
  
  myJSON <- lapply(filenames, function(x) fromJSON(file=x)) # a list in which each element is one of your original JSON files
  
  for(jsonf in myJSON){
    for(article in jsonf$response$docs){
      url <- article$web_url
      urls <- c(urls, url)
    }
    print(length(urls))
    
  }
}

lapply(urls, write, "/Users/yunchaewon/sicss-berlin/ai_hype/nyturls.txt", append=TRUE)
