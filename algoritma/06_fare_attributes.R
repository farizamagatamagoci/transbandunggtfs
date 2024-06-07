library(tibble)

rm(list = ls())

fare <- tibble::tribble(
  ~fare_id,           ~price, ~currency_type, ~payment_method, ~transfers, ~agency_id,
  "tmp-damri",        4900,   "IDR",          1,               NA,         "damri",
  "tmp-bluebird",     4900,   "IDR",          1,               NA,         "bluebird",
  "tmb",              4000,   "IDR",          1,               NA,         "badan_layanan_umum_daerah",
  "damri-kbp",        13000,  "IDR",          0,               NA,         "damri",
  "damri-8",          14000,  "IDR",          0,               NA,         "damri",
  "damri-6a",         13000,  "IDR",          0,               NA,         "damri",
  "damri-tegalluar",  10000,  "IDR",          0,               NA,         "damri",
  "damri-11",         8000,   "IDR",          0,               NA,         "damri"
)

write.csv(fare, "data/gtfs/fare_attributes.txt", row.names = FALSE, na = "")
