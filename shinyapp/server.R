library(shiny)
library(dplyr)
full.df <- readRDS('data/ngrams.rds')

dumbPred2 <- function(instr, dbcon) {
  inwords<-strsplit(tolower(instr), ' ')[[1]]
  # grab the full set of items based on final word
  codex <- full.df#data.frame(dbGetQuery(con, paste0('SELECT * from fullcorpus WHERE w4="',tail(inwords,n=1),'"')))
  res=head(codex,1)
  if (nrow(codex)>0) {
    if (length(inwords)==4) {
      res <- codex %>% filter(w1==inwords[1], w2==inwords[2], w3==inwords[3], w4==inwords[4])
    }
    if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
    if (length(inwords)==3) {
      res <- codex %>% filter(w2==inwords[1], w3==inwords[2], w4==inwords[3])
    }
    if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
    if (length(inwords)==2) {
      res <- codex %>% filter(w3==inwords[1], w4==inwords[2])
    }
    if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
    if (length(inwords)==1) {
      res <- codex %>% filter(w4==inwords[1])
    }
    return (res %>% group_by(w5) %>% summarise(cnt=sum(C5Gram)) %>% ungroup() %>% arrange(desc(cnt))) %>% head(3) %>% as.matrix()
  } 
}


shinyServer(function(input, output, session) {
  
  output$out1 <- renderPrint(input$in1)
  output$out2 <- renderPrint({
    res=dumbPred2(input$in1)
    res
    })
})
