#source("UsageExample_ClassifyLogistic.r")
LogisticExampleFile="data_UsageExample_ClassifyLogistic.csv"
LogisticExampleData=read.csv(LogisticExampleFile, header=T)

attach(LogisticExampleData)
LogisticExampleData.logit <- glm(formula=sex ~ age + height, family=binomial("logit"))

LogisticExampleData.predict <- predict.glm(LogisticExampleData.logit,LogisticExampleData[,1:2])

len <- length(LogisticExampleData.predict)

LogisticExampleData.result <- vector()
matches <- 0
for ( i in 1:len ){
   if ( LogisticExampleData.predict[i] <= 0 ){
      LogisticExampleData.result[i] <- 0;
   }
   else{
      LogisticExampleData.result[i] <- 1;
   }
   
   if ( LogisticExampleData.result[i] == LogisticExampleData[i,3] ){
      matches <- matches + 1
   }
}

matches

