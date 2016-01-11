# Initial capstone playground

# first, use the awk-based unicode converter
# then the opennlp sentence splitter
# ~/nltk_data/apache-opennlp-1.6.0/bin/opennlp SentenceDetector \
#   ~/nltk_data/apache-opennlp-1.6.0/models/en-sent.bin  < newblog > sentblog

# next the text filterer and ngrammer in python

# phone philter 
# url filtering regex by me!

library(dplyr)
library(RSQLite)



setwd('~/R_code/Coursera_DS/DSCapstone')
raw_blog <- read.csv2('~/datasets/capstone/en_US/en_US.blogs.rtl', sep=' ', col.names=c('w1','w2','w3','w4', 'w5'))
raw_blog <- 
  rbind( cbind(raw_blog, src='blog')) %>% 
  group_by(w1, w2, w3, w4, w5, src) %>% summarise(C5Gram = n()) %>%
  ungroup() 

raw_news <- read.csv2('~/datasets/capstone/en_US/en_US.news.rtl', sep=' ', col.names=c('w1','w2','w3','w4', 'w5'))
raw_news <- 
  rbind( cbind(raw_news, src='news')) %>% 
  group_by(w1, w2, w3, w4, w5, src) %>% summarise(C5Gram = n()) %>%
  ungroup() 

raw_twitter <- read.csv2('~/datasets/capstone/en_US/en_US.twitter.rtl', sep=' ', col.names=c('w1','w2','w3','w4', 'w5'))
raw_twitter <- 
  rbind( cbind(raw_twitter, src='twit')) %>% 
  group_by(w1, w2, w3, w4, w5, src) %>% summarise(C5Gram = n()) %>%
  ungroup() 


con <- dbConnect(SQLite(), dbname='fullcorpus.sqlite')
dbSendQuery(con, "DROP TABLE IF EXISTS fullcorpus")
setOldClass(c('tbl_df','data.frame'))
dbWriteTable(con, 'fullcorpus', rbind(raw_news, raw_blog, raw_twitter))
dbGetQuery(con,"CREATE INDEX index_w4 ON fullcorpus (w4)")
dbGetQuery(con,"delete from fullcorpus where w5 in (select w5 from fullcorpus group by w5 having count(*)=1);")
rm(list=c('raw_blog','raw_news','raw_twitter'))
gc()

