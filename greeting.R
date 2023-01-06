ui <- fluidPage(
    selectInput("greeting", label = "Choose Greeting", 
                choices = c("Hello", "Bonjour"), 
                selected = "Hello"),
    textInput("name", label = "Enter your name", value = "Kamau"),
    
    textOutput("final")
)

server <- function(input, output, session) {
    
    output$final <- renderText(print(paste(input$greeting, ", " , input$name)))
    
}

shinyApp(ui = ui, server = server)