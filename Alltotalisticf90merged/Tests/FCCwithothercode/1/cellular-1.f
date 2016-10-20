       program cellular
       implicit real*8(a-h,o-z)
       dimension iv(1000, 1000, 1000) 
       dimension nneigh(1000, 1000, 1000)
       dimension imm(3,2)
       alat = 4.0782d0
       open(11, file='input.in')
       read(11,*) nstep

C initial conditions
       iv = 0
       iv(500, 500, 500) = 1
       iv(499, 501, 500) = 1
       iv(500, 501, 500) = 1
       iv(499, 499, 500) = 1
       iv(500, 499, 500) = 1
       
       iv(499, 500, 501) = 1
       iv(500, 500, 501) = 1
       iv(500, 501, 501) = 1
       iv(500, 499, 501) = 1

       iv(499, 500, 499) = 1
       iv(500, 500, 499) = 1
       iv(500, 501, 499) = 1
       iv(500, 499, 499) = 1

       imm(1,1) = 494
       imm(2,1) = 247
       imm(3,1) = 247
       imm(1,2) = 506
       imm(2,2) = 253
       imm(3,2) = 253

CC
CC Evolution
       do j=1, nstep

CC Determination of number of occupied neighbours for a lattice site
          do i1 = imm(1,1), imm(1,2) 
             do i2 = imm(2,1), imm(2,2)          
                do i3 = imm(3,1), imm(3,2)
                   nneigh(i1, 2*i2, 2*i3+1) = 0
CC First even 'y' line on uneven 'z' line
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2+1, 2*i3+1)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1+1, 2*i2+1, 2*i3+1)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2-1, 2*i3+1)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1+1, 2*i2-1, 2*i3+1)

          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1  , 2*i2, 2*i3+2)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1+1, 2*i2, 2*i3+2)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2+1, 2*i3+2)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2-1, 2*i3+2)

          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1  , 2*i2, 2*i3)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1+1, 2*i2, 2*i3)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2+1, 2*i3)
          nneigh(i1, 2*i2, 2*i3+1) = nneigh(i1, 2*i2, 2*i3+1) + 
     &    iv(i1, 2*i2-1, 2*i3)
c          if(nneigh(i1, 2*i2, 2*i3+1).eq.1) then
c              write(12,*) 
c              write(12,*) '1.... ', i1, 2*i2, 2*i3+1
c        write(12,*) iv(i1, 2*i2+1, 2*i3+1), iv(i1+1, 2*i2+1, 2*i3+1)
c        write(12,*) iv(i1, 2*i2-1, 2*i3+1), iv(i1+1, 2*i2-1, 2*i3+1)
c        write(12,*) iv(i1  , 2*i2, 2*i3+2),  iv(i1+1, 2*i2, 2*i3+2)
c        write(12,*) iv(i1, 2*i2+1, 2*i3+2), iv(i1, 2*i2-1, 2*i3+2)
c        write(12,*) iv(i1  , 2*i2, 2*i3),  iv(i1+1, 2*i2, 2*i3)
c        write(12,*)  iv(i1, 2*i2+1, 2*i3), iv(i1, 2*i2-1, 2*i3)c
c          endif
                   
CC Then uneven 'y' line on uneven 'z' line
         nneigh(i1, 2*i2+1, 2*i3+1) = 0
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     &  iv(i1-1, 2*i2+2, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     &  iv(i1, 2*i2+2, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     &  iv(i1-1, 2*i2, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     &  iv(i1, 2*i2, 2*i3+1)

         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1-1  , 2*i2+1, 2*i3+2)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1,   2*i2+1, 2*i3+2)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1, 2*i2+2, 2*i3+2)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1, 2*i2, 2*i3+2)

         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1-1  , 2*i2+1, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1, 2*i2+1, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1, 2*i2+2, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3+1) = nneigh(i1, 2*i2+1, 2*i3+1) + 
     & iv(i1, 2*i2, 2*i3)


CC Then uneven 'y' line on even 'z' line
         nneigh(i1, 2*i2+1, 2*i3) = 0
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2+2, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1+1, 2*i2+2, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2, 2*i3)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1+1, 2*i2, 2*i3)

         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1  , 2*i2+1, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1+1, 2*i2+1, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2+2, 2*i3+1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2, 2*i3+1)

         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1  , 2*i2+1, 2*i3-1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1+1, 2*i2+1, 2*i3-1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2+2, 2*i3-1)
         nneigh(i1, 2*i2+1, 2*i3) = nneigh(i1, 2*i2+1, 2*i3) + 
     & iv(i1, 2*i2, 2*i3-1)

