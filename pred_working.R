library(dplyr)
library(RSQLite)
library(ggplot2)
library(tidyr)
library(gridExtra)

setwd('~/R_code/Coursera_DS/DSCapstone')
con <- dbConnect(SQLite(), dbname='fullcorpus.sqlite')
searchlist <- data.frame(searchterm=c(), results=c())


res1=dumbPred2('cup of',con)
dumbPred2('cup of',full.df)
predWrap('would live')

dbGetQuery(con, 'SELECT * from fullcorpus WHERE w4="were" and w3="that" limit 10')
searchlist <- append(searchlist,'hello')
searchlist <- rbind(searchlist, cbind('query','results'))


