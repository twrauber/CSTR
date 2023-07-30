C
C**********************************************************************
C Automated fault diagnosis of chemical process plants using model-based reasoning
C Download:
C http://dspace.mit.edu/bitstream/handle/1721.1/14194/22192007.pdf?sequence=1
C Author: Finch, Francis Eric
C Citable URI: http://hdl.handle.net/1721.1/14194
C Other Contributors: Massachusetts Institute of Technology.
C Dept. of Chemical Engineering.
C Advisor: Mark A. Kramer.
C Department: Massachusetts Institute of Technology.
C Dept. of Chemical Engineering.
C Publisher: Massachusetts Institute of Technology
C Date Issued: 1989
C Description:
C Thesis (Ph. D.)--Massachusetts Institute of Technology,
C Dept. of Chemical Engineering, 1989.
C Science hard copy bound in 2 v.Includes bibliographical
C references C (leaves 300-307).
C URI: http://hdl.handle.net/1721.1/14194
C Keywords: Chemical Engineering.
C**********************************************************************
C
C
C
C Jacketed CSTR Simulation Program:
C
C23456789        ** JACKETED CSTR DYNAMIC SIMULATION PROGRAM Al
C
C          F. ERIC FINCH
C          DEPARTMENT OF CHEMICAL ENGINEERING
C            MASSACHUSETTS INSTITUTE OF TECHNOLOGY
C          CAMBRIDGE, MA 02139
C
C           REVISED 5/89
C
C          ** VARIABLE DEFINITIONS **
C
C ALPHA1                - PRIMARY RATE CONSTANT PRE-EXPONENTIAL FACTOR (1/MIN)
C BETA1                 - PRIMARY ACTIVATION ENERGY (KJ/KMOL)
C ALPHA2                - SECONDARY RATE CONSTANT PRE-EXPONENTIAL FACTOR (1/MIN)
C BETA2                 - SECONDARY ACTIVATION ENERGY (KJ/KMOL)
C B(3,3)                - ARRAY OF CONTROLLER CONSTANTS FOR PID CONTROL
C                         (IF B(1,2)=0 & B(1,3)=0 THEN P CONTROL,
C                         IF B(1,3)=0 THEN PI CONTROL)
C CA0                   - FEED CONCENTRATION (A) (KMOL/M3)
C CA                    - REACTOR CONCENTRATION (A) (KMOL/M3)
C CB                    - REACTOR CONCENTRATION (B) (KMOL/M3)
C CC                    - REACTOR CONCENTRATION (C) (KMOL/M3)
C CNT(3)                - CONTROLLER OUTPUT VECTOR
C CP,CPOLD              - HEAT CAPACITY OF REACTOR CONTENTS (KJ/KG C)
C CP1                   - FEED HEAT CAPACITY (KJ/KG C)
C CP2                   - COOLING WATER HEAT CAPACITY (KJ/KG C)
C CWPD                  - COOLING WATER PRESSURE DROP CONSTRAINT RESIDUAL (M3/MIN)
C DATAFILE              - FILE NAME FOR OUTPUT
C DAY                   - DAY STAMP
C DELAY(3)              - DELAY UNTIL FAULT INITIATION (MIN)
C DERROR(3)             - VECTOR OF DIFFERENCES BETWEEN ERROR AT
C                         SUCCESSIVE TIME STEPS
C DEXT(3)               - FAULT EXTENT DIFFERENCE AT CURRENT TIME STEP
C DEXT0(3)              - DIFFERENCE BETWEEN FINAL EXTENT AND INITIAL
C                         EXTENT OF VARIABLE AFFECTED BY FAULT
C DSEED                 - SEED FOR GAUSSIAN RANDOM NUMBER GENERATOR
C DT                    - TIME INCREMENT OF MAIN LOOP (MIN)
C ERROR(3)              - VECTOR OF CONTROLLER ERRORS
C EXTENT0(3)            - ULTIMATE FAULT EXTENT (CONTEXT DEPENDENT!!)
C EPD                   - EFFLUENT PRESSURE DROP CONSTRAINT RESIDUAL (M3/MIN)
C F(3)                  - FAULT CODES (CAN HAVE UP TO 3 SIMULTANEOUS FAULTS)
C FF                    - ADJUSTABLE PARAMETER
C FINTEG                - INTEGRAL OF FLOW RESIDUAL (M3)
C FLOW(8)               - VECTOR OF PROCESS FLOWRATES (M3/MIN)
C FMODE(2)              - CHARACTER ARRAY OF SENSOR FAILURE MODES
C FTYPE(19)             - CHARACTER ARRAY OF FAULT TYPES
C HOUR                  - HOUR STAMP
C ISEED                 - SEED FOR RANDOM NUMBER GENERATOR
C LEVEL                 - CSTR LEVEL (M)
C M                     - NUMBER OF FAULTS TO BE SIMULATED
C MASSBAL               - RESIDUAL OF INVENTORY CONSTRAINT (M3)
C MEAS(20,2)            - ARRAY OF PROCESS MEASUREMENTS; COL 2 IS
C                          MOST RECENT, COL1 IS EWMA HISTORY
C MINUTE                - MINUTE STAMP
C MOLBAL                - MOL BALANCE CONSTRAINT RESIDUAL (KMOL)
C MOLIN                 - CUMULATIVE MOL INFLUX (KMOL)
C MOLOUT                - CUMULATIVE MOL OUTFLUX (KMOL)
C MON                   - MONTH STAMP
C N                     - TOTAL NUMBER OF SENSORS AND CONSTRAINTS
C NORMVAL(20)           - ARRAY OF NORMAL STEADY STATE PROCESS MEASUREMENTS
C PB,PBCOMP             - PRESSURE AT TANK OUTLET (KG/M2)
C PCW                   - COOLING WATER SUPPLY PRESSURE (KG/M2)
C PP,PP0                - PUMP DIFFERENTIAL PRESSURE (KG/M2)
C QEXT                  - EXTERNAL HEAT SOURCE(SINK) TO CSTR (KJ/MIN)   (external heat loss due to fault)
C QJAC                  - HEAT TRANSFERED IN HEAT EXCHANGER (KJ/MIN)
C QREAC1                - PRIMARY HEAT OF REACTION (KJ/KMOL)
C QREAC2                - SECONDARY HEAT OF REACTION (KJ/KMOL)
C R(10)                 - VECTOR OF FLOW RESISTANCES (MIN KG^0.5/M4)
C RAND(3)               - RANDOM NUMBER VECTOR
C RCOMP(10)             - COMPUTED VALUES FOR FLOW RESISTANCE
C                         BASED ON SENSOR MEASUREMENT DATA
C REG1(3),REG2(3)       - STORAGE REGISTERS FOR PAST CONTROLLER ERRORS
C RHO,RHOLD             - DENSITY OF REACTOR CONTENTS (KG/M3)
C RHO1                  - DENSITY OF FEED (KG/M3)
C RHO2                  - DENSITY OF COOLING WATER (KG/M3)
C R0(10)                - NOMINAL VALUES FOR FLOW RESISTANCE (MIN KG^0.5/M4)
C RRATE1                - RATE OF PRIMARY REACTION IN CSTR (KMOL/M3 MIN)
C RRATE2                - RATE OF SECONDARY REACTION IN CSTR (KMOL/M3 MIN)
C RC                    - OVERALL RESISTANCE FOR CW STREAM (MIN KG^0.5/M4)
C RE                    - OVERALL RESISTANCE FOR EFFLUENT STREAM (MIN KG^0.5/M4)
C S0,S1,S2,S3,
C S4,S5,S6              - PROGRAM CONTROL PARAMETERS
C SDEV(20)              - STANDARD DEVIATION OF RANDOM SENSOR NOISE
C SEC                   - SECOND STAMP
C SENSORS(20)           - CHARACTER ARRAY OF SENSOR NAMES
C SP(3)                 - VECTOR OF CONTROLLER SETPOINTS
C SPDYN                 - DYNAMICALLY CHANGE SET POINTS
C SPDYNN1,SPDYNN2       - NUMBER OF SETPOINT CHANGES FOR BOTH CONTROLLERS
C SPDYN1T(1000),SPDYN1VAL(1000),SPDYN2T(1000),SPDYN2VAL(1000)
C                       - TIME INSTANT AND VALUE OF SETPOINT CHANGE
C T(4)                  - VECTOR OF PROCESS TEMPERATURES (C)
C TC(3)                 - EXPONENTIAL TIME CONSTANT FOR FAULT EXTENT
C TAREA                 - FLOOR AREA OF CSTR (M2)
C TEMP                  - A TEMPORARY STORAGE REGISTER
C TH                    - TIME HORIZON OF SIMULATION (MIN)
C THETA                 - EWMA (EXP. FILTER) PARMETER
C TIME                  - SIMULATION TIME (MIN)
C TUNE                  - CONTROLLER TUNING LOGICAL CONTROL
C TUNEI,TUNEJ           - CONTROLLER TUNING ARRAY ELEMENTS
C UA                    - HEAT EXCHANGER CONSTANT (KJ/MIN C)
C UNITS(20)             - CHARACTER ARRAY OF SENSOR UNI1S
C V(2)                  - VECTOR OF CONTROL VALVE POSITIONS [0,100]
C VOL,VOLD              - CSTR LIQUID VOLUME (M3)
C YEAR                  - YEAR STAMP
C ZCOUNT                - COUNTER FOR PRINTING OUTPUT
C ZLIM                  - PRINT INTERVAL (MIN)
C
C           **BEGIN PROGRAM**
C
C DECLARE AND DIMENSION ALL VARIABLES
C
C REAL VARIABLES (ALL DOUBLE PRECISION)
C
      IMPLICIT NONE

      integer prot,dataout,fcnt,strlen,postrailblank,posclassstr
      parameter(prot=17,dataout=18)
      character *40 auxstr,classstr,csvsep*1
      real *8 sumConcABC,mol,dmolin,dmolout,measold



      REAL *8  ALPHA1,ALPHA2,BETA1,BETA2,B(3,3),CA0,CA,CB,CC,CCNOM,
     1         CNT(3),CP,CPOLD,CP1,CP2,CWPD,DELAY(3),DERROR(3),
     1         DEXT(3),DEXT0(3),DSEED,DT,EPD,
     1         ERROR(3),EXTENT0(3),FF,FINTEG,FLOW(8),JEP,
     1         LEVEL,MASSBAL,MEAS(20,2),MOLBAL,MOLIN,MOLOUT,
     1         NORMVAL(20),PB,PBCOMP,   aux,DFRAC, ! Additional func
     1         PCW,PP,PP0,QEXT,QJAC,QREAC1,QREAC2,R(10),RAND(3),
     1         RCOMP(10),REG1(3),REG2(3),REP,RHO,RHOLD,RHO1,RHO2,
     1         R0(10),RRATE1,RRATE2,RC,RE,RV(20),SP(3),SDEV(20),
     1         SPDYN1T(1000),SPDYN1VAL(1000),
     1         SPDYN2T(1000),SPDYN2VAL(1000),
     1         T(4),TAREA,TC(3),TEMP,TH,THETA,TIME,UA,V(2),VOL,VOLD,ZLIM
