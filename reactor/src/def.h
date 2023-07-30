
#define MAX(a,b)               (a<b ? b : a)
#define MIN(a,b)               (a>b ? b : a)

#define ON 1
#define OFF 0

#define TRUE 1
#define FALSE 0
typedef int boolean;

#define EMPTY (-1)

/* open, closed intervals */
#define LEFT_CLOSED__RIGHT_CLOSED 0
#define LEFT_CLOSED__RIGHT_OPEN 1
#define LEFT_OPEN__RIGHT_CLOSED 2
#define LEFT_OPEN__RIGHT_OPEN 3

#ifdef NON_UNIX
#define f_open_bin_w "wb"
#define f_open_bin_r "rb"
#define f_open_text_w "w"
#define f_open_text_r "r"
#else
#define f_open_bin_w "w"
#define f_open_bin_r "r"
#define f_open_text_w "w"
#define f_open_text_r "r"
#endif

/* Special marker to be filtered out by 'grep' */
#define GREP printf("### ")
#define GREP0


#define STRLEN 200
typedef char str[STRLEN+1];

#define WAIT  {char _str[STRLEN+1];fprintf(stderr,"...");\
        if(fgets(_str,STRLEN,stdin)==NULL) {EXIT("Problems with 'fgets'")};}
#define NL  printf("\n")

#define EXIT(msgStr) {fprintf(stderr,"\n%s\nExitus...\n",msgStr);exit(1);}
#define BLANK_LINE \
        {int i;printf("\r");for(i=0;i<80;i++)printf(" ");printf("\r");}

#define FREE(ptr) if(ptr!=NULL){free(ptr);ptr=NULL;}
#define CHKPTR(ptr) if(ptr==NULL){fprintf(stderr,"\n\nAllocation problem with \
'ptr' - exitus...\n");exit(1);}


typedef char str20[21];
typedef char str30[31];
typedef char str50[51];
typedef char str80[81];
typedef char str100[101];
typedef char str200[201];
typedef int bool;
typedef unsigned char byte;

#ifndef INFINITY
#define INFINITY (1000000000000.0)
#endif

