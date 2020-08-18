

# Step 1 load the datasets 2012-2014 and 2019. ####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_100_2012_2014.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_100_2019.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_200_2012_2014.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_200_2019.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_300_2012_2014.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_300_2019.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_400_2012_2014.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_400_2019.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_500_2012_2014.RData")
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/results_models/betas_logit_500_2019.RData")


# Step 2 add the variable buffer ####
betas_logit_100_2012_2014$buffer <- "Buffer 100 m"
betas_logit_100_2019$buffer <- "Buffer 100 m"

betas_logit_200_2012_2014$buffer <- "Buffer 200 m"
betas_logit_200_2019$buffer <- "Buffer 200 m"

betas_logit_300_2012_2014$buffer <- "Buffer 300 m"
betas_logit_300_2019$buffer <- "Buffer 300 m"

betas_logit_400_2012_2014$buffer <- "Buffer 400 m"
betas_logit_400_2019$buffer <- "Buffer 400 m"

betas_logit_500_2012_2014$buffer <- "Buffer 500 m"
betas_logit_500_2019$buffer <- "Buffer 500 m"


# Step 3 row binding the datasets ####

x <- rbind(betas_logit_100_2019,betas_logit_100_2012_2014,
           betas_logit_200_2012_2014,betas_logit_200_2019, 
           betas_logit_300_2012_2014,betas_logit_300_2019,
           betas_logit_400_2012_2014,betas_logit_400_2019,
           betas_logit_500_2012_2014,betas_logit_500_2019)
rm(betas_logit_100_2019,betas_logit_100_2012_2014,
   betas_logit_200_2012_2014,betas_logit_200_2019, 
   betas_logit_300_2012_2014,betas_logit_300_2019,
   betas_logit_400_2012_2014,betas_logit_400_2019,
   betas_logit_500_2012_2014,betas_logit_500_2019)



# Step 4. set the factors ####
head(x)
x$lags <- factor(x$lags,
                 levels = c("Lag0","Lag1","Lag2","Lag3","Lag4"),
                 labels = c(0:4))
levels(x$lags)


# Step 5. make the plot ####

library(ggplot2)
ggplot(data = x,
       aes(x = lags,
           y = OR)) +
    facet_grid(facets = c("ANO", "buffer"), 
               scales = "free_y") +
    xlab("Lags") +
    ylab("Odds Ratio")+
    geom_pointrange(aes(ymin = OR_lower,
                        ymax = OR_upper),
                    size = 1) +
    geom_point(col = "darkgreen", size = 3) +
    geom_hline(yintercept = 1,
               col= "black",
               linetype = 1,
               alpha = 0.4) +
    theme(strip.text = element_text(size = 12, face  = "bold")) 

# Step 6. save the plot ####
ggsave(filename = "4.Graph/OR_test_negative_design_2012_2019.jpg",
       dpi = 300)


