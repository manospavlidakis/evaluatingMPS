#!/bin/bash
############################# Setup ###############################
# Server: Jenna, 1xNUMA node, 16xcores, 0-7 Cores, 8-15 HyperThreads
# GPU Geforce RXT 2080 Ti, Driver 510.54, Cuda 11.6
# Optimal cores for GPU 0-15
# Taskset for Caffe 0-7
###################################################################
export smi_pid
function start_smi() {
    cd
    nvidia-smi --query-gpu=timestamp,name,pci.bus,pstate,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used,clocks.gr,clocks.sm,clocks.mem,clocks.video,power.draw,power.limit --format=csv -lms 100 > ~/smi_results/smi_stats.csv &
    smi_pid=$!
    echo "Start SMI" ${smi_pid}
    sleep 1
    cd -
}
function stop_smi() {
    echo "Stop SMI" ${smi_pid}
    kill -SIGINT ${smi_pid}
    sleep 10
}

if [ $# -eq 0 ]
then
    echo "1st param: 1 for MPS, 0 for Native"
    echo "2nd param: 1 for 1xconcurrent, 2 for 2xconcurrent, 4 for 4xconcurrent"
    exit
fi
MPS=$1

if [ $# -eq 0 ]
then
    exit
fi
iterations10Epochs=10
MPS=$1
concurrent_instances=$2

echo "Concurrency: "${concurrent_instances}

server=`echo $HOSTNAME |awk '{split($0,a,"."); print a[1]}'`
cdate=`date +'%m_%d_%Y'`
#echo ${cdate}
results=`echo ${cdate}`_${server}

mkdir -p ${results}
mkdir -p ${results}/MPS
mkdir -p ${results}/NATIVE

######### MPS ##########
if [ ${MPS} -eq 1 ]
then
    echo "--- START MPS ---"
    ./kernel_without_inout/start_mps.sh
fi


#### 1xConcurrent #####
if [ ${concurrent_instances} -eq 1 ]
then
    #Start SMI
    start_smi

    mkdir -p ${results}/kernel_without_inout/1concurrent
    path=${results}/kernel_without_inout/1concurrent
    for ((i=0; i<${iterations10Epochs};i++))
    do
        #runscript concurrent_instances, iteration
        ./kernel_without_inout/jenna_conf/execute.sh 1 ${i}
    done
    
    mv kernel_without_inout_stats_*.csv ${path}

    #Stop SMI
    stop_smi
    mv ~/smi_results/* ${path}

#### 2xConcurrent
elif [ ${concurrent_instances} -eq 2 ]
then
    #Start SMI
    start_smi

    mkdir -p ${results}/kernel_without_inout/2concurrent
    path=${results}/kernel_without_inout/2concurrent
    for ((i=0; i<${iterations10Epochs};i++))
    do
        ./kernel_without_inout/jenna_conf/execute.sh 2 ${i}
    done
    mv kernel_without_inout_stats_*.csv ${path}

    #Stop SMI
    stop_smi
    mv ~/smi_results/* ${path}

#### 4xConcurrent
else
    #Start SMI
    start_smi

    mkdir -p ${results}/kernel_without_inout/4concurrent
    path=${results}/kernel_without_inout/4concurrent
    for ((i=0; i<${iterations10Epochs};i++))
    do
        ./kernel_without_inout/jenna_conf/execute.sh 4 ${i}
        sleep 2
    done
    mv kernel_without_inout_stats_*.csv ${path}

    #Stop SMI
    stop_smi
    mv ~/smi_results/* ${path}
fi

if [ ${MPS} -eq 1 ]
then
    echo "--- STOP MPS ---"
     cp -rf ${results}/kernel_without_inout/ ${results}/MPS/
     rm -rf ${results}/kernel_without_inout
    ./kernel_without_inout/stop_mps.sh
else
    echo "--- Native ---"
    cp -rf ${results}/kernel_without_inout/ ${results}/NATIVE/
    rm -rf ${results}/kernel_without_inout
fi
