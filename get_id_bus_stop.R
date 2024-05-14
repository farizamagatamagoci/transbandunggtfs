library(jsonlite)

# Read JSON data from file
data <- fromJSON("bus_stop_in_bandung_completed.json")

# List of names to filter
names_to_filter <- c(
  "Mall Summarecon Bandung",
  "Stasiun Gedebage",
  "Halte Soekarno Hatta 4",
  "Dinas Koperasi Dan Usaha Kecil",
  "Halte Smkn 6 (Bnn)",
  "Gmw Motor",
  "Halte Tmb Kantor Pos",
  "Depo Bangunan",
  "Lotte Mart",
  "Halte Rs Al Islam",
  "Halte Metro",
  "Rancabolang",
  "Sai",
  "Smkn 7 Bandung",
  "Showroom Hyundai",
  "Bpn Jabar",
  "Universitas Mandiri",
  "Kantor Pos Sekejati",
  "Uninus",
  "Halte Carrefour",
  "Jalan Soekarno Hatta 518",
  "Jalan Soekarno Hatta 496",
  "Pt Medal Sekarwangi",
  "Bangunan Mart A",
  "Lpkia A",
  "Stie Inaba",
  "Suka Ati",
  "Pt Len Industri A",
  "Astra Biz Center",
  "Pln Up3 Bandung A",
  "Simpang by Pass Soekarno Hatta B",
  "Ampera Soekarno Hatta",
  "Mekarwangi",
  "Lapas Banceuy",
  "Bandung Convention Center",
  "Simpang Cibaduyut",
  "Halte Griya",
  "Pasar Caringin",
  "Sumbersari",
  "Cibuntu Selatan",
  "Ypp Teknik (Holis)",
  "Jalan Soekarno Hatta 8",
  "Jalan Jend. Sudirman, 773",
  "Halte Sudirman 3",
  "Halte Rajawali Barat",
  "Plaza Telkom Rajawali",
  "Elang"
)

# Function to check if name exists in data and print coordinates if exists
check_name <- function(name, data) {
  # Filter entries based on name
  filtered_data <- data[grepl(name, data$stop_name, ignore.case = TRUE), ]

  # Function to extract coordinates or return NA NA if no coordinates exist
  extract_coordinates <- function(coord) {
    if (length(coord) > 0) {
      paste(coord, collapse = " ")
    }
  }

  match_indices <- which(grepl(name, data$stop_name, ignore.case = TRUE))
  if (length(match_indices) > 0) {
    coordinates <- lapply(filtered_data$stop_id, extract_coordinates)
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