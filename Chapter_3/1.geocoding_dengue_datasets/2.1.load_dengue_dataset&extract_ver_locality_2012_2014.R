# Step 1. load the dengue dataset 2008-2015 #####
load("D:/Users/Dropbox/Boletines/boletines_den_2020/8.RData/den2008_2015_ver.RData")
library(magrittr)


# step 2. extract the locality ####
x <- den2008_2015_ver %>%
    dplyr::filter(ANO %in% c(2012:2014)) %>%
    dplyr::mutate(DES_MPO.x = stringr::str_trim(DES_MPO.x, side = "both"),
                  DES_LOC = stringr::str_trim(DES_LOC, side = "both")) %>%
    dplyr::filter(DES_MPO.x %in% c("VERACRUZ", "BOCA DEL RIO")) %>%
    dplyr::filter(DES_LOC %in% c("BOCA DEL RÍO", "BOCA DEL RIO", "VERACRUZ")) %>%
    dplyr::mutate(date = lubridate::ymd_hms(FEC_INI_SIGNOS),
                  DES_DIAG_FINAL = stringr::str_trim(DES_DIAG_FINAL, side = "both"),
                  year = lubridate::year(date),
                  week = lubridate::epiweek(date)) %>%
    dplyr::filter(VEC_EST %in% c(2,3)) %>%
    dplyr::mutate(VEC_EST = ifelse(VEC_EST == 2, "POSITIVO", "NEGATIVO")) %>%
    dplyr::filter(IDE_EDA_ANO <= 12 | IDE_EDA_ANO >= 65)



# Step 3. save the dataset #### 
write.csv(x, file  = "cases_control_ver_2012_2014.csv")