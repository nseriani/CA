import os
import numpy as np
import netCDF4 as NC
import matplotlib.pyplot as plt
from getFrames import *

filein        ='../OUTPUT/sc_002000_r000000000000746_state.xy'
filein_surface='../OUTPUT/sc_002000_r000000000000746_state_surface.xy'
base  =os.path.basename(filein)
filename, file_extension = os.path.splitext(base)

#CA_output        =getFrames(filein)
CA_output_surface=getFrames(filein_surface)

board =np.zeros((2000,2000))
boards=np.zeros((2000,2000))

ncOUT=NC.Dataset('prov.nc',"w");

ncOUT.createDimension('x',2000);
ncOUT.createDimension('y',2000);
ncOUT.createDimension('t',len(CA_output_surface));

ncvar_s    = ncOUT.createVariable('surf','d',('t', 'y', 'x'))  
ncvar_a    = ncOUT.createVariable('area','d',('t', 'y', 'x'))

for t,frame in enumerate(CA_output_surface):
       boards[:,:] = 0
       xs=frame['x']
       ys=frame['y']
       for p,pt in enumerate(xs):
           board[np.int(ys[p])-1,np.int(xs[p])-1]=1.
       for p,pt in enumerate(xs):
           boards[np.int(ys[p])-1,np.int(xs[p])-1]=1.
       ncvar_a[t,:,:]=board
       ncvar_s[t,:,:]=boards
ncOUT.close()
