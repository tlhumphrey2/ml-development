//ML10_Svd_UsageExampleFromMLReference.ecl
IMPORT * FROM ML;
A := 
   dataset([
            {1,1,2.0},
            {1,2,3.0},
            {1,3,4.0},
            {2,1,2.0},
            {2,2,3.0},
            {2,3,4.0},
            {3,1,2.0},
            {3,2,3.0}, 
            {3,3,4.0}
           ], ML.Mat.Types.Element
   );
OUTPUT(A,NAMED('A'));
U := ML.Mat.Svd(A).UComp;
OUTPUT(SORT(U,x,y),NAMED('U'));
S := ML.Mat.Svd(A).SComp;
OUTPUT(SORT(S,x,y),NAMED('S'));
V := ML.Mat.Svd(A).VComp;
OUTPUT(SORT(V,x,y),NAMED('V'));

tV := ML.Mat.Trans(V);

L := ML.Mat.MUL(U,S);
A_computed1 := ML.Mat.Mul(L,tV);
OUTPUT(SORT(A_computed1,x,y),NAMED('A_computed1'));

R := ML.Mat.MUL(S,tV);
A_computed2 := ML.Mat.Mul(U,R);
OUTPUT(SORT(A_computed2,x,y),NAMED('A_computed2'));
