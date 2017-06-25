import netCDF4 as NC
import numpy  as np
import pickle

NCin = NC.Dataset("../prov.nc","r")
x    = NCin.dimensions['x'].size
y    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size
W = []
#for t in np.arange(0,frame,50):
for t in np.arange(10,frame,2):
    print(str(t))
    surf = NCin.variables['surf'][t,:,:]
    x_in,h_in  = np.where(surf > 0.5)

    x0   = x_in.mean()
    h0   = h_in.mean()

    xmin = x_in.min()
    xmax = x_in.max()

    x_up = x_in[np.where(h_in>h0)] 
    h_up = h_in[np.where(h_in>h0)] 

    idx_x_up = np.argsort(x_up)

    x    = x_up[idx_x_up]
    h    = h_up[idx_x_up]

    xmin = x.min()
    xmax = x.max()

    Lmax = ( xmax - xmin )/2
    w    = np.zeros(Lmax+1)
    for L in np.arange(2,Lmax+1):
        std = 0.
        count=0
        for i in np.arange(Lmax-L+1):
            start = Lmax/2 + i
            end   = Lmax/2 + i + L
            h_mean= h[start:end].mean()
            std = std + np.sqrt( ( (h[start:end]-h_mean)*(h[start:end]-h_mean) ).sum()/L)
            count=count+1
        w[L]  = std/count
    W.append(w)

pickle.dump(W,open("output2.pkl","wb"))

