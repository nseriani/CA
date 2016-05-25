CCCC This code performs cellular automata calculations
CCC By Paolo Lazzari and Nicola Seriani
CCC Originally developed in May 2016

      program lazser
      implicit real*8(a-h,o-z)
      character(3) latticetype
      character(10) neighbourhood 
      character(10) ruletype
      dimension ipopulation(1000000)

      call init(idimension, latticetype, neighbourhood, nneigh, 
     & irealsize, ruletype, ictilde, icrule, nstep, nprint, ipopulation)

      call cellular(neighbourhood, nneigh, irealsize, ruletype, ictilde,
     &   icrule, nstep, nprint, ipopulation)

      end
