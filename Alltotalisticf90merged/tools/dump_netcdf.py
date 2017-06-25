import os
import numpy as np
import sys
import netCDF4 as NC

def dump_netcdf(filein):

   file_ext=filein.split(".")[-1]

   if   file_ext=='x': 
          site_type=np.dtype([('cell_type','S100'),('x', np.float)])
   elif file_ext=='xy':
          site_type=np.dtype([('cell_type','S100'),('x', np.float),('y', np.float)])
   elif file_ext=='xyz':
          site_type=np.dtype([('cell_type','S100'),('x', np.float),('y', np.float),('z', np.float)])
   elif file_ext=='xyzt':
          site_type=np.dtype([('cell_type','S100'),('x', np.float),('y', np.float),('z', np.float),('t', np.float)])
   else:
          sys.exit("File format not understood, put .x, .xy, .xyz, .xyzt !")


   f = open(filein, 'r')
   all_lines=[]

   for line in f:
       all_lines.append(line)

   L = 10000
   ncOUT=NC.Dataset('prova.nc',"w");

   ncOUT.createDimension('x',L);
   ncOUT.createDimension('y',L);
   ncOUT.createDimension('t',200);
   ncvar_a    = ncOUT.createVariable('area','i1',('t', 'y', 'x'),zlib=True)

   board =np.zeros((L,L))

   for i in range(all_lines.count('\n')):
       all_lines.remove('\n')

   start = 1 
   end   = int(all_lines[0])+1
   all_frames=[]

   t = 0
   while start < len(all_lines):
        frame=[]
        for i in range(start,end): 
            frame.append(all_lines[i])
            start+=1
        CA_output = np.loadtxt(frame,dtype=site_type)
#       Dump frame on netcdf       
        board[:,:] = 0
        x=CA_output['x']
        y=CA_output['y']

        for p,pt in enumerate(x):
            board[np.int(y[p])-1,np.int(x[p])-1]=1.
        ncvar_a[t,:,:]=board.astype('int8')
        t+= 1
        if t>199:break
        if start >= len(all_lines):break
        end=int(all_lines[start])+start+1
        start+=1
