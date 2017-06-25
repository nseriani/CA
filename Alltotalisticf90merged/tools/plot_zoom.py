# Script to generate simple Cellular Automata
# from the book ANKS S Wolfram 2002 pg 55-56
# PL 13.VI.2015
 
import numpy as np
import matplotlib.pyplot as plt
import pickle
import netCDF4 as NC

NCin = NC.Dataset("prova.nc","r")
x    = NCin.dimensions['x'].size
y    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size

xmin = x/2 - 5
xmax = x/2 + 5

ymin = y/2 - 5
ymax = y/2 + 5

dat_in = NCin.variables['area'][5,:,:]
dat_in[y/2-1,x/2-1] = 2
dat_to_plot = dat_in[ymin:ymax,xmin:xmax]

print(dat_to_plot.shape)
 
plt.figure(figsize=(20, 20))

#plt.gca().xaxis.set_major_locator(plt.NullLocator()) # remove ticks and labels
#plt.gca().yaxis.set_major_locator(plt.NullLocator())
 
plt.pcolor(dat_to_plot, cmap='Greys')
    
plt.savefig('plot_zoom.png', format='png',dpi=900)
 
print 'EOB'
