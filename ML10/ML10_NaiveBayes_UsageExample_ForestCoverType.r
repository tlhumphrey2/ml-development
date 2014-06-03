#source("ML10_NaiveBayes_UsageExample_ForestCoverType.r")
library(e1071)
covtype <- read.csv("randomize_covtype.data", header=FALSE)
covtrain <- read.csv("randomize_covtype.data", header=FALSE, nrows=11340)
covtest <- read.csv("randomize_covtype.data", header=FALSE, skip=11340)

xcovtrain <- as(covtrain[,2:54], "matrix")
ycovtrain <- covtrain[,55]

xcovtest <- as(covtest[,2:54], "matrix")
ycovtest <- covtest[,55]


ForestCoverType.classifier <- naiveBayes(xcovtrain, ycovtrain)
ForestCoverType.predict <- predict(ForestCoverType.classifier, xcovtest)
table(ForestCoverType.predict,ycovtest)


matches <- 0
len <- length(ForestCoverType[,1])
for ( i in 1:len){
   if ( ycovtest[i] == ForestCoverType.predict[i] ){
      matches <- matches + 1
   }
}

proportion_correct <- matches/len
