//ML10_NaiveBayes.ClassifyD_TestExample_sparse_ForestCoverType.ecl
IMPORT * FROM $;
IMPORT ML;
IMPORT ML10;


covtype_rec := ML10.covtype_rec;

// The following dataset was created with string2numericForestCoverType.ecl
filename:='~thor::thumphrey::Numeric::ForestCoverType';
d := PROJECT(ML10.randomize(DATASET(filename,covtype_rec,THOR)),TRANSFORM(covtype_rec,SELF.rid:=COUNTER,SELF:=LEFT));
OUTPUT(COUNT(d),NAMED('c_d'));
OUTPUT(d,NAMED('d'));

//train := d(rid<=11340);
//test := d(rid>11340);
train := d;
test := d;

ML.ToField(train,nf_train0);
ML.ToField(test,nf_test0);

nf_train := nf_train0(value<>0);
nf_test := nf_test0(value<>0);

dnf_train := ML.Discretize.ByRounding(nf_train);
indep_dnf_train := dnf_train(Number<=54);
dep_dnf_train := dnf_train(Number=55);
dnf_test := ML.Discretize.ByRounding(nf_test);
indep_dnf_test := dnf_test(Number<=54);
dep_dnf_test := dnf_test(Number=55);

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(indep_dnf_train,dep_dnf_train);
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
