# SICSS Berlin - Day 3 - July 4, 2023
# List to Data Frame - Exercise

library(tidyverse)

congress_members <- readRDS("./congress_members.Rds")
#str(congress_members)

dataframe <- congress_members %>% 
  data.table::rbindlist(fill=TRUE) %>% 
  select(-depiction) %>% 
  distinct() %>% 
  unnest_longer(terms) %>% 
  unnest_wider(terms)

# alternative (chatGPT)

# library(purrr)
# library(dplyr)

# dataframe <- congress_members %>%
#   map_df(as_tibble) %>%
#   unnest(cols = c(depiction, terms))



# Print the resulting dataframe
print(dataframe) 


# Print the resulting dataframe
print(df)
