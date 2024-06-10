library(dplyr)
library(tidyr)

rm(list = ls())

bandungbrt <- readRDS("data/bandung_detail.rds")

routes <- bandungbrt %>%
  select(route_id = scheduleId,
         agency_id = transportId,
         route_short_name = name,
         route_long_name = longName,
         route_color = color) %>%
  mutate(agency_id = gsub("bdg_", "", .$agency_id),
         route_type = 3)

write.csv(routes, "data/gtfs/routes.txt", row.names = FALSE, na = "")
