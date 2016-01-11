# First, need to load the data into R. It's in a streamed form of JSON, so needs a particular method of loading
library(jsonlite)

#rm(list=ls())
setwd('~/R_code/DSCapstone/yelp_dataset_challenge_academic_dataset')

if (file.exists('yelp_data.Rd'))
{
  load('yelp_data.Rd')
} else {
  y.business <- stream_in(file("yelp_academic_dataset_business.json"))
  y.checkin <- stream_in(file("yelp_academic_dataset_checkin.json"))
  y.review <- stream_in(file("yelp_academic_dataset_review.json"))
  y.tip <- stream_in(file("yelp_academic_dataset_tip.json"))
  y.user <- stream_in(file("yelp_academic_dataset_user.json"))
  save(list=c('y.business','y.user','y.review','y.tip','y.checkin'), file='yelp_data.Rd')
}

dim(business)
str(y.business)

subset(y.business, y.business$attributes$Ambience$romantic == TRUE)$categories

colnames(y.business$attributes$Ambience)
y.review[98:100,]


library(caret)

