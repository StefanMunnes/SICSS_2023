remotes::install_github("quanteda/quanteda.sentiment")

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)

library(dplyr)
library(tidyverse)
library(stringr)
library(lubridate)
library(ggplot2)

# load text data
textdata_cnn <- readRDS("data/CNN_complete.Rds")
textdata_fox <- readRDS("data/FOX_complete.Rds")

#correct dates before merging
#date variable
print(textdata_fox$timestamp)
print(textdata_cnn$timestamp)
regex <- "\\n.*(Updated|Published)\\n.*,\\s([A-Z][a-z][a-z])\\s(.*)\\n\\s+"

textdata_cnn <- textdata_cnn %>%
  tidyr::extract(col = timestamp, 
                 into = c("updated", "weekday", "date"), 
                 regex = regex,
                 remove = TRUE)

# Alternative using stringr
textdata_cnn <- textdata_cnn %>%
  mutate(updated = str_extract(
    timestamp,
    regex,
    group = 1),
    weekday =  str_extract(
      timestamp,
      regex,
      group = 2),
    date = str_extract(
      timestamp,
      regex,
      group = 3)) 

# Date format
textdata_cnn <- textdata_cnn %>%
  mutate(date = parse_date(date, "%B %d, %Y",
                           locale = locale("en")))

#dates for fox news
textdata_fox$timestamp <- gsub("\\s+", " ", str_trim(textdata_fox$timestamp))

textdata_fox <- str_split_fixed(textdata_fox$timestamp, ",", 3) %>% 
  data.frame() %>% 
  rename(date = X1, year = X2) %>% 
  cbind(textdata_fox, .)

textdata_fox <- str_split_fixed(textdata_fox$hour, " ", 3) %>% 
  data.frame() %>% 
  rename(year = X1, hour = X2) %>% 
  cbind(textdata_fox, .)

textdata_fox$date <- paste(textdata_fox$year, textdata_fox$hour)

#turn into a date variable
textdata_fox$date2 <- as.Date(textdata_fox$date,
                              format = "%B %d %Y")

textdata_fox <- textdata_fox[,-7:-9]

colnames(textdata_fox)[7] <- "date"

names(textdata_fox)

textdata_cnn <- textdata_cnn[,-3:-4]
textdata_fox <- textdata_fox[,-6]
textdata_fox <- textdata_fox[,c(1,2,6,3,4,5)]

textdata <- rbind(textdata_cnn, textdata_fox)

textdata2 <- rbind(textdata_cnn[1:100,], textdata_fox[1:100,])


#TEXT ANALYSIS PART
#1. load and inspect the whole corpus (documents, dimensions, tokens, types)
#for Fox and CNN separat
corpus <- corpus( textdata2,
  docid_field = "url",
  text_field = "body")

head(summary(corpus)) 

tokens <- tokens(corpus) # easy tokens without pre-processing
head(tokens)

dfm <- dfm(tokens) # DFM, without pre-processing
head(dfm)
dim(dfm)

#2. use different pre-processing strategies and compare results
topfeatures(dfm, 10)
textstat_frequency(dfm, n = 10)

#remove stopwords, symbols and extra characters? (I think, not sure)
stopwords("en")

tokens_pp <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE) |> #padding means remove the tokens and enters just the empty place holder
  tokens_wordstem(language = "en")

dfm_pp <- dfm(tokens_pp)
head(dfm_pp)
dim(dfm_pp)

#this code trims the document-feature matrix dfm_pp by removing terms that
#have a frequency less than 2, based on the count of occurrences. 
#Then it calculates and returns the dimensions of the resulting matrix
dfm_trim(dfm_pp, min_termfreq = 2, termfreq_type = "count") |>
  dim()

#3. show most important compound and co-occuring words
# keywords, most frequent words
textstat_frequency(dfm_pp, n = 15)

#for co-occurence
textstat_collocations(tokens_pp) |>
  head(15)


fcm_pp <- fcm(tokens_pp, context = "window", count = "frequency", window = 3)
dim(fcm_pp)

topfeatures(fcm_pp)

fcm_pp_subset <- fcm_select(fcm_pp, names(topfeatures(fcm_pp, 40)))

textplot_network(fcm_pp_subset)

#4. extract important keywords
# keywords, most frequent words
textstat_frequency(dfm_pp, n = 15)

# TF-IDF
tfifdf_pp <- dfm_tfidf(dfm_pp)

topfeatures(tfifdf_pp, n = 5, groups = docnames(tfifdf_pp))
topfeatures(dfm_pp, n = 5, groups = docnames(dfm_pp))

# keyness
textstat_keyness(dfm, target = 1:5) |> # docvars(dfm, "article_length") < 4000
  textplot_keyness()

convert(fcm_pp, to = "data.frame") |>
  dplyr::select(doc_id, "twitter") |>
  dplyr::filter(twitter > 0) |>
  dplyr::arrange(desc(twitter))


#5- over time
corpus <- corpus(textdata2,
                  docid_field = "url",
                  text_field = "body")
head(summary(corpus)) 




