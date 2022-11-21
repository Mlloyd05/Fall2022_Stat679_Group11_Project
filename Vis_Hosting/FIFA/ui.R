library(shiny)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(ggplot2)
library(ggthemes)

#player15 <- read_csv("Shiny_Data/players_15.csv")
#player16 <- read_csv("Shiny_Data/players_16.csv")
#player17 <- read_csv("Shiny_Data/players_17.csv")
#player18 <- read_csv("Shiny_Data/players_18.csv")
player19 <- read_csv("Shiny_Data/players_19.csv")
player20 <- read_csv("Shiny_Data/players_20.csv")
player21 <- read_csv("Shiny_Data/players_21.csv")
player22 <- read_csv("Shiny_Data/players_22.csv")
#player15$game <- "FIFA 15"
#player16$game <- "FIFA 16"
#player17$game <- "FIFA 17"
#player18$game <- "FIFA 18"
player19$game <- "FIFA 19"
player20$game <- "FIFA 20"
player21$game <- "FIFA 21"
player22$game <- "FIFA 22"
#player <- rbind(player15, player16, player17, player18, player19, player20, player21, player22)
player <- rbind(player19, player20, player21, player22)

ui <- fluidPage(
  fluidRow(
    column(4, selectInput("League_choice", label = "League", choices = unique(player$league_name), multiple = TRUE)),
    column(4, selectInput("Position_choice", label = "Position", choices = unique(player$club_position), multiple = TRUE)),
    column(4, selectInput("Game_choice", label = "Game", choices = unique(player$game), multiple = TRUE))
  ),
  plotOutput("score"),
  plotOutput("age")
)