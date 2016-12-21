#!/usr/bin/python
import sys, getopt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import os

def main(argv):
   inputfile = 'inputrand.in'
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



   file_ext=inputfile.split(".")[-1]


   ndim = 2   

   f = open(inputfile, 'r')
       all_lines=[]

       for line in f:
            all_lines.append(line)
       
#       print all_lines[0]
#       print len(all_lines)
#       print ndim
   
       framelen = 7+ndim
       nframes=len(all_lines)/framelen
       print "nframes", nframes

       for i in range(nframes):
          volumefile.write(all_lines[i*framelen]);
          distribfile.write(all_lines[2+i*framelen]);
          averagefile.write(all_lines[4+i*framelen]);
          prep1 = " "
          prep1 = prep1.join(all_lines[7+i*framelen:10+i*framelen])
          prep1 = prep1.replace('\n'," ", 2)
#          ciao = all_lines[7+i*framelen]+all_lines[8+i*framelen]+all_lines[9+i*framelen]
#          ciao.remove('\n')
#          ciao = ciao.append(all_lines[7+i*framelen])
#          ciao = ciao.append(all_lines[8+i*framelen])
#          ciao = ciao.append(all_lines[9+i*framelen])
          standarddeviationfile.write(prep1);

#volumefile = open("volume.dat", "wb")
#distribfile = open("distrib.dat", "wb")
#   averagefile = open("average.dat", "wb")
#   standarddeviationfile = open("stddev.dat", "wb")

#   for t,frame in enumerate(CA_output):
#       fig = plt.figure()
#       ax = fig.add_subplot(111, projection='3d')
#       xs=frame['x']
#       ys=frame['y']
#       zs=frame['z']
#       ax.scatter(xs, ys, zs, c='r', marker='o',s=1000)
#       my_title= 'FRAME: ' + str(t)
#       ax.set_title(my_title)
#       plt.show()

if __name__ == "__main__":
   main(sys.argv[1:])
