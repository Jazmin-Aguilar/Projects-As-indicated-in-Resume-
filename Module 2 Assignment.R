#install packages
install.packages ("tidyverse")
install.packages ("janitor")
install.packages("cluster")
install.packages("fpc")
install.packages("factoextra")


#load libraries
library(tidyverse)
library(janitor)
library(cluster)
library(fpc)
library(factoextra)
#set working directory (adjust this for your own computer)
setwd("C:/Users/jazmi/OneDrive/1. DTSC-560-80 Data Science for Business/DTSC-560-80 Data Science for Business/Module 2 Assignment csv files")


#read dataset into R
employeesdf <- read.csv("employees.csv")
View(employeesdf)

##PART 1: K-means Cluster Analysis




#1. Conduct a k-means cluster analysis using four variable specified above (Age, MonthlyIncome, PercentSalaryHike, YearAtCompany)

# Create df with the four columns, columns of interest are: 
employees4df <- employeesdf[c(-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-17,-18,-19,-21,-22,-23,-24,-26,-27,-28)]
View(employees4df)

#normalize each variable
employees4dfn<-scale(employees4df)
View(employees4dfn)


#set random number seed in order to replicate the analysis
set.seed(42)




#2. Create a function to calculate the total within-cluster sum of squared deviations using 10 random starts(nstart)

wss<-function(k){kmeans(employees4dfn, k, nstart=10)} $tot.withinss



#3. Generate an elbow plot

#range of k values for elbow plot
k_values<- 1:10

# run the function to create the range of values for the elbow plot
wss_values<-map_dbl(k_values, wss)

#create a new data frame containing both k_values and wss_values
elbowdf<- data.frame(k_values, wss_values)

#graph the elbow plot  Quiz Question 1: graph depicts cluster should be around 4 to 6
ggplot(elbowdf, mapping = aes(x = k_values, y = wss_values)) +
  geom_line() + geom_point()





#4. Run k-means clustering with 4 clusters(k=4) and 1000 random restarts


k4<-kmeans(employees4dfn, 4, nstart=1000)


#5. display the structure of the 4-means clustering object

str(k4)
k4
## Quiz Question 2&3: size of largest cluster: 717. size of smallest cluster 135




#6 Display cluster statistics using the Euclidean method

#display cluster statistics

#Quiz Question 4: densest cluster:4, within cluster average distance($average.distance-> 2.32,2.18,1.71,1.47)
cluster.stats(dist(employees4dfn, method="euclidean"), k4$cluster)
#Quiz Question 5: ratio of the average between-cluster(smallest to largest 3 and 2) distance to average within-cluster(smallest cluster 3) 
# average withing cluster 3->2.320545
#average between cluster 3 and 2 -> 4.039153
Q5<- 4.039153/2.320545
Q5

# 1.740605

#distance for the smallest cluster and the largest cluster?

# first need to isolate smallest cluster which is cluster #1 




#7. combining each observation's cluster assignment with unscaled data frame
employeesdfcluster<-cbind(employeesdf, clusterID=k4$cluster)
View(employeesdfcluster)

#write data frame to CSV file to analyze in Excel
write.csv(employeesdfcluster, "employees_kmeans_4clusters.csv")



#8. calculate variable averages for all non-normalized observations
summarize_all(employeesdf, mean)
##############WRONG#Question 7: average monthly income for all employees in the dataset-> $6502.931




#9. average variable for each cluster
clusteravgs <- employeesdfcluster %>%
        group_by(clusterID) %>%
        summarize_all(mean)
view(clusteravgs)
#Quiz Question #8:cluster with highest age gets: paid the most per Hourly rate, most education, job involvement,
#monthly rate,most numb of companies worked

#Quiz Question #9: cluster with highest years at company: 
### highest job level,least job satisfaction, most monthly income,highest relationship satisfaction,
#highest: work life balance,total working years,years current role, years since last promotions, years with current manager

#Quiz Question #10: cluster with highest average salary hike
# highest daily rate, highest distance from home, least education, lowest hourly rate, highest job satisfaction, 
#least number of companies worked, highest performance rating, least relationship satisfaction, least years at company, least years at current
#role, least years w/ current manager

#PART 2: Hierarchical Cluster Analysis

view(employees4df)


#1.scale the data
view(employees4dfn)

#Euclidean Distance
eucl_dist<-dist(employees4dfn, method="euclidean")

#use ward's method
cl_eucl_avg<-hclust(eucl_dist, method="ward.D")

# generate dendrogram
plot(cl_eucl_avg)

#create 4 clusters using the cutree function

cl_eucl_avg_4 <-cutree(cl_eucl_avg, k=4)

#link cluster assignemnts to original df

dfwardscluster<-cbind(employeesdf, clusterID=cl_eucl_avg_4)
view(dfwardscluster)

#display the number of observations of each cluster
dfwardscluster %>%
  group_by(clusterID) %>%
  summarize(n())

#Quiz Question #12, largest cluster:1 489
#Quiz Question #13, smallest cluster:3 221

#8. Calculate variable averages for all non-normalized observations


#9. average variable for each cluster
df2 <- dfwardscluster %>%
  group_by(clusterID) %>%
  summarize_all(mean)

view(df2)

# Quiz Question #14: Key Characteristics of cluster 1:

#highest daily rate, highest distance from home,h education,h hourly rate,h monthly rate, 
#h num of companies worked,h relationship satisfaction, l years at company,l years at current role,
#l years at current role, & l years w/ current man


#Quiz Question #15:Key Characteristics of Cluster 3
#youngest, l daily rate,lowest education, lowest job involment, l job level, l montly income,
#l number of companies worked, l percent salary hike, l performance rating, l total year worked, 
# h work life balance, 

#Quiz Question #16: 


cluster.stats(dist(employees4dfn, method="euclidean"), dfwardscluster$cluster)