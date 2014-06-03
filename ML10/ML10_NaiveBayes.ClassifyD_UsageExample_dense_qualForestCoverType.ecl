//ML10_NaiveBayes.ClassifyD_UsageExample_dense_qualForestCoverType.ecl
IMPORT * FROM $;
IMPORT ML;
IMPORT ML10;

covtype_rec := ML10.covtype_rec;
qual_covtype_rec := ML10.qual_covtype_rec;

// The following dataset was created with string2numericForestCoverType.ecl
filename:='~thor::thumphrey::Numeric::ForestCoverType';
d := PROJECT(DATASET(filename,covtype_rec,THOR),TRANSFORM(qual_covtype_rec,SELF.rid:=COUNTER,SELF:=LEFT));
OUTPUT(COUNT(d),NAMED('c_d'));
OUTPUT(d,NAMED('d'));

train := d(rid<=11340);
test := d(rid>11340);

//ML.ToField(train,nf_train0);
//ML.ToField(test,nf_test0);
ML.ToField(train,nf_train);
OUTPUT(SORT(nf_train,id,number),NAMED('nf_train'));
ML.ToField(test,nf_test);
OUTPUT(SORT(nf_test,id,number),NAMED('nf_test'));

//nf_train := nf_train0(value<>0);
//nf_test := nf_test0(value<>0);


dnf_train := ML.Discretize.ByRounding(nf_train);
indep_dnf_train := dnf_train(Number<=44);
dep_dnf_train := dnf_train(Number=45);
dnf_test := ML.Discretize.ByRounding(nf_test);
indep_dnf_test := dnf_test(Number<=44);
dep_dnf_test := dnf_test(Number=45);

MyNaiveBayesRegression:=ML.Classify.NaiveBayes;
Model3 := MyNaiveBayesRegression.LearnD(indep_dnf_train,dep_dnf_train);
OUTPUT(COUNT(Model3),NAMED('c_Model3'));
OUTPUT(SORT(Model3,id,number),NAMED('Model3'));

predict:=MyNaiveBayesRegression.ClassifyD(indep_dnf_test,Model3) : PERSIST('thumphrey::dense_indep_dnf_test::predictions');
OUTPUT(predict,NAMED('predict'));

TestModule := MyNaiveBayesRegression.TestD(indep_dnf_test,dep_dnf_test);
TestModule.Raw;
TestModule.CrossAssignments;
TestModule.PrecisionByClass;
TestModule.Headline;

proportion_correct := ML10.calcProportionCorrect(dep_dnf_test,predict);
OUTPUT(proportion_correct,NAMED('proportion_correct'));
