library(jsonlite)
library(stringdist)

# Read JSON data from file
data <- fromJSON("bandung_busstop_2.json")

# List of names to filter
names_to_filter <- c(
  "raja II",
  "Sumbersari",
  "Sumber sari"
)

# Function to check similarity between two strings using Jaro-Winkler distance
is_similar <- function(name1, name2, threshold = 0.5) {
  similarity <- stringdist::stringsim(name1, name2, method = "jw")
  similarity >= threshold
}

# Function to check if name exists in data and print coordinates if exists
check_name <- function(name, data) {
  # Filter entries based on similarity
  similar_names <- names_to_filter[sapply(names_to_filter, function(x) grepl(tolower(x), tolower(name)))]
  if (length(similar_names) > 0) {
    for (similar_name in similar_names) {
      filtered_data <- data[grepl(tolower(similar_name), tolower(data$properties$name)), ]
      if (nrow(filtered_data) > 0) {
        coordinates <- lapply(filtered_data$geometry$coordinates, function(coord) paste(coord, collapse = " "))
        cat(paste(coordinates[[1]], collapse = "\n"), "\n")
        return()
      }
    }
  }
  print("NA")
}

# Iterate over names to filter
for (name in names_to_filter) {
  print(paste("Checking for", name))
  check_name(name, data)
}