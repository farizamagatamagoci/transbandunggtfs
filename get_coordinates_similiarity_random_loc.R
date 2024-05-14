# Load necessary libraries
library(ggmap)
library(dplyr)
library(openxlsx)

register_google(key = "API_KEY")

# Set your locations
locations <- c(
  "87.7 Hard rock Fm Bandung",
  "Sulaksana",
  "Abdul Hamid",
  "Puslitbang Jalan Dan Jembatan",
  "Borma Nasution",
  "Halte Nasution",
  "Jembatan Pelangi (Kiara Artha)",
  "Muj",
  "Simpang Lima (A. Yani)",
  "Panin Bank",
  "Kasim",
  "Badan Keuangan Negara",
  "Halte Otto Iskandardinata",
  "Peta Muara",
  "Seberang Taman Sumringah",
  "Dinas Koperasi Dan Usaha Kecil",
  "Halte Smkn 6 (Bnn)",
  "Gmw Motor",
  "Halte Tmb Kantor Pos",
  "Depo Bangunan",
  "Lotte Mart",
  "Showroom Hyundai",
  "Samsat",
  "Unibi",
  "Jasa Raharja",
  "Halte Pt Suparma",
  "Halte Ariesta Yamaha",
  "Halte Guru Minda",
  "Sumbersari",
  "Naga Mas",
  "Sindangreret",
  "Ciguruwik",
  "Cikalang",
  "Vbi",
  "Halte Shakti",
  "Ratnasasih Shelter",
  "Jingganegara Shelter",
  "Subanglarang Shelter",
  "Cbcs",
  "Pasteur 1",
  "Seberang Tpu Pandu",
  "Kasmin",
  "Asep Berlian",
  "Samping Spbu Laswi",
  "Sukasenang Raya",
  "Bkkbn",
  "Surapati 1",
  "Surapati 2",
  "Lemahnendeut",
  "Sarimanis",
  "Rajawali 2",
  "Masjid Saifuddaulah",
  "Arya Graha",
  "Halte Carrefour",
  "Garuda",
  "Taman Sakura Indah",
  "Altamira",
  "Magna Raya",
  "Taman Sumringah",
  "Sukaraja II",
  "Cipedes Selatan",
  "Cipedes Hilir",
  "Underpass Cibogo"
)

# Initialize an empty data frame to store results
coordinates_df <- data.frame()

# Geocode each location
for (location in locations) {
  # Geocode location using autocomplete
  geo_data <- geocode(location, source = "google", messaging = FALSE)

  # Extract latitude and longitude from the first result
  if (length(geo_data) > 0) {
    lat <- geo_data$lat[1]
    lon <- geo_data$lon[1]

    # Add to data frame
    coordinates_df <- rbind(coordinates_df, data.frame(Location = location, Latitude = lat, Longitude = lon))
  } else {
    warning(paste("No results found for:", location))
  }
}

# Print the resulting data frame
print(coordinates_df)

# Export the dataframe to Excel
write.xlsx(coordinates_df, file = "coordinates.xlsx", row.names = FALSE)
