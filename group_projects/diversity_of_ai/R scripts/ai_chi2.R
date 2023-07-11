## Chi2 ##

library(tidyverse)
library(ggplot2)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)
setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/ai_diversity")

# ---- Combine Datasets ---- #

fb <- read.csv("ai_fb_clean", comment.char="#")
fb$body <- fb$text
fox <- read.csv("ai_fox_clean.csv")

fb$date <- as.Date(fb$date)
fox$date <- as.Date(fox$date)

fb2 <- subset(fb, select = c("body", "date"))
fb2$type <- "fb"
fox2 <- subset(fox, select = c("body", "date"))
fox2$type <- "fox"

data <- rbind(fb2, fox2)


# ---- Create Corpus ---- #
# options for corpus: fox2, fb2, data (combines both)

corpus <- corpus(fox2, text_field = "body")

# subset to create gpt variable
corpus_subset1 <- corpus_subset(corpus, date <= as.Date("2022-11-30"))
corpus_subset2 <- corpus_subset(corpus, date > as.Date("2022-11-30"))

docvars(corpus_subset1, "gpt") <- "Before November 30, 2022"
docvars(corpus_subset2, "gpt") <- "After November 30, 2022"

corpus <- c(corpus_subset1, corpus_subset2)

# tokenise
stopwords("en")

tokens <- tokens(
  corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_compound(pattern = phrase("not *")) |>
  tokens_remove(stopwords("en")) |> 
  tokens_wordstem(language = "en") |>
  tokens_compound(pattern = phrase("artifici intellig")) |>
  tokens_compound(pattern = phrase("machin learn")) |>
  tokens_compound(pattern = phrase("social media")) |>
  tokens_compound(pattern = phrase("fox news")) |>
  tokens_compound(pattern = phrase("generat ai"))

dfmat <- dfm(tokens)

dfmat_key <- dfm_group(dfmat, groups=gpt)

# calculate features that occur differentially across different categories
tstat_key <- textstat_keyness(dfmat_key,
                              target = "After November 30, 2022") 
tplot_key <- textplot_keyness(tstat_key,
                              margin = 0.2,
                              n = 20,
                              color = c("#291A32", "#DB6E59"))
tplot_key
