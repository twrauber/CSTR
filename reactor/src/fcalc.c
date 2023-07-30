#include <stdio.h>
#include <math.h>
#include "def.h"
#include "system.h"

extern float g;		/* Gravitation constant */
extern float R;		/* Gas constant */

extern heat_exchanger hx;
extern reactor r;
extern pump_and_pipes pp;


static float Amax, a1, a2, LM, rho, BP, AP, KL, KL2, KV2, KL1, KV1;


static void copy_params()
{
 Amax = pp.Amax; a1 = pp.a1; a2 = pp.a2; AP = pp.AP; BP = pp.BP;
 LM = r.LM; rho = r.rho; KL = pp.KL; KL1 = pp.KL1; KL2 = pp.KL2;
 KV1 = pp.KV1; KV2 = pp.KV2;
}


static double fp_root( FP )
double FP;
{
 double FPsqr, Amax2, Amax4, a1sqr, a2sqr, a1_4, APsqr;
 double pT;	/* Pressure caused by the weight of the liquid in the tank */
 double fp;

 FPsqr = FP * FP;
 Amax2 = Amax * Amax;
 Amax4 = Amax2 * Amax2;
 a1sqr = a1 * a1;
 a2sqr = a2 * a2;
 a1_4 = a1sqr * a1sqr;
 APsqr = AP * AP;
 pT = g * LM * rho;

 /* fprintf(stderr,"FP=%lf FPsqr=%lf Amax2=%lf Amax4=%lf a1sqr=%lf a2sqr=%lf",
	FP, FPsqr, Amax2, Amax4, a1sqr, a2sqr );
 fprintf(stderr," a1_4=%lf APsqr=%f pT=%lf\n", a1_4, APsqr, pT );	/**/

 fp =
	-BP + FPsqr*KL2 + FPsqr*KV2/
    (Amax2*a2sqr) - 
   AP*(FP + (Amax2*AP*a1sqr + 
         sqrt(Amax4*APsqr*a1_4 - 
           4.0*Amax2*a1sqr*
            (Amax2*a1sqr*KL1 + KV1)*
            (-BP - AP*FP - pT)))/
       (2.0*(Amax2*a1sqr*KL1 + KV1))) - pT;

 /* printf("fp_root> fp(%10.5lf)=%10.5lf\n", FP, fp );	/**/

 return( fp );
}


static double calc_FR( FP )
double FP;
{
 double FPsqr, Amax2, Amax4, a1sqr, a2sqr, a1_4, a2_4, APsqr;
 double pT;	/* Pressure caused by the weight of the liquid in the tank */
 double fr;

 /* printf("Calling calc_FR(FP=%f)\n", FP );	/**/
 FPsqr = FP * FP;
 Amax2 = Amax * Amax;
 Amax4 = Amax2 * Amax2;
 a1sqr = a1 * a1;
 a2sqr = a2 * a2;
 a1_4 = a1sqr * a1sqr;
 a2_4 = a2sqr * a2sqr;
 APsqr = AP * AP;
 pT = g * LM * rho;

 fr =
	Amax2*AP*a1sqr + 
    sqrt(Amax4*APsqr*a1_4 - 
      4.0*Amax2*a1sqr*
       (Amax2*a1sqr*KL1 + KV1)*(-BP - AP*FP - pT))/
  (2.0*(Amax2*a1sqr*KL1 + KV1));


 /* printf("fr=%lf\n", fr );	/**/

 return( fr );
}


/* Numerical Recipes 'rbis.c' */
/* Find the root of a function by bisection */


static void nrerror(error_text)
char error_text[];
{
        void exit();
 
        fprintf(stderr,"Numerical Recipes run-time error...\n");
        fprintf(stderr,"%s\n",error_text);
        fprintf(stderr,"...now exiting to system...\n");
        exit(1);
}



/* #define JMAX 40	/**/
#define JMAX 100	/**/

static double rtbis(func,x1,x2,xacc)
double x1,x2,xacc;
double (*func)();	/* ANSI: double (*func)(double); */
{
	int j;
	double dx,f,fmid,xmid,rtb;

	f=(*func)(x1);
	fmid=(*func)(x2);
	/* fprintf(stderr,"\nx1=%lf  x2=%lf  f=%lf  fmid=%lf\n",
			x1, x2, f, fmid );	/**/
	if (f*fmid >= 0.0)
        {
	  nrerror("Root must be bracketed for bisection in RTBIS");
        }
	rtb = f < 0.0 ? (dx=x2-x1,x1) : (dx=x1-x2,x2);
	for (j=1;j<=JMAX;j++) {
		fmid=(*func)(xmid=rtb+(dx *= 0.5));
		if (fmid <= 0.0) rtb=xmid;
		if (fabs(dx) < xacc || fmid == 0.0) return rtb;
	}
	nrerror("Too many bisections in RTBIS"); return INFINITY;
}

#undef JMAX


#define ACCURACY (0.00001)
#define BIG (50.0)

void calc_F_FR_FP( F_new, FR_new, FP_new )
float *F_new, *FR_new, *FP_new;
{
 float F, FP, FR;
 double left, right, offset;

 copy_params();

 /* Calculate FP by bisection */
 offset = 0.1;
 left = pp.FP - offset;
 right = pp.FP + offset;


 left = 0.0; right=2.0*pp.FP;	/**/


 /* fprintf(stderr, "FP= %f  left=%f  right=%f\n", pp.FP, left, right );/**/

 FP = (float)rtbis( fp_root, left, right, ACCURACY );
 FR = (float)calc_FR( (double)FP );
 F = FR + FP;

 /* printf("Pump flow rates: F=%f  FP=%f  FR=%f\n", F, FP, FR ); DBG;	/**/

 *F_new = F; *FR_new = FR; *FP_new = FP;
}
