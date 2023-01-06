## Load the packages ----
if(!require(pacman)){
    install.packages("pacman")
}

pacman::p_load(tidyverse, shiny, shinythemes, gapminder)

## Load the data ----
data("gapminder")
head(gapminder)
## Create a user interface ----

ui <- fluidPage(
    
    titlePanel(title = HTML("<h1>GDP vs Life Expectancy</h1>")),
    
    theme = shinythemes::shinytheme("darkly"), 
    
    sidebarLayout(
        
        sidebarPanel(
            
            selectInput(inputId = "continent", 
                        label = "Select continent",
                        selected = "Africa", 
                        choices = gapminder %>% 
                            select(continent) %>% 
                            unique() %>% 
                            pull(continent)),
            
            sliderInput(
                
                inputId = "year",
                label = "Select year",
                min = min(gapminder$year),
                max = max(gapminder$year),
                step = 5,
                value = max(gapminder$year)
            ),
            
            actionButton(inputId = "submit", 
                         label = "Submit",
                         class = "btn btn-primary")
            
            
        ),
        
        mainPanel(
            
            tabsetPanel(
                
                tabPanel("My Plot", plotOutput(outputId = "plot")),
                
                tabPanel("My Table", DT::DTOutput(outputId = "table"))
            )
            
            
        )
    )
    
)



server <- function(input, output){
    
    output$plot <- renderPlot({
        
        gapminder %>% 
            filter(continent == input$continent,
                   year == input$year) %>% 
            ggplot(mapping = aes(x = gdpPercap, 
                                 y = lifeExp)) + 
            geom_point()
    })
    
    
    output$table <- DT::renderDT(
        
        gapminder %>% 
            filter(continent == input$continent,
                   year == input$year)
    )
    
    
}


shinyApp(ui = ui, server = server)