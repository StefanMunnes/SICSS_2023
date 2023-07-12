Google docs (updated url): https://docs.google.com/document/d/1XGP_phbHtl-jrkKZafRC3S_UJvXV_ItA36ojVsx0eo4/edit?usp=sharing
Google slides: https://docs.google.com/presentation/d/1WgGo9_iuQj1atT76AzSWiJklrAtnnioBQC28vU5RXTo/edit?usp=sharing

**DAY 1**
Uploading txt files as lists: api_key <- str_split(readLines("SICSS Berlin/us_congress_api.txt"), pattern = " ")

**DAY 2**
Text preprocessing:
- date format
- descriptive statistics (frequencies, ngrams)
- RSelenium installation
- finish NYT collection

deal with dates:
fox$date <- str_extract(fox$timestamp, '\\s+(.*\\d{4})', group=1)
fox$date <- as.Date(fox$date, format = "%B %d, %Y")
