library(tidyverse)
library(stringr)
library(lubridate)

scraped <- readRDS(file="/Users/yunchaewon/sicss-berlin/ai_hype/NYT_200.Rds")
scraped_table <- data.table::rbindlist(scraped, fill = TRUE)

table_clean <- scraped_table %>%
  mutate(date = timestamp,
         date = str_replace(date, "July", "Jul."),
         date = str_replace(date, "April", "Apr."),
         date = str_replace(date, "June", "Jun."),
         date = str_replace(date, "March", "Mar."),
         date = str_replace(date, "May", "May."),
         date = str_replace(date, "Sept.", "Sep.")) %>%
  mutate(date = readr::parse_date(date, "%b. %d, %Y"))

