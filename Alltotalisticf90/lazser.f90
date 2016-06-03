!    This code performs cellular automata calculations
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      program lazser
      implicit none
!     implicit real*8(a-h,o-z)
      integer                     :: idimension, nneigh, irealsize, ictilde, icrule, nstep, nprint
      character(3)                :: latticetype
      character(10)               :: neighbourhood 
      character(10)               :: ruletype
      integer, dimension(1000000) :: ipopulation

      call init(idimension, latticetype, neighbourhood, nneigh,          & 
                irealsize, ruletype, ictilde, icrule, nstep, nprint, ipopulation)

      call cellular(neighbourhood, nneigh, irealsize, ruletype, ictilde, &
                    icrule, nstep, nprint, ipopulation)

      end
