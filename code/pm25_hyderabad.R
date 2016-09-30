library('RSelenium')
library("tidyr")
library("dplyr")
library("lubridate")
library("tibble")
library("lazyeval")
library("purrr")
library("stringr")
source("code/selPipe.R")

table_hyderabad <- tibble_(list(location = ~c("Hyderabad", "ZooPark"),
                                date_min = ~c(ymd("2015-04-17"), ymd("2015-09-01")),
                                parameters = ~c("PM 2.5(PM2.5)", "PM2.5(PM2.5)")))

table_hyderabad <- group_by(table_hyderabad, location)
table_hyderabad <- mutate_(table_hyderabad,
                           date_min = interp(~list(seq(from = date_min, to = Sys.Date() - 1,
                                           by = "2 days"))))
table_hyderabad <- unnest_(table_hyderabad, "date_min")

table_hyderabad <- table_hyderabad %>% 
  by_row(function(df){
    
    print(paste(df$location, df$date_min))
    value <- try(cpcb_data(remDr, state = "Telangana", city = "Hyderabad",
              station= df$location, parameters = df$parameters,
              report = "Tabular", criteria = "1 Hours",
              date_from = paste0(str_pad(day(df$date_min), 2, pad = "0"),
                                 "/",
                                 month(df$date_min), "/",
                                 year(df$date_min)), 
              date_to = paste0(str_pad(day(df$date_min + 1), 2, pad = "0"),
                               "/",
                               month(df$date_min + 1), "/",
                               year(df$date_min + 1))))
    try <- 0
    while(class(value) == "try-error" & try <= 20){
      print("error, try again")
      value <- try(cpcb_data(remDr, state = "Telangana", city = "Hyderabad",
                             station= df$location, parameters = df$parameters,
                             report = "Tabular", criteria = "1 Hours",
                             date_from = paste0(str_pad(day(df$date_min), 2, pad = "0"),
                                                "/",
                                                month(df$date_min), "/",
                                                year(df$date_min)), 
                             date_to = paste0(str_pad(day(df$date_min + 1), 2, pad = "0"),
                                              "/",
                                              month(df$date_min + 1), "/",
                                              year(df$date_min + 1))))
      try <- try + 1
    }
    
    value
    
  })

table_hyderabad <- table_hyderabad %>% 
  .$.out %>%
  bind_rows()


readr::write_csv(table_hyderabad, path = "data/PM25_CPCB_Hyderabad.csv")
rm(list=ls())