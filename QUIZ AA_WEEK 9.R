#243231041_Atikah azmi
#QUIZ AA WEEK 9

# 9) ToothGrowth --> number of row and column
library(datasets)
data(ToothGrowth)
dim(ToothGrowth)

# 10) fligths dataset --> max flight distance 
library("nycflights13")
flights
View(flights)
max_distance <- max(flights$distance)
print(max_distance)
