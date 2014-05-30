IMPORT PBblas;
IMPORT ML;
IMPORT ML.MAT;

EXPORT
cnvt := MODULE

EXPORT
NumericField2CellMatrix( DATASET(ML.Types.NumericField) x, unsigned nrows, unsigned ncols ) := FUNCTION
  
  PBblas.Types.Layout_Cell convert2CellMatrix(ML.Types.NumericField L, unsigned c, unsigned nrows, unsigned ncols) := TRANSFORM
    m:= c % ncols;
    real q := (c/ncols)+1;
    BOOLEAN isInteger := REGEXFIND('\\.0',REALFORMAT(q,8,1));

    SELF.x:=
      IF(isInteger,((integer)q)-1
    	   ,(integer)q
    	);
    SELF.y:= IF(m=0,ncols,m);
    SELF.v:=L.value;
  END;
  
  a_matrix:= PROJECT(x,convert2CellMatrix(LEFT,COUNTER, nrows, ncols));
return a_matrix;
END;

EXPORT
Element2Cell( DATASET(ML.Mat.Types.Element) x ) := FUNCTION
  y:=
     PROJECT(x
             ,TRANSFORM(PBblas.Types.Layout_Cell
                        ,SELF.x:=LEFT.x
                        ,SELF.y:=LEFT.y
                        ,SELF.v:=LEFT.value
              )
     );
return y;
END;

EXPORT
Cell2Element( DATASET(PBblas.Types.Layout_Cell) x ) := FUNCTION
  y:=
     PROJECT(x
             ,TRANSFORM(ML.Mat.Types.Element
                        ,SELF.x:=LEFT.x
                        ,SELF.y:=LEFT.y
                        ,SELF.value:=LEFT.v
              )
     );
return y;
END;

END;

