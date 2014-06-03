#source("UsageExample2_ClassifyLogistic.r")
LogisticEg2File="2nd_logistic_example.csv"
LogisticEg2Data=read.csv(LogisticEg2File, header=T)

#attach(LogisticEg2Data)
LogisticEg2Data.logit <- glm(formula=class ~ length, family=binomial("logit"),data=LogisticEg2Data)

LogisticEg2Data.predict <- predict.glm(object=LogisticEg2Data.logit,newdata=LogisticEg2Data[,1])

len <- length(LogisticEg2Data.predict)

LogisticEg2Data.result <- vector()
matches <- 0
for ( i in 1:len ){
   if ( LogisticEg2Data.predict[i] <= 0 ){
      LogisticEg2Data.result[i] <- 0;
   }
   else{
      LogisticEg2Data.result[i] <- 1;
   }
   
   if ( LogisticEg2Data.result[i] == LogisticEg2Data[i,3] ){
      matches <- matches + 1
   }
}

matches

