
# Step 1. load the dengue dataset and extract the locality ####
library(magrittr)

x <- data.table::fread("1.Datasets/DENGUE_2019.txt", 
                       header = TRUE, quote="", fill=TRUE) %>%
    as.data.frame() %>%
    dplyr::filter(CVE_EDO_RES == 30) %>%
    dplyr::filter(DES_MPO_RES %in% c("VERACRUZ", "BOCA DEL RIO") &
                      DES_LOC_RES %in% c("BOCA DEL RÍO","VERACRUZ")) %>%
    dplyr::filter(ESTATUS_CASO %in% c(2,3)) %>%
    dplyr::mutate(ESTATUS_CASO = ifelse(ESTATUS_CASO == 2, "POSITIVO", "NEGATIVO")) %>%
    dplyr::filter(IDE_EDA_ANO <= 12 | IDE_EDA_ANO >= 65) 


# Step 2. save the dataset #### 
write.csv(x, file  = "cases_control_ver_age_group_2019.csv")