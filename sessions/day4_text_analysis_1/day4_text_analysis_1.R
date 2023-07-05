remotes::install_github("quanteda/quanteda.sentiment")

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)


# load text data
textdata <- readRDS("data/CNN_complete.Rds")


# create corpus, tokens and dfm (just first ten documents)
corpus <- corpus(textdata[1:100, ], text_field = "body")
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
  tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
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

tokens_compound(tokens("This movie was not good."), pattern = phrase("not *"))


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

dfm_lookup(dfm_pp, dict_pol)
dfm_lookup(dfm_pp, dict_pol)
textstat_polarity(dfm_pp, dict_pol)

textstat_valence(dfm_pp, data_dictionary_AFINN)



# ---- topic models ----

tmod_lda <- textmodel_lda(dfm_pp, k = 3)

terms(tmod_lda, 10)

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
