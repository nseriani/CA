!    This reads input files and initializes variables
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in May 2016

      subroutine init(filein, CA_dom, CA_state, CA_seed, CA_rule) 
      use latticemem
      use nearneighbourmem
      use statemem
      use seedmem
      use rulemem
      use globalmem
      implicit none
      character(100)        :: filein
      type(domain)         :: CA_dom
      type(seed  )         :: CA_seed
      type(state )         :: CA_state
      type(rule  )         :: CA_rule

!    Read main input, with information on lattice, rule, number of iterations, output options 
   
    call init_global(filein,CA_dom, CA_state, CA_seed, CA_rule)

!   Initailize the mapping 1D <--> ND and the corresponding nearneihgbour vector

    call allocate_dom(CA_dom)

    call check_lattice_vs_seed(CA_dom,CA_seed%seedfile)

    call compute_nearneighbour(CA_dom)

    call dump_lattice(CA_dom)

!   Initailize state

    call init_state(CA_dom,CA_state)  

!   Read and initialize the seed

    call init_seed(CA_dom,CA_state,CA_seed)

!   call dump_state(CA_dom,CA_state)

!   Read the rule

    call init_rule(CA_dom,CA_rule)

      return
      end
