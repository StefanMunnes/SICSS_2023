# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("CNN_complete.Rds")

# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)

cnn_data_new <- cnn_data %>% separate(authors, c('author1', 'author2', 
                                                 'author3', 'author4', 'author5'),
                                      sep = ";")
cnn_data_new <- cnn_data_new %>% mutate(author4 = str_replace(author4, "CNN", ""))
cnn_data_new <- cnn_data_new %>% mutate(author4 = str_replace(author4, "\\s+\\|\\s+", ""))

columns <- c("author1", "author2", "author3", "author4")

for (col in columns) {
  cnn_data_new[[col]] <- ifelse(is.na(cnn_data_new[[col]]), NA, sapply(cnn_data_new[[col]], function(x) {
    reordered <- strsplit(x, ' ', fixed = TRUE)[[1]][c(2, 1)]
    paste(reordered, collapse = ', ')
  }))
}



# 2. timestamp, create one variable... ----------------------------------
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information

cnn_data_new <- cnn_data_new %>% mutate(timestamp = str_replace_all(timestamp, "\n", ""))

cnn_data_new$article_status <- str_extract(cnn_data_new$timestamp, "^  (\\w+)",
                                           group=1)
cnn_data_new$weekday <- str_extract(cnn_data_new$timestamp, "EDT, (\\w+)",
                                    group=1)

cnn_data_new$date <- str_extract(cnn_data_new$timestamp, "(\\w+\\s\\d+,\\s\\d{4})")
cnn_data_new$date <- as.Date(cnn_data_new$date, format = "%B %d, %Y")
cnn_data_new$timestamp <- NULL

# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
vars <- c("body", "title")

cnn_data_new <- cnn_data_new %>%
  mutate(across(all_of(vars), ~ str_replace_all(., "\n", ""))) %>%
  mutate(across(all_of(vars), ~ str_replace_all(., "\\s+", " "))) %>%
  mutate(across(all_of(vars), ~ str_trim(.)))

# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
#   b. how many characters and how many words does the overall corpus consist of?
#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results
#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'

cnn_data_new$length <- str_length(cnn_data_new$body)
cnn_data_new$word_count <- str_count(cnn_data_new$body, '\\S+')

cnn_data_new$black_lives_b <- str_count(cnn_data_new$body, 'Black Lives Matter')
cnn_data_new$blm_b <- str_count(cnn_data_new$body, 'BLM')

cnn_data_new$black_lives_t <- str_count(cnn_data_new$title, 'Black Lives Matter')
cnn_data_new$blm_t <- str_count(cnn_data_new$title, 'BLM')

total_characters <- sum(nchar(cnn_data_new$body))

# Calculate the total number of words
total_words <- sum(sapply(strsplit(cnn_data_new$body, "\\s+"), length))

print(paste("Total characters:", total_characters))
print(paste("Total words:", total_words))

# Count articles by month
article_count <- table(format(cnn_data_new$date, "%B"))
print(article_count)

# Count articles based on relation to words
count_peaceful <- sum(grepl("\\bpeaceful\\b|\\bprotest\\b", cnn_data_new$title, ignore.case = TRUE))
count_violent <- sum(grepl("\\bviolent\\b|\\bprotest\\b", cnn_data_new$title, ignore.case = TRUE))

print(paste("Number of articles related to peaceful protest:", count_peaceful))
print(paste("Number of articles related to violent protest:", count_violent))