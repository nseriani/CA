import os
import numpy as np
import matplotlib.pyplot as plt
from getFrames import *

filein        ='../OUTPUT/sc_002000_r000000000000746_state.xy'
filein_surface='../OUTPUT/sc_002000_r000000000000746_state_surface.xy'
base  =os.path.basename(filein)
filename, file_extension = os.path.splitext(base)

CA_output        =getFrames(filein)
CA_output_surface=getFrames(filein_surface)

board =np.zeros((2000,2000))
boards=np.zeros((2000,2000))

for t,frame in enumerate(CA_output_surface):
       fig = plt.figure()
       ax = fig.add_subplot(111)
       x=CA_output[40]['x']
       y=CA_output[40]['y']
       xs=frame['x']
       ys=frame['y']
       for p,pt in enumerate(x):
           board[np.int(y[p])-1,np.int(x[p])-1]=1.
       for p,pt in enumerate(xs):
           boards[np.int(ys[p])-1,np.int(xs[p])-1]=1.
       ax.pcolor(board,cmap='Greys')
       ax.pcolor(boards,cmap='Reds')
       my_title= 'FRAME: ' + str(t)
       ax.set_title(my_title)
       plt.axes().set_aspect('equal')
       fileout=filename + '_' + str(t).zfill(5) + '.png'
       print(fileout)
       fig.savefig(fileout,format='png',dpi=3600)
       plt.close(fig)
