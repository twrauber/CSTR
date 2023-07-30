#include <stdio.h>
#include <math.h>
#include "def.h"
#include "control.h"
#include "system.h"
#include "faults.h"


int get_state(void);

heat_exchanger hx;
reactor r;
pump_and_pipes pp;

static PID_controller CL;	/* controls level in tank (LM) */
static PID_controller CT;	/* controls temperature in tank (TM) */
static PID_controller CR;	/* controls flow rate of recyle flow (FR) */



static void init_heat_exchanger()
{
 hx.A = 40.0;
 hx.Tin = 15.0;
 /* hx.Tout = 56.0; &&& Original data from paper */
 hx.Tout = 57.9;
 /* hx.TR = 52.0; &&& Original data from paper */
 hx.TR = 36.0;
 hx.FW = 3.5; 
 /* Q is not a predefined variable */
}


static void init_reactor()
{
 r.LS = 3.0;  r.LM =  r.LS;
 r.TS = 58.0; r.TM =  r.TS;
 r.AM = 3.0;
 r.F0 = 2.5;
 r.T0 = 30.0;
 r.cA0 = 1200.0;
 r.cA = 20.0, r.cB = 1180.0;
 r.U = 10.0;

 r.C1 = 100.0; r.C2 = 200.0; r.c = 4.2;
 r.rho = 1000.0;
 r.E_ = 100.0;
 r.deltaH = 300.0;
}


static void init_pump_and_pipes()
{
 pp.AP = -4200.0;
 pp.BP = 220000.0;

 pp.FS = 7.0; pp.FR = pp.FS;
 pp.Fleak = 0.0;
 pp.FP = 2.5;
 pp.F = pp.FR + pp.FP;

 pp.a1   = 35.5;		/*&&&&&& TO BE DEFINED &&&&&&&&&*/
 pp.a2   = 0.15;		/*&&&&&& TO BE DEFINED &&&&&&&&&*/
 pp.Amax = 0.001;		/*&&&&&& TO BE DEFINED &&&&&&&&&*/

 pp.KL = 0.0; pp.KL1 = 1600.0; pp.KL2 = 940.0;
 pp.KV1 = 0.00067; pp.KV2 = 0.00067;
}


static void init_all_controllers()
{

 /*** init_PID_controller( pid, u, K, Ti, Td, w, y ) ***/
 /*	pid:	Controller
	u:	manipulated variable
	K:	gain
	Ti:	integration time
	Td:	lead time
	w:	reference variable
	y:	controlled variable
 */

 /* Init the two controllers of the reactor */
 /* LM ---> a2 */
 init_PID_controller( &CL, &(pp.a2), -1.0, 100.0, 0.0, &(r.LS), &(r.LM) );


 /* TM ---> FW */
 init_PID_controller( &CT, &(hx.FW), -1.0, 15.0, 200.0, &(r.TS), &(r.TM) );


 /* Init the controller of the recyle flow */
 init_PID_controller( &CR, &(pp.a1), -1.0, 15.0, 0.0, &(pp.FS), &(pp.FR) );

 /*
  *  Values of K, Ti, Td for paper SBAI97:
  *    -1.0, 10.0, 0.0
  *    -1.0, 15.0, 200.0
  *    -1.0, 15.0, 0.0
*/
}


void init_system()
{
 init_heat_exchanger();
 init_reactor();
 init_pump_and_pipes();
 init_all_controllers();
}



static float TR_new, Tout_new;	/* %%% Actualize later %%% */

static void update_heat_exchanger()
{
 float TR_old, Tout_old;

 printf("\n --- UPDATING HEAT EXCHANGER ---\n" );	/**/
 /* Calculate TR and Tout */
 TR_old = hx.TR; Tout_old = hx.Tout;
 nextT( TR_old, Tout_old, &TR_new, &Tout_new );
 GREP0;printf("Temperatures of recycle flow and coolant ");
	printf("TR: %f ---> %f    Tout: %f ---> %f\n",
	TR_old, TR_new, Tout_old, Tout_new );	/**/
}


static float LM_new, TM_new, cA_new, cB_new;	/* %%% Actualize later %%% */

