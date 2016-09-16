# Context

The primary goal of the code of this repo is to learn how to automatically scrape data from the [CPCB website](http://www.cpcb.gov.in/CAAQM/frmUserAvgReportCriteria.aspx). For this I use [RSelenium](https://github.com/ropensci/RSelenium) and packages from the [tidyverse](https://github.com/hadley/tidyverse).

# Retrieving PM2.5 data for Hyderabad

 My first goal (and primary motivation) is to get all PM2.5 data for the two stations in Hyderabad, see [this file](code/pm25_hyderabad.R). The function for scraping data for a given day and location is in [this file](code/utils.R). Note that when running, the code would sometimes have random errors (15 times in total maybe?) and I would have to relaunch it, changing the start date in order not to download the same data twice. E.g.

```r
table_hyderabad <- tibble_(list(location = ~c("Hyderabad", "ZooPark"),
                                date_min = ~c(ymd("2015-04-01"), ymd("2015-09-01")),
                                no_parameters = ~c(15, 4)))
```

would become

```r
table_hyderabad <- tibble_(list(location = ~c("Hyderabad", "ZooPark"),
                                date_min = ~c(ymd("2016-01-13"), ymd("2015-09-01")),
                                no_parameters = ~c(15, 4)))
```

The downloaded data was saved in a csv file for every 2-day table, in a data/ folder which I don't include here because I don't know if I can. All tables from those csv files could then be combined in a single table (at the time of writing I have not retrieved all data yet).

Currently the code is really slow because I've noticed I get errors more often if the breaks are shorter. 

The `no_parameters` variable is the number of times one has to go down in the scroll-down list of available parameters for getting PM2.5. I wasn't able to find how to choose a parameter by its value instead of its position.

# Making all the data easier to use 

The next step will be to try and download more data for injecting them into [OpenAQ](https://openaq.org/). For this I'll have to learn how to lookup the earliest date with data for all stations, probably from [this page](http://www.cpcb.gov.in/CAAQM/Auth/frmViewReportNew.aspx). I wasn't able to find how to choose a parameter by its value instead of its position but I could figure that out or use `RSelenium::getElementText` to at least know how many parameters there are.

In the issues I also discuss other possible data sources. 
