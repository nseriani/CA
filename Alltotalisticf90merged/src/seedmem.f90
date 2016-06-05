module seedmem
use latticemem
use statemem
type seed
CHARACTER (LEN=30)                    :: seedfile
CHARACTER (LEN=10)                    :: latticetype
CHARACTER (LEN=30)                    :: neighbourhood
CHARACTER (LEN=30)                    :: stype         ! indices or xyz.... 
CHARACTER (LEN=30)                    :: origin_type   ! manual or centered
INTEGER                               :: nseed         ! number of cells for seed
INTEGER, allocatable, dimension(:)    :: origin        ! indexes for seed
REAL(8), allocatable, dimension(:,:)  :: idxr          ! indexes for seed
INTEGER, allocatable, dimension(:,:)  :: idx           ! indexes for seed
end type seed

type(seed),save                       :: CA_seed1

contains

subroutine init_seed(CA_dom,CA_state,CA_seed)
   implicit none
   type(domain) :: CA_dom
   type(state ) :: CA_state
   type(seed  ) :: CA_seed
! local variables
   integer      :: i
      open(12,file=CA_seed%seedfile)

      read(12,*) CA_seed%nseed

      allocate(CA_seed%idxr(CA_seed%nseed,CA_dom%D))
      allocate(CA_seed%idx (CA_seed%nseed,CA_dom%D))

      read(12,*) CA_seed%latticetype, CA_seed%stype
      read(12,*) CA_seed%origin_type, CA_seed%origin(:)

      write(*,*) 'Number of cells in the seed: ',CA_seed%nseed
      write(*,*) 'From seed file: ',CA_seed%latticetype,'  ', CA_seed%stype

      if(CA_dom%latticetype.ne.CA_seed%latticetype)  STOP 'Seed lattice different from input lattice'

      do i =1, CA_seed%nseed
          read(12,*) CA_seed%idxr(i,:)
      enddo

      close(12)

!   Now use this to initialize the array...
      SELECT CASE (CA_seed%stype)
          CASE ('indices')
               CA_seed%idx = int(CA_seed%idxr)
               call seed_in_state(CA_dom,CA_state,CA_seed)
          CASE('xyz') 
               STOP 'seedtype = xyz not implemented yet'

          CASE DEFAULT
               STOP 'Wrong seedtype'

    END SELECT
!   End of seed initialization
end subroutine

subroutine seed_in_state(CA_dom,CA_state,CA_seed)
   implicit none
   type(domain) :: CA_dom
   type(state ) :: CA_state
   type(seed  ) :: CA_seed
! local variables
   integer      :: i,j
   integer      :: checker(CA_seed%nseed)

   checker(:) = 0 

   do i=1,CA_seed%nseed
      do j=1, CA_dom%s

        if (match(CA_dom,j,CA_seed,i)) then
            CA_state%ipopulation(j) = 1
            checker(i)            = checker(i) + 1
        endif

      enddo
   enddo
end subroutine

function  match(CA_dom,j,CA_seed,i)
   implicit none
   type(domain) :: CA_dom
   type(seed  ) :: CA_seed
   integer      :: i,j
   logical      :: match
! local variables
   integer      :: k,shifted
   
   match = .TRUE.
   do k =1, CA_dom%D
      shifted = CA_seed%idx(i,k) + CA_seed%origin(k)
      if (CA_dom%v1DtoND(j,k) .NE. shifted) match = .FALSE.
   enddo
end function
    
end module
