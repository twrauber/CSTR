C
      IMPLICIT NONE

      REAL *8 DSEED,RV(18),RAND(3),S(3)
      INTEGER NMAXERR
      INTEGER iunit, cunit, IOS, I, MAXSTEPS

      NMAXERR = 3 ! At most three simultaneous faults allowed
C      DSEED = 1234
C      MAXSTEPS = 1

      write(*,*) 'Go Fortran ...'
      cunit = 8
      open(unit=cunit, file='rand_deterministic.cfg',
     1     status='old', iostat=IOS)
      IF (IOS .ne. 0) THEN
      WRITE(*,*) 'Unable to read config file'
      stop
      ENDIF
      READ(cunit,*) DSEED
      READ(cunit,*) MAXSTEPS
      close(unit=cunit)
      WRITE(*,'(1x,A12,D12.2,A12,I5)')'Seed=',DSEED,'MAXSTEPS=',MAXSTEPS

      WRITE(*,'(1x,A)') 'Generating random data'
      iunit = 7
      open(unit=iunit, file='rand_deterministic.bin', iostat=IOS,
     1     status='replace', form='unformatted', ACCESS='STREAM')
      IF (IOS .ne. 0) THEN
        WRITE(*,*) 'Unable to create data file'
        stop
      ENDIF

      DO I=1,MAXSTEPS

        CALL GGUBS(DSEED,18,RV)
        WRITE(iunit) RV
C        WRITE (*,'(1x,A15,I5,18(F9.5))') 'UNIFORM [0,1]:',I, RV

        CALL GGNML(DSEED,NMAXERR,RAND)
        WRITE(iunit) RAND
C        WRITE (*,'(1x,A15,3(F12.5))') 'NORMAL (0,1):', RAND

      ENDDO
      close(unit=iunit)
      write(*,*) 'Done Fortran.'
      END

C-----------------------------------------------------------------------
C
C
C p. 319:
C ... Note that the Jacketed CSTR Simulation program makes
C three external function calls to GGNML, GGUBS, and SIMPLOT. GGNML and GGUBS
C are IMSL random number generator routines. SIMPLOT is a custom plotting routine. The
C SIMPLOT call can be removed with no effect on the performance of the simulator
C
C
C http://www.netlib.org/list/imsl
C imsl/GGNML   NORMAL OR GAUSSIAN RANDOM DEVIATE GENERATOR
C imsl/GGUBS   BASIC UNIFORM (0, 1) PSEUDO-RANDOM NUMBER GENERATOR
C
C
C dseed: inital seed (dseed is automatically updated)
C nr: dimension of the double precision array r
C r: real*8 r(nr)
C GGUBS generates nr independent uniform random variables
C GGNML generates nr independent normal variables


      SUBROUTINE GGUBS(DSEED,NR,R)
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   GGUBS GENERATES NR SINGLE PRECISION RANDOM VARIATES UNIFORM C
C ON (0,1) BY A LINEAR CONGRUENTIAL SCHEME.  THIS ROUTINE IS    C
C DEPENDENT ON MACHINE WORD SIZE.                               C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   LAST MODIFIED                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C   ON ENTRY                                                    C
C       DSEED   DOUBLE PRECISION                                C
C               SEED FOR GENERATOR                              C
C       NR      INTEGER                                         C
C               NUMBER OF VARIATES TO GENERATE                  C
C   ON RETURN                                                   C
C       R       REAL (NR)                                       C
C               SINGLE PRECISION ARRAY CONTAINING THE VARIATES  C
C   GGUBS CALLS                                                 C
C               DMOD                                            C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
      INTEGER            NR
      REAL*8             R(NR)
      DOUBLE PRECISION   DSEED
C
C                              LOCAL
C
      INTEGER            I
      DOUBLE PRECISION   D2P31M,D2P31,DMULTX
