# Parallel-Permuation-Cipher-Attack
 
It is a assumed that we know the plain text and the cipher text, and we need to find the key. In addition, it is also assumed that the key length does not exceed 8. The attack is a brute force attack which tries all the possible keys in parallel.
Thread i tries the i-th permutation and compares the original text with the cipher text. For example, for length 3, there would be working 6 = 3! threads in parallel.  

* Thread 1 : 1 2 3
* Thread 2 : 1 3 2
* Thread 3 : 2 1 3
* Thread 4 : 2 3 1
* Thread 5 : 3 2 1
* Thread 5 : 3 1 2

This list of permuatations is generated on the CPU and is then sent on the GPU. For each length we run n! threads active that brute force the key. 


The number of permutations of length n is excactly $n!$. Each thread then itereates on the text and checks if permuting that text with the key gives the cipher text. If it encounters a letter which doesnt match with the cipher text, then it stops.


```
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
```


