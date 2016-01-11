full.df<-data.frame(dbGetQuery(con,'select * from fullcorpus where w5<>"<>" order by random() limit 5000000'))
full.df$w1<-factor(full.df$w1)
full.df$w2<-factor(full.df$w2)
full.df$w3<-factor(full.df$w3)
full.df$w4<-factor(full.df$w4)
full.df$w5<-factor(full.df$w5)
full.df$src<-factor(full.df$src)

saveRDS(full.df, file='shinyapp/data/ngrams.rds')
full.df<-readRDS(file='shinyapp/data/ngrams.rds')

# create probabilities for 1grams
full.df <- full.df %>% 
  mutate(tgrams=sum(C5Gram)) %>%
  group_by(w5) %>% 
  mutate(p1gram=log(sum(C5Gram)/tgrams), p1obs=n()) %>% 
  ungroup() %>%
  select(-tgrams)

# the harder part - bigrams. once this works, the rest is simple
full.df <- 
  full.df %>% 
  group_by(w4) %>% 
  mutate(tgrams=sum(C5Gram)) %>%
  ungroup() %>%
  group_by(w4,w5) %>%
  mutate(p2gram=log(sum(C5Gram)/tgrams), p2obs=n()) %>% 
  ungroup() %>%
  select(-tgrams)

# 3grams
full.df <- 
  full.df %>% 
  group_by(w3, w4) %>% 
  mutate(tgrams=sum(C5Gram)) %>%
  group_by(w3, w4, w5) %>%
  mutate(p3gram=log(sum(C5Gram)/tgrams), p3obs=n()) %>% 
  ungroup() %>%
  select(-tgrams)

# 4grams
full.df <- 
  full.df %>% 
  group_by(w2, w3, w4) %>% 
  mutate(tgrams=sum(C5Gram)) %>%
  group_by(w2, w3, w4, w5) %>%
  mutate(p4gram=log(sum(C5Gram)/tgrams), p4obs=n()) %>% 
  ungroup() %>%
  select(-tgrams)

# 5grams
full.df <- 
  full.df %>% 
  group_by(w1, w2, w3, w4) %>% 
  mutate(tgrams=sum(C5Gram)) %>%
  group_by(w1, w2, w3, w4, w5) %>%
  mutate(p5gram=log(sum(C5Gram)/tgrams), p5obs=n()) %>% 
  ungroup() %>%
  select(-tgrams)


full.df %>% filter( w3=='the' & w4=='sausage') %>% 
  mutate(newp2 = log(0.5*exp(p1gram) + 0.35*exp(p2gram) + 0.15*exp(p3gram))) %>% 
  arrange(desc(newp2))

