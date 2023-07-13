# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise Solutions

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function
str_detect(text, "\n")

# Remove the line break
new_text <- str_remove(text, "\n")

# Remove the two "Orange"
new_text <- str_remove_all(new_text, "Orange")

# Remove the unnecessary white spaces
new_text <- new_text %>%
  str_squish()

# How long is this string? Count characters and words.
str_length(new_text)
str_count(new_text, pattern = "\\w+")

# Extract the email address
str_extract(new_text, ".{10}@.\\w+.\\w{2}")

# Change the text to all lower-case
new_text <- str_to_lower(new_text)

# Correct the misspelled word
new_text <- str_replace(new_text, "impovemend", "improvement")


