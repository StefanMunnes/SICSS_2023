# SICSS Berlin - Day 3 - July 5, 2023
# Reading PDFs -Bonus Exercise

library(tidyverse)
library(pdftools)

# Use the URLs provided here, to automatically download the PDF files that the 
# URLs lead to then read the content of these PDF files into R


# One way to extract the URLs ------------------------------------------
# Run the next lines
congr_rec <- readRDS("congress_record_urls.Rds")

congr_rec_df <- congr_rec %>% # Try this step by step, to see what is happening
  data.table::rbindlist(fill = TRUE) %>%
  unnest_wider(Links) %>%
  unnest_longer(PDF) %>%
  unnest_wider(PDF)

entire_rec <- congr_rec_df %>%
  filter(Label=="Entire Issue") %>% # Just keep URLs for entire issues
  select(Url) %>%   # Remove everything except URLs
  sample_n(20) %>%  # Draw a sample of 20 URLs
  pull()  # Pull the result out, so it becomes a chr object

entire_rec

# Download the target URLs into a folder called pdf ------------------------
dir.create("pdf")

folder_path <- "pdf/"

for (i in 1:20) {
  url <- entire_rec[[i]]
  
  filename <- basename(url)
  
  download.file(url, destfile = paste0(folder_path, filename), mode = "wb")
}

# Read all PDFs into R ----------------------------------------------------

pdf_files <- list.files(folder_path, pattern = "\\.pdf$", full.names = TRUE)

# Loop through each PDF file
for (file in pdf_files) {
  pdf_content <- pdf_text(file)
  
  cat("PDF File:", file, "\n")
  cat("Content:", pdf_content, "\n\n")
}