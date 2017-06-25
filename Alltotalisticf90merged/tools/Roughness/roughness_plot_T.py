import netCDF4 as NC
import numpy  as np
import matplotlib.pyplot as plt
import pickle


w=pickle.load(open("output_T1_0.pkl","rb"))

fig=plt.figure(figsize=(10, 10))

ax1=plt.subplot(2, 1, 1)
plt.loglog(w,     linewidth='2' )

plt.show()
