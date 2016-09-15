library('RSelenium')
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
