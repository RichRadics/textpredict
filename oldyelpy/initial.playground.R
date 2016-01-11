# Coursera Data Science Specialisation
# Capstone Project
# 
# Author    : Rich Dean
# Created   : 11/07/2015
#
# FILE :::::         Initial playground

# Optional : clear environment
# rm(list=ls())

# My standard library set for text analysis + modelling

library(tm)
library(stringi)
library(SnowballC)
library(RWeka)
library(rJava)
library(RWekajars)
library(RTextTools)
library(caret)
library(rpart)
library(rpart.plot)
library(ngram)
library(randomForest)


setwd('/Users/ratb3rt/Downloads/twitter_data/en_US/')
con <- file('en_US.twitter.txt', 'r') 
header_text <- readLines(con, n=1000, ok=TRUE) 
close(con)

# Need to build a sampling tool to create a %age based subsetter - given source/dest/%age, uses binomial to split
radicsCreateSample <- function  (file.in, file.out = '', sample.prob = 0.1, block.size = 10000)
{
    # Function to create sample files from input
    if (file.out == '') file.out=paste(file.in, 'sample', sep='.');
    con.in <- file(file.in, 'r');
    con.out <- file(file.out, 'w');
    repeat {
        cur.block<-readLines(con.in, n=block.size, ok=TRUE);
        line.map <- rbinom(n=block.size, size=1, prob=sample.prob);
        writeLines(cur.block[line.map==1], con.out);
        if (length(cur.block)<block.size) break;
    }
    close(con.in);
    close(con.out);
}

bigramTokenizer <- function(x) {
    x <- as.character(x)
    
    # Find words
    one.list <- c()
    tryCatch({
        one.gram <- ngram::ngram(x, n = 1)
        one.list <- ngram::get.ngrams(one.gram)
    }, 
    error = function(cond) { warning(cond) })
    
    # Find 2-grams
    two.list <- c()
    tryCatch({
        two.gram <- ngram::ngram(x, n = 2)
        two.list <- ngram::get.ngrams(two.gram)
    },
    error = function(cond) { warning(cond) })
    
    res <- unlist(c(one.list, two.list))
    res[res != '']
} 



setwd('/Users/ratb3rt/Downloads/twitter_data/en_US/')
con <- file('en_US.news.txt', 'r') 
all.max =0
iters = 0
repeat {
    iters = iters+1;
    block.size <- 10000;
    cur.block <- readLines(con, n=block.size, ok=TRUE);
    cur.max <- max(nchar(cur.block));
    if (cur.max>all.max) all.max <- cur.max;
    if (length(cur.block)<block.size) break;
}
close(con)
c(all.max, iters)


# try loading the entire twitter dataset
# **** after first try, this takes far too long, especially for building a test programme
# **** used 5% sample file instead, to develop exploration script. Will run complete file once that's done
radicsCreateSample('en_US.twitter.txt', block.size=1000, sample.prob=0.05)
radicsCreateSample('en_US.news.txt', block.size=1000, sample.prob=0.05)
radicsCreateSample('en_US.blogs.txt', block.size=1000, sample.prob=0.05)


con <- file('en_US.twitter.txt.sample', 'r') 
full_text <- readLines(con, n=-1) 
close(con)

# standard processing
corpus <- Corpus(VectorSource(full_text))
# because memory is pretty tight on this, i'll drop full_text here
rm(full_text)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeNumbers))
corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, content_transformer(stripWhitespace))

# 
dtm <- DocumentTermMatrix(corpus)) # , control = list(tokenize = bigramTokenizer))
sparse <- removeSparseTerms(x = dtm, sparse = 0.95)

# So. initial processing a) fails to create a DTM with the bigram tokenizer, and b) the complete dataset will be
# a complete memory nightmare to deal with. 
# Based on this (and with recommendations from others, I'll create a DTM using python, then load it into R for analysis
