library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)
age <-    c( 25, 28, 31, 23, 25, 26, 35, 24, 37, 21, 20, 22)
height <- c( 65, 63, 61, 67, 69, 72, 75, 73, 72, 68, 71, 63)
weight <- c(165,166,190,185,188,171,205,177,179,199,185,192)
sport <-  c("basketball","basketball","basketball","basketball","basketball","basketball","baseball","baseball","baseball","baseball","baseball","baseball")
performance <- c(1,3,6,7,2,10,9,3,5,8,4,9)

athletes <- data.frame(age,height,weight,sport,performance)

sports <- pull(athletes, sport) %>%
  unique() %>%
  na.omit()


### functions used in app
scatterplot <- function(df) {
  p <- ggplot(mapping = aes(age, performance)) +
    geom_point(data = df %>% filter(selected),  aes(text = "Performance by Age"), size = 2, alpha = 1) +
    geom_point(data = df %>% filter(!selected),  size = .5, alpha = .1)
  ggplotly(p, tooltip = "Title") %>%
    style(hoveron = "fill")
}

### definition of app
ui <- fluidPage(
  titlePanel("Sport Age Analysis"),
  selectInput("sports", "Sport", sports),
  sliderInput("height", "Height", min = min(athletes$height), max = max(athletes$height),c(20,100), sep = ""),
  sliderInput("weight", "Weight", min = min(athletes$weight), max = max(athletes$weight),c(100,225), sep = ""),
  sliderInput("age", "Age", min = min(athletes$age), max = max(athletes$age),c(18,40), sep = ""),
  plotlyOutput("sports_scatter"),
  dataTableOutput("dt")
)

server <- function(input, output) {
  sports_subset <- reactive({
    athletes %>%
      mutate(selected = (
        (sport %in% input$sports) &
          (height >= input$height[1]) &
          (height <= input$height[2]) &
        (weight >= input$weight[1]) &
          (weight <= input$weight[2]) &
        (age >= input$age[1]) &
          (age <= input$age[2])
      ))
  })
  output$dt <- renderDataTable(sports_subset())
  output$sports_scatter <- renderPlotly({
    scatterplot(sports_subset())
  })
}

app <- shinyApp(ui, server)