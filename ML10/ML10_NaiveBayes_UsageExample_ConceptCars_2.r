#source("ML10_NaiveBayes_UsageExample_ConceptCars_2.r")
library(e1071)
conceptcars <- read.csv("ConceptCarsDS2a.csv", header=T)

conceptcars.train <- conceptcars[1:570,]
conceptcars.test <- conceptcars[571:length(conceptcars[,1]),]

conceptcars.classifier <- naiveBayes(conceptcars.train[,1:6], conceptcars.train[,7])
conceptcars.predict <- predict(conceptcars.classifier, conceptcars.test[,1:6])
table(conceptcars.predict,conceptcars.test[,7])


matches <- 0
len <- length(conceptcars.test[,1])
for ( i in 1:len){
   if ( conceptcars.test[i,7] == conceptcars.predict[i] ){
      matches <- matches + 1
   }
}

proportion_correct <- matches/len
