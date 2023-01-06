#################################################
## Load package manager ----

if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
}

## Load required packages ----

pacman::p_load(
    tidyverse, janitor, skimr,
    ggthemes, arrow, shiny, glue,
    dtplyr, sparklyr, leaflet
)

#################################################
## Create the application ----
## User interface

ui <- fluidPage(
    textInput(inputId = "name", label = "Enter Name:"),
    textOutput("z")
)

## Server

server <- function(input, output) {
    output$z <- renderText(
        paste("Hello ", input$name)
    )
}

#####################################################
## Run the application ----

shinyApp(ui, server)
