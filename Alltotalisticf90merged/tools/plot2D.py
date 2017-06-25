import numpy as np
import matplotlib.pyplot as plt
from getFrames import *

CA_output=getFrames("../OUTPUT/sc_002000_r000000000000746_state.xy")
CA_output_s=getFrames("../OUTPUT/sc_002000_r000000000000746_state_surface.xy")
#CA_output=getFrames("../OUTPUT/sc_999_r000000000000224_state.xy")

for t,frame in enumerate(CA_output):
    frame_s=CA_output_s[t]
    fig = plt.figure()
    ax = fig.add_subplot(211)
    x=frame['x']
    y=frame['y']
    ax.scatter(x,   y, c='k', marker='o',s=10)
    my_title= 'FRAME: ' + str(t)
    ax.set_title(my_title)
    ax = fig.add_subplot(212)
    x=frame['x']
    y=frame['y']
    xs=frame_s['x']
    ys=frame_s['y']
    ax.scatter(x,   y, c='k', marker='o',s=10)
    ax.scatter(xs, ys, c='r', marker='d',s=40)
    my_title= 'FRAME: ' + str(t)
    ax.set_title(my_title)
    plt.show()
