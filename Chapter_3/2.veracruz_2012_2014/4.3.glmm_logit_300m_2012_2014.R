

# Step 1. load the datasets #####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/caso_control_2012_2014_buffers.RData")


# Step 2. sample the cases and ovitraps #### this step is for equal sample size ###
library(magrittr)
y <- xy_buffer300 %>%
    sf::st_drop_geometry() %>%
    dplyr::select(ANO, SEM, VEC_EST, 185:213) %>%
    dplyr::group_by(ANO, SEM) %>%
    tidyr::nest() %>%
    dplyr::mutate(sample_index_ovi = purrr::map(data,
                                                phdfadm3::sample_index,
                                                sinave_new = FALSE)) %>%
    dplyr::select(-data) %>%
    tidyr::unnest(cols = c(sample_index_ovi))

names(y)
## Step 3. nested dataset ####
make_lag0_4 <- function(x){
    x$lags <- ifelse(x$SEM == x$week.1, "Lag0",
                     ifelse(x$SEM-1 == x$week.1, "Lag1",
                            ifelse(x$SEM-2 == x$week.1, "Lag2",
                                   ifelse(x$SEM-3 == x$week.1, "Lag3",
                                          ifelse(x$SEM-4 == x$week.1, "Lag4", NA)))))
    x
}

x <- y %>%
    dplyr::group_by(ANO) %>%
    tidyr::nest() %>%
    dplyr::mutate(lags = purrr::map(data,
                                    make_lag0_4)) %>%
    dplyr::select(-data) %>%
    tidyr::unnest(cols = c(lags))


# Step 4. apply the function adn run the model and extract betas ####
system.time(betas_logit_300_2012_2014 <- x %>%
                dplyr::filter(!is.na(lags)) %>%
                as.data.frame() %>%
                dplyr::group_by(ANO, lags) %>%
                dplyr::arrange(dplyr::desc(-SEM)) %>%
                tidyr::nest() %>%
                dplyr::mutate(mod = purrr::map(data, 
                                               phdfadm3::glmm_binary,
                                               #linK = "logit",
                                               sinave_new = FALSE,
                                               aproximation = "gaussian",
                                               integration = "eb")) %>%
                dplyr::mutate(or = purrr::map(mod, 
                                              phdfadm3::extract_betas,
                                              name = "OR",
                                              link = "logit")) %>%
                dplyr::select(-data, -mod) %>%
                tidyr::unnest(cols = c(or)))



# Step 5. save the results ####
save(betas_logit_300_2012_2014, 
     file = "8.RData/results_models/betas_logit_300_2012_2014.RData")

