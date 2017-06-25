import os
import numpy as np
import sys
import netCDF4 as NC


def get_data(filein):
   f = open(filein, 'r')
   f.seek(0)
   rLEN  = np.fromfile(f,dtype='int32',count=1)
   nINT  = rLEN/4
   f.seek(4)
   field = np.fromfile(f,dtype='int32',count=nINT)
   field = np.reshape(field,(2,nINT/2))
   f.close()
   return field

def dump_netcdf(L,liststateFilein, listsurfFilein,fileout):

   ncOUT=NC.Dataset(fileout,"w");

   ncOUT.createDimension('x',L);
   ncOUT.createDimension('y',L);
   ncOUT.createDimension('t',len(liststateFilein));
   ncvar_a    = ncOUT.createVariable('area','i1',('t', 'y', 'x'),zlib=True)
   ncvar_s    = ncOUT.createVariable('surf','i1',('t', 'y', 'x'),zlib=True)

   for t,filein in enumerate(liststateFilein):
       print('-->'+str(t))

       data_state_frame = get_data(filein)
       board =np.zeros((L,L))
  
       for p in range(data_state_frame.shape[1]):
           x = data_state_frame[0,p]
           y = data_state_frame[1,p]
           board[np.int(y)-1,np.int(x)-1]=1.

       ncvar_a[t,:,:]=board.astype('int8')

       data_surf_frame = get_data(listsurfFilein[t])
       board =np.zeros((L,L))
  
       for p in range(data_surf_frame.shape[1]):
           x = data_surf_frame[0,p]
           y = data_surf_frame[1,p]
           board[np.int(y)-1,np.int(x)-1]=1.

       ncvar_s[t,:,:]=board.astype('int8')

   ncOUT.close()
