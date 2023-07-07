# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("CNN_complete.Rds")

# If you laptop has trouble with these operations, reduce the number of articles with
#cnn_data <- sample_n(cnn_data, 400) # or any other amount


# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)
cnn_data$authors[[1]]
cnn_authors <- cnn_data$authors
cnn_authors[[1]]

cnn_clean <- cnn_data%>%
  mutate(author = str_split(authors, ";", simplify = FALSE))%>%
  unnest_wider(author, names_sep = "")

# 2. timestamp, create one variable... ----------------------------------
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information

cnn_clean2 <- cnn_data%>%
  mutate(author = str_split(authors, ";", simplify = FALSE))%>%
  unnest_wider(author, names_sep = "")%>%
  mutate(Status = str_extract(timestamp, "Updated|Published"))%>%
  mutate(Weekday = str_extract(timestamp, "Sun|Mon|Tue|Wed|Thu|Fri|Sat"))%>%
  mutate(Date = str_extract(timestamp, "\\w+\\s+\\d{1,2},\\s+\\d{4}"))%>%
  select(-timestamp)
# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
cnn_clean3 <- cnn_data%>%
  mutate(title = str_replace_all(title, "\\n", ""))%>%
  mutate(title = str_replace_all(title, "\\s{2,9}", " "))%>%
  mutate(body = str_replace_all(body, "\\n", ""))%>%
  mutate(body = str_replace_all(body, "\\s{2,9}", " "))

# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
#   b. how many characters and how many words does the overall corpus consist of?
#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results
#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'


