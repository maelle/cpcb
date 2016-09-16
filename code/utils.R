
retrieve_data <- function(location, date_min, no_parameters, remDr){
  Sys.sleep(1)
  remDr$open(silent = TRUE)
  remDr$navigate("http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx")
  Sys.sleep(1)
  # select state, city, location
  webElem <- remDr$findElement(using = 'id', value = "ddlState")
  webElem$sendKeysToElement(list("Telangana"))
  Sys.sleep(1)
  webElem <- remDr$findElement(using = 'id', value = "ddlCity")
  webElem$sendKeysToElement(list("Hyderabad"))
  Sys.sleep(1)
  webElem <- remDr$findElement(using = 'id', value = "ddlStation")
  webElem$sendKeysToElement(list(location))
  Sys.sleep(1)
  
  # select PM2.5
  webElem <- remDr$findElement(using = 'id', value = "lstBoxChannelLeft")
  webElem$clickElement()
  Sys.sleep(1)
  for(i in 1:no_parameters){
    webElem$sendKeysToElement(list(key = "down_arrow"))
  }
  Sys.sleep(1)
  
  webElem <- remDr$findElement(using = 'id', value = "btnAdd")
  webElem$clickElement()
  Sys.sleep(1)
  
  # select hourly values
  webElem <- remDr$findElement(using = 'id', value = "ddlCriteria")
  webElem$sendKeysToElement(list("1 Hours"))
  Sys.sleep(1)
  
  # choose start and end dates and times 
  date <- paste0(str_pad(day(date_min), 2, pad = "0"), "/",
                 month(date_min), "/",
                 year(date_min))
  webElem <- remDr$findElement(using = 'id', value = "txtDateFrom")
  webElem$clearElement()
  webElem$sendKeysToElement(list(date))
  Sys.sleep(1)
  webElem <- remDr$findElement(using = 'id', value = "txtDateTo")
  webElem$clearElement()
  webElem$sendKeysToElement(list(paste0(str_pad(day(date_min) + 1, 2, pad = "0"), "/",
                                        month(date_min), "/",
                                        year(date_min))))
  
  Sys.sleep(1)
  
  # submit
  webElem <- remDr$findElement(using = 'id', value = "btnSubmit")
  webElem$clickElement()
  Sys.sleep(1)
  
  # get table and wrangle it
  
  webElem <- try(remDr$findElement(using = 'id', value = "gvReportStation"), TRUE)
  if(!class(webElem) == "try-error"){
    table <- webElem$getElementText()
    
    table <- strsplit(table[[1]], "\n")[[1]]
    table <- tibble_(list(content = ~table[4:length(table)]))
    table <- separate_(table, "content", sep = "  ",
                       into = c("parameter", "start_time", "end_time",
                                "date", "unit"))
    table <- separate_(table, "date", sep = " ",
                       into = c("date", "concentration"))
    table <- mutate_(table, row = interp(~1:nrow(table)))
    table <- group_by_(table, "row")
    table <- mutate_(table, start = interp(~dmy_hms(paste(date, start_time))))
    table <- mutate_(table, start = interp(~ force_tz(start, tzone = "Asia/Kolkata")))
    table <- mutate_(table, end = interp(~dmy_hms(paste(date, end_time))))
    table <- mutate_(table, end = interp(~ force_tz(start, tzone = "Asia/Kolkata")))
    table <- select_(table, quote(- date))
    table <- select_(table, quote(- start_time))
    table <- select_(table, quote(- end_time))
    table <- ungroup(table)
    table <- select_(table, quote(- row))
    table <- mutate_(table, unit = interp(~gsub(" NA NA", "", unit)))
    # previous page
    
    webElem <- remDr$findElement(using = 'id', value = "btnClose")
    webElem$clickElement()
    remDr$close()
    return(table)
  } else{
    # previous page
    
    webElem <- remDr$findElement(using = 'id', value = "btnClose")
    webElem$clickElement()
    remDr$close()
    return(tibble())
  }
  
  
  
}