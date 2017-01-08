!    This code prepares random and quasi-random seeds for 2D surface growth.
!   By Paolo Lazzari and Nicola Seriani
!   Originally developed in December 2016

      program prepsurf
      implicit none
! local variables
      character(3)        :: atom
      character(43)       :: filename
      integer              :: i,j, j1, j2, nactive
      integer              :: nconfig, natom, number
      real                 :: r(2,5000)
      real                 :: average, stddev, xmin, xmax
      real                 :: delta, length, x0, x1
      real                 :: averall, stddevall 
!      external integerrand

      open(10,file='input.dat')
      
      read(10,*) nconfig
      read(10,*) filename
      read(10,*) number

      open(12,file=filename)

      do i =1, nconfig
         read(12,*) natom
         read(12,*)  
         xmin = 400.d0
         xmax = 1200.d0
         
         do j =1, natom
            read(12,*) atom, r(:,j)
!            if(r(1,j).lt.xmin) xmin=r(1,j)
!            if(r(1,j).gt.xmax) xmax=r(1,j)
         enddo
         
         delta = (xmax-xmin)/float(number)
!         write(*,*) xmin, xmax, delta, number
         do j1 = 1, number
           length = delta*float(j1)
           averall = 0.0
           stddevall = 0.0
           do j2 = 1, number - j1+1
              x0 = xmin + delta*float(j2-1)
              x1 = x0 + length  
              average =0.d0
              stddev =0.d0
              nactive = 0
              do j =1, natom
                 if(r(1,j).ge.x0.and.r(1,j).le.x1) then 
                   average = average + r(2,j)
                   nactive = nactive +1
                 endif
              enddo
!              write(*,*) j1, j2, nactive, average 
              average = average/float(nactive)
              do j =1, natom
                if(r(1,j).ge.x0.and.r(1,j).le.x1) then
                  stddev = stddev + (r(2,j)-average)**2
                endif
              enddo
              stddev = sqrt(stddev/float(nactive))
              averall = averall + average
              stddevall = stddevall + stddev
!              write(14,*) i, average, stddev
           enddo
           averall = averall/float(number - j1+1) 
           stddevall = stddevall/float(number - j1+1)
           write(20+i,*) length, averall, stddevall
         enddo
      enddo
      
      write(*,*) 'End of calculation. Good bye.'
100 FORMAT('    ',1I4,'.0  ',1I4,'.0 49.0')
      end
