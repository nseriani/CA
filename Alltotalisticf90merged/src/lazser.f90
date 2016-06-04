!    This code performs cellular automata calculations
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      program lazser
      use latticemem             
      implicit none
! Local variables
      integer                     :: idimension, nneigh, irealsize, ictilde, icrule, nstep, nprint
      character(3)                :: latticetype
      character(10)               :: neighbourhood 
      character(10)               :: ruletype
      integer, dimension(1000000) :: ipopulation

      call init(CA_dom1, ruletype, ictilde, icrule, nstep, nprint, ipopulation) 

      call cellular(neighbourhood, nneigh, irealsize, ruletype, ictilde, &
                    icrule, nstep, nprint, ipopulation)

      end
