## TOPIC MODEL ##

library(tidyverse)
library(ggplot2)
library(stm)
library(reshape2)
pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda"
)
setwd("/Users/fwagner/Library/Mobile Documents/com~apple~CloudDocs/Uni/CEU/summer schools/SICSS Berlin/ai_diversity")

# ---- 1. Facebook ---- #

fb <- read.csv("ai_fb_clean", comment.char="#")
fb$date <- as.Date(fb$date)

# create corpus

corpus <- corpus(fb, text_field = "text")

# subset to create gpt variable
corpus_subset1 <- corpus_subset(corpus, date <= as.Date("2022-11-30"))
corpus_subset2 <- corpus_subset(corpus, date > as.Date("2022-11-30"))

docvars(corpus_subset1, "gpt") <- "Before November 30, 2022"
docvars(corpus_subset2, "gpt") <- "After November 30, 2022"

corpus <- c(corpus_subset1, corpus_subset2)
summary(corpus)

# tokenize texts
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

# create a document-feature matrix
dfmat <- dfm(tokens)

trim_dfm <- dfm_trim(dfmat, min_count = 10, min_docfreq = 5)

#STM compatible document-feature matrix
dfm_stm <- convert(trim_dfm, to = "stm", docvars = docvars(corpus))

system.time(
  stm_object5.1 <- stm(documents = dfm_stm$documents, 
                       vocab = dfm_stm$vocab, 
                       data = dfm_stm$meta,
                       max.em.its = 100,
                       K = 10, 
                       #prevalence=~User.Name+Post.Created.Date+sentiment.norm,
                       seed = 12345)
)

plot(stm_object5.1, type="labels")
plot(stm_object5.1, type="perspectives", topics=c(3, 4))
plot(stm_object5.1,type="hist")

td_theta <- tidytext::tidy(stm_object5.1, matrix = "theta")

names(td_theta$document) <- dfmat$label
td_theta$document

selectiontdthteta<-td_theta[td_theta$document%in%c(1:30),] #select the first 30 documents. be careful to select a sensible interval, as attempting to load a very huge corpus might crash the kernel

thetaplot1<-ggplot(selectiontdthteta, aes(y=gamma, x=as.factor(topic), fill = as.factor(topic))) +
  geom_bar(stat="identity",alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ document, labeller = labeller(document = selectiontdthteta$document), ncol = 3) +
  labs(title = "Theta values per document",
       y = expression(theta), x = "Topic")

thetaplot1


# Visualisation

# Highest word probabilities per topic

# New facet label names for topic variable

td_beta <- tidytext::tidy(stm_object5.1) 
td_beta$topic <- factor(td_beta$topic, levels = c("1", "2", "3", "4", "5"),
                        labels = c("Government", "Economy", "Fuel", "Energy", "War"))

options(repr.plot.width=7, repr.plot.height=8, repr.plot.res=100) 
td_beta %>%
  group_by(topic) %>%
  top_n(9, beta) %>%
  ungroup() %>%
  mutate(topic = paste0("Topic ", topic),
         term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = as.factor(topic))) +
  geom_col(alpha = 0.8, show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, y = expression(beta),
       title = "Highest word probabilities for each topic",
       subtitle = "Different words are associated with different topics")
