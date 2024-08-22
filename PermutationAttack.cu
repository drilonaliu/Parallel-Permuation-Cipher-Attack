#include "PermutationAttack.cuh"
#include "KernelAttack.cuh"

using namespace std;

void parallelAttackPermutationCipher(string text, string encryptedText) {

	//Original Text to char array
	char* text_arr = new char[text.length() + 1];
	strcpy(text_arr, text.c_str());
	int size = (text.length() + 1) * sizeof(char);

	//EncryptedText to charr array
	char* encrypted_arr = new char[encryptedText.length() + 1];
	strcpy(encrypted_arr, encryptedText.c_str());

	//Permutated Text
	char* permutated_arr = new char[text.length() + 1];

	//Device pointers
	char* d_text;
	char* d_encryptedText;
	char* d_permutatedText;
	int* d_permutations = 0;

	//Memory allocation
	cudaMalloc((void**)&d_text, size);
	cudaMalloc((void**)&d_encryptedText, size);
	cudaMalloc((void**)&d_permutatedText, size);

	//Memory copy
	cudaMemcpy(d_text, text_arr, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_encryptedText, encrypted_arr, size, cudaMemcpyHostToDevice);

	for (int permutationLength = 8; permutationLength <= 8; permutationLength++) {
		//Get all permutations
		int* permutations = getAllPermutations(permutationLength);

		//Allocate memory for permutations
		cudaMalloc((void**)&d_permutations, permutationLength * factorial(permutationLength) * sizeof(int));

		//Copy all 
		cudaMemcpy(d_permutations, permutations, permutationLength * factorial(permutationLength) * sizeof(int), cudaMemcpyHostToDevice);

		//Launch Kernel 
		int threads = 1024;
		int blocksPerThread = (int)ceil(factorial(permutationLength) *1.0/ 1024);
		cudaAttack << <blocksPerThread, threads>> > (d_text, d_encryptedText, d_permutatedText, d_permutations, permutationLength, text.length());

		//Wait for cuda to launch the next kernel
		cudaDeviceSynchronize();
	}
}


int factorial(int n) {
	int f = 1;
	for (int i = 1; i <= n; i++) {
		f = f * i;
	}
	return f;
}


int* getAllPermutations(int permutationLength) {
	int* allPermutations = new int[permutationLength * factorial(permutationLength)];
	vector<int> elements(permutationLength);
	for (int i = 0; i < permutationLength; i++) {
		elements[i] = i;
	}

	int counter = 0;
	do {
		for (int i = 0; i < permutationLength; i++) {
			allPermutations[permutationLength * counter + i] = elements[i];
		}
		counter += 1;
	} while (next_permutation(elements.begin(), elements.end()));

	return allPermutations;
}