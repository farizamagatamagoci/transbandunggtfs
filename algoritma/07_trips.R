library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(googleway)
library(sf)
library(sfheaders)
library(ggplot2)

rm(list = ls())

dt <- readRDS("data/bandung_detail.rds") %>% select(-load_date)
sc <- readRDS("data/bandung_schedule.rds") %>% select(-load_date)

trips <- dt %>%
  mutate(trip = map(dt$route_info, "tracks")) %>%
  select(route_id = scheduleId,
         route_color = color,
         trip) %>%
  unnest(trip) %>%
  mutate(route_id = .$route_id,
         direction = direction - 1,
         shape_id = paste0("shp_", gsub("\\.", "_", .$id))) %>%
  rename("trip_id" = "id",
         "trip_headsign" = "name",
         "direction_id" = "direction") %>%
  select(route_id, trip_id, trip_headsign, direction_id, shape_id, shape) %>%
  # create id for join
  mutate(id_join = paste(route_id, direction_id, sep = "_"))

cal <- sc %>%
  mutate(day = tolower(day),
         id_join = paste(route_id, direction_id, sep = "_"),
         start_time = ifelse(!is.na(start_time), 1, 0)) %>%
  pivot_wider(id_cols = "id_join",
              names_from = "day",
              values_from = "start_time") %>%
  # create service_id
  pivot_longer(cols = matches("day"),
               names_to = "day",
               values_to = "operation") %>%
  mutate(initial = ifelse(operation == 1, day, "x"),
         initial = str_extract(initial, "^\\w{1}")) %>%
  pivot_wider(id_cols = "id_join",
              names_from = "day",
              values_from = "initial") %>%
  mutate(service_id = paste0(monday, tuesday, wednesday,
                             thursday, friday, saturday, sunday),
         service_id = ifelse(service_id == "mtwtfss", "fullday",
                             ifelse(service_id == "mtwtfxx", "weekday",
                                    ifelse(service_id == "xxxxxss", "weekend",
                                           service_id))),
         .after = id_join) %>%
  mutate(
    monday    = ifelse(monday == "x", 0L, 1L),
    tuesday   = ifelse(tuesday == "x", 0L, 1L),
    wednesday = ifelse(wednesday == "x", 0L, 1L),
    thursday  = ifelse(thursday == "x", 0L, 1L),
    friday    = ifelse(friday == "x", 0L, 1L),
    saturday  = ifelse(saturday == "x", 0L, 1L),
    sunday = ifelse(sunday == "x", 0L, 1L),
    # applied days
    start_date = "20240426",
    end_date = "20241231")

trips <- trips %>%
  left_join(cal %>% select(id_join, service_id), by = "id_join") %>%
  select(-id_join)

trips <- trips %>%
  select(route_id,
         service_id,
         trip_id,
         trip_headsign,
         direction_id,
         shape_id)

write.csv(trips, "data/gtfs/trips.txt", row.names = FALSE, na = "")