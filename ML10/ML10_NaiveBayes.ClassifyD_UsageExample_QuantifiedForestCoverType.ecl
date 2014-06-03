//ML10_NaiveBayes.ClassifyD_UsageExample_QuantifiedForestCoverType.ecl
IMPORT * FROM $;
IMPORT ML;
IMPORT ML10;


covtype_quantified_rec := ML10.covtype_quantified_rec;

// The following dataset was created with string2numericForestCoverType.ecl
filename:='~thor::thumphrey::QuantifiedNumeric::ForestCoverType';
d := PROJECT(ML10.randomize(DATASET(filename,covtype_quantified_rec,THOR)),TRANSFORM(covtype_quantified_rec,SELF.rid:=COUNTER,SELF:=LEFT));
OUTPUT(COUNT(d),NAMED('c_d'));
OUTPUT(d,NAMED('d'));

//train := d(rid<=11340);
//test := d(rid>11340);
train := d;
test := d;

ML.ToField(train,nf_train);
OUTPUT(nf_train,NAMED('nf_train'));
ML.ToField(test,nf_test);

dnf_train := ML.Discretize.ByRounding(nf_train);
indep_dnf_train := dnf_train(Number<=12);
dep_dnf_train := dnf_train(Number=13);
dnf_test := ML.Discretize.ByRounding(nf_test);
indep_dnf_test := dnf_test(Number<=12);
dep_dnf_test := dnf_test(Number=13);

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(indep_dnf_train,dep_dnf_train);
OUTPUT(COUNT(Model3),NAMED('c_Model3'));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

predict:=MyNaiveBayesRegression.ClassifyD(indep_dnf_test,Model3);
OUTPUT(predict,NAMED('predict'));

TestModule := MyNaiveBayesRegression.TestD(indep_dnf_test,dep_dnf_test);
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;

proportion_correct := ML10.calcProportionCorrect(dep_dnf_test,predict);
OUTPUT(proportion_correct,NAMED('proportion_correct'));
