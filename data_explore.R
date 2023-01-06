## Load required packages ----
if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

######################################################
pacman::p_load(
    tidyverse, janitor, skimr,
    ggthemes, arrow, shiny, glue,
    dtplyr, data.table, mapproj, 
    plotly, leaflet, remotes, shiny.react,
    shiny.fluent
)

######################################################
## Vie data ----
prelim_data <- read_csv("biodiversity-data/occurence.csv", 
         n_max = 30)

glimpse(prelim_data)
head(prelim_data$country)

######################################################
col_names <- read_csv("biodiversity-data/occurence.csv", 
                      n_max = 3) %>% names()

col_classes <- apply(read.csv("biodiversity-data/occurence.csv", 
                               nrows = 3), 2, class)

read_csv("biodiversity-data/my_data.csv", 
      
                       #colClasses = col_classes,
                       col_names = col_names
      
      ) %>% 
    select(country, locality, eventDate, longitudeDecimal, latitudeDecimal, 
           scientificName, vernacularName, individualCount) %>% 
    mutate(vernacularName = case_when(
        
        is.na(vernacularName) ~ scientificName,
        
        TRUE ~ vernacularName
        
    )) %>% 
    
    mutate(scientificName = case_when(
        
        is.na(scientificName) ~ vernacularName,
        
        TRUE ~ scientificName
        
    )) %>% 
    
    mutate(vernacularName = str_to_sentence(vernacularName),
           scientificName = str_to_sentence(scientificName)) %>% 
    
    rename(longitude = longitudeDecimal, 
           latitude = latitudeDecimal) %>% 
    
    filter(individualCount > 0) %>% 
    
    mutate(year = lubridate::year(eventDate)) %>% 
    
    select(-eventDate) %>% 
    
    write_csv("final_data.csv")

#########################################################
## START OF THE APPLICATION ----
##########################################################
final_data <- read_csv("final_data.csv",
         
         col_types = 'ccDddccd')

head(final_data)
#########################################################
## Get maps data ----
maps_data <- map_data("world") %>%
    filter(region %chin% c("Poland", "Germany")) %>% 
    as_tibble()

## Filter species of choice ----
species <- final_data %>% 
    rename(longitude = longitudeDecimal, 
           latitude = latitudeDecimal) %>% 
    filter(individualCount > 0) %>% 
    filter(scientificName == "Abramis brama") 

## Create the map and the species points ----
maps_data %>% 
    ggplot() +
    geom_map(mapping = aes(x = long, y = lat, map_id = region), 
             map = maps_data,
             color = 'gray30', fill = 'gray90', size = 0.2) + 
    geom_point(data = species, 
               mapping = aes(x = longitudeDecimal, 
                             y = latitudeDecimal, 
                             size = individualCount),
               show.legend = FALSE, shape = 1) + 
    labs(x = "", y = "", 
         title = glue::glue("Prevalence of {species %>% select(scientificName) %>% distinct()} in Germany and Poland")) + 
             theme_minimal() + 
    coord_map('ortho', orientation = c(51, 19, 0))




final_data %>% 
    filter(individualCount > 0) %>% 
    filter(scientificName == "Abia fasciata") %>% 
    distinct(scientificName) %>% 
    pull(scientificName)

final_data %>% 
    filter(country %in% c("Germany", "Poland")) %>% 
    select(scientificName) %>% 
    arrange(scientificName) %>% 
    distinct(scientificName) %>% 
    pull(scientificName)

leaflet(species) %>% 
    addTiles() %>% 
    addCircles(color = "black", 
               radius = ~ individualCount^3.5,
               stroke = TRUE) %>% 
    addCircles()

#########################################
leaflet(
    final_data %>% 
        rename(longitude = longitudeDecimal, 
               latitude = latitudeDecimal) %>% 
        filter(individualCount > 0) %>% 
        filter(scientificName == "Abax parallelepipedus") 
) %>% 
    addTiles() %>% 
    addCircles(color = "black", 
               radius = ~ individualCount^3.5,
               stroke = TRUE,
               fillOpacity = 0.7
               )
#################################
leaflet(
    
    final_data %>% 
        rename(longitude = longitudeDecimal, 
               latitude = latitudeDecimal) %>% 
        filter(individualCount > 0) %>% 
        filter(scientificName == "Abax parallelepipedus") 
    
    
) %>%
    addProviderTiles('CartoDB.Voyager') %>%
    addCircles(
        color = "black", 
        radius = ~ sqrt(individualCount),
        stroke = TRUE,
        fillOpacity = 0.7
        
        
    )

###########################################
leaflet(
    final_data %>% 
        rename(longitude = longitudeDecimal, 
               latitude = latitudeDecimal) %>% 
        filter(individualCount > 0) %>% 
        filter(scientificName == input$scientificname) 
) %>% 
    addTiles() %>% 
    addCircles(color = "black", 
               radius = ~ sqrt(individualCount),
               stroke = TRUE) %>% 
    addCircles()

####################################################
final_data$vernacularName[final_data %>% 
    pull(vernacularName) %>% 
    str_detect("^[Nn]orw.*")] %>% unique()
