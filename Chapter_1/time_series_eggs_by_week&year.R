rm(list = ls())
# Step 1 load the dataset ####
load("D:/Users/OneDrive/proyects/priority_research_projects/ovitraps_sample_size/8.RData/ovitrap_sample_size_for_models_ver_2015_2019.RData")


# Step 2. plot the meand eggs by week and year #### 
library(ggplot2)
library(fishualize)

ggplot(data = x,
       aes(x = week,
           y = eggs)) +
    stat_summary(fun = mean, 
                 geom = "line", 
                 aes(colour = n), 
                 size = 1) +
    facet_wrap(facets = "year", scales = "free_y") +
    fishualize::scale_color_fish_d(option = "Scarus_quoyi") +
    ylab("Número Promedio de Huevos") +
    xlab("Semanas Epidemiológicas") +
    theme(legend.position = c(.8, .35)) +
    theme(legend.background = element_blank()) +
    theme(legend.key = element_blank()) +
    theme(legend.title = element_blank()) 

# Step 3. save the results ####
ggsave(filename = "4.Graph/times_series_plot_eggs.jpg",
       dpi = 300)