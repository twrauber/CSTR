#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include "def.h"
#include "system.h"
#include "faults.h"

FILE *open_read( char *name );
FILE *open_write( char *name );

extern float deltaT;

extern heat_exchanger hx;
extern reactor r;
extern pump_and_pipes pp;

/* The features: 11 measurements + 3 controller outputs
	supposing that FW is directly considered as the controller output
	of CT */

#define NUM_FEATS 13		/* The features */
static float feature[NUM_FEATS];
static char featname[NUM_FEATS][4] = {"F0", "T0", "cA0", "FR", "TR", "LM",
	"TM", "FW", "FP", "cA", "cB", "a1", "a2" };


static FILE *feat = NULL;
static char featnamfile[] = "features.nam";
static char featfile[] = "features.dat";
static FILE *multilabel = NULL;
static char multilabelfilename[] = "all.csv";

static str100 message;
static char state_str[1001];
static char *multilabel_str = NULL;


/*
 *   All possible conditions in which the process can be
 *   If a new condition is defined, it must be included into this list
 *   including the respective functions to activate and deactivate it
*/
struct condition {
	int val;
	str80 name;
	boolean active;
} condition[NUM_CONDITIONS] = {
/*
 *  N O R M A L  C O N D I T I O N S  A N D  F A U L T S  ( O F  P A P E R )
*/
  { NORMAL,				"NORMAL", TRUE },
  { INPUT_PIPE_PARTIALLY_BLOCKED,	"INPUT_PIPE_PARTIALLY_BLOCKED", FALSE },
  { RECYCLE_PIPE_PARTIALLY_BLOCKED,	"RECYCLE_PIPE_PARTIALLY_BLOCKED", FALSE },
  { INPUT_CONCENTRATION_A_HIGH,		"INPUT_CONCENTRATION_A_HIGH", FALSE },
  { RECYCLE_FLOW_SET_POINT_HIGH,	"RECYCLE_FLOW_SET_POINT_HIGH", FALSE },
  { FOULED_HEAT_EXCHANGER,		"FOULED_HEAT_EXCHANGER", FALSE },
  { DEACTIVATED_CATALYST,		"DEACTIVATED_CATALYST", FALSE },
  { TEMP_CONTROL_VALVE_STUCK_HIGH,	"TEMP_CONTROL_VALVE_STUCK_HIGH", FALSE },
  { LEAK_FLOW_IN_REACTOR,		"LEAK_FLOW_IN_REACTOR", FALSE },
  { RECYCLE_FLOWMETER_STUCK_HIGH,	"RECYCLE_FLOWMETER_STUCK_HIGH", FALSE },
  { MALFUNCTION_IN_PUMP,		"MALFUNCTION_IN_PUMP", FALSE },
/*
 *  O T H E R  N O R M A L  C O N D I T I O N S 
*/
  { NORMAL_A1,			"NORMAL_A1", FALSE },
  { NORMAL_A2,			"NORMAL_A2", FALSE },
  { NORMAL_A3,			"NORMAL_A3", FALSE },
  { NORMAL_A4,			"NORMAL_A4", FALSE },
  { NORMAL_B1,			"NORMAL_B1", FALSE },
  { NORMAL_B2,			"NORMAL_B2", FALSE },
  { NORMAL_B3,			"NORMAL_B3", FALSE },
  { NORMAL_B4,			"NORMAL_B4", FALSE }
};
static int num_conditions = NUM_CONDITIONS;
static int state = NORMAL;
int get_state(void) { return state; }



void init_feat_files()
{
	FILE *fn = NULL;	/* Feature Names */
	str200 nam;
	int i;

	strcpy( nam, DATADIR );
	strcat( nam, featnamfile );

	fn = open_write( nam );
	fprintf( fn, "#\n# Feature names\n#\n%d\n", NUM_FEATS );
	for( i = 0; i < NUM_FEATS; i++ )
		fprintf( fn, "%s\n", featname[i] );
	fclose(fn);

	strcpy( nam, DATADIR );
	strcat( nam, featfile );
	feat = open_write( nam );

	strcpy( nam, DATADIR );
	strcat( nam, multilabelfilename );
	multilabel = open_write( nam );
	multilabel_str = (char*)malloc((1+NUM_FAULTS)*sizeof(char));
	multilabel_str[0] = '\0';


	/* Feature names as comment into the feature file */
	fprintf( feat, "#\n# FEATURE NAMES:\n#  %s", featname[0] );
	fprintf( multilabel, "#\n# FEATURE NAMES:\n#  %s", featname[0] );
	for( i = 1; i < NUM_FEATS; i++ )	{
		fprintf( feat, "%8s ", featname[i] );
		fprintf( multilabel, "%8s ", featname[i] );
	}
	fprintf( feat, "\n#\n%d\n", NUM_FEATS );
	fprintf( multilabel, "\n#\n%d\n", NUM_FEATS );

	strcpy( state_str, condition[NORMAL].name );
}


