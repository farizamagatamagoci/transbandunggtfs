library(jsonlite)

# Read JSON data from file
data <- fromJSON("bus_stop_unknown_in_bandung.json")

# List of names to filter
names_to_filter <- c(
  "Veteran",
  "Katapang",
  "Hardrock Fm",
  "Balai Besar Tekstil",
  "Sulaksana",
  "Jalan Jendral Ahmad Yani 909 - 915",
  "Abdul Hamid",
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
  "Jembatan Pelangi (Kiara Artha)",
  "Muj",
  "Katapang Kaler",
  "Simpang Lima (A. Yani)",
  "Panin Bank",
  "Kasim",
  "Badan Keuangan Negara",
  "Jalan Kautamaan Istri",
  "Halte Otto Iskandardinata",
  "Peta Muara",
  "Pintu Keluar Terminal Leuwipanjang"
)

# Function to check if name exists in data and print coordinates if exists
check_name <- function(name, data) {
  # Filter entries based on name
  filtered_data <- data[grepl(name, data$stop, ignore.case = TRUE), ]

  # Function to extract coordinates or return NA NA if no coordinates exist
  extract_coordinates <- function(coord) {
    if (length(coord) > 0) {
      paste(coord, collapse = " ")
    }
  }

  match_indices <- which(grepl(name, data$stop, ignore.case = TRUE))
  if (length(match_indices) > 0) {
    coordinates <- lapply(filtered_data$coordinate, extract_coordinates)
    cat(paste(coordinates[1], collapse = "\n"), "\n")
  } else {
    print("NA")
  }
}

# Iterate over names to filter
for (name in names_to_filter) {
  # print(paste("Checking for", name))
  check_name(name, data)
}