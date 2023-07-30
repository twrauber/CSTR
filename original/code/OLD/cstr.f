C
C**********************************************************************
C Automated fault diagnosis of chemical process plants using model-based reasoning
C Download: http://dspace.mit.edu/bitstream/handle/1721.1/14194/22192007.pdf?sequence=1
C Author: Finch, Francis Eric
C Citable URI: http://hdl.handle.net/1721.1/14194
C Other Contributors: Massachusetts Institute of Technology. Dept. of Chemical Engineering.
C Advisor: Mark A. Kramer.
C Department: Massachusetts Institute of Technology. Dept. of Chemical Engineering.
C Publisher: Massachusetts Institute of Technology
C Date Issued: 1989
C Description:
C Thesis (Ph. D.)--Massachusetts Institute of Technology, Dept. of Chemical Engineering, 1989.
C   Science hard copy bound in 2 v.Includes bibliographical references C (leaves 300-307).
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
C CAO                   - FEED CONCENTRATION (A) (KMOL/M3)
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
C MEAS(18,2)            - ARRAY OF PROCESS MEASUREMENTS; COL 2 IS
C                          MOST RECENT, COL1 IS EWMA HISTORY
C MINUTE                - MINUTE STAMP
C MOLBAL                - MOL BALANCE CONSTRAINT RESIDUAL (KMOL)
C MOLIN                 - CUMULATIVE MOL INFLUX (KMOL)
C MOLOUT                - CUMULATIVE MOL OUTFLUX (KMOL)
C MON                   - MONTH STAMP
C N                     - TOTAL NUMBER OF SENSORS AND CONSTRAINTS
C NORMVAL(18)           - ARRAY OF NORMAL STEADY STATE PROCESS MEASUREMENTS
C PB,PBCOMP             - PRESSURE AT TANK OUTLET (KG/M2)
C PCW                   - COOLING WATER SUPPLY PRESSURE (KG/M2)
C PP,PP0                - PUMP DIFFERENTIAL PRESSURE (KG/M2)
C QEXT                  - EXTERNAL HEAT SOURCE(SINK) TO CSTR (KJ/MIN)
C QJAC                  - HEAT TRANSFERED IN HEAT EXCHANGER (KJ/MIN)
C QREAC1                - PRIMARY HEAT OF REACTION (KJ/KMOL)
C QREAC2                - SECONDARY HEAT OF REACTION (KJ/KMOL)
C R(10)                 - VECTOR OF FLOW RESISTANCES (MIN KG^0.5/M4)
C RAND(3)               - RANDOM NUMBER VECTOR
C RCOMP(10)             - COMPUTED VALUES FOR FLOW RESISTANCE
C                         BASED ON SENSOR MEASUREMENT DATA
C REG1 (3),
C REG2(3)               - STORAGE REGISTERS FOR PAST CONTROLLER ERRORS
C RHO,RHOLD             - DENSITY OF REACTOR CONTENTS (KG/M3)
C RHO1                  - DENSITY OF FEED (KG/M3)
C RHO2                  - DENSITY OF COOLING WATER (KG/M3)
C R0(10)                - NOMINAL VALUES FOR FLOW RESISTANCE (MIN KG^0.5/M4)
C RRATE1                - RATE OF PRIMARY REACTION IN CSTR (KMOL/M3 MIN)
C RRATE2                - RATE OF SECONDARY REACTION IN CSTR (KMOL/M3 MIN)
C RC                    - OVERALL RESISTANCE FOR CW STREAM (MIN KG^0.5/M4)
C RE                     - OVERALL RESISTANCE FOR EFFLUENT STREAM (MIN KG^0.5/M4)
C S0,S1,S2,S3,
C S4,S5,S6              - PROGRAM CONTROL PARAMETERS
C SDEV(18)              - STANDARD DEVIATION OF RANDOM SENSOR NOISE
C SEC                   - SECOND STAMP
C SENSORS(18)           - CHARACTER ARRAY OF SENSOR NAMES
C SP(3)                 - VECTOR OF CONTROLLER SETPOINTS
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
C UNITS(18)             - CHARACTER ARRAY OF SENSOR UNI1S
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
      REAL *8  ALPHA1,ALPHA2,BETA1,BETA2,B(3,3),CAO,CA,CB,CC,CNT(3),
     1         CP,CPOLD,CP1,CP2,CWPD,DELAY(3),DERROR(3),
     1         DEXT(3),DEXT0(3),DSEED,DT,EPD,
     1         ERROR(3),EXTENT0(3),FF,FINTEG,FLOW(8),JEP,
     1         LEVEL,MASSBAL,MEAS(18,2),MOLBAL,MOLIN,MOLOUT,
     1         NORMVAL(18),PB,PBCOMP,         DFRAC, ! Additional func
     1         PCW,PP,PP0,QEXT,QJAC,QREAC1,QREAC2,R(10),RAND(3),
     1         RCOMP(10),REG1(3),REG2(3),REP,RHO,RHOLD,RHO1,RHO2,
     1         R0(10),RRATE1,RRATE2,RC,RE,RV(18),SP(3),SDEV(18),T(4),
     1         TAREA,TC(3),TEMP,TH,THETA,TIME,UA,V(2),VOL,VOLD,ZLIM
