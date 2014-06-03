//UsageExampleIris_x10_Classify.NaiveBayes.ClassifyD.ecl
IMPORT * FROM ML;
iris := ML.Tests.Deprecated.IrisPlantDS;
OUTPUT(iris,NAMED('iris'));
ML.ToField(iris,flds0a);
flds0:=
   PROJECT(flds0a
           ,TRANSFORM(recordof(flds0a)
                      ,SELF.value := IF( LEFT.number=1, LEFT.value, LEFT.value*10)
                      ,SELF:=LEFT
            )
   );
OUTPUT(flds0,NAMED('flds0'));
flds := ML.Discretize.ByRounding(flds0);
OUTPUT(flds,NAMED('flds'));
MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(flds(Number>1),flds(Number=1));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));
predict:=MyNaiveBayesRegression.ClassifyD(flds(Number>1),Model3);
OUTPUT(predict,NAMED('predict'));

actual_predicted := RECORD
  unsigned id;
  real8 a_value;
  real8 p_value;
  real8 p_conf;
  real8 p_closest_conf;
END;

avp :=
   JOIN(flds(Number=1)
        ,predict
        ,LEFT.id=RIGHT.id
        ,TRANSFORM(actual_predicted
                   ,SELF.id:=LEFT.id
                   ,SELF.a_value:=LEFT.value
                   ,SELF.p_value:=RIGHT.value
                   ,SELF.p_conf:=RIGHT.conf
                   ,SELF.p_closest_conf:=RIGHT.closest_conf
         )
   );
OUTPUT( SORT(avp,id),NAMED('actual_v_predict')); 
OUTPUT(COUNT(avp(a_value<>p_value)),NAMED('number_of_mismatches'));
OUTPUT(COUNT(avp)-COUNT(avp(a_value<>p_value)),NAMED('number_of_matches'));
OUTPUT(REALFORMAT((REAL)(COUNT(avp)-COUNT(avp(a_value<>p_value)))/(REAL)COUNT(avp),4,2),NAMED('proportion_correct'));
TestModule := MyNaiveBayesRegression.TestD(flds(Number>1),flds(Number=1));
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;
