library(shiny)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(ggplot2)

bpl <- read.csv('Shiny_Data/BPL_Dataset.csv')
col <- colnames(bpl)
pot <- col[7:50]

ui <- fluidPage(
  selectInput("Club_choice", label = "Club", choices = unique(bpl$Club), multiple = TRUE),
  selectInput("Position_choice", label = "Position", choices = unique(bpl$Position), multiple = TRUE),
  selectInput("Metric_choice", label = "PlayerMetric1", choices = pot),
  selectInput("Metric_choice2", label = "PlayerMetric2", choices = pot),
  plotOutput("Effectiveness"),
  tableOutput("Table")
  
)