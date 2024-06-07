library(dplyr)
library(tidyr)
library(purrr)
library(rvest)
library(stringr)

rm(list = ls())

url <- "URL_SITUS_MOOVIT"
h <- read_html(url)

link <- h %>%
  html_elements("div.lines-container") %>%
  html_elements("li.line-item") %>%
  html_elements("a") %>%

  html_attr("href")

route <- h %>%
  html_elements("div.lines-container") %>%
  html_elements("li.line-item") %>%
  html_elements("strong.line-title") %>%
  html_text()

contra <- gsub("\\d{1}$", "1", link)

route_name <- gsub("^.+line-(\\w+)-Bandung.+", "\\1", link)

sch_url <- bind_cols(route_name, route, link, contra)
names(sch_url) <- c("name", "route", "url_direction", "url_contra")

# function for pull schedules
get_schedule <- function(url_char) {
  read_html(url_char) %>% html_table()
}

# function for time transformation
trans_schedule <- function(t) {
  t %>%
    rename("day" = "Day", "oh" = "Operating Hours") %>%
    mutate(oh = ifelse(oh == "Not Operational", NA, oh)) %>%
    separate(col = "oh", into = c("start_time", "end_time"), sep = " - ") %>%
    mutate(start_time = ifelse(str_detect(start_time, "AM"),
                               str_remove(start_time, "\\s?AM"),
                               paste(as.numeric(gsub(pattern = "^(\\d{1,2})\\:\\d{2}\\sPM$",                             replacement = "\\1",
                                                     x = .$start_time)) + 12,
                                     gsub(pattern = "^\\d{1,2}:(\\d{2})\\sPM$",
                                          replacement = "\\1",
                                          x = .$start_time),
                                     sep = ":")),
           start_time = ifelse(!is.na(start_time), paste(start_time,      "00", sep = ":"), start_time),
           end_time = ifelse(str_detect(end_time, "AM"),
                             str_remove(end_time, "\\s?AM"),
                             paste(as.numeric(gsub(pattern =
                                                     "^(\\d{1,2})\\:\\d{2}\\sPM$",

                                                   replacement = "\\1",
                                                   x = .$end_time)) + 12,
                                   gsub(pattern = "^\\d{1,2}:(\\d{2})\\sPM$",
                                        replacement = "\\1",
                                        x = .$end_time),
                                   sep = ":")),
           end_time = ifelse(!is.na(end_time), paste(end_time, "00", sep = ":"), end_time))
}

# gather schedule tables (crawling) will takes time
sch_list <- sch_url %>%
  pivot_longer(cols = 3:4, names_to = "direction", values_to = "url") %>%
  select(-matches("alert_")) %>%
  mutate(schedule = map(url, get_schedule))

sc <- sch_list %>%
  select(name, route, direction, schedule) %>%
  mutate(direction = ifelse(direction == "url_contra", 1, 0),
         load_date = Sys.Date()) %>%
  unnest(schedule) %>%
  distinct()

# time transformation
sc <- sc %>%
  select(name, route, direction, schedule, load_date) %>%
  unnest(schedule) %>%
  trans_schedule()

# rename schedule for suitability with gtfs headers
names(sc) <- c("route_id", "trip", "direction_id",  "day",
               "start_time", "end_time", "load_date")

# detect non directional trip names
ndtrip <- sc %>%
  select(route_id, trip) %>%
  mutate(strip = str_detect(trip, "-")) %>%
  filter(strip == FALSE) %>%
  .$route_id %>%
  unique()

# add headsign in schedule data
sc <- sc %>%
  mutate(trip = ifelse(route_id %in% ndtrip,
                       paste(trip, trip, sep = "-"),
                       trip)) %>%
  separate(col = "trip", into = c("trip_0", "trip_1"),
           sep = "-") %>%

  mutate(trip_0 = str_trim(trip_0),
         trip_1 = str_trim(trip_1)) %>%
  mutate(trip_headsign = ifelse(direction_id == 1,
                                paste(trip_1, trip_0, sep = " - "),
                                paste(trip_0, trip_1, sep = " - ")),
         .after = route_id) %>%
  select(-trip_0, -trip_1)

write.csv(sc, "data/bandung_schedule.csv")