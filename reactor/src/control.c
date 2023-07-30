#include <stdio.h>
#include <stdlib.h>
#include "def.h"
#include "control.h"

extern float deltaT;		/* Sampling time */


void init_PID_controller( pid, u, K, Ti, Td, w, y )
PID_controller *pid;
float *u;
float K, Ti, Td;
float *w, *y;
{
 float T0;

 if( deltaT == 0.0 ) {fprintf(stderr,"Error: delta_t is 0. Exit...\n");exit(1);}
 if( Ti == 0.0 ) {fprintf(stderr,"Error: Ti is 0. Exit...\n");exit(1);}

 T0 = deltaT;
 pid->u = u;
 pid->K = K;
 pid->Ti = Ti;
 pid->w = w;
 pid->y = y;

 pid->q0 =  K * ( 1.0 + Td/T0 );
 pid->q1 = -K * ( 1.0 + 2.0*(Td/T0) - T0/Ti );
 pid->q2 =  K * Td/T0;

 pid->e_1 = *(pid->w) - *(pid->y);
 pid->e_2 = pid->e_1;

 /* fprintf(stderr,"K=%12.5f Ti=%12.5f Td=%12.5f q0=%12.5f q1=%12.5f \
	q2=%12.5f e1=%12.5f e2=%12.5f\n",
	K, Ti, Td, pid->q0, pid->q1, pid->q2, pid->e_1, pid->e_2 ); WAIT; /**/
}


void pid_control( pid, commment )
PID_controller *pid;
char *commment;
{
 float u_k, u_k1, e_k, e_k1, e_k2;

 u_k1 = *(pid->u);
 e_k1 = pid->e_1;
 e_k2 = pid->e_2;
 e_k = *(pid->w) - *(pid->y);


 /* The PID algorithm: */

 u_k = u_k1 + pid->q0 * e_k + pid->q1 * e_k1 + pid->q2 * e_k2;

 /* Keep the last two values of 'e' */
 pid->e_2 = e_k1;
 pid->e_1 = e_k;


 /*****   CONTROL   *****/
 *(pid->u) = u_k;

 printf("%s y=%9.5f w=%9.5f  e:%9.5f->%9.5f->%9.5f u:%9.5f->%9.5f\n",
        commment, *(pid->y), *(pid->w), e_k2, e_k1, e_k, u_k1, u_k );
}
