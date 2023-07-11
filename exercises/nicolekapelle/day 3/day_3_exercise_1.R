# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise

library(tidyverse)


setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()

congress_members <- readRDS("./day 3/congress_members.Rds") # Dot indicates to go into subfolder. Two dots mean to go one folder back

# transfer lists into dataframe
dataframe <- congress_members %>%
  map_df(as_tibble) %>%
  unnest(cols = c(depiction, terms))

# alternative way
members_df <- congress_members %>%
  data.table::rbindlist(fill= TRUE) %>%
  select(-depiction) %>% # drop depiction
  distinct() %>% # deletes duplicates 
  unnest_longer(terms) %>% 
  unnest_wider(terms) # we end with long format (some individuals had several terms)
  

members_tidy <- data.table::rbindlist(members_tidy, fill = TRUE) # combines the lists into a single tibble
saveRDS(members_tidy, file = "CNN.Rds")