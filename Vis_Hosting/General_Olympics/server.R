library(shiny)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(ggplot2)
library(ggthemes)
theme_set(theme_gray())

olympics <- read_csv("Shiny_Data/athlete_events.csv")

### functions used in app
line_plot <- function(df) {
  ggplot(df, aes(Age, color=Sex)) +
    geom_line(aes(fill=..count..), stat="bin", binwidth=1) +
    ylab("Number of Athletes")
}

agged_sport_data <- cbind(aggregate(Age ~ Sport, olympics, mean), aggregate(ID ~ Sport, olympics, length)$ID, aggregate(Event ~ Sport, olympics, function(Event) length(unique(Event)))$Event)
colnames(agged_sport_data) = c("Sport", "Age", "Count", "Unique_Events")
agged_sport_data$Athletes_Per_Event <- agged_sport_data$Count / agged_sport_data$Unique_Events
agged_sport_data <- agged_sport_data[order(agged_sport_data$Age), ]  # sort
agged_sport_data$Sport <- factor(agged_sport_data$Sport, levels = agged_sport_data$Sport)
col = colnames(olympics)
pot = c(col[4:6],col[10])

server <- function(input, output) {
  #The below code renders the plot and connects with the ui object, based on the sports selected it produces various color coded dot graphs, colored by sport.
  output$olympics_plot <- renderPlot ({
    ggplot(aggregate(Medal ~ Age + Sport, olympics[(!is.na(olympics$Medal) &
                                                      (olympics$Sport %in% input$Sport_choice)), ], length)) + geom_point(aes(x = Age, y = Medal, col = Sport))
  })
  #The below code adds labels to the graph.
  brks <- seq(-200, 200, 50)
  lbls = paste0(as.character(c(seq(200, 0,-50), seq(50, 200, 50))))
  
  #This is a gender based plot which plots bars in either direction based on gender and fills color based on gender based on the sport selected.
  output$Gender_olympics_plot <- renderPlot ({
    ggplot(
      aggregate(Medal ~ Age + Sport + Sex, olympics[(!is.na(olympics$Medal) &
                                                       (olympics$Sport %in% input$Gender_Sport_choice)), ], length),
      aes(
        x = Age,
        y = ifelse(Sex == "M", Medal * -1, Medal),
        fill = Sex
      )
    ) +
      geom_bar(stat = "identity", width = .6) +   # draw the bars
      scale_y_continuous(breaks = brks,   # Breaks
                         labels = lbls) + # Labels
      coord_flip() +  # Flip axes
      labs(title = "Comparing Gender Data", x = "Age", y = "Medals" ) +
      theme(plot.title = element_text(hjust = .5),
            axis.ticks = element_blank()) +   # Centre plot title
      scale_fill_brewer(palette = "Dark2")  # Color palette
    
  })
  oly_subset <- reactive({
    olympics %>%
      mutate(selected = 1 * (Team %in% input$team_choice) * (Sport %in% input$sport_choice)) %>%
      filter(selected == 1)
  })
  
  #Plotting based on the aes_string function that allows the selection of x and y axes by the user for more customizability.
  output$Effectiveness <- renderPlot({
    ggplot(oly_subset()) +
      geom_jitter(
        aes_string(
          input$Metric_choice,
          input$Metric_choice2,
          color = "Medal",
          shape = "Sex"
        ),
        width = .1,
        height = .1
      )
  })
  #Renders a table of the data points that are a part of the subset.
  output$Table <- renderTable(oly_subset())
  
  #Age distribution plots
  olympics_subset <- reactive({
    olympics %>%
      mutate(selected = (
        (Sport %in% input$Sport) &
          (Year >= input$Year[1]) &
          (Year <= input$Year[2])
      ))
  })
  output$olympics_age_dist_plot <- renderPlot({
    line_plot(olympics[olympics$Sport %in% input$Sport & olympics$Year >= input$Year[1] & olympics$Year <= input$Year[2],])
  })
  
  output$athlete_distribution <- renderPlot({ggplot(agged_sport_data, aes(x=Sport, y=Athletes_Per_Event, fill = Age)) + 
      geom_bar(stat="identity", width=.5) + 
      labs(title="Ordered Bar Chart", 
           subtitle="Avg Age Vs Athlete Per Event Count", 
           caption="source: Olympics Dataset") + 
      theme(axis.text.x = element_text(angle=90, vjust=0.6)) + scale_fill_gradient2(low = "red", mid = "orange", high = "blue", midpoint = 12) + labs(y = "Athletes per Event")})
  
}