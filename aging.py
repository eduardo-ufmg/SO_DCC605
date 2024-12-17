V = [0, 0, 0, 0]
R = [0b0111, 0b1011, 0b1010, 0b1101, 0b0010, 0b1010, 0b1100, 0b0001]
k = 8

for i in range(len(R)):
  for j in range(len(V)):
    V[j] = ((R[i] >> j & 1) << (k-1)) | (V[j] >> 1)
    print(f'{V[j]:08b}', end=' ')
  print()
