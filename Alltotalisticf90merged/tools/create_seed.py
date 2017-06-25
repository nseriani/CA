import sys

def main():
    # print command line arguments
    for i,arg in enumerate(sys.argv[1:]):
        if i == 0:
           rule = arg
        if i == 1:
           L    = arg
        if i  > 1:
           raise TypeError(" max #arg = 1") 

    filename01 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/SEED/seed_'+ str(rule).zfill(4) + '.in'

    f01 = open(filename01,'wb')

    s1 = '   7               1) Number of atoms in the seed '
    f01.write(s1)
    f01.write("\n")

    s2 = '  sc    coord    1) Lattice type    2) Seed format((3D-)indices or coord coordinates) '
    f01.write(s2)
    f01.write("\n")

    s3 = '  manual '
    f01.write(s3)
    f01.write(" ")
    f01.write(str(int(L)/2)) # 
    f01.write(" ")
    f01.write(str(int(L)/2)) #
    f01.write(" ")
    f01.write("\n")

    s4 = ' -3.0   0.0 '
    f01.write(s4)
    f01.write("\n")

    s5 = ' -2.0   0.0 '
    f01.write(s5)
    f01.write("\n")

    s6 = ' -1.0   0.0 '
    f01.write(s6)
    f01.write("\n")

    s7 = ' 0.0   0.0 '
    f01.write(s7)
    f01.write("\n")

    s8 = ' 1.0   0.0 '
    f01.write(s8)
    f01.write("\n")

    s9 = ' 2.0   0.0 '
    f01.write(s9)
    f01.write("\n")

    s10 =' 3.0   0.0 '
    f01.write(s10)
    f01.write("\n")

    f01.close()

if __name__ == "__main__":
    main()
