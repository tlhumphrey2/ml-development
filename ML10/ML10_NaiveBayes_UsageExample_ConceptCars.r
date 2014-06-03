#source("ML10_NaiveBayes_UsageExample_ConceptCars.r")
library(class)
conceptcars <- read.csv("ConceptCarsDS2a.csv", header=T)

conceptcars.classifier <- naiveBayes(conceptcars[,1:6], conceptcars[,7])
conceptcars.predict <- predict(conceptcars.classifier, conceptcars[,1:6])
table(conceptcars.predict,conceptcars[,7])


matches <- 0
len <- length(conceptcars[,1])
for ( i in 1:len){
   if ( conceptcars[i,7] == conceptcars.predict[i] ){
      matches <- matches + 1
   }
}

proportion_correct <- matches/len
