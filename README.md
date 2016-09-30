# Context

The primary goal of the code of this repo is to learn how to automatically scrape data from the [CPCB website](http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx). For this I use [RSelenium](https://github.com/ropensci/RSelenium), [seleniumPipes](https://github.com/johndharrison/seleniumPipes) and packages from the [tidyverse](https://github.com/hadley/tidyverse).

# Retrieving PM2.5 data for Hyderabad

 My first goal (and primary motivation) is to get all PM2.5 data for the two stations in Hyderabad, see [this file](code/pm25_hyderabad.R). The function for scraping data for a given day and location is in [this file](code/selPipe.R). 

The downloaded data was saved in a csv file which I don't include here because I don't know if I can (please refer to the original source for licensing questions). That said, you can contact me and I might send it to you. :smile_cat:

# Making all the data easier to use 

The next step will be to try and download more data for injecting them into [OpenAQ](https://openaq.org/). For this I'll have to learn how to lookup the earliest date with data for all stations, probably from [this page](http://www.cpcb.gov.in/CAAQM/Auth/frmViewReportNew.aspx). I wasn't able to find how to choose a parameter by its value instead of its position but I could figure that out or use `RSelenium::getElementText` to at least know how many parameters there are.

In the issues I also discuss other possible data sources. 
