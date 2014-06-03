#source("ML10_AggloN_UsageExample_cars.r")
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

# Getting distance matrix:

dist.cars <- dist(cars.std)

# Single linkage:

cars.single.link <- hclust(dist.cars, method='single')

# Plotting the single linkage dendrogram:

plot(cars.single.link, labels = row.names(cars.data), frame.plot = FALSE, ann = TRUE, main = "Cluster Dendrogram", sub = NULL, xlab = NULL, ylab = "Height")

windows() # opening new window while keeping previous one open

# complete linkage:

cars.complete.link <- hclust(dist.cars, method='complete')

# Plotting the complete linkage dendrogram:

plot(cars.complete.link, labels = row.names(cars.data), frame.plot = FALSE, ann = TRUE, main = "Cluster Dendrogram", sub = NULL, xlab = NULL, ylab = "Height")

windows() # opening new window while keeping previous one open

# Average linkage:

cars.avg.link <- hclust(dist.cars, method='average')

# Plotting the average linkage dendrogram:

plot(cars.avg.link, labels = row.names(cars.data), frame.plot = FALSE, ann = TRUE, main = "Cluster Dendrogram", sub = NULL, xlab = NULL, ylab = "Height")

# Output dendrograms as nested parentheses for comparison with those of ML.Cluster.AggloN.
library(ctc)
cars.single.link.Newick <- hc2Newick(cars.single.link)
plot(cars.single.link, labels = row.names(cars.data), frame.plot = FALSE, ann = TRUE, main = "Cluster Dendrogram", sub = NULL, xlab = NULL, ylab = "Height")

cars.single.link.Newick <- hc2Newick(cars.single.link)
cars.complete.link.Newick <- hc2Newick(cars.complete.link)
cars.avg.link.Newick <- hc2Newick(cars.avg.link)

write(cars.single.link.Newick,file='cars.single.link.newick') 
write(cars.complete.link.Newick,file='cars.complete.link.newick') 
write(cars.avg.link.Newick,file='cars.avg.link.newick') 

