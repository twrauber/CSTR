import sys
import os
import numpy as np
import struct
import subprocess
import copy
import warnings
import fortranformat as ff


class Fault():
    """Fault class."""

    def __init__(self,
                 id=None,  # identifier for fault
                           # non-sensor (1,..) and sensor faults (2,3,...)
                 is_sensor_fault=False,
                 sensor_fault_type='bias',  # alternative ='value'
                 EXTENT0=None,
                 DELAY=None,
                 TC=None,  # Time constant
                 verbose=False):

        self.id_min = 2
        self.id_max = 22
        intvalstr = 'Must be in ['+str(self.id_min)+','+str(self.id_max)+'].'
        self.id_sensor_min = 1
        self.id_sensor_max = 14
        intvalsensorstr = ('(Must be in [' + str(self.id_min) +
                           ','+str(self.id_max) + '].)')

        if id is None:
            raise Exception('Fault must have identifier.')
        if EXTENT0 is None:
            raise Exception('Fault must have extent value.')
        if DELAY is None:
            raise Exception('Fault must have delay value.')
        if TC is None:
            raise Exception('Fault must have time constant value.')
        if is_sensor_fault:
            if not (self.id_sensor_min <= id <= self.id_sensor_max):
                raise Exception('Invalid sensor fault id. ' + intvalsensorstr)
        else:
            if not (self.id_min <= id <= self.id_max):
                raise Exception('Invalid fault id. ' + intvalstr)

        self.id = id
        self.is_sensor_fault = is_sensor_fault
        self.sensor_fault_type = sensor_fault_type
        self.EXTENT0 = EXTENT0
        self.DELAY = DELAY
        self.TC = TC
        self.DEXT = 0.0
        self.DEXT0 = 0.0


acronyms = ('c_{A0}', 'Q_{1}', 'T_{1}', 'L', 'c_{A}', 'c_{B}', 'T_{2}',
            'Q_{5}', 'Q_{4}', 'T_{3}', '\mathrm{PCW}',
            '\mathrm{CNT}_{1}', '\mathrm{CNT}_{3}=SP_{Q_{5}}',
            '\mathrm{CNT}_{2}', '\mathrm{INV\ CON}',
            '\mathrm{CW\ DP\ CON}', '\mathrm{EFFL\ DP\ CON}',
            '\mathrm{MOLBAL\ CON}', 'CLASS')


def _print_acronyms(file=sys.stdout, truncate=None):
    numacro = len(acronyms)
    if truncate is not None:
        print('%7s' % '',  end=' ', file=file)
        fmt = '%' + str(truncate) + 's'
        last = truncate + 1
    else:
        fmt = '%30s'
        last = 30

    end = ';'
    for i in range(numacro):
        a = str(acronyms[i][:last])
        # print('a=', a, 'fmt=', fmt)
        if i == numacro - 1:
            end = ''
        print(fmt % a, end=end, file=file)
    print(file=file)


class CSTR():
    """CSTR class."""

    def __init__(self,           # LEVEL, TEMP, COOLFLOW
                 # controller_parm=((35.0, -0.040, -25.0),  # Gain
                 #                 (5.00, -0.020, -75.0), # Integral
                 #                 (0.00, 0.00, 0.00)),   # Derivative
                 #                Gain   Integral Derivative
                 controller_parm=np.array(((35.0, 5.0, 0.0),  # LEVEL
                                           (-0.040, -0.020, 0.0),  # TEMP
                                           (-25.0, -75.0, 0.0))),  # COOLFLOW
                 theta=1.0,  # EWMA (EXP. FILTER) PARMETER
                 randseed=1234,
                 fortran_rand=False,
                 # (Fault number, extent, delay [min], time constant)
                 faults=(),
                 timehoriz=100,
                 verbose=False):

        self.controller_parm = controller_parm
        self.B = self.controller_parm
        # print('cp02=', controller_parm[0][2]); raise Exception
        self.THETA = theta
        self.DSEED = randseed
        self.maxerr = 3     # at most three simultaneous errors

        self.sensors = 14    # 14 sensors + 4 balances
        self.num_constraints = 4
        self.numvar = self.sensors + self.num_constraints    # 14 + 4
        self.faults, self.numfaults = list(faults), len(faults)
        self.classstr = ''
        self.verbose = verbose

        self.outfilename = '/tmp/X_py.csv'
        print('Opening output data file %s.' % self.outfilename)
        self.outfile = open(self.outfilename, mode='w')
        _print_acronyms(self.outfile)
        self.ALPHA1 = 2500.0
        self.BETA1 = 25000.0
        self.ALPHA2 = 3000.0
        self.BETA2 = 45000.0
        self.CA0 = 20.0
        self.CA00 = copy.copy(self.CA0)
        self.CA = 2.850  # CA+CB+CC = 19.9866 --- Shouldn't it be 20.0?
        self.CB = 17.114
        self.CCNOM = 0.0226
        self.CC = self.CCNOM
        self.CP = 4.2
        self.CP1 = 4.2
        self.CP2 = 4.2
        self.DT = 0.02  # time between two sample aquisitions [min]
        self.FINTEG = 0.0
        self.JEP = 0.0
        self.MOLIN = 0.0
        self.MOLOUT = 0.0
        self.PB = 2000.0
        self.PP = 48000.0
        self.PP0 = 48000.0
        self.QREAC1 = 30000.0
        self.QREAC2 = -10000.0
        self.QEXT = 0.0
        self.REP = 0.0
        self.RHO = 1000.0
        self.RHO1 = 1000.0
        self.RHO2 = 1000.0
        self.S3 = False
        self.S4 = False
        self.LEVEL = 2.0
        self.TAREA = 1.5
        self.TIME = 0.0
        self.MINUTES = -1
        self.timehoriz = timehoriz
        self.iter = 0
        # samples per minute = 50 for delta t = 0.02/min
        self.smppermin = int(1.0 / self.DT)
        self.maxiter = self.timehoriz * self.smppermin

        self.UA = 1901.0
        self.VOL = self.TAREA * self.LEVEL
        self.VOL0 = copy.copy(self.VOL)

        self.PCW = 56250.0
        # Set points of the controllers:
        # REACTOR LEVEL, REACTOR TEMP, COOLING WATER FLOW RATE
        self.CNT = np.array([74.7, 0.9, 59.3])
        self.FLOW = np.array([0.25, 0.25, 0.0, 0.25, 0.9, 0.0, 0.0, 0.9])
        self.SP = np.array([2.0, 80.0, 0.9])
        self.SDEV = np.array([0.15, 0.002, 0.15, 0.01, 0.02, 0.14,
                              0.15, 0.003, 0.002, 0.15, 400.0, 0.01,
                              0.01, 0.0001, 0.005, 0.005, 0.01, 0.5])
        self.ERROR = np.zeros(3)
        self.DERROR = np.zeros(3)
        self.R = np.array([100.0, 1e6, 0.0, 500.0, 72.0, 0.0, 1e6,
                           1e6, 0.0, 65.0])
