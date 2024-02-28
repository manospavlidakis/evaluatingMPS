# evalutingMPS
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
