library(shiny)
library(arrow)


## Load the data
final_data <- read_csv("final_data.csv",
                       
                       col_types = 'cddccd')

## Load the maps data 
maps_data <- map_data("world") %>%
    filter(region %in% c("Poland", "Germany")) %>% 
    as_tibble()

## Create the UI
ui <- fluidPage(
    
    headerPanel(h1("Prevalence of Selected Species in Europe")),
    
   sidebarLayout(
       
       sidebarPanel(
           
           ## Create a drop down inputs selection
           selectInput(inputId = "scienfificname", 
                       label = "Choose a Scientific Name",
                       selected = "Abax parallelepipedus",
                       choices = final_data %>% 
                           select(scientificName) %>% 
                           arrange(scientificName) %>% 
                           distinct(scientificName) %>% 
                           pull(scientificName)
                       ),
           
           
           
       ),
       
       mainPanel(
           
           plotOutput("mymap"), width = 15
       )
       
   )
   
   
    
)


server <- function(input, output){
    
    output$mymap <- renderPlot(
        
        maps_data %>% 
            ggplot() +
            geom_map(mapping = aes(x = long, y = lat, map_id = region), 
                     map = maps_data,
                     color = 'gray30', fill = 'gray90', size = 0.2) + 
            geom_point(data = final_data %>% filter(scientificName == 
                                                     
                                                     final_data %>% 
                                                     filter(individualCount > 0) %>% 
                                                     filter(scientificName == input$scienfificname) %>% 
                                                     distinct(scientificName) %>% 
                                                     pull(scientificName)
                                                     
                                                     
                                                     ), 
                       mapping = aes(x = longitudeDecimal, 
                                     y = latitudeDecimal, 
                                     size = individualCount),
                       show.legend = FALSE, shape = 1) + 
            labs(x = "", y = "", 
                 
                 title = glue::glue("Prevalence of {final_data %>% select(input$scientificname) %>% distinct()} in Germany and Poland")) + 
            
            theme_minimal() + 
            
            coord_map('ortho', orientation = c(51, 19, 0))
        
        
        
        
        
        
    )
    
    
}


shinyApp(ui, server)