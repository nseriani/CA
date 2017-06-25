import netCDF4 as NC
import numpy  as np
import matplotlib.pyplot as plt
import pickle

NCin = NC.Dataset("../prov.nc","r")
x    = NCin.dimensions['x'].size
y    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size


#W=pickle.load(open("output1.pkl","rb"))
W=pickle.load(open("output_radial.pkl","rb"))

timeseries10=[]
time10      =[]

for counter,element in enumerate(W):
    if len(element) >= 11:
        timeseries10.append(element[10])  
        time10.append(counter)

timeseries20=[]
time20      =[]

for counter,element in enumerate(W):
    if len(element) >= 21:
        timeseries20.append(element[20])  
        time20.append(counter)

timeseries30=[]
time30      =[]

for counter,element in enumerate(W):
    if len(element) >= 31:
        timeseries30.append(element[30])  
        time30.append(counter)

timeseries100=[]
time100      =[]

for counter,element in enumerate(W):
    if len(element) >= 101:
        timeseries100.append(element[100])
        time100.append(counter)

timeseries150=[]
time150      =[]

for counter,element in enumerate(W):
    if len(element) >= 151:
        timeseries150.append(element[150])
        time150.append(counter)

fig=plt.figure(figsize=(10, 10))

ax1=plt.subplot(2, 1, 1)
tt=np.arange(10,frame,2)
plt.plot(time10,timeseries10,label='L=10')
plt.plot(time20,timeseries20,label='L=20')
plt.plot(time30,timeseries30,label='L=30')
plt.plot(time100,timeseries100,label='L=100')
plt.plot(time150,timeseries150,label='L=150')
plt.xlabel('time')

legend =ax1.legend(loc='upper left')

ax1=plt.subplot(2, 1, 2)

plt.loglog(W[10],     linewidth='2',label='t=10'  )
plt.loglog(W[25/2],   linewidth='2',label='t=25'  )
plt.loglog(W[50/2],   linewidth='2',label='t=50'  )

ll=np.arange(2,1500)
plt.loglog(ll,np.sqrt(ll), label='P.L. -> 1/2',linewidth='4')
plt.loglog(ll,ll**(1./3.), label='P.L. -> 1/3',linewidth='4')
legend =ax1.legend(loc='lower right')

#plt.show()
fileout="roughness_circle_3.png"
plt.savefig(fileout, bbox_inches='tight')
