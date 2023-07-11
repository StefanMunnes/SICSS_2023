# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

# to get a pipe, press ctrl, shift and m

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "


### Use stringr functions, to solve the following tasks.

print(text_clean)

# Is there a line break present? Show using a function
str_detect(text, "\\n")

# Remove the line break
text <- str_squish(text)
print(text)

# Remove the two "Orange"
text <- str_replace_all(text, "Orange", "")
print(text)

# Remove the unnecessary white spaces
text <- str_squish(text) 
print(text)

# How long is this string? Count characters and words.
num_characters <- nchar(text)
num_words <- str_count(text, "\\w+")
print(num_characters)
print(num_words)

# Extract the email address
email_address <- str_extract(text, "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b")
print(email_address)

# Change the text to all lower-case
text <- tolower(text)
print(text)

# Correct the misspelled word
text <- str_replace(text, "impovemend", "improvements")
print(text)

