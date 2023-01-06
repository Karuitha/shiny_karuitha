################################################################################
## Download and load packages manager pacman ----
if(!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

################################################################################
# Download and load required packages ----
pacman::p_load(
    shiny, glue, plotly, leaflet, 
    shinythemes, tidyverse
)

###############################################################################
if(!require(shiny.react)){
remotes::install_github("Appsilon/shiny.react")}

if(!require(shiny.fluent)){
remotes::install_github("Appsilon/shiny.fluent")}

################################################################################
## Load the pre-processed data ----
final_data <- read_csv("final_data.csv",
                       
                       col_types = 'ccddccdd')

################################################################################
## Create the UI ----
ui <- fluidPage(
    
    ## Header panel
    headerPanel(HTML("<h1 style='color: grey'>Prevalence of Selected Species in Poland and Germany</h1>")),
    
    ## Add a themes selector for the app
    shinythemes::themeSelector(),
    
    ## Side bar layout
    sidebarLayout(
       
       sidebarPanel(
           
           HTML("<h3>User Input</h3>"),
           
           ## User enters vernacular name 
           HTML("<h4>Enter Vernacular Name</h4>"),
           ## Create a drop down inputs selection
           textInput(inputId = "vernacularname", 
                       label = "Choose a Vernacular Name",
                       value = "Box bug",
                       #placeholder = "Norway Maple",
                       width = "100%"
           ),
           
           ## User has the choice to enter scientific name
           HTML("<h4>Enter Scientific Name</h4>"),
           ## Create a drop down inputs selection
           textInput(inputId = "scientificname", 
                       label = "Choose a Scientific Name",
                       value = "Acer platanoides",
                       #placeholder = "Norway Maple",
                       width = "100%"
                     
                       ),
           
           ## User has the choice to enter scientific name
           HTML("<h4>Enter Year </h4>"),
           
           ## Create a slider input for the years
           selectInput(inputId = "year", 
                       label = "Choose year",
                       choices = sort(unique(final_data$year)),
                       selected = 2020,
                       multiple = FALSE)
           
       ),
       
       ## Main panel will contain the leaflet output
       mainPanel(
           
           
           leafletOutput("mymap"), width = "100%", height = "100%"
       )
       
   )
    
)

################################################################################
## Create the server with leaflet output ----
server <- function(input, output, session){
    
    
    ## Create a reactive for the current data ----
    this_data <- reactive({
        
        final_data %>% 
            
            filter(vernacularName == input$vernacularname,
                   
                   year == input$year)
    })
    
    
    ## Render an leaflet map
    output$mymap <- renderLeaflet(
        
        leaflet(
            
            this_data()
            
            
        ) %>%
            addProviderTiles('OpenStreetMap.HOT') %>%
            ## 
            ## Stamen.Toner
            addCircleMarkers(
                color = "red", 
                radius = ~ individualCount^0.3,
                stroke = TRUE,
                fillOpacity = 0.8,
                popup = ~paste(
                    
                    "<strong> Country: </strong>", country, "<br>",
                    "<strong> Locality: </strong>", locality, "<br>",
                    "<strong> Count: </strong>", individualCount, "<br>"
                )
                
                
            )
        
    )

    
    
}

################################################################################
## Run the application ----
shinyApp(ui, server)
################################################################################