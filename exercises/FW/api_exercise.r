# SICSS Berlin - Day 2 - July 4, 2023
# API - Exercise - FW

setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/SICSS_2023/exercises/FW")
library(tidyverse)
library(httr)
require(stringr)

api_key <- str_split(readLines("~/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/us_congress_api.txt"), pattern = " ")

httr_rec <- GET("https://api.congress.gov/v3/member",
                query = list(format = "json",
                             limit=250,
                             offset=0,
                             api_key = api_key))
                

content(httr_rec)

# extracting the members
members <- content(httr_rec, type='application/json')$member

### LOOP

members <- list()
limit <- 250
offset <- 0

# Define the total number of iterations
num_iterations <- 11 

# Loop through the desired number of iterations
for (i in 1:num_iterations) {
  httr_rec <- GET("https://api.congress.gov/v3/member", query = list(
    format = "json",
    limit = limit,
    offset = offset,
    api_key = api_key))
  
  members_temp <- content(httr_rec, type='application/json')$member
  members <- append(members, members_temp)
  offset <- offset + limit
}