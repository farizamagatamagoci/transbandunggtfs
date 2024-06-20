library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

bandungbus <- readRDS("data/bandung_detail.rds")
schedule <- readRDS("data/bandung_schedule.rds")

stimes <- bandungbus %>%
  mutate(trip = map(bandungbus$route_info, "tracks")) %>%
  select(route_id = scheduleId,
         route_color = color,
         trip) %>%
  unnest(trip) %>%
  select(trip_id = id, stops)

first_stop_times <- schedule %>%
  select(route_id, direction_id, start_time) %>%
  mutate(trip_id = paste(route_id, direction_id+1, sep = "_"),
         arr_der_time = start_time) %>%
  select(trip_id, arr_der_time) %>%
  distinct(trip_id, .keep_all = TRUE)

last_stop_times <- schedule %>%
  select(route_id, direction_id, end_time) %>%
  mutate(trip_id = paste(route_id, direction_id+1, sep = "_"),
         arr_der_time = end_time) %>%
  select(trip_id, arr_der_time) %>%
  distinct(trip_id, .keep_all = TRUE)

stimes$stops <- map(stimes$stops, function(ls_stop) {
  mutate(ls_stop,
         stop_sequence = 1:n(),
         arrival_time = ifelse(stop_sequence == 1, first_stop_times$arr_der_time[first_stop_times$trip_id == stimes$trip_id],
                               ifelse(stop_sequence == n(), last_stop_times$arr_der_time[last_stop_times$trip_id == stimes$trip_id],
                                      NA)),
         departure_time = ifelse(stop_sequence == 1, first_stop_times$arr_der_time[first_stop_times$trip_id == stimes$trip_id],
                                 ifelse(stop_sequence == n(), last_stop_times$arr_der_time[last_stop_times$trip_id == stimes$trip_id],
                                        NA)))
})

stimes <- stimes %>%
  unnest(stops) %>%
  mutate(stop_id = .$stopId) %>%
  select(trip_id, arrival_time, departure_time, stop_id, stop_sequence)

write.csv(stimes, "data/gtfs/stop_times.txt", row.names = FALSE, na = "")
