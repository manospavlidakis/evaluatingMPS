#!/usr/bin/env python3
 #######################################################
#       Find the avg of Iterations+Concurrent instances #
# Step1: Find the average of Nxconcurrent instances     #
# Step2: Find the average of Nxiterations               #
# In case of cifar add the two times and then do 1,2    #
 #######################################################
import optparse
import os
import fnmatch
from statistics import mean
# EG : ./find_avg.py -d 03_03_2022_jenna/ -b kernel_without_inout -c 1 

# Arguments
usage = "usage: %prog [options]"
parser = optparse.OptionParser(usage=usage)
parser.add_option("-d", "--directory", dest="dir", help="Provide directory (eg 02_24_2022_jenna/10epochs/mnist/)")
parser.add_option("-b", "--benchmark", dest="bench", help="Provide benchmark (eg mnist)")
parser.add_option("-c", "--concurrency", dest="concurrency", help="Provide concurrent instances (eg 2)")
parser.add_option("-m", "--mps", dest="mps", help="Provide if MPS is enabled")
(options, args) = parser.parse_args()

# Get the arguments
directory = options.dir
benchmark = options.bench
concurrent = options.concurrency
mps = options.mps
print("Directory of files: "+directory)
print("Concurrency: "+concurrent)
print("Benchmark: "+benchmark)
print("MPS: "+mps)

if (mps=="1"):
    # Array with all files in a dir
    files=[]
    for file in os.listdir(directory+"MPS/"+benchmark):
        #print(benchmark+'_stats_'+concurrent+'*.out')
        if fnmatch.fnmatch(file, benchmark+'_stats_'+concurrent+'*.out'):
            files.append(file)
            #print(file)

    #print(files)
    #Open files and calculate the average of the concurrent instances
    avg=[]                    
    add=[]        
    for i in files:
        #print(i)
        # Open the first file
        with open(directory+"MPS/"+benchmark+"/"+i, 'r') as f:
            data = f.read().split()
            floats = []
            # Calculate the AVG 
            for elem in data:
                try:
                    floats.append(float(elem))
                except ValueError:
                    pass
        #print("Float: "+str(floats)+" sum: "+str(add))
        avg.append(mean(floats))

    #print(avg)
    #print(mean(avg))
    avg=mean(avg)

    with open("AVG_MPS_concurrency_"+concurrent+'.final', "a") as file_object:
        file_object.write(benchmark+": "+str(avg)+"\n")
    print("AVG MPS"+benchmark+" concurrency "+concurrent+": "+str(avg))
else:
    print ("NAtive!!!")
    # Array with all files in a dir
    files=[]
    for file in os.listdir(directory+"NATIVE/"+benchmark):
        #print(benchmark+'_stats_'+concurrent+'*.out')
        if fnmatch.fnmatch(file, benchmark+'_stats_'+concurrent+'*.out'):
            files.append(file)
            #print(file)

    #print(files)
    #Open files and calculate the average of the concurrent instances
    avg=[]                    
    add=[]        
    for i in files:
        #print(i)
        # Open the first file
        with open(directory+"NATIVE/"+benchmark+"/"+i, 'r') as f:
            data = f.read().split()
            floats = []
            # Calculate the AVG 
            for elem in data:
                try:
                    floats.append(float(elem))
                except ValueError:
                    pass
        #print("Float: "+str(floats)+" sum: "+str(add))
        avg.append(mean(floats))

    #print(avg)
    #print(mean(avg))
    avg=mean(avg)

    with open("AVG_NAT_concurrency_"+concurrent+'.final', "a") as file_object:
        file_object.write(benchmark+": "+str(avg)+"\n")
    print("AVG NATIVE "+benchmark+" concurrency "+concurrent+": "+str(avg))

