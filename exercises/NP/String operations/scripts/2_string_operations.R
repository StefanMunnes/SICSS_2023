# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function
stuff <- str_detect(text, "\\n")

# Remove the line break
stuff <- str_replace_all(text, "[\r\\n]" , "")

# Remove the two "Orange"
stuff <- str_replace_all(stuff, "Orange", "")

# Remove the unnecessary white spaces
stuff <- gsub(' ','',stuff)

# How long is this string? Count characters and words.
charachters <- str_length(stuff)
charachters
words <- lengths(strsplit(stuff, "\\W+"))
words

# Extract the email address
mail <- regmatches(text, regexpr("[[:alnum:]]+\\@[[:alpha:]]+\\.eu(\\.[a-z]{2})?", text))
mail

# Change the text to all lower-case
stuff <- tolower(stuff)

# Correct the misspelled word
install.packages("remotes")
remotes::install_github("trinker/textclean")
textclean::replace_misspelling(stuff)

str_replace(text, 'improvemend', 'improvement')