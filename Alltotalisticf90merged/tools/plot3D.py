import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from getFrames import *

CA_output=getFrames("../OUTPUT/sc_100_r0011_state.xyz")
for t,frame in enumerate(CA_output):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    xs=frame['x']
    ys=frame['y']
    zs=frame['z']
    ax.scatter(xs, ys, zs, c='r', marker='o',s=1000)
    my_title= 'FRAME: ' + str(t)
    ax.set_title(my_title)
    plt.show()
