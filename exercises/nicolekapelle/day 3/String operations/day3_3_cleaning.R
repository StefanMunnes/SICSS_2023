# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)

setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()

cnn_data <- readRDS("./day 3/String operations/CNN_complete.Rds") # Dot indicates to go into subfolder. Two dots mean to go one folder back

# If you laptop has trouble with these operations, reduce the number of articles with
#cnn_data <- sample_n(cnn_data, 400) # or any other amount


# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
head(cnn_data$authors, 30)

#My solution:
# cnn_clean <- cnn_data %>% 
#   separate(col = authors, sep = ";", into = str_c('author',1:10))

cnn_clean <- cnn_data %>% 
  mutate(author = str_split(authors, ";", simplify = FALSE)) %>% 
  unnest_wider(author, names_sep = "")
  
#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)
cnn_clean <- cnn_data %>% 
  separate_wider_delim(authors,
                       delim = ";",
                       names_sep = "",
                       too_few = "align_start",
                       cols_remove = TRUE) %>% 
  rename_with(~sub("authors","author",.), starts_with("authors"))


# 2. timestamp, create one variable... ----------------------------------
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information


# Generate a new variable indicating if "Published" or "Updated" is present
cnn_clean <- cnn_clean %>% 
  mutate(published_updated = ifelse(str_detect(timestamp, regex("published", ignore_case = TRUE)), # regex = function for regular expression
                                    "published",
                                    ifelse(str_detect(timestamp, regex("updated", ignore_case = TRUE)),
                                           "updated",
                                           "NA")))

# new variable that holds the weekday

cnn_clean <- cnn_clean %>% 
  mutate(weekday = str_extract(timestamp, regex("(?<=EDT, |EST, )\\w{3}")))

table(cnn_clean$weekday, useNA = "always")
#No NAs --> seems to have worked 


# new variable that holds the date (in date format!)



# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
head(cnn_data$title, 10)
head(cnn_data$body, 2)

cnn_clean <- cnn_clean %>%
  mutate(title = str_remove_all(title, "\\n"),
         title = str_squish(title),
         body = str_replace_all(body, "\\n", " "),
         body = str_squish(body)) %>%
  mutate(title = str_to_lower(title),
         body = str_to_lower(body))
  
head(cnn_data$title, 10)
head(cnn_data$body, 2)


# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
#   b. how many characters and how many words does the overall corpus consist of?
#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results
#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'


