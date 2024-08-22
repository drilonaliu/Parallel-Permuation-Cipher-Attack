//for __syncthreads()
#ifndef __CUDACC__ 
#define __CUDACC__
#endif
#include <device_functions.h>
#include "KernelAttack.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void cudaAttack(char* text, char* encrypted, char* permutatedText1, int* permutations, int permutationLength, int textLength) {

	int i = threadIdx.x + blockIdx.x * blockDim.x;
	int permutation[8];
	int m = i * permutationLength;
	int factorial = f(permutationLength);
	if (i < factorial) {
		char pT[8];
		//Fill the permutation array
		for (int k = 0; k < permutationLength; k++) {
			permutation[k] = permutations[m + k];
		}
		bool found = true;
		for (int c = 0; c < textLength; c++) {
			int p = permutation[c % permutationLength];
			int j = (c / permutationLength) * permutationLength + p;
			pT[j] = text[c];

			//Dont bother going through all the text if one character is not same as the plain text.
			if (!(pT[j] == encrypted[j])) {
				found = false;
				break;
			}
		}

		if (found) {
			printf("\n\nAttack is successful! Permutation is: ");
			for (int m = 0; m < permutationLength; m++) {
				printf("%d", permutation[m]);
			}
		}
	}
}

__device__ int f(int n) {
	int f = 1;
	for (int i = 1; i <= n; i++) {
		f = f * i;
	}
	return f;
}