//ML10_KNN_KDTree_UsageExample_iris.ecl
IMPORT * FROM ML;
IrisDS:=ML.Tests.Deprecated.IrisPlantDS;
OUTPUT(IrisDS, NAMED('IrisDS'));

randomize( ds ) := FUNCTIONMACRO

ds_out :=
   PROJECT(
      SORT(
           PROJECT(ds
                   ,TRANSFORM({REAL ran,RECORDOF(ds)}
                              ,SELF.ran:=RANDOM()
                              ,SELF := LEFT
                    )
           )
           ,ran
      )
      ,RECORDOF(ds)
   );
  return ds_out;
ENDMACRO;

Randomized_IrisDS := randomize(IrisDS);

Train_IrisDS := Randomized_IrisDS(rid<=75);
//Test_IrisDS := Randomized_IrisDS(rid>75);
Test_IrisDS := IrisDS;

Depth:= 10;
MedianDepth:= 15;

indep_data:= TABLE(Train_IrisDS,{rid, sepal_length, sepal_width, petal_length, petal_width});
indep_test:= TABLE(Test_IrisDS,{rid, sepal_length, sepal_width, petal_length, petal_width});
dep_data:= TABLE(Train_IrisDS,{rid, class});
dep_test:= TABLE(Test_IrisDS,{rid, class});

ToField(indep_data, indepData);
ToField(indep_test, IndepTest);

ToField(dep_data, pr_dep);
ToField(dep_test, pr_depT);

depData := ML.Discretize.ByRounding(pr_dep);
depTest := ML.Discretize.ByRounding(pr_depT);


iknn:= Lazy.KNN_KDTree(3);

/*
TestModule:=  iknn.TestC(IndepTest, depTest);
OUTPUT(TestModule.Raw,NAMED('TestModuleRaw'));
OUTPUT(TestModule.CrossAssignments,NAMED('TestModuleCrossAssignments'));
OUTPUT(TestModule.PrecisionByClass,NAMED('TestModulePrecisionByClass'));
OUTPUT(TestModule.Headline,NAMED('TestModuleHeadline'));
*/

computed:=  iknn.ClassifyC(IndepData, depData, IndepTest);
OUTPUT(computed,NAMED('computed'));
Comparison:=  ML.Classify.Compare(depTest, computed);
OUTPUT(Comparison.Raw,NAMED('ComparisonRaw'));
OUTPUT(Comparison.CrossAssignments,NAMED('ComparisonCrossAssignments'));
OUTPUT(Comparison.PrecisionByClass,NAMED('ComparisonPrecisionByClass'));
OUTPUT(Comparison.Headline,NAMED('ComparisonHeadline'));
