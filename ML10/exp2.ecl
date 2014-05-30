EXPORT exp2 := MODULE

  EXPORT layout := RECORD
     unsigned time;
     string wuid;
     unsigned nblocks;
     string matdims;
     string partitioning;
  END;

  EXPORT timings :=DATASET('~thor::thumphrey::multi_runs_different_nblocks_diff_dims', layout,THOR);
END;

