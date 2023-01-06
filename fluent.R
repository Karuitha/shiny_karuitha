remotes::install_github("Appsilon/shiny.react") 
remotes::install_github("Appsilon/shiny.fluent") 
devtools::install_github("tidyverse/tidyverse") 
remotes::install_github("plotly/plotly") 
remotes::install_github("allisonhorst/palmerpenguins")


library(shiny)
library(shiny.fluent)
library(tidyverse)
library(palmerpenguins)
library(plotly)

penguins_options <- list(
    list(key = "Adelie", text = "Adelie"),
    list(key = "Chinstrap", text = "Chinstrap"),
    list(key = "Gentoo", text = "Gentoo")
)

shinyApp(
    ui = fluentPage(
        tags$style('
      body {
          background-color: #379be6;
        }
       div{
       background-color: white;
          color: #f8f8f8;
          border-radius: 5px;
          margin: 0px;
          padding: 5px;
       }'
        ),
      div(
          Text(
              variant = "xLarge",
              "Examples Using shiny.fluent ComboBox input",
              block = TRUE
          ),
          Separator(),
          Text(
              variant = "large",
              "Select your favorite penguin",
              block = TRUE
          ),
          tags$br(),
          ComboBox.shinyInput(
              "combo",
              value = list(text = "add some text or select"),
              options = penguins_options,
              allowFreeform = TRUE
          ),
          textOutput("comboValue")
      )
    ),
    
server = function(input, output) {
        output$comboValue <- renderText({
            sprintf("Value: %s", input$combo$text)
        })
    }
)