C
C INTEGER VARIABLES
C
      INTEGER I,J,K
      INTEGER *2 DAY,F(3),HOUR,MINUTE,M,MON,RO(18,2),SAMP(3,23),S0,
     1            S1(3),S2(3),S3,S4,S5,S6,S7,S8,SEC,SS,TUNE,TUNEI,
     1            TUNEJ
      INTEGER *4 N,YEAR,ZCOUNT
      INTEGER *4 ISEED
C
C CHARACTER VARIABLES
C
      CHARACTER *8   UNITS(18)
      CHARACTER *12  FMODE(2)
      CHARACTER *32  SENSORS(18),DATAFILE
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
     1            'BLOCKAGE AT TANK OUTLET                 ',
     1            'BLOCKAGE IN JACKET                      ',
     1            'JACKET LEAK TO ENVIRONMENT              ',
     1            'JACKET LEAK TO TANK                     ',
     1            'LEAK FROM PUMP                          ',
     1            'LOSS OF PUMP PRESSURE                   ',
     1            'JACKET EXCHANGE SURFACE FOULING         ',
     1            'EXTERNAL HEAT SOURCE (SINK)             ',
     1            'PRIMARY REACTION ACTIVATION ENERGY      ',
     1            'SECONDARY REACTION ACTIVATION ENERGY    ',
     1            'ABNORMAL FEED FLOWRATE                  ',
     1            'ABNORMAL FEED TEMPERATURE               ',
     1            'ABNORMAL FEED CONCENTRATION             ',
     1            'ABNORMAL COOLING WATER TEMPERATURE      ',
     1            'ABNORMAL COOLING WATER PRESSURE         ',
     1            'ABNORMAL JACKET EFFLUENT PRESSURE       ',
     1            'ABNORMAL REACTOR EFFLUENT PRESSURE      ',
     1            'ABNORMAL LEVEL CONTROLLER SETPOINT      ',
     1            'ABNORMAL TEMPERATURE CONTROLLER SETPOINT',
     1            'CONTROL VALVE (CV-1) STUCK              ',
     1            'CONTROL VALVE (CV-2) STUCK              ',
     1            'SENSOR FAULT                            '/
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
     1              'MOL_BALANCE_CONSTRAINT          '/
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
     1            'KMOL    '/
C
C INITIALIZE SENSOR FAULT MODE NAMES
C
      DATA FMODE /'FIXED BIAS ','FIXED VALUE '/
C
C INITIALIZE NUMERICAL DATA
C
      DATA CNT /74.7,0.9,59.3/
      DATA FLOW /0.25,0.25,0.00,0.25,0.9,0.00,0.00,0.9/
C
      DATA (SAMP(1,I),I=1,19) /1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     1  16,17,18,18/
      DATA (SAMP(2,I),I=1,19) /2,4,8,9,11,15,16,17,0,0,0,0,0,0,
     1                          0,0,0,0,8/
      DATA (SAMP(3,I),I=1,19) /3,7,10,12,13,14,0,0,0,0,0,0,0,0,0,0,
     1  0,0,6/
C
      DATA SP  /2.00,80.0,0.9/
      DATA SDEV /0.15,0.002,0.15,0.01,0.02,0.14,0.15,0.003,0.002,
     1                 0.15,400.0,0.01,0.01,0.0001,0.005,0.005,0.01,0.5/
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
      DATA V     /74.7,59.3/
