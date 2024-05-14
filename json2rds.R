# Load required libraries
library(jsonlite)
library(dplyr)
library(purrr)

# Read the JSON data
items <- fromJSON("bandung_detail.json")

# Assuming items is a list that needs to be converted to a data frame
bandung_detail <- as_tibble(items)

# Combine route_info columns into a single list column
bandung_detail <- bandung_detail %>%
  mutate(route_info = pmap(list(route_info$id, route_info$name, route_info$longName, route_info$color, route_info$icon, route_info$transportName, route_info$tracks, route_info$stops),
                           function(id, name, longName, color, icon, transportName, tracks, stops) {
                             list(id = id,
                                  name = name,
                                  longName = longName,
                                  color = color,
                                  icon = icon,
                                  transportName = transportName,
                                  tracks = tracks,
                                  stops = stops)
                           })) %>%
  select(-starts_with("route_info$"))# Remove individual route_info columns

# Save the modified dataframe as RDS
saveRDS(bandung_detail, "bandung_detail.rds")
