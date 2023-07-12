## TOPIC MODEL ##

library(tidyverse)
library(tidytext)
library(ggplot2)
library(stm)
library(reshape2)
library(ggplot2)
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

docvars(corpus_subset1, "gpt") <- 0
docvars(corpus_subset2, "gpt") <- 1 # after introduction

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
                       prevalence=~gpt+s(date),
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
td_beta$topic <- factor(td_beta$topic, levels = c("1", "2", "3", "4", "5",
                                                  "6", "7", "8", "9", "10"),
                        labels = c("Space Application", "ChatGPT", "Regulation", 
                                   "AI Reception", "Developers", "Education", 
                                   "Healthcare Application", "AI Outlook",
                                   "Creative Application", "Industry"))

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

# distribution and top 5 words per topic
plot.STM(stm_object5.1, "summary", n=7, topic.names=c("Space Application:", "ChatGPT:", "Regulation:", 
                                                      "AI Reception:", "Developers:", "Education:", 
                                                      "Healthcare Application:", "AI Outlook:",
                                                      "Creative Application:", "Industry:"))

# glimpse at highly representative documents per each topic



topic1 <- findThoughts(stm_object5.1,texts=fb$Message, topics=10, n=10)$docs[[1]]
plotQuote(topic1, width=100, maxwidth=400, text.cex=1.25 
          )

plot.STM(stm_object5.1, "labels", labeltype="frex", n=10, width=50,
         main = "Words by Frequency and Exclusivity to the Topic",
         topic.names=c("Space Application:", "ChatGPT:", "Regulation:", 
                       "AI Reception:", "Developers:", "Education:", 
                       "Healthcare Application:", "AI Outlook:",
                       "Creative Application:", "Industry:"))#top 10 FREX words per topics 5-6-9
# FREX weights words by frequency and exclusivity to the topic
#lift words (frequency divided by frequency in other topics)
#score (similar to lift, but with log frequencies)



# METADATA visualisation

# OVER TIME

dt <- make.dt(stm_object5.1, meta=dfm_stm$meta)

topics <- c("Topic1", "Topic2", "Topic3", "Topic4", "Topic5", "Topic6", "Topic7",
                           "Topic8", "Topic9", "Topic10")

plot_list <- list()
for (i in topics){
  plot <-  ggplot(dt, aes(date, i)) +
    geom_smooth()
  plot_list[[i]] = plot
}

library("ggpubr")


p1 <- ggplot(dt, aes(date, Topic1)) +
  geom_smooth() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p2 <- ggplot(dt, aes(date, Topic2)) +
  geom_smooth() +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p3 <- ggplot(dt, aes(date, Topic3)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p4 <- ggplot(dt, aes(date, Topic4)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p5 <- ggplot(dt, aes(date, Topic5)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p6 <- ggplot(dt, aes(date, Topic6)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p7 <- ggplot(dt, aes(date, Topic7)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p8 <- ggplot(dt, aes(date, Topic8)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p9 <- ggplot(dt, aes(date, Topic9)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
p10 <- ggplot(dt, aes(date, Topic10)) +
  geom_smooth()+
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")

figure <- ggarrange(p1, p2, p3, p4,p5,p6,p7,p8,p9,p10,
                    labels = c("Space Application:", "ChatGPT:", "Regulation:", 
                               "AI Reception:", "Developers:", "Education:", 
                               "Healthcare Application:", "AI Outlook:",
                               "Creative Application:", "Industry:"))
figure


df <- subset(dt, select = c("Topic1", "Topic2", "Topic3", "Topic4", "Topic5", "Topic6", "Topic7",
                            "Topic8", "Topic9", "Topic10"))

d <- colnames(df)[max.col(df, ties.method = "first")]

df <- cbind(dt, data.frame(d))

df %>% 
  mutate(date = as.Date(date)) %>%
  group_by(date, d) %>%
  summarise(Count = n()) %>%
  ggplot(aes(x = date, y = Count, color=d, group=d)) +
  geom_smooth(se = T) +
  scale_colour_discrete(labels=c("Space Application", "ChatGPT", "Regulation", 
            "AI Reception", "Developers", "Education", 
            "Healthcare Application", "AI Outlook",
            "Creative Application", "Industry"), name="Topic (Fb)") +
  geom_vline(xintercept = as.numeric(as.Date("2022-11-30")), linetype = "dashed", color = "red")
  
