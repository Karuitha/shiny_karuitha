## Load packages manager ----
if(!require(pacman)){
    install.packages("pacman")
}

pacman::p_load(tidyverse, janitor,
               shiny, shinythemes, 
               data.table, randomForest)

## Harvest the data ----
golf_data <- read_csv("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv") %>% 
    clean_names() %>% 
    mutate(play = factor(play),
           outlook = factor(outlook))

glimpse(golf_data)
## Build the model ----
myrf_model <- randomForest(play ~ ., data = golf_data, 
                           ntree = 500, mtry = 4,
                           importance =  TRUE)

## Create the user interface ----

ui <- fluidPage(
    
    theme = shinythemes::shinytheme(theme = "darkly"), 
    
    titlePanel(title = "Play Golf?"), 
    
    sidebarLayout(
        
        sidebarPanel(
            
            HTML("<h3>User Input</h3>"),
            
            selectInput(inputId = "outlook", label = "Select Outlook", 
                        choices = list("Sunny" = "sunny", 
                                       "Rainy" = "rainy",
                                       "Overcast" = "overcast"),
                        selected = "Rainy"
                        ),
            
            sliderInput(inputId = "temp", label = "Temperature",
                        min = min(golf_data$temperature),
                        max = max(golf_data$temperature),
                        value = median(golf_data$temperature)), 
            
            
            sliderInput(inputId = "hum", label = "Humidity",
                        min = min(golf_data$humidity),
                        max = max(golf_data$humidity),
                        value = median(golf_data$humidity)),
            
            
            selectInput(inputId = "windy", label = "Windy", 
                        choices = list("Yes" = "TRUE",
                                       "No" = "FALSE"),
                        selected = "Yes"
            ), 
            
            actionButton(inputId = "submit", label = "Submit",
                         class = "btn btn-primary")
            
            
            
        ), 
        
        
        mainPanel(
            
            tags$label(h3("Status/Output")),
            
            verbatimTextOutput("contents"),
            
            tableOutput("tabledata")
        )
        
    )
    
    
    
    
    
    
)




server <- function(input, output){
    
    ## Create a test data frame object 
    datasetInput <- reactive({
        
        df <- data.frame(
            
            name = c("outlook", "temperature", "humidity", "windy"),
            
            #values = c("sunny", 10, 15, TRUE)
            
            values = c(input$outlook, input$temp, input$hum, input$windy)
        )
        
        play <- "play"
        
        df <- rbind(df, play)
        
        input <- transpose(df)
        
        write_csv(input, "input.csv")
        
        test <- read_csv("input.csv") %>% 
            janitor::row_to_names(row_number = 1)
        
        
        test <- test %>% 
            mutate(outlook = factor(outlook, levels = levels(golf_data$outlook)),
                   
                   temperature = as.numeric(temperature),
                   
                   humidity = as.numeric(humidity),
                   
                   windy = as.logical(windy))
        
        final <- data.frame(Should_I_Play = predict(myrf_model, test), 
                            
                            predict(myrf_model, test, type = "prob"))
        
        print(final)
        
        
        
    }
        
    )
    
    
    ## Status of the submit button
    output$contents <- renderPrint(
        
        if(input$submit > 0){
            isolate("Calculation complete")
        } else{
            return("Server is ready for calculation")
        }
    )
    
    
    ## Prediction results table 
    output$tabledata <- renderTable({
        
        if(input$submit > 0){
            isolate(datasetInput())
        }
    }
        
        
    )
    
}


shinyApp(ui = ui, server = server)
##########################################

