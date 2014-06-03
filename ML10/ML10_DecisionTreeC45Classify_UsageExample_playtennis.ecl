//ML10_DecisionTreeC45Classify_UsageExample_playtennis.ecl
IMPORT * FROM ML;
DOrtlSeedRandom(unsigned i) := BEGINC++
  rtlSeedRandom(i);
ENDC++;
DOrtlSeedRandom(6578);

playtennis_rec := RECORD
    unsigned rid;
    integer  outlook;
    integer  temperature;
    integer  humidity;
    integer  wind;
    integer  playtennis;
END;

// Translation of field outlook's values:  1 is sunny,  2 is overcast,  3 is rainy
// Translation of field temperature's values:  1 is hot,  2 is mild,  3 is cool
// Translation of field humidity's values:  1 is high,  2 is normal
// Translation of field wind's values:  1 is FALSE,  2 is TRUE
// Translation of field playtennis's values:  0 is no,  1 is yes

d:=DATASET([
            {1,1,1,1,1,0},
            {2,1,1,1,2,0},
            {3,2,1,1,1,1},
            {4,3,2,1,1,1},
            {5,3,3,2,1,1},
            {6,3,3,2,2,0},
            {7,2,3,2,2,1},
            {8,1,2,1,1,0},
            {9,1,3,2,1,1},
            {10,3,2,2,1,1},
            {11,1,2,2,2,1},
            {12,2,2,1,2,1},
            {13,2,1,2,1,1},
            {14,3,2,1,2,0}
           ],playtennis_rec);
OUTPUT(d,NAMED('d'));
ML.ToField(d,flds0);
flds := ML.Discretize.ByRounding(flds0);
OUTPUT(flds,NAMED('flds'));
indep:=flds(number<5);
OUTPUT(indep,NAMED('indep'));
dep:=flds(number=5);
OUTPUT(dep,NAMED('dep'));

C45Module:=ML.Classify.DecisionTree.C45();
model:= C45Module.LearnD(indep, dep);
OUTPUT(model,named('model'));

predict:=C45Module.ClassifyD(indep,model);
OUTPUT(predict,named('predict'));

actual_predicted := RECORD
  unsigned id;
  real8 a_value;
  real8 p_value;
  real8 p_conf;
  real8 p_closest_conf;
END;

avp :=
   JOIN(flds(Number=5)
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
OUTPUT(SORT(avp,id),NAMED('actual_v_predict')); 
OUTPUT(COUNT(avp(a_value<>p_value)),NAMED('number_of_mismatches'));
OUTPUT(COUNT(avp)-COUNT(avp(a_value<>p_value)),NAMED('number_of_matches'));
OUTPUT(REALFORMAT((REAL)(COUNT(avp)-COUNT(avp(a_value<>p_value)))/(REAL)COUNT(avp),4,2),NAMED('proportion_correct'));

TestModule := C45Module.TestD(indep,dep);
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;