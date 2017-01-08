#!/bin/bash

for iii in {21..420}
do 
   for jjj in {1..100}
   do
     head -n $jjj fort.$iii | tail -1 >> segmlength$jjj.dat
   done
done
