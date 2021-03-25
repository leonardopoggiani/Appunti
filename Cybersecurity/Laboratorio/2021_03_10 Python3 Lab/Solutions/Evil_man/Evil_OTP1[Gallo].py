#!/usr/bin/env python3
import sys
import random

#How to read bytes from a file
f= open("./to_be_decrypted/deepest_secrets.txt", "rb")
ct=list(f.read()) # lista di byte (1 per ogni carattere)

"""
il messaggio è stato cifrato nel seguente modo:
    ct = [m ^ k for (m, k) in zip(msg + seed_enc, key + [0x88]*len(seed_enc))]

la parte finale della chiave è semplicemente la ripetizione di 0x88 (= 136 in base 10)
possiamo sfruttare questa conoscenza per ottenere il valore del seed

nello specifico sappiamo che alla fine del messaggio troveremo un valore numerico, infatti
time.time() restituisce un numero float (compreso il carattere ".")

"""

seed = []
i = 0

for el in reversed(ct):
    if(i >= 17): # 17 sono i valori che vengono restituiti da time.time()
        break
    i += 1
    seed.append( el ^ 136 )

seed = float(''.join([chr(x) for x in seed[::-1]]))

# Adesso che ho trovato il seed posso sfruttarlo per ottenere il messaggio in chiaro

random.seed(seed)
seed_enc = str(seed).encode('ASCII')
key = [random.randrange(256) for _ in range(len(ct)-17)]

pt = [k ^ c for (k, c) in zip(key, ct)]
for i in range(len(pt)):
    pt[i] = chr(pt[i])

pt = ''.join(pt)

print(pt)