C
      DATA (B(I,1),I=1,3) /35.0,-0.040,-25.0/
      DATA (B(I,2),I=1,3) /5.00,-0.020,-75.0/
      DATA (B(I,3),I=1,3) /0.00,0.00,0.00/
C
      DATA (MEAS(I,1),I=1,18)  /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1             0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0/
C
      DATA (MEAS(I,2),I=1,18)  /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1             0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0/
C
      DATA (NORMVAL(I),I=1,18) /20.0,0.25,30.0,2.00,2.85,17.11,80.0,
     1             0.9,0.25,20.0,56250.0,25.3,41.7,0.9,0.0,0.0,0.0,0.0/
C
C INITIALIZE SCALAR VARIABLES
C
      ALPHA1      =     2500.0
      BETA1       =     25000.0
      ALPHA2      =     3000.0
      BETA2       =     45000.0
      CAO         =     20.0
      CA          =     2.850
      CB          =     17.114
      CC          =     0.0226
      CP          =     4.20
      CP1         =     4.20
      CP2         =     4.20
      DT          =     0.02
      FF          =     0.10
      FINTEG      =     0.0
      JEP         =     0.0
      MOLIN       =     0.0
      MOLOUT      =     0.0
      N           =     18
      PB          =     2000.0
      PCW         =     56250.0
      PP          =     48000.0
      PP0         =     48000.0
      QREAC1      =     30000.0
      QREAC2      =     -10000.0
      QEXT        =     0.0
      REP         =     0.0
      RHO         =     1000.0
      RHO1        =     1000.0
      RHO2        =     1000.0
      S0          =     0
      S3          =     0
      S4          =     0
      S7          =     0
      S8          =     0
      TAREA       =     1.5
      TIME        =     0.0
      UA          =     1901.0
      VOL         =     3.0
C
C PLOT QUERY
C
      WRITE (*,800)
      WRITE (*,735)
      READ (*,*) S6
C      IF (S6 .EQ. 1) GOTO 550
      IF (S6 .EQ. 1) THEN
          CALL SIMPLOT(DATAFILE,N,NORMVAL,SDEV,SENSORS,UNITS)
          STOP
      ENDIF
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
      MON=6
      DAY=1
      YEAR=1989
C
C CONTROLLER TUNING (OPTIONAL)
C
600   CONTINUE
      WRITE (*,740)
      READ (*,*) TUNE
      IF (TUNE .EQ. 0) GOTO 650
610   WRITE (*,745)
      READ (*,*) TUNEI
      IF ((TUNEI .GT. 4) .OR. (TUNEI .LT. 1)) GOTO 610
620   WRITE (*,750)
      READ (*,*) TUNEJ
      IF ((TUNEJ .GT. 3) .OR. (TUNEJ .LT. 1)) GOTO 620
      WRITE (*,760) B(TUNEI,TUNEJ)
      READ (*,*) B(TUNEI,TUNEJ)
      GOTO 600
650   CONTINUE
C
C ENTER EXPONENTIAL FILTER CONSTANT (1=NO EWMA)
C
660   WRITE (*,770)
      READ (*,*) THETA
      IF ((THETA .LE. 0.0) .OR. (THETA .GT. 1.0)) GOTO 660
C
C ENTER PRINT FORMAT
C
      WRITE (*,772)
      READ (*,*) S7
      WRITE (*,773)
      READ (*,*) S8
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
      IF (F(S0) .EQ. 3) WRITE (*,835) R(9)
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
      IF (F(S0) .EQ. 14) WRITE (*,835) CAO
      IF (F(S0) .EQ. 15) WRITE (*,835) T(3)
      IF (F(S0) .EQ. 16) WRITE (*,835) PCW
      IF (F(S0) .EQ. 17) WRITE (*,835) JEP
      IF (F(S0) .EQ. 18) WRITE (*,835) REP
      IF (F(S0) .EQ. 19) WRITE (*,835) SP(1)
      IF (F(S0) .EQ. 20) WRITE (*,835) SP(2)
      IF (F(S0) .EQ. 21) WRITE (*,835) 100.0 - V(1)
      IF (F(S0) .EQ. 22) WRITE (*,835) 100.0 - V(2)
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
      DO 47 S0=1,M
      IF (F(S0) .EQ. 23) THEN
        WRITE (*,880) FTYPE(F(S0)),SENSORS(S1(S0)),FMODE(S2(S0)+1),
     1  EXTENT0(S0),DELAY(S0)
      ELSE
        WRITE (*,890) FTYPE(F(S0)),EXTENT0(S0),DELAY(S0),TC(S0)
      ENDIF
