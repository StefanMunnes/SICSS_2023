# Analysis for The Guardian Articles ----

library(tidyverse)
library(ggplot2)

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

guardian <- read.csv("./ai_guardian_clean.csv")

# plot across time ----
guardian$date <- as.Date(guardian$timestamp)

guardian_plot <- ggplot(guardian, aes(x = date)) +
  geom_histogram(stat = "count", bins = "auto", fill = "steelblue") +
  labs(x = "Date", y = "Number of Observations") +
  theme_minimal() +
  theme(text = element_text(size=10),
        axis.text.x = element_text(size=8),
        axis.text.y = element_text(size=8),
        axis.title.x = element_text(size=8),
        axis.title.y = element_text(size=8)) +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 5, 
           label = "Introduction Chat GPT", angle = 90, vjust = -0.5, hjust = 0, size=2)

print(guardian_plot)
ggsave("guardian_frequency_plot.png", width = 5, height = 3, path = "../figures", dpi=700, bg = 'white')

# Sentiment Analysis for The Guardian ----

corpus <- corpus(guardian, text_field = "body")
#head(summary(corpus))

stopwords("en")

tokens_guardian <- tokens(
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

dfm_guardian <- dfm(tokens_guardian)
head(dfm_guardian)
dim(dfm_guardian)

dfm_trim(dfm_guardian, min_termfreq = 2, termfreq_type = "count") |>
  dim()

textstat_frequency(dfm_guardian, n = 15)

# TF-IDF
tfifdf_guardian <- dfm_tfidf(dfm_guardian)

# N-grams
textstat_collocations(tokens_guardian) |>
  head(15)

# ---- sentiment analysis ----

#remotes::install_github("quanteda/quanteda.sentiment")
library(quanteda.sentiment)
dict_pol <- data_dictionary_HuLiu

#dfm_lookup(dfm_guardian, dict_pol)
polarity_scores <- dfm_guardian |>
  textstat_polarity(dictionary = dict_pol)
guardian <- cbind(guardian, polarity_scores)

#textstat_valence(dfm_pp, data_dictionary_AFINN)

# plot sentiment
guardian_sent <- ggplot(guardian) +
  geom_line(aes(x = date, y = sentiment), color = "steelblue") +
  geom_smooth(aes(x = date, y = sentiment), method = "loess", se = FALSE, color = "red") +
  labs(x = "Date", y = "Sentiment") +
  theme_minimal() +
  theme(text = element_text(size=10),
        axis.text.x = element_text(size=8),
        axis.text.y = element_text(size=8),
        axis.title.x = element_text(size=8),
        axis.title.y = element_text(size=8)) +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 1, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90, size=2)

print(guardian_sent)

ggsave("guardian_sentiment_plot.png", width = 5, height = 3, path = "../figures", dpi=700, bg = 'white')





