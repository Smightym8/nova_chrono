#include "library.h"

#include <stdio.h>

void encryptAndDecrypt(char plainOrCiphertext[], int length, int key) {
    for (int i = 0; i < length; i++) {
        plainOrCiphertext[i] = (char)(plainOrCiphertext[i] ^ key);
    }
}