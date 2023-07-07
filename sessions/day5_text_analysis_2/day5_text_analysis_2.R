library(word2vec)

textdata <- readRDS("data/CNN_complete.Rds")


model <- word2vec(textdata$body[100], type = "cbow", window = 5, dim = 50)


embeddings <- as.matrix(model)
head(embeddings)

predict(model, c("criminal", "violent"), type = "nearest", top_n = 5)


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