CC Then even 'y' line on even 'z' line
         nneigh(i1, 2*i2, 2*i3) = 0
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1-1, 2*i2+1, 2*i3)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2+1, 2*i3)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1-1, 2*i2-1, 2*i3)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2-1, 2*i3)

         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1-1  , 2*i2, 2*i3+1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1,   2*i2, 2*i3+1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2+1, 2*i3+1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2-1, 2*i3+1)

         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1-1  , 2*i2, 2*i3-1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2, 2*i3-1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2+1, 2*i3-1)
         nneigh(i1, 2*i2, 2*i3) = nneigh(i1, 2*i2, 2*i3) + 
     & iv(i1, 2*i2-1, 2*i3-1)


                enddo
             enddo
          enddo

CC Now occupation update (this the cellular automaton rule)
          nnnatom = 0
          do i1 = 4, 996
             do i2 = 4, 996
                do i3 = 4, 996
         if (nneigh(i1, i2, i3).eq.1) then
                      iv(i1, i2, i3) = 1
                      imm(1,1)=min(imm(1,1), i1-3)
                      imm(1,2)=max(imm(1,2), i1+3)
                      imm(2,1)=min(imm(2,1), i2/2-3)
                      imm(2,2)=max(imm(2,2), i2/2+3)
                      imm(3,1)=min(imm(3,1), i3/2-3)
                      imm(3,2)=max(imm(3,2), i3/2+3)
                   endif
cc          if (iv(i1, i2, i3).eq.1) then
cc            nnnatom = nnnatom +1
cc            write(14,*) 'ivvv     ', j,i1,i2,i3
cc          endif
                enddo
             enddo
          enddo
cc          write(14,*) ' cycle, natom ', j, nnnatom
cc          write(14,*) ' nneigh(498, 499, 500) ', 
cc     &      nneigh(498, 499, 500), iv(498, 499, 500)
       enddo   
      
       do i1 = imm(1,1), imm(1,2)
             do i2 = imm(2,1), imm(2,2)
                do i3 = imm(3,1), imm(3,2)
CC First even 'y' line on uneven 'z' line
                if(iv(i1, 2*i2, 2*i3+1).eq.1) then
c                write(12,*) 
c                write(12,*) 
c        write(12,*) iv(i1, 2*i2+1, 2*i3+1), iv(i1+1, 2*i2+1, 2*i3+1)
c        write(12,*) iv(i1, 2*i2-1, 2*i3+1), iv(i1+1, 2*i2-1, 2*i3+1)
c        write(12,*) iv(i1  , 2*i2, 2*i3+2),  iv(i1+1, 2*i2, 2*i3+2)
c        write(12,*) iv(i1, 2*i2+1, 2*i3+2), iv(i1, 2*i2-1, 2*i3+2)
c        write(12,*) iv(i1  , 2*i2, 2*i3),  iv(i1+1, 2*i2, 2*i3)
c        write(12,*)  iv(i1, 2*i2+1, 2*i3), iv(i1, 2*i2-1, 2*i3)
  

                  x = (dfloat(i1-1)+0.5d0)*alat
                  y = (dfloat(i2-1)+0.5d0)*alat
                  z =  dfloat(i3)*alat
                  write(12,*) 'Au ',  x, y, z
               endif
CC Then uneven 'y' line on uneven 'z' line
                if(iv(i1, 2*i2+1, 2*i3+1).eq.1) then
                  x = dfloat(i1-1)*alat
                  y = dfloat(i2)*alat
                  z = dfloat(i3)*alat
                  write(12,*) 'Au ',  x, y, z
               endif
CC Then uneven 'y' line on even 'z' line
                if(iv(i1, 2*i2+1, 2*i3).eq.1) then
                  x = (dfloat(i1-1)+0.5d0)*alat
                  y = dfloat(i2)*alat
                  z = (dfloat(i3-1)+0.5d0)*alat
                  write(12,*) 'Au ',  x, y, z
               endif
CC Then even 'y' line on even 'z' line
               if(iv(i1, 2*i2, 2*i3).eq.1) then
                  x = dfloat(i1-1)*alat
                  y = (dfloat(i2-1)+0.5d0)*alat
                  z = (dfloat(i3-1)+0.5d0)*alat
                  write(12,*) 'Au ',  x, y, z
               endif

             enddo
          enddo
       enddo
       end