47    CONTINUE
      WRITE (*,895) THETA
      WRITE (*,950)
C
C TOP OF MAIN ITERATION LOOP
C
50    CONTINUE
C
C INTRODUCE FAULT
C
      DO 60 S0=1,M
      IF ((F(S0) .EQ. 1).OR.(TIME .LT. DELAY(S0))) GOTO 60
C
C CALCULATE EXTENT DIFFERENTIAL
C
      IF (DEXT0(S0) .EQ. 0.0) THEN
        IF (F(S0) .EQ. 2) DEXT0(S0)=EXTENT0(S0) - R(1)
        IF (F(S0) .EQ. 3) DEXT0(S0)=EXTENT0(S0) - R(9)
        IF (F(S0) .EQ. 4) DEXT0(S0)=EXTENT0(S0) - R(8)
        IF (F(S0) .EQ. 5) DEXT0(S0)=EXTENT0(S0) - R(7)
        IF (F(S0) .EQ. 6) DEXT0(S0)=EXTENT0(S0) - R(2)
        IF (F(S0) .EQ. 7) DEXT0(S0)=EXTENT0(S0) - PP
        IF (F(S0) .EQ. 8) DEXT0(S0)=EXTENT0(S0) - UA
        IF (F(S0) .EQ. 9) DEXT0(S0)=EXTENT0(S0) - QEXT
        IF (F(S0) .EQ. 10) DEXT0(S0)=EXTENT0(S0) - BETA1
        IF (F(S0) .EQ. 11) DEXT0(S0)=EXTENT0(S0) - BETA2
        IF (F(S0) .EQ. 12) DEXT0(S0)=EXTENT0(S0) - FLOW(1)
        IF (F(S0) .EQ. 13) DEXT0(S0)=EXTENT0(S0) - T(1)
        IF (F(S0) .EQ. 14) DEXT0(S0)=EXTENT0(S0) - CAO
        IF (F(S0) .EQ. 15) DEXT0(S0)=EXTENT0(S0) - T(3)
        IF (F(S0) .EQ. 16) DEXT0(S0)=EXTENT0(S0) - PCW
        IF (F(S0) .EQ. 17) DEXT0(S0)=EXTENT0(S0) - JEP
        IF (F(S0) .EQ. 18) DEXT0(S0)=EXTENT0(S0) - REP
        IF (F(S0) .EQ. 19) DEXT0(S0)=EXTENT0(S0) - SP(1)
        IF (F(S0) .EQ. 20) DEXT0(S0)=EXTENT0(S0) - SP(2)
      ENDIF
C
C CALCULATE FAULT EXTENT EXPONENTIAL GROWTH FUNCTION
C
      DEXT(S0)=EXP(TC(S0)*(DELAY(S0)-TIME))
C
C CALCULATE FAULT EXTENT
C
      IF (F(S0) .EQ. 2) R(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 3) R(9)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 4) R(8)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 5) R(7)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 6) R(2)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 7) PP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 8) UA=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 9) QEXT=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 10) BETA1=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 11) BETA2=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 12) FLOW(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 13) T(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 14) CAO=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 15) T(3)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 16) PCW=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 17) JEP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 18) REP=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 19) SP(1)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
      IF (F(S0) .EQ. 20) SP(2)=EXTENT0(S0) - DEXT0(S0)*DEXT(S0)
C
60    CONTINUE
C
C CALCULATE CONTROLLER OUTPUTS
C
100   CONTINUE
C
C LEVEL CONTROLLER
C
      REG2(1)=REG1(1)
      REG1(1)=DERROR(1)
      DERROR(1)=ERROR(1) - (SP(1) - MEAS(4,1))
      ERROR(1)=ERROR(1) - DERROR(1)
      CNT(1)=MIN(100.0D0,MAX(0.0D0,CNT(1)-B(1,1)*DERROR(1)
     1 +B(1,2)*(0.5*DERROR(1)+ERROR(1))*DT
     2 +B(1,3)*(2.0*REG1(1)-0.5*REG2(1)-1.5*DERROR(1))/DT))
