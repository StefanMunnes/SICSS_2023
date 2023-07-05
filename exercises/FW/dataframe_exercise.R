# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise

library(tidyverse)
library(httr)
library(jsonlite)

congress_members <- readRDS("congress_members.Rds")

members_df <-  congress_members %>%
  data.table::rbindlist(fill = TRUE) %>%
  select(-depiction) %>%
  distinct() %>% #checks whether any rows are duplicates
  unnest_longer(terms) %>%
  unnest_wider(terms)