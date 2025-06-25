import sys

n = sys.argv[1]
res = ""

for i in range(0, len(n)):
    res = res + chr(ord(n[i]) - i)

print(res)