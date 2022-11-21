# read data in
olympics <- read_csv("Shiny_Data/athlete_events.csv")
server <- function(input, output) { 
  
  output$olympics_plot <- renderPlot ({
    ggplot(aggregate(Medal ~ Age + Sport, olympics[(!is.na(olympics$Medal) & (olympics$Sport %in% input$Sport_choice)),], length)) + geom_point(aes(x = Age, y = Medal, col = Sport))
  })
  
  brks <- seq(-200, 200, 50)
  lbls = paste0(as.character(c(seq(200, 0, -50), seq(50, 200, 50))))
  
  output$Gender_olympics_plot <- renderPlot ({
    ggplot(aggregate(Medal ~ Age + Sport + Sex, olympics[(!is.na(olympics$Medal) & (olympics$Sport %in% input$Gender_Sport_choice)),], length),
           aes(x = Age, y = ifelse(Sex=="M",Medal*-1,Medal), fill = Sex)) + 
      geom_bar(stat = "identity", width = .6) +   # draw the bars
      scale_y_continuous(breaks = brks,   # Breaks
                         labels = lbls) + # Labels
      coord_flip() +  # Flip axes
      labs(title="Comparing Gender Data") +
      theme_tufte() +  # Tufte theme from ggfortify
      theme(plot.title = element_text(hjust = .5), 
            axis.ticks = element_blank()) +   # Centre plot title
      scale_fill_brewer(palette = "Dark2")  # Color palette
    
  })
  
  
}