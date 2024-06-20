library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

bandungbus <- readRDS("data/bandung_detail.rds")

stimes <- bandungbus %>%
  mutate(trip = map(bandungbus$route_info, "tracks")) %>%
  select(route_id = scheduleId,
         route_color = color,
         trip) %>%
  unnest(trip) %>%
  select(trip_id = id, stops)

stimes$stops <- map2(stimes$stops, stimes$trip_id, function(ls_stop, trip_id) {
    mutate(
      ls_stop,
      stop_sequence = 1:n(),
      last_digit = substr(trip_id, nchar(trip_id), nchar(trip_id)),
      arrival_time = ifelse(
        last_digit == '1' & stop_sequence == 1, "17:30:00",
        ifelse(last_digit == '1' & stop_sequence == n(), "19:30:00",
               ifelse(last_digit == '2' & stop_sequence == 1, "17:30:00",
                      ifelse(last_digit == '2' & stop_sequence == n(), "19:30:00", NA)))
      ),
      departure_time = ifelse(
        last_digit == '1' & stop_sequence == 1, "17:30:00",
        ifelse(last_digit == '1' & stop_sequence == n(), "19:30:00",
               ifelse(last_digit == '2' & stop_sequence == 1, "17:30:00",
                      ifelse(last_digit == '2' & stop_sequence == n(), "19:30:00", NA)))
      )
    )
})

stimes <- stimes %>%
  unnest(stops) %>%
  mutate(stop_id = .$stopId) %>%
  select(trip_id, arrival_time, departure_time, stop_id, stop_sequence)

write.csv(stimes, "data/gtfs/stop_times.txt", row.names = FALSE, na = "")
