import numpy as np
import matplotlib.pyplot as plt
from getFrames import *

CA_output=getFrames("/home/nfs3/nseriani/work/Wulff/Cellular/MyCA/CA/Alltotalisticf90merged/Tests/2D/Moore/Fibonacci2/sc_000400_r000000000174766_state.xy")
for t,frame in enumerate(CA_output):
    fig = plt.figure()
    ax = fig.add_subplot(111)
    xs=frame['x']
    ys=frame['y']
    ax.scatter(xs, ys, c='r', marker='o',s=10)
    my_title= 'FRAME: ' + str(t)
    ax.set_title(my_title)
    plt.show()
