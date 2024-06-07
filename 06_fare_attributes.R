library(tibble)

rm(list = ls())

# https://kumparan.com/seputar-bandung/tarif-trans-metro-bandung-2024-daftar-koridor-dan-jam-operasionalnya-22JF2dVOjM6/1
# TMP IDR 4900
# https://bandung.kompas.com/read/2022/07/06/202645478/trans-metro-pasundan-harga-tiket-rute-dan-jam-operasional-layanan-teman-bus
# TMB IDR 4000
# https://harga.web.id/tarif-bus-damri-bandung.info
# DAMRI KBP IDR 13000
# DAMRI 8 IDR 14000
# DAMRI 6A IDR 13000
# DAMRI 11 IDR 8000
# https://www.kompas.tv/ekonomi/454414/rute-dan-jadwal-terbaru-damri-dari-stasiun-tegalluar-kota-bandung-pp-tiketnya-rp10-000?page=all
# DAMRI TEGALLUAR IDR 10000

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

# save data
write.csv(fare, "data/gtfs/fare_attributes.txt", row.names = FALSE, na = "")
