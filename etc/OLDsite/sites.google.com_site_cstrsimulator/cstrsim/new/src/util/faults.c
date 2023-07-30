//Manipula as falhas que foram passadas pelo arquivo
#include <math.h>
#include <stdio.h>

void faultHandler(int it, int *fl, double *inst, double *nv, double *tau, double *initVal, double *ms, double *newVal){

	//Faults
	int i;
	for(i=2; i <= 22; i++){
		if(it >= inst[i] && inst[i] != 0){
			fl[i] = 1;
			//printf("faultHandler> it=%7d i=%2d inst=%6d fl=%3d tau=%6.2lf\n",it,i,inst[i],fl[i],tau[i]);
			newVal[i] = nv[i]-(nv[i]-initVal[i])*exp(tau[i]*(inst[i]-it));
		}else{
			fl[i] = -1;
			newVal[i] = initVal[i];
		}
	}

	for(i=2; i<= 15; i++){
		if(it >= inst[i+21] && inst[i+21] != 0){
			fl[i+21] = 1;
			//printf("faultHandler> it=%7d i=%2d inst=%6d fl=%3d tau=%6.2lf\n",it,i,inst[i],fl[i],tau[i]);
			ms[i-2] = nv[i+21]-(nv[i+21]-0.0)*exp(tau[i+21]*(inst[i+21]-it)) + initVal[i+21];
		}else if(it >= inst[i+35] && inst[i+35] != 0){
			fl[i+35] = 1;
			//printf("faultHandler> it=%7d i=%2d inst=%6d fl=%3d tau=%6.2lf\n",it,i,inst[i],fl[i],tau[i]);
			ms[i-2] = nv[i+35]-(nv[i+35]-initVal[i+35])*exp(tau[i+35]*(inst[i+35]-it));
		}else{
			fl[i+21] = -1;
			fl[i+35] = -1;
			ms[i-2] = initVal[i+35];
		}
	}
}

void initSensorFaults(double *h, double *q, double *t, double *c, double *cnt, double *ms, double *initVal){
	
	//Sensor faults - fixed bias
	initVal[23] = c[0];			//#1 Feed concentration
	initVal[24] = q[1];			//#2 Feed flowrate
	initVal[25] = t[1];			//#3 Feed temperature
	initVal[26] = h[1];			//#4 Reactor level
	initVal[27] = c[1];			//#5 Product A concentration
	initVal[28] = c[2];			//#6 Product B concentration
	initVal[29] = t[2];			//#7 Reactor temperature
	initVal[30] = q[5];			//#8 Coolant flowrate
	initVal[31] = q[4];			//#9 Product flowrate
	initVal[32] = t[3];			//#10 Coolant inlet temperature
	initVal[33] = h[7];			//#11 Coolant inlet pressure
	initVal[34] = cnt[1];		//#12 Level controller output
	initVal[35] = cnt[3];		//#13 Coolant controller output
	initVal[36] = cnt[2];		//#14 Coolant setpoint

	//Sensor faults - fixed value
	initVal[37] = c[0];			//#1 Feed concentration
	initVal[38] = q[1];			//#2 Feed flowrate
	initVal[39] = t[1];			//#3 Feed temperature
	initVal[40] = h[1];			//#4 Reactor level
	initVal[41] = c[1];			//#5 Product A concentration
	initVal[42] = c[2];			//#6 Product B concentration
	initVal[43] = t[2];			//#7 Reactor temperature
	initVal[44] = q[5];			//#8 Coolant flowrate
	initVal[45] = q[4];			//#9 Product flowrate
	initVal[46] = t[3];			//#10 Coolant inlet temperature
	initVal[47] = h[7];			//#11 Coolant inlet pressure
	initVal[48] = cnt[1];		//#12 Level controller output
	initVal[49] = cnt[3];		//#13 Coolant controller output
	initVal[50] = cnt[2];		//#14 Coolant setpoint
}