import os
import numpy as np
import netCDF4 as NC
import matplotlib.pyplot as plt
from getFrames import *

L=5000

filein_surface='../OUTPUT/sc_005000_r000000000000746_state_surface.xy'
base  =os.path.basename(filein_surface)
filename, file_extension = os.path.splitext(base)

CA_output_surface=getFrames(filein_surface)

board =np.zeros((L,L))
boards=np.zeros((L,L))

ncOUT=NC.Dataset('sc_005000_r000000000000746_surf.nc',"w");

ncOUT.createDimension('x',L);
ncOUT.createDimension('y',L);
ncOUT.createDimension('t',len(CA_output_surface));

ncvar_s    = ncOUT.createVariable('surf','i1',('t', 'y', 'x'),zlib=True)  

for t,frame in enumerate(CA_output_surface):
       print(t)
       boards[:,:] = 0
       xs=frame['x']
       ys=frame['y']
       for p,pt in enumerate(xs):
           boards[np.int(ys[p])-1,np.int(xs[p])-1]=1.
       ncvar_s[t,:,:]=boards

ncOUT.close()
