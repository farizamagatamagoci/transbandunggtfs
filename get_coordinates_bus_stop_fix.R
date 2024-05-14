library(jsonlite)

# Read JSON data from file
data <- fromJSON("bus_stop_in_bandung.json")

# List of names to filter
names_to_filter <- c(
  "Jalan Bandung - Palimanan 52",
  "Mekarwangi",
  "Jalan Soekarno Hatta, 388",
  "Jalan Soekarno Hatta 198",
  "Sumbersari",
  "Cibuntu Selatan",
  "Ypp Teknik (Holis)",
  "Jalan Soekarno Hatta 8"
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