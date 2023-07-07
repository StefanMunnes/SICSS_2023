# SICSS Berlin - Day 5 - July 7, 2023
# text analysis - Exercise II - FW

library(word2vec)
library(tidyverse)
library(stringr)
library(tm)
library(SnowballC)

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

textdata <- readRDS("CNN_complete.Rds")

## Clean Data 

stopwords <- stopwords("en")

textdata <- textdata %>%
  mutate(body_clean = str_replace_all(body, "\n", "")) %>%
  #mutate(body_clean = str_replace_all(body_clean, "\\s+", " ")) %>%
  mutate(body_clean = str_replace_all(body_clean, "'*", "")) %>%
  mutate(body_clean = str_trim(body_clean)) %>%
  mutate(body_clean = str_replace_all(body_clean, "[^[:alnum:] ]", "")) %>%
  mutate(body_clean = tolower(body_clean)) 

textdata$body_stem <- stemDocument(textdata$body_clean, language = "english")

model <- word2vec(textdata$body_clean, type = "cbow", window = 5, dim = 50, stopwords=stopwords)


embeddings <- as.matrix(model)
head(embeddings)

predict(model, c("criminal", "violent"), type = "nearest", top_n = 10)


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
