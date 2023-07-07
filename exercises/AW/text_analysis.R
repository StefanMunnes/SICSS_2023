
rm(list = ls())

# Set paths
if(Sys.info()["user"] == "anicawaldendorf"){
  user = 1 # 1 = Anica
}
if(Sys.info()["user"] != "anicawaldendorf"){
  user = 2 # 2 = Code reviewer / co-author
}
if(user==1){
  data.folder <- "/Users/anicawaldendorf/Documents/EUI/SICSS/SICCS_personal/data_raw/"
  output.folder <- "/Users/anicawaldendorf/Documents/EUI/SICSS/SICCS_personal/data_processed/"
  pdf.folder <- "/Users/anicawaldendorf/Documents/EUI/SICSS/SICCS_personal/data_processed/pdf/"
  
}


setwd(data.folder)

remotes::install_github("quanteda/quanteda.sentiment")

pacman::p_load(
  "quanteda", "quanteda.textstats", "quanteda.textmodels",
  "quanteda.textplots", "quanteda.sentiment", "seededlda", "stringr", "dplyr", "lubridate", "ggplot2"
)


# load text data
cnn <- readRDS("CNN_complete.Rds")
fox <- readRDS("FOX_complete.Rds")

fox <- fox %>% dplyr::select(-article_length)


# clean data

cnn$timestamp
str_detect(cnn$timestamp, "Updated") == TRUE

cnn<- cnn%>%
  mutate(what= case_when(
    str_detect(cnn$timestamp, "Updated") == TRUE ~ "updated", 
    str_detect(cnn$timestamp, "Published") == TRUE ~ "published"))

table(cnn$what)

cnn$timestamp <- str_extract(cnn$timestamp, "(\\d+:\\d+.*)")

#cnn_clean$time <- str_extract(cnn_clean$timestamp, "^(.+?),")
#cnn_clean$time <- str_replace_all(cnn_clean$time , "," ,"")


#cnn$day <- str_extract(cnn$timestamp, "(Mon|Tue|Wed|Thu|Fri|Sat|Sun)")
cnn$date <- str_replace(cnn$timestamp, "^(.+?),", "") # extract the part that is the date
cnn$date <- str_replace(cnn$date, "(\\s...\\s)", "") #  remove white space and weekday

cnn$date <- mdy(cnn$date)


fox$timestamp
fox$date <- str_extract(fox$timestamp, "^([^\\d]+ \\d{1,2}, \\d{4})")
fox$date <- mdy(fox$date)
fox$what <- NA

fox$source <- "fox"
cnn$source <- "cnn"

textdata <- rbind(fox, cnn)

# create corpus, tokens and dfm (just first ten documents)
#corpus <- corpus(textdata[1:100, ], text_field = "body")

corpus <- corpus(textdata, text_field = "body")

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

# goes from 6398 to 3173 features 


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

textstat_keyness(dfm, target = 1:5) |> # docvars(dfm, "article_length") < 4000
  textplot_keyness(show_reference = FALSE)


######## one plot for fox, one for cnn 

source_dfm <- tokens(corpus, remove_punct = TRUE) %>%
  tokens_remove(stopwords("english")) %>%
  tokens_group(groups = source) %>%
  dfm()

keyness_split <- textstat_keyness(source_dfm, target = "fox") %>% textplot_keyness() 
keyness_split
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

### plot ####
table(corpus$source)
tokeninfo <- summary(corpus, n=3160)
tokeninfo$date <- docvars(corpus, "date")
plot_tokens_time <-ggplot(data = tokeninfo, aes(x = date, y = Tokens, group = 1)) +
  geom_line() + 
  geom_point() + 
 # scale_x_continuous(labels = c(seq(1789, 2017, 12)),
 #                    breaks = seq(1789, 2017, 12)) +
  facet_wrap(~source)
  theme_bw()



  features_dfm_inaug <- textstat_frequency(dfm_pp)#, n = 100)
  
  # Sort by reverse frequency order
  dfm_pp$feature <- with(features_dfm_inaug, reorder(feature, -frequency))
  
  ggplot(features_dfm_inaug, aes(x = feature, y = frequency)) +
    geom_point() + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1))


  
  
  
# ---- sentiment analysis ----

dict_pol <- data_dictionary_HuLiu

dict_results <- dfm_lookup(dfm_pp, dict_pol)

dfm_lookup(dfm_pp, dict_pol)
text_stat_pol_res <- textstat_polarity(dfm_pp, dict_pol)


textdata$doc_id <- seq.int(nrow(textdata))
textdata$doc_id <- paste0("text",textdata$docid)

