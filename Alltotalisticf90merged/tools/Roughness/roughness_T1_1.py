import matplotlib.pyplot as plt
import numpy as np
import pickle
D = 1500
Lmax=D/2
h_list=[]
a=0
for i in np.arange(D):
    if np.remainder(i,10) == 0:
       a=1-a
    h_list.append(a)

h=np.asarray(h_list)
w1    = np.zeros(Lmax+1)
for L in np.arange(2,Lmax+1):
    std = 0.
    count=0

    i = 0
    start = Lmax/2 + i
    end   = Lmax/2 + i + L
    h_mean= h[start:end].mean()
    w1[L] = ( (h[start:end]-h_mean)*(h[start:end]-h_mean) ).sum()/L

w2    = np.zeros(Lmax+1)
for L in np.arange(2,Lmax+1):
    std = 0.
    count=0

    i=0

    start = Lmax/2 + i
    end   = Lmax/2 + i + L
    h_mean= h[start:end].mean()

    w2[L] = np.sqrt( ( (h[start:end]-h_mean)*(h[start:end]-h_mean) ).sum()/L )


#pickle.dump(w,open("output_T1_0.pkl","wb"))

fig=plt.figure(figsize=(10, 10))

ax1=plt.subplot(2, 1, 1)

plt.plot(h,     linewidth='2' )

ax1=plt.subplot(2, 1, 2)

plt.loglog(w1,     linewidth='2', label='Method a' )

plt.loglog(w2,     linewidth='2', label='Method b' )

plt.legend(loc='lower right')

#plt.show()

fileout="roughness_T1_1.png"
plt.savefig(fileout, bbox_inches='tight')
