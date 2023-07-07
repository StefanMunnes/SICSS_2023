remotes::install_github("quanteda/quanteda.sentiment", force=TRUE)

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

library(quanteda)
library(word2vec)
library(dplyr)
library(tidyverse)
library(stringr)
library(lubridate)
library(ggplot2)

cnn <- readRDS("data/CNN_complete.Rds")
fox <- readRDS("data/FOX_complete.Rds")


#correct dates and combine two datasets
fox <- fox %>% dplyr::select(-article_length)


# clean data

cnn$timestamp
str_detect(cnn$timestamp, "Updated") == TRUE

cnn<- cnn%>%
  mutate(what= case_when(
    str_detect(cnn$timestamp, "Updated") == TRUE ~ "updated", 
    str_detect(cnn$timestamp, "Published") == TRUE ~ "published"))

table(cnn$what)

cnn$timestamp <- str_extract(cnn$timestamp, "(\\d+:\\d+.*)")

#cnn_clean$time <- str_extract(cnn_clean$timestamp, "^(.+?),")
#cnn_clean$time <- str_replace_all(cnn_clean$time , "," ,"")


#cnn$day <- str_extract(cnn$timestamp, "(Mon|Tue|Wed|Thu|Fri|Sat|Sun)")
cnn$date <- str_replace(cnn$timestamp, "^(.+?),", "") # extract the part that is the date
cnn$date <- str_replace(cnn$date, "(\\s...\\s)", "") #  remove white space and weekday

cnn$date <- mdy(cnn$date)


fox$timestamp
fox$date <- str_extract(fox$timestamp, "^([^\\d]+ \\d{1,2}, \\d{4})")
fox$date <- mdy(fox$date)
fox$what <- NA

fox$source <- "fox"
cnn$source <- "cnn"

textdata <- rbind(fox, cnn)


#pre-processing
textdata$body <- str_to_lower(textdata$body)
textdata$body<- str_squish(textdata$body)


#word embeddings = Stefan's code
model <- word2vec(textdata$body, type = "cbow", window = 5, dim = 50)

embeddings <- as.matrix(model)
head(embeddings) #Each row of the matrix represents a word, and each column represents a dimension in the word vector space
#predictions
predict(model, c("criminal", "person"), type = "nearest", top_n = 10)

#2. Downloaded Wiki word embeddings - it can be used as a comparison
#of your specific data/model with the general corpus of data 
wiki <- read.word2vec("exercises/NP/8/model.bin")

predict(wiki, c("criminal", "person"), type = "nearest", top_n = 10)


#3- most important keywords
predict(model, c("belief", "person"), type = "nearest", top_n = 10)




# This code uses the trained Word2Vec model (model) to predict the most 
#similar words to "criminal" and "violent" based on their word vectors. 
#It returns the top 5 most similar words for each input word.
predict(model, c("official", "soccer"), type = "nearest", top_n = 5)


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
