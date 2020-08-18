
# Step 1. load the dengue cases 2019 ####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/case_control_ver_2019.RData")

y <- x %>%
    dplyr::group_by(ANO, SEM, ESTATUS_CASO) %>%
    dplyr::summarise(n = dplyr::n())

# Step 2. load the dengue cases 2012-201 ####
load("D:/Users/OneDrive/proyects/priority_research_projects/test_negative_design_ver/8.RData/case_control_ver_2012_2014.RData")

x <- x %>%
    dplyr::group_by(ANO, SEM, VEC_EST) %>%
    dplyr::summarise(n = dplyr::n())

# Step 3. rowbinding the both dataset ####
names(x) <- names(y)
xy <- rbind(x, y); rm(x, y)


# Step 4. plot the dengue cases ####

library(ggplot2)
ggplot(data  = xy,
       aes(x = SEM,
           fill = ESTATUS_CASO,
           y = n)) +
    geom_bar(stat = "identity", 
             alpha = 0.7,
             position = "fill")+
    facet_wrap(facet = "ANO") +
    xlab("Semana Epidemiológica") +
    ylab("Fracción") +
    theme(legend.position = "none") +
    theme(strip.text = element_text(size = 12, face  = "bold")) +
    scale_fill_manual(values = c("darkblue", "darkred"))


# Step 5. save the plot####
ggsave(filename = "4.Graph/sample_size_visualization.jpg",
       dpi = 300)    

