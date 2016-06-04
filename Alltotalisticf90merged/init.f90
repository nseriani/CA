!    This reads input files and initializes variables
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      subroutine init(CA_dom, ruletype, ictilde, icrule, nstep, nprint, ipopulation) 
      use latticemem
      use nearneighbourmem
      implicit none
      type(domain)      :: CA_dom
      integer           :: ipopulation(1000000), index(100,3)
      integer           :: idimension, nneigh, irealsize, ictilde, icrule, nstep, nprint
!     Local variables
!     implicit real*8(a-h,o-z)
      integer           :: i,j
      character(20)     :: seedfile, rulefile, neighbourhood 
      character(20)     :: seedtype, ruletype
      character(3)      :: latticetype, latticetypes, latticetyper
      integer           :: isize,nseed
      integer           :: irule(2,30)
      namelist /files/ seedfile, rulefile
      namelist /lattice/ idimension, latticetype, neighbourhood, isize
      namelist /steps/ nstep, nprint

!   Set some default values: 3 dimensions, simple cubic lattice, Moore's neighbourhood 
      CA_dom%latticetype   ='sc'
      CA_dom%neighbourhood = 'vonneumann'
      CA_dom%isize         = 100 

      ipopulation(:)=0
      nstep = 10
      nprint = 10

!    Read main input, with information on lattice, rule, number of iterations, output options 
      open(11,file='input.dat')

      read(11,nml=files)
      read(11,nml=lattice)

        CA_dom%latticetype   = latticetype
        CA_dom%neighbourhood = neighbourhood
        CA_dom%isize         = isize

        write(*,*) 'Type of lattice: ', CA_dom%latticetype
        write(*,*) 'Type of neighbourhood: ', CA_dom%neighbourhood

        if(idimension.ne.CA_dom%D) STOP 'Wrong dimension - check&
                                   with value at compilation time'

      call allocate_dom(CA_dom)

      call compute_nearneighbour(CA_dom)

      read(11,nml=steps)

!   Read and initialize the seed
      open(12,file=seedfile)
      read(12,*) nseed
      read(12,*) latticetypes, seedtype
      write(*,*) 'Number of atoms in the seed: ',nseed
      write(*,*) 'From seed file: ',latticetypes,'  ', seedtype
      if(latticetypes.ne.latticetype)  STOP 'Seed lattice different from input lattice'
      if(seedtype.eq.'indices') then
         do i =1, nseed
           read(12,*) index(i,1), index(i,2), index(i,3)
         enddo
!   Now use this to initialize the array...
         if(latticetypes.eq.'sc') then     
            do i =1, nseed    
              j = (index(i,1)-1)*isize
              j = (j+index(i,2)-1)*isize+index(i,3)
              ipopulation(j)=1           
            enddo   
         elseif(latticetypes.eq.'fcc') then
            STOP 'No way to put seed on fcc lattice yet'
         else
            STOP 'No way to put seed in this lattice'
         endif
      elseif(seedtype.eq.'xyz') then
         STOP 'seedtype = xyz not implemented yet'
      else
         STOP 'Wrong seedtype'
      endif
      close(12)
!   End of seed initialization
      
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
