import numpy as np
import matplotlib.pyplot as plt
from getFrames import *

CA_output=getFrames("../OUTPUT/sc_000300_r000000000000746_state.xy")
#CA_output=getFrames("../OUTPUT/sc_999_r000000000000224_state.xy")

for t,frame in enumerate(CA_output):
    fig = plt.figure()
    ax = fig.add_subplot(111)
    xs=frame['x']
    ys=frame['y']
    ax.scatter(xs, ys, c='r', marker='o',s=10)
    my_title= 'FRAME: ' + str(t)
    ax.set_title(my_title)
    plt.show()
