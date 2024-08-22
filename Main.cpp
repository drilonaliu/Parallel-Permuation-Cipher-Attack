#include <iostream>
#include "PermutationCipher.h"
#include "PermutationAttack.cuh"
using namespace std;

int main(){

	const int permutationLength = 8;
	int permutation[permutationLength] = { 7,6,5,3,2,4,1,0};

	//Encryption of a string
	string text = "ABCDEFGH";
	string encrypted = permutationEncrypt(text, permutation, permutationLength);
	string decrypted = permutationDecrypt(encrypted, permutation, permutationLength);

	cout << "\nText: " + text
		<< "\nEncrypted " + encrypted
		<< "\nDecrypted: " + decrypted;

	//Find the key when you have the plain text and the encrypted text
	parallelAttackPermutationCipher(text, encrypted);
}

