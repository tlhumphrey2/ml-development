EXPORT
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
