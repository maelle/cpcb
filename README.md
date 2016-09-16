The primary goal of the code of this repo is to learn how to automatically scrape data from the [CPCB website](http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx). For this I use [RSelenium](https://github.com/ropensci/RSelenium) and packages from the [tidyverse](https://github.com/hadley/tidyverse).

The first step is to get all PM2.5 data for the two stations in Hyderabad, see [this file](code/pm25_hyderabad.R). The function for scraping data for a given day and location is in [this file](code/utils.R).

Currently the code is really slow because I've noticed I get errors more often if the breaks are shorter. 

The next step will be to try and download more data for injecting them into [OpenAQ](https://openaq.org/). For this I'll have to learn how to lookup the earliest date with data for all stations, probably from [this page](http://www.cpcb.gov.in/CAAQM/Auth/frmViewReportNew.aspx). In the PM2.5 code for Hyderabad I choose PM2.5 in the scroll-down list but if I just want to retrieve everything I can use all parameters. I wasn't able to find how to choose a parameter by its value instead of its position but I could figure that out or use `RSelenium::getElementText` to at least know how many parameters there are.

In the issues I also discuss other possible data sources. 
