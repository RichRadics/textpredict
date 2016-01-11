library(shiny)
# library(devtools)
# devtools::install_github('rstudio/rsconnect')
library(rsconnect)

setwd('~/R_code/Coursera_DS/DSCapstone')
runApp('shinyapp', display.mode = 'showcase')



# deploy
rsconnect::setAccountInfo(name='richradics', token='*********************', secret='****************************')
deployApp('shinyapp', appName='DSCapstone')