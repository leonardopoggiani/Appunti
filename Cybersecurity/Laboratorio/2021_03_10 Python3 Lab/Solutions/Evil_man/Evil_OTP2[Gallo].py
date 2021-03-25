#!/usr/bin/env python3
import sys
import random

#How to read bytes from a file
f= open("./to_be_decrypted/deepest_secrets.txt", "rb")
ct=list(f.read()) 

seed = [el ^ 136 for el in (ct[::-1])[0:17]]
seed = float(''.join([chr(x) for x in seed[::-1]]))

random.seed(seed)
seed_enc = str(seed).encode('ASCII')
key = [random.randrange(256) for _ in range(len(ct)-17)]
pt = ''.join([chr(k ^ c) for (k, c) in zip(key, ct)])

print(pt)