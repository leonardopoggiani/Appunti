#!/usr/bin/env python3
import sys
import time

#I seed my random generator
#A, C, and n are used in the libc! They MUST BE SECURE!
A=1103515245
C=12345
n=2**31

if __name__ == '__main__':
	k0=int(input("Insert shared-secret (k0): "))
	#Insert the message
	pt = input("Message to be encrypted: \n")
	if pt[0:6]!="From: ":
		print("For security reasons anonymous messages are not allowed!")
		exit()
	while len(pt)%4!=0:
		pt+=' '
	pt=pt.encode('ASCII')
	print(pt)
	ct=[]
	ki=(A*k0+C)%n
	print(ki)

	#Encrypt the message in 32-bit blocks! SUPER-SAFE!
	for i in range(int(len(pt)/4)):
		ki_b = [ki%256, (ki>>8)%256, (ki>>16)%256, (ki>>24)%256]
		print(f"chiave: {ki_b}")

		print(pt[i * 4:i * 4 + 4])

		for (a, b) in zip(ki_b, pt[i * 4:i * 4 + 4]):
			print(a)
			print(b)


		ct += [a^b for (a,b) in zip(ki_b,pt[i*4:i*4+4])]
		print(f"cypher:  {ct}")

		ki = (A*ki + C) % n
		print(f"next key {ki} ")

	#Write to file
	with open("captured_ct_v2.txt", "wb") as f:
		f.write(bytes(ct))
	#How to read bytes from a file
	#f= open("<filename>", "rb")
	#ct=list(f.read())