C
C REACTOR TEMPERATURE CONTROLLER
C
      REG2(2)=REG1(2)
      REG1(2)=DERROR(2)
      DERROR(2)=ERROR(2) - (SP(2) - MEAS(7,1))
      ERROR(2)=ERROR(2) - DERROR(2)
      CNT(2)=MAX(0.0D0,CNT(2)-B(2,1)*DERROR(2)
     1 +B(2,2)*(0.5*DERROR(2)+ERROR(2))*DT
     2 +B(2,3)*(2.0*REG1(2)-0.5*REG2(2)-1.5*DERROR(2))/DT)
C
C COOLING WATER FLOW CONTROLLER
C
      REG2(3)=REG1(3)
      REG1(3)=DERROR(3)
      DERROR(3)=ERROR(3) - (SP(3) - MEAS(8,1))
      ERROR(3)=ERROR(3) - DERROR(3)
      CNT(3)=MIN(100.0D0,MAX(0.0D0,CNT(3)-B(3,1)*DERROR(3)
     1 +B(3,2)*(0.5*DERROR(3)+ERROR(3))*DT
     2 +B(3,3)*(2.0*REG1(3)-0.5*REG2(3)-1.5*DERROR(3))/DT))
C
C EVALUATE SAFETY SYSTEMS
C
      IF ((MEAS(4,1) .GE. 2.75).OR.(MEAS(7,1) .GE. 130.0)) THEN
        IF (S3 .EQ. 1) GOTO 150
        DO 110 S0=1,M
        IF (F(S0) .EQ. 12) THEN
             EXTENT0(S0)=0.0
             DEXT0(S0)=0.0
        ENDIF
110     CONTINUE
        FLOW(1)=0.0
        S3=1
        WRITE (*,970) TIME
      ELSEIF (MEAS(4,1) .LE. 1.2) THEN
        IF (S4 .EQ. 1) GOTO 150
        DO 120 S0=1,M
        IF (F(S0) .EQ. 7) THEN
             EXTENT0(S0)=0.0
             DEXT0(S0)=0.0
        ENDIF
120     CONTINUE
        PP=0.0
        S4=1
        WRITE (*,980) TIME
      ENDIF
C
C CALCULATE VALVE POSITIONS
C
150   DO 160 S0=1,M
      IF ((F(S0) .EQ. 21) .AND. (TIME .GE. DELAY(S0))) THEN
        V(1)=100.0 - EXTENT0(S0)*(1.0-DEXT(S0))
      ELSE
        V(1)=MIN(100.0D0,MAX(0.0D0,100.0-MEAS(12,2)))
      ENDIF
      IF ((F(S0) .EQ. 22) .AND. (TIME .GE. DELAY(S0))) THEN
        V(2)=100.0 - EXTENT0(S0)*(1.0-DEXT(S0))
      ELSE
        V(2)=MIN(100.0D0,MAX(0.0D0,100.0-MEAS(13,2)))
      ENDIF
160   CONTINUE
C
C CALCULATE FLOWRATES
C
      R(3)=5.0 * EXP(0.0545*V(1))
      R(6)=5.0 * EXP(0.0545*V(2))
C
      RE=(1/((1/R(2))+(1/(R(3)+R(4)))))+R(1)
      RC=(1/((1/R(7))+(1/R(8))+(1/(R(9)+R(10)))))+R(5)+R(6)
C
C NOTE: THESE FORMULAS WILL NOT WORK WELL IF BOTH AN
C ABNORMAL EFFLUENT PRESSURE AND A LEAK ARE SIMULATED
C
      FLOW(2)=(1/RE)*(PP+PB-REP)**0.5
      FLOW(3)=(1/R(2))*((PP+PB-REP)-(FLOW(2)*R(1))**2.0)**0.5
      FLOW(4)=FLOW(2)-FLOW(3)
C
      FLOW(5)=(1/RC)*(PCW-JEP)**0.5
      FLOW(6)=(1/R(7))*(PCW-JEP-(FLOW(5)*(R(5)+R(6)))**2.0)**0.5
      FLOW(7)=(1/R(8))*(PCW-JEP-(FLOW(5)*(R(5)+R(6)))**2.0)**0.5
      FLOW(8)=FLOW(5)-FLOW(6)-FLOW(7)
