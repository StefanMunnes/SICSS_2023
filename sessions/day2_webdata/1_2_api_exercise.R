# SICSS Berlin - Day 2 - July 4, 2023
# API - Exercise

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
# 1.	Names and other information on members of congress from 2020 to 2023

# Task2 -------------------------------------------------------------------
# 2.	Congressional records from 2020 to 2023 (only includes URLs to records)

# Task 3 ------------------------------------------------------------------
# Think about, how you might be able to merge the two data sets

