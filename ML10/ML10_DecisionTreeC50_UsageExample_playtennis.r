#source("ML10_DecisionTreeC50_UsageExample_playtennis.r")
library(C50)
#PlayTennisData=read.csv("r_play_tennis.csv", header=T) # this dataset gets slightly less accurate results then play_tennis.csv
PlayTennisData=read.csv("play_tennis.csv", header=T)

PlayTennisData.ruleModel <- C5.0(playtennis ~ ., data=PlayTennisData, rules=TRUE)
PlayTennisData.ruleModel.predict <- predict.C5.0(PlayTennisData.ruleModel, PlayTennisData[,-5])

PlayTennisData.treeModel <- C5.0(x=PlayTennisData[,-5], y=PlayTennisData$playtennis)
PlayTennisData.treeModel.predict <- predict.C5.0(PlayTennisData.treeModel, PlayTennisData[,-5])

len.ruleModel.predict <- length(PlayTennisData.ruleModel.predict)
PlayTennisData.ruleModel.result <- vector()
PlayTennisData.ruleModel.matches <- 0
for ( i in 1:len.ruleModel.predict ){
   if ( PlayTennisData.ruleModel.predict[i] == PlayTennisData[i,5] ){
      PlayTennisData.ruleModel.matches <- PlayTennisData.ruleModel.matches + 1
   }
}

PlayTennisData.ruleModel.matches/len.ruleModel.predict

len.treeModel.predict <- length(PlayTennisData.treeModel.predict)
PlayTennisData.treeModel.result <- vector()
PlayTennisData.treeModel.matches <- 0
for ( i in 1:len.treeModel.predict ){
   if ( PlayTennisData.treeModel.predict[i] == PlayTennisData[i,5] ){
      PlayTennisData.treeModel.matches <- PlayTennisData.treeModel.matches + 1
   }
}

PlayTennisData.treeModel.matches/len.treeModel.predict
