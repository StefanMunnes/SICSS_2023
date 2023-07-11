##########################################################################################
#####################################################################################################################
# Project: SICSS project
# Date: 10.07.23
# Author(s): Anica 
#####################################################################################################################
#####################################################################################################################
# 0. Set-up
#####################################################################################################################
# clears the environment
rm(list = ls())
# load packages
# install package in case they are not installed - good for colab & cross-computer work
if( ! require( "pacman" , character.only = TRUE ) ){
  #  If package was not able to be loaded then re-install
  install.packages( "pacman" , dependencies = TRUE )
  #  Load package after installing
  require("pacman" , character.only = TRUE )
}
pacman::p_load(tidyverse, data.table, readxl, lubridate, pdftools, stringr) 
# Set paths
if(Sys.info()["user"] == "anicawaldendorf"){
  user = 1 # 1 = Anica
}
if(Sys.info()["user"] != "anicawaldendorf"){
  user = 2 # 2 = Code reviewer / co-author
}
if(user==1){
  data.folder <- "/Users/anicawaldendorf/Documents/EUI/SICSS/SICCS_personal/data_raw/factiva/"
  output.folder <- "/Users/anicawaldendorf/Documents/EUI/SICSS/SICCS_personal/results/"
 }

setwd(data.folder)

pdf1 <- pdftools::pdf_text(pdf = "Factiva-1-100.pdf")
pdf2 <- pdftools::pdf_text(pdf = "Factiva-101-200.pdf")
pdf3 <- pdftools::pdf_text(pdf = "Factiva-201-300.pdf")
pdf4 <- pdftools::pdf_text(pdf = "Factiva-301-400.pdf")
pdf5 <- pdftools::pdf_text(pdf = "Factiva-401-500.pdf")
pdf6 <- pdftools::pdf_text(pdf = "Factiva-501-600.pdf")
pdf7 <- pdftools::pdf_text(pdf = "Factiva-601-700.pdf")
pdf8 <- pdftools::pdf_text(pdf = "Factiva-701-800.pdf")
pdf9 <- pdftools::pdf_text(pdf = "Factiva-801-900.pdf")
pdf10 <- pdftools::pdf_text(pdf = "Factiva-901-1000.pdf")
pdf11 <- pdftools::pdf_text(pdf = "Factiva-1001-1100.pdf")
pdf12 <- pdftools::pdf_text(pdf = "Factiva-1101-1200.pdf")
pdf13 <- pdftools::pdf_text(pdf = "Factiva-1201-1300.pdf")
pdf14 <- pdftools::pdf_text(pdf = "Factiva-1301-1400.pdf")
pdf15 <- pdftools::pdf_text(pdf = "Factiva-1401-1500.pdf")
pdf16 <- pdftools::pdf_text(pdf = "Factiva-1501-1600.pdf")
pdf17 <- pdftools::pdf_text(pdf = "Factiva-1601-1700.pdf")

pdf <- c(pdf1, pdf2, pdf3, pdf4, pdf5, pdf6, pdf7, pdf8, pdf9, pdf10, pdf11, pdf12, pdf13, pdf14, pdf15, pdf16, pdf17)


# Each element in the character vector represents one page in the PDF. This is not necessarily one article
# So we collapse all elements into one big one and can then decide how we can split it into separate articles
merged_text <- paste(pdf, collapse = " ")

# the document number is the last piece of information for each article. all text before that number is one
# article so we can split along that
articles <- str_split(merged_text, "Document\\s.{25}", n = Inf)

# this gives us a nested list. We extract the first part of the list so we just have a list, not a nested list
first <- articles[[1]]
first[1]

# First step of cleaning: all texts have the page number and copyright. we delete this
first <- str_replace_all(first, "Page \\d+ of 214 © 2023 Factiva, Inc. All rights reserved." ,"")


# Information we want to get in the longrun 
# source
# date
# author? 
# Titel 
# identify last line to cut

# Create different subsets of data depending on the source
sz_online <- str_subset(first, "\nSüddeutsche Zeitung Online\n")  #SUDZEIT
sddz <- str_subset(first, "\nSDDZ\n") 
welt <- str_subset(first, "\nDie Welt\n") 
welt_online <- str_subset(first, "\nWELTON\n") 

zeit_online <- str_subset(first, "\nZEIT online\n") 
zeit <- str_subset(first, "\nZEIT online\n") # ZEITON
spon <- str_subset(first, "\nSpiegel Online\n")  # SPGLO
spiegel <- str_subset(first, "\nSPGL\n")  


## Süddetusche Zeitung Online
# convert character vector into dataframe
sz_online <- as.data.frame(sz_online)

