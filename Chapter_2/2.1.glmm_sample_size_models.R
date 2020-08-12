
# Step 1. load the ovitraps dataset of veracruz 2015-2019 ####
load("D:/Users/OneDrive/proyects/priority_research_projects/ovitraps_sample_size/8.RData/ovitrap_sample_size_for_models_ver_2015_2019.RData")
library(magrittr)

# Step 2. run the model and extract betas with nb #####
library(furrr)
library(purrr)
library(future)
system.time(ver_mod2015_2019_nb <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo, year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = furrr::future_map(data, 
                                                      phdfadm::glmm_sample_size_eggs,
                                                      fam = "nbinomial",
                                                      aproximation = "gaussian",
                                                      integration = "eb")) %>%
                dplyr::mutate(betas = furrr::future_map(mod, 
                                                        phdfadm::extract_betas,
                                                        link = "nb")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))


# Step 3. run the model and extract betas with zinb0 #####
system.time(ver_mod2015_2019_zinb0 <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo, year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "zeroinflatednbinomial0",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "zinb0")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))


# Step 4. run the model and extract betas with zinb1 #####
system.time(ver_mod2015_2019_zinb1 <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo, year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "zeroinflatednbinomial1",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "zinb1")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))

# Step 5. run the model and extract betas with poisson #####
system.time(ver_mod2015_2019_p <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo,  year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "poisson",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "p")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))

# Step 6. run the model and extract betas with zip1 #####
system.time(ver_mod2015_2019_zip1 <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo,  year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "zeroinflatedpoisson1",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "zip1")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))


# Step 7. run the model and extract betas with zip0 #####
system.time(ver_mod2015_2019_zip0 <- ver_2015_2019 %>%
                dplyr::group_by(edo, mpo, year, week) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm::glmm_sample_size_eggs,
                                               fam = "zeroinflatedpoisson0",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(betas = purrr::map(mod, 
                                                 phdfadm::extract_betas,
                                                 link = "zip0")) %>% 
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(col = c(betas)))


# Step 8. row binding the datasets ####
ver_mod2015_2019_results <- rbind(ver_mod2015_2019_nb,
                                  ver_mod2015_2019_zinb0,
                                  ver_mod2015_2019_zinb1,
                                  ver_mod2015_2019_p,
                                  ver_mod2015_2019_zip0,
                                  ver_mod2015_2019_zip1)
# Step 9. save the results ####
save(ver_mod2015_2019_results,
     file = "8.RData/results_models/ver_mod2015_2019_results.RData")




