library(dplyr)

rm(list = ls())

bandungbus <- readRDS("data/bandung_detail.rds")

agency <- bandungbus %>%
  select(agency_id = transportId) %>%
  distinct() %>%
  mutate(agency_id = gsub("bdg_", "", .$agency_id),
         agency_name = c("DAMRI",
                         "Blue Bird Bandung",
                         "Badan Layanan Umum Daerah Kota Bandung"),
         agency_url = c("https://damri.co.id/",
                        "https://www.bluebirdgroup.com/",
                        "https://upt-angkutan-dishub.github.io/"),
         agency_timezone = "Asia/Jakarta")

write.csv(agency, "data/gtfs/agency.txt", row.names = FALSE, na = "")