info <- textdata %>% dplyr::select(date, source)
#text_stat_pol_res <- left_join(text_stat_pol_res, dates, by ="doc_id")
text_stat_pol_res <- cbind(text_stat_pol_res, info)


## try with TF IDF
text_stat_pol_res_tfidf <- textstat_polarity(tfifdf_pp, dict_pol)
text_stat_pol_res_tfidf <- cbind(text_stat_pol_res_tfidf, info)


tfidf_plot <- text_stat_pol_res_tfidf%>% filter(date >"2020-01-01") %>%
  ggplot(aes(x = date, y = sentiment , colour = source)) + 
  geom_point()+ 
  geom_smooth(aes(group=source))
labs(color  = "source", 
     x = "Date",
     y = "Sentiment")+ 
  theme_light()+
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text( size = 8, vjust = 0.5))


### Plot 
text_stat_pol_res%>% filter(date >"2020-01-01") %>%
  ggplot(aes(x = date, y = sentiment , colour = source)) + 
  geom_point()+ 
  geom_smooth(aes(group=source))
  labs(color  = "source", 
       x = "Date",
       y = "Sentiment")+ 
 theme_light()+
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text( size = 8, vjust = 0.5))

textstat_valence(dfm_pp, data_dictionary_AFINN)


#### Keyword search BLM ####

textdata$title <- tolower(textdata$title) 

textdata <- textdata %>% 
  mutate(BLM_flag= case_when(
   # str_detect(textdata$body, "blm") == TRUE ~ 1, 
    str_detect(textdata$title, "blm") == TRUE ~ 1, 
   # str_detect(textdata$body, "black lives matter") == TRUE ~ 1,
   str_detect(textdata$title, "black lives matter") == TRUE ~ 1,
    TRUE ~ 0 ))
table(textdata$BLM_flag)


#### plotting wordcloud #### 
set.seed(100)

textplot_wordcloud(dfm_pp)

textplot_wordcloud(dfm_pp, min_count = 6, random_order = FALSE, rotation = 0.25,
                   color = RColorBrewer::brewer.pal(8, "Dark2"))

textplot_wordcloud(dfm_pp, rotation = 0.25, 
                   color = rev(RColorBrewer::brewer.pal(10, "RdBu")))

col <- sapply(seq(0.1, 1, 0.1), function(x) adjustcolor("#1F78B4", x))
textplot_wordcloud(dfm_pp, adjust = 0.5, random_order = FALSE, 
                   color = col, rotation = FALSE)

# ---- topic models ----
rs <- sample_n(textdata, 1000)
table(rs$source)

rs_corpus <- corpus(rs, text_field = "body")

rs_tokens_pp <- tokens(
  rs_corpus,
  remove_punct = TRUE,
  remove_symbols = TRUE,
  remove_numbers = TRUE,
  remove_separators = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"), padding = TRUE) |> # show padding
  tokens_wordstem(language = "en")

rs_dfm_pp <- dfm(rs_tokens_pp)
head(rs_dfm_pp)
dim(rs_dfm_pp)


rs_dfm_pp <- dfm_trim(rs_dfm_pp, min_termfreq = 2, termfreq_type = "count") 


tmod_lda <- textmodel_lda(rs_dfm_pp, k = 3)

terms(tmod_lda, 10)

topics_res <- as.data.frame(topics(tmod_lda))
topics_res <- tibble::rownames_to_column(topics_res, "id")

# do sentiment analysis 
rs_dfm_pp_senti <- textstat_polarity(rs_dfm_pp, dict_pol)

rs_info <- rs %>% dplyr::select(date, source)
#text_stat_pol_res <- left_join(text_stat_pol_res, dates, by ="doc_id")
rs_dfm_pp_senti <- cbind(rs_dfm_pp_senti, rs_info)

rs_dfm_pp_senti_topic <- cbind(rs_dfm_pp_senti, topics_res)

names(rs_dfm_pp_senti_topic)

names(rs_dfm_pp_senti_topic)[names(rs_dfm_pp_senti_topic) == "topics(tmod_lda)"] <- "topics"

### Plot 
rs_dfm_pp_senti_topic%>% filter(date >"2020-01-01") %>%
  ggplot(aes(x = date, y = sentiment , colour = topics)) + 
  geom_point()+ 
  geom_smooth(aes(group=topics))+
labs(color  = "topics", 
     x = "Date",
     y = "Sentiment")+ 
  theme_light()+
  facet_wrap(~source)+
  geom_vline(xintercept = 2020-05-05,  colour = "black", linetype = "dashed")+
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        axis.text.x = element_text( size = 8, vjust = 0.5))
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
