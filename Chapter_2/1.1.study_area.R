
rm(list = ls())

# Step 2.1 load the kml ovitraps coordinates ####
y <- data.table::fread("D:/Users/OneDrive/datasets/SI_Monitoreo_Vectores/subsistema_vigilancia_dengue/Vigilancia_Entomologica/coordinates_ovitraps/ovitraps_coordinates final.csv")


# Step 2.2 convert df to sf ####
library(magrittr)
y <- y %>% 
    sf::st_as_sf(coords = c("Pocision_X", "Pocision_Y"),
                 crs = 4326)

# Step 3 load the sf objet of veracruz ####
library(sf)
x <- dendata::den_loc_mex %>%
    dplyr::filter(loc =="Veracruz")
plot(sf::st_geometry(x))

# Step 4. extract the ovitraps of veracruz ###
y_ver <- y[x,]


# Step 5. plot the map of veracruz  ####
library(ggplot2)
names(x)
ggplot() +
    geom_sf(data = x, 
            fill = "gray85", 
            col = "white",
            lwd = 0.5) +
    geom_sf(data = y_ver, 
            alpha = .5,
            col = "darkred",
            size = 0.1) +
    theme_void()

# Step 6. save the map #####
ggsave(filename = "6.Maps/ovitramps_maps_ver.jpg",
       dpi = 300)
