# evalutingMPS

MPS has an open bug that we reported in NVIDIA Developer forum with id 3559606. The issue is that when running mulitple clients with MPS is slower than Native CUDA that used time-sharing.
Dir kernel\_without\_inout contains the microbenchmark that will run mulitple times to evaluate the performance improvement provided by MPS compared to Native.

## Compile
Use the Makefile in kernel\_without\_inout.

## Adjust the execute script
In the kernel\_without\_inout directory adjust the jenna\_conf/execute.sh. To find the optimal cores use nvidia-smi topo --matrix.
 
## Run
### 1st runConc.sh 
It takes as parameters MPS or No MPS and the concurrency.
 
### 2nd Manually
In the kernel\_without\_inout there are scripts for starting and stopping MPS. Then run multiple times the jenna\_conf/execute.sh. 

## Results
| Concurrent instances 	|     MPS     	|   NATIVE   	|
|:--------------------:	|:-----------:	|:----------:	|
|           1          	|   1786.074  	|  1784.629  	|
|           2          	|  1958.4375  	|  2218.039  	|
|           4          	| 10991.53675 	| 4412.19625 	|
