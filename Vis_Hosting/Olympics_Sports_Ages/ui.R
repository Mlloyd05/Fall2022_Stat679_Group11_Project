library(rsconnect)
library(shiny)
library(shinythemes)
library(tidyverse)
library(readr)
library(ggthemes)
library(ggplot2)

olympics <- read_csv("Shiny_Data/athlete_events.csv")

ui <- 
  navbarPage("Group 11 Olympics Shiny Prototype", collapsible = TRUE, inverse = TRUE, theme = shinytheme("spacelab"),
             tabPanel("General Olympics",
                      sidebarLayout(sidebarPanel(selectInput("Sport_choice", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE)),
                                    mainPanel(plotOutput("olympics_plot")),
                      )
             ),
             tabPanel("Gender Breakdown",
                      sidebarLayout(sidebarPanel(selectInput("Gender_Sport_choice", label = "Sport", choices = unique(olympics$Sport), multiple = TRUE)),
                                    mainPanel(plotOutput("Gender_olympics_plot")),
                      )
             )
  )