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

subroutine dump_state(CA_dom,CA_state)
use latticemem
implicit none
!local variables
type(domain)   :: CA_dom
type(state )   :: CA_state
integer        :: i
logical        :: isOccupied
character(len=1024)  :: filename
character(len=1024)  :: cube_side

write (cube_side, "(I3.3)") CA_dom%isize
filename =  TRIM(CA_dom%latticetype)//TRIM(cube_side)//'state.xyz'

OPEN(UNIT=333,FILE=TRIM(filename),FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")

    write(unit=333,FMT=*) sum(CA_state%ipopulation(:))
    write(unit=333,FMT=*) 

SELECT CASE (CA_dom%latticetype)

     CASE('hc')
         if ( allocated(examap))        deallocate(examap)
         if ( allocated(v_aux))         deallocate(v_aux)
         allocate(examap(CA_dom%S,2))
         allocate(v_aux(CA_dom%S))
         examap = 0.
         v_aux  = .FALSE.
         call create_exa(CA_dom,1,0.,0.)
         do i=1,CA_dom%S
             isOccupied = (CA_state%ipopulation(i) .EQ. 1)
             if (isOccupied) write(unit=333,FMT=*) 'Au', examap(i,1),examap(i,2), CA_dom%v1DtoND(i,3:CA_dom%D)
         enddo

     CASE DEFAULT
         do i=1,CA_dom%S
             isOccupied = (CA_state%ipopulation(i) .EQ. 1)
             if (isOccupied) write(unit=333,FMT=*) 'Au', CA_dom%v1DtoND(i,:)
         enddo

END SELECT

CLOSE(UNIT=333)

end subroutine
end module