C
C INTEGER VARIABLES
C
      INTEGER I,J,K
      INTEGER *2 DAY,F(3),HOUR,MINUTE,M,MON,RO(20,2),SAMP(3,23),S0,
     1            S1(3),S2(3),S3,S4,S5,S6,S7,S8,SEC,SPDYN,
     1            SS,TUNE,TUNEI,TUNEJ
      INTEGER *4 N,YEAR,ZCOUNT,SPDYNN1,SPDYNN2
      INTEGER *4 ISEED
      integer date_time(8)
      character*10 dummy(3)
C
C CHARACTER VARIABLES
C
      CHARACTER *8   UNITS(20)
      CHARACTER *12  FMODE(2)
      CHARACTER *32  SENSORS(20),DATAFILE
      CHARACTER *40  FTYPE(23)
C
5     CONTINUE
C
C
C INITIALIZE CHARACTER DATA
C
C
C INITIALIZE FAULT NAMES
C
      DATA FTYPE /'NO FAULT                                ',
     1            'BLOCKAGE AT TANK OUTLET                 ', ! Fault 2
     1            'BLOCKAGE IN JACKET                      ', ! Fault 3
     1            'JACKET LEAK TO ENVIRONMENT              ', ! Fault 4
     1            'JACKET LEAK TO TANK                     ', ! Fault 5
     1            'LEAK FROM PUMP                          ', ! Fault 6
     1            'LOSS OF PUMP PRESSURE                   ', ! Fault 7
     1            'JACKET EXCHANGE SURFACE FOULING         ', ! Fault 8
     1            'EXTERNAL HEAT SOURCE (SINK)             ', ! Fault 9
     1            'PRIMARY REACTION ACTIVATION ENERGY      ', ! Fault 10
     1            'SECONDARY REACTION ACTIVATION ENERGY    ', ! Fault 11
     1            'ABNORMAL FEED FLOWRATE                  ', ! Fault 12, nominal value is 0.25, defined in initialization of FLOW(...)
     1            'ABNORMAL FEED TEMPERATURE               ', ! Fault 13
     1            'ABNORMAL FEED CONCENTRATION             ', ! Fault 14
     1            'ABNORMAL COOLING WATER TEMPERATURE      ', ! Fault 15
     1            'ABNORMAL COOLING WATER PRESSURE         ', ! Fault 16
     1            'ABNORMAL JACKET EFFLUENT PRESSURE       ', ! Fault 17
     1            'ABNORMAL REACTOR EFFLUENT PRESSURE      ', ! Fault 18
     1            'ABNORMAL LEVEL CONTROLLER SETPOINT      ', ! Fault 19
     1            'ABNORMAL TEMPERATURE CONTROLLER SETPOINT', ! Fault 20
     1            'CONTROL VALVE (CV-1) STUCK              ', ! Fault 21
     1            'CONTROL VALVE (CV-2) STUCK              ', ! Fault 22
     1            'SENSOR FAULT                            '/ ! Fault 23
C
C INITIALIZE SENSOR NAMES
C
      DATA SENSORS /'FEED_CONCENTRATION_SENSOR       ',
     1              'FEED_FLOWRATE_SENSOR            ',
     1              'FEED_TEMPERATURE_SENSOR         ',
     1              'REACTOR_LEVEL_SENSOR            ',
     1              'CONCENTRATION_A_SENSOR          ',
     1              'CONCENTRATION_B_SENSOR          ',
     1              'REACTOR_TEMPERATURE_SENSOR      ',
     1              'COOLING_WATER_FLOWRATE_SENSOR   ',
     1              'PRODUCT_FLOWRATE_SENSOR         ',
     1              'COOLING_WATER_TEMPERATURE_SENSOR',
     1              'COOLING_WATER_PRESSURE_SENSOR   ',
     1              'LEVEL_CONTROLLER_OUTPUT_SIGNAL  ',
     1              'CW_FLOW_CONTROLLER_OUTPUT_SIGNAL',
     1              'COOLING_WATER_SETPOINT          ',
     1              'INVENTORY CONSTRAINT            ',
     1              'CW_PRESSURE_DROP_CONSTRAINT     ',
     1              'EFFL_PRESSURE_DROP_CONSTRAINT   ',
     1              'MOL_BALANCE_CONSTRAINT          ',
     1              'SETPOINT_LEVEL                  ',
     1              'SETPOINT_TEMPERATURE            '/
C
C INITIALIZE SENSOR UNITS
C
      DATA UNITS /'KMOL/M3 ',
     1            'M3/MIN  ',
     1            'C       ',
     1            'M       ',
     1            'KMOL/M3 ',
     1            'KMOL/M3 ',
     1            'C       ',
     1            'M3/MIN  ',
     1            'M3/MIN  ',
     1            'C       ',
     1            'KG/M2   ',
     1            '% OPEN  ',
     1            '% OPEN  ',
     1            'M3/MIN  ',
     1            'M3      ',
     1            'M3/MIN  ',
     1            'M3/MIN  ',
     1            'KMOL    ',
     1            'M       ',
     1            'C       '/
C
C INITIALIZE SENSOR FAULT MODE NAMES
C
      DATA FMODE /'FIXED BIAS ','FIXED VALUE '/
C
C INITIALIZE NUMERICAL DATA
C
      DATA CNT /74.7,0.9,59.3/
      DATA FLOW /0.25,0.25,0.00,0.25,0.9,0.00,0.00,0.9/
