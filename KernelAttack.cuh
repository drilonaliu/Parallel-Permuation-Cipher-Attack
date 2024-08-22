#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void cudaAttack(char* text, char* encrypted, char* permutatedText, int* permutations,int permutationLength, int textLength);
__device__ void printSuccess(int* permutation, int permutationLength);
__device__ int f(int n);