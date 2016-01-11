# Some geo analysis
# Use kmeans to check state/location based on lat-long
# i have the list of actual locations which the data should be from, so i will seed the kmeans with that
y.locations<- c()
library(ggmap)
cities<-c('Edinburgh, UK', 'Karlsruhe, Germany', 'Montreal, Canada', 'Waterloo, Canada', 
'Pittsburgh, PA', 'Charlotte, NC', 'Urbana-Champaign, IL', 'Phoenix, AZ', 'Las Vegas, NV', 'Madison, WI')
region.centers<-geocode(cities)
set.seed(43046721)
myclus<-kmeans(y.business[,c('longitude','latitude')],region.centers)
table(myclus$cluster, y.business$state)

# these results show a good grouping, where each state is entirely represented by one cluster, with the exception of two. 
# Cluster 8 and 9 both contain CA - resaonable as they both border it. Cluster 9 seems to contain a rogue SC entry
y.business[which(myclus$cluster==9&y.business$state=='NC'),]$full_address
# This shows a typo, where NC instead of NV was used. It seems that the 'state' data was taken from the address.
y.business$cluster <- myclus$cluster
table(y.business$cluster)
# i'll add a distance to the cluster center too - i can then do some analysis of the area covered by each cluster
# this is only for a comparative measure, and the distances /should/ be realtively short, so i won't go so far as a great circle calculation
t.distance<-y.business[,c('longitude','latitude')]-myclus$centers[y.business$cluster,]
y.business$cluster.distance<-sqrt(rowSums(t.distance**2))
tbl_df(y.business[,c('cluster','cluster.distance')]) %>% group_by(cluster) %>% summarise(mn=mean(cluster.distance), sd=sd(cluster.distance))

