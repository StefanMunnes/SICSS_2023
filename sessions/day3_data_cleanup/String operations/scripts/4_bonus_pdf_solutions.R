# SICSS Berlin - Day 3 - July 5, 2023
# Reading PDFs -Bonus Exercise Solutions

library(tidyverse)
library(rvest)

# Use the URLs provided here, to automatically download the PDF files that the URLs lead to
# Then read the content of these PDF files into R


# How I extracted the URLs from the API data ------------------------------
congr_rec <- readRDS("../data/processed/congress_record_urls.Rds")

congr_rec_df <- congr_rec %>%
  data.table::rbindlist(fill = TRUE) %>%
  unnest_wider(Links) %>%
  unnest_longer(PDF) %>%
  unnest_wider(PDF)

entire_rec <- congr_rec_df %>%
  filter(Label=="Entire Issue") %>%
  select(Url) %>%
  sample_n(20) %>%
  pull()



# Download the target URLs -------------------------------------------------
dir.create("pdf")
# lapply
lapply(entire_rec, function(x) {
  download.file(x, 
                destfile = paste0("pdf/", basename(x)),
                mode="wb")
})
# For loop
for (url in entire_rec) {
  download.file(url, 
                destfile = paste0("pdf/", basename(url)),
                mode="wb")
}


# Read PDF into R ---------------------------------------------------------
library(pdftools)
library(stringr)
filenames <- list.files("pdf")
pdf_text <- pdf_text(paste0("pdf/", filenames[[1]])) %>%
  paste(collapse = "") %>%
  str_squish()


# Read all PDFs into R ----------------------------------------------------
pdf_texts <- lapply(filenames, function(x) {
  pdf_text <- pdf_text(paste0("pdf/", x)) %>% 
    paste(collapse = "") %>%
    str_squish()
  return(pdf_text)
})

pdf_texts <- unlist(pdf_texts)

pdf_texts <- tibble(pdf_texts) %>%
  distinct()

