
library(shiny)

shinyUI(fluidPage(

  titlePanel("Diffusion Model"),

  sidebarLayout(
    sidebarPanel(
      sliderInput('n','n', min = 1,max = 10000, value = 100),
      numericInput('alpha','alpha', min = 0,max = 10, value =2),
      numericInput('tau','tau', min = 0,max = 4, value = 0.3),
      sliderInput('beta','beta', min = 0,max = 1, value = 0.5),
      numericInput('delta','delta', min = -1 ,max = 1, value = 0.5)
      
    ),

    mainPanel(
      plotOutput("Plot"),
      plotOutput("Plot2"),
      plotOutput("Plot3"),
      tableOutput("data_w")
    )
  )
))
