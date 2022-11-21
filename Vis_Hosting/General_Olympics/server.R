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

server <- function(input, output) {
  olympics_subset <- reactive({
    olympics %>%
      mutate(selected = (
        #(Pos %in% input$pos) &
        (Sport %in% input$Sport) &
          (Year >= input$Year[1]) &
          (Year <= input$Year[2])
      ))
  })
  
  output$line <- renderPlot({
    line_plot(olympics[olympics$Sport %in% input$Sport & olympics$Year >= input$Year[1] & olympics$Year <= input$Year[2],])
  })
}