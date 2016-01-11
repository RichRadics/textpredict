library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediction App"),
  
  br(),
  fluidRow(
    column(4,
           h4('Enter n-gram'),
           p('Please enter at least 3 words')),
    column(4,
           h4('Predicted next word')),
    column(4,
           h4('Details'))
  ),
  fluidRow(
    column(4,
           hr(),
           textInput('in1', label='NGram')),
    column(4,
           hr(),
           verbatimTextOutput('out1')),
    column(4,
           hr(),
           verbatimTextOutput('out2'))
    
  ),
  fluidRow(
    column(4,
           h4('Advanced options'))
  )
))
