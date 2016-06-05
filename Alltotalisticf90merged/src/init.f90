!    This reads input files and initializes variables
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      subroutine init(CA_dom, CA_state, CA_seed, ruletype, ictilde, icrule, nstep, nprint) 
      use latticemem
      use nearneighbourmem
      use statemem
      use seedmem
      implicit none
      type(domain)         :: CA_dom
      type(seed  )         :: CA_seed
      type(state )         :: CA_state
      integer              :: irealsize, ictilde, icrule
!     Local variables
!     implicit real*8(a-h,o-z)
      integer              :: i,j
      integer              :: idimension, nneigh
      character(20)        :: seedfile, rulefile, neighbourhood 
      character(20)        :: ruletype
      character(3)         :: latticetype,latticetyper
      integer              :: isize,nseed
      integer              :: irule(2,30)
      integer              :: nstep, nprint

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
      open(11,file='input.dat')

      read(11,nml=files)

        CA_seed%seedfile     = seedfile 

      read(11,nml=lattice)

        CA_dom%latticetype   = latticetype
        CA_dom%neighbourhood = neighbourhood
        CA_dom%isize         = isize

        write(*,*) 'Type of lattice:       ', CA_dom%latticetype
        write(*,*) 'Type of neighbourhood: ', CA_dom%neighbourhood

        if(idimension.ne.CA_dom%D) STOP 'Wrong dimension - check&
                                   with value at compilation time'

!   Initailize the mapping 1D <--> ND and the corresponding nearneihgbour vector

      call allocate_dom(CA_dom)

      call compute_nearneighbour(CA_dom)

      read(11,nml=steps)

!   Initailize state

     call init_state(CA_dom,CA_state)  

!   Read and initialize the seed

      call init_seed(CA_dom,CA_state,CA_seed)

!   Read the rule
      open(12,file=rulefile)
      read(12,*) latticetyper
      read(12,*) ruletype
      write(*,*) 'From rule file: ',latticetyper,'  ', ruletype
      if(latticetyper.ne.latticetype) STOP 'Lattice from rulefile different from input lattice' 
      if(ruletype.eq.'outer') then 
         read(12,*) ictilde
      elseif(ruletype.eq.'outer2') then
!  irule(1,:): when the central site is empty
         read(12,*) irule(1,0:nneigh)
!  irule(2,:): when the central site is full
         read(12,*) irule(2,0:nneigh)
         ictilde = 0
!   This is the definition of C tilde from Packard and Wolfram, J Stat Phys 38, 901 (1985))
         do i=0,nneigh
           ictilde = ictilde + irule(1,i)*(2**(2*i+1))
           ictilde = ictilde + irule(2,i)*(2**(2*i))
         enddo
         write(*,*) ' Ctilde  ', ictilde
      elseif(ruletype.eq.'totalistic') then
         read(12,*) icrule
         STOP 'Non-outer totalistic rule not yet implemented!'
      else 
         STOP 'Generic rule not yet implemented!'
      endif
      close(12)
      return
      end
