library(seleniumPipes)
library(RSelenium)
library(rvest)

# RSelenium::startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/msalmon.ISGLOBAL/Documents/cpcb/chromedriver.exe")
#                        , log = FALSE, invisible = FALSE)
# remDr <- remoteDr(browserName = "chrome")


cpcb_data <- function(remDr, state = "Telangana", city = "Hyderabad", station= "Hyderabad", parameters = "Nitric Oxide(NO)",
                      report = "Tabular", criteria = "1 Hours", date_from = "11/09/2016", date_to = "16/09/2016"){
  # Set state, city and station
  remDr %>% go("http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx") %>% 
    setSelect("ddlState", state) %>%                # set state
    setSelect("ddlCity", city) %>%                  # set city
    setSelect("ddlStation", station) %>%            # set station
    selectParameters(parameters) %>%                # set paramters
    checkParameters(parameters) %>%                 # check parameters are set
    setSelect("ddlReportFormat", report) %>%        # set report
    setSelect("ddlCriteria", criteria) %>%          # set criteria
    clearInputAndSet("txtDateFrom", date_from) %>%  # set date from
    clearInputAndSet("txtDateTo", date_to) %>%      # set date to
    findElement(using = 'id', value = "btnSubmit") %>%  # SUBMIT FORM
    elementClick
  
  # return table
  remDr %>% findElement(using = 'css', value = "#gvReportStation table") %>% 
    getElementAttribute("outerHTML") %>% 
    read_html %>% 
    html_table
}

# Utility function to set a select value
setSelect <- function(remDr, id, value, retry = 5){
  webElem <- remDr %>% findElement(using = 'id', value = id)
  # need to check there are options
  try <- 1
  childElems <- webElem %>% findElementsFromElement("css", "option")
  while(length(childElems) < 2L && try < retry){
    Sys.sleep(1)
    webElem <- remDr %>% findElement(using = 'id', value = id)
    childElems <- webElem %>% findElementsFromElement("css", "option")
    try <- try + 1
  }
    webElem %>% elementSendKeys(value)
  invisible(remDr)
}

# utility function to set paramters
selectParameters <- function(remDr, parameters, retry = 5){
  # get parameters
  webElems <- remDr %>% findElements("css", "#lstBoxChannelLeft option")
  parText <- sapply(webElems, getElementText)
  appParams <- webElems[parText %in% parameters]
  try <- 1
  while(length(appParams) < 1L && try < retry){
    Sys.sleep(1)
    cat("\nretrying parameters\n")
    webElems <- remDr %>% findElements("css", "#lstBoxChannelLeft option")
    parText <- sapply(webElems, getElementText)
    appParams <- webElems[parText %in% parameters]
    try <- try + 1
  }
  # match parameters wanted
  if(length(appParams) == 0L){stop("No parameters. Check names")}
  addButton <- remDr %>% findElement(using = 'id', value = "btnAdd")
  # Add parameters
  lapply(appParams, function(x){
    x %>% elementClick
    addButton %>% elementClick
  }
  )
  invisible(remDr)
}


# Utility function to clear and set an input
clearInputAndSet <- function(remDr, id, value){
  remDr %>% findElement(using = 'id', value = id) %>% 
    elementClear %>% 
    elementSendKeys(value)
  invisible(remDr)
  
}

checkParameters <- function(remDr, parameters, retry = 5){
  # check parameters are finished
  try <- 1
  chk <- sapply(remDr %>% findElements("css", "#lstBoxChannelRight option"), getElementText)
  while((!identical(chk, parameters)) && try < retry){
    cat("\nwaiting for parameters\n")
    Sys.sleep(1)
    chk <- sapply(remDr %>% findElements("css", "#lstBoxChannelRight option"), getElementText)
    try <- try + 1
  }
  if(!identical(chk, parameters)){stop("parameters not set. Is a clear needed to start?")}
  invisible(remDr)
}
  