import netCDF4 as NC
import numpy  as np
import pickle

NCin = NC.Dataset("../prov.nc","r")
n    = NCin.dimensions['x'].size
j    = NCin.dimensions['y'].size
frame= NCin.dimensions['t'].size
W = []
#for t in np.arange(0,frame,50):
for t in np.arange(10,200,2):
    print(str(t))
    surf = NCin.variables['surf'][t,:,:]

    x_in,y_in  = np.where(surf > 0.5)

    x0CM       = x_in.mean()
    y0CM       = y_in.mean()

    x0         = n/2
    y0         = j/2

    xR        = x_in - x0
    yR        = y_in - y0

    h1         = np.sqrt ( xR*xR + yR*yR )
    a1         = np.angle( xR    + yR*1.0j, deg=True)

    idx        = np.argsort(a1)

    R          = h1[idx] 
    a          = a1[idx] 

    w          = np.zeros(360)

    for angle in np.arange(1,360):

        std   = 0.
        count = 0

        R1    = R.tolist()

        a1    = a.tolist()

        p_rad1 = zip(R1,a1)

        p_rad2 = list(p_rad1)

        for i in np.arange(360-angle):

            start  = i

            end    = i + angle 
        
            h_aux  = []

            p_rad2= list(p_rad1)

            for pp,aa in enumerate(p_rad2): 
                if (aa[1] > start) and (aa[1] < end): 
                    h_aux.append(aa[0])
                    p_rad1.remove(aa)

            h      = np.asarray(h_aux)

            h_mean = h.mean()

            std    = std + np.sqrt( ( (h[:]-h_mean)*(h[:]-h_mean) ).sum()/angle)

            count  = count+1

        w[angle]   = std/count

    W.append(w)

pickle.dump(W,open("output_radial_1.pkl","wb"))

