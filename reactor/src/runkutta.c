#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* NUMERICAL RECIPES IN C: http://nr.harvard.edu/nr		*/
/* Integrate Ordinary differential equation by fourth order Runge-Kutta */
/* Use adaptive stepsize */



static void nrerror(error_text)
char error_text[];
{
        void exit();

        fprintf(stderr,"Numerical Recipes run-time error...\n");
        fprintf(stderr,"%s\n",error_text);
        fprintf(stderr,"...now exiting to system...\n");
        exit(1);
}


static float *vector(nl,nh)
int nl,nh;
{
        float *v;

        v=(float *)malloc((unsigned) (nh-nl+1)*sizeof(float));
        if (!v) nrerror("allocation failure in vector()");
        return v-nl;
}


static void free_vector(v,nl,nh)
float *v;
int nl,nh;
{
        free((char*) (v+nl));
}
 

void rk4(y,dydx,n,x,h,yout,derivs)
float y[],dydx[],x,h,yout[];
void (*derivs)();	/* ANSI: void (*derivs)(float,float *,float *); */
int n;
{
	int i;
	float xh,hh,h6,*dym,*dyt,*yt;

	dym=vector(1,n);
	dyt=vector(1,n);
	yt=vector(1,n);
	hh=h*0.5;
	h6=h/6.0;
	xh=x+hh;
	for (i=1;i<=n;i++) yt[i]=y[i]+hh*dydx[i];
	/* printf("rk4: x=%.2f h=%.2f hh=%.2f  xh=%.2f\n", x, h, hh, xh );
	printf("\tyt[1]=%.2f yt[2]=%.2f dyt[1]=%.2f  dyt[2]=%.2f\n",
		yt[1], yt[2], dyt[1], dyt[2] );	/**/
	(*derivs)(xh,yt,dyt);
	for (i=1;i<=n;i++) yt[i]=y[i]+hh*dyt[i];
	(*derivs)(xh,yt,dym);
	for (i=1;i<=n;i++) {
		yt[i]=y[i]+h*dym[i];
		dym[i] += dyt[i];
	}
	(*derivs)(x+h,yt,dyt);
	for (i=1;i<=n;i++)
		yout[i]=y[i]+h6*(dydx[i]+dyt[i]+2.0*dym[i]);
	free_vector(yt,1,n);
	free_vector(dyt,1,n);
	free_vector(dym,1,n);
}




#define PGROW -0.20
#define PSHRNK -0.25
#define FCOR 0.06666666		/* 1.0/15.0 */
#define SAFETY 0.9
#define ERRCON 6.0e-4

void rkqc(y,dydx,n,x,htry,eps,yscal,hdid,hnext,derivs)
float y[],dydx[],*x,htry,eps,yscal[],*hdid,*hnext;
void (*derivs)();	/* ANSI: void (*derivs)(float,float *,float *); */
int n;
{
	int i;
	float xsav,hh,h,temp,errmax;
	float *dysav,*ysav,*ytemp;
	void rk4(),nrerror();

	dysav=vector(1,n);
	ysav=vector(1,n);
	ytemp=vector(1,n);
	xsav=(*x);
	for (i=1;i<=n;i++) {
		ysav[i]=y[i];
		dysav[i]=dydx[i];
	}
	h=htry;
	for (;;) {
		hh=0.5*h;
		rk4(ysav,dysav,n,xsav,hh,ytemp,derivs);
		*x=xsav+hh;
		(*derivs)(*x,ytemp,dydx);
		rk4(ytemp,dydx,n,*x,hh,y,derivs);
		*x=xsav+h;
		if (*x == xsav) nrerror("Step size too small in routine RKQC");
		rk4(ysav,dysav,n,xsav,h,ytemp,derivs);
		errmax=0.0;
		for (i=1;i<=n;i++) {
			ytemp[i]=y[i]-ytemp[i];
			temp=fabs(ytemp[i]/yscal[i]);
			if (errmax < temp) errmax=temp;
		}
		errmax /= eps;
		if (errmax <= 1.0) {
			*hdid=h;
			*hnext=(errmax > ERRCON ?
				SAFETY*h*exp(PGROW*log(errmax)) : 4.0*h);
			break;
		}
		h=SAFETY*h*exp(PSHRNK*log(errmax));
	}
	for (i=1;i<=n;i++) y[i] += ytemp[i]*FCOR;
	free_vector(ytemp,1,n);
	free_vector(dysav,1,n);
	free_vector(ysav,1,n);
}

#undef PGROW
#undef PSHRNK
#undef FCOR
#undef SAFETY
#undef ERRCON





#define MAXSTP 10000
#define TINY 1.0e-30

int kmax=0,kount=0;  /* defining declaration */
float *xp=0,**yp=0,dxsav=0;  /* defining declaration */

void odeint(ystart,nvar,x1,x2,eps,h1,hmin,nok,nbad,derivs,rkqc)
float ystart[],x1,x2,eps,h1,hmin;
int nvar,*nok,*nbad;
void (*derivs)();	/* ANSI: void (*derivs)(float,float *,float *); */
void (*rkqc)(); 	/* ANSI: void (*rkqc)(float *,float *,int,float *,float,
				float,float *,float *,float *,void (*)()); */
{
	int nstp,i;
	float xsav,x,hnext,hdid,h;
	float *yscal,*y,*dydx;
	void nrerror();

	yscal=vector(1,nvar);
	y=vector(1,nvar);
	dydx=vector(1,nvar);
	x=x1;
	h=(x2 > x1) ? fabs(h1) : -fabs(h1);
	*nok = (*nbad) = kount = 0;
	for (i=1;i<=nvar;i++) y[i]=ystart[i];
	if (kmax > 0) xsav=x-dxsav*2.0;
	for (nstp=1;nstp<=MAXSTP;nstp++) {
		(*derivs)(x,y,dydx);
		for (i=1;i<=nvar;i++)
			yscal[i]=fabs(y[i])+fabs(dydx[i]*h)+TINY;
		if (kmax > 0) {
			if (fabs(x-xsav) > fabs(dxsav)) {
				if (kount < kmax-1) {
					xp[++kount]=x;
					for (i=1;i<=nvar;i++) yp[i][kount]=y[i];
					xsav=x;
				}
			}
		}
		if ((x+h-x2)*(x+h-x1) > 0.0) h=x2-x;
		(*rkqc)(y,dydx,nvar,&x,h,eps,yscal,&hdid,&hnext,derivs);
		if (hdid == h) ++(*nok); else ++(*nbad);
		if ((x-x2)*(x2-x1) >= 0.0) {
			for (i=1;i<=nvar;i++) ystart[i]=y[i];
			if (kmax) {
				xp[++kount]=x;
				for (i=1;i<=nvar;i++) yp[i][kount]=y[i];
			}
			free_vector(dydx,1,nvar);
			free_vector(y,1,nvar);
			free_vector(yscal,1,nvar);
			return;
		}
		if (fabs(hnext) <= hmin) nrerror("Step size too small in ODEINT");
		h=hnext;
	}
	nrerror("Too many steps in routine ODEINT");
}

#undef MAXSTP
#undef TINY
