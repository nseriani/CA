import numpy as np
import sys
#filein='sc_100_r0118_state.xyz'

def getFrames(filein):

   file_ext=filein.split(".")[-1]

   if   file_ext=='x': 
          site_type=np.dtype([('cell_type','S100'),('x', np.int)])
   elif file_ext=='xy':
          site_type=np.dtype([('cell_type','S100'),('x', np.int),('y', np.int)])
   elif file_ext=='xyz':
          site_type=np.dtype([('cell_type','S100'),('x', np.int),('y', np.int),('z', np.int)])
   elif file_ext=='xyzt':
          site_type=np.dtype([('cell_type','S100'),('x', np.int),('y', np.int),('z', np.int),('t', np.int)])
   else:
          sys.exit("File format not understood, put .x, .xy, .xyz, .xyzt !")

   f = open(filein, 'r')
   all_lines=[]

   for line in f:
       all_lines.append(line)

   for i in range(all_lines.count('\n')):
       all_lines.remove('\n')

   start = 1 
   end   = int(all_lines[0])+1
   all_frames=[]

   while start < len(all_lines):
        aux_list=[]
        for i in range(start,end): 
            aux_list.append(all_lines[i])
            start+=1
        all_frames.append(aux_list)
        if start >= len(all_lines):break
        end=int(all_lines[start])+start+1
        start+=1

   CA_output=[]

   for frame in all_frames:
       CA_output.append(np.loadtxt(frame,dtype=site_type))
     
   return CA_output
