#!/usr/bin/python
import sys, getopt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from getFrames import *

def main(argv):
   inputfile = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:",["ifile="])
   except getopt.GetoptError:
      print 'plot3D.py -i <inputfile>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'plot3D.py -i <inputfile>'
         sys.exit()
      elif opt in ("-i", "--ifile"):
         inputfile = arg
   print 'Input file is "', inputfile

   CA_output=getFrames(inputfile)

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

if __name__ == "__main__":
   main(sys.argv[1:])
