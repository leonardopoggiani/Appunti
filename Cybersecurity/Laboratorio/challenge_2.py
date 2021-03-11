import pprint

if __name__ == '__main__':
    f = open("C:\\Users\Leonardo Poggiani\\Documents\\GitHub\\Appunti\\Cybersecurity"
             "\\Laboratorio\\2021_03_10 Python3 Lab\\Nuclear_threat\\Hard\\to_be_decrypted\\captured_ct.txt", "rb")
    ct = list(f.read())

    matrix = [[0 for x in range(4)] for y in range(0, 256)]

    for j in range(0, 4):
        for ki in range(0, 256):
            matrix[ki][j] = ki ^ ct[j]

    for i in range(0, 256):
        print(''.join([chr(a) for a in matrix[i]]))
        print("\n")
