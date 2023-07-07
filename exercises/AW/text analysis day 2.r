# Text analysis day 2
#install.packages("word2vec")
library(word2vec)

cnn <- readRDS("data_raw/CNN_complete.Rds")
fox <- readRDS("data_raw/FOX_complete.Rds")

set.seed(123)

model50 <- word2vec(textdata$body, type = "cbow", window = 5, dim = 50) # includes automatic tokenization


embeddings50 <- as.matrix(model50)
head(embeddings50)

# predict nearest 5 words
prediction50 <- predict(model50, c("criminal", "violent"), type = "nearest", top_n = 5)


wv <- embeddings50["white", ] - embeddings50["person", ] + embeddings50["racism", ]
predict(model50, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model50, "mymodel50.bin")
model50 <- read.word2vec("mymodel50.bin")

######

model300 <- word2vec(textdata$body, type = "cbow", window = 5, dim = 300) # includes automatic tokenization


embeddings300 <- as.matrix(model300)
head(embeddings300)

# predict nearest 5 words
prediction300 <- predict(model300, c("criminal", "violent"), type = "nearest", top_n = 5)


wv <- embeddings300["white", ] - embeddings300["person", ] + embeddings300["racism", ]
predict(model300, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model300, "mymodel300.bin")
model300 <- read.word2vec("mymodel300.bin")


prediction300
prediction50

## fox
# training our 
modelfox <- word2vec(fox$body, type = "cbow", window = 5, dim = 50) # includes automatic tokenization
embeddingsfox <- as.matrix(modelfox)
prediction_fox <- predict(modelfox, c("criminal", "violent"), type = "nearest", top_n = 5)

# cnn 
modelcnn <- word2vec(cnn$body, type = "cbow", window = 5, dim = 50) # includes automatic tokenization
embeddingscnn <- as.matrix(modelcnn)
prediction_cnn <- predict(modelcnn, c("criminal", "violent"), type = "nearest", top_n = 5)


# read in other embeddings


# read in file with vectors that other people have obtained
# google
google_embeds <- read.word2vec("data_raw/GoogleNews-vectors-negative300.bin")

# british national corpus 
bnc_embeds <- read.word2vec("data_raw/model.bin") # british national  

# look at words that occur with criminal or violent in each embedding 
predict_google_embeds <-  predict(google_embeds, c("criminal", "violent"), type = "nearest", top_n = 5)
predict_model300 <-  predict(model300, c("criminal", "violent"), type = "nearest", top_n = 5)
predict_bnc <-  predict(bnc_embeds, c("criminal", "violent"), type = "nearest", top_n = 5)


# look at the word embeddings in different data sources e.g. how is criminal used in british national corpus
