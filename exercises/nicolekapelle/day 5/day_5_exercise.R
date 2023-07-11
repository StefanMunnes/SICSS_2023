#1. train your own word embeddings on the whole news article corpus
#     pre-process data, choose architecture and hyperparameter
#     additional: train separate by newspaper
library(word2vec)


setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()

textdata <- readRDS("./day 4/CNN_complete.Rds") 

model <- word2vec(textdata$body, type = "cbow", window = 5, dim = 50) # training the dataset
embeddings <- as.matrix(model) # extracting embeddings and saving into matrix
head(embeddings) # show first couple of embeddings

predict(model, c("criminal", "violent"), type = "nearest", top_n = 5) # give our top 5 words that are closest to "criminal" and "violent" based on our embeddings


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")

#download pre-trained word embeddings (check parameter)
google_embeds <- read.word2vec("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/GoogleNews-vectors-negative300.bin")
#compare the most similar words for some important keywords

#discuss possible differences: method or content?