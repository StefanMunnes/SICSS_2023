# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise Solution

library(tidyverse)

congress_members <- readRDS("../data/processed/congress_members.Rds")

members_df <- congress_members %>%
  data.table::rbindlist(fill = TRUE) %>%
  select(-depiction) %>%
  distinct() %>%
  unnest_longer(terms) %>%
  unnest_wider(terms)


library(pacman)
?p_load_gh

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh(c(
  "trinker/termco", 
  "trinker/coreNLPsetup",        
  "trinker/tagger"
))