C
C                              MACHINE CONSTANTS
C                              D2P31M=(2**31) - 1
C                              D2P31 =(2**31)(OR AN ADJUSTED VALUE)
C
      DATA               D2P31M/2147483647.D0/
      DATA               D2P31/2147483711.D0/
      DATA               DMULTX/16807.0D+00/
C
      DO 5 I=1,NR
         DSEED=DMOD(DMULTX*DSEED,D2P31M)
         R(I) =DSEED / D2P31
  5   CONTINUE
C
C                               END OF GGUBS
C
      RETURN
      END
C===============================================================C
C===============================================================C
      SUBROUTINE GGNML(DSEED,NR,R)
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   GGNML GENERATES NR SINGLE PRECISION N(0,1) RANDOM VARIATES  C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   LAST MODIFIED                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C   ON ENTRY                                                    C
C       DSEED   DOUBLE PRECISION                                C
C               SEED FOR GENERATOR                              C
C       NR      INTEGER                                         C
C               NUMBER OF VARIATES TO GENERATE                  C
C   ON RETURN                                                   C
C       R       REAL (NR)                                       C
C               SINGLE PRECISION ARRAY CONTAINING THE VARIATES  C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
      INTEGER            NR
      REAL*8             R(NR)
      DOUBLE PRECISION   DSEED
C                              LOCAL
      INTEGER             IER
C
C                              GET NR RANDOM NUMBERS
C                              UNIFORM (0,1)
C
      CALL GGUBS(DSEED,NR,R)
C
C                              TRANSFORM EACH UNIFORM DEVIATE
C
      DO 5 I=1,NR
         CALL MDNRIS(R(I),R(I),IER)
    5 CONTINUE
C
C                               END OF GGNML
C
      RETURN
      END


      SUBROUTINE MDNRIS (P,Y,IER)
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C                                                               C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   LAST MODIFIED                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C                                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C                                  SPECIFICATIONS FOR ARGUMENTS
      REAL*8             P,Y
      INTEGER            IER
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      REAL*8             EPS,G0,G1,G2,G3,H0,H1,H2,A,W,WI,SN,SD
      REAL*8             SIGMA,SQRT2,X,XINF
      DATA               XINF/1.7014E+38/
      DATA               SQRT2/1.414214/
      DATA               EPS/1.1921E-07/
      DATA               G0/.1851159E-3/,G1/-.2028152E-2/
      DATA               G2/-.1498384/,G3/.1078639E-1/
      DATA               H0/.9952975E-1/,H1/.5211733/
      DATA               H2/-.6888301E-1/
C                                  FIRST EXECUTABLE STATEMENT
      IER = 0
      IF (P .GT. 0.0 .AND. P .LT. 1.0) GO TO 5
      IER = 129

      if (p .lt. 0.0D+00) then
         sigma = -1.0D+00
      else
         sigma = 1.0D+00
      endif

C      SIGMA = SIGN(1.0,P)
C      write(6,666) p,sigma
C666   format(' Sign #1: ',2f15.8)
C      pause

      Y = SIGMA * XINF
      GO TO 20
    5 IF(P.LE.EPS) GO TO 10
      X = 1.0D0 -(P + P)
      CALL MERFI (X,Y,IER)
      Y = -SQRT2 * Y
      GO TO 20
C                                  P TOO SMALL, COMPUTE Y DIRECTLY
   10 A = P+P
      W = SQRT(-dLOG(A+(A-A*A)))
C                                  USE A RATIONAL FUNCTION IN 1./W
      WI = 1.0D0/W
      SN = ((G3*WI+G2)*WI+G1)*WI
      SD = ((WI+H2)*WI+H1)*WI+H0
      Y = W + W*(G0+SN/SD)
      Y = -Y*SQRT2
C                               END OF MDNRIS
  20  RETURN
      END