void close_feat_files()
{
	fclose( feat );
	fclose( multilabel );
	FREE( multilabel_str );
}


#define NORM_FEAT
void set_features()
{
#ifdef NORM_FEAT
 /* Normalize all features by dividing them by their default value */
 feature[0] = r.F0/2.5;	feature[1] = r.T0/30.0;	feature[2] = r.cA0/1200.0;
 feature[3] = pp.FR/7.0; feature[4] = hx.TR/37.0; feature[5] = r.LM/3.0;
 feature[6] = r.TM/58.0; feature[7] = hx.FW/3.0; feature[8] = pp.FP/2.5;
 feature[9] = r.cA/20.0; feature[10] = r.cB/1200.0;
 feature[11] = pp.a1/35.5; feature[12] = pp.a2/0.15;
#endif
#ifndef NORM_FEAT
 feature[0] = r.F0;	feature[1] = r.T0;	feature[2] = r.cA0;
 feature[3] = pp.FR;	feature[4] = hx.TR;	feature[5] = r.LM;
 feature[6] = r.TM;	feature[7] = hx.FW;	feature[8] = pp.FP;
 feature[9] = r.cA;	feature[10] = r.cB;
 feature[11] = pp.a1; feature[12] = pp.a2;
#endif
}

/*----------------------------------------------------*/
static void normal()
{ state = NORMAL; condition[state].active = TRUE; strcpy( message, "Normal"); }

