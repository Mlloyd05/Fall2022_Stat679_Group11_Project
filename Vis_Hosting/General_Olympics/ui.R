library(shiny)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(ggplot2)

olympics <- read_csv("Shiny_Data/athlete_events.csv", col_types = cols(
  ID = col_character(),
  Name = col_character(),
  Sex = col_factor(levels = c("M","F")),
  Age =  col_integer(),
  Height = col_double(),
  Weight = col_double(),
  Team = col_character(),
  NOC = col_character(),
  Games = col_character(),
  Year = col_integer(),
  Season = col_factor(levels = c("Summer","Winter")),
  City = col_character(),
  Sport = col_character(),
  Event = col_character(),
  Medal = col_factor(levels = c("Gold","Silver","Bronze"))
)
)

olympics <- olympics[!is.na(olympics$Age),]
olympics <- olympics[!is.na(olympics$Sex),]
olympics <- olympics[!is.na(olympics$Year),]
glimpse(olympics)

### functions used in app
line_plot <- function(df) {
  ggplot(df, aes(Age, color=Sex)) +
    geom_line(aes(fill=..count..), stat="bin", binwidth=1) +
    ylab("Number of Athletes")
}


### definition of app
ui <- fluidPage(
  titlePanel("Olympic Athletes Age Visualization"),
  selectInput("Sport", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE),
  #pickerInput("Sport", "Sport", Sport, options = list(`actions-box` = TRUE),multiple = T),
  #pickerInput("pos", "Position", pos, options = list(`actions-box` = TRUE),multiple = T),
  sliderInput("Year", "Year", min = min(olympics$Year), max = max(olympics$Year), c(2000, 2005), sep = ""),
  plotOutput("line")
)