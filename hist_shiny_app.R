################################################################################
library(tidyverse)
library(shiny)
library(shinythemes)
library(ggthemes)

################################################################################
data("mpg")
head(mpg)
################################################################################
ui <- fluidPage(
    
    titlePanel(h1("Visualizing Fuel Consumption")),
    
    sidebarLayout(
        
        sidebarPanel(
            
            selectInput(inputId = "vars", 
                        label = "Select variable",
                        selected = "displ",
                        choices = c("displ", "cty", "hwy")
                        
                        )
            
            
        ),
        
        
        mainPanel(
            
            plotOutput("box")
        )
        
    )
    
    
)



server <- function(input, output){
    
    output$box <- renderPlot(
        
        
        mpg %>% 
            ggplot(mapping = aes(x = manufacturer, y = {input$vars})) + 
            geom_boxplot() + theme_fivethirtyeight()
    )
}


shinyApp(ui = ui, server = server)




