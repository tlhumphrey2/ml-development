//KMeansCluster_UsageExample_cars.ecl
IMPORT * FROM ML;
car_rec := RECORD
    INTEGER	car_id;
    REAL	mpg;
    INTEGER	cyl;
    REAL	disp;
    INTEGER	hp;
    REAL	drat;
    REAL	wt;
    REAL	qsec;
    INTEGER	vs;
    INTEGER	am;
    INTEGER	gear;
    INTEGER	carb;
END;

// Translation of field car_id's values: 
//      1 is 'Z1'
//      2 is 'Z2'
//      3 is 'Dt'
//      4 is 'H1'
//      5 is 'H2'
//      6 is 'Va'
//      7 is 'Du'
//      8 is 'M1'
//      9 is 'M2'
//      10 is 'M3'
//      11 is 'M4'
//      12 is 'M5'
//      13 is 'M6'
//      14 is 'M7'
//      15 is 'Cd'
//      16 is 'Ln'
//      17 is 'Ch'
//      18 is 'F1'
//      19 is 'Ho'
//      20 is 'T1'
//      21 is 'T2'
//      22 is 'Do'
//      23 is 'AM'
//      24 is 'Ca'
//      25 is 'Po'
//      26 is 'F2'
//      27 is 'Pr'
//      28 is 'Lo'
//      29 is 'Fo'
//      30 is 'Fe'
//      31 is 'Ma'
//      32 is 'Vo'

d0:=DATASET([
            {1,21,6,160,110,3.9,2.62,16.46,0,1,4,4},
            {2,21,6,160,110,3.9,2.875,17.02,0,1,4,4},
            {3,22.8,4,108,93,3.85,2.32,18.61,1,1,4,1},
            {4,21.4,6,258,110,3.08,3.215,19.44,1,0,3,1},
            {5,18.7,8,360,175,3.15,3.44,17.02,0,0,3,2},
            {6,18.1,6,225,105,2.76,3.46,20.22,1,0,3,1},
            {7,14.3,8,360,245,3.21,3.57,15.84,0,0,3,4},
            {8,24.4,4,146.7,62,3.69,3.19,20,1,0,4,2},
            {9,22.8,4,140.8,95,3.92,3.15,22.9,1,0,4,2},
            {10,19.2,6,167.6,123,3.92,3.44,18.3,1,0,4,4},
            {11,17.8,6,167.6,123,3.92,3.44,18.9,1,0,4,4},
            {12,16.4,8,275.8,180,3.07,4.07,17.4,0,0,3,3},
            {13,17.3,8,275.8,180,3.07,3.73,17.6,0,0,3,3},
            {14,15.2,8,275.8,180,3.07,3.78,18,0,0,3,3},
            {15,10.4,8,472,205,2.93,5.25,17.98,0,0,3,4},
            {16,10.4,8,460,215,3,5.424,17.82,0,0,3,4},
            {17,14.7,8,440,230,3.23,5.345,17.42,0,0,3,4},
            {18,32.4,4,78.7,66,4.08,2.2,19.47,1,1,4,1},
            {19,30.4,4,75.7,52,4.93,1.615,18.52,1,1,4,2},
            {20,33.9,4,71.1,65,4.22,1.835,19.9,1,1,4,1},
            {21,21.5,4,120.1,97,3.7,2.465,20.01,1,0,3,1},
            {22,15.5,8,318,150,2.76,3.52,16.87,0,0,3,2},
            {23,15.2,8,304,150,3.15,3.435,17.3,0,0,3,2},
            {24,13.3,8,350,245,3.73,3.84,15.41,0,0,3,4},
            {25,19.2,8,400,175,3.08,3.845,17.05,0,0,3,2},
            {26,27.3,4,79,66,4.08,1.935,18.9,1,1,4,1},
            {27,26,4,120.3,91,4.43,2.14,16.7,0,1,5,2},
            {28,30.4,4,95.1,113,3.77,1.513,16.9,1,1,5,2},
            {29,15.8,8,351,264,4.22,3.17,14.5,0,1,5,4},
            {30,19.7,6,145,175,3.62,2.77,15.5,0,1,5,6},
            {31,15,8,301,335,3.54,3.57,14.6,0,1,5,8},
            {32,21.4,4,121,109,4.11,2.78,18.6,1,1,4,2}
           ],car_rec);

