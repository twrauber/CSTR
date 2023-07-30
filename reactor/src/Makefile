#
#
HOMEDIR = .
#
#############################################################
#
#
BINDIR = $(HOMEDIR)
#
#CC = cc
CC = gcc
#
# Use only one of the next two flags
#OPTIMIZE = -O3
DEBUG = -g
WARN = -Wall -Wno-implicit-function-declaration -Wno-comment
#
CFLAGS = $(OPTIMIZE)  $(DEBUG) $(WARN)
#
#INCPATH = -I/usr/include/bsd
#
LIBS = -lm
#
DEFS = $(MORE_DEF)
#
OBJECTS	= control.o faults.o fcalc.o nextstep.o \
	random.o reactor.o runkutta.o system.o
EXECUTABLE = reactor
#
.c.o:	; $(CC) -c $(DEFS) $(CFLAGS) $(INCPATH) -o $@ $*.c
#
$(EXECUTABLE):	$(OBJECTS)
	$(CC) -o $(BINDIR)/$(EXECUTABLE) $(CFLAGS) $(OBJECTS) $(LIBS)
#
control.o:	def.h control.h
fcalc.o:	def.h system.h
faults.o:	def.h system.h faults.h
nextstep.o:	def.h system.h
random.o:
reactor.o:	def.h system.h
runkutta.o:
system.o:	def.h control.h system.h faults.h
#
clean :
	rm -f *.o *.ln ../out/* core $(EXECUTABLE)
