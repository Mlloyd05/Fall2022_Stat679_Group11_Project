bpl <- read.csv('Shiny_Data/BPL_Dataset.csv')
col <- colnames(bpl)
pot <- col[7:50]

server <- function(input, output,session){
  bpl_subset <- reactive({
    bpl %>%
      mutate(selected = 1 * (Club %in% input$Club_choice) * (Position %in% input$Position_choice)) %>%
      filter(selected == 1)
  })
  xVarName <- reactive({
    input$Metric_choice
  })
  yVarName <- reactive({
    input$Metric_choice2
  })
  
  output$Effectiveness <- renderPlot({
    ggplot(bpl_subset()) +
      geom_point(aes_string(input$Metric_choice,input$Metric_choice2))
  })
  output$Table <- renderTable(bpl_subset())
}