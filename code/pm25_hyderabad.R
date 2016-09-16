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
                                date_min = ~c(ymd("2015-06-07"), ymd("2015-09-01")),
                                no_parameters = ~c(15, 4)))

table_hyderabad <- group_by(table_hyderabad, location)
table_hyderabad <- mutate_(table_hyderabad,
                           date_min = interp(~list(seq(from = date_min, to = Sys.Date(),
                                           by = "2 days"))))
table_hyderabad <- unnest_(table_hyderabad, "date_min")

table_hyderabad <- table_hyderabad %>% 
  by_row(function(df){
    print(paste(df$location, df$date_min))
    data_pm <- retrieve_data(location = df$location, 
                  date_min = df$date_min, 
                  no_parameters = df$no_parameters,
                  remDr = remDr)
    if(nrow(data_pm)>1){
      readr::write_csv(data_pm[1:(nrow(data_pm)-2),],
                       path = paste0("data/pm25_", df$location, "_",
                                     gsub("-", "_", as.character(df$date_min)),
                                     ".csv"))
    }
    
    return(NULL)
  })



library("ggplot2")
ggplot(table_hyderabad) +
  geom_line(aes(start, concentration, col = location))