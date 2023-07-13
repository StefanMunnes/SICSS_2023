# SICSS Berlin - Day 2 - July 4, 2023
# Web scraping - Exercise Solution

library(tidyverse)
library(RSelenium)
library(rvest)
library(wdman)
library(netstat)
library(binman)

# 1.	Install RSelenium using the guide
# 2.	Use RSelenium to collect the URLs of 200 articles that mention "Black Lives Matter".
# 3.  Scrape the title, author, date and body of the articles.
#   a. Test scraping one of the articles
#   b. Build a loop/function to scrape all the URLs from step 2.

# NOTE: The result should be a dataframe with five columns (title, author, date, body, url). 
# NOTE: Tomorrow we will learn how to clean the text data.
# NOTE: Don't forget to include a time delay between each request to the server! 


# Task 1 ------------------------------------------------------------------
# Install RSelenium
# You can use any guide you want, this one worked perfectly for me:
# https://www.youtube.com/watch?v=GnpJujF9dBw

selenium()

# Identify the path, go to the path, and delete all LICENSE.chromedriver files in all of the chromedriver folders
selenium_object <- selenium(retcommand = T,
                            check = F) 

binman::list_versions("chromedriver") 


# Task 2 ------------------------------------------------------------------
# Use RSelenium to collect the URLs of 200 articles mentioning “Black Lives Matter”
# Start a remote driver
remote_driver <- rsDriver(browser = "chrome", 
                          chromever = "114.0.5735.90",
                          verbose = FALSE,
                          port = free_port(random = TRUE)) # close this window

# select and open only the client 
# the remote driver consists of a server and a client, but we are only using the client
remDr <- remote_driver$client

# navigate to cnn.com
remDr$navigate("https://edition.cnn.com/")

# Reject cookies
remDr$findElement(using = "xpath", "//button[@id='onetrust-reject-all-handler']")$clickElement() 

# Click search button
remDr$findElement(using = "xpath", "//button[@id='headerSearchIcon']")$clickElement() 

# Find and save searchbox as object
searchbox <- remDr$findElement(using = "xpath", "//input[@aria-label='Search']")

# Click searchbox
searchbox$clickElement() 

# Write search term
searchbox$sendKeysToElement(list('\"Black Lives Matter\"', key = "enter"))

# Limit search to stories
remDr$findElement(using = "xpath", "//label[@for='collection_article']")$clickElement() 

## LOOP
urls <- character()
file <- file("../data/processed/practice_CNN_URLs.txt")
page <- 1
while (1==1) {
  
  Sys.sleep(runif(1)+sample(1:2, 1))
  
  print(page)
  
  # Check whether new stuff is added
  pre <- length(urls)
  
  # Extract headlines (with URLs)
  webElem <- remDr$findElements(using = "xpath", value="//span[@data-editable='headline']")
  
  # Save only URLs and add to url object
  for (i in 1:10) {
    url_tmp <- webElem[[i]]$getElementAttribute("data-zjs-href")
    urls <- c(urls, unlist(url_tmp))
  }
  
  # Ensure that there are no repeat URLs
  urls <- unique(urls)
  
  # save new length
  new <- length(urls)
  
  # Stop if no new urls were added
  if (pre==new) {
    print("No new urls added")
    close(file)
    break
  } 
  
  # (For exercise) Stop if 200 urls was reached
  if (new > 200) {
    print("200 urls reached")
    close(file)
    break
  }
  # Save URLs to file
  writeLines(urls, file)
  
  # Test scroll to element (the next button)
  element <- remDr$findElement(using = "css selector", ".pagination-arrow-right")
  remDr$executeScript("arguments[0].scrollIntoView(true);", list(element))
  
  Sys.sleep(0.2)
  # Click next page
  remDr$findElement(using = "css selector", ".pagination-arrow-right")$clickElement() 
  
  page <- page + 1
}

# close server
remote_driver$server$stop()
