# reference:  http://ccgilroy.com/nyt-api-httr-demo/nyt_api_httr_demo.html
library(tidyverse)
library(httr)
library(devtools)
library(readr)
library(ggplot2)
library(stringr)
library(jsonlite)
library(fstrings)
library(glue)
# devtools::install_github("jimhester/fstrings", force=TRUE)
# file.edit("~/.Renviron")
# Sys.getenv("nyt_key")



nyt_articlesearch_url <- 
  "https://api.nytimes.com/svc/search/v2/articlesearch.json"


query_list <- 
  list(
    `api-key` = Sys.getenv("nyt_key"), 
    begin_date = "20220601",
    end_date="20230610",
    fq="Artificial Intelligence"
    )

  
r <- GET(nyt_articlesearch_url, query = query_list)

status_code(r)
content(r)$response$meta
docs <- content(r)$response$docs

articles <- content(r, type='application/json')$response$docs

hits <- content(r)$response$meta$hits
hits
pages <- 0:(ceiling(hits/10) - 1)

requests <- 
  lapply(pages, function(page_idx, query_list) {
      print(page_idx)
      dir.create(glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}"), showWarnings = TRUE, recursive = FALSE, mode = "0777")
      # sprintf 
      print('dir created!')
      new_query_list <- c(query_list, page = page_idx)
      ## wait to avoid being rate-limited
      Sys.sleep(12)
      r <- GET(nyt_articlesearch_url, query = new_query_list)
      
      print('----sending request----')
      
      print(status_code(r))
      print(page_idx)
      status_code(r)
      
      print('----writing files----')
      
      Map(function(r, x){
        ## build file name
        file_name <- str_c("artificial_intelligence", str_pad(as.character(x), 2, pad = "0"), 
                           sep = "_") %>%
          str_c(".json") %>%
          file.path(glue::glue("/Users/yunchaewon/sicss-berlin/ai_hype/nyt_{page_idx}"), .)
        ## write to file as JSON
        if (status_code(r) == 200) {
          content(r) %>% toJSON() %>% prettify() %>% write_file(file_name)
        }
      }, 
      r = requests, x = pages) %>% invisible()
      
      }, query_list = query_list)