C Ph.D. Thesis Finch, p. 322 FLOW=Q
C	Q1=Feed flowrate (constant flow into the tank, nominal value 0.25), associated fault nr: 12 (abnormal feed flowrate)
C	Q2=flowrate between tank exit and division into leak flow Q3 and effluent flow Q4
C	Q3=leak flowrate, modeled by resistance R2 (high resistance=small leak)
C	Q4=Effluent flowrate, nominal value 0.25 (incoming into tank=outgoing product flowrate from system, without leaking)
C
C	Cooling system:
C	Q5=Cooling flowrate (constant flow into the tank, nominal value 0.9), calculated
C	Q6=Flowrate from cooling circuit through jacket into reactor, associated fault nr: 5 (jacket leak to tank), diminish resistance R7
C	Q7=Flowrate from cooling circuit into exterior area, associated fault nr: 4 (jacket leak to environment), diminish resistance R8
C	Q8=Effluent cooling circuit flowrate, nominal value 0.9 (incoming into jacket=outgoing from jacket, without leaking into tank or environment)
C
C
C
C
      DATA (SAMP(1,I),I=1,21) /1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     1  16,17,18,19,20,20/
      DATA (SAMP(2,I),I=1,21) /2,4,8,9,11,15,16,17,0,0,0,0,0,0,
     1                          0,0,0,0,8,0,0/
      DATA (SAMP(3,I),I=1,21) /3,7,10,12,13,14,0,0,0,0,0,0,0,0,0,0,
     1  0,0,6,0,0/
C
      DATA SP  /2.00,80.0,0.9/  ! Set points of the controllers: REACTOR LEVEL, REACTOR TEMP, COOLING WATER FLOW RATE
      DATA SDEV /0.15,0.002,0.15,0.01,0.02,0.14,0.15,0.003,0.002,
     1     0.15,400.0,0.01,0.01,0.0001,0.005,0.005,0.01,0.5,0.001,0.01/
      DATA ERROR /0.00,0.00,0.00/
      DATA DERROR /0.00,0.00,0.00/
C
      DATA (EXTENT0(I),I=1,3) /0.0,0.0,0.0/
      DATA (DELAY(I),I=1,3) /0.0,0.0,0.0/
      DATA (DEXT(I),I=1,3)  /0.0,0.0,0.0/
      DATA (DEXT0(I),I=1,3) /0.0,0.0,0.0/
      DATA (TC(I),I=1,3)  /0.0,0.0,0.0/
C
      DATA R      /100.0,1000000.0,0.00,500.0,72.0,0.00,1000000.0,
     1               1000000.0,0.00,65.0/
      DATA R0     /100.0,1000000.0,0.00,500.0,72.0,0.00,1000000.0,
     1               1000000.0,0.00,65.0/
      DATA REG1 /0.00,0.00,0.00/
      DATA REG2 /0.00,0.00,0.00/
      DATA T     /30.0,80.0,20.0,40.0/
      DATA THETA /1.0/
      DATA V     /74.7,59.3/
C
      DATA (B(I,1),I=1,3) /35.0,-0.040,-25.0/
      DATA (B(I,2),I=1,3) /5.00,-0.020,-75.0/
      DATA (B(I,3),I=1,3) /0.00,0.00,0.00/
C
      DATA (MEAS(I,1),I=1,20)  /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1   0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0,2.0,80.0/
C
      DATA (MEAS(I,2),I=1,20)  /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1   0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0,2.0,80.0/
C
      DATA (NORMVAL(I),I=1,20) /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1   0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0,2.0,80.0/


C      data LEVEL /0.2/  ! Original value is wrong, since in first simlation loop is 2m
      data LEVEL /2.0/  ! CSTR level at t=0
      data MASSBAL /0.0/
      data EPD /0.0/
      data CWPD /0.0/
      data MOLBAL /0.0/

      open(unit=prot,file='log.txt',status='replace')
      write(prot,*) 'Opening protocol file ''log.txt''...'
      write(*,*) 'Opening protocol file ''log.txt''...'
      open(unit=dataout,file='X.csv',status='replace')
      write(*,*) 'Opening output data file ''X.csv''...'
      csvsep = char(9)      ! char(9)=TAB
      csvsep = ';'
C     Number of features
      write(dataout,'(A2)') '20'




C
C INITIALIZE SCALAR VARIABLES
C
      ALPHA1      =     2500.0D0
      BETA1       =     25000.0D0
      ALPHA2      =     3000.0D0
      BETA2       =     45000.0D0
      CA0         =     20.0D0
      CA          =     2.850D0  ! CA+CB+CC = 19.9866 --- Shoudn't it be 20.0?
      CB          =     17.114D0
      CCNOM       =     0.0226D0
      CC          =     CCNOM
      CP          =     4.20D0
      CP1         =     4.20D0
      CP2         =     4.20D0
      DT          =     0.02D0
      FF          =     0.10D0
      FINTEG      =     0.0D0
      JEP         =     0.0D0
      MOLIN       =     0.0D0
      MOLOUT      =     0.0D0
      N           =     20
      PB          =     2000.0D0
      PCW         =     56250.0D0
      PP          =     48000.0D0
      PP0         =     48000.0D0
      QREAC1      =     30000.0D0
      QREAC2      =     -10000.0D0
      QEXT        =     0.0D0
      REP         =     0.0D0
      RHO         =     1000.0D0
      RHO1        =     1000.0D0
      RHO2        =     1000.0D0
      S0          =     0
      S3          =     0
      S4          =     0
      S7          =     0
      S8          =     0
      TAREA       =     1.5D0
      TIME        =     0.0D0
      UA          =     1901.0D0
      VOL         =     3.0D0
C
C PLOT QUERY
C
      WRITE (*,800)
C      WRITE (*,735)
C      READ (*,*) S6
C      IF (S6 .EQ. 1) GOTO 550
C      IF (S6 .EQ. 1) THEN
C          CALL SIMPLOT(DATAFILE,N,NORMVAL,MEAS,SDEV,SENSORS,UNITS)
C          STOP
C      ENDIF
C
C OPEN OUTPUT FILE FOR RAW DATA DUMP (MIDAS FORMAT)
C
      WRITE (*,700)
      READ (*,710) DATAFILE
C      IF (DATAFILE .EQ. '') THEN
      IF (DATAFILE(1:1) .EQ. ' ') THEN
        DATAFILE='DUMP.RAW'
      ENDIF
C
      OPEN (UNIT=14,FILE=DATAFILE)
C
C ENTER DATE STAMP DATA
C
C  WRITE (*,720)
C  READ (*,730) MON,DAY,YEAR
      MON=1
      DAY=1
      YEAR=2016
C
      call date_and_time(dummy(1), dummy(2), dummy(3), date_time)
C      print *,'year=',date_time(1)
C      print *,'month_of_year=',date_time(2)
C      print *,'day_of_month=',date_time(3)
      YEAR=date_time(1)
      MON=INT2(date_time(2))
      DAY=INT2(date_time(3))
C      print *,'YEAR=',YEAR
C      print *,'MON=',MON
C      print *,'DAY=',DAY
C
C CONTROLLER TUNING (OPTIONAL)
C
600   CONTINUE
C      WRITE (*,740)
C      READ (*,*) TUNE
C      IF (TUNE .EQ. 0) GOTO 650
C610   WRITE (*,745)
C      READ (*,*) TUNEI
C      IF ((TUNEI .GT. 4) .OR. (TUNEI .LT. 1)) GOTO 610
C620   WRITE (*,750)
C      READ (*,*) TUNEJ
C      IF ((TUNEJ .GT. 3) .OR. (TUNEJ .LT. 1)) GOTO 620
C      WRITE (*,760) B(TUNEI,TUNEJ)
C      READ (*,*) B(TUNEI,TUNEJ)
C      GOTO 600
650   CONTINUE
C
C ENTER EXPONENTIAL FILTER CONSTANT (1=NO EWMA)
C
C660   WRITE (*,770)
C      READ (*,*) THETA
C      IF ((THETA .LE. 0.0) .OR. (THETA .GT. 1.0)) GOTO 660
C
C ENTER PRINT FORMAT
C
C      WRITE (*,772)
C      READ (*,*) S7
C      WRITE (*,773)
C      READ (*,*) S8
C
C COMPUTE SEED FOR RANDOM NUMBER GENERATOR
C
      WRITE (*,790)
      READ (*,*) ISEED
      DSEED=DBLE(ISEED)
C
C ENTER FAULT INFORMATION
C
20    CONTINUE
      DO 30 I=1,23
        WRITE(*,810) I,FTYPE(I)
30    CONTINUE
C
35    S0=S0 + 1
      WRITE (*,820)
      READ (*,*) F(S0)
      DO 37 I=1,(S0-1)
      IF (F(I) .EQ. F(S0)) THEN
        WRITE (*,822)
        WRITE (*,823)
        READ (*,*) S6
        IF (S6 .EQ. 1) GOTO 37
        S0=S0 - 1
        GOTO 40
      ENDIF
