library(tidyverse)
library(ggplot2)

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

save_path = "/Users/yunchaewon/sicss-berlin/ai_hype/clean_NYT_448.Rds"
nyt_articles <- readRDS(file=save_path, refhook = NULL)

# Number of articles acros time
nyt_plot <- ggplot(nyt_articles, aes(x = date)) +
  geom_histogram(stat = "count", fill = "steelblue") +
  labs(x = "Date", y = "Number of Observations") +
  theme_minimal() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2022-11-30"), y = 2.5, 
           label = "Introduction Chat GPT", vjust = -0.5, hjust = 0, angle = 90)

print(nyt_plot)


# preprocessing

corpus <- corpus(nyt_articles, text_field = "body")
#head(summary(corpus))

stopwords("en")

tokens_nyt <- tokens(
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

dfm_nyt <- dfm(tokens_nyt)
head(dfm_nyt)
dim(dfm_nyt)

dfm_trim(dfm_nyt, min_termfreq = 2, termfreq_type = "count") |>
  dim()

textstat_frequency(dfm_nyt, n = 15)

# TF-IDF
tfifdf_nyt <- dfm_tfidf(dfm_nyt)

# N-grams
textstat_collocations(tokens_nyt) |>
  head(15)
