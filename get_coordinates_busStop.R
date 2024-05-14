library(jsonlite)

# Read JSON data from file
data <- fromJSON("bandung_busstop_2.json")

# List of names to filter
names_to_filter <- c(
  "Terminal Leuwipanjang",
  "Hotel Grand Pasundan",
  "Bumi Kopo Kencana",
  "Mall Festival Citylink",
  "Simpang Pasir Koja 0",
  "Spbu Pasir Koja",
  "Hotel Soreang A",
  "Mall Pelayanan Publik A",
  "Plaza Pemkab Bandung A",
  "Simpang Desa Soreang",
  "Pasar Ikan Modern",
  "Rsud Otto Iskandar Dinata",
  "Pengendapan Tmp 1d",
  "Hotel Soreang B",
  "Sumber Sari Junction",
  "Halte Soekarno Hatta 3 (Pasar Induk)",
  "Halte Soekarno Hatta Leuwi Panjang"
)

# Filter entries based on name
filtered_data <- data[data$properties$name %in% names_to_filter, ]

# Function to extract coordinates or return NA NA if no coordinates exist
extract_coordinates <- function(coord) {
  if (length(coord) > 0) {
    paste(coord, collapse = " ")
  } else {
    print("hiimnotexist")
  }
}

# Extract coordinates or NA NA if no coordinates exist
coordinates <- lapply(filtered_data$geometry$coordinates, extract_coordinates)

# Output coordinates with separate lines
cat(paste(coordinates, collapse = "\n"))

check_name <- function(name, data) {
  # Filter entries based on partial name matching
  filtered_data <- data[grepl(name, data$properties$name, ignore.case = FALSE), ]

  # Function to extract coordinates or return "NA NA" if no coordinates exist
  extract_coordinates <- function(coord) {
    if (length(coord) > 0) {
      paste(coord, collapse = " ")
    } else {
      "hiimnotexist"
    }
  }

  if (nrow(filtered_data) > 0) {
    coordinates <- lapply(filtered_data$geometry$coordinates, extract_coordinates)
    cat(paste(coordinates, collapse = "\n"), "\n")
  } else {
    print("NA")
  }
}