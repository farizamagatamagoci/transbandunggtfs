library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

bandungbrt <- readRDS("data/bandung_detail.rds")

# stop_id, stop_name, stop_lat, stop_lon,
# zone_id, parent_station, location_type
stops <- bandungbrt %>%
  mutate(stop_detail = map(bandungbrt$route_info, "stops")) %>%
  select(stop_detail) %>%
  unnest("stop_detail") %>%
  mutate(id = .$id) %>%
  select(-icon, -mapIcon, -areaName, -directionName) %>%
  # distinct()
  distinct(id, .keep_all = TRUE)

names(stops) <- c("stop_id", "stop_name", "stop_lat", "stop_lon")

# save data
write.csv(stops, "data/gtfs/stops.txt", row.names = FALSE, na = "")
