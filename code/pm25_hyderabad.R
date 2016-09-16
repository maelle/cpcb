library('RSelenium')
library("tidyr")
library("dplyr")
library("lubridate")
library("tibble")
library("lazyeval")
library("purrr")
library("stringr")
source("code/utils.R")

# RSelenium::startServer()
# eCap <- list(phantomjs.binary.path = "C:/Users/msalmon.ISGLOBAL/Documents/phantomjs-2.1.1-windows/phantomjs-2.1.1-windows/bin/phantomjs.exe")
# remDr <- remoteDriver(browserName = "phantomjs", extraCapabilities = eCap)

RSelenium::startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/msalmon.ISGLOBAL/Documents/cpcb/chromedriver.exe")
                       , log = FALSE, invisible = FALSE)
remDr <- remoteDriver(browserName = "chrome")


table_hyderabad <- tibble_(list(location = ~c("Hyderabad", "ZooPark"),
                                date_min = ~c(ymd("2010-11-01"), ymd("2015-09-01")),
                                no_parameters = ~c(15, 4)))

table_hyderabad <- group_by(table_hyderabad, location)
table_hyderabad <- mutate_(table_hyderabad,
                           date_min = interp(~list(seq(from = date_min, to = Sys.Date(),
                                           by = "1 day"))))
table_hyderabad <- unnest_(table_hyderabad, "date_min")

table_hyderabad <- table_hyderabad %>% 
  by_row(function(df){
    print(paste(df$location, df$date_min))
    retrieve_data(location = df$location, 
                  date_min = df$date_min, 
                  no_parameters = df$no_parameters,
                  remDr = remDr)
  })

table_hyderabad <- unnest_(table_hyderabad, ".out")
table_hyderabad <- select_(table_hyderabad, quote(location), quote(concentration),
                           quote(unit), quote(start), quote(end))
table_hyderabad <- mutate_(table_hyderabad,
                           concentration = interp(~as.numeric(concentration)))
readr::write_csv(table_hyderabad, path = "data/hyderabad_pm25.csv")


library("ggplot2")
ggplot(table_hyderabad) +
  geom_line(aes(start, concentration, col = location))