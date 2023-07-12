library(tidyverse)
library(rvest)
library(RSelenium)
library(wdman)
library(netstat)

selenium()

selenium_object <- selenium(retcommand = TRUE,
                            check = FALSE)

binman::list_versions("chromedriver")


remote_driver <- rsDriver(browser = "chrome", 
                          chromever = "114.0.5735.90",
                          verbose = FALSE,
                          port = free_port(random = TRUE))

remDr <- remote_driver$client
remDr$open()
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


# Loop --------------------------------------------------------------------
urls <- character()
file <- file("CNN_URLs_save.txt")
for (page in 1:296) {
  
  Sys.sleep(runif(1)+sample(1:2, 1))
  
  print(page)
  
  # Check whether new stuff is added
  pre <- length(urls)
  
  # Extract headlines (with URLs)
  webElem <- remDr$findElements(using = "class", value="__headline")
  
  # Save only URLs and add to url object
  for (i in 1:10) {
    url_tmp <- webElem[[i]]$getElementAttribute("data-zjs-href")
    urls <- c(urls, unlist(url_tmp))
  }
  
  # Ensure that there are no repeat URLs
  urls <- unique(urls)
  
  # Check if new stuff is added
  if (pre==length(urls)) {
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
}
close(file)


# close server
remote_driver$server$stop()
