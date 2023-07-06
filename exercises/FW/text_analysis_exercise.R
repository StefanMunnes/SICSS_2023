# SICSS Berlin - Day 4 - July 6, 2023
# Text Analysis - Exercise - FW

# ---- Exercise I ----
library(tidyverse)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)
library(lubridate)
#1. load and inspect the whole corpus (documents, dimensions, tokens, types) -----

setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin")
CNN_complete <- readRDS("~/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/CNN_complete.Rds")
FOX_complete <- readRDS("~/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/FOX_complete.Rds")

CNN_complete$type <- "CNN"
FOX_complete$type <- "FOX"

# clean timestamp
CNN_complete$date <- str_extract(CNN_complete$timestamp, "(\\w+\\s\\d+,\\s\\d{4})")
CNN_complete$date <- as.Date(CNN_complete$date, format = "%B %d, %Y")
CNN_complete$timestamp <- NULL

FOX_complete$date <- str_extract(FOX_complete$timestamp, '\\s+(.*\\d{4})', group=1)
FOX_complete$date <- as.Date(FOX_complete$date, format = "%B %d, %Y")
FOX_complete$timestamp <- NULL

textdata <- bind_rows(CNN_complete, FOX_complete)

# create corpus, tokens and dfm (just first ten documents)
corpus <- corpus(textdata, text_field = "body")
head(summary(corpus))

tokens <- tokens(corpus) # easy tokens without pre-processing
head(tokens)

dfm <- dfm(tokens)
head(dfm)
dim(dfm)

topfeatures(dfm, 10)
textstat_frequency(dfm, n = 10)

#2. use different pre-processing strategies and compare results ------

stopwords("en")

tokens_pp <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en")) |> # show padding
  tokens_wordstem(language = "en") 

#tokens_pp <- tokens_keep(tokens_pp, nchar(tokens_pp) >= 1)

dfm_pp <- dfm(tokens_pp)
head(dfm_pp)
dim(dfm_pp)

topfeatures(dfm_pp, 10)
textstat_frequency(dfm_pp, n = 10)

dfm_trim(dfm_pp, min_termfreq = 2, termfreq_type = "count") |>
  dim()
#3. show most important compound and co-occuring words -----

fcm_pp <- fcm(tokens_pp, context = "window", count = "frequency", window = 3)
dim(fcm_pp)

topfeatures(fcm_pp)


fcm_pp_subset <- fcm_select(fcm_pp, names(topfeatures(fcm_pp, 40)))

textplot_network(fcm_pp_subset)

convert(fcm_pp, to = "data.frame") |>
  dplyr::select(doc_id, type)

#4. extract important keywords -----
# keywords, most frequent words
textstat_frequency(dfm_pp, n = 15)

# TF-IDF
tfifdf_pp <- dfm_tfidf(dfm_pp)

topfeatures(tfifdf_pp, n = 10, groups = type)
topfeatures(dfm_pp, n = 5, groups = docnames(dfm_pp))

# keyness
textstat_keyness(dfm, target = 1:5) |> # docvars(dfm, "article_length") < 4000
  textplot_keyness()


# ---- Exercise II ----


#Decide as team which task you want to start with:
#  1. dictionary: sentiment over time, grouped by newspaper

dict_pol <- data_dictionary_HuLiu

dfm_lookup(dfm_pp, dict_pol)
dfm_lookup(dfm_pp, dict_pol)
textstat_polarity(dfm_pp, dict_pol)

polarity_scores <- dfm_pp |>
  textstat_polarity(dictionary = dict_pol)

new_data <- cbind(textdata, polarity_scores)

# Plot polarity scores across the 'type' variable
plot <- ggplot(new_data, aes(x = type, y = sentiment)) +
  geom_boxplot()
print(plot)

plot_time <- ggplot(subset(new_data, date > as.Date("2018-01-01")), aes(x = date, y = sentiment, colour = type)) +
  geom_point() +
  scale_x_date(date_labels = "%Y-%m-%d") +
  geom_smooth() +
  labs(x="Date", y="Polarity")

print(plot_time)
#Are there differences using TF-IDF? Why? Try different Dictionaries.
#2. topic modeling: find topics and show how they appear in the corpus
#3. Bonus: try the seeded LDA or stm topic modeling approach