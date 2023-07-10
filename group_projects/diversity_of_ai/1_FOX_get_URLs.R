# !! 
# Take care that I only wrote this script to get some sample data
# So I only improved it until it works _well enough_
# For a real paper, you'll definitely need to improve it more!

## Have fun


library(tidyverse)
library(rvest)
library(RSelenium)
library(wdman)
library(netstat) # required for free_port
library(lubridate)
library(glue) # required to feed dates into string
# Fox News ----------------------------------------------------------------
# search term "Black Lives Matter"
remote_driver <- rsDriver(browser = "chrome", 
                          chromever = "114.0.5735.90",
                          verbose = FALSE,
                          port = free_port(random = TRUE))

remDr <- remote_driver$client
remDr$open()

# Load page
remDr$navigate("https://www.foxnews.com/search-results/search?q=%22Black%20Lives%20Matter%22")

# Select "By Content" dropdown
remDr$findElement(using = "xpath", "//button[contains(., 'Content')]")$clickElement() 

# Select "By Content" dropdown
remDr$findElement(using = "xpath", "//input[@title='Article']")$clickElement() 

# Click Search
remDr$findElement(using = "xpath", "//a[contains(., 'Search')]")$clickElement() 


# TESTING
# Set date
#start <- mdy(01012020)
#end <- start+2
#start_day <- formatC(day(start), width=2, format="d", flag="0")
#start_month <- formatC(month(start), width=2, format="d", flag="0")
#start_year <- year(start)

#end_day <- formatC(day(end), width=2, format="d", flag="0")
#end_month <- formatC(month(end), width=2, format="d", flag="0")
#end_year <- year(end)

# Select dates
# Start
## month
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='sub month']")$clickElement()  # For start month
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='sub month']//li[@id='{start_month}']"))$clickElement()
## day
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='sub day']")$clickElement()  # For start day
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='sub day']//li[@id='{start_day}']"))$clickElement()
## year
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='sub year']")$clickElement()  # For start year
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='sub year']//li[@id='{start_year}']"))$clickElement()
## month
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub month']")$clickElement()  # For end month
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub month']//li[@id='{end_month}']"))$clickElement()
## day
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub day']")$clickElement()  # For end day
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub day']//li[@id='{end_day}']"))$clickElement()
# year
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub year']")$clickElement()  # For end year
#Sys.sleep(.1)
#remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub year']//li[@id='{end_year}']"))$clickElement()

# Click Search
#remDr$findElement(using = "xpath", "//a[contains(., 'Search')]")$clickElement() 

#start <- start+2

# Loop --------------------------------------------------------------------
# Multiple issues:
# 1. Sometimes the date filter is ignored and the search results include all articles
# 2. Scroll down + button press does not work for some reason
# 3. starting 22 Feb 2022 the search results were stuck at the loading circle. 
# 4. does not stop when current date is reached

urls <- character()
file <- file("FOX_URLs_save1.txt")
start <- mdy(01012020)
for (page in 1:1000) {
  if (start==mdy(02102022)) {
    print("Final date reached")
    break
  }
  #Sys.sleep(runif(1)+sample(1:2, 1))
  
  print(page)
  
  # Scroll top of page
  remDr$executeScript("window.scrollTo(0, 0)")

  # Set date
  end <- start+2
  start_day <- formatC(day(start), width=2, format="d", flag="0")
  start_month <- formatC(month(start), width=2, format="d", flag="0")
  start_year <- year(start)
  
  end_day <- formatC(day(end), width=2, format="d", flag="0")
  end_month <- formatC(month(end), width=2, format="d", flag="0")
  end_year <- year(end)
  
  # Select dates
  # Start
  # month
  remDr$findElement(using = "xpath", "//div[@class='sub month']")$clickElement()  # For start month
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='sub month']//li[@id='{start_month}']"))$clickElement()
  # day
  remDr$findElement(using = "xpath", "//div[@class='sub day']")$clickElement()  # For start day
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='sub day']//li[@id='{start_day}']"))$clickElement()
  # year
  remDr$findElement(using = "xpath", "//div[@class='sub year']")$clickElement()  # For start year
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='sub year']//li[@id='{start_year}']"))$clickElement()
  # month
  remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub month']")$clickElement()  # For end month
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub month']//li[@id='{end_month}']"))$clickElement()
  # day
  remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub day']")$clickElement()  # For end day
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub day']//li[@id='{end_day}']"))$clickElement()
  # year
  remDr$findElement(using = "xpath", "//div[@class='date max']//div[@class='sub year']")$clickElement()  # For end year
  Sys.sleep(.1)
  remDr$findElement(using = "xpath", glue("//div[@class='date max']//div[@class='sub year']//li[@id='{end_year}']"))$clickElement()
  
  Sys.sleep(.3)
  
  # Click Search
  remDr$findElement(using = "xpath", "//a[contains(., 'Search')]")$clickElement() 

  # Wait to load
  Sys.sleep(runif(1)+1)
  
  len_prev <- 0
  while (1==1) {
  # Get URLs
    webElem <- remDr$findElements(using = "css selector", ".title a")
    
    len <- length(webElem)
    if (len==len_prev) {
      print("No new items")
      break
    }
    if (len > 0) {
      for (i in 1:len) {
        url_tmp <- webElem[[i]]$getElementAttribute("href")
        urls <- c(urls, unlist(url_tmp))
      }
    } else{
      print("Nothing found")
    }
    
    len_prev <- len
    
    # If there is a load more, load more
    element <- remDr$findElement(using = "css selector", ".load-more span")
    remDr$executeScript("arguments[0].scrollIntoView(true);", list(element))
    element$clickElement()
    Sys.sleep(.5)
  }
  
  # Delete duplicate URLs
  urls <- unique(urls)
  
  # Save URLs to file
  writeLines(urls, file)
  
  # Next start date
  start <- start+2
}
close(file)


# close server
remote_driver$server$stop()

