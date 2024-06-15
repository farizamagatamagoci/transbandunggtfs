library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

bandungbus <- readRDS("data/bandung_detail.rds")

stops <- bandungbus %>%
  mutate(stop_detail = map(bandungbus$route_info, "stops")) %>%
  select(stop_detail) %>%
  unnest("stop_detail") %>%
  mutate(id = .$id) %>%
  select(-icon, -mapIcon, -areaName, -directionName) %>%
  distinct(id, .keep_all = TRUE)

names(stops) <- c("stop_id", "stop_name", "stop_lat", "stop_lon")

write.csv(stops, "data/gtfs/stops.txt", row.names = FALSE, na = "")
