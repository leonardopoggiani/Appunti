n = 256
def to_string(ct):
	res = ""
	for c in ct:
		res += chr(c)
	return res

def decrypt(pt,ki, A, C):
	ct = []
	for i in range(len(pt)):
		ct.append(ki ^ pt[i])
		ki = (A*ki + C)%n
	return ct

f = open("./to_be_decrypted/captured_ct.txt", "rb")
pt = f.read()
f.close()
k0 = pt[0] ^ ord('F')

for a in range(2,n):
	for c in range(2,n):
		re = decrypt(pt, k0, a,c)
		re = to_string(re)
		if re[0:6] == "From: ":
			print("A:" + str(a) + " C:" + str(c) + " message: "+ re + "\n")


