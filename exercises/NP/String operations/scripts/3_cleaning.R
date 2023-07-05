# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution
library(dplyr)
library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("exercises/NP/CNN_complete.Rds")

# If you laptop has trouble with these operations, reduce the number of articles with
cnn_data <- sample_n(cnn_data, 400) # or any other amount


# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
cnn_data[c('first_author', 'second_author', 'third_author')] <- str_split_fixed(cnn_data$authors, ";", 3)

cnn_data <- cnn_data[,-14:-15]

#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)
cnn_data$first_author <- sub('(\\w+) (\\w+)', '\\2 \\1', cnn_data$first_author)
cnn_data$second_author <- sub('(\\w+) (\\w+)', '\\2 \\1', cnn_data$second_author)
cnn_data$third_author <- sub('(\\w+) (\\w+)', '\\2 \\1', cnn_data$third_author)


# 2. timestamp, create one variable... ----------------------------------
#   a. ...that includes the information whether the article was updated or 
#         published on this date
cnn_data$timestamp <- gsub("\\s+", " ", str_trim(cnn_data$timestamp))

cnn_data <- str_split_fixed(cnn_data$timestamp, " ", 2) %>% 
  data.frame() %>% 
  rename(t1 = X1, t2 = X2) %>% 
  cbind(cnn_data, .)

#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#first create 3 new variables from t2 variable
cnn_data[c('hour', 'date', 'year')] <- str_split_fixed(cnn_data$t2, ",", 3)

#now create two separate variables based on the date variable
cnn_data$date <- gsub("\\s+", " ", str_trim(cnn_data$date))
cnn_data <- str_split_fixed(cnn_data$date, " ", 2) %>% 
  data.frame() %>% 
  rename(week_day = X1, month = X2) %>% 
  cbind(cnn_data, .)

#turn month variable into a date format
#first combine two columns to have full data
cnn_data$date_full <-  paste(cnn_data$month,cnn_data$year)
cnn_data$date_full2 <- as.POSIXct(cnn_data$date_full, format="%b%d%Y")

#   d. ...discard the rest of the information
myvars <- c("t1", "week_day", "date_full2")
cnn_data2 <- cnn_data[myvars]
cnn_data2



# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
cnn_data$title <- gsub("[^[:alnum:] ]", "", cnn_data$title)
cnn_data$title <- trimws(cnn_data$title)
cnn_data$title

cnn_data$body <- gsub("[^[:alnum:] ]", "", cnn_data$body)
cnn_data$body <- trimws(cnn_data$body)
cnn_data$body

#remove capitalization
cnn_data$title <- tolower(cnn_data$title)
cnn_data$body <- tolower(cnn_data$body)


# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
charachters <- str_length(cnn_data$body)
charachters
words <- lengths(strsplit(cnn_data$body, "\\W+"))
words

#   b. how many characters and how many words does the overall corpus consist of?

#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results

Loss <- rowSums(cnn_data == "BLM") # Count the "Loss" per row
cbind(Loss = rowSums(cnn_data=="BLM"), Wins = rowSums(cnn_data=="Black Lives Matter"))
cbind(Loss, Wins = ncol(cnn_data) - Loss)


#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'


