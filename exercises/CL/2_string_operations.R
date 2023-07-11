# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function

str_detect(text, "\\n")

# Other operations

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

text_new <- text %>%
  str_replace("\\n", "") %>% #Remove the line break
  str_replace_all("Orange", "") %>%  # Remove the two "Orange"
  str_squish() # Remove the unnecessary white spaces

str_count(text_new, '\\w+') %>% print() # How long is this string? Count characters and words

str_length(text_new) %>% print() # How long is this string? Count characters and words


str_extract(text_new, "\\w+\\.\\d+\\@\\w+\\.\\w+") %>% print() # Extract the email address

text_new <- text_new %>% str_to_lower() %>% # Change the text to all lower-case
  str_replace("impovemend", "improvement") %>%  # Correct the misspelled word
  print()






