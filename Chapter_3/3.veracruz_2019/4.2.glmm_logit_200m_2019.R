

# Step 1. load the datasets #####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/caso_control_buffers.RData")


# Step 2. sample the cases and ovitraps #### this step is for equal sample size ###
library(magrittr)
y <- xy_buffer200 %>%
    sf::st_drop_geometry() %>%
    dplyr::select(ANO, SEM, ESTATUS_CASO, 427:453) %>%
    dplyr::group_by(SEM) %>%
    tidyr::nest() %>%
    dplyr::mutate(sample_index_ovi = purrr::map(data,
                                                phdfadm3::sample_index,
                                                sinave_new = TRUE)) %>%
    dplyr::select(-data) %>%
    tidyr::unnest(cols = c(sample_index_ovi))



## Step 3. create the lags  ####
y$lags <- ifelse(y$SEM == y$week, "Lag0",
                 ifelse(y$SEM-1 == y$week, "Lag1",
                        ifelse(y$SEM-2 == y$week, "Lag2",
                               ifelse(y$SEM-3 == y$week, "Lag3",
                                      ifelse(y$SEM-4 == y$week, "Lag4", NA)))))

# Step 4. apply the function and run the model and extract betas ####
system.time(betas_logit_200_2019 <- y %>%
                dplyr::filter(!is.na(lags)) %>%
                as.data.frame() %>%
                dplyr::group_by(ANO, lags) %>%
                dplyr::arrange(dplyr::desc(-SEM)) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm3::glmm_binary,
                                               sinave_new = TRUE,
                                               #linK = "logit",
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(or = purrr::map(mod, 
                                              phdfadm3::extract_betas,
                                              name = "OR",
                                              link = "logit")) %>%
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(cols = c(or)))


# Step 5. save the betas ####
save(betas_logit_200_2019, 
     file = "8.RData/results_models/betas_logit_200_2019.RData")