static void update_reactor()
{
 float LM_old;
 float TM_old;
 float cA_old, cB_old;

 printf("\n --- UPDATING REACTOR ---\n" );	/**/
 /*** Level in the reactor 'LM' ***/
 LM_old = r.LM;
 nextLM( LM_old, &LM_new );
 printf("Level in the reactor LM: %f ---> %f\n", LM_old, LM_new );

 /*** Temperature of the reactor 'TM' ***/
 TM_old = r.TM;
 nextTM( TM_old, &TM_new ); 
 GREP0;printf("Temperature of the reactor TM: %f ---> %f\n", TM_old, TM_new );

 /* Concentrations */
 cA_old = r.cA; cB_old = r.cB;
 nextC( cA_old, cB_old, &cA_new, &cB_new );
 GREP0;printf("Concentrations cA: %f ---> %f    cB: %f ---> %f\n",
	cA_old, cA_new, cB_old, cB_new );	/**/
}


static float F_new, FP_new, FR_new;	/* %%% Actualize later %%% */

static void update_pump_and_pipes()
{
 printf("\n --- UPDATING PUMP AND PIPES ---\n" );	/**/
 calc_F_FR_FP( &F_new, &FR_new, &FP_new );

 GREP0;printf("Flow rates F: %.4f -> %.4f FR: %.4f -> %.4f FP: %.4f -> %.4f",
	pp.F, F_new, pp.FR, FR_new, pp.FP, FP_new );
 printf("  FW: %.4f\n", hx.FW );
}


extern float calc_deltaTemp();
static float deltaTemp;

extern sysvars vars[];

static void set_old_vars()
{
 float deltaTemp;

 deltaTemp = calc_deltaTemp( r.TM, hx.Tout, hx.TR, hx.Tin );

 vars[0].val  = 1+  r.F0/2.5;
 vars[1].val  = 2+  r.T0/30.0;
 vars[2].val  = 3+  r.cA0 / 1200.0;
 vars[3].val  = 4+  pp.FR/7.0;
 vars[4].val  = 5+  hx.TR/37.0;
 vars[5].val  = 6+  r.LM/3.0;
 vars[6].val  = 7+  r.TM/58.0;
 vars[7].val  = 8+  hx.FW/3.0;
 vars[8].val  = 9+  pp.FP/2.5;
 vars[9].val  = 10+ r.cA/20.0;
 vars[10].val = 11+ r.cB / 1200.0;
 vars[11].val = 12+ pp.a1/35.5;
 vars[12].val = 13+ pp.a2/0.15;

 vars[13].val = 14+ pp.F/9.5;
 vars[14].val = 15+ hx.Tout/58.0;
 vars[15].val = 16+ deltaTemp/1.5;
 vars[16].val = 17+ hx.Q/6.5;
}


static void actualize_parameters( i, t )
int i;
float t;
{
 set_old_vars();
 set_features();

 hx.TR = TR_new; hx.Tout = Tout_new;

 r.LM = LM_new;
 r.TM = TM_new;
 r.cA = cA_new; r.cB = cB_new;

 pp.F = F_new;
 pp.FR = FR_new;
 pp.FP = FP_new;


 deltaTemp = calc_deltaTemp( r.TM, hx.Tout, hx.TR, hx.Tin );
 GREP;printf("TM=%f  Tout=%f  TR=%f  FW=%f  cA=%f cB=%f  DeltaTemp=%f  Q=%f",
	r.TM, hx.Tout, hx.TR, hx.FW, r.cA, r.cB, deltaTemp, hx.Q );
 printf(" Step=%d\n", i );

 dump_vars( i );
 dump_features( i );
}

void update_system( i, t )
int i;
float t;
{
 printf("\n\n>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
 printf(">>>  UPDATING SYSTEM: Step=%d  t=%.1f <<<\n", i, t );	/**/
 printf(">>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
 update_heat_exchanger();
 update_reactor();
 update_pump_and_pipes();
 printf("\n========  END OF UPDATE STEP %d ============\n", i );
 actualize_parameters( i, t );
}


void control_system( i, t )
int i;
float t;
{
 printf(">>>>>>>  CONTROLLING STEP %d  <<<<<<<<<<<<<<<<\n", i );
 /* Control reactor level LM */
 pid_control( &CL, "CL ---       Reactor level LM:" );

 /* Control reactor temperature TM */
 if( get_state() != TEMP_CONTROL_VALVE_STUCK_HIGH )
   pid_control( &CT, "CT --- Reactor temperature TM:" );	/**/

 /* Control recycle flow FR */
 pid_control( &CR, "CR ---        Recycle flow FR:" );
}