37    CONTINUE
      IF (F(S0) .EQ. 1) GOTO 40
      IF (F(S0) .EQ. 23) THEN
        WRITE (*,821) (I,SENSORS(I),I=1,14)
        WRITE (*,825)
        READ (*,*) S1(S0)
        WRITE (*,830)
        READ (*,*) S2(S0)
        WRITE (*,*) 'NOMINAL VALUE IS : ' ,MEAS(S1(S0),1)
      ELSE
      IF (F(S0) .EQ. 2) WRITE (*,835) R(1)
      IF (F(S0) .EQ. 3) WRITE (*,835) R(9) ! 'BLOCKAGE IN JACKET', ! Fault 3
      IF (F(S0) .EQ. 4) WRITE (*,835) R(8)
      IF (F(S0) .EQ. 5) WRITE (*,835) R(7)
      IF (F(S0) .EQ. 6) WRITE (*,835) R(2)
      IF (F(S0) .EQ. 7) WRITE (*,835) PP
      IF (F(S0) .EQ. 8) WRITE (*,835) UA
      IF (F(S0) .EQ. 9) WRITE (*,835) QEXT
      IF (F(S0) .EQ. 10) WRITE (*,835) BETA1
      IF (F(S0) .EQ. 11) WRITE (*,835) BETA2
      IF (F(S0) .EQ. 12) WRITE (*,835) FLOW(1)
      IF (F(S0) .EQ. 13) WRITE (*,835) T(1)
      IF (F(S0) .EQ. 14) WRITE (*,835) CA0
      IF (F(S0) .EQ. 15) WRITE (*,835) T(3)
      IF (F(S0) .EQ. 16) WRITE (*,835) PCW
      IF (F(S0) .EQ. 17) WRITE (*,835) JEP
      IF (F(S0) .EQ. 18) WRITE (*,835) REP
      IF (F(S0) .EQ. 19) WRITE (*,835) SP(1)
      IF (F(S0) .EQ. 20) WRITE (*,835) SP(2)
      IF (F(S0) .EQ. 21) WRITE (*,835) 100.0D0 - V(1)
      IF (F(S0) .EQ. 22) WRITE (*,835) 100.0D0 - V(2)
      ENDIF
      WRITE (*,840)
      READ (*,*) EXTENT0(S0)
      WRITE (*,850)
      READ (*,*) DELAY(S0)
C     IF (F(S0) .GE. 20) GOTO 40
      WRITE (*,860)
      READ (*,*) TC(S0)
40    IF (S0 .GE. 3) GOTO 42
      WRITE (*,865)
      READ (*,*) S6
      IF (S6 .EQ. 1) GOTO 20
42    M=S0
      WRITE (*,870)
      READ (*,*) TH
      WRITE (*,873)
      READ (*,*) ZLIM
      IF (ZLIM .EQ. 0.0) THEN
        ZLIM=TH
        GOTO 45
      ENDIF
      WRITE (*,875)
      READ (*,*) ZLIM
45    ZLIM=ZLIM/DT
      ZCOUNT=IDNINT(ZLIM)
C
C
C     Extension: Allow dynamic manipulation of setpoints of reactor level and temperature (SP1 SP2)
      write (*,'(5X,A)')
     1   'Dynamically change controller setpoints? [0=NO, 1=YES]'
      READ (*,*) SPDYN
      IF (SPDYN .EQ. 0) GOTO 680
      SPDYNN1=0
      SPDYNN2=0
C     read all setpoint changes
      write(*,'(5X,A)')
     1   'Number of setpoint changes for level controller?'
      read(*,*) SPDYNN1
      do i=1,SPDYNN1
        write(*,'(5X,A,I3)')
     1    'Enter time instant [min] and value of change # ',i
        read(*,*) SPDYN1T(i), SPDYN1VAL(i)
      enddo

      write(*,'(5X,A)')
     1     'Number of setpoint changes for temperature controller?'
      read (*,*) SPDYNN2
      do i=1,SPDYNN2
        write(*,'(5X,A,I3)')
     1    'Enter time instant [min] and value of change # ',i
        read(*,*) SPDYN2T(i), SPDYN2VAL(i)
      enddo
680   CONTINUE
C
C Give Report of simulation parameters
C
C      write(*,*) 'Feedback...'

      if (SPDYN .NE. 0) then
        write(*,'(/,10X,A,/)')
     1      'CONTROLLER SETPOINTS DYNAMICALLY CHANGED'
      else
        write(*,'(//,10X,A,3F8.3)')
     1     'CONTROLLER SETPOINTS FIXED AT ',SP(1),SP(2)!,SP(3)
      endif
      do i=1,SPDYNN1
        write(*,'(10X,2(A,I3),2(A,F8.2))')
     1   'Level setpoint: Change ',i ,' of ',SPDYNN1,
     1   ' - Time instant= ',SPDYN1T(i),' Value=',SPDYN1VAL(i)
      enddo
      do i=1,SPDYNN2
        write(*,'(10X,2(A,I3),2(A,F8.2))')
     1   'Temp. setpoint: Change ',i,' of ',SPDYNN2,
     1    ' - Time instant= ',SPDYN2T(i),' Value=',SPDYN2VAL(i)
      enddo

      DO 47 S0=1,M
      IF (F(S0) .EQ. 23) THEN
        WRITE (*,880) FTYPE(F(S0)),SENSORS(S1(S0)),FMODE(S2(S0)+1),
     1  EXTENT0(S0),DELAY(S0)
      ELSE
        WRITE (*,890) FTYPE(F(S0)),EXTENT0(S0),DELAY(S0),TC(S0)
      ENDIF
47    CONTINUE
      WRITE (*,895) THETA
      WRITE (*,950)     ! RUNNING.....
C
C
C
C======================================================================
C TOP OF MAIN ITERATION LOOP
C======================================================================
C
50    CONTINUE
C
C EVENTUALLY CHANGE SET POINT
C
C      write(*,'(1x,A,I2,3(A,F8.3))')
C     1   'SPDYN=',SPDYN,' TIME=',TIME,' SP1=',SP(1),' SP2=',SP(2)
      if (SPDYN .NE. 0) then
        do i=1,SPDYNN1
          if (SPDYN1T(i).GE.TIME .AND. SPDYN1T(i).LT.(TIME+DT)) then
            SP(1) = SPDYN1VAL(i)
            write(prot,*) 'Setting level controller setpoint to ',SP(1),
     1                 ' at time ',TIME
          endif
        enddo
        do i=1,SPDYNN2
          if (SPDYN2T(i).GE.TIME.AND.SPDYN2T(i).LT.(TIME+DT)) then
            SP(2) = SPDYN2VAL(i)
            write(prot,*) 'Setting temperature controller setpoint to ',
     1                 SP(2),' at time ',TIME
          endif
        enddo
      endif
      call noise(SP(1),19,DSEED)
      call noise(SP(2),20,DSEED)
C
C
C
C INTRODUCE FAULT

      classstr='undefined'
      posclassstr=0
      fcnt=0   ! fault counter
C
      DO 60 S0=1,M

      if( fcnt.eq.0 ) classstr='normal'
      
      IF ((F(S0) .EQ. 1).OR.(TIME .LT. DELAY(S0))) GOTO 60 ! Normal or delay not yet reached
C
C Produce class string at time t
C
      fcnt=fcnt+1
      if( fcnt.eq.1 ) then
        classstr='       '
        posclassstr=0
      endif
