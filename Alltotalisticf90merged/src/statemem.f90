module statemem
use latticemem
type state
INTEGER                               :: S                  ! size of the  State
INTEGER, allocatable, dimension(:)    :: ipopulation,ipop   ! state vectors
end type state
type(state),save                      :: CA_state1

contains

subroutine init_state(CA_dom,CA_state)
   implicit none
   type(domain) :: CA_dom
   type(state ) :: CA_state
   
   allocate(CA_state%ipopulation(0:CA_dom%S))
   allocate(CA_state%ipop(0:CA_dom%S))
! initialize 
  CA_state%ipopulation(:) = 0.
  CA_state%ipop(:)        = 0.

end subroutine
end module