/*----------------------------------------------------*/
static void block_input()
{ state = INPUT_PIPE_PARTIALLY_BLOCKED; r.F0 = 2.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Blocking input pipe"); }

static void UNDO_block_input()
{ r.F0 = 2.5;
  condition[INPUT_PIPE_PARTIALLY_BLOCKED].active = FALSE;
  strcpy( message, "Blocking input pipe - UNDO"); }


/*----------------------------------------------------*/
static void input_A_high()
{ state = INPUT_CONCENTRATION_A_HIGH; r.cA0 = 1500.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Setting input concentration of A high"); }

static void UNDO_input_A_high()
{ r.cA0 = 1200.0;
  condition[INPUT_CONCENTRATION_A_HIGH].active = FALSE;
  strcpy( message, "Setting input concentration of A high - UNDO"); }


/*----------------------------------------------------*/
static void recycle_FS_high()
{ state = RECYCLE_FLOW_SET_POINT_HIGH; pp.FS = 10.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Setting recycle flow set point FS high"); }

static void UNDO_recycle_FS_high()
{ pp.FS = 7.0;
  condition[RECYCLE_FLOW_SET_POINT_HIGH].active = FALSE;
  strcpy( message, "Setting recycle flow set point FS - UNDO"); }


/*----------------------------------------------------*/
static void fouled_hx()
{ state = FOULED_HEAT_EXCHANGER; hx.A = 5.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Fouled heat exchanger"); }

static void UNDO_fouled_hx()
{ hx.A = 40.0;
  condition[FOULED_HEAT_EXCHANGER].active = FALSE;
  strcpy( message, "Fouled heat exchanger - UNDO"); }


/*----------------------------------------------------*/
static void deactivate_catalyst()
{ state = DEACTIVATED_CATALYST; /* &&& to be filled in */
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Deactivated catalyst"); }

static void UNDO_deactivate_catalyst()
{ /* &&& to be filled in */
  condition[DEACTIVATED_CATALYST].active = FALSE;
  strcpy( message, "Deactivated catalyst - UNDO"); }


/*----------------------------------------------------*/
static void temp_valve_VT_high()
{ state = TEMP_CONTROL_VALVE_STUCK_HIGH; hx.FW = 5.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Temp. control valve VT stuck high"); }

static void UNDO_temp_valve_VT_high()
{ hx.FW = hx.FW;	/* do nothing, let it be controlled again */
  condition[TEMP_CONTROL_VALVE_STUCK_HIGH].active = FALSE;
  strcpy( message, "Temp. control valve VT stuck high - UNDO"); }


/*----------------------------------------------------*/
static void leak()
{ state = LEAK_FLOW_IN_REACTOR; pp.Fleak = 1.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Leak flow in reactor"); }

static void UNDO_leak()
{ pp.Fleak = 0.0;
  condition[LEAK_FLOW_IN_REACTOR].active = FALSE;
  strcpy( message, "Leak flow in reactor - UNDO"); }


/*----------------------------------------------------*/
static void recycle_flowmeter_high()
{ state = RECYCLE_FLOWMETER_STUCK_HIGH; pp.FR = 10.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Recycle flowmeter stuck high"); }

static void UNDO_recycle_flowmeter_high()
{ state = EMPTY;
  condition[RECYCLE_FLOWMETER_STUCK_HIGH].active = FALSE;
  strcpy( message, "Recycle flowmeter stuck high - UNDO"); }


/*----------------------------------------------------*/
static void pump_defect()
{ state = MALFUNCTION_IN_PUMP; pp.AP = -2000.0;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  strcpy( message, "Malfunctioning in pump"); }

static void UNDO_pump_defect()
{ pp.AP = -4200.0;
  condition[NORMAL].active = FALSE;
  condition[MALFUNCTION_IN_PUMP].active = FALSE;
  strcpy( message, "Malfunctioning in pump - UNDO"); }

/*----------------------------------------------------*/

/*----------------------------------------------------*/
/* Additional events:				*/
/*----------------------------------------------------*/
static void normal_A1()
{ state = NORMAL_A1; r.LS = 2.9;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  sprintf( message, "Lowering set point for tank level to %.3f", r.LS ); }

static void UNDO_normal_A1()
{ r.LS = 3.0;
  condition[NORMAL_A1].active = FALSE;
  strcpy( message, "Lowering set point for tank level - UNDO"); }
/*----------------------------------------------------*/

static void normal_A2()
{ state = NORMAL_A2; r.LS = 3.10;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  sprintf( message, "Raising set point for tank level to %.3f", r.LS ); }

static void UNDO_normal_A2()
{ r.LS = 3.0;
  condition[NORMAL_A2].active = FALSE;
  strcpy( message, "Raising set point for tank level - UNDO"); }
/*----------------------------------------------------*/

static void normal_A3()
{ state = NORMAL_A3; r.LS = 3.12;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  sprintf( message, "Raising set point for tank level to %.3f", r.LS ); }

static void UNDO_normal_A3()
{ r.LS = 3.0;
  condition[NORMAL_A3].active = FALSE;
  strcpy( message, "Raising set point for tank level - UNDO"); }
/*----------------------------------------------------*/


static void normal_B1()
{ state = NORMAL_B1; pp.FS = 5.00;
  condition[NORMAL].active = FALSE;
  condition[state].active = TRUE;
  sprintf( message, "Lowering flow rate to %.3f", pp.FS ); }

static void UNDO_normal_B1()
{ pp.FS = 7.0;
  condition[NORMAL_B1].active = FALSE;
  strcpy( message, "Lowering flow rate - UNDO"); }
/*----------------------------------------------------*/


/* Implemented events */
/*
normal
block_input
UNDO_block_input
input_A_high
UNDO_input_A_high
recycle_FS_high
UNDO_recycle_FS_high
fouled_hx
UNDO_fouled_hx
temp_valve_VT_high
UNDO_temp_valve_VT_high
leak
UNDO_leak
recycle_flowmeter_high_START
UNDO_recycle_flowmeter_high
pump_defect
UNDO_pump_defect
----------------------------------------------------
normal_A1		---	normal_A3
UNDO_normal_A1		---	UNDO_normal_A3
normal_B1
UNDO_normal_B1
*/


typedef struct events {
	int when;
	int code;
	void (*what)();
} Events;

typedef struct dump_interval {
	int		start,	stop,	resolution;
} Dump_interval;

/*======================================================================*/
#if 0
int stepsOLD = 70000;	/* Number of discrete sampling points */
/* ### */
static struct events eventOLD[] = {
	{     0,	normal },
	{  10000,	fouled_hx },
	{  30000,	leak },
	{  50000,	block_input },
	{  60000,	UNDO_fouled_hx },
	{  60000,	UNDO_leak },
	{  60000,	UNDO_block_input },
	{  60000,	normal },
	{  EMPTY,	NULL } /* Always here */
};


static struct dump_interval dump_intervalOLD[] = {
	{ 		9000,	10000,	20		},
	{ 		29000,	30000,	20		},
	{ 		49000,	50000,	20		},
	{ 		59000,	60000,	20		},
	{ 		EMPTY,	EMPTY,	EMPTY		} /* Always here */
};
#endif
/*======================================================================*/

static struct events *event = NULL;
static struct dump_interval *dump_interval = NULL;

void free_events()
{
	FREE( event );
	FREE( dump_interval );
}

typedef struct validevent {
	int when;	// Time step
	int what;	// Event: Fault, data dump
	int flag;	// on / off	
} Validevent;

typedef struct validdumpint {
	int when;	// Time step
	int flag;	// on / off	
} Validdumpint;

#define MAX_EVENTS 1000
#define MAX_DUMP_INTVALS 1000


#define DATALINELEN 80
static char line[DATALINELEN+1];

#define COMMENTCHAR '#'
#define COMMENTSTR "#"

static int steps = EMPTY;
int get_steps( void ) { return steps; }
static int dumpresolution = EMPTY;

static struct validevent **ve = NULL;

static void process_event( int step, int event, int state,
		struct validevent *ve, struct validdumpint *vdi, int *cntVe, int *cntDi )
{
	//fprintf(stderr,"Step=%6d Event=%3d State=%3d\n", step, event, state );
	boolean valid =
		step >=0 && step <= steps &&
		event >= DATA_DUMPING && event <= NUM_CONDITIONS &&
		(state == OFF || state == ON);
	if( valid )	{
		// process valid event
		/*fprintf(stderr,"VALID EVENTS #%3d VALID DUMP INTVAL #%3d: Step=%6d Event=%3d State=%3d\n",
			*cntVe, *cntDi, step, event, state );	/**/
		if( event == DATA_DUMPING )	{
			//fprintf(stderr,"\t---> VALID DUMP INTVAL\n" );
			int p = *cntDi;
			vdi[p].when = step; vdi[p].flag = state;
			(*cntDi)++;
		}
		else	{
			int p = *cntVe;
			ve[p].when = step; ve[p].what = event; ve[p].flag = state;
			(*cntVe)++;
		}
	}
	if( (*cntDi) >= MAX_DUMP_INTVALS ) EXIT("Raise constant 'MAX_DUMP_INTVALS'");
	if( (*cntVe) >= MAX_EVENTS ) EXIT("Raise constant 'MAX_EVENTS'");
}

static void (*event_code(int what, int flag))(void)
{
	if( flag != ON && flag != OFF ) EXIT("Unknown flag value");
	switch( what )	{
		case INPUT_PIPE_PARTIALLY_BLOCKED:
			if( flag == ON ) return	block_input;
			return		UNDO_block_input; break;
		case INPUT_CONCENTRATION_A_HIGH:
			if( flag == ON ) return	input_A_high;
			return		UNDO_input_A_high; break;
		case RECYCLE_FLOW_SET_POINT_HIGH:
			if( flag == ON ) return	recycle_FS_high;
			return		UNDO_recycle_FS_high; break;
		case FOULED_HEAT_EXCHANGER:
			if( flag == ON ) return	fouled_hx;
			return		UNDO_fouled_hx; break;
		case DEACTIVATED_CATALYST:
			if( flag == ON ) return	deactivate_catalyst;
			return		UNDO_deactivate_catalyst; break;
		case TEMP_CONTROL_VALVE_STUCK_HIGH:
			if( flag == ON ) return	temp_valve_VT_high;
			return		UNDO_temp_valve_VT_high; break;
		case LEAK_FLOW_IN_REACTOR:
			if( flag == ON ) return	leak;
			return		UNDO_leak; break;
		case RECYCLE_FLOWMETER_STUCK_HIGH:
			if( flag == ON ) return	recycle_flowmeter_high;
			return		UNDO_recycle_flowmeter_high; break;
		case MALFUNCTION_IN_PUMP:
			if( flag == ON ) return	pump_defect;
			return		UNDO_pump_defect; break;
		case NORMAL_A1:
			if( flag == ON ) return	normal_A1;
			return		UNDO_normal_A1; break;
		case NORMAL_A2:
			if( flag == ON ) return	normal_A2;
			return		UNDO_normal_A2; break;
		case NORMAL_A3:
			if( flag == ON ) return	normal_A3;
			return		UNDO_normal_A3; break;
		case NORMAL_B1:
			if( flag == ON ) return	normal_B1;
			return		UNDO_normal_B1; break;

		default: fprintf(stderr,"Unknown condition. Exitus ...\n");
				exit(EXIT_FAILURE);
	}
}

void readcfg( int argc, char **argv )
{
	int i, n; char *ret = NULL;

	if( argc < 2 ) {
		fprintf( stderr, "usage: %s <config file>\n", argv[0] );
		exit( EXIT_SUCCESS );
	}
	char *configFileName = argv[1];
	FILE *f = open_read( configFileName );

	struct validevent *ve = (struct validevent*)malloc(MAX_EVENTS*sizeof(struct validevent));
	struct validdumpint *vdi = (struct validdumpint*)malloc(MAX_DUMP_INTVALS*sizeof(struct validdumpint));

	int cntVe = 0;
	int cntDi = 0;

	/// DO NOT MIX fscanf with fgets !!!
	/// http://stackoverflow.com/questions/19363951/fgets-not-working-after-fscanf
	///
	ret = fgets( line, DATALINELEN, f );
	n = sscanf( line, "%d", &steps );
	ret = fgets( line, DATALINELEN, f );
	n = sscanf( line, "%d", &dumpresolution );
	fprintf(stdout,"Configuration file = '%s'\n", argv[1] );
	fprintf(stdout,"Number of time steps = %d\n", steps );
	fprintf(stdout,"Dumping every %d-th step\n", dumpresolution );

	while( !feof(f) )	{
		char *ret = fgets( line, DATALINELEN, f );
		if( !feof(f) )	{
			//fprintf(stderr,"LINE BEFORE=>>>%s<<<\n", line );
			int step = EMPTY, event = EMPTY, state = EMPTY;
			n = sscanf( line, "%d %d %d", &step, &event, &state );
			/*fprintf(stderr,"ret='%d' n=%d\n", n, (int)ret );
			if( n > 2 )	{
				fprintf(stderr,"step=%d\n", step );
				fprintf(stderr,"event=%d\n", event );
				fprintf(stderr,"state=%d\n", state );
				fprintf(stderr,"n=%d Step=%6d  Event=%3d  State=%3d\n",
					n, step, event, state );
			} WAIT;	/**/
			// Process triple
			process_event( step, event, state, ve, vdi, &cntVe, &cntDi );
		}
	}
	fclose( f );

	// Translate valid events to old format
	fprintf(stdout,"Found %3d valid events and %3d valid dump interval events\n", cntVe, cntDi );

	event = (struct events*)malloc((2+cntVe)*sizeof(struct events));
	dump_interval = (struct dump_interval*)malloc((2+cntDi)*sizeof(struct dump_interval));

	event[0].when = 0; event[0].code = NORMAL; event[0].what = normal;
	for( i=0;i<cntVe;i++ )	{
		event[i+1].when = ve[i].when;
		event[i+1].code = condition[ve[i].what].val;
		event[i+1].what = event_code( ve[i].what, ve[i].flag );
	}
	event[cntVe+1].when = EMPTY;
	event[cntVe+1].code = EMPTY;
	event[cntVe+1].what = NULL;

	for( i=0;i<=cntVe;i++ )	{
		if( event[i].when != EMPTY )
			fprintf(stdout,"Event # %3d: when=%8d what=%s\n",
				i+1, event[i].when, condition[event[i].code].name );
		else
			fprintf(stdout,"------------- EMPTY --------------\n" );
	}


	// if no dump interval exist, dump everything
	int diCount = 0;
	if( cntDi == 0 )	{
		dump_interval[0].start = 0;
		dump_interval[0].stop = steps;
		dump_interval[0].resolution = dumpresolution;
		dump_interval[1].start = EMPTY;
		dump_interval[1].stop = EMPTY;
		dump_interval[1].resolution = EMPTY;
		diCount++;
	}
	else	{
		int oldflag = vdi[0].flag;
		if( oldflag != ON ) EXIT("First data dumping flag must be 1");
		int dumpstart = vdi[0].when;
		for( i=1;i<cntDi;i++ )	{
			int flag = vdi[i].flag;

			if( flag == OFF && oldflag == ON )	{
				int dumpstop = vdi[i].when;
				dump_interval[diCount].start = dumpstart;
				dump_interval[diCount].stop = dumpstop;
				dump_interval[diCount].resolution = dumpresolution;
				diCount++;
				oldflag = OFF;
			}
			if( flag == ON && oldflag == OFF )	{
				dumpstart = vdi[i].when;
				oldflag = ON;
			}
		}
		if( oldflag == ON )	{	// no last OFF flag
			dump_interval[diCount].start = dumpstart;
			dump_interval[diCount].stop = steps;
			dump_interval[diCount].resolution = dumpresolution;
			diCount++;
		}
		dump_interval[diCount].start = EMPTY;
		dump_interval[diCount].stop = EMPTY;
		dump_interval[diCount].resolution = EMPTY;
	}

	for( i=0; i<=diCount; i++ )	{
		if( dump_interval[i].start != EMPTY )
			fprintf(stdout,"Dumping interval # %3d: start=%8d stop=%8d resolution=%5d\n",
				i+1, dump_interval[i].start, dump_interval[i].stop, dump_interval[i].resolution );
		else
			fprintf(stdout,"------------- EMPTY --------------\n" );
	}

	FREE(ve);
	FREE(vdi);
	//WAIT;
}


static int intvalptr = 0, resCntr = 0, allDumps = 0;

void dump_features( i )
int i;
{
	boolean dump = FALSE;
	int d, start, stop, res;
	/* Check first if the time is in a valid interval */

	if( dump_interval[intvalptr].start == EMPTY )
		return;

	start = dump_interval[intvalptr].start;
	stop = dump_interval[intvalptr].stop;
	res = dump_interval[intvalptr].resolution;

	if( i >= start && i <= stop )
	{
		/*fprintf(stderr,"dump_features>i==start+resCntr*res(%d==%d+%d*%d)=%d\n",
			i,start,resCntr,res,i==start+resCntr*res);/**/
		if( i == start )
			fprintf(stderr, "  $ FEATURE DUMPING START: at %d with resolution %d\n",
				i, res );
		if( i == stop )	{
			fprintf(stderr, "  $ FEATURE DUMPING STOP:  at %d\n", i );
			intvalptr++; resCntr = 0;
		}
		else if( i == start + resCntr * res )
		{
			dump = TRUE;
			resCntr++;
		}
	}
	if( dump )	{
		allDumps++;
		/*fprintf(stderr,"dump_features> i=%7d start=%7d stop=%7d res=%5d dump=%d allDumps=%d\n",
			i,start,stop,res,dump,allDumps);/**/
	}
	else
		return;


	for( d = 0; d < NUM_FEATS; d++ )	{
		fprintf( feat, "%f ", feature[d] );
		fprintf( multilabel, "%f ", feature[d] );
	}
	fprintf( feat, "%s\n", state_str );
	fflush( feat );
	fprintf( multilabel, "%s\n", multilabel_str );
	fflush( multilabel );
}

static int last_event = 0;	/* The last event that had happened */

void update_event( int i, float t )
{
	int e, s, le;

	le = last_event; e = le;
	/* Search if at time i there is an event and execute it */
	//fprintf(stderr, "event[%d].when=%d i=%d\n", e, event[e].when, i );
	while( event[e].when != EMPTY )	{
		if( event[e].when == i )	{
			state_str[0] = '\0';
			event[e].what();
			last_event++;
			for( s = 0; s < num_conditions; s++ )	{
				if( condition[s].active )	{
					if( state_str[0] != '\0' )
						strcat( state_str, "+" );
					strcat( state_str, condition[s].name );
				}
			}
			int mpos = 0;
			for( s = INPUT_PIPE_PARTIALLY_BLOCKED; s < INPUT_PIPE_PARTIALLY_BLOCKED+NUM_FAULTS; s++ )	{
				if( condition[s].active )
					multilabel_str[mpos] = '1';
				else
					multilabel_str[mpos] = '0';
				mpos++;
			}
			multilabel_str[mpos] = '\0';
			fprintf(stderr, "$$$ EVENT at %6d: %s\n", i, message ); //sleep(1);
		}
		e++;
	}
	/* special cases */
	if( state == RECYCLE_FLOWMETER_STUCK_HIGH )
		recycle_flowmeter_high();
}