#        self.R = np.array([100.0, 1.570e6, 0.0, 500.0, 72.0, 0.0, 1e6,
#                           1e6, 0.0, 65.0])
        self.R0 = copy.copy(self.R)
        self.RCOMP = np.zeros(10)
        self.REG1 = np.zeros(3)
        self.REG2 = np.zeros(3)
        self.T = np.array([30.0, 80.0, 20.0, 40.0])
        self.V = np.array([74.7, 59.3])
        self.MEAS1 = np.array([20.0, 0.25, 30.0, 2.00, 2.85, 17.11,
                               80.0, 0.9, 0.25, 20.0, 56250.0, 25.3, 40.7, # seems to be wrong since in first loop changes to 40.7 #  41.7,
                               0.9, 0.0, 0.0, 0.0, 0.0])
        self.MEAS2 = copy.copy(self.MEAS1)
        self.NORMVAL = copy.copy(self.MEAS1)

        self.MASSBAL = 0.0
        self.EPD = 0.0
        self.CWPD = 0.0
        self.MOLBAL = 0.0

        self.RE, self.RC = np.nan, np.nan
        self.randbuf = None
        self.fortran_rand = fortran_rand
        if self.fortran_rand:
            # self.fortran_random_generation()
            from rand_fortran import GGNML
            self.GGNML = GGNML
        else:
            np.random.seed(seed=self.DSEED)
        self.dbgvar = np.zeros(10)  # Test variables
        # Test variables for average values
        self.dbg_meas_sum = np.zeros(100)
        self.dbg_meas_sum = copy.copy(self.NORMVAL)
        self.dbg_flow_sum = copy.copy(self.FLOW)

    def close(self):
        print('Closing at iter=%8d t=%8.2f min ...' % (self.iter, self.TIME))
        self.outfile.close()

    def fortran_random_generation(self):
        DSEED = self.DSEED
        MAXSTEPS = self.maxiter
        # File name to write config for Fortran
        fncfg = 'rand_deterministic.cfg'
        with open(fncfg, mode='w') as f:
            f.write(str(DSEED)+'\n')
            f.write(str(MAXSTEPS)+'\n')
            f.close()

        # External call to Fortran to generate the binary
        # file with the random numbers
        prog_fortran = 'rand_deterministic'
        print('Running external Fortran random number generation: %s' %
              prog_fortran)
        # https://docs.python.org/3/library/subprocess.html#subprocess.run
        # devnull = open(os.devnull, 'w')
        # stdout = stderr = devnull
        # stdout = stderr = None
        subprocess.run([prog_fortran])
        # subprocess.run([prog_fortran], stdout=stdout, stderr=stderr)
        # devnull.close()
        # raise Exception()

        # https://stackoverflow.com/questions/20006643/writing-out-a-binary-file-from-fortran-and-reading-in-c
        # https://stackoverflow.com/questions/8710456/reading-a-binary-file-with-python
        # https://docs.python.org/3/library/struct.html#struct.unpack
        # b is important -> binary
        with open('rand_deterministic.bin', mode='rb') as f:
            data = f.read()
            f.close()

        # Cut off first two headers, 4 bytes each
        nbytes = len(data)
        # print('Number of bytes before skip=', nbytes, 'data=', data)
        # data = data[8:]
        nbytes = len(data)
        print('Number of bytes=', nbytes)

        # i = 0
        # DSEED = struct.unpack('<d', data[8*i:8*i+8])[0]
        # i += 1
        # MAXSTEPS = struct.unpack('<d', data[8*i:8*i+8])[0]
        # i += 1
        # print('DSEED=', DSEED, 'MAXSTEPS=', MAXSTEPS)
        # raise Exception()
        #
        # data = data[i*8:]

        self.randbuf = np.zeros(MAXSTEPS*(self.numvar+3))
        cnt = 0
        for i in range(int(nbytes/8)):
            d = data[8*i:8*i+8]
            # print('d=', d)
            value = struct.unpack('<d', d)[0]
            self.randbuf[cnt] = value
            # print('i=', i, 'value=', value)
            cnt += 1
        print('cnt=', cnt)
        print('self.randbuf=', self.randbuf, 'len=', len(self.randbuf))

    def update_affected_param(self, S0):
        f = self.faults[S0]
        if self.TIME < f.DELAY:  # delay not yet reached
            return

        fnr = f.id
        # print('\tActive fault=', f, end='')
        if f.is_sensor_fault:
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            return

        if fnr == 2:  # BLOCKAGE AT TANK OUTLET : Nominal 100
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.R[0]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.R[0] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 3:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.R[8]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.R[8] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 4:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.R[7]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.R[7] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 5:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.R[6]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.R[6] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 6:  # LEAK FROM PUMP : Nominal 1e6
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.R[1]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.R[1] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 7:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.PP
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.PP = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 8:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.UA
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.UA = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 9:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.QEXT
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.QEXT = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 10:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.BETA1
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.BETA1 = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 11:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.BETA2
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.BETA2 = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 12:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.FLOW[0]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.FLOW[0] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 13:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.T[0]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.T[0] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 14:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.CA0
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.CA0 = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 15:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.T[2]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.T[2] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 16:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.PCW
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.PCW = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 17:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.JEP
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.JEP = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 18:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.REP
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.REP = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 19:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.SP[0]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.SP[0] = f.EXTENT0 - f.DEXT0 * f.DEXT

        if fnr == 20:
            if f.DEXT0 == 0.0:
                f.DEXT0 = f.EXTENT0 - self.SP[1]
            f.DEXT = np.exp(f.TC * (f.DELAY - self.TIME))
            self.SP[1] = f.EXTENT0 - f.DEXT0 * f.DEXT

        # CALCULATE FAULT EXTENT EXPONENTIAL GROWTH FUNCTION
        self.faults[S0] = f

    def update_controllers(self):
        #         SP(1)=setpoint Level; MEAS(4,1)=LEVEL
        #         SP(2)=setpoint CSTR temperature; MEAS(7,1)=CSTR temperature
        #         SP(3)=cooling water flowrate; MEAS(8,1)=inflow cooling water (FLOW(5))
        MEAS = [self.MEAS1[3], self.MEAS1[6], self.MEAS1[7]]
        B = self.controller_parm

        for i in range(3):
            self.REG2[i] = self.REG1[i]
            self.REG1[i] = self.DERROR[i]
            dif = self.SP[i] - MEAS[i]
            self.DERROR[i] = self.ERROR[i] - dif
            self.ERROR[i] -= self.DERROR[i]
            '''
            if i == 0:
                print('Error LEVEL_ERROR=%10.5e' % self.ERROR[0],
                       'REG1=', self.REG1[i], 'REG2=', self.REG2[i],
                       'DERROR=', self.DERROR[i], 'MEAS=', MEAS,
                       'SP(1)=',self.SP[i],'dif=', dif)
                if self.iter == 5: raise Exception()
            '''

            aux = (self.CNT[i] - B[i][0] * self.DERROR[i]
                   + B[i][1] * (0.5 * self.DERROR[i] + self.ERROR[i]) * self.DT
                   + B[i][2] * (2.0 * self.REG1[i] - 0.5*self.REG2[i] -
                                1.5 * self.DERROR[i]) / self.DT)
            aux1 = max(0.0, aux)
            if i == 1:
                self.CNT[i] = aux1
            else:
                self.CNT[i] = min(100.0, aux1)
        '''
        DT = self.DT

        self.REG2[0] = self.REG1[0]
        self.REG1[0] = self.DERROR[0]
        self.DERROR[0] = self.ERROR[0] - (self.SP[0] - self.MEAS1[3])
        DERROR = self.DERROR[0]
        self.ERROR[0] -= DERROR
        ERROR = self.ERROR[0]
        self.CNT[0] = min(100,max(0,self.CNT[0]-B[0][0]*DERROR+B[0][1]*
                      (0.5*DERROR+ERROR)*DT+B[0][2]*(2*self.REG1[0]-0.5*self.REG2[0]-1.5*DERROR)/DT))

        self.REG2[1] = self.REG1[1]
        self.REG1[1] = self.DERROR[1]
        self.DERROR[1] = self.ERROR[1] - (self.SP[1] - self.MEAS1[6])
        DERROR = self.DERROR[1]
        self.ERROR[1] -= DERROR
        ERROR = self.ERROR[1]
        self.CNT[1] = max(0,  self.CNT[1]-B[1][0]*DERROR+B[1][1]*
                      (0.5*DERROR+ERROR)*DT+B[1][2]*(2*self.REG1[1]-0.5*self.REG2[1]-1.5*DERROR)/DT)


        self.REG2[2] = self.REG1[2]
        self.REG1[2] = self.DERROR[2]
        self.DERROR[2] = self.ERROR[2] - (self.SP[2] - self.MEAS1[7])
        DERROR = self.DERROR[2]
        self.ERROR[2] -= DERROR
        ERROR = self.ERROR[0]
        self.CNT[2] = min(100,max(0,self.CNT[2]-B[2][0]*DERROR+B[2][1]*
                      (0.5*DERROR+ERROR)*DT+B[2][2]*(2*self.REG1[2]-0.5*self.REG2[2]-1.5*DERROR)/DT))
        '''

        # print('REG2=', self.REG2, 'REG1=', self.REG1, 'DERROR=', self.DERROR,
        #      'ERROR=', self.ERROR, 'CNT=', self.CNT, 'B=', self.B,
        #      'CNT(1)=%.15lf' % self.CNT[0]  ); input('...'); raise Exception

    def evaluate_safety_systems(self):
        MEAS41 = self.MEAS1[3]
        MEAS71 = self.MEAS1[6]
        minlevel = 1.2
        maxlevel = 2.75
        maxtemp = 130.0

        # if not (MEAS41 >= 2.75 or MEAS71 >= 130.0): return
        # MEAS41=LEVEL, MEAS71=T(2)=Reactor temperature
        if MEAS41 >= maxlevel or MEAS71 >= maxtemp:
            # If inflow FLOW(1) is already closed, continue normally
            if not self.S3:
                for i in range(self.numfaults):
                    f = self.faults[i]
                    if not f.is_sensor_fault and f.id == 12:
                        # Eliminate Fault 12, ABNORMAL FEED FLOWRATE, because
                        # inflow has been set to zero
                        self.faults[i].DEXT = 0.0
                        self.faults[i].DEXT0 = 0.0
                self.FLOW[0] = 0.0  # Close inflow FLOW(1)
                self.S3 = True  # Set closed inflow flag true
            reason = ''
            if MEAS41 >= maxlevel:
                reason += 'REACTOR LEVEL AT ' + '{:5.2f}'.format(MEAS41)
            if MEAS71 >= maxtemp:
                reason += 'REACTOR TEMP  ' + '{:5.2f}'.format(MEAS71)
            warnstr = ('***** EMERGENCY SHUTDOWN INITIATED AT ' +
                       '{:5.2f}'.format(self.TIME) + ' --- REASON: ' + reason)
            warnings.warn(warnstr)
            self.shutdown = True

        elif MEAS41 <= minlevel:  # MEAS41=LEVEL
            # If inflow FLOW(1) is already closed, continue normally
            if not self.S4:
                for i in range(self.numfaults):
                    f = self.faults[i]
                    if not f.is_sensor_fault and f.id == 7:
                        # Eliminate Fault 7, LOSS OF PUMP PRESSURE, because
                        # pump head has been set to zero
                        self.faults[i].DEXT = 0.0
                        self.faults[i].DEXT0 = 0.0
                self.PP = 0.0  # Shut down pump, no more pump head
                self.S4 = True  # Set shut down pump flag true
            reason = 'REACTOR LEVEL AT ' + '{:5.2f}'.format(MEAS41)
            warnstr = ('***** LOW LEVEL FORCES PUMP SHUTDOWN AT ' +
                       '{:5.2f}'.format(self.TIME) + ' --- REASON: ' + reason)
            warnings.warn(warnstr)
            self.shutdown = True
        else:
            pass

    def calc_valve_positions(self):
        if self.numfaults == 0:
            self.V[0] = min(100.0, max(0.0, 100.0 - self.MEAS2[11]))
            self.V[1] = min(100.0, max(0.0, 100.0 - self.MEAS2[12]))
        else:
            for i in range(self.numfaults):
                f = self.faults[i]
                if (not f.is_sensor_fault and f.id == 21
                        and self.TIME >= f.DELAY):
                    self.V[0] = 100.0 - f.EXTENT0 * (1.0 - f.DEXT)
                else:
                    # MEAS(12,2)=CNT(1)
                    self.V[0] = min(100.0, max(0.0, 100.0 - self.MEAS2[11]))

                if (not f.is_sensor_fault and f.id == 22
                        and self.TIME >= f.DELAY):
                    self.V[1] = 100.0 - f.EXTENT0 * (1.0 - f.DEXT)
                else:
                    # MEAS(13,2)=CNT(3)
                    self.V[1] = min(100.0, max(0.0, 100.0 - self.MEAS2[12]))
        # print('calc_valve_positions> V(1)=', self.V[0],
        #       'V(2)=', self.V[1]); raise Exception

    def calc_flow_rates(self):
        # Valve resistances from the valve positions obtained from
        # valve controllers
        self.R[2] = 5.0 * np.exp(0.0545*self.V[0])
        self.R[5] = 5.0 * np.exp(0.0545*self.V[1])

        # Combined pipe, valve and leak resistances: Finch p. 319, p. 322
        # RE = R_effluent
        self.RE = (1/((1/self.R[1])+(1/(self.R[2]+self.R[3]))))+self.R[0]
        self.RC = ((1/((1/self.R[6])+(1/self.R[7]) +
                       (1/(self.R[8]+self.R[9]))))+self.R[4]+self.R[5])
        # print('calc_flow_rates> RE=', self.RE, 'RC=', self.RC);
        # raise Exception

        '''
        NOTE: THESE FORMULAS WILL NOT WORK WELL IF BOTH AN
        ABNORMAL EFFLUENT PRESSURE AND A LEAK ARE SIMULATED

        JEP = Jacket effluent pressure (fault 17, nominal zero)
        REP = Reactor effluent pressure (fault 18, nominal zero)
        PCW = COOLING WATER SUPPLY PRESSURE, nominal 56250.0 KG/M^2
        Simulates probably some obstruction
        '''
        aux = (self.PP+self.PB-self.REP)
        if aux <= 0:
            self.FLOW[1] = 0.0
        else:
            self.FLOW[1] = np.sqrt(aux) / self.RE

        aux = (self.PP+self.PB-self.REP)-(self.FLOW[1]*self.R[0])**2.0
        if aux <= 0:
            self.FLOW[2] = 0.0
        else:
            self.FLOW[2] = np.sqrt(aux) / self.R[1]
        self.FLOW[3] = self.FLOW[1] - self.FLOW[2]

        self.FLOW[4] = np.sqrt(self.PCW-self.JEP) / self.RC

        aux = self.PCW-self.JEP-(self.FLOW[4]*(self.R[4]+self.R[5]))**2.0
        if aux <= 0:
            self.FLOW[5] = 0.0
            self.FLOW[6] = 0.0
        else:
            auxsqrt = np.sqrt(aux)
            self.FLOW[5] = auxsqrt / self.R[6]
            self.FLOW[6] = auxsqrt / self.R[7]
        self.FLOW[7] = self.FLOW[4] - self.FLOW[5] - self.FLOW[6]
        '''
        print('aux=%.5f' % aux, 'R(3)=%.5f' % self.R[2],
              'R(6)=%.5f' % self.R[5],
              'RE=%.5f' % self.RE, 'RC=%.5f' % self.RC,
              'FLOW=', self.FLOW, 'VALVEPOS: V(1)=%.5f' % self.V[0],
              'V(2)=%.5f' % self.V[1], 'V(2)=%.5f' % self.V[1],
              'CONTROLLERS: ', self.CNT) # ; input('...');
        print('k=%7d' % self.iter, 'FLOW(1)=', self.FLOW[0], 'FLOW(6)=',
               self.FLOW[5], 'FLOW(2)=', self.FLOW[1], 'LEVEL=', self.LEVEL
               'VOL=', self.VOL)
        '''

    def calc_thermo_level_volume(self):
        # CALCULATE JACKET TEMPERATURE
        self.T[3] = ((self.UA * self.T[1] + self.RHO2 *
                     self.CP2 * self.FLOW[7] * self.T[2]) /
                     (self.UA + self.RHO2 * self.CP2 * self.FLOW[7]))
        # CALCULATE HEAT FLUX
        self.QJAC = self.UA * (self.T[1] - self.T[3])

        # CALCULATE CSTR VARIABLES
        # LEVEL/VOLUME/DENSITY/HEAT CAPACITY
        self.VOLD = self.VOL
        self.RHOLD = self.RHO
        self.CPOLD = self.CP

        self.VOL = (self.VOLD + (self.FLOW[0] + self.FLOW[5] - self.FLOW[1]) *
                    self.DT)
        iVOL = 1 / self.VOL
        self.LEVEL = self.VOL / self.TAREA
        if self.VOL <= 0.0:
            warnstr = ('***** FAILURE DUE TO LOW LEVEL FORCES SHUTDOWN AT ' +
                       '{:5.2f}'.format(self.TIME))
            warnings.warn(warnstr)
            self.PB = 0.0
            self.shutdown = True
        else:
            self.RHO = (iVOL * (self.VOLD * self.RHO) +
                        iVOL *
                        (self.DT * (self.FLOW[0] *
                                    self.RHO1 + self.FLOW[5] *
                                    self.RHO2 - self.FLOW[1] *
                                    self.RHO)))

            self.CP = (iVOL * (self.VOLD * self.CP) +
                       iVOL *
                       (self.DT * (self.FLOW[0] * self.CP1 +
                                   self.FLOW[5] * self.CP2 -
                                   self.FLOW[1] * self.CP)))

            self.PB = self.RHO * self.LEVEL

        # CONCENTRATIONS p. 235, https://en.wikipedia.org/wiki/Arrhenius_equation
        # http://www.nyu.edu/classes/tuckerman/pchem/lectures/lecture_21.pdf

        self.RRATE1 = (self.ALPHA1 * np.exp(
            -self.BETA1 / (8.314 * (273.15 + self.T[1]))) * self.CA)
        self.RRATE2 = (self.ALPHA2 * np.exp(
            -self.BETA2 / (8.314 * (273.15 + self.T[1]))) * self.CA)

        self.CA = (iVOL * (self.VOLD * self.CA) +
                   iVOL * (self.FLOW[0] * self.CA0 -
                           self.FLOW[1] * self.CA - self.RRATE1 *
                           self.VOLD - self.RRATE2 * self.VOLD) *
                   self.DT)

        self.CB = (iVOL * (self.VOLD * self.CB) +
                   iVOL * (self.RRATE1 * self.VOLD -
                           self.FLOW[1] * self.CB) * self.DT)
        self.CC = (iVOL * (self.VOLD * self.CC) +
                   iVOL * (self.RRATE2 * self.VOLD -
                           self.FLOW[1] * self.CC) * self.DT)

        # TEMPERATURE
        aux = self.VOL * self.RHO * self.CP
        iaux = 1 / aux
        self.T[1] = (iaux * (self.VOLD * self.RHOLD * self.CPOLD * self.T[1]) +
                     iaux * (((self.QREAC1 * self.RRATE1 +
                               self.QREAC2 * self.RRATE2) *
                             self.VOLD) * self.DT) +
                     iaux * ((self.QEXT - self.QJAC) * self.DT) +
                     iaux * (self.FLOW[0] * self.RHO1 * self.CP1 *
                             self.T[0] * self.DT) +
                     iaux * (self.FLOW[5] * self.RHO2 * self.CP2 *
                             self.T[3] * self.DT) -
                     iaux * (self.FLOW[1] * self.RHOLD * self.CPOLD *
                             self.T[1] * self.DT))

        '''
        print('T(4)=%.15f' % self.T[3], 'QJAC=%.15f' % self.QJAC,
              'VOL=%.15f' % self.VOL, 'RHO=%.15f' % self.RHO,
               'T(2)=%.15f' % self.T[1], 'RRATE1=%.15f' % self.RRATE1, 'RRATE2=%.15f' % self.RRATE2,
               'CA=%.15f' % self.CA, 'CB=%.15f' % self.CB, 'CC=%.15f' % self.CC )
        # input('...')
        '''


    def measure(self):
        # MEASURE SENSED VARIABLES
        self.MEAS2[0] = self.CA0
        self.MEAS2[1] = self.FLOW[0]
        self.MEAS2[2] = self.T[0]
        self.MEAS2[3] = self.LEVEL
        self.MEAS2[4] = self.CA
        self.MEAS2[5] = self.CB
        self.MEAS2[6] = self.T[1]
        self.MEAS2[7] = self.FLOW[4]
        self.MEAS2[8] = self.FLOW[3]
        self.MEAS2[9] = self.T[2]
        # COOLING WATER SUPPLY PRESSURE, nominal 56250.0 KG/M^2
        self.MEAS2[10] = self.PCW
        self.MEAS2[11] = 100.0 - self.CNT[0]
        self.MEAS2[12] = 100.0 - self.CNT[2]
        self.MEAS2[13] = self.CNT[1]

        # self.peepvars() ; input('...')

        for s in range(self.sensors):
            if self.fortran_rand:
                self.DSEED, RAND = self.GGNML(self.DSEED, 3)
            else:
                RAND = np.random.normal(size=3)

            #RAND = np.random.normal(loc=0.0, scale=1.0, size=3)  # DEBUG
            #self.SDEV[s] = 1.0e-3  # DEBUG

            measold = self.MEAS2[s]
            # print('Sensor=%d' % (s+1), 'iter=', self.iter, 'RAND=', RAND); input('...')

            if self.numfaults == 0:
                self.MEAS2[s] += RAND[0] * self.SDEV[s]
            else:
                for i in range(self.numfaults):
                    f = self.faults[i]
                    aux = RAND[i] * self.SDEV[s]
                    if f.is_sensor_fault and self.TIME >= f.DELAY:
                        if s+1 == f.id and f.sensor_fault_type == 'bias':
                            self.MEAS2[s] += (aux + f.EXTENT0 * (1 - f.DEXT))
                        elif s+1 == f.id and f.sensor_fault_type == 'value':
                            self.MEAS2[s] = f.EXTENT0 * (1 - f.DEXT)
                        else:
                            self.MEAS2[s] += aux
                        '''
                        print('Sensor fault:','Sensor #', s+1, 'type=',
                              f.sensor_fault_type, 'f.id=', f.id, 'S0=', i+1,
                              'F(S0)=',f.id, 'aux=', aux, 'EXTENT0=', f.EXTENT0,
                              'DEXT=', f.DEXT, 'DEXT0=', f.DEXT0,
                              'measold=%.10f' % measold,
                              'MEAS(I,2)=%.10f' % self.MEAS2[s],'iter=',self.iter,
                               'TIME=', self.TIME, 'DELAY=', f.DELAY)  # ;input('...')
                        '''
                    else:
                        # Sum unconditionally from sensor fault noise to sensor reading
                        self.MEAS2[s] += aux

        # print('MEAS(1,2)=',self.MEAS2[0],'TIME=',self.TIME)
        # CALCULATE EXPONENTIAL WEIGHTED MOVING AVERAGE FOR USE IN CONTROLLERS
        for s in range(self.sensors):
            self.MEAS1[s] = (self.THETA*self.MEAS2[s] +
                             (1.0 - self.THETA)*self.MEAS1[s])

    def eval_constraints(self):
        # EVALUATE QUANTITATIVE CONSTRAINTS:

        # INVENTORY CONSTRAINT, Finch p. 236
        # MEAS(2,2)=FLOW(1), MEAS(9,2)=FLOW(4)
        difFLOW1FLOW4 = self.MEAS2[1] - self.MEAS2[8]
        # self.FINTEG += difFLOW1FLOW4 * self.DT
        self.FINTEG += (difFLOW1FLOW4 + self.FLOW[5] - self.FLOW[2]) * self.DT  # <<<<<<<<<<<< CORRECTION
        '''
        print('GREP: k=%10d' % self.iter, 'FINTEG=%20.10f' % self.FINTEG,
              'MEAS(2,2)=FLOW(1)=%20.10f' % self.MEAS2[1],
              'MEAS(9,2)=FLOW(4)=%20.10f' %  self.MEAS2[8],
              'FLOW(3)=%20.10f' % self.FLOW[2], 'dif=%30.20e' % difFLOW1FLOW4,
              'MASSBAL=%30.20e' % self.MASSBAL,
              'dbgvar0=%30.20e' % self.dbgvar[0])
        '''

        # MEAS(4,2)=L, L(t=0)=0.2 ==> A*L_0=3.0
        VOLMEAS = self.TAREA * self.MEAS2[3]
        VOLDIF = VOLMEAS - self.VOL0
        self.MASSBAL = VOLDIF - self.FINTEG

        # EFFLUENT FLOW CONSTRAINT
        self.PBCOMP = self.RHO1 * self.MEAS2[3]  # MEAS(4,2)=L

        # MEAS(13,2)=CNT(1), MEAS(9,2)=FLOW(4)
        self.RCOMP[2] = 5.0 * np.exp(0.0545 * (100.0 - self.MEAS2[11]))

        #
        aux = np.sqrt(self.PBCOMP + self.PP0)
        self.EPD = (self.MEAS2[8] - ((1.0 / (self.RCOMP[2] +
                                             self.R0[0] + self.R0[3]))*aux))

        # COOLING WATER FLOW CONSTRAINT
        # MEAS(13,2)=CNT(2), MEAS(8,2)=FLOW(5), MEAS(11,2)=PCW
        self.RCOMP[5] = 5.0 * np.exp(0.0545 * (100.0 - self.MEAS2[12]))
        aux = self.RCOMP[5] + self.R0[4] + self.R0[8] + self.R0[9]
        self.CWPD = self.MEAS2[7] - (1.0 / aux) * np.sqrt(self.MEAS2[10])

        # MOL BALANCE CONSTRAINT: MEAS: 1=CA0; 2=FLOW(1); 3=T(1);
        #                               4=L; 5=CA; 6=CB, 9=FLOW(4)
        # CA + CB + CC Nominal
        sumConcABC = self.MEAS2[4] + self.MEAS2[5] + self.CCNOM
        # CA0 * FLOW(1) * DT
        dmolin = self.MEAS2[0] * self.MEAS2[1] * self.DT
        # (CA + CB + CC Nominal) * FLOW(4) * DT
        # dmolout = sumConcABC * self.MEAS2[8] * self.DT
        # (CA + CB + CC Nominal) * (FLOW(4)+FLOW(3)) * DT
        dmolout = sumConcABC * (self.MEAS2[8] + self.FLOW[2]) * self.DT  # <<<<<<<<<<<< CORRECTION
        self.MOLIN += dmolin
        self.MOLOUT += dmolout
        mol = sumConcABC * VOLMEAS
        # Mol balance, cA(t=0)*V(t=0)=20*3=60
        self.MOLBAL = mol - self.CA00 * self.VOL0 - self.MOLIN + self.MOLOUT


        # DETERMINE VALUES OF CONSTRAINTS FROM SENSORS
        self.MEAS2[14] = self.MASSBAL
        self.MEAS2[15] = self.CWPD
        self.MEAS2[16] = self.EPD
        self.MEAS2[17] = self.MOLBAL

    def set_classstr(self):
        if self.shutdown:
            self.classstr = 'shutdown'
            return

        active_faults = 0
        for i in range(self.numfaults):
            if self.TIME >= self.faults[i].DELAY:
                active_faults += 1

        self.classstr = 'normal'
        if active_faults > 0:
            self.classstr = ''
            for i in range(active_faults):
                f = self.faults[i]
                if f.is_sensor_fault:
                    self.classstr += 'S'
                else:
                    self.classstr += ''
                self.classstr += str(f.id)
                if i < active_faults-1:
                    self.classstr += '+'

    def measure_out(self):
        M = self.MEAS2
        lineformat = ff.FortranRecordWriter('(E15.5)')
        # print('%6d' % self.iter, file=self.outfile, end='')
        for s in range(self.numvar):
            # print('%15.5E' % M[s], file=self.outfile, end='; ')
            mstr = lineformat.write([M[s]])
            print('%15s' % mstr, file=self.outfile, end=';')
        self.set_classstr()
        # print('TIME=', self.TIME, 'classstr=', classstr)
        print(self.classstr, file=self.outfile)

    def peepvars(self):
        # https://stackoverflow.com/questions/21266850/python-scientific-notation-with-forced-leading-zero
        M = self.MEAS2
        lineformat = ff.FortranRecordWriter('(E15.5)')
        print('k=%6d' % self.iter, end='')
        for s in range(self.numvar):
            mstr = lineformat.write([M[s]])
            print('%15s' % mstr, end=';')
        print()
        # print(self.RE, ';', self.RC)

    def run(self):
        print('Running ...')
        done = False
        self.shutdown = False

        self.measure_out()
        '''
        print('INITIAL VALUES')
        _print_acronyms(truncate=15)
        self.peepvars(); # input('...')
        '''
        while not done and not self.shutdown:
            # print('Iter=%8d t=%8.2f min' % (self.iter, self.TIME), end='')

            for S0 in range(self.numfaults):
                self.update_affected_param(S0)
                # print('\tself.R[0]=%10.5e' % self.R[0], end='>>>'); raise Exception()

            self.update_controllers()

            self.evaluate_safety_systems()

            self.calc_valve_positions()

            self.calc_flow_rates()

            self.calc_thermo_level_volume()

            self.measure()

            self.eval_constraints()

            self.iter += 1
            self.TIME += self.DT
            self.SP[2] = self.MEAS2[13]  # MEAS(14,2)=CNT(2)

            # print('TIME=', self.TIME, 'self.iter % self.smppermin=',
            #       self.iter % self.smppermin); # input('...')
            if self.iter % self.smppermin == 0 or self.shutdown:
                # print('measure_out at =%7d of %7d' % (self.iter, self.maxiter)); input('...')
                self.measure_out()
                self.MINUTES += 1
            # self.peepvars()  # ; input('...')
            print('iter=%10d of %10d -- TIME=%8.2f of %8.2f [min]' %
                  (self.iter, self.maxiter, self.MINUTES, self.timehoriz),
                  end='\r')
            done = self.iter >= self.maxiter # - 1
            # if self.iter == 1: raise Exception()

            # DEBUG AND VERIFICATION
            for s in range(self.numvar):
                self.dbg_meas_sum[s] += self.MEAS2[s]
            for i in range(len(self.FLOW)):
                self.dbg_flow_sum[i] += self.FLOW[i]

            self.dbgvar[0] += self.MEAS2[1] - self.MEAS2[8]
            self.dbgvar[1] += self.FINTEG
            self.dbgvar[2] += self.TAREA * self.MEAS2[3] - self.VOL0  # V(t)-V_0
            self.dbgvar[3] += self.VOL
            self.dbgvar[4] += self.MEAS2[14]
            self.dbgvar[5] += self.FLOW[0] - self.FLOW[3]

        print()


        # DEBUG AND VERIFICAATION
        print('Average values and difference from normal:')
        for s in range(self.numvar):
            iter1 = self.iter + 1
            avg = self.dbg_meas_sum[s]
            print('%3d: = %30s SUM=%17.6f  AVG=%17.6f NORM=%17.6f dif=%17.6f' %
                  (s+1, acronyms[s], avg,
                   avg / iter1, self.NORMVAL[s],
                   avg / iter1 - self.NORMVAL[s]))
        print()

        for i in range(len(self.FLOW)):
            iter1 = self.iter + 1
            avg = self.dbg_flow_sum[i]
            print('%3d: = %30s SUM=%17.6f  AVG=%17.6f NORM=%17.6f dif=%17.6f' %
                  (i+1, 'FLOW' + str(i+1), avg,
                   avg / iter1, self.FLOW[i],
                   avg / iter1 - self.FLOW[i]))

        print('\nFLOWDIF 1-4 Model:  SUM=%17.6f AVG= %17.6f LAST= %17.6f' %
              (self.dbgvar[5], self.dbgvar[5] / iter1, self.FLOW[0] - self.FLOW[3]))
        print('FLOWDIF 1-4 Sensor: SUM=%17.6f AVG= %17.6f LAST= %17.6f' %
              (self.dbgvar[0], self.dbgvar[0] / iter1, self.MEAS2[1] - self.MEAS2[8]))
        print('VOLDIF:  SUM= %17.6f AVG=%17.6f LAST= %17.6f' %
              (self.dbgvar[2], self.dbgvar[2] / iter1, self.TAREA * self.MEAS2[3] - self.VOL0))
        print('FINTEG:  SUM= %17.6f AVG=%17.6f LAST= %17.6f'
              % (self.dbgvar[1], self.dbgvar[1] / iter1, self.FINTEG))
        print('MASSBAL: SUM= %17.6f AVG=%17.6f LAST= %17.6f'
              % (self.dbgvar[4], self.dbgvar[4]/iter1, self.MASSBAL))
        DT = self.DT
        print('FINTEG*DT: SUM = %17.6f AVG = %17.6f LAST= %17.6f' %
              (self.dbgvar[1]*DT, self.dbgvar[1] * DT / iter1, self.FINTEG*DT))

        # Sum flow into tank from cooling circuit and subtract flow from pump leaking
        print('F1-F4+F6-F3:  SUM= %17.6f' % (self.FLOW[0] - self.FLOW[3] + self.FLOW[5] - self.FLOW[2]))


