!    This reads input files and initializes variables
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      subroutine init(idimension, latticetype, neighbourhood, nneigh,&
       irealsize, ruletype, ictilde, icrule, nstep, nprint, ipopulation) 
      implicit none
!     implicit real*8(a-h,o-z)
      integer           :: i,j
      integer           :: idimension, nneigh, irealsize, ictilde, icrule, nstep, nprint
      character(3)      :: latticetype, latticetypes, latticetyper
      character(10)     :: seedfile, rulefile, neighbourhood 
      character(10)     :: seedtype, ruletype
      integer           :: nseed,isize
      integer           :: ipopulation(1000000), index(100,3)
      integer           :: neighlist(1000000, 30), irule(2,30)
      namelist /files/ seedfile, rulefile
      namelist /lattice/ idimension, latticetype, neighbourhood, isize
      namelist /steps/ nstep, nprint

!   Set some default values: 3 dimensions, simple cubic lattice, Moore's neighbourhood 
      idimension = 3
      latticetype ='sc'
      neighbourhood = 'vonneumann'
      neighlist(:,:)=0
      isize = 100 
!       itotsize = isize**idimension    
      ipopulation(:)=0
      nstep = 10
      nprint = 10

!    Read main input, with information on lattice, rule, number of iterations, output options 
      open(11,file='input.dat')

      read(11,nml=files)
      read(11,nml=lattice)
      read(11,nml=steps)
      write(*,*) 'Type of lattice: ', latticetype
      write(*,*) 'Type of neighbourhood: ', neighbourhood
      if(idimension.ne.3) STOP 'Wrong dimension'
      if(latticetype.ne.'sc'.and.latticetype.ne.'fcc')   STOP 'Wrong lattice'
      if(neighbourhood.ne.'vonneumann'.and. neighbourhood.ne.'moore')    STOP 'Wrong neighbourhood'

      if(latticetype.eq.'sc'.and.neighbourhood.eq.'vonneumann') then
           irealsize=isize**idimension
           nneigh=6
           call scvonneumann(isize, neighlist)
!             do i =101,130
!                write(*,*) neighlist(i,:)
!                write(*,*)'------------------'
!             enddo
      elseif(latticetype.eq.'sc'.and.neighbourhood.eq.'moore') then
           irealsize=isize**idimension
           nneigh=26
           call scmoore(isize, neighlist)
!              do i =101,130
!                write(*,*) neighlist(i,:)
!                write(*,*)'------------------'
!              enddo
!       elseif(latticetype.eq.'fcc'.and.neighbourhood.eq.'vonneumann') then
!              irealsize=isize**idimension*WHAT?? 
      else
         STOP 'No neighbours for this lattice-neighbourhood'
      endif

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
