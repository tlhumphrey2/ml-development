//ML10_NaiveBayes.ClassifyD_UsageExample_ConceptCar.ecl
IMPORT * FROM $;
IMPORT ML;

d := cCar;
OUTPUT(d,NAMED('d'));

ML.ToField(d,flds0);

flds := ML.Discretize.ByRounding(flds0);
OUTPUT(flds,NAMED('flds'));

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(flds(Number<=2),flds(Number=3));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

predict:=MyNaiveBayesRegression.ClassifyD(flds(Number<=2),Model3);
OUTPUT(predict,NAMED('predict'));

TestModule := MyNaiveBayesRegression.TestD(flds(Number<=2),flds(Number=3));
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;
