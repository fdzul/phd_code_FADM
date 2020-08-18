
# Step 1. load the dengue cases dataset ####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/case_control_ver_2012_2014.RData")

# Step 2. load the ovitrap dataset ####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/ovitraps_ver_2012_2014.RData")



# Step 2. create the function for calculate dg to meters ####
dg_m <- function(x, dg){
    if(dg == TRUE){
        x * (111.111 * 1000)
    } else {
        x/(111.111 * 1000)
    }
}

# Step 2.1 decimal degree to meters/1000 = kilometer ####
dg_m(x = 0.001, dg = TRUE)
dg_m(x = 0.01, dg = TRUE)/1000
dg_m(x = 1, dg = TRUE)/1000
dg_m(x = .1, dg = TRUE)/1000

## Step 2.3. 100, 200, 300, and 400 meters to decimal degree#####
round(dg_m(x = 100, dg = FALSE), digits = 3)
round(dg_m(x = 200, dg = FALSE), digits = 3)
round(dg_m(x = 300, dg = FALSE), digits = 3)
round(dg_m(x = 400, dg = FALSE), digits = 3)

# Step 3. covert the case control to sf ####
names(x)
x <- x %>% as.data.frame() %>%
    dplyr::mutate(long = longitud,
                  lat = latitud) %>%
    sf::st_as_sf(coords = c("long", "lat"),
                 crs = 4326)

# Step 4. make the buffers for each case and control ####
x_buffer100 <- sf::st_buffer(x, dist = 0.001)
x_buffer200 <- sf::st_buffer(x, dist = 0.002)
x_buffer300 <- sf::st_buffer(x, dist = 0.003)
x_buffer400 <- sf::st_buffer(x, dist = 0.004)
x_buffer500 <- sf::st_buffer(x, dist = 0.005)



# Step 5.Extract the ovitraps for each buffer ####

xy_buffer100 <- sf::st_intersection(x = x_buffer100,
                                    y = ovitraps_ver_2012_2014)
xy_buffer200 <- sf::st_intersection(x = x_buffer200,
                                    y = ovitraps_ver_2012_2014)
xy_buffer300 <- sf::st_intersection(x = x_buffer300,
                                    y = ovitraps_ver_2012_2014)
xy_buffer400 <- sf::st_intersection(x = x_buffer400,
                                    y = ovitraps_ver_2012_2014)
xy_buffer500 <- sf::st_intersection(x = x_buffer500,
                                    y = ovitraps_ver_2012_2014)


# Step 6. save the results ####
save(xy_buffer100, xy_buffer200, xy_buffer300,
     xy_buffer400, xy_buffer500,
     file = "8.RData/caso_control_2012_2014_buffers.RData")


# nota en buffer 400 and 500 many ovitraps 
# is many cases an control ####

# note................
# I think we need againg sampling the dengue cases
# for ensure that in specific week/year the
# number of positive and negative cases are similar