#dictionary part 1
#preparing the data
corpus <- corpus( textdata2,
                  docid_field = "url",
                  text_field = "body")

head(summary(corpus)) 

tokens <- tokens(corpus) # easy tokens without pre-processing
head(tokens)

dfm <- dfm(tokens) # DFM, without pre-processing
head(dfm)
dim(dfm)

#remove stopwords, symbols and extra characters? (I think, not sure)
stopwords("en")

tokens_pp <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE) |> #padding means remove the tokens and enters just the empty place holder
  tokens_wordstem(language = "en")

dfm_pp <- dfm(tokens_pp)
head(dfm_pp)
dim(dfm_pp)

#this code trims the document-feature matrix dfm_pp by removing terms that
#have a frequency less than 2, based on the count of occurrences. 
#Then it calculates and returns the dimensions of the resulting matrix
dfm_trim(dfm_pp, min_termfreq = 2, termfreq_type = "count")

#apply dictionary
dict_pol <- data_dictionary_HuLiu

dfm_lookup(dfm_pp, dict_pol) #negative, positive and neutral dictionaries
textstat_polarity(dfm_pp, dict_pol)

sent_score <- textstat_valence(dfm_pp, data_dictionary_AFINN) #how different the words on the positive and negative scales are scaled
colnames(sent_score)[1] <- "url"
textdata2 <- merge(textdata2, sent_score, by="url")







#######stefan's code

# create corpus, tokens and dfm (just first ten documents)
corpus <- corpus(textdata[1:100, ], text_field = "body") #this takes first 100 rows of text
head(summary(corpus)) 

tokens <- tokens(corpus) # easy tokens without pre-processing
head(tokens)

dfm <- dfm(tokens) # DFM, without pre-processing
head(dfm)
dim(dfm)


# most frequent words: see effect of no pre-processing
topfeatures(dfm, 10)
textstat_frequency(dfm, n = 10)



# ---- pre-processing ----

stopwords("en")

tokens_pp <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE) |> #padding means remove the tokens and enters just the empty place holder
  tokens_wordstem(language = "en")

dfm_pp <- dfm(tokens_pp)
head(dfm_pp)
dim(dfm_pp)


dfm_trim(dfm_pp, min_termfreq = 2, termfreq_type = "count") |>
  dim()



# ---- Keywords, tf-idf, and keyness ----

# keywords, most frequent words
textstat_frequency(dfm_pp, n = 15)

# TF-IDF
tfifdf_pp <- dfm_tfidf(dfm_pp)

topfeatures(tfifdf_pp, n = 5, groups = docnames(tfifdf_pp))
topfeatures(dfm_pp, n = 5, groups = docnames(dfm_pp))

# keyness
textstat_keyness(dfm, target = 1:5) |> # docvars(dfm, "article_length") < 4000
  textplot_keyness()



# ---- Context, n-grams, and feature co-occurrence matrix ----

# N-grams
textstat_collocations(tokens_pp) |>
  head(15)

# create n-grams of any length
tokens_ngrams(tokens("This is a beautiful test sentence"), n = 2:3)

# create specific n-grams to keep
tokens_compound(tokens("I want to live in New York City."),
  pattern = phrase(c("New York City", "United States"))
)

tokens_compound(tokens("This movie was not good."), pattern = phrase("not *")) #combines tokens


kwic(tokens_pp, "rezensent*", window = 3) #how often a token rezensent appears in the text and 3 words before and after it


fcm_pp <- fcm(tokens_pp, context = "window", count = "frequency", window = 3)
dim(fcm_pp)

topfeatures(fcm_pp)

fcm_pp_subset <- fcm_select(fcm_pp, names(topfeatures(fcm_pp, 40)))

textplot_network(fcm_pp_subset)



convert(fcm_pp, to = "data.frame") |>
  dplyr::select(doc_id, "twitter") |>
  dplyr::filter(twitter > 0) |>
  dplyr::arrange(desc(twitter))



# ---- sentiment analysis ----

dict_pol <- data_dictionary_HuLiu

dfm_lookup(dfm_pp, dict_pol) #negative, positive and neutral dictionaries
dfm_lookup(dfm_pp, dict_pol)
textstat_polarity(dfm_pp, dict_pol)

textstat_valence(dfm_pp, data_dictionary_AFINN) #how different the words on the positive and negative scales are scaled



# ---- topic models ----

tmod_lda <- textmodel_lda(dfm_pp, k = 3) #k defines number of topics your want to extract

terms(tmod_lda, 10) #you get 10 most frequent terms in the text

topics(tmod_lda)



# ---- classifier: NB ----

# 1. get training set
dfmat_train <- dfm(c("positive bad negative horrible", "great fantastic nice"))
class <- c("neg", "pos")

# 2. train model
tmod_nb <- textmodel_nb(dfmat_train, class)

# 3. get unlabelled test set
dfmat_test <- dfm(c(
  "bad horrible negative awful",
  "nice bad great",
  "great fantastic"
))

# 4. predict class
predict(tmod_nb, dfmat_test, force = TRUE)
