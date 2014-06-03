#hclust_UsageExample_cars.r
#
##########################
##
##  K-means clustering
##
##########################

###########################################
###  mtcars example 
###########################################

mtcars <- read.csv("mtcars.csv", header=T)
cars.data <- mtcars[,c(3,5:9)];

# Standardizing by dividing through by the sample range of each variable

samp.range <- function(x){
  myrange <- diff(range(x))
  return(myrange)
}

my.ranges <- apply(cars.data,2,samp.range)
cars.std <- sweep(cars.data,2,my.ranges,FUN="/") 

attach(mtcars)

# Let's try k=4:

cars.k4 <- kmeans(cars.std, centers=4, iter.max=100, nstart=25)
cars.k4.first_run_centroids <- cars.k4$centers;
cars.k4.first_run_centroids

# Make new initial cluster centroids (centers)

nobs <- length(cars.k4.first_run_centroids[,1])
nfeatures <- length(cars.k4.first_run_centroids[1,])

cars.k4.second_run_initial_centroids <- cars.k4.first_run_centroids
for ( i in 1:nobs ){
    for ( j in 1:nfeatures ){
       if ( (i==1) && (j==1) ){
          cars.k4.second_run_initial_centroids[i,j] <- 2
       }
       else{
          cars.k4.second_run_initial_centroids[i,j] <- round(cars.k4.first_run_centroids[i,j],0)
       }
    }
}

cars.k4 <- kmeans(cars.std, centers=cars.k4.second_run_initial_centroids, iter.max=100, nstart=25)
cars.k4.second_run_centroids <- cars.k4$centers;
cars.k4.second_run_centroids


cars.k4.clust <- lapply(1:4, function(nc) plotsym[cars.k4$cluster==nc])  

############# Visualization of Clusters:

### Via the scatterplot matrix:

pairs(mtcars[,3:13], panel=function(x,y) text(x,y,cars.k4$cluster))


### Via a plot of the scores on the first 2 principal components, 
### with the clusters separated by color:

cars.pc <- princomp(cars.data,cor=T)

# Setting up the colors for the 5 clusters on the plot:
my.color.vector <- rep("green", times=nrow(cars.data))
my.color.vector[cars.k4$cluster==1] <- "green"
my.color.vector[cars.k4$cluster==2] <- "blue"
my.color.vector[cars.k4$cluster==3] <- "red"
my.color.vector[cars.k4$cluster==4] <- "orange"

# Plotting the PC scores:

par(pty="s")
par(font=1)
plot(cars.pc$scores[,1], cars.pc$scores[,2], ylim=range(cars.pc$scores[,1]), xlab="PC 1", ylab="PC 2", type ='n', lwd=2)
text(cars.pc$scores[,1], cars.pc$scores[,2], labels=plotsym, cex=0.7, lwd=2, col=my.color.vector)
text(cars.pc$scores[,1], cars.pc$scores[,2], labels=plotsym, cex=0.7, lwd=2, col=my.color.vector)

