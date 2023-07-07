# SICSS Berlin - Day 3 - July 5, 2023
# String Operations - Exercise

library(tidyverse)
library(stringr)

text <- "   I hope you will have a great time during the 9 days of SICSS-Berlin.  Orange  \nIf you have any suggestions for impovemend, feel free to tell us in person or via sicss.2023@wzb.eu.    Orange "

### Use stringr functions, to solve the following tasks.

# Is there a line break present? Show using a function
text%>%
str_detect("\n")
# Remove the line break
text%>%
  str_replace_all("\n","")
# Remove the two "Orange"
text%>%
  str_replace_all("Orange","")
# Remove the unnecessary white spaces
text%>%
  str_replace_all("\\s","")
# How long is this string? Count characters and words.
text%>%
  str_count(".")
# Extract the email address
text%>%
  str_extract("sicss.2023@wzb.eu")
# Change the text to all lower-case
text%>%
  str_to_lower()
# Correct the misspelled word
text%>%
  str_replace("impovemend","improvement")

#everything at once
text_edited<-text%>%
  str_replace_all("\n","")%>%
  str_replace_all("Orange","")%>%
  str_replace_all("\\s","")%>%
  str_to_lower()
text_extracted<-text_edited%>%
  str_replace("impovemend","improvement")%>%
  str_extract("sicss.2023@wzb.eu")
text_extracted
