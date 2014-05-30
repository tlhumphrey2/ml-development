//ML10_RandomForestClassify_UsageExample_iris.ecl
IMPORT * FROM ML;
IrisDS:=ML.Tests.Deprecated.IrisPlantDS;
OUTPUT(IrisDS, NAMED('IrisDS'));
ToField(IrisDS, pr_IrisDS0);
OUTPUT(pr_IrisDS0, NAMED('pr_IrisDS0'));
pr_IrisDS:=PROJECT(pr_IrisDS0,TRANSFORM(recordof(pr_IrisDS0),SELF.value:=10*LEFT.value,SELF:=LEFT));
OUTPUT(pr_IrisDS, NAMED('pr_IrisDS'));
pr_indep:= pr_IrisDS(number>1);
OUTPUT(pr_indep, NAMED('pr_indep'));
pr_dep:= pr_IrisDS(number=1);
OUTPUT(pr_dep, NAMED('pr_dep'),ALL);
indepData := ML.Discretize.ByRounding(pr_indep);
depData := ML.Discretize.ByRounding(pr_dep);

// Using a small dataset to facilitate understanding of algorithm
OUTPUT(indepData, NAMED('indepData'), ALL);
OUTPUT(depData, NAMED('depData'), ALL);

run_randomForest(
                 DATASET(ML.Types.DiscreteField) IndepData,
                 DATASET(ML.Types.DiscreteField) DepData,
                 ntrees=50,
                 nfeatures=3,
                 maxdepth=10
                ) := FUNCTION
	 learner := Classify.RandomForest(ntrees, nfeatures, 1.0, maxdepth); // generating a random forest of 1 trees selecting 3 features for splits using impurity:=1.0 and max depth:= 10
   result := learner.learnd(IndepData, DepData); // model to use when classifying
   //OUTPUT(result,NAMED('result'), ALL); // group_id represent number of tree
   model:= learner.model(result);  // transforming model to a easier way to read it
   //OUTPUT(SORT(model, group_id,level, node_id, number),NAMED('model'), ALL); // group_id represent number of tree
   predicted_class:= learner.classifyD(IndepData, result); // classifying
   //OUTPUT(SORT(predicted_class,id), NAMED('predicted_class'), ALL); // conf show voting percentage
   performance:= Classify.Compare(depData, predicted_class);
   //OUTPUT(performance.CrossAssignments, NAMED('CrossAssignments'));

   actual_v_predicted_rec := RECORD
     unsigned id;
     unsigned number;
     real a_value;
     real e_value;
     real a_e_diff;
   END;

   actual_v_predicted :=
      JOIN(depData
           ,predicted_class
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
END;

proportion_correct_with_50trees := run_randomForest(indepData,depData);
OUTPUT(proportion_correct_with_50trees,NAMED('proportion_correct_with_50trees'));

proportion_correct_with_1trees := run_randomForest(indepData,depData,1);
OUTPUT(proportion_correct_with_1trees,NAMED('proportion_correct_with_1trees'));
