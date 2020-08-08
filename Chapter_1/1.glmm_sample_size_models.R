

# Step 1. load the ovitraps dataset of veracruz 2015-2019 ####
load("D:/Users/OneDrive/proyects/priority_research_projects/ovitraps_sample_size/8.RData/ovitrap_sample_size_for_models_ver_2015_2019.RData")

# Step 2. run the model and extract betas with nb #####
library(magrittr)
system.time(mod_nb <- ver_2015_2019 %>%
                dplyr::group_by(edo, loc, year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "nbinomial",
                                               aproximation = "laplace",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "nb")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))
