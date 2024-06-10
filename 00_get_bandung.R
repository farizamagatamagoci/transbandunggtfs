library(rvest)
library(dplyr)
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
    rename("stop" = "stopWrapper") %>%
    mutate(stop = str_trim(stop))
}

stops <- sch_url %>%
  select(Route_info) %>%
  str_split(pattern = "\n", simplify = TRUE) %>%
  unnest(c("stop")) %>%
  mutate(stop = str_trim(stop))

sc <- bind_cols(sch_url, stops)

names(sc) <- c("transportName", "scheduleId", "transportId", "Name", "longName", "Route_info", "Load_date")

route_info <- sc %>%
  select(Route_info) %>%
  str_split(pattern = "\n", simplify = TRUE) %>%
  unnest(c("Id", "Name", "longName", "transportName", "Tracks", "stops"))

sc <- bind_cols(sc, route_info)

write.json(sc, "data/bandung_detail.json")