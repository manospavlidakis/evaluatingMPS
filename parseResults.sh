#!/bin/bash
if [ $# -eq 0 ]
then
    echo "1st param: Root dir (eg 2_24_2022_jenna/MPS)"
    echo "2th param: 1 for 1xconcurrent, 2 for 2xconcurrent, 4 for 4xconcurrent"
    echo "3th param: Add iterations"
    exit
fi

directory=$1
concurrency=$2
iterations=$3
echo ${iterations}
if [ -z ${iterations} ]
then
    echo "Please set iterations!!!"
    exit
fi

#MPS 
cd ${directory}/MPS/kernel_without_inout

for ((i=0; i<${iterations};i++))
do
    cat ${concurrency}concurrent/kernel_without_inout_stats_${i}_*.csv | grep "Elapsed time:" | awk '{print $3}' &> kernel_without_inout_stats_${concurrency}_iter-${i}.out
done
wait
cd -
#NAT
cd ${directory}/NATIVE/kernel_without_inout

for ((i=0; i<${iterations};i++))
do
    cat ${concurrency}concurrent/kernel_without_inout_stats_${i}_*.csv | grep "Elapsed time:" | awk '{print $3}' &> kernel_without_inout_stats_${concurrency}_iter-${i}.out
done
wait
