install.packages("word2vec")

library(word2vec)


setwd("C:/Users/nicol/Dropbox (Personal)/Work/03 Statistics/02 Methods literature and example code/Computational Social Science/SICSS Berlin/SICSS_2023/exercises/nicolekapelle") 
getwd()

textdata <- readRDS("./day 4/CNN_complete.Rds") 

model <- word2vec(textdata$body, type = "cbow", window = 5, dim = 50)


embeddings <- as.matrix(model)
head(embeddings)

predict(model, c("criminal", "violent"), type = "nearest", top_n = 5)


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
