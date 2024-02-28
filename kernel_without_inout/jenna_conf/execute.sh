#!/bin/bash
TIMEFORMAT='%3R'
if [ $# -eq 0 ]
then
    echo "1st parameter --> num of Concurrent instances"
    echo "2nd parameter --> iteration"
    exit
fi
concurrent=$1
iteration=$2
for ((i=0; i<${concurrent};i++))
do
    time taskset -c 4-7  ./kernel_without_inout/kernel_without_inout &>kernel_without_inout_stats_${iteration}_${i}.csv & 
done
wait
