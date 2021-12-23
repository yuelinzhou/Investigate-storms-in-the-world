## 4) Data Importing in R
library("readr")

column_names <- c("serial_Num","season","num","basin","sub_basin","name", "iSO_time", "nature","latitude","longitude","wind","press")
column_types <- c("character","integer","character","factor","character","character","character","character","real","real","real","real")
dat <- read.csv("~/stat133/workouts/workout1/data/ibtracs-2010-2015.csv",sep = ",",header = TRUE,colClasses = column_types,col.names = column_names,
                na.strings  = c("-999.","-1.0","0.0"))

sink(file = "stat133/workouts/workout1/output/data-summary.txt")
summary(dat)
sink()

## 5) Data Visualization
library("dplyr")
library("chron")
library("ggplot2")
library("lubridate")
library("maps")
library("mapdata")
library("geofacet")

# 5.1）
world <- map_data("world")
ggplot(dat) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#0066CC")+ 
scale_color_gradient(low = "#CCFFCC",high = "#006600") +
scale_size(range = c(0.15,1.5))
ggsave(filename = "stat133/workouts/workout1/images/map-all-storms.pdf")


png(filename = "stat133/workouts/workout1/images/map-all-storms.png")
ggplot(dat) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#0066CC")+ 
scale_color_gradient(low = "#CCFFCC",high = "#006600") +
scale_size(range = c(0.15,1.5)) 
dev.off()


# 5.2)
dat2 <- filter(dat, basin == " EP" | basin == " NA")

ggplot(dat2) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
facet_wrap(~ season) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#006600") + 
scale_color_gradient(low = "blue",high = "red") +
scale_size(range = c(0.15,1.5))
ggsave(filename = "stat133/workouts/workout1/images/map-ep-na-storms-by-year.pdf")


png(filename = "stat133/workouts/workout1/images/map-ep-na-storms-by-year.png")
ggplot(dat2) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
facet_wrap(~ season) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#006600") + 
scale_color_gradient(low = "blue",high = "red") +
scale_size(range = c(0.15,1.5))
dev.off()

# 5.3)
date_time <- ymd_hms(dat2$iSO_time)
dat3 <- cbind(dat2,date_time)

month_num <- month(date_time)
dat3 <- cbind(dat3,month_num)

month_str <- month(date_time,label = TRUE)
dat3 <-cbind(dat3,month_str)

ggplot(dat3) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
facet_wrap(~ month_str) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "blue") + 
scale_color_gradient(low = "yellow",high = "red") +
scale_size(range = c(0.15,1.5)) 
ggsave(filename = "stat133/workouts/workout1/images/map-ep-na-storms-by-month.pdf")


png(filename = "stat133/workouts/workout1/images/map-ep-na-storms-by-month.png")
ggplot(dat3) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
facet_wrap(~ month_str) + 
geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "blue") + 
scale_color_gradient(low = "yellow",high = "red") +
scale_size(range = c(0.15,1.5))  
dev.off()


# Some additional graphic I make for my report in part 6
png(filename = "stat133/workouts/workout1/images/uniquename.png",width = 200, height = 130)
ggplot(unique(select(dat,name,season)),aes(x = season)) + 
geom_bar(width=rep(0.3,6),fill="yellow")+
ggtitle("Unique Storms per Year") 
dev.off()

png(filename = "stat133/workouts/workout1/images/pressures.png",width = 200, height = 130)
ggplot(filter(dat,latitude >0 &latitude <= 90),aes(x= press)) + geom_bar() + ggtitle("south pressure") 
dev.off()
png(filename = "stat133/workouts/workout1/images/pressuren.png",width = 200, height = 130)
ggplot(filter(dat,latitude < 0 & latitude >= -90),aes(x= press)) + geom_bar()+ ggtitle("north pressure") 
dev.off()

png(filename = "stat133/workouts/workout1/images/all-storms-by-year.png",width = 350, height = 300)
ggplot(dat) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
  facet_wrap(~ season) +
  geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#0066CC")+ 
  scale_color_gradient(low = "red",high = "brown") +
  scale_size(range = c(0.15,1.5))
dev.off()

date_time2 <- ymd_hms(dat$iSO_time)
dat4 <- cbind(dat,date_time2)

month_num <- month(date_time2)
dat4 <- cbind(dat4,month_num)

month_str <- month(date_time2,label = TRUE)
dat4 <-cbind(dat4,month_str)

png(filename = "stat133/workouts/workout1/images/all-storms-by-month.png",width = 350, height = 300)
ggplot(dat4) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
  facet_wrap(~ month_str) + 
  geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "blue") + 
  scale_color_gradient(low = "red",high = "black") +
  scale_size(range = c(0.15,1.5))  
dev.off()

png(filename = "stat133/workouts/workout1/images/all-storms-by-basin.png",width = 350, height = 300)
ggplot(dat) + geom_point(aes(x =longitude, y = latitude,size = press,color = wind,shape = nature)) + 
  facet_wrap(~ basin) + 
  geom_polygon(data = world, aes(x=long, y = lat, group = group),fill = "#0066CC")+ 
  scale_color_gradient(low = "#CCFFCC",high = "#006600") +
  scale_size(range = c(0.15,1.5)) 
dev.off()

png(filename = "stat133/workouts/workout1/images/top_10.png",width = 300, height = 300)
ggplot(top_10_list, aes(x= wind)) + geom_bar(fill="steelblue")+
  theme_minimal() + ggtitle("Number of storm in the Top 10 wind value") 
dev.off()

png(filename = "stat133/workouts/workout1/images/bar-distance.png",width = 300, height = 300)
barplot(table(cut(abs((duration_second/3600) - mean_hour),breaks = c(0,3,6,9,20,100,500,1000,2000),labels = c("0-3","3-6","6-9","9-20","20-100","100-500","500-1000","1000-2000"))),main = "Distance from the mean in hours", cex.names=0.7,col = rainbow(8))
dev.off()


