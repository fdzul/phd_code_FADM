

# Step 1.2 load the function
source('D:/Users/Dropbox/1.Read_Automatic_dataset_platform/Functions/2.Load_automatic_ovitraps_readings.R')


## Step 1.1 apply the function for ovitrap dataset 2019 of veracruz ###
system.time(x <- load_ovitraps_readings(path = "1.Datasets/ovitrampas_2019",
                                        years = c("2019"),
                                        header = TRUE))
library(data.table)


# load the # Step 2. load the kml ovitraps coordinates ####
y <- data.table::fread("D:/Users/Dropbox/1.Read_Automatic_dataset_platform/datasets/ovitraps_coordinates final.csv")


x[,ovitrap := bit64::as.integer64(ovitrap)]

# step 3. left_joint the ovitraps with the coordinates ####
system.time(x <- dplyr::left_join(x = x,
                                  y = y,
                                  by = c("ovitrap"= "Ovitrampa")))

x <- x[!is.na(x$Pocision_X),]

# 4. load the locality of veracruz ####
library(magrittr)
library(sf)
ver_sf <- dendata::den_loc_mex %>% dplyr::filter(loc == "Veracruz")



# 5. transform to sf objet the dataset ####

x$latitud <- x$Pocision_Y
x$longitud <- x$Pocision_X
x <- sf::st_as_sf(x, 
                  coords = c("Pocision_X", "Pocision_Y"),
                  crs = 4326)

# Step 6. extract the ovitraps ##

ovitraps_ver_2019 <- x[ver_sf,]


# 7. save the results ###
save(ovitraps_ver_2019, file = "8.RData/ovitraps_ver_2019.RData")


