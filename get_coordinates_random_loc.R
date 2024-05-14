# Load necessary libraries
library(ggmap)
library(dplyr)

register_google(key = "API_KEY")

# Set your locations
locations <- c(
  "87.7 Hard rock Fm",
  "Underpass Cibogo"
)

# Initialize an empty data frame to store results
coordinates_df <- data.frame()

# Geocode each location
for (location in locations) {
  # Geocode location
  geo_data <- geocode(location, source = "google", region = "ID", output = "more")

  # Extract latitude and longitude
  lat <- geo_data$lat
  lon <- geo_data$lon

  # Add to data frame
  coordinates_df <- rbind(coordinates_df, data.frame(Location = location, Latitude = lat, Longitude = lon))
}

# Print the resulting data frame
print(coordinates_df)