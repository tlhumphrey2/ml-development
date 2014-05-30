IMPORT * FROM $;
IMPORT ML,ML.TestML, ML.Types;

output(TestML.ChickWeight,named('CheckWeight'));
/* ChickWeight dataset RECORD
ChickWeightRec := RECORD
  unsigned weight;
  unsigned Time;
  unsigned Chick;
  unsigned Diet;
END;
*/
/* THE ABOVE RECORD LAYOUT LOOKS LIKE THE FOLLOWING:
EXPORT NumericField := RECORD
  t_RecordID id;
  t_FieldNumber number;
  t_FieldReal value;
  END;
*/

ml.ToField(TestML.ChickWeight,x);

CountValues  := RECORD
  x.number;
	x.value;
	unsigned value_count := count(group);
END;

y := table(x,CountValues, number, value );
output(y,named('y'));

CountNumberOfDifferentValues := RECORD
  y.number;
	unsigned diff_value_count := count(group);
END;

z := table(y,CountNumberOfDifferentValues, number );
output(z,named('z'));


F1 := ML.FieldAggregates(x);
//output(F1,named('F1'));

F1.Buckets(4);
F1.BucketRanges(4)



