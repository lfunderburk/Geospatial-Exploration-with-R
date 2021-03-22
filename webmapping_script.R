## Exploring web mapping with Leaflet
## March 21 2021 
## With Laura G. Funderburk and Sarah ...
## Script inspired on Aetaka Shashank's instructional material
##   https://aticup.github.io/webmapr/

## We will begin by installing the folloring packages
# leaflet - parsing and displaying geographical data
# tidyverse - ease data manipulation and visualization
# sp
# sf
# maps - render maps

# Run this command once
#install.packages("leaflet")
#install.packages("tidyverse")
#install.packages("sp")
#install.packages("sf")
#install.packages("maps")
#install.packages("jsonlite")
#install.packages("tidyjson")

library(leaflet)
library(magrittr)
library(jsonlite)
library(tidyverse)
library(tidyjson)
library(sf)

# Read art data
art_data <- read.csv("public-art.csv",sep=";")

# Clean data
# Remove "" entries in art_data
art_data <- art_data[!(is.na(art_data$Geom) | art_data$Geom==""), ]

# "Flatten" column Geom
geom_dat <- art_data$Geom %>% 
  map_dfr(~ fromJSON(.x) %>% 
            as.data.frame)

# Ensure correct data structure
geom_dat <- as.vector(geom_dat)

# Generate latitude and longitude
art_data$latitude <-geom_dat$coordinates[seq(2,800,2)]
art_data$longitude <-geom_dat$coordinates[seq(1,800,2)]


# Generate our first map using coordinates
map_1 <- leaflet() %>% # Creates leaflet map widget
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(lng = -123.134604,
             lat = 49.239068,
             popup = "Horizontal Column (1975)")

map_1


# Generate plot
map2 <- leaflet() %>% 
  addProviderTiles(providers$CartoDB.Voyager) %>%
  setView(-123.12402, 49.2474, zoom = 12)  %>% 
  addCircleMarkers(data = art_data, 
                   lat = art_data$latitude, 
                   lng = art_data$longitude,
                   color = "black", fill = TRUE, opacity = 1,
                   radius = 2, weight = 1,
                   popup = paste("Year of Installation:", art_data$YearOfInstallation, "<br>",
                                 "URL:", art_data$URL, "<br>"))
map2

# Adding local area boundary
nbh <- st_read("local-area/local-area-boundary.shp")
van <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Voyager) %>%
  setView(-123.12402, 49.2474, zoom = 12) %>%
  addPolygons(data = nbh, color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.3,
              fillColor = "brown",
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE),
              popup = paste("Neighborhood: ", nbh$name, "<br>"))
van

# Bringing it all together
van2 <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Voyager) %>%
  setView(-123.12402, 49.2474, zoom = 12)  %>%
  addPolygons(data = nbh, color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.3,
              fillColor = "brown",
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE),
              popup = paste("Neighborhood: ", nbh$name, "<br>")) %>%
  addCircleMarkers(data = art_data, 
                   lat = art_data$latitude, 
                   lng = art_data$longitude,
                   color = "black", fill = TRUE, opacity = 1,
                   radius = 2, weight = 1,
                   popup = paste("Year of Installation:", art_data$YearOfInstallation, "<br>",
                                 "URL:", art_data$URL, "<br>"))
van2

# Select longitude and latitude using coordinate reference system
# WGS84 (EPSG: 4326)
## Commonly used by organizations that provide GIS data for the entire globe or many countries. CRS used by Google Earth

dsf <- sf::st_as_sf(art_data, coords=c("longitude","latitude"), crs=4326)

# Convert foreign object to an sf object
map <- sf::st_as_sf(nbh)
# Transform into CRS 4326 - matching CRS as data point
map <- st_transform(map,crs=4326)

# Plot for visual reference, uses sf::plot_sf:
plot(map, reset=FALSE)
plot(dsf, add=TRUE, reset=FALSE, pch=16, col="red", cex=0.5)
axis(1, line=-1) ; axis(2, line=-1, las=1)

# Find country of each coordinate:
# 2163
int <- st_intersection(map, dsf)

# Compute frequency 
frequency <- as.data.frame(table(int$name))
colnames(frequency) <- c("Neighborhood", "ArtFrequency")

# Sort in descending order
frequency[order(-frequency$ArtFrequency),]
