

# Step 1 load the dataset ####
load("D:/Users/OneDrive/proyects/priority_research_projects/ovitraps_sample_size/8.RData/ovitrap_sample_size_for_models_ver_2015_2019.RData")



# Step 2. count the blocks and ovitrap by year and week ####
y <- x %>%
    dplyr::mutate(id_manz = paste(mpo, loc, sector, manzana, sep = "")) %>%
    dplyr::group_by(year, week) %>%
    dplyr::summarise(n_ovitrap = length(unique(ovitrap)),
                     n_mza = length(unique(id_manz)))


# Step 3. plot the block and ovitraps by week and year ####

ggplot(data = y,
       aes(x = week)) +
    geom_line(aes(y = n_ovitrap), col = "darkgreen") +
    geom_line(aes(y = n_mza/.3), col = "darkred") +
    facet_wrap(facets = "year", scales = "free_y") +
    fishualize::scale_color_fish_d(option = "Scarus_quoyi") +
    xlab("Semanas Epidemiológicas") +
    scale_y_continuous(
        
        # Features of the first axis
        name = "Número de Ovitrampas",
        
        # Add a second axis and specify its features
        sec.axis = sec_axis(~.*.3, name= "Número de Manzanas")) +
    theme(
        axis.title.y = element_text(color = "darkgreen", 
                                    size=13),
        axis.title.y.right = element_text(color = "darkred", 
                                          size=13)) 

# Step 4. save the plot ####
ggsave(filename = "4.Graph/manzanas&ovitrampas_instaladas.jpg",
       dpi = 300)