      subroutine scmoore(isize, neighlist)
      implicit real*8(a-h,o-z)
      dimension neighlist(1000000, 30)
      do i1 =2, isize-1
        do i2 =2, isize-1
          do i3 =2, isize-1
              j = (i1-1)*isize
              j = (j+i2-1)*isize+i3
              kk=1
              do k1=1,3 
                do k2 =1,3
                 j2 = (i1-2)*isize
                 j2 = (j2+i2-3+k1)*isize+i3-2+k2
                 neighlist(j, kk)=j2           
                 kk=kk+1
                 
                 j2 = i1*isize
                 j2 = (j2+i2-3+k1)*isize+i3-2+k2
                 neighlist(j, kk)=j2 
                 kk=kk+1
                enddo
              enddo
              do k1=1,3
                j2 = (i1-1)*isize
                j2 = (j2+i2-2)*isize+i3-2+k1
                neighlist(j, kk)=j2
                kk=kk+1
 
                j2 = (i1-1)*isize
                j2 = (j2+i2)*isize+i3-2+k1
                neighlist(j, kk)=j2
                kk=kk+1

              enddo
              j2 = (i1-1)*isize
              j2 = (j2+i2-1)*isize+i3-1
              neighlist(j, kk)=j2
              kk=kk+1
 
              j2 = (i1-1)*isize
              j2 = (j2+i2-1)*isize+i3+1
              neighlist(j, kk)=j2
!              write(*,*)'kk  ', kk
          enddo
        enddo
      enddo      

      return
      end
  
