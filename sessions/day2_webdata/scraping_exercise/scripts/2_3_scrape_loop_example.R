# Here you can see how to scrape multiple URLs in a loop.
# The first version uses lapply, and below that a for loop

library(rvest)

# Load the previously saved URLs
urls <- scan("../data/processed/practice_CNN_URLs.md", character(), quote = "")


# lapply ------------------------------------------------------------------
# Run loop over these URLs
# With lapply
articles <- lapply(urls, function(url) {
  
  Sys.sleep(runif(1)+1)
  
  message(url)
  
  website <- read_html(url)
  
  article <- tibble(
    title = website %>%
      html_node("#maincontent") %>%
      html_text(),
    
    authors = website %>%
      html_nodes(".byline__name") %>%
      html_text() %>%
      paste(collapse = ";"),
    
    timestamp = website %>%
      html_nodes(".timestamp") %>%
      html_text(),
    
    body = website %>%
      html_nodes(".paragraph") %>%
      html_text() %>%
      paste(collapse = ""),
    
    url = url
  )
  
  return(article)
})

articles <- data.table::rbindlist(articles, fill = TRUE) 
saveRDS(articles, file = "/Users/maialodato/Desktop/Summer School 2023 /D1/SICSS_2023/exercises/NP/CNN.Rds")


# Loop alternative --------------------------------------------------------
articles <- data.frame()
count <- 1
for (url in urls) {
  
  Sys.sleep(runif(1)+1)
  
  print(paste(count, url))
  
  website <- read_html(url)
  
  tmp <- tibble(
    title = website %>%
      html_node("#maincontent") %>%
      html_text(),
    
    authors = website %>%
      html_nodes(".byline__name") %>%
      html_text() %>%
      paste(collapse = ";"),
    
    timestamp = website %>%
      html_nodes(".timestamp") %>%
      html_text(),
    
    body = website %>%
      html_nodes(".paragraph") %>%
      html_text() %>%
      paste(collapse = ""),
    
    url = url
  )
  
  articles <- rbind(articles, tmp)
  saveRDS(articles, file = "../data/processed/CNN.Rds")
  
  count <- count + 1
}

# Note: If you don't limit yourself to 200 articles, you need to split the URL list into 
# manageable chunks (~300-500), otherwise R will run out of memory and crash.

