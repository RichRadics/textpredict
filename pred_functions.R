
library(dplyr)
library(RSQLite)

dumbPred <- function(instr, codex) {
  inwords<-strsplit(instr, ' ')[[1]]
  if (length(inwords)==4) {
    print('Matching 4...')
    res = codex %>% filter(w1==inwords[1], w2==inwords[2], w3==inwords[3], w4==inwords[4])
  }
  if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
  if (length(inwords)==3) {
    print('Matching 3...')
    res = codex %>% filter(w2==inwords[1], w3==inwords[2], w4==inwords[3])
  }
  if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
  if (length(inwords)==2) {
    print('Matching 2...')
    res = codex %>% filter(w3==inwords[1], w4==inwords[2])
  }
  if (nrow(res)==0) {inwords = inwords[2:length(inwords)]}
  if (length(inwords)==1) {
    print('Matching 1...')
    res = codex %>% filter(w4==inwords[1])
  }
  return (head(res %>% group_by(w5) %>% summarise(cnt=n()) %>% ungroup() %>% arrange(desc(cnt))))
}


dumbPred2 <- function(instr, codex) {
  inwords<-strsplit(tolower(instr), ' ')[[1]]
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

predWrap <- function(x) {
  instr <- strsplit(gsub("[^[:alnum:] ]", "", x), " +")[[1]]
  instr <- paste(tail(instr, n=4), collapse=' ')
  res1 <- dumbPred2(instr, con)
  if (is.null(res1)) {
    searchlist <<- rbind(searchlist, cbind(instr, 'NONE'))
    return (c('the', 'on', 'a'))
  }else{
    res1 <- res1 %>% filter(w5!='<SEN>', w5!='<sen>')
    res2 <- as.vector(unlist(res1[1:3,1]))
    searchlist <<- rbind(searchlist, cbind(instr, paste(res2, collapse=', ')))
    return (res2)
  }
}