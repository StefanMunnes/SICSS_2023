## DESCRIPTIVE STATS ##

library(tidyverse)
library(ggplot2)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)
setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/ai_diversity")

# ---- 1. Facebook ---- #

fb <- read.csv("ai_fb_clean", comment.char="#")
fox <- read.csv("ai_fox_clean.csv")

# plot across time
fb$date <- as.Date(fb$date)
fox$date <- as.Date(fox$date)

fb_plot <- ggplot(fb, aes(x = date)) +
  geom_histogram(stat = "count", bins = "auto", fill = "steelblue") +
  labs(x = "Date", y = "Number of Observations") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 200, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(fb_plot)

fox_plot <- ggplot(fox, aes(x = date)) +
  geom_histogram(stat = "count", fill = "steelblue") +
  labs(x = "Date", y = "Number of Observations") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 2.5, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(fox_plot)


## Sentiment Analysis FB

corpus <- corpus(fb, text_field = "text")
#head(summary(corpus))

stopwords("en")

tokens_fb <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_compound(pattern = phrase("not *")) |>
  tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
  tokens_wordstem(language = "en") |>
  tokens_compound(pattern = phrase("artifici intellig")) |>
  tokens_compound(pattern = phrase("machin learn")) |>
  tokens_compound(pattern = phrase("social media")) |>
  tokens_compound(pattern = phrase("generat ai"))

dfm_fb <- dfm(tokens_fb)
head(dfm_fb)
dim(dfm_fb)

dfm_trim(dfm_fb, min_termfreq = 2, termfreq_type = "count") |>
  dim()

textstat_frequency(dfm_fb, n = 15)

# TF-IDF
tfifdf_fb <- dfm_tfidf(dfm_fb)

# N-grams
textstat_collocations(tokens_fb) |>
  head(15)

# ---- sentiment analysis ----

dict_pol <- data_dictionary_HuLiu

#dfm_lookup(dfm_fb, dict_pol)
polarity_scores <- dfm_fb |>
  textstat_polarity(dictionary = dict_pol)
fb <- cbind(fb, polarity_scores)

#textstat_valence(dfm_pp, data_dictionary_AFINN)

# plot sentiment
fb_sent <- ggplot(fb) +
  geom_line(aes(x = date, y = sentiment), color = "steelblue") +
  geom_smooth(aes(x = date, y = sentiment), method = "loess", se = FALSE, color = "red") +
  labs(x = "Date", y = "Sentiment") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 1, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(fb_sent)

## Sentiment Analysis FOX

corpus <- corpus(fox, text_field = "title")
#head(summary(corpus))

stopwords("en")

tokens_fox <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_compound(pattern = phrase("not *")) |>
  tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
  tokens_wordstem(language = "en") |>
  tokens_compound(pattern = phrase("artifici intellig")) |>
  tokens_compound(pattern = phrase("fox news")) |>
  tokens_compound(pattern = phrase("social media")) |>
  tokens_compound(pattern = phrase("machin learn"))

dfm_fox <- dfm(tokens_fox)
head(dfm_fox)
dim(dfm_fox)

dfm_trim(dfm_fox, min_termfreq = 2, termfreq_type = "count") |>
  dim()

textstat_frequency(dfm_fox, n = 15)

# TF-IDF
tfifdf_fox <- dfm_tfidf(dfm_fox)

# N-grams
textstat_collocations(tokens_fox) |>
  head(15)

# ---- sentiment analysis ----

dict_pol <- data_dictionary_HuLiu

#dfm_lookup(dfm_fb, dict_pol)
polarity_scores <- dfm_fox |>
  textstat_polarity(dictionary = dict_pol)
fox <- cbind(fox, polarity_scores)

#textstat_valence(dfm_pp, data_dictionary_AFINN)

# plot sentiment
fox_sent <- ggplot(fox) +
  geom_line(aes(x = date, y = sentiment), color = "steelblue") +
  geom_smooth(aes(x = date, y = sentiment), method = "loess", se = FALSE, color = "red") +
  labs(x = "Date", y = "Sentiment") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 1, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(fox_sent)

