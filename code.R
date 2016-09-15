library('RSelenium')
RSelenium::startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/Maelle/Documents/cpcb/chromedriver.exe")
                       , log = FALSE, invisible = FALSE)
remDr <- remoteDriver(browserName = "chrome")
remDr$open()
#remDr$getStatus()
remDr$navigate("http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx")
webElem <- remDr$findElement(using = 'id', value = "ddlState")
webElem$sendKeysToElement(list("Telangana"))
Sys.sleep(1)
webElem <- remDr$findElement(using = 'id', value = "ddlCity")
webElem$sendKeysToElement(list("Hyderabad"))
Sys.sleep(1)
webElem <- remDr$findElement(using = 'id', value = "ddlStation")
webElem$sendKeysToElement(list("Hyderabad"))
Sys.sleep(1)


webElem <- remDr$findElement(using = 'id', value = "lstBoxChannelLeft")
webElem$clickElement()
for(i in 1:15){
  webElem$sendKeysToElement(list(key = "down_arrow"))
}



webElem <- remDr$findElement(using = 'id', value = "btnAdd")
webElem$clickElement()

