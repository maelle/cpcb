library('RSelenium')
library("tidyr")
library("dplyr")
library("lubridate")
library("tibble")
library("lazyeval")

RSelenium::startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/Maelle/Documents/cpcb/chromedriver.exe")
                       , log = FALSE, invisible = FALSE)
remDr <- remoteDriver(browserName = "chrome")

# open Chrome
remDr$open()
# go to webpage
remDr$navigate("http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx")

# select state, city, location
webElem <- remDr$findElement(using = 'id', value = "ddlState")
webElem$sendKeysToElement(list("Telangana"))
Sys.sleep(1)
webElem <- remDr$findElement(using = 'id', value = "ddlCity")
webElem$sendKeysToElement(list("Hyderabad"))
Sys.sleep(1)
webElem <- remDr$findElement(using = 'id', value = "ddlStation")
webElem$sendKeysToElement(list("Hyderabad"))
Sys.sleep(1)

# select PM2.5
webElem <- remDr$findElement(using = 'id', value = "lstBoxChannelLeft")
webElem$clickElement()
for(i in 1:15){
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

# choose start and end dates 
webElem <- remDr$findElement(using = 'id', value = "txtDateFrom")
webElem$clearElement()
webElem$sendKeysToElement(list("08/09/2016"))
Sys.sleep(1)

# submit
webElem <- remDr$findElement(using = 'id', value = "btnSubmit")
webElem$clickElement()
Sys.sleep(1)

# get table and wrangle it
webElem <- remDr$findElement(using = 'id', value = "gvReportStation")
table <- webElem$getElementText()
table <- strsplit(table[[1]], "\n")[[1]]
table <- tibble_(list(content = ~table[4:length(table)]))
table <- separate_(table, "content", sep = "  ",
                  into = c("parameter", "start_time", "end_time",
                           "date", "unit"))
table <- separate_(table, "date", sep = " ",
                   into = c("date", "concentration"))
table <- select_(table, quote(- parameter))
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
