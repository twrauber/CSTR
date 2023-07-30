/*
 * PID CONTROLLER
*/
typedef struct PID_controller_ {
/* ==================  P L A N T  ================== */
        float *u;		/* manipulated variable */

/* ==================  PID  C O N T R O L L E R  ========================== */
	float K;		/* Gain */
/* Samal, p.171:  K from interval: 0.3...100, Default: 1.0       */
	float Ti;		/* Integration time */
/* Samal, p.171:  Ti from interval: 0.003s...1800s, Default: 10.0  */
	float Td;		/* Derivative time (lead time) */

	float q0;		/* q0 = K*(1.0 + Td/deltaT) */
	float q1;		/* q1 = -K*(1.0 + 2*Td/deltaT - deltaT/Ti) */
	float q2;		/* q2 = K * Td/ deltaT; */

        float *w;		/* reference variable */
        float *y;		/* controlled variable */
        float e_1, e_2;		/* last two control errors */
        } PID_controller;
