# SICSS Berlin - Day 3 - July 5, 2023
# Cleaning text data - Exercise Solution

library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("../data/processed/CNN_complete.Rds")

# If you laptop has trouble with these operations, reduce the number of articles with
#cnn_data <- sample_n(cnn_data, 400) # or any other amount

# 1. authors
#   a. Separate authors into individual variables
#stringr
cnn_clean <- cnn_data %>%
  mutate(author = str_split(authors, ";", simplify = FALSE)) %>%
  unnest_wider(author, names_sep = "")

#tidyr
cnn_clean <- cnn_data %>%
  separate_wider_delim(authors, 
                       delim = ";", 
                       names_sep = "", 
                       too_few = "align_start",
                       cols_remove = TRUE) %>%
  rename_with(~sub("authors", "author", .), starts_with("authors"))

#72 are missing author names, because the CSS selector was different, e.g.: https://edition.cnn.com/2022/12/23/entertainment/whitney-houston-biopic-legacy-reaj/index.html




#   b. Change author names to be Surname First
#testing
name <- c("First Last", "First F. Last", "First Letzte Last", "First de Last", "First Last-Letzte")
str_replace(name, 
            "^([:alpha:]+(\\s[:alpha:]\\.)?(?!,))\\s(.+(-.+)?)" , 
            "\\3, \\1")

#implementation
regex <- "^([:alpha:]+(\\s[:alpha:]\\.)?(?!,))\\s(.+(-.+)?)"
cnn_clean <- cnn_clean %>%
  mutate_at(vars(starts_with("author")), ~ str_replace(.,  regex , "\\3, \\1"))

### !! 
# As some very attentive participants realized, some authors have additional
# text, and therefore the above does not work for them. If you want a 
# challenge, you can try to solve these cases as well (list is not complete):
# CNN | Jacqui Palumbo
# Exclusive: By Ena Bilobrk
# Story: Scottie Andrew
# EXCLUSIVE: By Clarissa Ward
# Stephen Collinson with Caitlin Hu
# Illustration by Alberto Mier
# Shaun Leonardo | Introduction by Ananda Pellerin
# William J. Barber II
# Fernando Alfonso III
###############

# 2. timestamp, create one variable...
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information
regex <- "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+"

cnn_clean <- cnn_clean %>%
  tidyr::extract(col = timestamp, 
                 into = c("updated", "weekday", "date"), 
                 regex = regex,
                 remove = TRUE)

# Alternative using stringr
cnn_clean <- cnn_clean %>%
  mutate(updated = str_extract(
           timestamp,
           regex,
           group = 1),
         weekday =  str_extract(
           timestamp,
           regex,
           group = 2),
         date = str_extract(
           timestamp,
           regex,
           group = 3)) 

# Date format
cnn_clean <- cnn_clean %>%
  mutate(date = parse_date(date, "%B %d, %Y",
                           locale = locale("en")))

# 3. title and body
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
cnn_clean <- cnn_clean %>%
  mutate(title = str_remove_all(title, "\\n"),
         title = str_squish(title),
         body = str_replace_all(body, "\\n", " "),
         body = str_squish(body)) %>%
  mutate(title = str_to_lower(title),
         body = str_to_lower(body))

# 4. body
#   a. count the length of articles
cnn_clean <- cnn_clean %>%
  mutate(length_chr = str_length(body),
         word_count = str_count(body, "\\w+"))

# character length of all articles combined
format(sum(cnn_clean$length_chr), nsmall=1, big.mark=",")
# word count of all articles combined
format(sum(cnn_clean$word_count), nsmall=1, big.mark=",")


#   b. count how often "Black Lives Matter" or "BLM" are mentioned in individual articles and titles and think about the implications of the results
cnn_clean <- cnn_clean %>%
  mutate(count_BLM = str_count(body, "\\bblack lives matter|blm\\b"),
         count_BLM_title = str_count(title, "\\bblack lives matter|blm\\b"))
# So how many of these articles are actually about BLM, and not just mentioning it..

#   c. count the number of articles by month
cnn_clean <- cnn_clean %>%
  mutate(my = paste0(month(date), year(date))) %>%
  group_by(my) %>%
  mutate(count_articles = n()) %>%
  ungroup() %>%
  select(!my)


#   d. count the numbers of articles that contain words related to 
#       'peaceful protest' and then words related to 'violent protest'
cnn_clean <- cnn_clean %>%
  mutate(count_violent = str_count(body, "\\bviolent|riot|burning\\b"),
         count_peaceful = str_count(body, "\\bpeaceful|march|demonstration\\b"))

sum(cnn_clean$count_violent)
sum(cnn_clean$count_peaceful)

