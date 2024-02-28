#!/bin/bash
# the following must be performed with root privilege
export CUDA_VISIBLE_DEVICES="0"
export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps 
export CUDA_MPS_LOG_DIRECTORY=/tmp/nvidia-log 
nvidia-cuda-mps-control -d

#nvidia-smi -i 2 -c EXCLUSIVE_PROCESS
#nvidia-cuda-mps-control -d
