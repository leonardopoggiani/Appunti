#!/usr/bin/env python3
import random
import sys
import time


def to_string(ct):
	res = ""
	for c in ct:
		res += chr(c)
	return res


f = open("./to_be_decrypted/deepest_secrets.txt", "rb")
ct = f.read()
f.close()

ks = 0x88
seed_size = 17
seed_enc = ct[-seed_size:]
seed_enc = [cs ^ ks for cs in seed_enc]
seed = float(to_string(seed_enc))

random.seed(seed)

msg = ct[0:len(ct)-seed_size]
key = [random.randrange(256) for _ in msg]

msg = [m ^ k for (m,k) in zip(msg, key)]
print(to_string(msg))