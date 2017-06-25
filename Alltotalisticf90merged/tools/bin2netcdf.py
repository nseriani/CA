import os
import numpy as np
import netCDF4 as NC
import matplotlib.pyplot as plt
from getFrames import *

L=10000

filein        ='../OUTPUT/RADIAL_CLUSTER/sc_010000_r000000000000746_state.xy'
filein_surface='../OUTPUT/RADIAL_CLUSTER/sc_010000_r000000000000746_state_surface.xy'
base  =os.path.basename(filein)
filename, file_extension = os.path.splitext(base)

CA_output        =getFrames(filein)
CA_output_surface=getFrames(filein_surface)

board =np.zeros((L,L))
boards=np.zeros((L,L))

ncOUT=NC.Dataset('sc_010000_r000000000000746_radial_area.nc',"w");

ncOUT.createDimension('x',L);
ncOUT.createDimension('y',L);
ncOUT.createDimension('t',len(CA_output_surface));

#ncvar_s    = ncOUT.createVariable('surf','d',('t', 'y', 'x'))  
ncvar_a    = ncOUT.createVariable('area','d',('t', 'y', 'x'))

#for t,frame in enumerate(CA_output_surface):
#       print(t)
#       boards[:,:] = 0
#       xs=frame['x']
#       ys=frame['y']
#       for p,pt in enumerate(xs):
#           boards[np.int(ys[p])-1,np.int(xs[p])-1]=1.
#       ncvar_s[t,:,:]=boards

for t,frame in enumerate(CA_output):
       print(t)
       board[:,:] = 0
       x=frame['x']
       y=frame['y']
       for p,pt in enumerate(x):
           board[np.int(y[p])-1,np.int(x[p])-1]=1.
       ncvar_a[t,:,:]=board

ncOUT.close()
