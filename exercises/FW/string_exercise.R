# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function
str_detect(text, "\n", negate = FALSE)

# Remove the line break
text2 <- str_replace(text, "\n","")

# Remove the two "Orange"
text2 <- str_replace_all(text2, "Orange","")

# Remove the unnecessary white spaces
text2 <- str_replace_all(text2, "\\s+", " ")
text2 <- str_trim(text2)

# How long is this string? Count characters and words.
str_length(text2)
str_count(text2, '\\w+')
str_count(text2, '\\S+')

# Extract the email address
str_extract(text2, '\\w+\\.\\d+@\\w+\\.\\w{2}')

# Change the text to all lower-case
text_low <- str_to_lower(text2)
text_low

# Correct the misspelled word
text_low <- str_replace(text_low, "impovemend", "improvement")
text_low