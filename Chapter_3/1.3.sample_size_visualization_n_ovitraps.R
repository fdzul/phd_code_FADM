

# Step 0. load the function ####
source('D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/3.Functions/sample_index.R')
source('D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/3.Functions/n_ovitraps.R')

# Step 1.1 load the datasets 2012-2014 #####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/caso_control_2012_2014_buffers.RData")

library(magrittr)

# 1.2 apply the function and extract the ovitraps number of 2012 t0 2014 ####
buffer100_2012_2014 <- n_ovitraps(xy_buffer100, buffer = "Buffer 100 m",  sinave_new = FALSE)
buffer200_2012_2014 <- n_ovitraps(xy_buffer200, buffer = "Buffer 200 m",  sinave_new = FALSE)
buffer300_2012_2014 <- n_ovitraps(xy_buffer300, buffer = "Buffer 300 m",  sinave_new = FALSE)
buffer400_2012_2014 <- n_ovitraps(xy_buffer400, buffer = "Buffer 400 m",  sinave_new = FALSE);rm(xy_buffer100, xy_buffer200, xy_buffer300, xy_buffer400)
buffer500_2012_2014 <- n_ovitraps(xy_buffer500, buffer = "Buffer 500 m",  sinave_new = FALSE);rm(xy_buffer500)

# Step 2.1 load the datasets 2019 #####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/caso_control_buffers.RData")

# 2.2 apply the function and extract the ovitraps number of 2012 t0 2014 ####
buffer100_2019 <- n_ovitraps(xy_buffer100, buffer = "Buffer 100 m",  sinave_new = TRUE)
buffer200_2019 <- n_ovitraps(xy_buffer200, buffer = "Buffer 200 m",  sinave_new = TRUE)
buffer300_2019 <- n_ovitraps(xy_buffer300, buffer = "Buffer 300 m",  sinave_new = TRUE)
buffer400_2019 <- n_ovitraps(xy_buffer400, buffer = "Buffer 400 m",  sinave_new = TRUE);rm(xy_buffer100, xy_buffer200, xy_buffer300, xy_buffer400)
buffer500_2019 <- n_ovitraps(xy_buffer500, buffer = "Buffer 500 m",  sinave_new = TRUE);rm(xy_buffer500)


# Step 4. rowbindin the dataset
names(buffer100_2012_2014) <- names(buffer100_2019)
names(buffer200_2012_2014) <- names(buffer100_2019)
names(buffer300_2012_2014) <- names(buffer100_2019)
names(buffer400_2012_2014) <- names(buffer100_2019)
names(buffer500_2012_2014) <- names(buffer100_2019)

xy <- rbind(buffer100_2012_2014, buffer100_2019,
            buffer200_2012_2014, buffer200_2019,
            buffer300_2012_2014, buffer300_2019,
            buffer400_2012_2014, buffer400_2019,
            buffer500_2012_2014, buffer500_2019); rm(buffer100_2012_2014, buffer100_2019,
                                                     buffer200_2012_2014, buffer200_2019,
                                                     buffer300_2012_2014, buffer300_2019,
                                                     buffer400_2012_2014, buffer400_2019,
                                                     buffer500_2012_2014, buffer500_2019)


# Step 5. plot the dengue cases ####

library(ggplot2)
names(xy)
ggplot(data  = xy,
       aes(x = SEM,
           fill = ESTATUS_CASO,
           y = n_ovitraps)) +
    geom_bar(stat = "identity", 
             alpha = 0.7,
             position = "fill")+
    facet_grid(facets = c("ANO", "buffer"), 
               scales = "free_y") +
    xlab("Semana Epidemiológica") +
    ylab("Fracción") +
    theme(legend.position = "none") +
    theme(strip.text = element_text(size = 12, face  = "bold")) +
    scale_fill_manual(values = c("darkblue", "darkred"))


# Step 6. save the plor #####
ggsave(filename = "4.Graph/sample_size_ovitraps_visualization.jpg",
       dpi = 300)
