program test_pdgetrf

use, intrinsic :: iso_fortran_env, only : real64
!! this can be a source of linking issues, so be sure scalapack linked correctly
implicit none

external :: pdgetrf

character, parameter :: ORDER = 'R'
integer, parameter :: NPROW = 2, NPCOL = 2, M=4, N=4, MB=2,NB=MB
integer :: dt, icontxt, myrow, mycol, info, desc_a(9), ipvt(9+2)

integer, parameter :: MMAX=8,NMAX=8,LDA=MMAX,LW=NMAX
real(real64) :: A(LDA,NMAX)

desc_a = [DT, ICONTXT, M, N, MB, NB, NPROW, NPCOL, LDA]



CALL BLACS_GET (0, 0, ICONTXT)
CALL BLACS_GRIDINIT(ICONTXT, ORDER, NPROW, NPCOL)
CALL BLACS_GRIDINFO(ICONTXT, NPROW, NPCOL, MYROW, MYCOL)

CALL PDGETRF( 9  , 9 , A , 1 , 1 ,  DESC_A , IPVT , INFO )

call blacs_gridexit(icontxt)
call blacs_exit(0)

end program
