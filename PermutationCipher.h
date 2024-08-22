#pragma once
#include <iostream>
using namespace std;


string permutationEncrypt(string text, int* permutation, int permutationLength);
string permutationDecrypt(string text, int* permutation, int permutationLength);
string applyPermutation(string text, int* permutation, int permutationLength);
int* getInversePermutation(int* permutation, int permutationLength);