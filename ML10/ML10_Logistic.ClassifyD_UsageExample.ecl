//ML10_Logistic.ClassifyD_UsageExample.ecl
//Uses sparse implementation of Logistic
IMPORT ML;
value_record := RECORD
UNSIGNED rid;
REAL age;
REAL height;
integer1 sex; // 0 = female, 1 = male
END;
d := DATASET([{1,35,149,0},{2,11,138,0},{3,12,148,1},{4,16,156,0},
{5,32,152,0},{6,16,157,0},{7,14,165,0},{8,8,152,1},
{9,35,177,0},{10,33,158,1},{11,40,166,0},{12,28,165,0},
{13,23,160,0},{14,52,178,1},{15,46,169,0},{16,29,173,1},
{17,30,172,0},{18,21,163,0},{19,21,164,0},{20,20,189,1},
{21,34,182,1},{22,43,184,1},{23,35,174,1},{24,39,177,1},
{25,43,183,1},{26,37,175,1},{27,32,173,1},{28,24,173,1},
{29,20,162,0},{30,25,180,1},{31,22,173,1},{32,25,171,1}]
,value_record);
OUTPUT(d,NAMED('d'));

ML.ToField(d,flds0);
OUTPUT(flds0,NAMED('flds0'));

flds := ML.Discretize.ByRounding(flds0);
OUTPUT(SORT(flds,id,number),NAMED('flds'));

MyLogisticRegression:=ML.Classify.Logistic_sparse();

Model3 := MyLogisticRegression.LearnD(flds(Number<=2),flds(Number>=3));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

predict:=MyLogisticRegression.ClassifyD(flds(Number<=2),Model3);
OUTPUT(SORT(predict,id,number),NAMED('predict'));

predicted_v_actual :=
  JOIN(predict,flds(Number>=3)
       ,(LEFT.id=RIGHT.id) and (LEFT.number=RIGHT.number)
       ,TRANSFORM({UNSIGNED id,UNSIGNED4 number,REAL8 pvalue,REAL8 avalue}
                  ,SELF.pvalue:=LEFT.value
                  ,SELF.avalue:=RIGHT.value
                  ,SELF := LEFT
        )
  );
OUTPUT(SORT(predicted_v_actual,id,number),NAMED('predicted_v_actual'));

Accuracy_proportion := COUNT(predicted_v_actual(pvalue=avalue))/COUNT(predicted_v_actual);
Output(Accuracy_proportion, NAMED('Accuracy'));

TestModule := MyLogisticRegression.TestD(flds(Number<=2),flds(Number=3));
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;