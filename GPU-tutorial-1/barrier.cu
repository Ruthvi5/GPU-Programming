#include <iostream>
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void barrierKernel(int *d_data)
{
    __shared__ int count;
    if (threadIdx.x == 0)
    {
        count = 0;
    }
    __syncthreads();
    int tid = threadIdx.x;
    printf("Thread %d: Before barrier\n", tid);
    atomicAdd(&count, 1);
    __syncthreads();
    printf("Thread %d: After barrier\n", tid);
}

int main()
{
    int n = 16;
    int size = n * sizeof(int);

    int *d_data;
    int *h_data;

    cudaMalloc((void **)&d_data, size);
    h_data = (int *)malloc(size);

    printf("Launching 1 block with %d threads\n\n", n);
    barrierKernel<<<1, n>>>(d_data);

    cudaDeviceSynchronize();
    cudaMemcpy(h_data,d_data,size,cudaMemcpyDeviceToHost);

    return 0;
}