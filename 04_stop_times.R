library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

# read data
bandungbrt <- readRDS("data/bandung_detail.rds")
schedule <- readRDS("data/bandung_schedule.rds")

# trip_id, arrival_time, departure_time, stop_id, stop_sequence

stimes <- bandungbrt %>%
  mutate(trip = map(bandungbrt$route_info, "tracks")) %>%
  select(route_id = scheduleId,
         route_color = color,
         trip) %>%
  unnest(trip) %>%
  select(trip_id = id, stops)

# assumption arrival and departure has the same exact time
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


# add stop_sequence, arrival_time, and departure_time
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

# save data
write.csv(stimes, "data/gtfs/stop_times.txt", row.names = FALSE, na = "")
# write.csv(ls_stop, "data/gtfs/000.txt", row.names = FALSE, na = "")
write.csv(first_stop_times, "data/gtfs/111.txt", row.names = FALSE, na = "")
write.csv(last_stop_times, "data/gtfs/222.txt", row.names = FALSE, na = "")
