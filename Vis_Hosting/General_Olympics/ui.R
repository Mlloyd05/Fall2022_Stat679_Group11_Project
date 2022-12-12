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


### definition of app
ui <-
  navbarPage(
    "Group 11 Shiny Prototype",
    collapsible = TRUE,
    inverse = TRUE,
    theme = shinytheme("spacelab"),
    tabPanel(
      "Olympic Sports - Age vs. Medal",
      sidebarLayout(sidebarPanel(
        selectInput("Sport_choice", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE, selected = c('Basketball', 'Football') ) ),
        mainPanel(plotOutput("olympics_plot")),)
    ),
    tabPanel(
      "Sport-Gender Breakdown by Age",
      sidebarLayout(sidebarPanel(
        selectInput("Gender_Sport_choice", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE, selected = 'Basketball')
      ),
      mainPanel(plotOutput("Gender_olympics_plot")),)
    ),
    tabPanel(
      "Olympics Athelete Age Distribution",
      sidebarLayout(
        sidebarPanel(
          style = paste0("height: 27vh; overflow-y: auto;"),
          selectInput("Sport", label = "Sport", choices = unique(olympics$Sport), 
                      multiple = TRUE, selected = c('Basketball', 'Football') ),
          sliderInput("Year", "Year", min = min(olympics$Year), max = max(olympics$Year), c(1980, 2010), sep = "" ),
          plotOutput("line")
        ),
        mainPanel(
          plotOutput("olympics_age_dist_plot")
        ),
      )
      
    ),
    tabPanel(
      "Athlete Analysis",
      fluidRow(column(
        4,
        selectInput("sport_choice", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE , selected = 'Basketball') ),
        column(
          4,
          selectInput("team_choice", label = "Team", choices = unique(olympics$Team), multiple = TRUE, selected = 'United States')
        )),
      selectInput("Metric_choice", label = "PlayerMetricX", choices = pot, selected = 'Age'),
      selectInput("Metric_choice2", label = "PlayerMetricY", choices = pot, selected = 'Height'),
      plotOutput("Effectiveness"),
      tableOutput("Table")
    ),
    tabPanel(
      "Age vs. Athlete Count/Event",
      plotOutput("athlete_distribution")
    )
    
    
  )