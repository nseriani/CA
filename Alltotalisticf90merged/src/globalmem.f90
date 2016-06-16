!    This reads input files and initializes variables
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

module globalmem

       integer :: nstep, nprint

contains

subroutine init_global(filein,CA_dom, CA_state, CA_seed, CA_rule)
      use latticemem
      use nearneighbourmem
      use statemem
      use seedmem
      use rulemem
      implicit none
      character(30)        :: filein,seedfile, rulefile, neighbourhood 
      character(3)         :: latticetype,latticetyper
      integer              :: idimension,isize
      integer              :: nstep, nprint
      type(domain)         :: CA_dom
      type(seed  )         :: CA_seed
      type(state )         :: CA_state
      type(rule  )         :: CA_rule

      namelist /files/ seedfile, rulefile
      namelist /lattice/ idimension, latticetype, neighbourhood, isize
      namelist /steps/ nstep, nprint

!   Set some default values: 3 dimensions, simple cubic lattice, Moore's neighbourhood 
      CA_dom%latticetype   ='sc'
      CA_dom%neighbourhood = 'vonneumann'
      CA_dom%isize         = 100 

      nstep = 10
      nprint = 10

!    Read main input, with information on lattice, rule, number of iterations, output options 
      open(11,file=TRIM(filein))

      read(11,nml=files)

        CA_seed%seedfile     = seedfile 
        CA_rule%rulefile     = rulefile 

      read(11,nml=lattice)

        CA_dom%latticetype   = latticetype
        CA_dom%neighbourhood = neighbourhood
        CA_dom%isize         = isize

        write(*,*) 'Type of lattice:       ', CA_dom%latticetype
        write(*,*) 'Type of neighbourhood: ', CA_dom%neighbourhood

        if(idimension.ne.CA_dom%D) STOP 'Wrong dimension - check with value at compilation time'


      read(11,nml=steps)
      
      close(11)

      end subroutine
end module