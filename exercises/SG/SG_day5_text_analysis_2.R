library(word2vec)

textdata <- readRDS("CNN_complete.Rds")

library(quanteda)
stopwords("en")

textdata_pp$body[[1]]

model <- word2vec(textdata$body[1:100], type = "cbow", window = 5, dim = 50, stopwords = stopwords("en"))


embeddings <- as.matrix(model)
head(embeddings)

predict(model, c("criminal", "violent"), type = "nearest", top_n = 10)


wv <- embeddings["black", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
