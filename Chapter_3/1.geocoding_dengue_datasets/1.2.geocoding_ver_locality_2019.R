
# Step 1. load the function for create the vector addresses and
# text manipulation 
source('D:/Users/Dropbox/ovitraps_activas&casesmx_klm/3.Functions/data_geocoden.R',
       encoding = 'UTF-8')


#  Step 2. generate the vector addresses ####
addresses <- data_geocoden(infile = "cases_control_ver_2019",
                           data = FALSE,
                           sinave_new = TRUE)

# Step 3. geocoding ###
library(ggmap)
denhotspots::geocoden(infile = "cases_control_ver_2019")


## Step 4. save the geocoded 2019 dengue dataset  of veracruz #####
z <- readRDS("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/cases_control_ver_2019_temp_geocoded.rds")
data <- denhotspots::data_geocoden(infile = "cases_control_ver_2019", 
                                   data = TRUE,
                                   sinave_new = TRUE)
denhotspots::save_geocoden(x = z,
                           y = data,
                           directory = "9.RData_geocoded",
                           loc = "cases_control_ver_2019")
