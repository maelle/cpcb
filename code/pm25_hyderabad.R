library('RSelenium')
library("tidyr")
library("dplyr")
library("lubridate")
library("tibble")
library("lazyeval")
library("purrr")
library("stringr")
source("code/utils.R")

RSelenium::startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/msalmon.ISGLOBAL/Documents/cpcb/chromedriver.exe")
                       , log = FALSE, invisible = FALSE)
remDr <- remoteDriver(browserName = "chrome")

# open Chrome
remDr$open()
# go to webpage


table_hyderabad <- tibble_(list(location = ~c("Hyderabad", "ZooPark"),
                                date_min = ~c(ymd("2016-09-12"), ymd("2016-09-12")),
                                no_parameters = ~c(15, 4)))
table_hyderabad <- filter(table_hyderabad, location == "ZooPark")
table_hyderabad <- group_by(table_hyderabad, location)
table_hyderabad <- mutate_(table_hyderabad,
                           date_min = interp(~list(seq(from = date_min, to = Sys.Date(),
                                           by = "1 day"))))
table_hyderabad <- unnest_(table_hyderabad, "date_min")

table_hyderabad <- table_hyderabad %>% 
  by_row(function(df){
    retrieve_data(df$location, df$date_min, remDr)
  })

table_hyderabad <- unnest_(table_hyderabad, ".out")
table_hyderabad <- select_(table_hyderabad, quote(location), quote(concentration),
                           quote(unit), quote(start), quote(end))
readr::write_csv(table_hyderabad, path = "data/hyderabad_pm25.csv")
