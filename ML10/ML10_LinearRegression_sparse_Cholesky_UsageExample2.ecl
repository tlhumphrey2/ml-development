//UsageExample2_LinearRegression_sparse_Cholesky.ecl
IMPORT * FROM ML;
fpe_rec := RECORD
   string country;
   integer setting;
   integer effort;
   integer change;
END;

fpe:=DATASET([
               {'Bolivia',46,0,1},
               {'Brazil',74,0,10},
               {'Chile',89,16,29},
               {'Colombia',77,16,25},
               {'CostaRica',84,21,29},
               {'Cuba',89,15,40},
               {'DominicanRep',68,14,21},
               {'Ecuador',70,6,0},
               {'ElSalvador',60,13,13},
               {'Guatemala',55,9,4},
               {'Haiti',35,3,0},
               {'Honduras',51,7,7},
               {'Jamaica',87,23,21},
               {'Mexico',83,4,9},
               {'Nicaragua',68,0,7},
               {'Panama',84,19,22},
               {'Paraguay',74,3,6},
               {'Peru',73,0,2},
               {'TrinidadTobago',84,15,29},
               {'Venezuela',91,7,11}
             ], fpe_rec);
 

ML.ToField(project(fpe,TRANSFORM({unsigned rid,integer setting,integer effort,integer change},SELF.rid:=COUNTER,SELF:=LEFT)),o);
OUTPUT(SORT(o,id,number),NAMED('o'));
indep := O(Number IN [1,2]); // Pull out the indep
OUTPUT(indep,NAMED('indep'));
dep := O(Number IN [3]); // Pull out the dep
OUTPUT(dep,NAMED('dep'));
RegSparse := ML.Regression.Sparse.OLS_Cholesky(indep,dep);
OUTPUT(RegSparse);
sparse_my_modelY:=sort(RegSparse.modelY,id);
OUTPUT(sparse_my_modelY,NAMED('sparse_my_modelY'));
sparse_extapo_change:=sort(RegSparse.Extrapolated(indep),id);
OUTPUT(sparse_extapo_change,NAMED('sparse_extapo_change'));

actual_extrapo_rec := RECORD
  unsigned id;
  unsigned number;
  real a_value;
  real e_value;
  real a_e_diff;
END;

actual_extrapo :=
   JOIN(dep
        ,sparse_extapo_change
        ,LEFT.id=RIGHT.id
        ,TRANSFORM(actual_extrapo_rec
                   ,SELF.a_value:=LEFT.value
                   ,SELF.e_value:=RIGHT.value
                   ,SELF.a_e_diff := ABS(LEFT.value-RIGHT.value)
                   ,SELF:=LEFT
         )
   );
OUTPUT(actual_extrapo,NAMED('actual_extrapo')); 

avg_diff := SUM(actual_extrapo,a_e_diff)/COUNT(actual_extrapo);
OUTPUT(avg_diff,NAMED('avg_diff'));

my_rsquared := RegSparse.RSquared;
OUTPUT(my_rsquared,NAMED('my_rsquared'));

my_betas := RegSparse.Betas();
OUTPUT(my_betas,NAMED('my_betas'));
