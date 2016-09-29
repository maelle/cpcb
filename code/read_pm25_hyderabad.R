library("dplyr")
library("ggplot2")
library("viridis")
pm25 <- readr::read_csv("data/PM25_CPCB_Hyderabad.csv")

ggplot(pm25) +
  geom_point(aes(start, concentration, col = location)) +
  facet_grid(location ~ ., scales = "free_y") +
  scale_color_viridis(discrete = TRUE) +
  theme(legend.position = "none")
