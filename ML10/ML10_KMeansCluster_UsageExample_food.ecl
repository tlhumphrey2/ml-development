//KMeansCluster_UsageExample_food.ecl
IMPORT * FROM ML;
food_rec := RECORD
    integer  Food;
    integer  Energy;
    integer  Protein;
    integer  Fat;
    integer  Calcium;
    integer  Iron;
END;

// Translation of field Food's values: 
//      1 is 'BB'
//      2 is 'HR'
//      3 is 'BR'
//      4 is 'BS'
//      5 is 'BC'
//      6 is 'CB'
//      7 is 'CC'
//      8 is 'BH'
//      9 is 'LL'
//      10 is 'LS'
//      11 is 'HS'
//      12 is 'PR'
//      13 is 'PS'
//      14 is 'BT'
//      15 is 'VC'
//      16 is 'FB'
//      17 is 'AR'
//      18 is 'AC'
//      19 is 'TC'
//      20 is 'HF'
//      21 is 'MB'
//      22 is 'MC'
//      23 is 'PF'
//      24 is 'SC'
//      25 is 'DC'
//      26 is 'UC'
//      27 is 'RC'

d0:=DATASET([
            {1,340,20,28,9,2.6},
            {2,245,21,17,9,2.7},
            {3,420,15,39,7,2},
            {4,375,19,32,9,2.5},
            {5,180,22,10,17,3.7},
            {6,115,20,3,8,1.4},
            {7,170,25,7,12,1.5},
            {8,160,26,5,14,5.9},
            {9,265,20,20,9,2.6},
            {10,300,18,25,9,2.3},
            {11,340,20,28,9,2.5},
            {12,340,19,29,9,2.5},
            {13,355,19,30,9,2.4},
            {14,205,18,14,7,2.5},
            {15,185,23,9,9,2.7},
            {16,135,22,4,25,0.6},
            {17,70,11,1,82,6},
            {18,45,7,1,74,5.4},
            {19,90,14,2,38,0.8},
            {20,135,16,5,15,0.5},
            {21,200,19,13,5,1},
            {22,155,16,9,157,1.8},
            {23,195,16,11,14,1.3},
            {24,120,17,5,159,0.7},
            {25,180,22,9,367,2.5},
            {26,170,25,7,7,1.2},
            {27,110,23,1,98,2.6}
           ],food_rec);

food_variance:=
         TABLE(d0
               ,{
                 sdEnergy:=VARIANCE(GROUP,Energy)
                 ,sdProtein:=VARIANCE(GROUP,Protein)
                 ,sdFat:=VARIANCE(GROUP,Fat)
                 ,sdCalcium:=VARIANCE(GROUP,Calcium)
                 ,sdIron:=VARIANCE(GROUP,Iron)              
                }
         );

food_sd:=
    PROJECT(food_variance
            ,TRANSFORM(recordof(food_variance)
                       ,SELF.sdEnergy:=SQRT(LEFT.sdEnergy)
                       ,SELF.sdProtein:=SQRT(LEFT.sdProtein)
                       ,SELF.sdFat:=SQRT(LEFT.sdFat)
                       ,SELF.sdCalcium:=SQRT(LEFT.sdCalcium)
                       ,SELF.sdIron:=SQRT(LEFT.sdIron)
            )
    );
OUTPUT(food_sd,NAMED('food_sd'));

d:=PROJECT(d0
           ,TRANSFORM(recordof(d0)
                      ,SELF.Energy:=LEFT.Energy/food_sd[1].sdEnergy
                      ,SELF.Protein:=LEFT.Protein/food_sd[1].sdProtein
                      ,SELF.Fat:=LEFT.Fat/food_sd[1].sdFat
                      ,SELF.Calcium:=LEFT.Calcium/food_sd[1].sdCalcium
                      ,SELF.Iron:=LEFT.Iron/food_sd[1].sdIron
											,SELF:=LEFT
            )
   );
OUTPUT(d,NAMED('d'));

ML.ToField(d,dEntities);
dCentroidMatrix:=DATASET([
   {1,1,1,1,1,1},
   {2,2,2,2,2,2},
   {3,3,3,3,3,3},
   {4,4,4,4,4,4},
   {5,5,5,5,5,5}
],RECORDOF(d));
ML.ToField(dCentroidMatrix,dCentroids);

MyKMeans:=ML.Cluster.KMeans(dEntities,dCentroids,30,1.0);
OUTPUT(MyKMeans.AllResults,NAMED('AllResults'));
MyKMeansResult:=MyKMeans.Result();
OUTPUT(MyKMeansResult,NAMED('Result'));
OUTPUT(MyKMeans.Allegiance(5),NAMED('Allegiance'));
OUTPUT(SORT(MyKMeans.Allegiances(5),y,x),NAMED('Allegiances'));
OUTPUT(MyKMeans.Convergence,NAMED('Convergence'));
OUTPUT(MyKMeans.Delta(0),NAMED('Delta'));
OUTPUT(MyKMeans.DistanceDelta(0),NAMED('DistanceDelta'));

MyKMeans2:=ML.Cluster.KMeans(dEntities,MyKMeansResult,30);
OUTPUT(MyKMeans2.AllResults,NAMED('AllResults2'));
MyKMeansResult2:=MyKMeans2.Result();
OUTPUT(MyKMeansResult2,NAMED('Result2'));
OUTPUT(MyKMeans2.Allegiance(5),NAMED('Allegiance2'));
OUTPUT(SORT(MyKMeans2.Allegiances(5),y,x),NAMED('Allegiances2'));
OUTPUT(MyKMeans2.Convergence,NAMED('Convergence2'));
OUTPUT(MyKMeans2.Delta(0),NAMED('Delta2'));
OUTPUT(MyKMeans2.DistanceDelta(0),NAMED('DistanceDelta2'));
6