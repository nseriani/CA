import os
import numpy as np
import matplotlib.pyplot as plt
from getFrames import *

filein='../OUTPUT/sc_002000_r000000000000746_state.xy'
base  =os.path.basename(filein)
filename, file_extension = os.path.splitext(base)

CA_output=getFrames(filein)

for t,frame in enumerate(CA_output):
    if t>298:
       fig = plt.figure()
       board=np.zeros((3000,3000))
       ax = fig.add_subplot(111)
       xs=frame['x']
       ys=frame['y']
       for p,pt in enumerate(xs):
           board[np.int(ys[p])-1,np.int(xs[p])-1]=1.
       ax.pcolor(board,cmap='Greys')
       my_title= 'FRAME: ' + str(t)
       ax.set_title(my_title)
       plt.axes().set_aspect('equal')
       fileout=filename + '_' + str(t).zfill(5) + '.png'
       print(fileout)
       fig.savefig(fileout,format='png',dpi=1800)
       plt.close(fig)
