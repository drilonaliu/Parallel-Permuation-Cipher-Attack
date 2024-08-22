#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <fstream>
#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

using namespace std;

void parallelAttackPermutationCipher(string text, string encryptedText);
int factorial(int n);
int* getAllPermutations(int permutationLength);