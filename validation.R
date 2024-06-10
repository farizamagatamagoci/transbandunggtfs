library(tidytransit)

rm(list = ls())

g <- read_gtfs("data/bandung.gtfs.zip")
write.csv(validate_gtfs(g), "validation_status.csv", row.names = FALSE)
