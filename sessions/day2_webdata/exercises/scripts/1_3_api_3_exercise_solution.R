# SICSS Berlin - Day 2 - July 4, 2023
# API - Exercise Solutions

library(tidyverse)
library(httr)

# Use the API provided by https://api.congress.gov/ to get 
# 1.	Names and other information on members of congress.
#     Save the resulting data on your hard drive.
#     Bonus: Congress has had 2,516 members not 250.

# Optional task
# 2.	Congressional records from 2020 to 2023
#     Save the resulting data on your hard drive.

# NOTE: The data might look messy, but we will deal with that tomorrow!
# NOTE: Don’t forget to include a time delay between API requests!

# Get your API-key https://api.congress.gov/sign-up/ 
# Store your API-key outside of the script
# Run the following line.
# A window will open.
# Add "congress_key = [your key]" and save
file.edit("~/.Renviron")
# Restart R, then you can access the key via
Sys.getenv("congress_key")


# Task 1 ------------------------------------------------------------------
# Names and other information on members of congress starting 2020
# API call
httr_pers <- GET("https://api.congress.gov/v3/member", 
                 query = list(format = "json",
                              limit = 250,
                              offset = 0,
                              api_key = Sys.getenv("congress_key")))

# Extract the contents as JSON format/lists
members <- content(httr_pers, type='application/json')$member 

# This would be it for the task, except that we want all members




# With while()
members <- list()
offset <- 0
while (1==1) {
  print(paste0("offset=", offset))
  Sys.sleep(1)

  httr_pers <- GET("https://api.congress.gov/", 
                   path = "v3/member",
                   query = list(format = "json",
                                limit = 250,
                                offset = offset,
                                api_key = Sys.getenv("congress_key")))
  
  tmp <- content(httr_pers, type='application/json')$member 
  
  if (length(tmp)==0) {
    print(paste("No more members"))
    break
  }
  members <- append(members, tmp)
  
  offset <- offset + 250
}

saveRDS(members, file = "../data/processed/congress_members.Rds")

# ALTERNATIVE With lapply
members <- lapply(
  seq(0, 3000, by = 250), 
  local({
    broken <- FALSE
    function(offset) {
      
      if (broken) return()
      
      message("offset=", offset)

      Sys.sleep(1)

      httr_pers <- GET("https://api.congress.gov/", 
                   path = "v3/member",
                   query = list(format = "json",
                                fromDateTime = "2020-01-01T00:00:00Z",
                                limit = 250,
                                offset = offset,
                                api_key = Sys.getenv("congress_key")))

      members <- content(httr_pers, type='application/json')$member 

      if (length(members)==0) {
        message("No more members")
        broken <<- TRUE
      }

    return(members)
    }
}))



# Task 2 ------------------------------------------------------------------
# Congressional records starting 2020 (only includes URLs to records)
congr_records <- list()
for (year in 2020:2023) {
  offset <- 0
  while (1==1) {
    print(paste(year, "offset =", offset))
    Sys.sleep(1)
    
    httr_rec <- GET("https://api.congress.gov/", 
                     path = "v3/congressional-record",
                     query = list(format = "json",
                                  year = year,
                                  limit = 250,
                                  offset = offset,
                                  api_key = Sys.getenv("congress_key")))
    
    tmp <- content(httr_rec, type='application/json')$Results$Issues
    
    if (length(tmp)==0) {
      print(paste("No more congressional records in", year))
      break
    }
    
    congr_records <- append(congr_records, tmp)
    
    offset <- offset + 250
  }
}

saveRDS(congr_records, file = "../data/processed/congress_record_urls.Rds")
