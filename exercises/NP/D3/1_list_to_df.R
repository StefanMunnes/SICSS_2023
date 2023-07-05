# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise

library(tidyverse)

congress_members <- readRDS("exercises/NP/D3/congress_members.Rds")

#this works except for terms
df2 <- congress_members %>% 
  data.table::rbindlist(fill=TRUE) %>%
  select (-depiction) %>%
  distinct %>% #to remove duplicates
  unnest_longer(terms) %>% #to unnest the terms column
  unnest_wider(terms)
