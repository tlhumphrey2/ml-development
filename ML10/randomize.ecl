EXPORT
randomize( ds ) := FUNCTIONMACRO
 ran_rec := RECORD
   REAL ran;
   ds
 END;
 
 return
 PROJECT(
      SORT(
           PROJECT(ds
                   ,TRANSFORM(ran_rec
                              ,SELF.ran:=RANDOM()
                              ,SELF := LEFT
                    )
           )
           ,ran
      )
      ,recordof(ds)
 );
ENDMACRO;
