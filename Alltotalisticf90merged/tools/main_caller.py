from dump_netcdf2 import *

#sc_005000_r000000000000746_f000193_state.xy

list_file = []
L = 5000

for t in range(200):
    file = '../OUTPUT/sc_' + str(L).zfill(6) + '_r000000000000746_f' + str(t).zfill(6) + '_state.xy'
    list_file.append(file)

file_out='sc_005000_r000000000000746_state.nc'

dump_netcdf(L,list_file,file_out)
