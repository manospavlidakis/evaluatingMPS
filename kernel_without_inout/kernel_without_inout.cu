#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cuda.h>                                                                                   
#include <cuda_runtime.h>                                                                           
#include <chrono>                                                                                   
#include <iostream> 

#define KERNELS 1000000

// # threadblocks
#define TBLOCKS 32
#define THREADS 16

//__global__ void memcpy_kernel_batch(int *dst, int *src, size_t n)
__global__ void memcpy_kernel_batch()
{
    for (int j = 0; j < 10000000; j++)
    {
        int id = blockDim.x * blockIdx.x + threadIdx.x;
        id++; 
   }
}


int main(int argc, char **argv)
{
    auto start = std::chrono::system_clock::now();
    for (int j = 0; j < KERNELS; j++)
        memcpy_kernel_batch<<<TBLOCKS, THREADS, 0, 0>>>();
    cudaDeviceSynchronize();
    auto end = std::chrono::system_clock::now();
    std::chrono::duration<double, std::milli> elapsed_milli = end - start;
    std::cerr<<"Elapsed time: "<<elapsed_milli.count()<<std::endl;
    return 0;
}
