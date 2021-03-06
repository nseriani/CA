module statemem
use latticemem
type state
INTEGER                               :: S                  ! size of the  State
INTEGER, allocatable, dimension(:)    :: ipopulation,ipop, ipopulation0   ! state vectors
end type state

type(state),save                      :: CA_state1, CA_state_surf, CA_state_surf0

contains

subroutine init_state(CA_dom,CA_state)
   implicit none
   type(domain) :: CA_dom
   type(state ) :: CA_state
   
   if ( .NOT. allocated(CA_state%ipopulation))  allocate(CA_state%ipopulation(0:CA_dom%S))
   if ( .NOT. allocated(CA_state%ipop))         allocate(CA_state%ipop(0:CA_dom%S))
   if ( .NOT. allocated(CA_state%ipopulation0)) allocate(CA_state%ipopulation0(0:CA_dom%S))
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
character(len=100)  :: filename
character(len=1024)  :: cube_side
character(len=1024)  :: rule_name
character(len=10)    :: st_suffix ! state file suffix x,xy,xyz,xyzt,nD

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

write (cube_side, "(I6.6)") CA_dom%isize
write (rule_name, "(I15.15)") CA_rule%icrule

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

subroutine copy_state(CA_state_in,CA_state_out)
implicit none
type(state ), intent(in)   :: CA_state_in
type(state ), intent(inout):: CA_state_out

CA_state_out%S            = CA_state_in%S
CA_state_out%ipopulation  = CA_state_in%ipopulation
CA_state_out%ipop         = CA_state_in%ipop
CA_state_out%ipopulation0 = CA_state_in%ipopulation0

end subroutine

logical function compare_state(CA_dom, CA_state_in1,CA_state_in2)
implicit none
type(domain), intent(in)   :: CA_dom
type(state ), intent(in)   :: CA_state_in1, CA_state_in2
!local 
integer                    :: i        

do i =0, CA_dom%S            
   if (  CA_state_in1%ipopulation(i) .NE. CA_state_in2%ipopulation(i) ) then
    compare_state = .FALSE.
    return
   endif
enddo

compare_state = .TRUE.
return
end function

subroutine fill_state(CA_dom,CA_state_in)
use latticemem
use rulemem
implicit none
type(domain), intent(in)      :: CA_dom
type(state ), intent(inout)   :: CA_state_in

CA_state_in%ipop = CA_state_in%ipopulation

   SELECT CASE (TRIM(CA_dom%latticetype))

      CASE('sc')

           SELECT CASE (TRIM(CA_dom%neighbourhood))

              CASE('vonneumann')
                  call fill_state_sc_fn(CA_dom,CA_state_in)

              CASE('moore')
                  call fill_state_sc_mo(CA_dom,CA_state_in)

              CASE DEFAULT
                  write(*,*) 'Scheme: '//TRIM(CA_dom%latticetype)//'-'//TRIM(CA_dom%latticetype)//' not implemented'
                  STOP 

           END SELECT

      CASE('hc')

           SELECT CASE (TRIM(CA_dom%neighbourhood))

              CASE('vonneumann')
                  call fill_state_hc(CA_dom,CA_state_in)

              CASE DEFAULT
                  write(*,*) 'Scheme: '//TRIM(CA_dom%latticetype)//'-'//TRIM(CA_dom%latticetype)//' not implemented'
                  STOP 

           END SELECT
          
      CASE('fcc')

           SELECT CASE (TRIM(CA_dom%neighbourhood))

              CASE('vonneumann')
                  write(*,*) 'Scheme: '//TRIM(CA_dom%latticetype)//'-'//TRIM(CA_dom%latticetype)//' not implemented'
                  STOP 

              CASE DEFAULT
                  write(*,*) 'Scheme: '//TRIM(CA_dom%latticetype)//'-'//TRIM(CA_dom%latticetype)//' not implemented'
                  STOP 

           END SELECT

      CASE DEFAULT

           write(*,*) 'Lattice: '//TRIM(CA_dom%latticetype)//' not implemented' 
           STOP 
   END SELECT



end subroutine

subroutine fill_state_sc_fn(CA_dom,CA_state_in)
use latticemem
use rulemem
implicit none
type(domain), intent(in)      :: CA_dom
type(state ), intent(inout)   :: CA_state_in
!     Local variables
integer i,k
integer a,b

do i=1,CA_dom%S
   do k=1,CA_dom%nneigh,2

      a = CA_dom%neighlist(i,k)
      b = CA_dom%neighlist(i,k+1)

      if ( (CA_state_in%ipopulation(a).EQ.1) .AND. (CA_state_in%ipopulation(b).EQ.1)) then

         CA_state_in%ipop(i)=1
         exit 
      endif

   enddo
enddo

do i=1,CA_dom%S
   CA_state_in%ipopulation(i) = CA_state_in%ipop(i)
enddo  

end subroutine

subroutine fill_state_sc_mo(CA_dom,CA_state_in)
use latticemem
use rulemem
implicit none
type(domain), intent(in)      :: CA_dom
type(state ), intent(inout)   :: CA_state_in
!     Local variables
integer i,k
integer a,b

do i=1,CA_dom%S
   do k=1,CA_dom%nneigh/2

      a = CA_dom%neighlist(i,k)
      b = CA_dom%neighlist(i,CA_dom%nneigh+1-k)

      if ( (CA_state_in%ipopulation(a) .EQ. 1) .AND. ( CA_state_in%ipopulation(b) .EQ.  1) ) then
         CA_state_in%ipop(i)=1
         exit
      endif

   enddo
enddo

do i=1,CA_dom%S
   CA_state_in%ipopulation(i) = CA_state_in%ipop(i)
enddo

end subroutine

subroutine fill_state_hc(CA_dom,CA_state_in)
use latticemem
use rulemem
implicit none
type(domain), intent(in)      :: CA_dom
type(state ), intent(inout)   :: CA_state_in
!     Local variables
integer i
integer a,b

do i=1,CA_dom%S

      a = CA_dom%neighlist(i,1)
      b = CA_dom%neighlist(i,4)

      if ( (CA_state_in%ipopulation(a) .EQ. 1) .AND. ( CA_state_in%ipopulation(b) .EQ.  1) ) then
         CA_state_in%ipop(i)=1
      endif

      a = CA_dom%neighlist(i,2)
      b = CA_dom%neighlist(i,5)

      if ( (CA_state_in%ipopulation(a) .EQ. 1) .AND. ( CA_state_in%ipopulation(b) .EQ.  1) ) then
         CA_state_in%ipop(i)=1
      endif

      a = CA_dom%neighlist(i,3)
      b = CA_dom%neighlist(i,6)

      if ( (CA_state_in%ipopulation(a) .EQ. 1) .AND. ( CA_state_in%ipopulation(b) .EQ.  1) ) then
         CA_state_in%ipop(i)=1
      endif

enddo

do i=1,CA_dom%S
   CA_state_in%ipopulation(i) = CA_state_in%ipop(i)
enddo

end subroutine

end module
