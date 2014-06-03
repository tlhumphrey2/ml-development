#UsageExample_food_KMeans.r
#
##########################
##
##  K-means clustering
##
##########################

###########################################
###  Foodstuffs example 
###########################################

food <- read.table("http://www.stat.sc.edu/~hitchcock/foodstuffs.txt", header=T)
std <- sapply(food[,-1],sd) # finding standard deviations of variables
food.std <- sweep(food[,-1],2,std,FUN="/") 


attach(food)

# Consider the food.std data frame given above.

# A K-means clustering with k = 5:

# Note that the stability of the result can be improved by increasing the maximum number 
# of iterations and using multiple random starts:

food.k5 <- kmeans(food.std, centers=5, iter.max=100, nstart=25)
food.k5

# Let's try k=4:

food.k4 <- kmeans(food.std, centers=4, iter.max=100, nstart=25)
food.k4

# Printing the clustering vector for the 4-cluster solution:

food.k4$cluster

food.k4.clust <- lapply(1:4, function(nc) Food[food.k4$cluster==nc])  
food.k4.clust   # printing the clusters in terms of the Food labels

############# Visualization of Clusters:

### Via the scatterplot matrix:

pairs(food[,-1], panel=function(x,y) text(x,y,food.k4$cluster))

# Cluster 1 foods tend to be high in calcium. (this comment does not reflect all runs of the algorithm)
# Cluster 4 foods tend to be high in fat. (this comment does not reflect all runs of the algorithm)


### Via a plot of the scores on the first 2 principal components, 
### with the clusters separated by color:

food.pc <- princomp(food[,-1],cor=T)

# Setting up the colors for the 5 clusters on the plot:
my.color.vector <- rep("green", times=nrow(food))
my.color.vector[food.k4$cluster==1] <- "green"
my.color.vector[food.k4$cluster==2] <- "blue"
my.color.vector[food.k4$cluster==3] <- "red"
my.color.vector[food.k4$cluster==4] <- "orange"

# Plotting the PC scores:

par(pty="s")
par(font=1)
plot(food.pc$scores[,1], food.pc$scores[,2], ylim=range(food.pc$scores[,1]), xlab="PC 1", ylab="PC 2", type ='n', lwd=2)
text(food.pc$scores[,1], food.pc$scores[,2], labels=Food, cex=0.7, lwd=2, col=my.color.vector)
text(food.pc$scores[,1], food.pc$scores[,2], labels=Food, cex=0.7, lwd=2, col=my.color.vector)

# Cluster 1 is the "canned seafood" cluster.  (this comment does not reflect all runs of the algorithm)
# Cluster 2 is the clams cluster.  (this comment does not reflect all runs of the algorithm)

## NOTE:  The default for the kmeans function in R is the Hartigan-Wong (1979) algorithm.
## The MacQueen algorithm (1967) can be used by altering the code to, say:
##                kmeans(food.std, centers=4,algorithm="MacQueen")
## You can try it in this case -- I don't think the MacQueen algorithm produces as good of a result.


#require(graphics)
#pairs(mtcars, main = "mtcars data")
#coplot(mpg ~ disp | as.factor(cyl), data = mtcars, panel = panel.smooth, rows = 1)



