library(dplyr)
library(tidyr)

items <- read.csv("bandung_schedule.csv", header = TRUE, sep = ",")
saveRDS(items,"bandung_schedule.rds")