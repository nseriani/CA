
import sys
import numpy as np

def main():
    # print command line arguments
    for i,arg in enumerate(sys.argv[1:]):
        if i == 0:
           rule = arg
        else:
           raise TypeError(" max #arg = 1") 

    aux = np.zeros(18).astype(int)
    filename01 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/RULE/rule2D_'+ str(rule).zfill(4) + '.in'
    filename02 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/RULE/rule2D_'+ str(rule).zfill(4) + '.conv'

    f01 = open(filename01,'wb')
    f02 = open(filename02,'wb')

    s1 = '  sc        Lattice type'
    f01.write(s1)
    f01.write("\n")

    s2 = '   outer2     Type of rule: generic, totalistic, outer (totalistic), outer2 (totalistic)'
    f01.write(s2)
    f01.write("\n")

#   Mapping first 256 rules
    rr = int(rule) % 256 
    a  = map(int,bin(rr)[2:].zfill(8)) # rule creator
 
#   write first row always 0
    f01.write(" ")
    f01.write(str(0)) # First entry --> no creation from vacuum
    aux[0] = 0        # First entry --> no creation from vacuum
    f01.write(" ")

    for i in range(8):
        f01.write(str(a[7-i]))
        aux[2*(i+1)]=a[7-i]
        f01.write(" ")
    f01.write(" site with 0 became 1")
    f01.write("\n")

#   write second row 
    f01.write(" ")
    if int(rule)/256 == 0:
       for i in range(9):
           f01.write(str(1))
           aux[2*i+1]=1
           f01.write(" ")
    else:
       for i in range(5):
           f01.write(str(1))
           aux[2*i+1]=1
           f01.write(" ")
       for i in range(5,9):
           f01.write(str(0))
           aux[2*i+1]=0
           f01.write(" ")

    f01.write(" site with 1 stay 1")
    f01.write("\n")

    f01.close()
  
    for i in range(18):
        f02.write(str(aux[i]))
        f02.write(" ")
    f02.write("\n")
    f02.write(str( sum(2**i for i, v in enumerate(aux) if v == 1)))
#   f02.write(str( sum(2**i for i, v in enumerate(reversed(aux)) if v == 1)))
    f02.close()

if __name__ == "__main__":
    main()
