# SICSS Berlin - Day 2 - July 4, 2023
# Webscraping - Selenium - Exercise - FW


library(tidyverse)
library(rvest)
library(RSelenium)
library(wdman)
library(netstat)

selenium()

selenium_object <-  selenium(retcommand = TRUE, check = FALSE)

selenium_object

binman::list_versions("chromedriver")

remote_driver <- rsDriver(browser = "chrome",
                          chromever = "114.0.5735.90",
                          verbose =FALSE,
                          port = free_port(random = TRUE))

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
file <- file("practice_CNN_URLs.txt")
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
