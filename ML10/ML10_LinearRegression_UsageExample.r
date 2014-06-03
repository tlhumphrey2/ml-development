#source("UsageExample_LinearRegression.r")
LinearRegressionFile="LinearRegressionData.csv"
LinearRegressionData=read.csv(LinearRegressionFile, header=T)

#attach(LinearRegressionData)
LinearRegressionData.lm <- lm(formula=height ~ age,data=LinearRegressionData)
LinearRegressionData.predict <- predict.lm(object=LinearRegressionData.lm,newdata=data.frame(age=LinearRegressionData[,1]))

diff <- abs(LinearRegressionData.predict-data.frame(height=LinearRegressionData[,2]))
