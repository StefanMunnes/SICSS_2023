library(pacman)

p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots"
)

remotes::install_github("quanteda/quanteda.sentiment")

reviews <- readRDS("C:/Users/munnes/ownCloud/AF_Gruppe/LitInequalities/projects/nominees/data/pt_reviews.RDS")

textdata <- readRDS("sessions/Example_Data/Final/CNN_complete.Rds")



corpus <- corpus(textdata[1:10, ], text_field = "body")
head(summary(corpus))

tokens <- tokens(corpus) # easy tokens without pre-processing
head(tokens)

dfm <- dfm(tokens) # DFM, without pre-processing
head(dfm)
dim(dfm)

# most frequent words: see effect of no pre-processing
topfeatures(dfm, 10)
textstat_frequency(dfm, n = 10)


# pre-processing
stopwords("en")

tokens_pp <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE) |>
  tokens_wordstem(language = "en")

dfm_pp <- dfm(tokens_pp)
head(dfm_pp)
dim(dfm_pp)

# dfm_trim(min_termfreq = 0.2, termfreq_type = "prop")

textstat_frequency(dfm_pp, n = 15)

# keywords in context
kwic(tokens_pp, "polic")


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


# TF-IDF
tfifdf_pp <- dfm_tfidf(dfm_pp)

topfeatures(tfifdf_pp, n = 5, groups = docnames(tfifdf_pp))
topfeatures(dfm_pp, n = 5, groups = docnames(dfm_pp))

textstat_keyness(dfm, target = docvars(dfm, "article_length") < 4000) |>
  textplot_keyness()


# text
text <- "This is our new text. We try different variants."

tokens(text)

tokens(text, "sentence")
tokens(text, "character")


# what about special characters?
text <- "Gr8, you owe me just 1.000$ since 4ever #friends4life"

tokens(text, )




head(textstat_collocations(text), 15)


# ---- 2. create corpus, tokens, and dfm ----
corpus <- corpus(text_raw, text_field = "text")

summary(corpus)
corpus$year
corpus_subset()

tokens <- tokens(corpus, what = "word")

kwic(tokens, pattern = "immig*") # phrase("asylum seeker*")

topfreatures(dfm, 20)

dfm <- dfm(tokens)

dfm_group()


# ---- 3. most frequent words ----
dtm <- text_raw |>
  corpus(text_field = "review") |>
  tokens(
    what = "word",
    remove_punct = TRUE,
    remove_symbols = TRUE,
    remove_numbers = TRUE,
    remove_separators = TRUE,
    include_docvars = TRUE,
    verbose = TRUE
  ) |>
  tokens_wordstem(language = "en") |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE)


dfm_trim(min_termfreq = 0.2, termfreq_type = "prop")
# dfm_trim(quant_dfm, min_termfreq = 4, max_docfreq = 10)

# ---- 4. feature co-occurence matrix ----
fcm <- fcm(toks3, context = "window", window = 3)


# Create a feature co-occurrence matrix
fcmat_rev <- toks_rev %>%
  fcm(context = "window")

# keep the 40 top observations
feat <- names(topfeatures(fcmat_rev, 40))
fcmat_rev_subset <- fcmat_rev %>%
  fcm_select(feat)

textplot_network(fcmat_rev_subset)




dfm_tfidf()


# show just compound words (bigrams) with capital letters
toks_news_cap <- tokens_select(toks_news,
  pattern = "^[A-Z]",
  valuetype = "regex",
  case_insensitive = FALSE,
  padding = TRUE
)
textstat_collocations(toks_news_cap, min_count = 10, tolower = FALSE) |>
  head(15)


# ---- N-grams ----

# create n-grams of any length
tokens_ngrams(toks, n = 2:4)

# ? skip-grams

# create specific n-grams to keep
tokens_compound(tokens, pattern = prhase(c("New York City", "United States")))

toks_neg_bigram <- tokens_compound(toks, pattern = phrase("not *"))
tokens_select(toks_neg_bigram, pattern = phrase("not_*"))



# ---- show development of words over time ----
tokens_select(tokens, pattern = "violent*") |>
  dfm()


# ---- Dictionary: Sentiment ----



# --- Topic Model ----
quant_dfm <- tokens(
  data_corpus_irishbudget2010,
  remove_punct = TRUE,
  remove_numbers = TRUE
) |>
  tokens_remove(stopwords("en")) |>
  dfm()
quant_dfm <- dfm_trim(quant_dfm, min_termfreq = 4, max_docfreq = 10)

my_lda_fit20 <- stm(quant_dfm, K = 20, verbose = FALSE)
plot(my_lda_fit20)


dict <- dictionary(
  list(book = c("buch", "zeitung"), author = c("autor*", "rezensent*"))
)

a <- dfm_lookup(dfm, dict)

kwic(tokens, dict)

head(a)

dict_pol <- quanteda.sentiment::data_dictionary_HuLiu
dict_val <- quanteda.sentiment::data_dictionary_AFINN


dfm_dic <- dfm_lookup(dfm, dict_pol)

kwic(tokens, dict_pol)[1:10]



b <- convert(a, to = "data.frame")

b


# ---- topic models ----

tmod_lda <- textmodel_lda(dfm_pp, k = 10)

terms(tmod_lda, 10)

# topics(tmod_lda)


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
