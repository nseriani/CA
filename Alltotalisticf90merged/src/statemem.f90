module statemem
use latticemem
type state
INTEGER                               :: S                  ! size of the  State
INTEGER, allocatable, dimension(:)    :: ipopulation,ipop, ipopulation0   ! state vectors
end type state
type(state),save                      :: CA_state1
contains

subroutine init_state(CA_dom,CA_state)
   implicit none
   type(domain) :: CA_dom
   type(state ) :: CA_state
   
   allocate(CA_state%ipopulation(0:CA_dom%S))
   allocate(CA_state%ipop(0:CA_dom%S))
   allocate(CA_state%ipopulation0(0:CA_dom%S))
! initialize 
  CA_state%ipopulation(:) = 0.
  CA_state%ipop(:)        = 0.
  CA_state%ipopulation0(:) = 0.

end subroutine

subroutine dump_state(CA_dom,CA_state,CA_rule)
use latticemem
use rulemem
implicit none
type(domain)   :: CA_dom
type(state )   :: CA_state
type(rule  )   :: CA_rule
!local variables
integer        :: i
logical        :: isOccupied
logical        :: file_exist
character(len=1024)  :: filename
character(len=1024)  :: cube_side
character(len=1024)  :: rule_name
character(len=1024)  :: st_suffix ! state file suffix x,xy,xyz,xyzt,nD

SELECT CASE (CA_dom%D)
   CASE(1)
       st_suffix='x'
   CASE(2)
       st_suffix='xy'
   CASE(3)
       st_suffix='xyz'
   CASE(4)
       st_suffix='xyzt'
   CASE DEFAULT
       st_suffix='nD'
END SELECT

write (cube_side, "(I3.3)") CA_dom%isize
write (rule_name, "(I4.4)") CA_rule%icrule

filename =  '../OUTPUT/'//TRIM(CA_dom%latticetype)//'_'//TRIM(cube_side)//'_r'//TRIM(rule_name)//'_state.'//TRIM(st_suffix)

inquire(FILE=TRIM(filename),exist=file_exist)
if(file_exist) then
    OPEN(UNIT=333,FILE=TRIM(filename),FORM="FORMATTED",STATUS="OLD",POSITION="APPEND",ACTION="WRITE")
else
    OPEN(UNIT=333,FILE=TRIM(filename),FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
endif

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
