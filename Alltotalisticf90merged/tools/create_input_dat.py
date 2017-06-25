import sys

def main():
    # print command line arguments
    for i,arg in enumerate(sys.argv[1:]):
        if i == 0:
           rule     = arg
        if i == 1:
           L        = arg
        if i == 2:
           nstep    = arg
        if i == 3:
           nprint   = arg
        if i == 4:
           ndiagno  = arg
        if i  > 4:
           raise TypeError(" max #arg = 5") 

    filename01 = '../ALL_TOTALISTIC_2D/' + str(rule).zfill(4) + '/bin/input.dat'

    f01 = open(filename01,'wb')

    s1 = '&files'
    f01.write(s1)
    f01.write("\n")

    s2 = '  seedfile=\'../SEED/seed_' + str(rule).zfill(4) + '.in\''
    f01.write(s2)

    f01.write("\n")

    s3 = '  rulefile=\'../RULE/rule2D_'+ str(rule).zfill(4) + '.in\''
    f01.write(s3)

    f01.write("\n")
    f01.write("/")

    f01.write("\n")
    f01.write('&lattice')

    f01.write("\n")
    f01.write(' idimension  = 2')

    f01.write("\n")
    f01.write(' latticetype = \'sc\'')

    f01.write("\n")
    f01.write(' neighbourhood=\'moore\'')

    f01.write("\n")
    s4 = '  isize =' + str(L)
    f01.write(s4)

    f01.write("\n")
    f01.write("/")

    f01.write("\n")
    f01.write('&steps')
    f01.write("\n")

    s5 = '  nstep = ' + str(nstep)
    f01.write(s5)
    f01.write("\n")

    s6 = '  nprint = ' + str(nprint)
    f01.write(s6)
    f01.write("\n")

    s7 = '  ndiagno = ' + str(ndiagno)
    f01.write(s7)
    f01.write("\n")
    f01.write("/")
    f01.write("\n")

    f01.close()

if __name__ == "__main__":
    main()
