install.packages("RSelenium")
install.packages("netstat")

library(RSelenium)
library(wdman)
library(netstat)

selenium()

selenium_object <-selenium(retcommand = TRUE, #output where all drivers etc are installed
                          check =FALSE) # check would check if all drivers are installed. We don't need that anymore. We did that before

selenium_object

# google chrome
binman::list_versions("chromedriver")
remote_driver <-rsDriver(browser = "chrome",
                         chromever = "114.0.5735.90", #latest version on my computer 
                         verbose = FALSE, #suppresses messages
                         port = free_port()) #finds free port on computer to run Selenium