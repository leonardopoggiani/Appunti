#!/usr/bin/env python3
import sys
import time

#How to read bytes from a file
f= open("./to_be_decrypted/captured_ct.txt", "rb")
ct=list(f.read()) # lista di byte (1 per ogni carattere)

k0 = ct[0] ^ "F".encode("ASCII")[0] # k0 = 147
k1 = ct[1] ^ "r".encode("ASCII")[0] # k1 = 111
k2 = ct[2] ^ "o".encode("ASCII")[0] # k2 = 35

A = -1
C = -1

for i in range(2**8):
    for j in range(2**8):
        if (k1 == (i * k0 + j) % 256) and (k2 == (i * k1 + j) % 256):
            A = i
            C = j
            break

# adesso ho trovato A e C, quindi posso generare le chiavi successive
ki = k0
pt = []

for i in range(len(ct)):
    pt.append(ct[i] ^ ki)
    ki = (A * ki + C)%256

print(''.join([chr(x) for x in pt]))