!     -- BLACS example code --
!     Written by Clint Whaley 7/26/94
!     Performs a simple check-in type hello world
implicit none
INTEGER CONTXT, IAM, NPROCS, NPROW, NPCOL, MYPROW, MYPCOL
INTEGER ICALLER, I, J, HISROW, HISCOL
integer, external :: blacs_pnum
!     Determine my process number and the number of processes in
!     machine
CALL BLACS_PINFO(IAM, NPROCS)
!     If in PVM, create virtual machine if it doesn't exist
IF (NPROCS < 1) THEN
  IF (IAM == 0) NPROCS = 2
  CALL BLACS_SETUP(IAM, NPROCS)
END IF
!     Set up process grid that is as close to square as possible
NPROW = INT( SQRT( REAL(NPROCS) ) )
NPCOL = NPROCS / NPROW
!     Get default system context, and define grid
CALL BLACS_GET(0, 0, CONTXT)
CALL BLACS_GRIDINIT(CONTXT, 'Row', NPROW, NPCOL)
CALL BLACS_GRIDINFO(CONTXT, NPROW, NPCOL, MYPROW, MYPCOL)
!     If I'm not in grid, go to end of program
IF ( (MYPROW < NPROW) .and. (MYPCOL < NPCOL) ) then
!     Get my process ID from my grid coordinates
ICALLER = BLACS_PNUM(CONTXT, MYPROW, MYPCOL)
!     If I am process {0,0}, receive check-in messages from
!     all nodes
IF ( (MYPROW == 0) .AND. (MYPCOL == 0) ) THEN
  DO I = 0, NPROW-1
    DO J = 0, NPCOL-1

      IF ( (I /= 0) .OR. (J /= 0) ) THEN
        CALL IGERV2D(CONTXT, 1, 1, ICALLER, 1, I, J)
      ENDIF
! Make sure ICALLER is where we think in process grid
      CALL BLACS_PCOORD(CONTXT, ICALLER, HISROW, HISCOL)
      IF ( (HISROW /= I) .OR. (HISCOL /= J) ) error stop 'Grid error!'
      print '(A,i3,i3,A,i3,A)','Process ',I, J, '  node number ', ICALLER
    enddo
  enddo

  print '(/,A)', 'All processes checked in.  Run finished.'
!     All processes but {0,0} send process ID as a check-in
ELSE
  call IGESD2D(CONTXT, 1, 1, ICALLER, 1, 0, 0)
END IF

endif

CALL BLACS_EXIT(0)

END program