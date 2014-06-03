//ML10_NaiveBayes.ClassifyD_UsageExample_ConceptCar_2.ecl
IMPORT * FROM $;
IMPORT ML;
IMPORT ML10;

car_rec := RECORD
    unsigned rid;
    unsigned buying;
    unsigned maint;
    unsigned doors;
    unsigned persons;
    unsigned lug_boot;
    unsigned safety;
    unsigned conceptcar;
END;

// The following dataset was created with string2numericConceptCarDS.ecl
filename:='~hthor::thumphrey::Numeric::ConceptCarsDS';
d0 := DATASET(filename,car_rec,THOR);
OUTPUT(d0,NAMED('d0'));

d:=ML10.randomize(d0);

d_train:=d(rid<=570);
d_test:=d(rid>570);

ML.ToField(d_train,flds0_train);
flds_train := ML.Discretize.ByRounding(flds0_train);
OUTPUT(flds_train,NAMED('flds_train'));

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(flds_train(Number<=6),flds_train(Number=7));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

ML.ToField(d_test,flds0_test);
flds_test := ML.Discretize.ByRounding(flds0_test);
OUTPUT(flds_test,NAMED('flds_test'));

predict:=MyNaiveBayesRegression.ClassifyD(flds_test(Number<=6),Model3);
OUTPUT(predict,NAMED('predict'));

proportion_correct := ML10.calcProportionCorrect(flds_test(Number=7),predict);
OUTPUT(proportion_correct,NAMED('proportion_correct'));
