/*
 * HEAT EXCHANGER
*/
typedef struct heat_exchanger {
        float A;                /* Surface area */
	float Tin, Tout;	/* Temperature of the coolant fluid */
	float TR;		/* Recycle temperature */
	float FW;		/* Flow rate of the coolant fluid */
	float Q;		/* Heat exchanged in the exchanger */
        } heat_exchanger;


/*
 * REACTOR
*/
typedef struct reactor_ {
	float TM, TS;		/* Temperature in tank, set point */
	float LM, LS;		/* Level of fluid in tank, set point */
	float AM;		/* Area of the bottom of the tank */
	float F0;		/* Input flow rate */
	float T0;		/* Input temperature */
	float cA0;		/* Input concentration of component A */
	float cA, cB;		/* Concentration of component A, B */

	float U;		/* Heat transfer coefficient */
	float C1, C2;		/* Heat capacities */
	float c;		/* Specific heat capacity of fluid in tank */
	float rho;		/* Density of fluid in tank */
	float E_;		/* Activation energy */
	float deltaH;		/* Heat of the reaction */
	} reactor;


/*
 * PUMP & PIPES
*/
typedef struct pump_and_pipes_ {
	/* PUMP */
	float AP;		/* Pump parameter */
	float BP;

        float F;		/* Flow */
	float FR, FS;		/* Recycle flow, set point */
	float FP;		/* Output flow rate */
	float Fleak;		/* Leaking flow */
	float a1, a2, Amax;	/* Valve parameters for V1 and V2 */
	float KL, KL1, KL2;	/* Fluid resistance coefficients */
	float KV1, KV2;		/* Control valve parameters */
	} pump_and_pipes;	


typedef struct sysvars_ {
        FILE *fp;
        char name[5];
	float val;
} sysvars;

#define DATADIR "../out/"