C
C CALCULATE JACKET TEMPERATURE
C
      T(4)=((UA*T(2)+RHO2*CP2*FLOW(8)*T(3))/(UA+RHO2*CP2*FLOW(8)))
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
      IF (LEVEL .LE. 0.0) THEN
        WRITE (*,*) 'FAILURE DUE TO LOW LEVEL'
        STOP
      ENDIF
      PB=RHO*LEVEL
C
C CONCENTRATIONS
C
      RRATE1=ALPHA1*CA*EXP(-BETA1/(8.314*(273.15+T(2))))
      RRATE2=ALPHA2*CA*EXP(-BETA2/(8.314*(273.15+T(2))))
C
      CA=(1/VOL)*(VOLD*CA)+
     1 (1/VOL)*(FLOW(1)*CAO-FLOW(2)*CA-RRATE1*VOLD-RRATE2*VOLD)*DT
C
      CB=(1/VOL)*(VOLD*CB)+
     1 (1/VOL)*(RRATE1*VOLD-FLOW(2)*CB)*DT
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
C
C MEASURE SENSED VARIABLES
C
      MEAS(1,2)=CAO
      MEAS(2,2)=FLOW(1)
      MEAS(3,2)=T(1)
      MEAS(4,2)=LEVEL
      MEAS(5,2)=CA
      MEAS(6,2)=CB
      MEAS(7,2)=T(2)
      MEAS(8,2)=FLOW(5)
      MEAS(9,2)=FLOW(4)
      MEAS(10,2)=T(3)
      MEAS(11,2)=PCW
      MEAS(12,2)=100.0 - CNT(1)
      MEAS(13,2)=100.0 - CNT(3)
      MEAS(14,2)=CNT(2)
C
C MODIFY SENSOR READINGS
C
C CALL GGNML(A,B,C)
C
C GGNML IS A GAUSIAN RANDOM NUMBER GENERATOR PRODUCING A VECTOR C
C OF NORMAL (0,1) RANDOM NUMBERS OF DIMENSION B. THE SEED (A) MUST
C BE DOUBLE PRECISION.
C
      DO 250 I=1,14
        CALL GGNML(DSEED,3,RAND)
        DO 250 S0=1,M
        IF ((F(S0) .EQ. 23) .AND. (TIME .GE. DELAY(S0))) THEN
          IF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 0)) THEN
          MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)+
     1         EXTENT0(S0)*(1.0-DEXT(S0))
          ELSEIF ((I .EQ. S1(S0)) .AND. (S2(S0) .EQ. 1)) THEN
          MEAS(I,2)=EXTENT0(S0)*(1.0-DEXT(S0))
          ELSE
          MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
          ENDIF
        ELSE
        MEAS(I,2)=MEAS(I,2)+RAND(S0)*SDEV(I)
        ENDIF
250   CONTINUE
C
C CALCULATE EXPONENTIAL WEIGHTED MOVING AVERAGE FOR USE IN CONTROLLERS
C
      DO 260 I=1,14
        MEAS(I,1)=THETA*MEAS(I,2) + (1.0 - THETA)*MEAS(I,1)
260   CONTINUE
C
C EVALUATE QUANTITATIVE CONSTRAINTS:
C
C INVENTORY, COOLING WATER PRESSURE DROP, EFFLUENT PRESSURE DROP
C
C INVENTORY CONSTRAINT
C
      FINTEG=FINTEG+(MEAS(2,2)-MEAS(9,2))*DT
      MASSBAL=TAREA*MEAS(4,2)-FINTEG-3.00
C
C EFFLUENT FLOW CONSTRAINT
C
      PBCOMP=RHO1*MEAS(4,2)
      RCOMP(3)=5.0*EXP(0.0545*(100.0-MEAS(12,2)))
      EPD=MEAS(9,2)-
     1 ((1/(RCOMP(3)+R0(1)+R0(4)))*(PBCOMP+PP0)**0.5)
C
C COOLING WATER FLOW CONSTRAINT
C
      RCOMP(6)=5.0*EXP(0.0545*(100.0-MEAS(13,2)))
      CWPD=MEAS(8,2)-
     1 ((1/(RCOMP(6)+R0(5)+R0(9)+R0(10)))*MEAS(11,2)**0.5)
