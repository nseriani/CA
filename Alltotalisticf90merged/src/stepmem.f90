module stepmem
type step
INTEGER                               :: nstep         ! number of CA steps
INTEGER                               :: nprint        ! State printed every nprint steps
INTEGER                               :: ndiagno       ! Diagnostics printed every ndiagno steps 
end type step

type(step),save                       :: CA_step

end module
