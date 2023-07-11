### TEXT PREPROCESSING ###

library(tidyverse)
setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/ai_diversity")

# ---- 1. Facebook ---- #

fb <- read.csv("ai_facebook.csv", comment.char="#")
fb_clean <- fb[(grepl("#artificialintelligence|Artificial Intelligence|artificial intelligence", 
                      fb$Message)), ]

fb_clean <- subset(fb_clean, select = c("User.Name", "Message", "Post.Created.Date", "Page.Category"))

# set dateformat
fb_clean$Post.Created.Date
fb_clean$date <- as.Date(fb_clean$Post.Created.Date, format = "%Y-%m-%d")
fb_clean$date
fb_clean$Post.Created.Date <- NULL

# remove links and @
fb_clean$text[25:35]
fb_clean <- fb_clean %>% 
  mutate(text = str_replace_all(Message, "@|#", "")) |> #removing only sign or words as well?
  mutate(text = str_replace_all(text, "http\\S+", ""))

#save clean file
write.csv(fb_clean, file = "ai_fb_clean.csv", row.names = FALSE)


# ---- 2. FOX News ---- #

fox <- readRDS("FOX_complete.Rds")

# set dateformat
fox$date <- str_extract(fox$timestamp, '\\s+(.*\\d{4})', group=1)
fox$date <- as.Date(fox$date, format = "%B %d, %Y")
fox$timestamp <- NULL

# remove \ and anything in brackets?
fox$text[5:6]
fox <- fox %>% 
  mutate(text = str_replace_all(body, "\\(.*?\\)", ""))
  #mutate(text = str_replace_all(body, "\\\\\\\\", "")) |> 
  

#save clean file
write.csv(fox, file = "ai_fox_clean", row.names = FALSE)
