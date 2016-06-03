module latticemem

type domain
INTEGER                               :: isize    ! length of N-dimensional cube edge
#include <define_array.h>
INTEGER                               :: S        ! Size of the vectorized domain
CHARACTER (LEN=10)                    :: latticetype
CHARACTER (LEN=30)                    :: neighbourhood
INTEGER                               :: nneigh       ! number of near nieghbours
INTEGER, allocatable, dimension(:,:)  :: v1DtoND  ! map of 1D to ND
INTEGER, allocatable, dimension(:,:)  :: neighlist      ! matrix of vectorized nearneighbours
end type domain

type(domain),save                     :: CA_dom1

contains

subroutine allocate_dom(CA_dom)

type(domain)                       :: CA_dom
! local variable
integer   :: i,j
integer   :: L,D
INTEGER, allocatable, dimension(:)    :: v        ! state_vector


D = CA_dom%D
L = CA_dom%isize

#include <allocate_array.h>


SELECT CASE (TRIM(CA_dom%latticetype))

   CASE('SC','sc')
 
       write(*,*) 'SC'

       CA_dom%S=CA_dom%isize**CA_dom%D

       allocate(v(CA_dom%S))

       FORALL (i=1:CA_dom%S) v(i) = i

       CA_dom%m=UNPACK(v,CA_dom%m==CA_dom%m,CA_dom%m)! D-dimensional matrix of indexes

   CASE('FCC','fcc')


       write(*,*) 'FCC'

       CA_dom%n = 0
       write(*,*) shape(CA_dom%n)

       do i=1,D
          CA_dom%m = 0
          do j=1,(CA_dom%isize/2)*2,2
             CA_dom%m=EOSHIFT(CA_dom%m,SHIFT= 1,BOUNDARY=1,DIM=i)
             CA_dom%m=CSHIFT(CA_dom%m,SHIFT= 1,DIM=i)
          enddo
          CA_dom%n = CA_dom%m + CA_dom%n 
       enddo

       CA_dom%n = mod(CA_dom%n,2)

       CA_dom%S=SUM(CA_dom%n)

       allocate(v(CA_dom%S))

       FORALL (i=1:CA_dom%S) v(i) = i

       CA_dom%m = UNPACK(v,CA_dom%n == 1,CA_dom%n) ! D-dimensional matrix of indexes


   CASE DEFAULT

       STOP     'Lattice not understood, select SC or FCC'

END SELECT

! construct map between 1D world and ND world

allocate(CA_dom%v1DtoND(CA_dom%S,D))

do i=1,D
   CA_dom%n = 0
     do j=1,CA_dom%isize
        CA_dom%n=EOSHIFT(CA_dom%n,SHIFT= 1,BOUNDARY=j,DIM=i)
     enddo
   CA_dom%v1DtoND(:,i) =PACK(CA_dom%n,CA_dom%m>0)
enddo


deallocate(v)

end subroutine

subroutine dump_lattice(CA_dom)
implicit none
!local variables
type(domain)   :: CA_dom
integer        :: i,j
character(len=1024)  :: filename
character(len=1024)  :: cube_side

write (cube_side, "(I3.3)") CA_dom%isize
filename =  TRIM(CA_dom%latticetype)//TRIM(cube_side)//'.xyz'

OPEN(UNIT=333,FILE=TRIM(filename),FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")

    write(unit=333,FMT=*) CA_dom%S
    write(unit=333,FMT=*) 
do i=1,CA_dom%S
    write(unit=333,FMT=*) "Au", CA_dom%v1DtoND(i,:)
enddo

CLOSE(UNIT=333)

end subroutine

subroutine deallocate_dom(CA_dom)
implicit none
type(domain)   :: CA_dom

deallocate(CA_dom%m)
deallocate(CA_dom%n)
deallocate(CA_dom%v1DtoND)
deallocate(CA_dom%neighlist)

end subroutine


end module
