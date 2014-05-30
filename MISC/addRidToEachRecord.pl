=pod

addRidToEachRecord.pl ChickWeight.ecl

ChickWeightRec := RECORD
  unsigned rid;
  unsigned weight;
  unsigned Time;
  unsigned Chick;
  unsigned Diet;
END;

EXPORT ChickWeight := dataset([
{42,0,1,1},
{51,2,1,1},
{59,4,1,1},
{64,6,1,1},
{76,8,1,1},
=cut

$n = 0;

while(<>){
   
   if ( /\{/ ){
      $n++;
      s/\{/\{$n,/;
   }
   
   print $_;
}