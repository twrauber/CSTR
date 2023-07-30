

import numpy as np
import struct
import subprocess


'''
n = 100

np.random.seed(seed=1234)


for i in range(100):
    u = np.random.uniform(size=18)
    print('UNIFORM [0,1]:', u)
    
    g = np.random.normal(size=3)
    print('NORMAL (0,1):', g)
'''

DSEED = 1234    # Seed of the number generator
MAXSTEPS = 30    # Maximum number of performed simulation steps
fncfg = 'rand_deterministic.cfg'   # File name to write config for Fortran


with open(fncfg, mode='w') as f:
    f.write(str(DSEED)+'\n')
    f.write(str(MAXSTEPS)+'\n')
    f.close()

### External call to Fortran to generate the binary file with the random numbers
prog_fortran = 'rand_deterministic'
print('Running external Fortran random number generation: %s' % prog_fortran)
subprocess.run([prog_fortran]) 
#raise Exception()


# https://stackoverflow.com/questions/20006643/writing-out-a-binary-file-from-fortran-and-reading-in-c
# https://stackoverflow.com/questions/8710456/reading-a-binary-file-with-python
# https://docs.python.org/3/library/struct.html#struct.unpack
with open('rand_deterministic.bin', mode='rb') as f: # b is important -> binary
    data = f.read()
    f.close()

# Cut off first two headers, 4 bytes each
nbytes = len(data)
print('Number of bytes before skip=', nbytes, 'data=', data)
#data = data[8:]
nbytes = len(data)
print('Number of bytes=', nbytes)

# i = 0
# DSEED = struct.unpack('<d', data[8*i:8*i+8])[0]
# i += 1
# MAXSTEPS = struct.unpack('<d', data[8*i:8*i+8])[0]
# i += 1
# print('DSEED=', DSEED, 'MAXSTEPS=', MAXSTEPS)
# raise Exception()
#
#data = data[i*8:]

randbuf = np.zeros(MAXSTEPS*(18+3))
cnt = 0
for i in range(int(nbytes/8)):
    d = data[8*i:8*i+8]
    # print('d=', d)
    value = struct.unpack('<d', d)[0]
    randbuf[cnt] = value
    print('i=', i, 'value=', value)
    cnt += 1
print('cnt=', cnt)
print('randbuf=', randbuf)


#import array
#doubles_sequence = array.array('d', data)
#print(doubles_sequence, 'len=', len(doubles_sequence))

'''
d = 1.234
b = struct.pack('!d', d)
print('b=', b, 'len=', len(b))
d2, = struct.unpack('!d', b)
print('d2=', d2)


    
print(data, 'len=', len(data))


format = '!1d'
s = struct.calcsize(format)
print('calcsize=', s)
res = struct.iter_unpack(format, data)

#print('res=', res)
cnt = 0
for i in res:
    print(i)
    cnt += 1
print('cnt=', cnt)
'''