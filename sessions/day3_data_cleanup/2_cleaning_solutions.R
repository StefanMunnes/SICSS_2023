library(tidyverse)
library(stringr)
library(lubridate)

cnn_data <- readRDS("../Example_Data/Final/CNN_complete.Rds")

# 1. authors
#   a. Separate authors into individual variables
cnn_clean <- cnn_data %>%
  separate_wider_delim(authors, 
                       delim = ";", 
                       names_sep = "", 
                       too_few = "align_start",
                       cols_remove = TRUE)
#72 are missing author names, because the CSS selector was different, e.g.: https://edition.cnn.com/2022/12/23/entertainment/whitney-houston-biopic-legacy-reaj/index.html

#   b. Change author names to be Surname First
# PREVENT FROM SWITCHING BACK             done
# CHECK WHAT HAPPENS TO HYPHENATED NAMES  done
# Fails on Nicquel Terry Ellis            done

#testing
name <- c("First Last", "First F. Last", "First Letzte Last", "First de Last", "First Last-Letzte")
str_replace(name, 
            "^(.[:alpha:]+(\\s[:alpha:]\\.)?(?!,))\\s(.+(-.+)?)" , 
            "\\3, \\1")

#implementation
regex <- "'^(.[:alpha:]+(\\s[:alpha:]\\.)?(?!,))\\s(.+(-.+)?)'"
cnn_clean <- cnn_clean %>%
  mutate(authors1 = str_replace(authors1, regex , "\\3, \\1"),
         authors2 = str_replace(authors2, regex , "\\3, \\1"),
         authors3 = str_replace(authors3, regex , "\\3, \\1"),
         authors4 = str_replace(authors4, regex , "\\3, \\1"),
         authors5 = str_replace(authors5, regex , "\\3, \\1"),
         authors6 = str_replace(authors6, regex , "\\3, \\1"))


# 2. timestamp, create one variable...
#   a. ...that includes the information whether the article was updated or 
#         published on this date
#   b. ...that holds the weekday
#   c. ...that holds the date (in date format!)
#   d. ...discard the rest of the information
cnn_clean <- cnn_clean %>%
  tidyr::extract(col = timestamp, 
                 into = c("updated", "weekday", "date"), 
                 regex = "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+",
                 remove = TRUE)

# Alternative using stringr
cnn_clean <- cnn_clean %>%
  mutate(updated = str_extract(
           timestamp,
           "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+",
           group = 1),
         weekday =  str_extract(
           timestamp,
           "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+",
           group = 2),
         date = str_extract(
           timestamp,
           "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+",
           group = 3)) 

# Date format
cnn_clean <- cnn_clean %>%
  mutate(date = parse_date(date, "%B %d, %Y",
                           locale = locale("en")))

# 3. title and body
#   a. remove non-language characters (e.g., \n and excessive white spaces) and remove capitalization
cnn_clean <- cnn_clean %>%
  mutate(title = str_remove_all(title, "\\n"),
         title = str_remove_all(title, "\\s\\s+"),
         body = str_replace_all(body, "\\n", " "),
         body = str_replace_all(body, "\\s+", " "),
         body = str_trim(body, side = "both")) %>%
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


#   b. count how often "Black Lives Matter" or "BLM" are mentioned in individual articles and titles
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


#   e. remove self-advertisement (calls to join on Facebook or Twitter)
#Look at the texts that include Facebook or Twitter mentions
cnn_clean <- cnn_clean %>%
  mutate(fb_twit_mention = str_extract(body, ".{30}([Ff]acebook|[Tt]witter).{30}"))
table(cnn_clean$fb_twit_mention)
#Visit CNN.com/sport for more news, videos and features...
#Visit CNN's Election Center for full coverage of the 2020 
#A version of this story appeared in CNNâ€™s Pop Life Chronicles newsletter. To get it in your inbox, sign up for free here. Tell us what youâ€™d like to see more of in the newsletter at entertainment.newsletter@cnn.com. 
#follow her|him on twitter @ 
#follow her|him @ 
#follow her|him at @
#follow @
#Please send story ideas and feedback to ...@
#You can subscribe here. Tell us what youâ€™d like to see more of in the newsletter at entertainment.newsletter@cnn.com

