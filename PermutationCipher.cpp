#include "PermutationCipher.h"

/*
If text is not a multiple of key, we add the symbol " ` " until
the last block is a multiple of the text.
When we decrypt, we remove the paddSymbol
*/
char paddSymbol = '`';

/*
* Encrypts a text using the permutation cipher.
*
* @param text - plain text.
* @param permutation - key.
* @param permutationLength - length of permutation.
*
* @return encrypted text.
*
*/
string permutationEncrypt(string text, int* permutation, int permutationLength) {
	int m = text.length() % permutationLength;
	//Add the padd symbol if padding is needed.
	if (m != 0) {
		int padding = permutationLength - m;
		for (int i = 0; i < padding; i++) {
			text += paddSymbol;
		}
	}
	string encryptedText = applyPermutation(text, permutation, permutationLength);
	return encryptedText;
}

/*
* Decrypts a text using the permutation cipher.
*
* @param text - encrypted text.
* @param permutation - key.
* @param permutationLength - length of permutation.
*
* @return decrypted text.
*
*/
string permutationDecrypt(string text, int* permutation, int permutationLength) {
	int* inv_permutation = getInversePermutation(permutation, permutationLength);
	string decryptedText = applyPermutation(text, inv_permutation, permutationLength);
	/*Check if padding was added by going to the last block.
	If it has the padding symbol, remove everything after it.*/
	for (int i = text.length() - permutationLength - 1; i < text.length(); i++) {
		char letter = decryptedText[i];;
		if (letter == paddSymbol) {
			decryptedText.erase(i);
			break;
		}
	}

	return decryptedText;
}


/*
* Applies any kind of permutation on a given text.
* Method used in both encryption and decryption.
*
* @return the permutated text
*/
string applyPermutation(string text, int* permutation, int permutationLength) {
	string permutatedText = text;
	for (int i = 0; i < text.length(); i++) {
		int p = permutation[i % permutationLength];
		int j = (i / permutationLength) * permutationLength + p;
		permutatedText[j] = text[i];
	}
	return permutatedText;
}

/*
* Calculates the inverse permutation for a given one.
*
* @return inversed permutation.
*/
int* getInversePermutation(int* permutation, int permutationLength) {
	int* inv_permutation = new int[permutationLength];
	for (int i = 0; i < permutationLength; i++) {
		inv_permutation[permutation[i]] = i;
	}
	return inv_permutation;
}