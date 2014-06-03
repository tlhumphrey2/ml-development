//ML10_NaiveBayes.ClassifyD_UsageExample_sparse_qualForestCoverType.ecl
IMPORT * FROM $;
IMPORT ML;
IMPORT ML10;

dep_var:=55;

covtype_rec := RECORD
    unsigned  rid:=1;
    unsigned  Elevation;
    unsigned  Aspect;
    unsigned  Slope;
    unsigned  HDistance2Hydrology;
    unsigned  VDistance2Hydrology;
    unsigned  HDistance2Roadways;
    unsigned  Hillshade_9am;
    unsigned  Hillshade_Noon;
    unsigned  Hillshade_3pm;
    unsigned  HDistance2FirePoints;
    unsigned1 WildernessArea1;
    unsigned1 WildernessArea2;
    unsigned1 WildernessArea3;
    unsigned1 WildernessArea4;
    unsigned1 SoilType01;
    unsigned1 SoilType02;
    unsigned1 SoilType03;
    unsigned1 SoilType04;
    unsigned1 SoilType05;
    unsigned1 SoilType06;
    unsigned1 SoilType07;
    unsigned1 SoilType08;
    unsigned1 SoilType09;
    unsigned1 SoilType10;
    unsigned1 SoilType11;
    unsigned1 SoilType12;
    unsigned1 SoilType13;
    unsigned1 SoilType14;
    unsigned1 SoilType15;
    unsigned1 SoilType16;
    unsigned1 SoilType17;
    unsigned1 SoilType18;
    unsigned1 SoilType19;
    unsigned1 SoilType20;
    unsigned1 SoilType21;
    unsigned1 SoilType22;
    unsigned1 SoilType23;
    unsigned1 SoilType24;
    unsigned1 SoilType25;
    unsigned1 SoilType26;
    unsigned1 SoilType27;
    unsigned1 SoilType28;
    unsigned1 SoilType29;
    unsigned1 SoilType30;
    unsigned1 SoilType31;
    unsigned1 SoilType32;
    unsigned1 SoilType33;
    unsigned1 SoilType34;
    unsigned1 SoilType35;
    unsigned1 SoilType36;
    unsigned1 SoilType37;
    unsigned1 SoilType38;
    unsigned1 SoilType39;
    unsigned1 SoilType40;
    unsigned  CoverType;
END;

qual_covtype_rec := RECORD
    unsigned  rid:=1;
    unsigned1 WildernessArea1;
    unsigned1 WildernessArea2;
    unsigned1 WildernessArea3;
    unsigned1 WildernessArea4;
    unsigned1 SoilType01;
    unsigned1 SoilType02;
    unsigned1 SoilType03;
    unsigned1 SoilType04;
    unsigned1 SoilType05;
    unsigned1 SoilType06;
    unsigned1 SoilType07;
    unsigned1 SoilType08;
    unsigned1 SoilType09;
    unsigned1 SoilType10;
    unsigned1 SoilType11;
    unsigned1 SoilType12;
    unsigned1 SoilType13;
    unsigned1 SoilType14;
    unsigned1 SoilType15;
    unsigned1 SoilType16;
    unsigned1 SoilType17;
    unsigned1 SoilType18;
    unsigned1 SoilType19;
    unsigned1 SoilType20;
    unsigned1 SoilType21;
    unsigned1 SoilType22;
    unsigned1 SoilType23;
    unsigned1 SoilType24;
    unsigned1 SoilType25;
    unsigned1 SoilType26;
    unsigned1 SoilType27;
    unsigned1 SoilType28;
    unsigned1 SoilType29;
    unsigned1 SoilType30;
    unsigned1 SoilType31;
    unsigned1 SoilType32;
    unsigned1 SoilType33;
    unsigned1 SoilType34;
    unsigned1 SoilType35;
    unsigned1 SoilType36;
    unsigned1 SoilType37;
    unsigned1 SoilType38;
    unsigned1 SoilType39;
    unsigned1 SoilType40;
    unsigned  CoverType;
END;

calcProportionCorrect(actualDep, predictedDep) := FUNCTIONMACRO
   actual_v_predicted_rec := RECORD
     unsigned id;
     unsigned number;
     real a_value;
     real e_value;
     real a_e_diff;
   END;

   actual_v_predicted :=
      JOIN(actualDep
           ,predictedDep
           ,LEFT.id=RIGHT.id
           ,TRANSFORM(actual_v_predicted_rec
                      ,SELF.a_value:=LEFT.value
                      ,SELF.e_value:=RIGHT.value
                      ,SELF.a_e_diff := ABS(LEFT.value-RIGHT.value)
                      ,SELF:=LEFT
            )
      );
   //OUTPUT(actual_v_predicted,NAMED('actual_v_predicted'));

   proportion_error := COUNT(actual_v_predicted(a_value<>e_value))/COUNT(actual_v_predicted);
   //OUTPUT(proportion_error,NAMED('proportion_error'));
   proportion_correct := 1.0 - proportion_error;
   //OUTPUT(proportion_correct,NAMED('proportion_correct'));
   return proportion_correct;
ENDMACRO;

// The following dataset was created with string2numericForestCoverType.ecl
filename:='~thor::thumphrey::Numeric::ForestCoverType';
//d := PROJECT(DATASET(filename,covtype_rec,THOR),TRANSFORM(qual_covtype_rec,SELF.rid:=COUNTER,SELF:=LEFT));
d := DATASET(filename,covtype_rec,THOR);
OUTPUT(COUNT(d),NAMED('c_d'));
OUTPUT(d,NAMED('d'));

train := d(rid<=11340);
test := d(rid>11340);

ML.ToField(train,nf_train0);
ML.ToField(test,nf_test0);
OUTPUT(SORT(nf_train0,id,number),NAMED('nf_train0'));
OUTPUT(SORT(nf_test0,id,number),NAMED('nf_test0'));

nf_train := nf_train0((value<>0) or (number=dep_var));
nf_test := nf_test0((value<>0) or (number=dep_var));
//OUTPUT(SORT(nf_train,id,number),NAMED('nf_train'));
//OUTPUT(SORT(nf_test,id,number),NAMED('nf_test'));


dnf_train := ML.Discretize.ByRounding(nf_train);
indep_dnf_train := dnf_train(Number<dep_var);
dep_dnf_train := dnf_train(Number=dep_var);
dnf_test := ML.Discretize.ByRounding(nf_test);
indep_dnf_test := dnf_test(Number<dep_var);
dep_dnf_test := dnf_test(Number=dep_var);

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(indep_dnf_train,dep_dnf_train);
OUTPUT(COUNT(Model3),NAMED('c_Model3'));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

predict:=MyNaiveBayesRegression.ClassifyD(indep_dnf_test,Model3) : PERSIST('thumphrey::sparse_indep_dnf_test::predictions');
OUTPUT(predict,NAMED('predict'));

TestModule := MyNaiveBayesRegression.TestD(indep_dnf_test,dep_dnf_test);
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;

proportion_correct := calcProportionCorrect(dep_dnf_test,predict);
OUTPUT(proportion_correct,NAMED('proportion_correct'));
