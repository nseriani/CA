import netCDF4 as NC
import numpy  as np
import matplotlib.pyplot as plt
import pickle

NCin = NC.Dataset("../sc_010000_r000000000000746_state.nc","r")
x    = NCin.dimensions['x'].size
y    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size

nstep=500

#W=pickle.load(open("output1.pkl","rb"))
W=pickle.load(open("output_radial_10000_b.pkl","rb"))

timeseries20=[]
time20      =[]

for counter,element in enumerate(W):
    if len(element) >= 21:
        timeseries20.append(element[20])  
        time20.append(counter*nstep)

timeseries30=[]
time30      =[]

for counter,element in enumerate(W):
    if len(element) >= 31:
        timeseries30.append(element[30])  
        time30.append(counter*nstep)

timeseries60=[]
time60      =[]

for counter,element in enumerate(W):
    if len(element) >= 61:
        timeseries60.append(element[60])
        time60.append(counter*nstep)

timeseries120=[]
time120      =[]

for counter,element in enumerate(W):
    if len(element) >= 121:
        timeseries120.append(element[120])
        time120.append(counter*nstep)

timeseries180=[]
time180      =[]

for counter,element in enumerate(W):
    if len(element) >= 181:
        timeseries180.append(element[180])
        time180.append(counter*nstep)

timeseries240=[]
time240      =[]

for counter,element in enumerate(W):
    if len(element) >= 241:
        timeseries240.append(element[240])
        time240.append(counter*nstep)

timeseries300=[]
time300      =[]

for counter,element in enumerate(W):
    if len(element) >= 301:
        timeseries300.append(element[300])
        time300.append(counter*nstep)

timeseries358=[]
time358      =[]

for counter,element in enumerate(W):
    if len(element) >= 358:
        timeseries358.append(element[358])
        time358.append(counter*nstep)



fig=plt.figure(figsize=(10, 10))

ax1=plt.subplot(2, 3, 1)
#plt.plot(time10,timeseries10,label='a=10')
plt.plot(time20,timeseries20,label='a=20')
plt.plot(time30,timeseries30,label='a=30')
plt.plot(time60,timeseries60,label='a=60')
plt.plot(time120,timeseries120,label='a=120')
plt.plot(time180,timeseries180,label='a=180')
plt.plot(time240,timeseries240,label='a=240')
plt.plot(time300,timeseries300,label='a=300')

#plt.loglog(time10,timeseries10,label='a=10')
#plt.loglog(time20,timeseries20,label='a=20')
#plt.loglog(time30,timeseries30,label='a=30')
#plt.loglog(time60,timeseries60,label='a=60')
#plt.loglog(time120,timeseries120,label='a=120')
#plt.loglog(time180,timeseries180,label='a=180')
#plt.loglog(time240,timeseries240,label='a=240')
#plt.loglog(time300,timeseries300,label='a=300')
#plt.loglog(time358,timeseries358,label='a=358')
ll=np.arange(500,10000)
plt.loglog(ll,ll, label='P.L. -> 1',linewidth='4')
plt.loglog(ll,np.sqrt(ll), label='P.L. -> 1/2',linewidth='4')
plt.loglog(ll,ll**(1./3.), label='P.L. -> 1/3',linewidth='4')
plt.xlabel('time')

#legend =ax1.legend(loc='upper left')
#legend =ax1.legend(loc='lower right')

#plt.show()
fileout="roughness_circle_10000_b.png"
plt.savefig(fileout, bbox_inches='tight')
