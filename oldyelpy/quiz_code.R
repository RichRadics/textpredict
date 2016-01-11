library(dplyr)
# Quiz 1 code

# Q3
nrow(y.review)
# Q4
y.review[100,]$text
#q5
table(y.review$stars)/nrow(y.review)

# q6
nrow(y.business)

#q7
# subset(y.business, y.business$attributes$`Wi-Fi`=='free')
tmpt<-table(y.business$attributes$`Wi-Fi`)
tmpt/sum(tmpt)

#q8
nrow(y.tip)
#q9
y.tip[1000,]
#q10
subset(y.user, y.user$compliments$funny>10000)$name
#q11
table(y.user$fans>1)
table(y.user$fans>1, y.user$compliments$funny>1 & !is.na(y.user$compliments$funny))
fisher.test(table(y.user$fans>1, y.user$compliments$funny>1 & !is.na(y.user$compliments$funny)))