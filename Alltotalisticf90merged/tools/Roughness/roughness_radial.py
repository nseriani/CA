import netCDF4 as NC
import numpy  as np
import pickle

from mpi4py import MPI

size = MPI.COMM_WORLD.Get_size()
rank = MPI.COMM_WORLD.Get_rank()
name = MPI.Get_processor_name()


NCin = NC.Dataset("../sc_005000_r000000000000746_state.nc","r")
n    = NCin.dimensions['x'].size
j    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size
W = []
T = []
for t in np.arange(0,frame):
#for t in np.arange(0,120):
    if t%size == rank :
       print(str(t))
       surf = NCin.variables['surf'][t,:,:]

       y_in,x_in  = np.where(surf > 0.5)

       x0CM       = x_in.mean()
       y0CM       = y_in.mean()

       x0         = n/2
       y0         = j/2

       xR        = x_in - x0
       yR        = y_in - y0

       h1         = np.sqrt ( xR*xR + yR*yR )
       a1         = np.angle( xR    + yR*1.0j, deg=True)

       idx        = np.argsort(a1)

       R          = h1[idx] 
       a          = a1[idx] 

       w          = np.zeros(360)

       for angle in np.arange(1,360):
           std = 0.
           count=0
           for i in np.arange(360-angle):
               start =  i
               end   =  i + angle 
        
               h_aux = []

               for pp,aa in enumerate(a): 
                  if (a[pp] > start) and (a[pp] < end): 
                      h_aux.append(R[pp])
                  if (a[pp] > end) : 
                      break

               size = len(h_aux)
               h = np.asarray(h_aux)

               h_mean= h.mean()

               std = std +  ( (h[:]-h_mean)*(h[:]-h_mean) ).sum()/size
#              std = std +  ( (h[:]-h_mean)*(h[:]-h_mean) ).sum()/angle
#              std = std + np.sqrt( ( (h[:]-h_mean)*(h[:]-h_mean) ).sum()/angle)

               count=count+1

           w[angle]  = np.sqrt( std/count )
#          w[angle]  = std/count

       W.append(w)
       T.append(t)

fileout = "output_radial_05000_b" + str(rank) + ".pkl"
pickle.dump(W,open(fileout,"wb"))

fileout = "output_radial_05000_b" + str(rank) + "time.pkl"
pickle.dump(T,open(fileout,"wb"))

