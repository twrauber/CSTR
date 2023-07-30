#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "def.h"
#include "system.h"

int get_steps( void );

float deltaT = 0.1;			/* Sampling time */
static float t = 0.0;			/* GLOBAL TIME */

/* Resolution of the dumping for gnuplot, 0=noplot */
static int do_dump = 1000;

static str80 dataDir;
/* The names and filepointers of the variables that will be written */
sysvars vars[] = {
	{NULL, "F0", 0.0}, {NULL, "T0", 0.0}, {NULL, "cA0", 0.0},
	{NULL, "FR", 0.0}, {NULL, "TR", 0.0}, {NULL, "LM", 0.0},
	{NULL, "TM", 0.0}, {NULL, "FW", 0.0}, {NULL, "FP", 0.0},
	{NULL, "cA", 0.0}, {NULL, "cB", 0.0},
	{NULL, "a1", 0.0}, {NULL, "a2", 0.0},
	{NULL, "F", 0.0}, {NULL, "Tout", 0.0},
	{NULL, "dt", 0.0}, {NULL, "Q", 0.0} };
int numVarnames = 17;


FILE *open_read( char *name )
{
	FILE *f = NULL;
 
	f = fopen( name, "r" );
	if( f == NULL )	{
		fprintf( stderr, "Unable to open %s - Exitus.\n", name );
		exit(EXIT_FAILURE);
	}
	else	{
		fprintf(stderr,"Opening %s ...\n", name );
		return f;
	}
}


FILE *open_write( char *name )
{
	FILE *f = NULL;
 
	f = fopen( name, "w" );
	if( f == NULL )	{
		fprintf( stderr, "Unable to open %s - Exitus.\n", name );
		exit(EXIT_FAILURE);
	}
	else	{
		fprintf(stderr,"Opening %s ...\n", name );
		return f;
	}
}


/* #define PSTRICKS_DOCU	/**/
#ifdef PSTRICKS_DOCU
static int pstrickscounter = 0;
#endif


static void init_var_files()
{
	FILE *f = NULL;
	int i;
	char nam[201];

	strcpy( dataDir, DATADIR );
	for( i = 0; i < numVarnames; i++ )
	{
#ifdef PSTRICKS_DOCU
		if( i <= 13 )
			fprintf(stderr,
				"\\fileplot[style=dataplotstyle]{FIGS/scenar1-dat/%s}\n", vars[i].name );
#endif
		strcpy( nam, dataDir );
		strcat( nam, vars[i].name );
		f = open_write( nam );
		vars[i].fp = f;
	}
}


static void close_var_files()
{
	int i;

	for( i = 0; i < numVarnames; i++ )
		fclose( vars[i].fp );
}


void dump_vars( i )
int i;
{
	int v;

	if( do_dump  && (i % do_dump == 0 ) )
	{
		for( v = 0; v < numVarnames; v++ )
		{
#ifdef PSTRICKS_DOCU
			fprintf( vars[v].fp, "%4d,\t", pstrickscounter );
#endif
			fprintf( vars[v].fp, "%f\n", vars[v].val );
			fflush( vars[v].fp );
		}
#ifdef PSTRICKS_DOCU
		pstrickscounter++;
#endif
	}
}


static void init_all()
{
	init_system();
	init_var_files();
	init_feat_files();
	init_random();	/**/
}


static void close_all()
{
	close_var_files();
	close_feat_files();
	free_events();
}



int main( int argc, char **argv )
{
	int i;

	readcfg( argc, argv ); //return 1;
	init_all();

	t = 0.0;
	for( i = 0; i <= get_steps(); i++ )	/**/
	/* while( TRUE )	/**/
	{
		if( i % 100 == 0 )
			fprintf(stderr, "%d\r", i );	/**/
		t += deltaT;
		update_system( i, t );
		update_event( i, t );
		control_system( i, t ); /* i++; */
	}
	close_all(); fprintf(stderr,"\n");
	return( EXIT_SUCCESS );
}