car_rec2 := RECORD
    INTEGER	car_id;
    REAL	mpg;
    REAL	disp;
    REAL	hp;
    REAL	drat;
    REAL	wt;
    REAL	qsec;
END;

d1 := PROJECT(d0,car_rec2);
OUTPUT(d1,NAMED('d1'));

car_ranges:=
         TABLE(d1
               ,{
                 range_mpg   := MAX(GROUP,mpg) - MIN(GROUP,mpg)
                 ,range_disp  := MAX(GROUP,disp) - MIN(GROUP,disp)
                 ,range_hp    := MAX(GROUP,hp) - MIN(GROUP,hp)
                 ,range_drat  := MAX(GROUP,drat) - MIN(GROUP,drat)
                 ,range_wt    := MAX(GROUP,wt) - MIN(GROUP,wt)
                 ,range_qsec  := MAX(GROUP,qsec) - MIN(GROUP,qsec)
                }
         );
OUTPUT(car_ranges,NAMED('car_ranges'));

d:=PROJECT(d1
           ,TRANSFORM(recordof(d1)
                      ,SELF.mpg :=LEFT.mpg/car_ranges[1].range_mpg
                      ,SELF.disp:=LEFT.disp/car_ranges[1].range_disp
                      ,SELF.hp  :=LEFT.hp/car_ranges[1].range_hp
                      ,SELF.drat:=LEFT.drat/car_ranges[1].range_drat
                      ,SELF.wt  :=LEFT.wt/car_ranges[1].range_wt
                      ,SELF.qsec:=LEFT.qsec/car_ranges[1].range_qsec
                      ,SELF:=LEFT
            )
   );
OUTPUT(d,NAMED('d'));

ML.ToField(d,dEntities);
OUTPUT(dEntities,NAMED('dEntities'));
dCentroidMatrix:=DATASET([
   {1,1,0,0,2,1,2},
   {2,1,0,0,2,0,2},
   {3,1,1,1,2,1,2},
   {4,1,1,1,1,1,2}
],RECORDOF(d));
/*
dCentroidMatrix:=DATASET([
   {1,1,1,1,2,1,2},
   {2,1,0,0,2,1,2},
   {3,1,1,1,1,1,2},
   {4,1,0,0,2,0,2}
],RECORDOF(d));
*/
/*
dCentroidMatrix:=DATASET([
   {1,1,1,1,1,1,1},
   {2,2,2,2,2,2,2},
   {3,3,3,3,3,3,3},
   {4,4,4,4,4,4,4}
],RECORDOF(d));
*/
/* THE CLUSTER CENTERS PRODUCED BY R's KMEANS WHEN RAN ON D.
dCentroidMatrix:=DATASET([
{1,0.9004255,0.3583936,0.3876325,1.775576,0.7427768,2.217857},
{2,0.7423168,0.7462099,0.5516294,1.392217,0.9231796,2.128307},
{3,1.2794326,0.2161387,0.2667845,1.959293,0.4789057,2.190278},
{4,0.5708207,0.9742365,0.8778395,1.570770,1.1019834,1.931463}
],RECORDOF(d));
*/
OUTPUT(dCentroidMatrix,NAMED('dCentroidMatrix'));
ML.ToField(dCentroidMatrix,dCentroids);
OUTPUT(dCentroids,NAMED('dCentroids'));
MyKMeans:=ML.Cluster.KMeans(dEntities,dCentroids,30,0.3);
OUTPUT(MyKMeans.AllResults,NAMED('AllResults'));
MyKMeansResult:=MyKMeans.Result();
OUTPUT(MyKMeansResult,NAMED('Result'));
ML.FromField(MyKMeansResult,car_rec2,car_rec2_MyKMeansResult,dEntities_Map);
OUTPUT(SORT(car_rec2_MyKMeansResult,car_id),NAMED('car_rec2_MyKMeansResult'));
OUTPUT(MyKMeans.Allegiance(5),NAMED('Allegiance'));
OUTPUT(SORT(MyKMeans.Allegiances(5),y,x),NAMED('Allegiances'));
OUTPUT(MyKMeans.Convergence,NAMED('Convergence'));
OUTPUT(MyKMeans.Delta(0),NAMED('Delta'));
OUTPUT(MyKMeans.DistanceDelta(0),NAMED('DistanceDelta'));
