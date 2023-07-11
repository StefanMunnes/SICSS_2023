library(rvest)
urls <- scan("/Users/yunchaewon/sicss-berlin/ai_hype/nyturls.txt", character(), quote = "")


# Run loop over these URLs
# With lapply
for(loop in 1:12){
  st = 1
  ed = 200
  
  articles <- lapply(urls[st:ed], function(url) {
    
    Sys.sleep(12)
    
    message(url)
    
    website <- read_html(url)
    
    article <- tibble(
      title = website %>%
        html_node(".e1h9rw200") %>%
        html_text(),
      
      authors = website %>%
        html_nodes(".last-byline") %>%
        html_text() %>%
        paste(collapse = ";"),
      
      timestamp = website %>%
        html_nodes(".e16638kd0") %>%
        html_text(),
      
      body = website %>%
        html_nodes(".StoryBodyCompanionColumn") %>%
        html_text() %>%
        paste(collapse = ""),
      
      url = url
    )
    
    return(article)
    articles <- data.table::rbindlist(articles, fill = TRUE) 
    saveRDS(articles, file = "/Users/yunchaewon/sicss-berlin/ai_hype/NYT.Rds")
    
    
  })
    st <- st + 200
    ed <- ed + 200
    if(ed > 2320){
      ed <- 2320
    }
}


scraped <- readRDS(file="/Users/yunchaewon/sicss-berlin/ai_hype/NYT.Rds", refhook = NULL)



html <- read_html("https://edition.cnn.com/2023/05/10/us/florida-social-studies-textbooks-education-department/index.html")
html %>% 
  html_elements("h1")
# Task 1 ------------------------------------------------------------------
# Test scraping one of the articles

# Find css selectors with SelectorGadget
Title <- html %>% 
  html_node("#maincontent")  %>% 
  html_text()

# Authors: 
Authors <- html %>% 
  html_node(".byline__names") %>% 
  html_text()

# Date: 
Date <- html %>% 
  html_node(".timestamp") %>% 
  html_text()

# Text: 
Text <- html %>% 
  html_node(".article__content") %>% 
  html_text()