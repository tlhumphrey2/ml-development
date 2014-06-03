#source("ML10_RandomForest_UsageExample_covtype.r")
covtype <- read.csv("randomize_covtype.data", header=FALSE)
covtrain <- read.csv("randomize_covtype.data", header=FALSE, nrows=11340)
#covtest <- read.csv("randomize_covtype.data", header=FALSE, skip=11340, nrows=3780)
covtest <- read.csv("randomize_covtype.data", header=FALSE, skip=11340)
len.covtest <- length(covtest[,1])
every50th <- seq(from=1, to=len.covtest, by=50)
covsample <-  covtest[every50th, ]

xcovtrain <- as(covtrain[,2:54], "matrix")
ycovtrain <- covtrain[,55]
xsampletrain <- as(covsample[,2:54], "matrix")
ysampletrain <- covsample[,55]
ycovtrain <- factor(covtrain[,55])
ysampletrain <- factor(covsample[,55])
covtrain.randomForest <- randomForest(x=xcovtrain, y=ycovtrain,xtest=xsampletrain, ytest=ysampletrain,keep.forest=TRUE,do.trace=5)

xcovtest <- as(covtest[1:10000,2:54], "matrix")
ycovtest <- factor(covtest[1:10000,55])
xcovtest.randomForest.predict <- predict(covtrain.randomForest, xcovtest)

len.randomForest.predict <- length(xcovtest.randomForest.predict)
xcovtest.randomForest.result <- vector()
xcovtest.randomForest.matches <- 0
for ( i in 1:len.randomForest.predict ){
   if ( xcovtest.randomForest.predict[i] == ycovtest[i] ){
      xcovtest.randomForest.matches <- xcovtest.randomForest.matches + 1
   }
}

xcovtest.randomForest.matches/len.randomForest.predict