C
      
      if( S0 .eq. 1 ) then
        if (F(S0).le.10) then
          write(auxstr,'(I1)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
        else
          write(auxstr,'(I2)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(2:2)
        end if
      end if
      if( S0 .eq. 2 ) then
        if( fcnt .gt. 1) then
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = '_'
        endif
        if (F(S0).le.10) then
          write(auxstr,'(I1)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
        else
          write(auxstr,'(I2)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(2:2)
        end if
      end if
      if( S0 .eq. 3 ) then
        if( fcnt .gt. 1) then
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = '_'
        endif
        if (F(S0).le.10) then
          write(auxstr,'(I1)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
        else
          write(auxstr,'(I2)') F(S0)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(1:1)
          posclassstr=posclassstr+1
          classstr(posclassstr:posclassstr) = auxstr(2:2)
        end if
      end if

C
C CALCULATE EXTENT DIFFERENTIAL
C
      IF (DEXT0(S0) .EQ. 0.0) THEN
        IF (F(S0) .EQ. 2) DEXT0(S0)=EXTENT0(S0) - R(1) ! Fault BLOCKAGE AT TANK OUTLET, R(1) nominal=100
        IF (F(S0) .EQ. 3) DEXT0(S0)=EXTENT0(S0) - R(9)
        IF (F(S0) .EQ. 4) DEXT0(S0)=EXTENT0(S0) - R(8)
        IF (F(S0) .EQ. 5) DEXT0(S0)=EXTENT0(S0) - R(7)
        IF (F(S0) .EQ. 6) DEXT0(S0)=EXTENT0(S0) - R(2)
        IF (F(S0) .EQ. 7) DEXT0(S0)=EXTENT0(S0) - PP
        IF (F(S0) .EQ. 8) DEXT0(S0)=EXTENT0(S0) - UA ! Fault JACKET EXCHANGE SURFACE FOULING
        IF (F(S0) .EQ. 9) DEXT0(S0)=EXTENT0(S0) - QEXT
        IF (F(S0) .EQ. 10) DEXT0(S0)=EXTENT0(S0) - BETA1
        IF (F(S0) .EQ. 11) DEXT0(S0)=EXTENT0(S0) - BETA2
        IF (F(S0) .EQ. 12) DEXT0(S0)=EXTENT0(S0) - FLOW(1)
        IF (F(S0) .EQ. 13) DEXT0(S0)=EXTENT0(S0) - T(1)
        IF (F(S0) .EQ. 14) DEXT0(S0)=EXTENT0(S0) - CA0
        IF (F(S0) .EQ. 15) DEXT0(S0)=EXTENT0(S0) - T(3)
        IF (F(S0) .EQ. 16) DEXT0(S0)=EXTENT0(S0) - PCW
        IF (F(S0) .EQ. 17) DEXT0(S0)=EXTENT0(S0) - JEP
        IF (F(S0) .EQ. 18) DEXT0(S0)=EXTENT0(S0) - REP
        IF (F(S0) .EQ. 19) DEXT0(S0)=EXTENT0(S0) - SP(1) ! Fault 'ABNORMAL LEVEL CONTROLLER SETPOINT'
        IF (F(S0) .EQ. 20) DEXT0(S0)=EXTENT0(S0) - SP(2)
      ENDIF
C
C CALCULATE FAULT EXTENT EXPONENTIAL GROWTH FUNCTION
C
      DEXT(S0)=EXP(TC(S0)*(DELAY(S0)-TIME))
C
C CALCULATE FAULT EXTENT
C
      IF (F(S0) .EQ. 2) R(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0) ! Fault BLOCKAGE AT TANK OUTLET
      IF (F(S0) .EQ. 3) R(9)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 4) R(8)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0) ! Fault 'JACKET LEAK TO ENVIRONMENT', diminish resistance R(8)
      IF (F(S0) .EQ. 5) R(7)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0) ! Fault 'JACKET LEAK TO TANK', diminish resistance R(7)
      IF (F(S0) .EQ. 6) R(2)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 7) PP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 8) UA=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 9) QEXT=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 10) BETA1=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 11) BETA2=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 12) FLOW(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 13) T(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 14) CA0=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 15) T(3)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 16) PCW=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 17) JEP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 18) REP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 19) SP(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 20) SP(2)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
C
60    CONTINUE
C
C      write(*,*) 'M=',M,' S0=',S0,' F(1)=',F(1),' F(2)=',F(2),
C     1   ' F(3)=',F(3),' classstr=>>>',classstr,'<<<'
C
100   CONTINUE
C
C ADD NOISE
      call noise(CA0,1,DSEED)
      call noise(FLOW(1),2,DSEED)
      call noise(T(1),3,DSEED)
      call noise(T(3),10,DSEED)
      call noise(PCW,11,DSEED)
C
C CALCULATE CONTROLLER OUTPUTS
C https://en.wikipedia.org/wiki/PID_controller
C https://controls.engin.umich.edu/wiki/index.php/CascadeControl
C
C      DATA SP  /2.00,80.0,0.9/  ! Set points of the controllers: REACTOR LEVEL, REACTOR TEMP, COOLING WATER FLOW RATE
C
C LEVEL CONTROLLER
C REG1(3),REG2(3)       - STORAGE REGISTERS FOR PAST CONTROLLER ERRORS
C ERROR(3)              - VECTOR OF CONTROLLER ERRORS
C DERROR(3)             - VECTOR OF DIFFERENCES BETWEEN ERROR AT SUCCESSIVE TIME STEPS
C B(3,3)                - ARRAY OF CONTROLLER CONSTANTS FOR PID CONTROL K_P=(1,1), K_I=(1,2), K_D=(1,3)
C                         (IF B(1,2)=0 & B(1,3)=0 THEN P CONTROL, IF B(1,3)=0 THEN PI CONTROL)
C      DATA (B(I,1),I=1,3) /35.0,-0.040,-25.0/  K_P for Level controller, temperature controller, flow controller
C      DATA (B(I,2),I=1,3) /5.00,-0.020,-75.0/  K_I for Level controller, temperature controller, flow controller
C      DATA (B(I,3),I=1,3) /0.00,0.00,0.00/     K_D for Level controller, temperature controller, flow controller
C
      REG2(1)=REG1(1)
      REG1(1)=DERROR(1)
      DERROR(1)=ERROR(1) - (SP(1) - MEAS(4,1))  ! SP(1)=setpoint Level; MEAS(4,1)=LEVEL
      ERROR(1)=ERROR(1) - DERROR(1)
      CNT(1)=MIN(100.0D0,MAX(0.0D0,CNT(1)-B(1,1)*DERROR(1)
     1 +B(1,2)*(0.5D0*DERROR(1)+ERROR(1))*DT
     2 +B(1,3)*(2.0D0*REG1(1)-0.5D0*REG2(1)-1.5D0*DERROR(1))/DT))
      call noise(CNT(1),12,DSEED)
C
C REACTOR TEMPERATURE CONTROLLER
C
      REG2(2)=REG1(2)
      REG1(2)=DERROR(2)
      DERROR(2)=ERROR(2) - (SP(2) - MEAS(7,1))  ! SP(2)=setpoint CSTR temperature; MEAS(7,1)=CSTR temperature
      ERROR(2)=ERROR(2) - DERROR(2)
      CNT(2)=MAX(0.0D0,CNT(2)-B(2,1)*DERROR(2)
     1 +B(2,2)*(0.5D0*DERROR(2)+ERROR(2))*DT
     2 +B(2,3)*(2.0D0*REG1(2)-0.5D0*REG2(2)-1.5D0*DERROR(2))/DT)
      call noise(CNT(2),14,DSEED)
C
C COOLING WATER FLOW CONTROLLER
C
      REG2(3)=REG1(3)
      REG1(3)=DERROR(3)
      DERROR(3)=ERROR(3) - (SP(3) - MEAS(8,1))  ! SP(3)=cooling water flowrate; MEAS(8,1)=inflow cooling water (FLOW(5))
      ERROR(3)=ERROR(3) - DERROR(3)
      CNT(3)=MIN(100.0D0,MAX(0.0D0,CNT(3)-B(3,1)*DERROR(3)
     1 +B(3,2)*(0.5D0*DERROR(3)+ERROR(3))*DT
     2 +B(3,3)*(2.0D0*REG1(3)-0.5D0*REG2(3)-1.5D0*DERROR(3))/DT))
      call noise(CNT(3),13,DSEED)
C
C EVALUATE SAFETY SYSTEMS
C
C Attention: Only a message is issued and a flag is set, simulation continues util reaching timeout, no simulation abort
C
C
      IF ((MEAS(4,1) .GE. 2.75).OR.(MEAS(7,1) .GE. 130.0)) THEN ! MEAS(4,1)=LEVEL, MEAS(7,1)=T(2)=Reactor temperature
        IF (S3 .EQ. 1) GOTO 150  ! If inflow FLOW(1) is already closed, continue normally
        DO 110 S0=1,M
        IF (F(S0) .EQ. 12) THEN  ! Eliminate Fault 12, ABNORMAL FEED FLOWRATE, because inflow has been set to zero
             EXTENT0(S0)=0.0D0
             DEXT0(S0)=0.0D0
        ENDIF
110     CONTINUE
        FLOW(1)=0.0D0          ! Close inflow FLOW(1)
        S3=1                   ! Set closed inflow flag true
        WRITE (*,970) TIME     ! '***** EMERGENCY SHUTDOWN INITIATED AT '
        WRITE (prot,970) TIME
      ELSEIF (MEAS(4,1) .LE. 1.2) THEN ! MEAS(4,1)=LEVEL, reactor below level
        IF (S4 .EQ. 1) GOTO 150 ! If pump is already shut down, continue normally
        DO 120 S0=1,M
        IF (F(S0) .EQ. 7) THEN ! Eliminate Fault 7, LOSS OF PUMP PRESSURE, because pump head has been set to zero
             EXTENT0(S0)=0.0D0
             DEXT0(S0)=0.0D0
        ENDIF
120     CONTINUE
        PP=0.0D0               ! Shut down pump, no more pump head
        S4=1                   ! Set shut down pump flag true
        WRITE (*,980) TIME     ! '***** LOW LEVEL FORCES PUMP SHUTDOWN AT '
        WRITE (prot,980) TIME
      ENDIF
