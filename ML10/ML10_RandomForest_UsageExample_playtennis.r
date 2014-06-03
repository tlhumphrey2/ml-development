#source(ML10_RandomForest_UsageExample_playtennis.r)
library(randomForest)
#PlayTennisData <- read.csv("r_play_tennis2.csv", header=T)
PlayTennisData <- read.csv("r_play_tennis.csv", header=T)# playtennis field is factors ('yes' and 'no').

PlayTennisData.randomForest <- randomForest(x=PlayTennisData[,1:4],y=PlayTennisData[,5], importance=TRUE, proximity=TRUE, ntree=25)
#PlayTennisData.randomForest <- randomForest(playtennis ~ ., data=PlayTennisData, importance=TRUE, proximity=TRUE, ntrees=25)
PlayTennisData.randomForest.predict <- predict(PlayTennisData.randomForest, PlayTennisData[,-5])

len.randomForest.predict <- length(PlayTennisData.randomForest.predict)
PlayTennisData.randomForest.result <- vector()
PlayTennisData.randomForest.matches <- 0
for ( i in 1:len.randomForest.predict ){
   if ( PlayTennisData.randomForest.predict[i] == PlayTennisData[i,5] ){
      PlayTennisData.randomForest.matches <- PlayTennisData.randomForest.matches + 1
   }
}

PlayTennisData.randomForest.matches/len.randomForest.predict

len.treeModel.predict <- length(PlayTennisData.treeModel.predict)
PlayTennisData.treeModel.result <- vector()
PlayTennisData.treeModel.matches <- 0
for ( i in 1:len.treeModel.predict ){
   if ( PlayTennisData.treeModel.predict[i] == PlayTennisData[i,5] ){
      PlayTennisData.treeModel.matches <- PlayTennisData.treeModel.matches + 1
   }
}

PlayTennisData.treeModel.matches/len.treeModel.predict
