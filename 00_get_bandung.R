library(rvest)
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)

url <- "URL_SITUS_MOOVIT"
h <- read_html(url)

lines_container <- h %>% html_elements("div.lines-container")
line_items <- lines_container %>% html_elements("li.line-item")
links <- line_items %>% html_elements("a") %>% html_attr("href")
route_names <- line_items %>% html_elements("strong.line-title") %>% html_text()

sch_url <- bind_cols(route_names, links)
names(sch_url) <- c("name", "url")

get_schedule <- function(url_char) {
  read_html(url_char) %>% html_table()
}

trans_stops <- function(t) {
  t %>%
    rename("stop" = "stop-Wrapper") %>%
    mutate(stop = str_trim(stop))
}

stops <- sch_url %>%
  select(url) %>%
  rowwise() %>%
  mutate(stops_data = list(trans_stops(get_schedule(url)))) %>%
  unnest(stops_data)

route_info <- stops %>%
  group_by(name) %>%
  summarise(
    departure_route = toJSON(list(stop = stop[1:floor(n()/2)])),
    return_route = toJSON(list(stop = stop[(floor(n()/2) + 1):n()]))
  )

sc <- bind_cols(sch_url, route_info)

sc <- sc %>%
  mutate(latitude = NA, longitude = NA, shape = NA)

write_json(sc, "data/bandung_detail.json")