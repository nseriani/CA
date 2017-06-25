import netCDF4 as NC
import numpy  as np
import pickle

NCin = NC.Dataset("../sc_001600_r000000000262074_state_FIBONACCI_MIXED_4.nc","r")
x    = NCin.dimensions['x'].size
y    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size
W  = []
Ht = []
for t in np.arange(10,frame,2):
    print(str(t))
    surf = NCin.variables['surf'][t,:,:]
    h_in,x_in  = np.where(surf > 0.5)


    idx_x_in = np.argsort(x_in)

    x    = x_in[idx_x_in]
    h    = h_in[idx_x_in]

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
    Ht.append(h[Lmax/2:Lmax/2+Lmax].mean()) 

pickle.dump(W,open("sc_W_001600_r000000000262074_state_FIBONACCI_MIXED_4.pkl","wb"))
pickle.dump(Ht,open("sc_Ht_001600_r000000000262074_state_FIBONACCI_MIXED_4.pkl","wb"))
