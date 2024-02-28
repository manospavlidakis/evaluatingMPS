# Gencode arguments
SMS ?= 70 75

# Generate SASS code for each SM architecture listed in $(SMS)
$(foreach sm,$(SMS),$(eval GENCODE_FLAGS += -gencode arch=compute_$(sm),code=sm_$(sm)))

# Generate PTX code from the highest SM architecture in $(SMS) to guarantee forward-compatibility
HIGHEST_SM := $(lastword $(sort $(SMS)))
GENCODE_FLAGS += -gencode arch=compute_$(HIGHEST_SM),code=compute_$(HIGHEST_SM) -lcublas -lcurand


#`pkg-config --list-all | grep cuda | grep -v 'cudart'| cut -f 1 -d ' '`
CUDA = /usr/local/cuda-11.6

CXXFLAGS = -O3 -std=c++11 -I./include
CUDAFLAGS = -I$(CUDA)/include
LDDFLAGS = -lrt -lpthread 

NVCC = $(CUDA)/bin/nvcc -ccbin $(CXX) 

all: kernel_without_inout

kernel_without_inout: kernel_without_inout.o
	$(NVCC) $(GENCODE_FLAGS) $(CXXFLAGS) $(LDDFLAGS) $^ -o $@  
kernel_without_inout.o: kernel_without_inout.cu
	$(NVCC) $(GENCODE_FLAGS) ${CXXFLAGS} -c $< -o $@
	
clean:
	-rm kernel_without_inout
	-rm  *.o
