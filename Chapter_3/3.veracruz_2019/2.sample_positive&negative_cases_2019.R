rm(list = ls())
# Step 1. load the dataset ####
load("D:/Users/Dropbox/test_negative_design/9.RData_geocoded/geo_cases_control_ver_age_group_2019.RData")
table(y$year, y$VEC_EST)
library(magrittr)
y <- y %>% 
    dplyr::mutate(longitud = long,
                  latitud = lat) %>%
    as.data.frame() %>%
    sf::st_as_sf(coords = c("long", "lat"),
                 crs = 4326)
class(y)


# Step 2. extract the dengue cases only veracruz ####
ver <- dendata::den_loc_mex %>% dplyr::filter(loc == "Veracruz")

y <- y[ver,]

table(y$ANO, y$ESTATUS_CASO)


# Step 3. sample the cases by week and year ####
source('D:/Users/Dropbox/test_negative_design/3.Functions/sample_cases.R')
library(data.table)

phdfadm3::sample_cases()
# Step 3.1 test before sample the dataset #### 
y %>%
    sf::st_drop_geometry() %>%
    as.data.frame() %>%
    dplyr::group_by(ANO, SEM, ESTATUS_CASO) %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::arrange(desc(-SEM)) %>%
    tidyr::pivot_wider(id_cols = c(-n, -ESTATUS_CASO),
                       values_from = n,
                       values_fill = 0,
                       names_from = ESTATUS_CASO)

# Step 3.2 sample the dataset #### 
x <- y %>%
    dplyr::group_by(ANO, SEM) %>%
    dplyr::arrange(dplyr::desc(-SEM)) %>%
    tidyr::nest() %>%
    dplyr::mutate(case_control = purrr::map(data,
                                            phdfadm3::sample_cases,
                                            sinave_new = TRUE)) %>%
    dplyr::select(-data)%>%
    tidyr::unnest(cols = case_control, keep_empty = FALSE)


# Step 3.3 test after sample the dataset #### 
x %>%
    as.data.frame() %>%
    dplyr::group_by(ANO, SEM, ESTATUS_CASO) %>%
    dplyr::summarise(n = dplyr::n()) %>%
    dplyr::arrange(desc(-SEM)) %>%
    tidyr::pivot_wider(id_cols = c(-n, -ESTATUS_CASO),
                       values_from = n,
                       values_fill = 0,
                       names_from = ESTATUS_CASO)


# Step 4. save the results ####
save(x, file = "8.RData/case_control_ver_2019.RData")


