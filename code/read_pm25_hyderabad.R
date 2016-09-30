library("dplyr")
library("ggplot2")
library("viridis")
Sys.setlocale("LC_ALL","English")
pm25 <- readr::read_csv("data/PM25_CPCB_Hyderabad.csv")
theme_set(theme_gray(base_size = 20))

ggplot(pm25) +
  geom_point(aes(start, concentration, col = location)) +
  facet_grid(location ~ .) +
  scale_color_viridis(discrete = TRUE) +
  theme(legend.position = "none") +
  scale_x_datetime(date_breaks = "1 month", date_labels = "%Y-%b-%d")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  ylab(expression(paste("Concentration (", mu, "g/",m^3,")"))) +
  ggtitle("Hourly PM2.5 concentrations in Hyderabad, India",
          subtitle = "Data accessed in R via the CPCB website thanks to seleniumPipes & RSelenium")

ggsave(file = "Hyderbad_CPCB.png", width = 12, height = 6)