C
C CALCULATE VALVE POSITIONS
C
150   DO 160 S0=1,M
      IF ((F(S0) .EQ. 21) .AND. (TIME .GE. DELAY(S0))) THEN
        V(1)=100.0D0 - EXTENT0(S0)*(1.0D0-DEXT(S0))
      ELSE
        V(1)=MIN(100.0D0,MAX(0.0D0,100.0D0-MEAS(12,2))) ! MEAS(12,2)=CNT(1)
      ENDIF
      IF ((F(S0) .EQ. 22) .AND. (TIME .GE. DELAY(S0))) THEN
        V(2)=100.0D0 - EXTENT0(S0)*(1.0D0-DEXT(S0))
      ELSE
        V(2)=MIN(100.0D0,MAX(0.0D0,100.0D0-MEAS(13,2))) ! MEAS(13,2)=CNT(3)
      ENDIF
160   CONTINUE
C
C CALCULATE FLOWRATES
C
C Valve resistances from the valve positions obtained from valve controllers
C
      R(3)=5.0D0 * EXP(0.0545D0*V(1))
      R(6)=5.0D0 * EXP(0.0545D0*V(2))
C
C Combined pipe, valve and leak resistances: Finch p. 319, p. 322
C RE = R_effluent
      RE=(1/((1/R(2))+(1/(R(3)+R(4)))))+R(1)
      RC=(1/((1/R(7))+(1/R(8))+(1/(R(9)+R(10)))))+R(5)+R(6)
C
C NOTE: THESE FORMULAS WILL NOT WORK WELL IF BOTH AN
C ABNORMAL EFFLUENT PRESSURE AND A LEAK ARE SIMULATED
C
C JEP = Jacket effluent pressure (fault 17, nominal zero)
C REP = Reactor effluent pressure (fault 18, nominal zero)
C PCW = COOLING WATER SUPPLY PRESSURE, nominal 56250.0 KG/M^2 
C Simulates probably some obstruction
C
      aux=(PP+PB-REP)
      if (aux .le. 0) THEN
        FLOW(2)=0
      else
        FLOW(2)=(1D0/RE)*aux**0.5D0
      endif
      aux = ((PP+PB-REP)-(FLOW(2)*R(1))**2.0D0)
      if (aux .le. 0) THEN
        FLOW(3)=0
      else
        FLOW(3)=(1D0/R(2))*aux**0.5D0
      endif
      FLOW(4)=FLOW(2)-FLOW(3)
      call noise(FLOW(4),9,DSEED)
C
      FLOW(5)=(1D0/RC)*(PCW-JEP)**0.5D0
      call noise(FLOW(5),8,DSEED)
      aux=(PCW-JEP-(FLOW(5)*(R(5)+R(6)))**2.0D0)
      if (aux .le. 0) THEN
        FLOW(6)=0
        FLOW(7)=0
      else
        FLOW(6)=(1D0/R(7))*aux**0.5D0
        FLOW(7)=(1D0/R(8))*aux**0.5D0
      endif
      FLOW(8)=FLOW(5)-FLOW(6)-FLOW(7)
C      if (.TRUE.) then
      if (.FALSE.) then
      write(prot,'(1x,A,8(A,e12.5),A,3(f7.2),2(A,f6.2,A),4(A,f12.2))')
     1    'FLOWRATES Q=',
     1    ' Q1=',FLOW(1),' Q2=',FLOW(2),' Q3=',FLOW(3),' Q4=',FLOW(4),
     1    ' Q5=',FLOW(5),' Q6=',FLOW(6),' Q7=',FLOW(7),' Q8=',FLOW(8),
     1    '  CONTROLLERS=',CNT(1),CNT(2),CNT(3),
     1    '  VALVE POS: V(1)=',V(1),'%',' V(2)=',V(2),'%',
     1    '  R: R(5)=',R(5),' R(6)=',R(6),' R(7)=',R(7),' R(8)=',R(8)
      endif

C
C CALCULATE JACKET TEMPERATURE
C
      T(4)=(UA*T(2)+RHO2*CP2*FLOW(8)*T(3)) / (UA+RHO2*CP2*FLOW(8))
C
C CALCULATE HEAT FLUX
C
      QJAC=UA*(T(2)-T(4))
C
C CALCULATE CSTR VARIABLES
C
C LEVEL/VOLUME/DENSITY/HEAT CAPACITY
C
220   VOLD=VOL
      RHOLD=RHO
      CPOLD=CP
C
      VOL=VOLD+(FLOW(1)+FLOW(6)-FLOW(2))*DT
      RHO=(1/VOL)*(VOLD*RHO)+
     1 (1/VOL)*(DT*(FLOW(1)*RHO1+FLOW(6)*RHO2-FLOW(2)*RHO))
C
      CP=(1/VOL)*(VOLD*CP)+
     1 (1/VOL)*(DT*(FLOW(1)*CP1+FLOW(6)*CP2-FLOW(2)*CP))
C
      LEVEL=VOL/TAREA
      call noise(LEVEL,4,DSEED)
C      if (.TRUE.) then
      if (.FALSE.) then
      write(prot,'(1x,6(A,e12.5))') 'Level=', LEVEL, ' RHO=',RHO,
     1    ' RHO1=',RHO1, ' RHO2=',RHO2, ' CP=',CP, ' VOL=',VOL
      endif

      IF (LEVEL .LE. 0.0) THEN
        WRITE (*,*) 'FAILURE DUE TO LOW LEVEL'
        STOP
      ENDIF
      PB=RHO*LEVEL
C
C CONCENTRATIONS p. 235, https://en.wikipedia.org/wiki/Arrhenius_equation
C
C http://www.nyu.edu/classes/tuckerman/pchem/lectures/lecture_21.pdf
C
C
      RRATE1=ALPHA1*EXP(-BETA1/(8.314D0*(273.15D0+T(2))))*CA
      RRATE2=ALPHA2*EXP(-BETA2/(8.314D0*(273.15D0+T(2))))*CA
C
      CA=(1/VOL)*(VOLD*CA)+
     1 (1/VOL)*(FLOW(1)*CA0-FLOW(2)*CA-RRATE1*VOLD-RRATE2*VOLD)*DT
      call noise(CA,5,DSEED)
C
      CB=(1/VOL)*(VOLD*CB)+
     1 (1/VOL)*(RRATE1*VOLD-FLOW(2)*CB)*DT
      call noise(CB,6,DSEED)
C
      CC=(1/VOL)*(VOLD*CC)+
     1 (1/VOL)*(RRATE2*VOLD-FLOW(2)*CC)*DT
C
C TEMPERATURE
C
      T(2)=(1/(VOL*RHO*CP))*(VOLD*RHOLD*CPOLD*T(2))+
     1 (1/(VOL*RHO*CP))*(((QREAC1*RRATE1+QREAC2*RRATE2)*VOLD)*DT)+
     1 (1/(VOL*RHO*CP))*((QEXT-QJAC)*DT)+
     1 (1/(VOL*RHO*CP))*(FLOW(1)*RHO1*CP1*T(1)*DT)+
     1 (1/(VOL*RHO*CP))*(FLOW(6)*RHO2*CP2*T(4)*DT)-
     1 (1/(VOL*RHO*CP))*(FLOW(2)*RHOLD*CPOLD*T(2)*DT)
      call noise(T(2),7,DSEED)
C
C MEASURE SENSED VARIABLES
C
      MEAS(1,2)=CA0
      MEAS(2,2)=FLOW(1)
      MEAS(3,2)=T(1)
      MEAS(4,2)=LEVEL
      MEAS(5,2)=CA
      MEAS(6,2)=CB
      MEAS(7,2)=T(2)
      MEAS(8,2)=FLOW(5)
      MEAS(9,2)=FLOW(4)
      MEAS(10,2)=T(3)
      MEAS(11,2)=PCW ! COOLING WATER SUPPLY PRESSURE, nominal 56250.0 KG/M^2  
      MEAS(12,2)=100.0D0 - CNT(1)
      MEAS(13,2)=100.0D0 - CNT(3)
      MEAS(14,2)=CNT(2)
C Additionally put the setpoints into the measure vector
      MEAS(19,2)=SP(1)
      MEAS(20,2)=SP(2)
C
C MODIFY SENSOR READINGS
C
C CALL GGNML(A,B,C)
C
C GGNML IS A GAUSIAN RANDOM NUMBER GENERATOR PRODUCING A VECTOR C
C OF NORMAL (0,1) RANDOM NUMBERS OF DIMENSION B. THE SEED (A) MUST
C BE DOUBLE PRECISION.
C
      DO I=1,14
