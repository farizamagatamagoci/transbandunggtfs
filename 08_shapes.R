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

shape_trips <- dt %>%
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
    start_date = "20240426",
    end_date = "20241231")

shape_trips <- shape_trips %>%
  left_join(cal %>% select(id_join, service_id), by = "id_join") %>%
  select(-id_join)

convert_shape <- function(x, y) {
  x %>%
    st_as_sf(coords = c("lon", "lat")) %>%
    group_by(gr = y) %>%
    summarise(do_union = FALSE) %>%
    st_cast("LINESTRING") %>%
    ungroup() %>%
    select(geometry)
}

shapes <- shape_trips %>%
  mutate(shape_decode = map(shape, decode_pl))

shapes <- shapes %>%
  unnest(shape_decode) %>%
  st_as_sf(coords = c("lon", "lat")) %>%
  group_by_at(vars(-geometry)) %>%
  summarise(do_union = FALSE, .groups = "drop") %>%
  st_cast("LINESTRING")

sg <- sfc_to_df(shapes$geometry) %>%
  group_by(linestring_id) %>%
  mutate(shape_pt_sequence = 1:n())

shapes <- shapes %>%
  mutate(linestring_id = 1:n()) %>%
  right_join(sg, by = "linestring_id") %>%
  st_drop_geometry() %>%
  select(shape_id,
         shape_pt_lat = y,
         shape_pt_lon = x,
         shape_pt_sequence)

write.csv(shapes, "data/gtfs/shapes.txt", row.names = FALSE, na = "")