C===============================================================C
      SUBROUTINE MERFI (P,Y,IER)
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C                                                               C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++C
C   LAST MODIFIED                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C                                                               C
C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C
C                                  SPECIFICATIONS FOR ARGUMENTS
      REAL*8             P,Y
      INTEGER            IER
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      REAL*8             A,B,X,Z,W,WI,SN,SD,F,Z2,RINFM,A1,A2,A3,B0,B1,
     *                   B2,B3,C0,C1,C2,C3,D0,D1,D2,E0,E1,E2,E3,F0,F1,
     *                   F2,G0,G1,G2,G3,H0,H1,H2,SIGMA
      DATA               A1/-.5751703/,A2/-1.896513/,A3/-.5496261E-1/
      DATA               B0/-.1137730/,B1/-3.293474/,B2/-2.374996/
      DATA               B3/-1.187515/
      DATA               C0/-.1146666/,C1/-.1314774/,C2/-.2368201/
      DATA               C3/.5073975E-1/
      DATA               D0/-44.27977/,D1/21.98546/,D2/-7.586103/
      DATA               E0/-.5668422E-1/,E1/.3937021/,E2/-.3166501/
      DATA               E3/.6208963E-1/
      DATA               F0/-6.266786/,F1/4.666263/,F2/-2.962883/
      DATA               G0/.1851159E-3/,G1/-.2028152E-2/
      DATA               G2/-.1498384/,G3/.1078639E-1/
      DATA               H0/.9952975E-1/,H1/.5211733/
      DATA               H2/-.6888301E-1/
      DATA               RINFM/1.7014E+38/
C                                  FIRST EXECUTABLE STATEMENT
      IER = 0
      X = P

      if (x .lt. 0.0D+00) then
         sigma = -1.0D+00
      else
         sigma = 1.0D+00
      endif

C      SIGMA = SIGN(1.0,X)
C      write(6,666) x,sigma
C666   format(' Sign #2: ',2f15.8)
C      pause

C                                  TEST FOR INVALID ARGUMENT
      IF (.NOT.(X.GT.-1. .AND. X.LT.1.)) GO TO 30
      Z = ABS(X)
      IF (Z.LE. .85D0) GO TO 20
      A = 1.0D0-Z
      B = Z
C                                  REDUCED ARGUMENT IS IN (.85,1.),
C                                     OBTAIN THE TRANSFORMED VARIABLE
    5 W = SQRT(-dLOG(A+A*B))
      IF (W.LT.2.5D0) GO TO 15
      IF (W.LT.4.0D0) GO TO 10
C                                  W GREATER THAN 4., APPROX. F BY A
C                                     RATIONAL FUNCTION IN 1./W
      WI = 1.0D0/W
      SN = ((G3*WI+G2)*WI+G1)*WI
      SD = ((WI+H2)*WI+H1)*WI+H0
      F = W + W*(G0+SN/SD)
      GO TO 25
C                                  W BETWEEN 2.5 AND 4., APPROX. F
C                                     BY A RATIONAL FUNCTION IN W
   10 SN = ((E3*W+E2)*W+E1)*W
      SD = ((W+F2)*W+F1)*W+F0
      F = W + W*(E0+SN/SD)
      GO TO 25
C                                  W BETWEEN 1.13222 AND 2.5, APPROX.
C                                     F BY A RATIONAL FUNCTION IN W
   15 SN = ((C3*W+C2)*W+C1)*W
      SD = ((W+D2)*W+D1)*W+D0
      F = W + W*(C0+SN/SD)
      GO TO 25
C                                  Z BETWEEN 0. AND .85, APPROX. F
C                                     BY A RATIONAL FUNCTION IN Z
   20 Z2 = Z*Z
      F = Z+Z*(B0+A1*Z2/(B1+Z2+A2/(B2+Z2+A3/(B3+Z2))))
C                                  FORM THE SOLUTION BY MULT. F BY
C                                     THE PROPER SIGN
   25 Y = SIGMA*F
      IER = 0
      GO TO 40
C                                  ERROR EXIT. SET SOLUTION TO PLUS
C                                     (OR MINUS) INFINITY
   30 IER = 129
      Y = SIGMA * RINFM
C                               END OF MERFI
   40 RETURN
      END
C===============================================================C