C        measold = MEAS(I,2)
        CALL GGNML(DSEED,3,RAND)
        DO S0=1,M
          IF ((F(S0) .EQ. 23) .AND. (TIME .GE. DELAY(S0))) THEN
            IF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 0)) THEN
              MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)+
     1           EXTENT0(S0)*(1.0D0-DEXT(S0))
            ELSEIF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 1)) THEN
              MEAS(I,2)=EXTENT0(S0)*(1.0D0-DEXT(S0))
            ELSE
              MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
            ENDIF
          ELSE
            MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
          ENDIF
C        write(*,'(1x,A,I4,A,e12.5,A,e12.5,A)') 'NOISE:MEAS #',
C     1         I,' ',measold,' --> ',MEAS(I,2),' <==='
        ENDDO
      ENDDO
250   CONTINUE
C
C CALCULATE EXPONENTIAL WEIGHTED MOVING AVERAGE FOR USE IN CONTROLLERS
C
      DO I=1,14
        MEAS(I,1)=THETA*MEAS(I,2) + (1.0D0 - THETA)*MEAS(I,1)
      ENDDO
260   CONTINUE
C
C
      DO I=19,20
C        measold = MEAS(I,2)
        CALL GGNML(DSEED,3,RAND)
        DO S0=1,M
          IF ((F(S0) .EQ. 23) .AND. (TIME .GE. DELAY(S0))) THEN
            IF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 0)) THEN
              MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)+
     1          EXTENT0(S0)*(1.0D0-DEXT(S0))
            ELSEIF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 1)) THEN
              MEAS(I,2)=EXTENT0(S0)*(1.0D0-DEXT(S0))
            ELSE
              MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
            ENDIF
          ELSE
            MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
          ENDIF
C        write(*,'(1x,A,I4,A,e12.5,A,e12.5,A)') 'NOISE:MEAS #',
C     1         I,' ',measold,' --> ',MEAS(I,2),' <==='
        ENDDO
      ENDDO
280   CONTINUE
C
C CALCULATE EXPONENTIAL WEIGHTED MOVING AVERAGE FOR USE IN CONTROLLERS
C
      DO 290 I=19,20
        MEAS(I,1)=THETA*MEAS(I,2) + (1.0D0 - THETA)*MEAS(I,1)
290   CONTINUE
C
C EVALUATE QUANTITATIVE CONSTRAINTS:
C
C INVENTORY, COOLING WATER PRESSURE DROP, EFFLUENT PRESSURE DROP
C
C INVENTORY CONSTRAINT
C
      FINTEG=FINTEG+(MEAS(2,2)-MEAS(9,2))*DT ! MEAS(2,2)=FLOW(1), MEAS(9,2)=FLOW(4)
      MASSBAL=TAREA*MEAS(4,2)-FINTEG-3.00D0 ! MEAS(4,2)=L, L(t=0)=0.2 ==> A*L_0=3.0
C
C EFFLUENT FLOW CONSTRAINT
C
      PBCOMP=RHO1*MEAS(4,2) ! MEAS(4,2)=L
      RCOMP(3)=5.0D0*EXP(0.0545D0*(100.0D0-MEAS(12,2))) ! MEAS(13,2)=CNT(1), MEAS(9,2)=FLOW(4)
      EPD=MEAS(9,2)-
     1 ((1D0/(RCOMP(3)+R0(1)+R0(4)))*(PBCOMP+PP0)**0.5D0)
C
C COOLING WATER FLOW CONSTRAINT
C
      RCOMP(6)=5.0D0*EXP(0.0545D0*(100.0D0-MEAS(13,2))) ! MEAS(13,2)=CNT(2), MEAS(8,2)=FLOW(5), MEAS(11,2)=PCW
      CWPD=MEAS(8,2)-
     1 ((1/(RCOMP(6)+R0(5)+R0(9)+R0(10)))*MEAS(11,2)**0.5D0)
C
C MOL BALANCE CONSTRAINT: MEAS: 1=CA0; 2=FLOW(1); 3=T(1); 4=L; 5=CA; 6=CB, 9=FLOW(4)
C
      sumConcABC = MEAS(5,2)+MEAS(6,2)+CCNOM
      dmolin=MEAS(1,2)*MEAS(2,2)*DT
      dmolout=sumConcABC*MEAS(9,2)*DT
      MOLIN=MOLIN+dmolin
      MOLOUT=MOLOUT+dmolout
      mol=sumConcABC*TAREA*MEAS(4,2)
      MOLBAL=mol-60.0D0-MOLIN+MOLOUT ! Mol balance, cA(t=0)*V(t=0)=20*3=60
C
C DETERMINE VALUES OF CONSTRAINTS FROM SENSORS
C
      MEAS(15,2)=MASSBAL
      MEAS(16,2)=CWPD
      MEAS(17,2)=EPD
      MEAS(18,2)=MOLBAL
C
C
C CONVERT TIME TO HOURS, MINUTES, AND SECONDS (DFRAC WAS NOT IN THE CODE)
C
      SEC=IDNINT(DFRAC(TIME)*60D0)
      TEMP=(TIME-DFRAC(TIME))/60D0
      HOUR=IDNINT(TEMP-DFRAC(TEMP))
      MINUTE=IDNINT((TIME-DFRAC(TIME))-(TEMP-DFRAC(TEMP))*60D0)
C
      IF (SEC .EQ. 60) THEN
        SEC=0
        MINUTE=MINUTE + 1
      ENDIF
C
C PRINT UPDATED STATUS
C
      IF ((ZCOUNT .EQ. IDNINT(ZLIM/3.0D0)).AND.(S8 .EQ. 1)) THEN
      SS=3
      ELSEIF ((ZCOUNT .EQ. IDNINT(ZLIM/1.5D0)).AND.(S8 .EQ. 1)) THEN
      SS=3
      ELSEIF ((ZCOUNT .EQ. IDNINT(ZLIM/2.0D0)).AND.(S8 .EQ. 1)) THEN
      SS=2
      ELSEIF (ZCOUNT .EQ. IDNINT(ZLIM)) THEN
      ZCOUNT=0
      SS=1
      ELSE
      GOTO 500
      ENDIF
C
C PRINT TO RAW DATA OUTPUT FILE
C
C LIST SENSOR READINGS IN RANDOM ORDER
C
C CALL GGUBS(A,B,C)
C
C GGUBS IS A UNIFORM RANDOM NUMBER GENERATOR PRODUCING A VECTOR C
C OF UNIFORM (0,1) RANDOM NUMBERS OF DIMENSION B. THE SEED (A) MUST
C BE DOUBLE PRECISION.
C
      DO 261 J=1,20
      RO(J,1)=SAMP(SS,J)
      RO(J,2)=SAMP(SS,J)
261   CONTINUE
      IF (S7 .EQ. 0) GOTO 266
      CALL GGUBS(DSEED,20,RV)
      DO 265 J=1,SAMP(SS,21)
      K=IDNINT(RV(J)*20.0D0+0.5D0)
262   IF (RO(K,1) .NE. 0) THEN
      RO(J,2)=RO(K,1)
      RO(K,1)=0
      ELSE
      K=K+1
      IF (K .GT. 20) K=1
      GOTO 262
      ENDIF
265   CONTINUE
C
C WRITE SENSOR READING TO FILE, char(9)=TAB
C
C266   write(*,'(1x,A,i6,A,i6)')
C     1             'SS=',SS, 'SAMP(SS,21)=', SAMP(SS,21)
266   DO 270 J=1,SAMP(SS,21)
      WRITE (14,999) SENSORS(RO(J,2)),YEAR,MON,DAY,HOUR,MINUTE,SEC,
     1 MEAS(RO(J,2),2),UNITS(RO(J,2))
270   CONTINUE
      write(dataout,'(20(e15.5,A1),A1,A10)')
     1               (MEAS(I,2),csvsep,I=1,18),SP(1),csvsep,
     1               SP(2),csvsep,' ',classstr
C
C CHECK FOR TERMINATION AND ITERATE
C
C NOTE: SIMPLOT IS A SUBPROGRAM USED CREATING DATA FILES FOR PPLOT AND
C    CAN BE REMOVED WITHOUT OTHER MODIFICATIONS.
C
500   TIME=TIME + DT
      ZCOUNT=ZCOUNT + 1
      SP(3)=MEAS(14,2)  ! MEAS(14,2)=CNT(2)
      IF (TIME .GT. (TH + DT)) THEN
        WRITE (*,960)
        CLOSE (UNIT=14)
