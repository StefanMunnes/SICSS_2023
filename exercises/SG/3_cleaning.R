# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("../data/processed/CNN_complete.Rds")

# If you laptop has trouble with these operations, reduce the number of articles with
#cnn_data <- sample_n(cnn_data, 400) # or any other amount


# 1. authors --------------------------------------------------------------
#   a. Separate authors into individual variables
#   b. Change author names to be last name first, i.e., "Last, First" (relatively difficult)


# 2. timestamp, create one variable... ----------------------------------
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information



# 3. title and body -------------------------------------------------------
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization


# 4. body -----------------------------------------------------------------
#   a. how many characters and how many words does each article consist of?
#   b. how many characters and how many words does the overall corpus consist of?
#   c. count how often "Black Lives Matter" or "BLM" are mentioned in individual
#      articles and titles and think about the implications of the results
#   d. count the number of articles by month
#   e. count the numbers of articles that contain words related to 
#      'peaceful protest' and then words related to 'violent protest'


