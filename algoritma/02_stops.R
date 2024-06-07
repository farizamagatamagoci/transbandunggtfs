library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

bandungbrt <- readRDS("data/bandung_detail.rds")

stops <- bandungbrt %>%
  mutate(stop_detail = map(bandungbrt$route_info, "stops")) %>%
  select(stop_detail) %>%
  unnest("stop_detail") %>%
  mutate(id = .$id) %>%
  select(-icon, -mapIcon, -areaName, -directionName) %>%
  distinct(id, .keep_all = TRUE)

names(stops) <- c("stop_id", "stop_name", "stop_lat", "stop_lon")

write.csv(stops, "data/gtfs/stops.txt", row.names = FALSE, na = "")