# split the meta data from the main text. Last piece of information is usually the copyright.
sz_online <- sz_online %>%
  mutate(sz_online = str_split(sz_online, "\nCopyright \\d{4} sueddeutsche.de\n", simplify = FALSE)) %>% # 
  unnest_wider(sz_online, names_sep = "")

# rename the different columns
names(sz_online)[names(sz_online) == "sz_online1"] <- "meta"
names(sz_online)[names(sz_online) == "sz_online2"] <- "body"


## Süddeutsche Zeitung
sddz <- as.data.frame(sddz)

sddz <- sddz %>%
  mutate(sddz = str_split(sddz, "\nCopyright \\d{4} Süddeutsche Zeitung GmbH\n", simplify = FALSE)) %>% # 
  unnest_wider(sddz, names_sep = "")

names(sddz)[names(sddz) == "sddz1"] <- "meta"
names(sddz)[names(sddz) == "sddz2"] <- "body"


## spiegel
spiegel <- as.data.frame(spiegel)

spiegel <- spiegel %>%
  mutate(spiegel = str_split(spiegel, "\n(c) \\d{4} Der Spiegel\n", simplify = FALSE)) %>% 
  unnest_wider(spiegel, names_sep = "")

names(spiegel)[names(spiegel) == "spiegel1"] <- "meta"
names(spiegel)[names(spiegel) == "spiegel2"] <- "body"


## spon
spon <- as.data.frame(spon)

spon <- spon %>%
  mutate(spon = str_split(spon, "\\d{4} SPIEGEL net GmbH. All rights reserved.", simplify = FALSE)) %>% 
  unnest_wider(spon, names_sep = "")

names(spon)[names(spon) == "spon1"] <- "meta"
names(spon)[names(spon) == "spon2"] <- "body"


## taz 
taz <- str_subset(first, "taz - die tageszeitung\n") 

taz <- as.data.frame(taz)

taz <- taz %>%
  mutate(taz = str_split(taz, "\n(c) \\d{4} taz, die tageszeitung\n", simplify = FALSE)) %>% 
  unnest_wider(taz, names_sep = "")

names(taz)[names(taz) == "taz1"] <- "meta"
names(taz)[names(taz) == "taz2"] <- "body"


stringr::str_split(taz, "\n(c) \\d{4} taz, die tageszeitung\n", simplify = FALSE)

## zeit
zeit <- as.data.frame(zeit)

zeit <- zeit %>%
  mutate(zeit = str_split(zeit, "\nCopyright \\d{4} Zeitverlag Gerd Bucerius GmbH & Co\n", simplify = FALSE)) %>% 
  unnest_wider(zeit, names_sep = "")

names(zeit)[names(zeit) == "zeit1"] <- "meta"
names(zeit)[names(zeit) == "zeit2"] <- "body"

## zeit online
zeit_online <- as.data.frame(zeit_online)

zeit_online <- zeit_online %>%
  mutate(zeit_online = str_split(zeit_online, "\nCopyright \\d{4} Zeitverlag Gerd Bucerius GmbH & Co\n", simplify = FALSE)) %>% 
  unnest_wider(zeit_online, names_sep = "")

names(zeit_online)[names(zeit_online) == "zeit_online1"] <- "meta"
names(zeit_online)[names(zeit_online) == "zeit_online2"] <- "body"

## welt 
welt <- as.data.frame(welt)

welt <- welt %>%
  mutate(welt = str_split(welt, "\nCopyright \\d{4} Axel Springer SE\n", simplify = FALSE)) %>% 
  unnest_wider(welt, names_sep = "")

names(welt)[names(welt) == "welt1"] <- "meta"
names(welt)[names(welt) == "welt2"] <- "body"

## welt online
welt_online <- as.data.frame(welt_online)
welt_online <- welt_online %>%
  mutate(welt_online = str_split(welt_online, "\nCopyright \\d{4} Axel Springer SE\n", simplify = FALSE)) %>% 
  unnest_wider(welt_online, names_sep = "")

names(welt_online)[names(welt_online) == "welt_online1"] <- "meta"
names(welt_online)[names(welt_online) == "welt_online2"] <- "body"

## add variable containing source information
sddz$source <- "SZ"
sz_online$source <- "SZON"
spiegel$source <- "spiegel"
spon$source <- "spon"
taz$source <- "taz"
welt$source <- "welt"
welt_online$source <- "welt_online"
zeit$source <- "zeit"
zeit_online$source <- "zeit_online"

df <- rbind(sddz, sz_online, spon, welt, welt_online, zeit, zeit_online)

# spiegel, taz

names(sddz)
names(sz_online)
names(spiegel)

setwd(output.folder)
saveRDS(df, file = "factiva_data.rds")

df <- readRDS(file = "factiva_data.rds")