C        WRITE (*,990)   ! 'PERFORM ANOTHER RUN? [0=NO , 1=YES]'
C        READ (*,*) S5
C        IF (S5 .EQ. 1) GOTO 5
C        WRITE (*,995)   ! PLOT RESULTS? [0=NO , 1=YES]
C        READ (*,*) S6
C        IF (S6 .EQ. 1) THEN
550       CONTINUE
C          CALL SIMPLOT(DATAFILE,N,NORMVAL,MEAS,SDEV,SENSORS,UNITS)
C        ENDIF

C ZCOUNT                - COUNTER FOR PRINTING OUTPUT
        write(prot,'(1x,A,f10.2,A,i6,A,f10.2,A,f7.3)')
     1    'Closing at TIME=',TIME,'  Print output counter=',ZCOUNT,
     1    '  Time Horizon=',TH,'  Delta t=',DT
        write(*,*) 'Closing protocol file ''log.txt''...'
        close(prot)
        write(*,*) 'Closing data output file ''X.csv''...'
        close(dataout)

        STOP
      ENDIF
C
C END OF MAIN LOOP
C ITERATE FOR NEXT TIME STEP
C
      GOTO 50
C
C FORMAT STATEMENTS
C
700   FORMAT (/,5X,'ENTER OUTPUT FILE NAME [DEFAULT=DUMP.RAW]')
710   FORMAT (A32)
720   FORMAT (/,5X,'ENTER DATE STAMP [MM/DD/YYYY] ')
730   FORMAT (I2,1X,I2,1X,I4)
735   FORMAT (/,5X,'PLOT RESULTS OF PREVIOUS RUN? [0=NO , 1=YES] ')
740   FORMAT (/,5X,'OVERRIDE CONTROLLER TUNING ? [0=NO , 1=YES] ')
745   FORMAT (/,5X,'INDICATE CONTROLLER:',3X,'1=CONTROLLER',
     1 /,28X,'2=TEMPERATURE CONTROLLER',
     1 /,28X,'3=RECYCLE FLOW CONTROLLER',
     1 /,28X,'4=COOLING WATER FLOW CONTROLLER ')
750   FORMAT (/,5X,'ENTER PARAMETER TO CHANGE:',3X,'1=GAIN',
     1 /,34X,'2=INTEGAL'
     1 /,34X,'3=DERIVATIVE ')
760   FORMAT (/,5X,'ENTER NEW VALUE [CURRENT VALUE IS ',F10.4,'] ')
770   FORMAT (/,5X,'ENTER FILTER CONSTANT [0.0 - 1.0] ')
772   FORMAT (/,5X,'PRINT OUTPUT IN RANDOM ORDER? [0=NO , 1=YES] ')
773   FORMAT (/,5X,'VARIABLE OUTPUT FREQUENCY? [0=NO , 1=YES] ')
775   FORMAT (5X,F4.2)
790   FORMAT (/,5X,'ENTER INTEGER SEED FOR RANDOM NUMBER GENERATOR ')
800   FORMAT (//,5X,'*** JACKETED CSTR DYNAMIC SIMULATION ***',/)
810   FORMAT (5X,I2,') ',A40)
820   FORMAT (5X,'ENTER DESIRED FAULT TYPE ')
821   FORMAT (//,15X,'PROCESS SENSORS ARE : ',//,15(5X,I4,' ',A,/)
     1 ,//)
822   FORMAT (/,5X,'INDICATED FAULT HAS ALREADY BEEN SELECTED! ')
823   FORMAT (/,5X,'CONTINUE? [0=NO , 1=YES) ')
825   FORMAT (/,5X,'ENTER NUMBER OF FAILED SENSOR ')
830   FORMAT (/,5X,'ENTER TYPE OF SENSOR FAILURE: O=FIXED BIAS',
     1 /,35X,'1=FIXED VALUE ')
835   FORMAT (/,5X,'NOMINAL VALUE IS: ',3X,F14.4)
840   FORMAT (/,5X,'ENTER EXTENT OF FAULT (IN APPROPRIATE UNITS) ')
850   FORMAT (/,5X,'ENTER FAULT DELAY [min] ')
860   FORMAT (/,5X,'ENTER TIME CONSTANT [(min)-1]: ')
865   FORMAT (/,5X,'ADD ANOTHER FAULT? [0=NO , 1=YES] ')
870   FORMAT (/,5X,'ENTER TIME HORIZON FOR SIMULATION [min] ')
873   FORMAT (/,5X,'PRINT INTERMEDIATE RESULTS? [1=YES/0=NO] ')
875   FORMAT (/,5X,'ENTER PRINT INTERVAL [min] ')
880   FORMAT (//,10X,'PROCESS CONDITION IS -- ',A40,
     1   /,28X,'IN ',A32,
     2   //,10X,'SENSOR FAULT IS TYPE -- ',A12,
     3   /,10X,'FAULT EXTENT IS  -- ',F8.2,
     4   /,10X,'FAULT DELAY IS   -- ',F8.2,' (MIN)')
890   FORMAT (//,10X,'PROCESS CONDITION IS -- ',A40,
     1   //,10X,'FAULT EXTENT IS  --',F8.2,
     2   /,10X,'FAULT DELAY IS   --',F8.2,' (MIN)',
     3   /,10X,'TIME CONSTANT IS  --',F8.2)
895   FORMAT (/,10X,'FILTER CONSTANT IS  --',F8.2)
930   FORMAT (/)
940   FORMAT (5X,A36,' IS ',A16)
950   FORMAT (/,5X,'RUNNING.....',/)
960   FORMAT (/,5X,'END OF RUN',/)
970   FORMAT (//,5X,'***** EMERGENCY SHUTDOWN INITIATED AT ',F6.2,
     1   ' MIN ',//)
980   FORMAT (//,5X,'***** LOW LEVEL FORCES PUMP SHUTDOWN AT ',F6.2,
     1   ' MIN ',//)
990   FORMAT (/,5X,'PERFORM ANOTHER RUN? [0=NO , 1=YES] ')
995   FORMAT (/,5X,'PLOT RESULTS? [0=NO , 1=YES] ')
999   FORMAT (A32,I4,I2,I2,I2,I2,I2,F14.4,A7)
C
      END

C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C+++++++++++++  ROUTINES NOT IN THE ORIGINAL CODE  ++++++++++++++++++++
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C----------------------------------------------------------------------
C Add noise to a recently updated variable
      subroutine noise(var,I,DSEED)
      REAL*8 var,varold
      REAL*8 DSEED,RAND(1)
      INTEGER I

      return ! Do not add any noise
      NOISESCAL = 1D-4
C      NOISESCAL = 0D0
      varold = var
      CALL GGNML(DSEED,1,RAND)
      var=var * (1.0D0 + NOISESCAL*RAND(1))
C      write(*,'(1x,A,I4,A,e30.20,A,e30.20)')
C     1    'NOISE: var #',
C     1    I,' ',varold,' --> ',var
      return
      end
C----------------------------------------------------------------------

C++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C----------------------------------------------------------------------
C Fractional part of double precision real value
      REAL*8 FUNCTION DFRAC( X )
      REAL*8 X
      DFRAC = X-INT(X)
      RETURN
      END
C----------------------------------------------------------------------

C Position of first trailing blank in string
      integer function postrailblank( str )
      character str*(*)
      integer i
      
      i = len(str)
C      write(*,*) 'strlen=', i, ' str=', str
      
      do while( str(i:i) .eq. ' ' .and. i .gt. 0 )
C        write(*,*) 'str(',i,')=', str( i:i )
        i = i - 1
      end do

      postrailblank = I
C      write(*,*) 'postrailblank=', postrailblank
      return
      end
C----------------------------------------------------------------------


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DUMMY IMPLEMENTATION

      SUBROUTINE SIMPLOT(DATAFILE,N,NORMVAL,MEAS,SDEV,SENSORS,UNITS)

      CHARACTER*8 UNITS(20)
      CHARACTER *32 SENSORS(20),DATAFILE,gnufile*40
      INTEGER *4 N, i
      REAL *8 NORMVAL(20),SDEV(20),MEAS(20,2)
C
      WRITE(*,*) 'Executing SIMPLOT ...'
C      WRITE(*,*) 'dummy function. Not yet implemented ...'
C      gnufile=adjustr(trim(DATAFILE)//'.gnu')
C      OPEN (UNIT=15,FILE=gnufile)
C      write(*,*) 'Opening plot file ''',gnufile,''''
C      write(*,*) 'n=',N
C      write(*,*) (i,SENSORS(i),i=1,N)
C      write(*,*) (i,':',NORMVAL(i),' ',MEAS(i,1),' ',SDEV(i),i=1,N)
C
C
C      write(*,*) 'Closing plot file ''',gnufile,''''
C      CLOSE(UNIT=15)
      RETURN
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
