#source("ML10_KNN_KDTree_UsageExample_monks.r")
MonkTrainData=read.csv("monks-1_train.csv", header=T)
MonkTestData=read.csv("monks-1_test.csv", header=T)

train <- MonkTrainData[,2:7]
test <- MonkTestData[,2:7]
cl <- MonkTrainData[,1]
monk.knn.train <- knn(train, test, cl, k = 5, prob=TRUE,algorithm="kd_tree")
monk.knn.test <- knn1(train,test

len <- length(MonkTrainData.predict)

MonkTrainData.result <- vector()
matches <- 0
for ( i in 1:len ){
   if ( MonkTrainData.predict[i] <= 0 ){
      MonkTrainData.result[i] <- 0;
   }
   else{
      MonkTrainData.result[i] <- 1;
   }
   
   if ( MonkTrainData.result[i] == MonkTrainData[i,3] ){
      matches <- matches + 1
   }
}

matches

