
# Step 1. load the dengue dataset 2008-2015 #####
load("D:/Users/Dropbox/Boletines/boletines_den_2020/8.RData/den2008_2015_ver.RData")
library(magrittr)
x <- den2008_2015_ver %>%
    dplyr::mutate(DES_MPO.x = stringr::str_trim(DES_MPO.x, side = "both"),
                  DES_LOC = stringr::str_trim(DES_LOC, side = "both")) %>%
    dplyr::filter(DES_MPO.x %in% c("VERACRUZ", "BOCA DEL RIO")) %>%
    dplyr::mutate(date = lubridate::ymd_hms(FEC_INI_SIGNOS),
                  DES_DIAG_FINAL = stringr::str_trim(DES_DIAG_FINAL, side = "both"),
                  year = lubridate::year(date),
                  week = lubridate::epiweek(date)) %>%
    dplyr::filter(DES_DIAG_FINAL %in% c("FIEBRE HEMORRAGICA POR DENGUE", "FIEBRE POR DENGUE")) %>%
    dplyr::group_by(date, year, week) %>%
    dplyr::summarise(cont = dplyr::n()) %>%
    as.data.frame()
table(x$DES_LOC)


# Step 2. load the dengue dataset 2016-2019 ####
load("D:/Users/Dropbox/1.Read_Automatic_dataset_platform/RData/sinave/den2008_2019_r.RData")
y <- den2008_2019_r %>%
    dplyr::filter(ANO %in% c(2016:2019)) %>%
    dplyr::filter(DES_EDO_RES == "VERACRUZ") %>%
    dplyr::filter(DES_MPO_RES %in% c("VERACRUZ", "BOCA DEL RIO")) %>%
    dplyr::mutate(date = lubridate::ymd(FEC_INI_SIGNOS_SINT),
                  DES_DIAG_FINAL = stringr::str_trim(DES_DIAG_FINAL, side = "both"),
                  year = lubridate::year(date),
                  week = lubridate::epiweek(date)) %>%
    dplyr::filter(DES_DIAG_FINAL %in% c("DENGUE CON SIGNOS DE ALARMA", "DENGUE GRAVE", "DENGUE NO GRAVE")) %>%
    dplyr::group_by(date, year, week) %>%
    dplyr::summarise(cont = dplyr::n()) %>%
    as.data.frame()

rm(den2008_2015_ver, den2008_2019_r)


# Step 3. load the dengue dataset 2020 ####
z <- data.table::fread("1.Datasets/DENGUE_(1).txt", 
                       header = TRUE,
                       fill = TRUE,
                       quote="") %>%
    dplyr::filter(DES_EDO_RES == "VERACRUZ") %>%
    dplyr::filter(DES_MPO_RES %in% c("VERACRUZ", "BOCA DEL RIO")) %>%
    dplyr::mutate(date = lubridate::ymd(FEC_INI_SIGNOS_ALARMA),
                  DES_DIAG_FINAL = stringr::str_trim(DES_DIAG_FINAL, side = "both"),
                  year = lubridate::year(date),
                  week = lubridate::epiweek(date)) %>%
    dplyr::filter(DES_DIAG_FINAL %in% c("DENGUE CON SIGNOS DE ALARMA", 
                                        "DENGUE GRAVE", 
                                        "DENGUE NO GRAVE")) %>%
    dplyr::group_by(date, year, week) %>%
    dplyr::summarise(cont = dplyr::n()) %>%
    as.data.frame()
table(z$year)

# Step 4. row binding the datasets ####
xyz <- rbind(x, y, z) %>%
    dplyr::filter(year > 2000)
rm(x, y, z)
head(xyz)

table(xyz$year)
# make the graph ####
library(ggplot2)
library(scales)
ggplot(data = xyz %>% dplyr::filter(year > 2000),
       aes(x = as.Date(date),
           y = cont)) +
    geom_line(colour = "black", 
              #fill = "firebrick4", 
              alpha = 0.9) +
    ylab("Número de Casos") +
    xlab("") +
    geom_vline(xintercept = c(as.Date("2008-01-01"),
                              as.Date("2009-01-01"),
                              as.Date("2010-01-01"),
                              as.Date("2011-01-01"),
                              as.Date("2012-01-01"),
                              as.Date("2013-01-01"),
                              as.Date("2014-01-01"),
                              as.Date("2015-01-01"),
                              as.Date("2016-01-01"),
                              as.Date("2017-01-01"),
                              as.Date("2018-01-01"),
                              as.Date("2019-01-01"),
                              as.Date("2020-01-01")),
               col= "gray45",
               linetype = 2,
               alpha = 0.4) +
    scale_x_date(date_breaks = "1 year", date_labels = "%Y")

ggsave(filename = "4.Graph/time_series_dengue_loc_ver.jpg",
       dpi = 300)

