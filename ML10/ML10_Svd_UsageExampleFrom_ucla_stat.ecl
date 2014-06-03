//ML10_Svd_UsageExampleFrom_ucla_stat.ecl
//http://www.ats.ucla.edu/stat/r/pages/svd_demos.htm
IMPORT * FROM ML;
a_rec := RECORD
   integer c1;
   integer c2;
   integer c3;
   integer c4;
END;

A0:=DATASET([
            {1,1,0,0},
            {1,1,0,0},
            {1,1,0,0},
            {1,0,1,0},
            {1,0,1,0},
            {1,0,1,0},
            {1,0,0,1},
            {1,0,0,1},
            {1,0,0,1}
           ], a_rec);
OUTPUT(A0,NAMED('A0'));

ML.AppendID(A0, rid, A);
OUTPUT(A,NAMED('A'));

ML.ToField(A,O);
OUTPUT(O,NAMED('O'));

X := ML.Types.ToMatrix(O);
OUTPUT(X,NAMED('X'));
OUTPUT(ML.Mat.Has(X).Stats,NAMED('X_dimensions'));

U := ML.Mat.Svd(X).UComp;
//OUTPUT(SORT(U,x,y),NAMED('U'));
OUTPUT(ML.Mat.Has(U).Stats,NAMED('U_dimensions'));

S := ML.Mat.Svd(X).SComp;
OUTPUT(SORT(S,x,y),NAMED('S'));
OUTPUT(ML.Mat.Has(S).Stats,NAMED('S_dimensions'));
V := ML.Mat.Svd(X).VComp;
//OUTPUT(SORT(V,x,y),NAMED('V'));
OUTPUT(ML.Mat.Has(V).Stats,NAMED('V_dimensions'));

tU := ML.Mat.Trans(U);
uI0 := ML.Mat.MUL(tU,U);
uI := 
  PROJECT(uI0
          ,TRANSFORM(recordof(uI0)
                     ,SELF.value:=
                         IF(LEFT.x=LEFT.y
                            ,LEFT.value
                            ,(REAL)REALFORMAT(LEFT.value,9,6)
                         )
                     ,SELF:=LEFT
           )
  );
OUTPUT(SORT(uI,x,y),NAMED('uI'));
tV := ML.Mat.Trans(V);
vI0 := ML.Mat.MUL(tV,V);
vI := 
  PROJECT(vI0
          ,TRANSFORM(recordof(vI0)
                     ,SELF.value:=
                         IF(LEFT.x=LEFT.y
                            ,LEFT.value
                            ,(REAL)REALFORMAT(LEFT.value,9,6)
                         )
                     ,SELF:=LEFT
           )
  );
OUTPUT(SORT(vI,x,y),NAMED('vI'));