C
C MOL BALANCE CONSTRAINT
C
      MOLIN=MOLIN+MEAS(1,2)*MEAS(2,2)*DT
      MOLOUT=MOLOUT+(MEAS(5,2)+MEAS(6,2)+0.0226)*MEAS(9,2)*DT
      MOLBAL=(MEAS(5,2)+MEAS(6,2)+0.0226)*TAREA*MEAS(4,2)-60.0-
     1 MOLIN+MOLOUT
C
C DETERMINE VALUES OF CONSTRAINTS FROM SENSORS
C
      MEAS(15,2)=MASSBAL
      MEAS(16,2)=CWPD
      MEAS(17,2)=EPD
      MEAS(18,2)=MOLBAL
C
C CONVERT TIME TO HOURS, MINUTES, AND SECONDS (DFRAC WAS NOT IN THE CODE)
C
      SEC=IDNINT(DFRAC(TIME)*60)
      TEMP=(TIME-DFRAC(TIME))/60
      HOUR=IDNINT(TEMP-DFRAC(TEMP))
      MINUTE=IDNINT((TIME-DFRAC(TIME))-(TEMP-DFRAC(TEMP))*60)
C
      IF (SEC .EQ. 60) THEN
        SEC=0
        MINUTE=MINUTE + 1
      ENDIF
C
C PRINT UPDATED STATUS
C
      IF ((ZCOUNT .EQ. IDNINT(ZLIM/3.0)).AND.(S8 .EQ. 1)) THEN
      SS=3
      ELSEIF ((ZCOUNT .EQ. IDNINT(ZLIM/1.5)).AND.(S8 .EQ. 1)) THEN
      SS=3
      ELSEIF ((ZCOUNT .EQ. IDNINT(ZLIM/2.0)).AND.(S8 .EQ. 1)) THEN
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
      DO 261 J=1,18
      RO(J,1)=SAMP(SS,J)
      RO(J,2)=SAMP(SS,J)
261   CONTINUE
      IF (S7 .EQ. 0) GOTO 266
      CALL GGUBS(DSEED,18,RV)
      DO 265 J=1,SAMP(SS,19)
      K=IDNINT(RV(J)*18.0+0.5)
262   IF (RO(K,1) .NE. 0) THEN
      RO(J,2)=RO(K,1)
      RO(K,1)=0
      ELSE
      K=K+1
      IF (K .GT. 18) K=1
      GOTO 262
      ENDIF
265   CONTINUE
C
C WRITE SENSOR READING TO FILE
C
266   DO 270 J=1,SAMP(SS,19)
      WRITE (14,999) SENSORS(RO(J,2)),YEAR,MON,DAY,HOUR,MINUTE,SEC,
     1 MEAS(RO(J,2),2),UNITS(RO(J,2))
270   CONTINUE
C
C CHECK FOR TERMINATION AND ITERATE
C
C NOTE: SIMPLOT IS A SUBPROGRAM USED CREATING DATA FILES FOR PPLOT AND
C    CAN BE REMOVED WITHOUT OTHER MODIFICATIONS.
C
500   TIME=TIME + DT
      ZCOUNT=ZCOUNT + 1
      SP(3)=MEAS(14,2)
      IF (TIME .GT. (TH + DT)) THEN
        WRITE (*,960)
        CLOSE (UNIT=14)
        WRITE (*,990)
        READ (*,*) S5
        IF (S5 .EQ. 1) GOTO 5
        WRITE (*,995)
        READ (*,*) S6
        IF (S6 .EQ. 1) THEN
550       CONTINUE
          CALL SIMPLOT(DATAFILE,N,NORMVAL,SDEV,SENSORS,UNITS)
        ENDIF
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
745   FORMAT (/,5X,'INDICATE CONTROLLER:',3X,'1=LEVEL CONTROLLER',
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
C Fractional part of double precision real value
      REAL*8 FUNCTION DFRAC( X )
      REAL*8 X
      DFRAC = X-INT(X)
      RETURN
      END
C----------------------------------------------------------------------


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DUMMY IMPLEMENTATION

      SUBROUTINE SIMPLOT(DATAFILE,N,NORMVAL,SDEV,SENSORS,UNITS)

      CHARACTER*8 UNITS(18)
      CHARACTER *32 SENSORS(18),DATAFILE
      INTEGER *4 N
      REAL *8 NORMVAL(18),SDEV(18)
C
      WRITE(*,*) 'Executing SIMPLOT ...'
      WRITE(*,*) 'dummy function. Not yet implemented ...'
C
C
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
