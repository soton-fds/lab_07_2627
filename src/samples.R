library(shiny)
library(tidyverse)

ui <- fluidPage(
  fluidRow(
    column(
      2,
      numericInput("mu1", label = withMathJax("$$\\mu_1$$"), value = -1, width = "80px")
    ),
    column(
      2,
      numericInput("mu2", label = withMathJax("$$\\mu_2$$"), value = 1, width = "80px")
    )
  ),
  plotOutput("plot"),
  textOutput("means"),
  tableOutput("table")
)

server <- function(input, output, session) {
  samples <- reactive(tibble(
    x1 = rnorm(10, input$mu1, 1),
    x2 = rnorm(10, input$mu2, 1)
  ))

  output$plot <- renderPlot(
    {
      ggplot(samples(), aes(x = x1, y = x2)) +
        geom_point() +
        coord_cartesian(xlim = c(-5, 5), ylim = c(-5, 5))
    },
    res = 96
  )

  output$means <- renderText({
    paste(
      "Sample means:",
      round(mean(samples()$x1), 2), "and",
      round(mean(samples()$x2), 2)
    )
  })

  output$table <- renderTable(samples())
}

shinyApp(ui, server)
