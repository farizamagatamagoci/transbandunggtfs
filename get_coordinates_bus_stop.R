library(jsonlite)

# Read JSON data from file
data <- fromJSON("bandung_busstop_2.json")

# List of names to filter
names_to_filter <- c(
  "Terminal Leuwipanjang",
  "Rs Imanuel Pintu Kopo",
  "Sukaleueur",
  "Jalan Raya Kopo 30-34",
  "Simpang Pungkur-Dewi Sartika",
  "Kcp Bca Dewi Sartika",
  "Gereja Rehoboth",
  "Grand Yogya Kepatihan",
  "Pendopo Kota Bandung",
  "Alun-Alun Bandung",
  "Halte Banceuy",
  "Bjb Braga",
  "Click Square",
  "Veteran",
  "Katapang",
  "Pasar Kosambi",
  "Lapangan Persib",
  "Sekolah Agustinus",
  "Hardrock Fm",
  "Balai Besar Tekstil",
  "Awi Bitung",
  "Gateway Cicadas",
  "Sulaksana",
  "Jalan Jendral Ahmad Yani 909 - 915",
  "Seberang Terminal Cicaheum",
  "Abdul Hamid",
  "Cikadut",
  "Jalan A.H. Nasution, 68",
  "Lapas Sukamiskin",
  "Sdn 068 Sindanglaya",
  "Jalan A.H. Nasution 84",
  "Puslitbang Jalan Dan Jembatan",
  "Sman 24 Bandung",
  "Jalan A.H. Nasution 38",
  "Jalan Raya Ujungberung 55",
  "Kartikasari Ujung Berung",
  "Masjid Besar Ujung Berung",
  "Terminal Ujung Berung",
  "Sdn Ciporeat",
  "Jalan A.H. Nasution 236",
  "Borma Nasution",
  "Jalan Desa Cipadung",
  "Uin Sunan Gunung Djati",
  "Pangkalan Damri Cibiru",
  "Jalan A.H. Nasution 37a",
  "Kimia Farma Ujung Berung",
  "Sdn Andir Kidul",
  "Gani Factory Outlet",
  "Shop And Drive Ujung Berung",
  "Halte Nasution",
  "Halte Pusjatan",
  "Rs Hermina Rancamanik",
  "Jalan A.H. Nasution 918",
  "Depan Terminal Cicaheum",
  "Simpang Cicaheum",
  "Padasuka",
  "Halte Tmb Ibrahim Adjie",
  "Btm",
  "Jembatan Pelangi (Kiara Artha)",
  "Muj",
  "Stmik",
  "Gor Koni",
  "Plaza Ibcc",
  "Segitiga Mas",
  "Cikudapateuh",
  "Kantor Pos Kosambi",
  "Seberang Pasar Kosambi",
  "Katapang Kaler",
  "Simpang Lima (A. Yani)",
  "Panin Bank",
  "Kasim",
  "Badan Keuangan Negara",
  "Museum Kaa",
  "Jalan Dalem Kaum",
  "Toko Mas Abc",
  "Jalan Kautamaan Istri",
  "Simpang Ijan",
  "Lapang Tegalega Bandung",
  "Halte Otto Iskandardinata",
  "Peta Muara",
  "Rumah Sakit Imanuel B",
  "Pintu Keluar Terminal Leuwipanjang",
  "Halte Soekarno Hatta Leuwi Panjang"
)

# Function to check if name exists in data and print coordinates if exists
check_name <- function(name, data) {
  # Filter entries based on name
  filtered_data <- data[grepl(name, data$properties$name, ignore.case = TRUE), ]

  # Function to extract coordinates or return NA NA if no coordinates exist
  extract_coordinates <- function(coord) {
    if (length(coord) > 0) {
      paste(coord, collapse = " ")
    }
  }

  match_indices <- which(grepl(name, data$properties$name, ignore.case = TRUE))
  if (length(match_indices) > 0) {
    coordinates <- lapply(filtered_data$geometry$coordinates, extract_coordinates)
    cat(paste(coordinates[1], collapse = "\n"), "\n")
  } else {
    print("NA")
  }
}

# Iterate over names to filter
for (name in names_to_filter) {
  print(paste("Checking for", name))
  check_name(name, data)
}