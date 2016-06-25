!    This code performs cellular automata calculations
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      subroutine cellular(CA_dom, CA_state, CA_rule)
      use latticemem
      use statemem
      use rulemem
      use globalmem
      use stepmem 
      implicit none
      type(domain)         :: CA_dom
      type(state )         :: CA_state
      type(rule  )         :: CA_rule
!     Local variabiles
      integer i, i2


      if(CA_rule%ruletype.eq.'alltotalistic') then

         CA_rule%ruletype = 'totalistic'
         do i2 =0, 2**(CA_dom%nneigh+1)
           write(*,*) 'rule ', i2
           CA_rule%icrule = i2
           CA_state%ipopulation = CA_state%ipopulation0
           
           do i =1, CA_step%nstep
             
             call update(CA_dom,CA_state, CA_rule)
             if(mod(i,CA_step%nprint).eq.0)  call dump_state(CA_dom,CA_state)

           enddo 
            
         enddo
      else

        do i =1, CA_step%nstep 

         call update(CA_dom,CA_state, CA_rule)
         if(mod(i,CA_step%nprint).eq.0)  call dump_state(CA_dom,CA_state)

        enddo
      endif

      end
