# Exercise day 4
# load and inspect the whole corpus (documents, dimensions, tokens, types)
# use different pre-processing strategies and compare results
# show most important compound and co-occuring words
# extract important keywords
# Bonus: check, if keywords differ over time and between groups
# (e.g. newspaper, authors gender, division, ...)

#install.packages("remotes")
#install.packages("pacman")

#remotes::install_github("quanteda/quanteda.sentiment")

pacman::p_load("quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda", "tidyverse")

# load and inspect the whole corpus (documents, dimensions, tokens, types)
setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()

cnn_data <- readRDS("./day 4/CNN_complete.Rds") 
fox_data <- readRDS("./day 4/FOX_complete.Rds") 

# We need to drop article_length from FOX dataset
fox_data <- fox_data %>% 
  select(-article_length)

# Add identifier for dataset
cnn_data$newspaper <- "CNN"
fox_data$newspaper <- "FOX"

data_combined <- rbind(cnn_data, fox_data)

corpus <- corpus(data_combined, text_field = "body") 
head(summary(corpus))

tokens <- tokens(corpus)

tokens <- tokens(
  corpus,
  what = "word",
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_wordstem(language = "en") |>
  tokens_remove(stopwords("en"), padding = TRUE)


dfm <-dfm(tokens)
dfm

types <- head(summary(corpus))

# show most important compound and co-occuring words
collocation <- textstat_collocations(tokens, min_count = 5, size = 3)

topfeatures(dfm, 10)
textstat_frequency(dfm, n = 10)

# extract important keywords
# Bonus: check, if keywords differ over time and between groups
# (e.g. newspaper, authors gender, division, ...)



# topic modeling: find topics and show how they appear in the corpus

tmod_lda <- textmodel_lda(dfm, k = 5)

terms(tmod_lda, 10)

topics(tmod_lda)


# dictionary: sentiment over time, grouped by newspaper Are there differences using TF-IDF? Why? Try different Dictionaries.

dict_pol <- data_dictionary_HuLiu

dfm_lookup(dfm, dict_pol)

polarity <- textstat_polarity(dfm, dict_pol)

valence <- textstat_valence(dfm, data_dictionary_AFINN)

combined <- cbind(data_combined, polarity)
combined <- rename(combined, polarity = sentiment)
combined <- select(combined, -doc_id)
combined <- cbind(combined, valence)
combined <- rename(combined, valence = sentiment)