def run_experiment(experiment):
    e = experiment
    cstr = CSTR(theta=e['theta'], randseed=e['randseed'],
                fortran_rand=e['fortran_rand'],
                faults=e['faults'],
                timehoriz=e['timehoriz'])
    cstr.run()
    cstr.close()


def main():
    exp1 = {'theta': 1, 'randseed': 1234, 'fortran_rand': True,
            'timehoriz': 1000,
            'faults': (
                 Fault(id=2, EXTENT0=200, DELAY=200, TC=1.0),
                 Fault(is_sensor_fault=True, id=2, sensor_fault_type='bias',
                       EXTENT0=0.5, DELAY=700, TC=0.1)
                       )
            }

    exp_normal = {'theta': 1, 'randseed': 1234, 'fortran_rand': True,
                  'timehoriz': 1000, 'faults': ()}

    exp_normal = {'theta': 1, 'randseed': 1234, 'fortran_rand': False,
                  'timehoriz': 1000, 'faults': ()}

    exp_f2 = {'theta': 1, 'randseed': 1234, 'fortran_rand': False,
              'timehoriz': 1000, 'faults': (
                  Fault(id=2, EXTENT0=200, DELAY=500, TC=0.1), )}

    experiment = exp1
    experiment = exp_f2
    experiment = exp_normal
    run_experiment(experiment)


if __name__ == "__main__":
    main()
