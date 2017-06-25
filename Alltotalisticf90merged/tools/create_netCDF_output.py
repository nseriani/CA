import sys
from dump_netcdf2 import *

def main():
    # print command line arguments
    for i,arg in enumerate(sys.argv[1:]):
        if i == 0:
           L = int(arg)
        if i == 1:
           nT = int(arg)
        if i == 2:
           rule = arg
        if i > 2:
           raise TypeError(" max #arg = 1") 

    filename_rule_num = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/RULE/rule2D_'+ str(rule).zfill(4) + '.conv'
    rule_num          = np.loadtxt(filename_rule_num,skiprows=1).astype(int) # rule numb according to Wolfram Packard

    list_state_file = []
    list_state_surf_file = []

    for t in range(nT):
        file1 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/OUTPUT/sc_' + str(L).zfill(6) + '_r' + str(rule_num).zfill(15) + '_f' + str(t).zfill(6) + '_state.xy'
        list_state_file.append(file1)

    for t in range(nT):
        file2 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/OUTPUT/sc_' + str(L).zfill(6) + '_r' + str(rule_num).zfill(15) + '_f' + str(t).zfill(6) + '_state_surface.xy'
        list_state_surf_file.append(file2)

    file_out='../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/OUTPUT/sc_'+ str(L).zfill(6) + '_r' + str(rule_num).zfill(15) + '.nc'

    dump_netcdf(L,list_state_file,list_state_surf_file ,file_out)

if __name__ == "__main__":
    main()
