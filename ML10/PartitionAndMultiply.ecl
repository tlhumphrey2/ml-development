//PartitionAndMultiply.ecl
IMPORT * FROM ML;
IMPORT PBblas;
IMPORT PBblas.Tests;
IMPORT PBblas.Types;
IMPORT ML.DMAT;
IMPORT ML.Mat;
IMPORT ML10;

EXPORT
PartitionAndMultiply( a_cells, t_a_cells, nrows, ncols, fbrows, fbcols) := FUNCTIONMACRO

a_partition_map  := PBblas.Matrix_Map(nrows, ncols, fbrows, fbcols);
t_a_partition_map  := PBblas.Matrix_Map(ncols, nrows, fbcols, fbrows);
r_a_partition_map  := PBblas.Matrix_Map(nrows, nrows, fbrows, fbrows);
a1 := DMAT.Converted.FromCells(a_partition_map, a_cells);
t_a1 := DMAT.Converted.FromCells(t_a_partition_map, t_a_cells);

AxtA := 
   PBblas.PB_dgemm(FALSE
                   ,FALSE
                   ,1.0
                   ,a_partition_map, a1
                   ,t_a_partition_map, t_a1
                   ,r_a_partition_map
   );
//O:=OUTPUT(a1,ALL);
//O:=OUTPUT(COUNT(a1));
//return 	WHEN	(AxtA,O);
return 	AxtA;
ENDMACRO;
