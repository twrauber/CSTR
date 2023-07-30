#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "def.h"
#include "system.h"

extern float deltaT;

extern heat_exchanger hx;
extern reactor r;
extern pump_and_pipes pp;

/*
 * Fixed physical constants
*/
static float k0 = 0.02;		/* Preexponential kinetic constant */
float g = 9.81;			/* Gravitation constant */
float R = 8.3143;		/* Gas constant */


float calc_deltaTemp( TM, Tout, TR, Tin )
float TM, Tout, TR, Tin;
{
 float d1, d2, dtemp;

 /* Check the plausibilities of the temperatures */
 d1 = TM - Tout;
 if( d1 < 0.0 )
 {
   fprintf(stderr, "\nWARNING: Temperature error: TM=%f Tout=%f\n", TM, Tout );
   WAIT;	/**/
   return( 0.0 );
 }

 d2 = TR - Tin;
 if( d2 < 0.0 )
 {
   fprintf(stderr, "WARNING: Temperature error: TR=%f Tin=%f\n", TR, Tin );
   return( 0.0 );
 }

 dtemp = (float) sqrt( (double)(d1 * d2) );
 return( dtemp );
}


static void Tderivs( t, T, dTdt )
float t, T[], dTdt[];
{
 float TR, Tout, deltaTemp;

 TR = T[1]; Tout = T[2];
 deltaTemp = calc_deltaTemp( r.TM, Tout, TR, hx.Tin );
 hx.Q = r.U * hx.A * deltaTemp;
 dTdt[1] = 1.0 / r.C1 * ( r.c * pp.FR * (r.TM - TR) - hx.Q );
 dTdt[2] = 1.0 / r.C2 * ( hx.Q - r.c * hx.FW * (Tout - hx.Tin) );
}



/*
 *  Calculate the two variables 'TR' and 'Tout' by solving
 *  the differential equations
*/
void nextT( TR_old, Tout_old, TR_new, Tout_new )
float TR_old, Tout_old, *TR_new, *Tout_new;
{
 float T[3];
 float eps = 0.001, h1; int nok, nbad;
 void rkqc();

 h1 = deltaT / 10.0;
 T[1] = TR_old; T[2] = Tout_old;

 odeint( T, 2, 0.0, deltaT, eps, h1, 0.0, &nok, &nbad, Tderivs, rkqc );
 /* printf("odeint: NEW T= %f %f\n", T[1], T[2] );	/**/

 *TR_new = T[1]; *Tout_new = T[2];
}


static void LMDeriv( t, LM, dLMdt )
float t, LM[], dLMdt[];
{
 float aux1;

 aux1 = 1.0 / (r.rho * r.AM);

 dLMdt[1] = aux1 * (r.F0 - pp.FP - pp.Fleak);
}


void nextLM( LM_old, LM_new )
float LM_old, *LM_new;
{
 float LM[2];
 float eps = 0.001, h1; int nok, nbad;
 void rkqc();

 h1 = deltaT/10.0;
 LM[1] = LM_old;

 odeint( LM, 1, 0.0, deltaT, eps, h1, 0.0, &nok, &nbad, LMDeriv, rkqc );
 /* printf("odeint: NEW LM= %f\n", LM[1] );	/**/

 *LM_new = LM[1];
}


static void TMDeriv( t, TM, dTMdt )
float t, TM[], dTMdt[];
{
 float aux1;
 float QR;	/* energy created in reaction */
 float kR;	/* reaction time */

 aux1 = 1.0 / (r.c * r.rho * r.AM * r.LM);
 kR = k0 * (float) exp( -r.E_ / (R * r.TM) );
 QR = r.deltaH * r.cA * r.LM * r.AM * kR;

 dTMdt[1] = aux1 * (r.c * r.F0 * r.T0 + r.c * pp.FR * hx.TR +
	QR - r.c * r.TM * r.F0 - r.c * r.TM * pp.FR);
}


void nextTM( TM_old, TM_new )
float TM_old, *TM_new;
{
 float TM[2];
 float eps = 0.001, h1; int nok, nbad;
 void rkqc();

 h1 = deltaT/10.0;
 TM[1] = TM_old;

 odeint( TM, 1, 0.0, deltaT, eps, h1, 0.0, &nok, &nbad, TMDeriv, rkqc );
 /* printf("odeint: NEW TM= %f\n", TM[1] );	/**/

 *TM_new = TM[1];
}


static void cDerivs( t, c, dcdt )
float t, c[], dcdt[];
{
 float aux1, aux2, aux3;
 float kR;		/* reaction time */

 aux1 = r.AM * r.LM;
 aux2 = r.F0 / r.rho;
 kR = k0 * (float) exp( -r.E_ / (R * r.TM) );
 aux3 = kR * c[1] * aux1;

 dcdt[1] = (1.0 / aux1) * (aux2 * (r.cA0 - c[1]) - aux3 );
 dcdt[2] = (1.0 / aux1) * (-aux2 * c[2] + aux3 );
}


void nextC( cA_old, cB_old, cA_new, cB_new )
float cA_old, cB_old, *cA_new, *cB_new;
{
 float c[3];
 float eps = 0.001, h1; int nok, nbad;
 void rkqc();

 h1 = deltaT/10.0;
 c[1] = cA_old; c[2] = cB_old;

 odeint( c, 2, 0.0, deltaT, eps, h1, 0.0, &nok, &nbad, cDerivs, rkqc );
 /* printf("odeint: NEW c= %f %f\n", c[1], c[2] );	/**/

 *cA_new = c[1]; *cB_new = c[2];
}
